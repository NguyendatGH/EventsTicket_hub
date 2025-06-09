
package models;




public class Ticket {

    private int ticketInfoID;
    private String ticketCode;
    private String status;
    private Integer seatID; // Có thể null

    public Ticket() {
    }

    public Ticket(int ticketInfoID, String ticketCode, String status, Integer seatID) {
        this.ticketInfoID = ticketInfoID;
        this.ticketCode = ticketCode;
        this.status = status;
        this.seatID = seatID;
    }

    public int getTicketInfoID() {
        return ticketInfoID;
    }

    public void setTicketInfoID(int ticketInfoID) {
        this.ticketInfoID = ticketInfoID;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getSeatID() {
        return seatID;
    }

    public void setSeatID(Integer seatID) {
        this.seatID = seatID;
    }

    @Override
    public String toString() {
        return "Ticket{"
                + "ticketInfoID=" + ticketInfoID
                + ", ticketCode='" + ticketCode + '\''
                + ", status='" + status + '\''
                + ", seatID=" + seatID
                + '}';
    }
}
