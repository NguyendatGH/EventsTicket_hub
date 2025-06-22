package utils;

public class ToggleEvent {
    private final boolean success;
    private final String message;

    public ToggleEvent(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getMessage() {
        return message;
    }
}
