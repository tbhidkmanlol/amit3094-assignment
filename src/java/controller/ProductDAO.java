package controller;

import controller.DBConnection;
import entity.Product;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        System.out.println("DEBUG: Attempting database connection");

        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("DEBUG: Connection successful!");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, name, price, image FROM product");

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getString("image"));
                products.add(p);
                System.out.println("DEBUG: Loaded product - " + p.getName());
            }

            System.out.println("DEBUG: Total products loaded: " + products.size());
            if (products.isEmpty()) {
                System.out.println("WARNING: No products found in database!");
            }
        } catch (SQLException e) {
            System.err.println("FATAL DATABASE ERROR:");
            System.err.println("Message: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT id, name, price, image FROM product WHERE id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setName(rs.getString("name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setImage(rs.getString("image"));
                    return product;
                }
            }
        } catch (SQLException e) {
            handleSQLException(e);
        }
        return null;
    }

    private void handleSQLException(SQLException e) {
        System.err.println("SQL Error: " + e.getMessage());
        System.err.println("SQL State: " + e.getSQLState());
        System.err.println("Error Code: " + e.getErrorCode());
    }

}
