package utils;

import java.util.Map;

public class ToggleEvent {
    private final boolean success;
    private final String message;
    private int eventId;
    private Map<String, Integer> ticketInfoIdMap;

    public ToggleEvent(boolean success, String message) {
        this.success = success;
        this.message = message;
        this.eventId = 0;
        this.ticketInfoIdMap = null;
    }

    public ToggleEvent(boolean success, String message, int eventId) {
        this.success = success;
        this.message = message;
        this.eventId = eventId;
        this.ticketInfoIdMap = null;
    }

    public ToggleEvent(boolean success, String message, int eventId, Map<String, Integer> ticketInfoIdMap) {
        this.success = success;
        this.message = message;
        this.eventId = eventId;
        this.ticketInfoIdMap = ticketInfoIdMap;
    }

    public int getEventId() {
        return this.eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public Map<String, Integer> getTicketInfoIdMap() {
        return this.ticketInfoIdMap;
    }

    public void setTicketInfoIdMap(Map<String, Integer> ticketInfoIdMap) {
        this.ticketInfoIdMap = ticketInfoIdMap;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getMessage() {
        return message;
    }
}