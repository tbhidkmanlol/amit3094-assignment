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
                    int id = rs.getInt("id");
                    String role = rs.getString("role");
                    
                    if ("CUSTOMER".equals(role)) {
                        // For customers, fetch additional information
                        return new User(
                            id,
                            rs.getString("username"),
                            rs.getString("password"),
                            role,
                            rs.getString("customer_name"),
                            rs.getString("contact_number"),
                            rs.getString("email")
                        );
                    } else {
                        // For ADMIN and MANAGER, just the basic fields
                        return new User(
                            id,
                            rs.getString("username"),
                            rs.getString("password"),
                            role
                        );
                    }
                }
            }
        }
        return null;
    }

    // 3. Register customer
    public boolean registerCustomer(User user) throws SQLException, Exception {
        String sql = "INSERT INTO users (username, password, role, customer_name, contact_number, email) VALUES (?, ?, 'CUSTOMER', ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getCustomerName());
            stmt.setString(4, user.getContactNumber());
            stmt.setString(5, user.getEmail());
            
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
    
    // 5. Create staff account by manager
    public boolean createStaffAccount(String username, String password) throws SQLException, Exception {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'STAFF')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // 6. Update user password
    public boolean updatePassword(int userId, String newPassword) throws SQLException, Exception {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // 7. Get all customers (for manager view)
    public java.util.List<User> getAllCustomers() throws SQLException, Exception {
        java.util.List<User> customers = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User customer = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("customer_name"),
                    rs.getString("contact_number"),
                    rs.getString("email")
                );
                customers.add(customer);
            }
        }
        return customers;
    }
    
    // 8. Get all staff (for manager view)
    public java.util.List<User> getAllStaff() throws SQLException, Exception {
        java.util.List<User> staff = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'STAFF'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User admin = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
                staff.add(admin);
            }
        }
        return staff;
    }

    // 9. Get all admins (for manager view)
    public java.util.List<User> getAllAdmins() throws SQLException, Exception {
        java.util.List<User> admins = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'ADMIN'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User admin = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
                admins.add(admin);
            }
        }
        return admins;
    }
    
    // 10. Get user by ID
    public User getUserById(int userId) throws SQLException, Exception {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    
                    if ("CUSTOMER".equals(role)) {
                        return new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            role,
                            rs.getString("customer_name"),
                            rs.getString("contact_number"),
                            rs.getString("email")
                        );
                    } else {
                        return new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            role
                        );
                    }
                }
            }
        }
        return null;
    }
    
    // 11. Update customer details
    public boolean updateCustomer(User customer) throws SQLException, Exception {
        String sql = "UPDATE users SET username = ?, password = ?, customer_name = ?, contact_number = ?, email = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getUsername());
            stmt.setString(2, customer.getPassword());
            stmt.setString(3, customer.getCustomerName());
            stmt.setString(4, customer.getContactNumber());
            stmt.setString(5, customer.getEmail());
            stmt.setInt(6, customer.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Update admin details
    public boolean updateAdmin(User admin) throws SQLException, Exception {
        String sql = "UPDATE users SET username = ?, password = ? WHERE id = ? AND role = 'ADMIN'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            stmt.setInt(3, admin.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    // 12. Delete user
    public boolean deleteUser(int userId) throws SQLException, Exception {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // 13. Check if username exists
    public boolean usernameExists(String username) throws SQLException, Exception {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    // 14. verify password
     public boolean verifyPassword(int userId, String password) throws SQLException, Exception {
        String sql = "SELECT 1 FROM users WHERE id = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    // 15. Update username 
    public boolean updateUsername(int userId, String newUsername) throws SQLException, Exception {
        String sql = "UPDATE users SET username = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newUsername);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }
}
