package dao;

import model.Messages;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.DBConnection;

public class MessageDAO {
    // Connection method with logging
    private static Connection getConnection() {
        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("[DEBUG] Database connection successful: " + conn); // Log connection
            return conn;
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to connect to database:");
            e.printStackTrace();
            return null;
        }
    }

    public static List<Messages> getMessages(String search, String statusFilter, String sortOrder) throws SQLException {
        List<Messages> messages = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM CONTACT_MESSAGES WHERE 1=1");
        
        // Add search filter
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (LOWER(firstName) LIKE ? OR LOWER(lastName) LIKE ? OR LOWER(email) LIKE ?)");
        }
        
        // Add status filter
        if (statusFilter != null) {
            switch (statusFilter) {
                case "unread":
                    sql.append(" AND is_read = false");
                    break;
                case "read":
                    sql.append(" AND is_read = true");
                    break;
                case "pending":
                    sql.append(" AND is_read = true AND is_responded = false");
                    break;
                case "responded":
                    sql.append(" AND is_responded = true");
                    break;
            }
        }
        
        // Add sorting
        if ("oldest".equals(sortOrder)) {
            sql.append(" ORDER BY submission_date ASC");
        } else {
            sql.append(" ORDER BY submission_date DESC");
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (search != null && !search.isEmpty()) {
                String searchTerm = "%" + search.toLowerCase() + "%";
                stmt.setString(paramIndex++, searchTerm);
                stmt.setString(paramIndex++, searchTerm);
                stmt.setString(paramIndex, searchTerm);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Messages msg = new Messages();
                    msg.setId(rs.getInt("ID"));
                    msg.setFirstName(rs.getString("FIRST_NAME"));
                    msg.setLastName(rs.getString("LAST_NAME"));
                    msg.setEmail(rs.getString("EMAIL"));
                    msg.setPhone(rs.getString("PHONE"));
                    msg.setMessage(rs.getString("MESSAGE"));
                    msg.setSubmissionDate(rs.getTimestamp("SUBMISSION_DATE"));
                    msg.setRead(rs.getBoolean("IS_READ"));
                    msg.setResponded(rs.getBoolean("IS_RESPONDED"));
                    messages.add(msg);
                }
            }
        }
        return messages;
    }

    // Method to get message by ID
    public static Messages getMessageById(int id) throws SQLException {
        String sql = "SELECT * FROM CONTACT_MESSAGES WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Messages msg = new Messages();
                    msg.setId(rs.getInt("ID"));
                    msg.setFirstName(rs.getString("FIRST_NAME"));
                    msg.setLastName(rs.getString("LAST_NAME"));
                    msg.setEmail(rs.getString("EMAIL"));
                    msg.setPhone(rs.getString("PHONE"));
                    msg.setMessage(rs.getString("MESSAGE"));
                    msg.setSubmissionDate(rs.getTimestamp("SUBMISSION_DATE"));
                    msg.setRead(rs.getBoolean("IS_READ"));
                    msg.setResponded(rs.getBoolean("IS_RESPONDED"));
                    return msg;
                }
            }
        }
        return null;
    }

    // Method to mark message as read
    public static void markAsRead(int id) throws SQLException {
        String sql = "UPDATE CONTACT_MESSAGES SET is_read = true WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    // Method to send response
    public static void sendResponse(int id, String response) throws SQLException {
        String sql = "UPDATE CONTACT_MESSAGES SET is_responded = true, response = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, response);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
    }

    // Count all messages
    public static int countAllMessages() {
        String sql = "SELECT COUNT(*) FROM CONTACT_MESSAGES";
        System.out.println("[DEBUG] Executing SQL: " + sql); // Log SQL
        try (Connection conn = getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql); 
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("[DEBUG] Total messages count: " + count); // Log result
                return count;
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] SQL Exception in countAllMessages:");
            e.printStackTrace();
        }
        return 0;
    }

    // Count messages by status (unread/read)
    public static int countMessagesByStatus(String status) {
        String sql = "";
        if ("unread".equals(status)) {
            sql = "SELECT COUNT(*) FROM CONTACT_MESSAGES WHERE is_read = false";
        } else if ("read".equals(status)) {
            sql = "SELECT COUNT(*) FROM CONTACT_MESSAGES WHERE is_read = true";
        } else if ("pending".equals(status)) {
            sql = "SELECT COUNT(*) FROM CONTACT_MESSAGES WHERE is_read = true AND is_responded = false";
        }
        
        System.out.println("[DEBUG] Executing SQL: " + sql); // Log SQL query
        System.out.println("[DEBUG] Checking status: " + status); // Log input status
        
        try (Connection conn = getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            int count = rs.next() ? rs.getInt(1) : 0;
            System.out.println("[DEBUG] Found " + count + " messages for status: " + status); // Log result
            return count;
        } catch (SQLException e) {
            System.err.println("[ERROR] SQL Exception in countMessagesByStatus:");
            e.printStackTrace();
            return 0;
        }
    }
    
    // Count messages by responded status
    public static int countMessagesByRespondedStatus(String status) {
        String sql = "SELECT COUNT(*) FROM CONTACT_MESSAGES WHERE is_responded = ?";
        System.out.println("[DEBUG] Executing SQL: " + sql); // Log SQL query
        System.out.println("[DEBUG] Checking responded status: " + status); // Log input status
        
        try (Connection conn = getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            boolean isResponded = "responded".equals(status);
            stmt.setBoolean(1, isResponded);
            System.out.println("[DEBUG] Parameter (is_responded): " + isResponded); // Log parameter
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = rs.next() ? rs.getInt(1) : 0;
                System.out.println("[DEBUG] Found " + count + " messages with responded status: " + status); // Log result
                return count;
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] SQL Exception in countMessagesByRespondedStatus:");
            e.printStackTrace();
            return 0;
        }
    }

    public static int countPendingMessages() {
        String sql = "SELECT COUNT(*) FROM CONTACT_MESSAGES WHERE is_read = true AND is_responded = false";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] SQL Exception in countPendingMessages:");
            e.printStackTrace();
            return 0;
        }
    }
    
    public static boolean storeMessage(Messages message) {
    String sql = "INSERT INTO CONTACT_MESSAGES (FIRST_NAME, LAST_NAME, EMAIL, PHONE, MESSAGE, SUBMISSION_DATE, IS_READ, IS_RESPONDED) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, false, false)";
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, message.getFirstName());
        stmt.setString(2, message.getLastName());
        stmt.setString(3, message.getEmail());
        stmt.setString(4, message.getPhone());
        stmt.setString(5, message.getMessage());
        int rows = stmt.executeUpdate();
        return rows > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

    public static int getTotalMessagesCount() {
        return countAllMessages();
    }

    public static int getUnreadMessagesCount() {
        return countMessagesByStatus("unread");
    }

    public static int getPendingResponseCount() {
        return countPendingMessages();
    }

    public static int getCompletedMessagesCount() {
        return countMessagesByRespondedStatus("responded");
    }
}