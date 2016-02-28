package au.org.sports.wrugby.scoreboard;

public class Image {
    private byte[] image;
    private String contentType;

    public Image(byte[] image, String contentType) {
        this.image = image;
        this.contentType = contentType;
    }

    public byte[] getImage() {
        return image;
    }

    public String getContentType() {
        return contentType;
    }
}
