package au.org.sports.wrugby.scoreboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

@RestController
@Controller
public class ScoreboardController {

    private static Scoreboard currentScoreboard = new Scoreboard();
    private SimpMessagingTemplate template;

    @Autowired
    public ScoreboardController(SimpMessagingTemplate template) {
        this.template = template;
        template.setMessageConverter(new MappingJackson2MessageConverter());
    }

    @RequestMapping(value = "/scoreboard", method = RequestMethod.GET, produces = {"application/json"})
    @ResponseStatus(HttpStatus.OK)
    public Scoreboard score() {
        return currentScoreboard;
    }

    @RequestMapping(value = "scoreboard", method = RequestMethod.GET)
    public ModelAndView scoreHTML(Map<String, Object> model) {
        model.put("score", currentScoreboard);
        return new ModelAndView("/scoreboard", model);
    }

    @RequestMapping(value = "score", method = RequestMethod.POST)
    public
    @ResponseBody
    Scoreboard updateScore(@RequestBody Scoreboard scoreboard) {
        System.out.println("Score was submitted...");
        this.currentScoreboard = scoreboard;
        this.template.convertAndSend("/topic/score", scoreboard);
        return currentScoreboard;
    }

   /* @MessageMapping("/tweet")
    @SendTo("/topic/tweet")
    public Tweet scoreMessage(Tweet tweet) {
        String tweetString =currentScore.getOversAndBalls() + " " + tweet.getText();
        tweets.add(0, tweetString);
        //TODO Truncate the list
        return new Tweet(tweetString);
    }*/
}
