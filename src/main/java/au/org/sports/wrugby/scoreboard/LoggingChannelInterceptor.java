package au.org.sports.wrugby.scoreboard;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.xml.XmlMapper;
import org.apache.commons.io.FileUtils;
import org.codehaus.jackson.map.SerializationConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptorAdapter;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;

import static org.springframework.messaging.simp.SimpMessageType.*;

@Component("loggingChannelInterceptor")
public class LoggingChannelInterceptor extends ChannelInterceptorAdapter implements InitializingBean {
    private static final Logger LOGGER = LoggerFactory.getLogger(LoggingChannelInterceptor.class);
    public static final DateFormat ISO_8601_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", Locale.getDefault());

    @Value("${au.org.sports.wrugby.scoreboard.logFile}")
    public String fileName;

    private File file;

    @Override
    public void afterPropertiesSet() throws Exception {
        file = new File(fileName);
    }

    @Override
    public void afterSendCompletion(Message<?> message, MessageChannel channel, boolean sent, Exception ex) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        if (accessor.getCommand().getMessageType() == MESSAGE) {
            String scoreJSON = new String ((byte[]) message.getPayload());
            try {
                ObjectMapper jsonMapper = new ObjectMapper();
                Scoreboard score = jsonMapper.readValue(scoreJSON, Scoreboard.class);
                XmlMapper xmlMapper = new XmlMapper();
                xmlMapper.configure(SerializationConfig.Feature.WRITE_DATES_AS_TIMESTAMPS, false);
                xmlMapper.setDateFormat(ISO_8601_DATE_FORMAT);
                FileUtils.writeStringToFile(file, xmlMapper.writeValueAsString(score) + "\n", true);
            } catch (IOException e) {
                // As this is an interceptor, we don't want the exception to propogate
                LOGGER.error("Unable to write score to file", e);
            }
        }
    }
}
