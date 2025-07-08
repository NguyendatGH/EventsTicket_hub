package service;

import dao.EventDAO;
import dto.UserDTO;
import models.Event;
import utils.ToggleEvent;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public class EventService {
    private final EventDAO eventDAO;

    public EventService() {
        this.eventDAO = new EventDAO();
    }

    public BigDecimal getTotalRevenue() {
        return eventDAO.getTotalRevenueOfAllEvent();
    }

    public List<Event> getAllApprovedEvents() {
        List<Event> events = eventDAO.getAllApprovedEvents();
        return events;
    }

    public List<Event> getActiveEvents() {
        List<Event> events = eventDAO.getActiveEvents();
        return events;
    }

    public List<Event> getNonActiveEvents() {
        List<Event> events = eventDAO.getNonActiveEvents();
        return events;
    }

    public Event getEventById(int eventId) {
        Event event = eventDAO.getEventById(eventId);
        if (event != null) {
            return event;
        }
        return null;
    }

    public int getAllEventCreatedThisMonthNums() {
        return eventDAO.getAllEventCreatedThisMonthNums();
    }

    public List<Event> getListTopEvents() {
        List<Event> events = eventDAO.getListTopEvents();
        return events;
    }

    public List<Event> getPendingEvents() {
        List<Event> events = eventDAO.getPendingEvents();
        return events;
    }

    public List<Event> getSuggestedEvents(int currentEventId) {
        List<Event> events = eventDAO.getSuggestedEvents(currentEventId);
        return events;
    }

    public ToggleEvent deleteEvent(int eventId) {
        return eventDAO.deleteEvent(eventId);
    }

    public ToggleEvent updateEvent(Event e) {
        return eventDAO.updateEvent(e);
    }

    public Map<String, Integer> getEventByStatus() {
        return eventDAO.getEventByStatus();
    }

    public Map<String, Integer> getEventStatsByGenre() {
        return eventDAO.getEventStatsByGenre();
    }

    public List<Map<String, Object>> getMonthlyEventStats() {
        return eventDAO.getMonthlyEventStats();
    }

    public UserDTO getEventOwnerId(int ownerId) {
        return eventDAO.getEventOwnerId(ownerId);
    }

}