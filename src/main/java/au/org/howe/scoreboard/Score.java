package au.org.howe.scoreboard;

public class Score {
    private Integer wickets = 0;
    private Integer runs = 0;
    private Integer overs = 0;
    private Integer balls = 0;
    private Integer wideNBThisOver = 0;
    private Integer extras = 0;
    private Integer target = 0;

    public Score() {

    }

    public Integer getWickets() {
        return wickets;
    }

    public void setWickets(Integer wickets) {
        this.wickets = wickets;
    }

    public long getRuns() {
        return runs;
    }

    public void setRuns(Integer runs) {
        this.runs = runs;
    }

    public Integer getOvers() {
        return overs;
    }

    public void setOvers(Integer overs) {
        this.overs = overs;
    }

    public Integer getBalls() {
        return balls;
    }

    public void setBalls(Integer balls) {
        this.balls = balls;
    }

    public Integer getWideNBThisOver() {
        return wideNBThisOver;
    }

    public void setWideNBThisOver(Integer wideNBThisOver) {
        this.wideNBThisOver = wideNBThisOver;
    }

    public Integer getExtras() {
        return extras;
    }

    public void setExtras(Integer extras) {
        this.extras = extras;
    }

    public Integer getTarget() {
        return target;
    }

    public void setTarget(Integer target) {
        this.target = target;
    }

    public String getOversAndBalls() {
        return overs + "." + balls;
    }
}
