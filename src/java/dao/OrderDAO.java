package dao;

import model.Order;
import model.OrderItem;
import model.DBConnection;
import model.Product;
import model.SalesReport;
import model.TopProduct;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Calendar;

public class OrderDAO {
    
    // 创建新订单
    public static int createOrder(Order order) {
        String sql = "INSERT INTO NBUSER.ORDERS (ORDER_NUMBER, CUSTOMER_ID, TOTAL_AMOUNT, SHIPPING_FEE, " +
                "TAX_AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS, SHIPPING_STATUS, BILLING_ADDRESS, " +
                "SHIPPING_ADDRESS, CUSTOMER_EMAIL, CUSTOMER_PHONE) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // 生成唯一订单号（如果没有）
            if (order.getOrderNumber() == null || order.getOrderNumber().trim().isEmpty()) {
                order.setOrderNumber(generateOrderNumber());
            }
            
            stmt.setString(1, order.getOrderNumber());
            stmt.setInt(2, order.getCustomerId());
            stmt.setDouble(3, order.getTotalAmount());
            stmt.setDouble(4, order.getShippingFee());
            stmt.setDouble(5, order.getTaxAmount());
            stmt.setString(6, order.getPaymentMethod());
            stmt.setString(7, order.getPaymentStatus());
            stmt.setString(8, order.getShippingStatus());
            stmt.setString(9, order.getBillingAddress());
            stmt.setString(10, order.getShippingAddress());
            stmt.setString(11, order.getCustomerEmail());
            stmt.setString(12, order.getCustomerPhone());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("创建订单失败，没有行受到影响");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int orderId = generatedKeys.getInt(1);
                    order.setOrderId(orderId);
                    
                    // 插入订单项目
                    for (OrderItem item : order.getOrderItems()) {
                        insertOrderItem(conn, orderId, item);
                        
                        // 更新产品库存
                        ProductDAO.reduceProductQuantity(item.getProductId(), item.getQuantity());
                    }
                    
                    return orderId;
                } else {
                    throw new SQLException("创建订单失败，未能获取ID");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    // 插入订单项目
    private static void insertOrderItem(Connection conn, int orderId, OrderItem item) throws SQLException {
        String sql = "INSERT INTO NBUSER.ORDER_ITEMS (ORDER_ID, PRODUCT_ID, QUANTITY, PRICE_PER_UNIT, SUBTOTAL) " +
                "VALUES (?, ?, ?, ?, ?)";
                
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            stmt.setDouble(4, item.getPricePerUnit());
            stmt.setDouble(5, item.getSubtotal());
            
            stmt.executeUpdate();
            item.setOrderId(orderId);
        }
    }
    
    // 生成订单号
    private static String generateOrderNumber() {
        long timestamp = System.currentTimeMillis();
        Random random = new Random();
        int randomDigits = random.nextInt(10000);
        return "ORD" + timestamp + String.format("%04d", randomDigits);
    }
    
