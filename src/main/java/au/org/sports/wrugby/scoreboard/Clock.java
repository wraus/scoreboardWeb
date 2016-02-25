package au.org.sports.wrugby.scoreboard;

public class Clock {

    private Integer mins = 8;
    private Integer secs = 40;
    private Integer tenths = 0;

    public Clock() {

    }

    public Integer getMins() {
        return mins;
    }

    public void setMins(Integer mins) {
        this.mins = mins;
    }

    public Integer getSecs() {
        return secs;
    }

    public void setSecs(Integer secs) {
        this.secs = secs;
    }

    public Integer getTenths() {
        return tenths;
    }

    public void setTenths(Integer tenths) {
        this.tenths = tenths;
    }
}
