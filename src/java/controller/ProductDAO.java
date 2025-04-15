/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import entity.Product;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    // Remove the dataSource field and replace with database connection properties
private String dbUrl = "jdbc:mysql://localhost:1527/PocketGadgetDB"; // Adjust to your database URL
private String dbUser = "app"; // Replace with your database username
private String dbPassword = "app"; // Replace with your database password

 public ProductDAO() {
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver"); // Use your appropriate JDBC driver
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error loading database driver", e);
        }
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }
    
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM products WHERE category = 'Tech Gadgets & Accessories'");
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    public Product getProductById(int id) {
        Product product = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return product;
    }
    
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            // Search by name or ID (if the keyword is a number)
            String sql = "SELECT * FROM products WHERE category = 'Tech Gadgets & Accessories' AND " +
                        "(LOWER(name) LIKE LOWER(?) OR description LIKE LOWER(?)";
            
            // If the keyword can be parsed as an integer, also search by ID
            try {
                int id = Integer.parseInt(keyword);
                sql += " OR id = ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, "%" + keyword + "%");
                stmt.setString(2, "%" + keyword + "%");
                stmt.setInt(3, id);
            } catch (NumberFormatException e) {
                sql += ")";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, "%" + keyword + "%");
                stmt.setString(2, "%" + keyword + "%");
            }
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return products;
    }
    
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setCategory(rs.getString("category"));
        product.setImageUrl(rs.getString("image_url"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        return product;
    }
    
    // Method to initialize the database with sample data
    public void initializeDatabase() {
        Connection conn = null;
        Statement stmt = null;
        
        try {
            conn = getConnection();
            stmt = conn.createStatement();
            
            // Check if products table exists
            try {
                stmt.executeQuery("SELECT COUNT(*) FROM products");
            } catch (SQLException e) {
                // Table doesn't exist, create it
                stmt.executeUpdate("CREATE TABLE products (" +
                    "id INT PRIMARY KEY, " +
                    "name VARCHAR(255), " +
                    "description VARCHAR(1000), " +
                    "price DOUBLE, " +
                    "category VARCHAR(100), " +
                    "image_url VARCHAR(255), " +
                    "stock_quantity INT)");
                
                // Insert sample data
                insertSampleData(conn);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    private void insertSampleData(Connection conn) throws SQLException {
        String[] insertStatements = {
            "INSERT INTO products VALUES (1, 'Wireless Bluetooth Earbuds', 'High-quality wireless earbuds with noise cancellation', 79.99, 'Tech Gadgets & Accessories', 'images/earbuds.jpg', 50)",
            "INSERT INTO products VALUES (2, 'Smart Watch', 'Fitness tracking smart watch with heart rate monitor', 129.99, 'Tech Gadgets & Accessories', 'images/smartwatch.jpg', 30)",
            "INSERT INTO products VALUES (3, 'Portable Power Bank', '20000mAh fast charging power bank with USB-C', 49.99, 'Tech Gadgets & Accessories', 'images/powerbank.jpg', 100)",
            "INSERT INTO products VALUES (4, 'Bluetooth Speaker', 'Waterproof portable Bluetooth speaker', 69.99, 'Tech Gadgets & Accessories', 'images/speaker.jpg', 40)",
            "INSERT INTO products VALUES (5, 'Wireless Mouse', 'Ergonomic wireless mouse with adjustable DPI', 29.99, 'Tech Gadgets & Accessories', 'images/mouse.jpg', 75)",
            "INSERT INTO products VALUES (6, 'Laptop Stand', 'Adjustable aluminum laptop stand', 35.99, 'Tech Gadgets & Accessories', 'images/laptopstand.jpg', 60)",
            "INSERT INTO products VALUES (7, 'Phone Gimbal', 'Smartphone stabilizer for smooth video recording', 89.99, 'Tech Gadgets & Accessories', 'images/gimbal.jpg', 25)",
            "INSERT INTO products VALUES (8, 'USB-C Hub', '7-in-1 USB-C hub with HDMI and card readers', 45.99, 'Tech Gadgets & Accessories', 'images/usbhub.jpg', 50)"
        };
        
        Statement stmt = conn.createStatement();
        for (String sql : insertStatements) {
            stmt.executeUpdate(sql);
        }
    }
}