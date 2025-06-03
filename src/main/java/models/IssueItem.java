package models;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class IssueItem {

    private String clientEmail;
    private String issueTitle;
    private LocalDateTime dateTime;

    public IssueItem(String clientEmail, String issueTitle, LocalDateTime dateTime) throws ParseException {
        this.clientEmail = clientEmail;
        this.issueTitle = issueTitle;
        this.dateTime = dateTime;
    }

    public String getClientEmail() {
        return clientEmail;
    }

    public String getIssueTitle() {
        return issueTitle;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public void setClientEmail(String clientEmail) {
        this.clientEmail = clientEmail;
    }

    public void setIssueTitle(String issueTitle) {
        this.issueTitle = issueTitle;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    @Override
    public String toString() {
        return "IssueItem{" + "clientEmail=" + clientEmail + ", issueTitle=" + issueTitle + ", sendDate=" + dateTime + '}';
    }

}
