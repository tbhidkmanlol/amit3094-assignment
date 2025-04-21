package dao;

import model.User;
import model.DBConnection;
import java.sql.*;

public class UserDAO {
    
    // 1. Create default manager account
    public void createDefaultManager() throws SQLException, Exception {
        if (!managerExists()) {  // Check if manager already exists
            String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setString(1, "manager");
                stmt.setString(2, "manager123");
                stmt.setString(3, "MANAGER");
                stmt.executeUpdate();
            }
        }
    }

    private boolean managerExists() throws SQLException, Exception {
        String sql = "SELECT 1 FROM users WHERE role = 'MANAGER'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next();
        }
    }

    // 2. Authenticate user
    public User authenticate(String username, String password) throws SQLException, Exception {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role")
                    );
                }
            }
        }
        return null;
    }

    // 3. Register customer
    public boolean registerCustomer(User user) throws SQLException, Exception {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'CUSTOMER')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            return stmt.executeUpdate() > 0;
        }
    }

    // 4. Create admin account (manager-only)
    public boolean createAdminAccount(User admin, User manager) throws SQLException, Exception {
        // Verify the requester is a manager
        if (!"MANAGER".equals(manager.getRole())) {
            return false;
        }
        
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'ADMIN')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            return stmt.executeUpdate() > 0;
        }
    }
}