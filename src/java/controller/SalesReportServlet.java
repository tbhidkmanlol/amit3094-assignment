/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author wonghx
 */

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.SalesRecord;

@WebServlet("/SalesReportServlet")
public class SalesReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<SalesRecord> salesRecords = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/paymentdb", "nbuser", "nbuser")) {
            
            String sql = "SELECT c.last_name, c.email, c.address, " +
                        "o.order_id, oi.product_name, oi.quantity " +
                        "FROM orders o " +
                        "JOIN customers c ON o.customer_id = c.customer_id " +
                        "JOIN order_items oi ON o.order_id = oi.order_id " +
                        "ORDER BY c.last_name, o.order_id";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    SalesRecord record = new SalesRecord();
                    record.setLastName(rs.getString("last_name"));
                    record.setEmail(rs.getString("email"));
                    record.setAddress(rs.getString("address"));
                    record.setOrderId(rs.getString("order_id"));
                    record.setProductName(rs.getString("product_name"));
                    record.setQuantity(rs.getInt("quantity"));
                    salesRecords.add(record);
                }
            }
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
        
        request.setAttribute("salesRecords", salesRecords);
        request.getRequestDispatcher("salesReport.jsp").forward(request, response);
    }
}