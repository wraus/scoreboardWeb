package au.org.sports.wrugby.scoreboard;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

@RestController
@Controller
public class ScorerController {
    @Value("${au.org.sports.wrugby.scoreboard.logFile}")
    public String fileName;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.quarter-length}")
    public String preset1QuarterLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.quarter-length}")
    public String preset2QuarterLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.quarter-length}")
    public String preset3QuarterLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.shotclock-length}")
    public String preset1ShotClockLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.shotclock-length}")
    public String preset2ShotClockLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.shotclock-length}")
    public String preset3ShotClockLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.display-shotclock}")
    public String preset1DisplayShotClock;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.display-shotclock}")
    public String preset2DisplayShotClock;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.display-shotclock}")
    public String preset3DisplayShotClock;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.player-timeouts}")
    public String preset1PlayerTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.player-timeouts}")
    public String preset2PlayerTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.player-timeouts}")
    public String preset3PlayerTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.coach-timeouts}")
    public String preset1CoachTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.coach-timeouts}")
    public String preset2CoachTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.coach-timeouts}")
    public String preset3CoachTimeouts;

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
        ModelAndView mav = new ModelAndView("scorer");
        mav.addObject("preset1QuarterLength", preset1QuarterLength);
        mav.addObject("preset2QuarterLength", preset2QuarterLength);
        mav.addObject("preset3QuarterLength", preset3QuarterLength);
        mav.addObject("preset1ShotClockLength", preset1ShotClockLength);
        mav.addObject("preset2ShotClockLength", preset2ShotClockLength);
        mav.addObject("preset3ShotClockLength", preset3ShotClockLength);
        mav.addObject("preset1DisplayShotClock", preset1DisplayShotClock);
        mav.addObject("preset2DisplayShotClock", preset2DisplayShotClock);
        mav.addObject("preset3DisplayShotClock", preset3DisplayShotClock);
        mav.addObject("preset1PlayerTimeouts", preset1PlayerTimeouts);
        mav.addObject("preset2PlayerTimeouts", preset2PlayerTimeouts);
        mav.addObject("preset3PlayerTimeouts", preset3PlayerTimeouts);
        mav.addObject("preset1CoachTimeouts", preset1CoachTimeouts);
        mav.addObject("preset2CoachTimeouts", preset2CoachTimeouts);
        mav.addObject("preset3CoachTimeouts", preset3CoachTimeouts);

        return mav;
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
        return new ResponseEntity<>(image.getImage(), headers, HttpStatus.CREATED);
    }

    @RequestMapping(method = RequestMethod.POST, value = "/scorer/image")
    public void handleFileUpload(
            @RequestParam("key") String key,
            @RequestParam("logo") MultipartFile file,
            RedirectAttributes redirectAttributes) {
        if (!file.isEmpty()) {
            try {
                Image image = new Image(file.getBytes(), file.getContentType());
                context.setAttribute(key, image);
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

    @RequestMapping(value = "/scorer/log", method = RequestMethod.GET)
    public ResponseEntity<byte[]> downloadLog() {
        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("text/xml"));
        try {
            byte[] outerTagOpen = "<scores>".getBytes();
            File file = new File(fileName);
            byte[] fileContent;
            if (file.exists()) {
                fileContent = FileUtils.readFileToByteArray(file);
            } else {
                fileContent = new byte[]{};
            }
            byte[] outerTagClose = "</scores>".getBytes();
            byte[] joinedArray = new byte[outerTagOpen.length + fileContent.length + outerTagClose.length];
            System.arraycopy(outerTagOpen, 0, joinedArray, 0, outerTagOpen.length);
            System.arraycopy(fileContent, 0, joinedArray, outerTagOpen.length, fileContent.length);
            System.arraycopy(outerTagClose, 0, joinedArray, outerTagOpen.length + fileContent.length, outerTagClose.length);
            return new ResponseEntity<>(joinedArray, headers, HttpStatus.CREATED);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @RequestMapping(value = "/scorer/log", method = RequestMethod.DELETE)
    public void deleteLog() {
        FileUtils.deleteQuietly(new File(fileName));
    }
}
