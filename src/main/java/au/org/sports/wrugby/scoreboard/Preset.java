package au.org.sports.wrugby.scoreboard;

public class Preset {

    private String quarterLength;

    private String shotClockLength;

    private String displayShotClock;

    private String playerTimeouts;

    private String coachTimeouts;

    public Preset(String quarterLength, String shotClockLength, String displayShotClock, String playerTimeouts, String coachTimeouts) {
        this.quarterLength = quarterLength;
        this.shotClockLength = shotClockLength;
        this.displayShotClock = displayShotClock;
        this.playerTimeouts = playerTimeouts;
        this.coachTimeouts = coachTimeouts;
    }

    public String getQuarterLength() {
        return quarterLength;
    }

    public void setQuarterLength(String quarterLength) {
        this.quarterLength = quarterLength;
    }

    public String getShotClockLength() {
        return shotClockLength;
    }

    public void setShotClockLength(String shotClockLength) {
        this.shotClockLength = shotClockLength;
    }

    public String getDisplayShotClock() {
        return displayShotClock;
    }

    public void setDisplayShotClock(String displayShotClock) {
        this.displayShotClock = displayShotClock;
    }

    public String getPlayerTimeouts() {
        return playerTimeouts;
    }

    public void setPlayerTimeouts(String playerTimeouts) {
        this.playerTimeouts = playerTimeouts;
    }

    public String getCoachTimeouts() {
        return coachTimeouts;
    }

    public void setCoachTimeouts(String coachTimeouts) {
        this.coachTimeouts = coachTimeouts;
    }
}
