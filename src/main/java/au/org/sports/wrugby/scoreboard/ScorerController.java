package au.org.sports.wrugby.scoreboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@Controller
public class ScorerController {

    private static Score currentScore = new Score();

    private SimpMessagingTemplate template;

    @Autowired
    public ScorerController(SimpMessagingTemplate template) {
        this.template = template;
        template.setMessageConverter(new MappingJackson2MessageConverter());
    }

    @RequestMapping(value = "/scorer", method = RequestMethod.GET)
    public ModelAndView scorerHTML() {
        return new ModelAndView("scorer");
    }
}
