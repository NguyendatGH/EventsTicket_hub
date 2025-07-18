package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import models.Order;
import models.OrderItem;
import utils.ConfigLoader;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
@WebServlet(name = "PayOSPaymentServlet", urlPatterns = {"/PayOSPaymentServlet"})
public class PayOSPaymentServlet extends HttpServlet {

    private static final String CLIENT_ID = ConfigLoader.get("client.id");
    private static final String API_KEY = ConfigLoader.get("api.key");
    private static final String CHECKSUM_KEY = ConfigLoader.get("checksum.key");

    private PayOS payOS;

    @Override
    public void init() throws ServletException {
        super.init();
        this.payOS = new PayOS(CLIENT_ID, API_KEY, CHECKSUM_KEY);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Order currentOrder = (session != null) ? (Order) session.getAttribute("currentOrder") : null;

        if (currentOrder == null) {
            forwardToErrorPage(request, response, "Phiên làm việc đã hết hạn hoặc không có đơn hàng.");
            return;
        }

        try {
            int amount = currentOrder.getTotalAmount().intValue();
            Long orderCode = System.currentTimeMillis();
            String description = "MDT " + orderCode;
            String appBaseUrl = request.getScheme() + "://" + request.getServerName()
                    + (request.getServerPort() == 80 || request.getServerPort() == 443 ? ""
                    : ":" + request.getServerPort())
                    + request.getContextPath();

            List<ItemData> payosItems = new ArrayList<>();
            for (OrderItem orderItem : currentOrder.getItems()) {
                payosItems.add(ItemData.builder()
                        .name(orderItem.getTicketTypeName())
                        .quantity(orderItem.getQuantity())
                        // SỬA LỖI: Dùng .intValue() để chuyển từ BigDecimal sang int
                        .price(orderItem.getUnitPrice().intValue())
                        .build());
            }

            PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCode)
                    .amount(amount)
                    .description(description)
                    .returnUrl(appBaseUrl + "/PayOSReturnServlet")
                    .cancelUrl(appBaseUrl + "/PayOSReturnServlet")
                    .items(payosItems)
                    .build();

            CheckoutResponseData result = this.payOS.createPaymentLink(paymentData);
            response.sendRedirect(result.getCheckoutUrl());

        } catch (Exception e) {
            e.printStackTrace();
            forwardToErrorPage(request, response, "Lỗi khi tạo yêu cầu thanh toán: " + e.getMessage());
        }
    }

    private void forwardToErrorPage(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("status", "error");
        request.setAttribute("message", message);
        request.getRequestDispatcher("/pages/PaymentResult.jsp").forward(request, response);
    }
}
