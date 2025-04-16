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

    private String dbUrl = "jdbc:derby://localhost:1527/PocketGadgetDB;create=true";
    private String dbUser = "app";
    private String dbPassword = "app";

    public ProductDAO() {
        try {
            // Load the JDBC driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error loading database driver", e);
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        System.out.println("Getting all products"); //debug
        try {
            conn = getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM products");

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Found " + products.size() + " products");
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
            String sql = "SELECT * FROM products WHERE "
                    + "(LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?))";

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

}
