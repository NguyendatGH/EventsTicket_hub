package models;

import java.math.BigDecimal;

public class TicketType {
    String name;
    BigDecimal price;
    int quantity;

    public TicketType(String name, BigDecimal price, int quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }
    public String getName(){
        return this.name;
    }

    @Override
    public String toString() {
        return this.name + this.quantity + this.price;
    }
}