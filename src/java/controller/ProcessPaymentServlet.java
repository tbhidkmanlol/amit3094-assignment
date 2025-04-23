package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.User;
import dao.OrderDAO;
import dao.ProductDAO;

@WebServlet("/ProcessPaymentServlet")
public class ProcessPaymentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 获取会话
        HttpSession session = request.getSession();
        
        // 获取购物车商品
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        // 获取用户信息
        User user = (User) session.getAttribute("user");
        int customerId = (user != null) ? user.getId() : 0;
        
        // 获取表单参数
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postal = request.getParameter("postal");
        String country = request.getParameter("country");
        
        // 获取支付细节
        String paymentMethod = request.getParameter("method");
        String cardType = request.getParameter("cardType");
        String cardName = request.getParameter("cardName");
        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        String walletType = request.getParameter("walletType");
        
        // 获取财务值
        double merchandiseSubtotal = Double.parseDouble(request.getParameter("merchandiseSubtotal"));
        double shippingSubtotal = Double.parseDouble(request.getParameter("shippingSubtotal"));
        double shippingSST = Double.parseDouble(request.getParameter("shippingSST"));
        double deliveryFee = Double.parseDouble(request.getParameter("deliveryFee"));
        double totalPayment = Double.parseDouble(request.getParameter("totalPayment"));
        
        // 生成交易/订单号
        String orderNumber = generateOrderNumber();
        
        // 生成当前日期和预计送达日期（7天后）
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
        Date currentDate = new Date();
        String orderDate = dateFormat.format(currentDate);
        
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        calendar.add(Calendar.DATE, 7); // 添加7天
        String estimatedDeliveryDate = dateFormat.format(calendar.getTime());
        
        // 如果是信用卡/借记卡支付，则掩盖卡号
        if ("creditCard".equals(paymentMethod) || "debitCard".equals(paymentMethod)) {
            if (cardNumber != null && cardNumber.length() >= 16) {
                // 只保留最后4位数字可见，其余掩盖
                cardNumber = "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
            }
        }
        
        // 为确认页面设置所有属性
        request.setAttribute("orderNumber", orderNumber);
        request.setAttribute("orderDate", orderDate);
        request.setAttribute("estimatedDeliveryDate", estimatedDeliveryDate);
        
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("address", address);
        request.setAttribute("district", city);
        request.setAttribute("state", state);
        request.setAttribute("postal", postal);
        request.setAttribute("country", country);
        
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("cardType", cardType);
        request.setAttribute("cardName", cardName);
        request.setAttribute("cardNumber", cardNumber);
        request.setAttribute("walletType", walletType);
        
        request.setAttribute("merchandiseSubtotal", String.format("%.2f", merchandiseSubtotal));
        request.setAttribute("shippingSubtotal", String.format("%.2f", shippingSubtotal));
        request.setAttribute("shippingSST", String.format("%.2f", shippingSST));
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("totalPayment", String.format("%.2f", totalPayment));
        
        // 传递购物车商品以在确认页面显示
        request.setAttribute("confirmedCart", cart);
        
        // 创建订单对象
        Order order = new Order();
        order.setOrderNumber(orderNumber);
        order.setCustomerId(customerId);
        order.setTotalAmount(totalPayment);
        order.setShippingFee(deliveryFee);
        order.setTaxAmount(shippingSST);
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("PAID");
        order.setShippingStatus("PROCESSING");
        
        // 组合地址信息
        String fullAddress = address + ", " + city + ", " + state + ", " + postal;
        order.setBillingAddress(fullAddress);
        order.setShippingAddress(fullAddress);
        order.setCustomerEmail(email);
        
        // 添加订单商品
        if (cart != null) {
            for (CartItem cartItem : cart) {
                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(cartItem.getProduct().getId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPricePerUnit(cartItem.getProduct().getPrice());
                order.addOrderItem(orderItem);
            }
        }
        
        // 保存订单到数据库
        int orderId = OrderDAO.createOrder(order);
        
        if (orderId > 0) {
            // 订单创建成功，清除购物车
            session.removeAttribute("cart");
            
            // 转发到确认页面
            request.getRequestDispatcher("confirmation.jsp").forward(request, response);
        } else {
            // 订单创建失败
            request.setAttribute("errorMessage", "支付处理失败，请重试。");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        }
    }
    
    // 生成唯一订单号的辅助方法
    private String generateOrderNumber() {
        long timestamp = System.currentTimeMillis();
        Random random = new Random();
        int randomDigits = random.nextInt(10000); // 随机4位数字
        return "TX" + timestamp + String.format("%04d", randomDigits);
    }
}