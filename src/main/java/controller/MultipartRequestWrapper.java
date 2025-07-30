package controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.*;

public class MultipartRequestWrapper extends HttpServletRequestWrapper {
  private final Map<String, String[]> parameters = new HashMap<>();

    public MultipartRequestWrapper(HttpServletRequest request) throws Exception {
        super(request);
        
        try {
            // Đọc các part và trích xuất tham số
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (part.getContentType() == null) { // Là form field thông thường
                    String name = part.getName();
                    String value = new String(part.getInputStream().readAllBytes(), "UTF-8");
                    parameters.put(name, new String[]{value});
                }
            }
        } catch (Exception e) {
            throw new Exception("Error processing multipart request", e);
        }
        
        // Sao chép các tham số có sẵn
        parameters.putAll(request.getParameterMap());
    }
    @Override
    public String getParameter(String name) {
        String[] values = parameters.get(name);
        return values != null && values.length > 0 ? values[0] : null;
    }

    @Override
    public Map<String, String[]> getParameterMap() {
        return Collections.unmodifiableMap(parameters);
    }

    @Override
    public String[] getParameterValues(String name) {
        return parameters.get(name);
    }
}