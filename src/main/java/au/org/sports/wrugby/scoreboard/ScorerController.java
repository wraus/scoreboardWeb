package au.org.sports.wrugby.scoreboard;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;

@RestController
@Controller
public class ScorerController {

    private SimpMessagingTemplate template;

    @Autowired
    private ServletContext context;

    @Autowired
    public ScorerController(SimpMessagingTemplate template) {
        this.template = template;
        template.setMessageConverter(new MappingJackson2MessageConverter());
    }

    @RequestMapping(value = "/scorer", method = RequestMethod.GET)
    public ModelAndView scorerHTML() {
        return new ModelAndView("scorer");
    }

    @RequestMapping(value = "/scorer/image", method = RequestMethod.GET)
    public ResponseEntity<byte[]> serveTeamLogo(
            @RequestParam("key") String key,
            @RequestParam(value = "default", required = false) String defaultURL) throws Exception {
        Image image = (Image) context.getAttribute(key);
        if (image == null) {
            if (defaultURL != null) {
                String imageType = defaultURL.substring(defaultURL.indexOf(".") + 1);
                image = new Image(IOUtils.toByteArray(context.getResourceAsStream(defaultURL)), "image/" + imageType);
            } else {
                image = new Image(IOUtils.toByteArray(context.getResourceAsStream("/images/blank.gif")), "image/gif");
            }
        }
        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType(image.getContentType()));
        return new ResponseEntity<byte[]>(image.getImage(), headers, HttpStatus.CREATED);
    }

    @RequestMapping(method = RequestMethod.POST, value = "/scorer/image")
    public void handleFileUpload(
            @RequestParam("key") String key,
            @RequestParam("logo") MultipartFile file,
                                   RedirectAttributes redirectAttributes) {
        if (!file.isEmpty()) {
            try {
                Image image = new Image(file.getBytes(), file.getContentType());
                context.setAttribute(key , image);
                redirectAttributes.addFlashAttribute("message",
                        "You successfully uploaded ");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("message",
                        "You failed to upload " + e.getMessage());
            }
        } else {
            redirectAttributes.addFlashAttribute("message",
                    "You failed to upload because the file was empty");
        }
    }
}
