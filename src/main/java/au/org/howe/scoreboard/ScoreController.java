package au.org.howe.scoreboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

@RestController
@Controller
public class ScoreController {
    private SimpMessagingTemplate template;

    @Autowired
    public ScoreController(SimpMessagingTemplate template) {
        this.template = template;
        template.setMessageConverter(new MappingJackson2MessageConverter());
    }

    private static Score currentScore = new Score();

    @RequestMapping(value = "/score", method = RequestMethod.GET, produces = {"application/json"})
    @ResponseStatus(HttpStatus.OK)
    public Score score() {
        return currentScore;
    }

    @RequestMapping(value = "score", method = RequestMethod.GET)
    public ModelAndView scoreHTML(Map<String, Object> model) {
        model.put("score", currentScore);
        return new ModelAndView("/score", model);
    }

    @RequestMapping(value = "score", method = RequestMethod.POST)
    public @ResponseBody Score updateScore(@RequestBody Score score) {
        this.currentScore = score;
        this.template.convertAndSend("/topic/score", score);
        return currentScore;
    }

    @MessageMapping("/scoreTopic")
    @SendTo("/topic/score")
    public Score scoreMessage(Score score) {
        return score;
    }
}
