package au.org.howe.scoreboard;

public class Tweet {
    private String text;

    public Tweet() {

    }

    public Tweet(String text) {
        this.text = text;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}
