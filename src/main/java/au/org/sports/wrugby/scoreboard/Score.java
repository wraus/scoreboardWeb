package au.org.sports.wrugby.scoreboard;

public class Score {

    private Integer team1Score = 0;
    private Integer team2Score = 0;

    private String team1Name;
    private String team2Name;

    private Integer gameClockMins = 0;
    private Integer gameClockSecs = 0;
    private Integer gameClockTenthSecs = 0;

    private Integer shotClockSecs = 0;
    private Integer shotClockTenthSecs = 0;

    private Integer period = 1;
    private String possession;

    public Score() {

    }

    public Integer getTeam1Score() {
        return team1Score;
    }

    public void setTeam1Score(Integer team1Score) {
        this.team1Score = team1Score;
    }

    public Integer getTeam2Score() {
        return team2Score;
    }

    public void setTeam2Score(Integer team2Score) {
        this.team2Score = team2Score;
    }

    public String getTeam1Name() {
        return team1Name;
    }

    public void setTeam1Name(String team1Name) {
        this.team1Name = team1Name;
    }

    public String getTeam2Name() {
        return team2Name;
    }

    public void setTeam2Name(String team2Name) {
        this.team2Name = team2Name;
    }

    public Integer getGameClockMins() {
        return gameClockMins;
    }

    public void setGameClockMins(Integer gameClockMins) {
        this.gameClockMins = gameClockMins;
    }

    public Integer getGameClockSecs() {
        return gameClockSecs;
    }

    public void setGameClockSecs(Integer gameClockSecs) {
        this.gameClockSecs = gameClockSecs;
    }

    public Integer getGameClockTenthSecs() {
        return gameClockTenthSecs;
    }

    public void setGameClockTenthSecs(Integer gameClockTenthSecs) {
        this.gameClockTenthSecs = gameClockTenthSecs;
    }

    public Integer getShotClockSecs() {
        return shotClockSecs;
    }

    public void setShotClockSecs(Integer shotClockSecs) {
        this.shotClockSecs = shotClockSecs;
    }

    public Integer getShotClockTenthSecs() {
        return shotClockTenthSecs;
    }

    public void setShotClockTenthSecs(Integer shotClockTenthSecs) {
        this.shotClockTenthSecs = shotClockTenthSecs;
    }

    public Integer getPeriod() {
        return period;
    }

    public void setPeriod(Integer period) {
        this.period = period;
    }

    public String getPossession() {
        return possession;
    }

    public void setPossession(String possession) {
        this.possession = possession;
    }

}