package au.org.sports.wrugby.scoreboard;

public class Team {

    private Integer score = 0;
    private Integer coachTimeouts = 0;
    private Integer teamTimeouts = 0;
    private String name;
    private String colour;

    public Team(){
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getCoachTimeouts() {
        return coachTimeouts;
    }

    public void setCoachTimeouts(Integer coachTimeouts) {
        this.coachTimeouts = coachTimeouts;
    }

    public Integer getTeamTimeouts() {
        return teamTimeouts;
    }

    public void setTeamTimeouts(Integer teamTimeouts) {
        this.teamTimeouts = teamTimeouts;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColour() {
        return colour;
    }

    public void setColour(String colour) {
        this.colour = colour;
    }
}