    // 获取特定订单
    public static Order getOrderById(int orderId) {
        String sql = "SELECT * FROM NBUSER.ORDERS WHERE ORDER_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    // 获取订单项目
                    order.setOrderItems(getOrderItemsByOrderId(orderId));
                    return order;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // 获取订单项目
    private static List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.NAME AS PRODUCT_NAME FROM NBUSER.ORDER_ITEMS oi " +
                "JOIN NBUSER.PRODUCT p ON oi.PRODUCT_ID = p.ID " +
                "WHERE oi.ORDER_ID = ?";
                
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setItemId(rs.getInt("ITEM_ID"));
                    item.setOrderId(rs.getInt("ORDER_ID"));
                    item.setProductId(rs.getInt("PRODUCT_ID"));
                    item.setQuantity(rs.getInt("QUANTITY"));
                    item.setPricePerUnit(rs.getDouble("PRICE_PER_UNIT"));
                    item.setSubtotal(rs.getDouble("SUBTOTAL"));
                    item.setProductName(rs.getString("PRODUCT_NAME"));
                    items.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    // 获取用户的所有订单
    public static List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM NBUSER.ORDERS WHERE CUSTOMER_ID = ? ORDER BY ORDER_DATE DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    // 获取订单项目
                    order.setOrderItems(getOrderItemsByOrderId(order.getOrderId()));
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // 获取所有订单
    public static List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM NBUSER.ORDERS ORDER BY ORDER_DATE DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                // 不加载订单项目以提高性能
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // 从结果集映射到订单对象
    private static Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("ORDER_ID"));
        order.setOrderNumber(rs.getString("ORDER_NUMBER"));
        order.setCustomerId(rs.getInt("CUSTOMER_ID"));
        order.setOrderDate(rs.getTimestamp("ORDER_DATE"));
        order.setTotalAmount(rs.getDouble("TOTAL_AMOUNT"));
        order.setShippingFee(rs.getDouble("SHIPPING_FEE"));
        order.setTaxAmount(rs.getDouble("TAX_AMOUNT"));
        order.setPaymentMethod(rs.getString("PAYMENT_METHOD"));
        order.setPaymentStatus(rs.getString("PAYMENT_STATUS"));
        order.setShippingStatus(rs.getString("SHIPPING_STATUS"));
        order.setBillingAddress(rs.getString("BILLING_ADDRESS"));
        order.setShippingAddress(rs.getString("SHIPPING_ADDRESS"));
        order.setCustomerEmail(rs.getString("CUSTOMER_EMAIL"));
        order.setCustomerPhone(rs.getString("CUSTOMER_PHONE"));
        return order;
    }
    
    // 获取按日期分组的销售数据
    public static List<SalesReport> getSalesByDate(String periodType, String startDate, String endDate) {
        List<SalesReport> salesData = new ArrayList<>();
        
        String sql = "SELECT * FROM NBUSER.SALES_REPORT WHERE 1=1";
        
        // 添加日期筛选条件
        if (startDate != null && !startDate.isEmpty()) {
            sql += " AND ORDER_DATE >= ?";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += " AND ORDER_DATE <= ?";
        }
        
        // 根据时间段类型添加排序
        sql += " ORDER BY ORDER_DATE DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                stmt.setString(paramIndex++, startDate + " 00:00:00");
            }
            if (endDate != null && !endDate.isEmpty()) {
                stmt.setString(paramIndex, endDate + " 23:59:59");
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesReport report = new SalesReport();
                    report.setOrderDate(rs.getTimestamp("ORDER_DATE"));
                    
                    // 手动计算年、月、日
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(report.getOrderDate());
                    report.setYear(cal.get(Calendar.YEAR));
                    report.setMonth(cal.get(Calendar.MONTH) + 1); // 月份从0开始
                    report.setDay(cal.get(Calendar.DAY_OF_MONTH));
                    
                    report.setOrderId(rs.getInt("ORDER_ID"));
                    report.setOrderNumber(rs.getString("ORDER_NUMBER"));
                    report.setCustomerId(rs.getInt("CUSTOMER_ID"));
                    report.setPaymentMethod(rs.getString("PAYMENT_METHOD"));
                    report.setTotalAmount(rs.getDouble("TOTAL_AMOUNT"));
                    report.setTaxAmount(rs.getDouble("TAX_AMOUNT"));
                    report.setShippingFee(rs.getDouble("SHIPPING_FEE"));
                    report.setProductId(rs.getInt("PRODUCT_ID"));
                    report.setProductName(rs.getString("PRODUCT_NAME"));
                    report.setQuantity(rs.getInt("QUANTITY"));
                    report.setPricePerUnit(rs.getDouble("PRICE_PER_UNIT"));
                    report.setSubtotal(rs.getDouble("SUBTOTAL"));
                    salesData.add(report);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return salesData;
    }
    
    // 获取前10个热销产品
    public static List<TopProduct> getTopSellingProducts(int limit) {
        List<TopProduct> topProducts = new ArrayList<>();
        
        String sql = "SELECT * FROM NBUSER.TOP_PRODUCTS";
        
        // 限制结果数量
        if (limit > 0) {
            sql += " FETCH FIRST " + limit + " ROWS ONLY";
        }
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                TopProduct product = new TopProduct();
                product.setProductId(rs.getInt("PRODUCT_ID"));
                product.setProductName(rs.getString("PRODUCT_NAME"));
                product.setTotalQuantitySold(rs.getInt("TOTAL_QUANTITY_SOLD"));
                product.setTotalRevenue(rs.getDouble("TOTAL_REVENUE"));
                topProducts.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return topProducts;
    }
} 