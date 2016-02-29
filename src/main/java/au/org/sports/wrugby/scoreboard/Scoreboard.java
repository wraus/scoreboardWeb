package au.org.sports.wrugby.scoreboard;

import java.util.Date;

public class Scoreboard {

    private String command;
    private String action;
    private Date actionTime;
    private Team team1;
    private Team team2;
    private Clock gameClock;
    private Clock shotClock;
    private Integer period = 1;
    private String direction;

    public Scoreboard() {

    }

    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Date getActionTime() {
        return actionTime;
    }

    public void setActionTime(Date actionTime) {
        this.actionTime = actionTime;
    }

    public Team getTeam1() {
        return team1;
    }

    public void setTeam1(Team team1) {
        this.team1 = team1;
    }

    public Team getTeam2() {
        return team2;
    }

    public void setTeam2(Team team2) {
        this.team2 = team2;
    }

    public Clock getGameClock() {
        return gameClock;
    }

    public void setGameClock(Clock gameClock) {
        this.gameClock = gameClock;
    }

    public Clock getShotClock() {
        return shotClock;
    }

    public void setShotClock(Clock shotClock) {
        this.shotClock = shotClock;
    }

    public Integer getPeriod() {
        return period;
    }

    public void setPeriod(Integer period) {
        this.period = period;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }
}