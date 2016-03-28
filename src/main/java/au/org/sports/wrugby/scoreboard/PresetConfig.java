package au.org.sports.wrugby.scoreboard;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class PresetConfig {

    @Value("${au.org.sports.wrugby.scoreboard.preset1.name}")
    private String preset1Name;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.quarter-length}")
    private String preset1QuarterLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.shotclock-length}")
    private String preset1ShotClockLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.display-shotclock}")
    private String preset1DisplayShotClock;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.player-timeouts}")
    private String preset1PlayerTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset1.coach-timeouts}")
    private String preset1CoachTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.name}")
    private String preset2Name;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.quarter-length}")
    private String preset2QuarterLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.shotclock-length}")
    private String preset2ShotClockLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.display-shotclock}")
    private String preset2DisplayShotClock;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.player-timeouts}")
    private String preset2PlayerTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset2.coach-timeouts}")
    private String preset2CoachTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.name}")
    private String preset3Name;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.quarter-length}")
    private String preset3QuarterLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.shotclock-length}")
    private String preset3ShotClockLength;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.display-shotclock}")
    private String preset3DisplayShotClock;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.player-timeouts}")
    private String preset3PlayerTimeouts;

    @Value("${au.org.sports.wrugby.scoreboard.preset3.coach-timeouts}")
    private String preset3CoachTimeouts;

    public PresetConfig() {
    }

    @Bean(name = "preset1")
    public Preset preset1() {
        return new Preset(preset1QuarterLength, preset1ShotClockLength, preset1DisplayShotClock,
                preset1PlayerTimeouts, preset1CoachTimeouts, preset1Name);
    }

    @Bean(name = "preset2")
    public Preset preset2() {
        return new Preset(preset2QuarterLength, preset2ShotClockLength, preset2DisplayShotClock,
                preset2PlayerTimeouts, preset2CoachTimeouts, preset2Name);
    }

    @Bean(name = "preset3")
    public Preset preset3() {
        return new Preset(preset3QuarterLength, preset3ShotClockLength, preset3DisplayShotClock,
                preset3PlayerTimeouts, preset3CoachTimeouts, preset3Name);
    }
}
