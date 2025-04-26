package dao;

import model.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDAO {

    static {
        initializeTable();
    }

    /**
     * Create the contact_messages table if it doesn't exist
     */
    private static void initializeTable() {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData dbm = conn.getMetaData();
            ResultSet tables = dbm.getTables(null, "NBUSER", "CONTACT_MESSAGES", null);

            if (!tables.next()) {
                System.out.println("Creating CONTACT_MESSAGES table in database");

                try (Statement stmt = conn.createStatement()) {
                    String createTableSQL =
                            "CREATE TABLE NBUSER.CONTACT_MESSAGES (" +
                            "id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), " +
                            "first_name VARCHAR(50) NOT NULL, " +
                            "last_name VARCHAR(50) NOT NULL, " +
                            "email VARCHAR(100) NOT NULL, " +
                            "phone VARCHAR(20), " +
                            "message VARCHAR(1000) NOT NULL, " +
                            "submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                            "is_read BOOLEAN DEFAULT FALSE, " +
                            "is_responded BOOLEAN DEFAULT FALSE, " +
                            "PRIMARY KEY (id))";

                    stmt.executeUpdate(createTableSQL);
                    System.out.println("CONTACT_MESSAGES table created successfully");
                }
            } else {
                System.out.println("CONTACT_MESSAGES table already exists");
            }

        } catch (Exception e) {
            System.err.println("Error initializing CONTACT_MESSAGES table:");
            e.printStackTrace();
        }
    }

    /**
     * Store a contact message
     */
    public static boolean storeMessage(String firstName, String lastName, String email, String phone, String message) {
        String sql = "INSERT INTO NBUSER.CONTACT_MESSAGES (first_name, last_name, email, phone, message) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, email);
            stmt.setString(4, phone);
            stmt.setString(5, message);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            System.err.println("Error storing contact message:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Optional: Retrieve all contact messages (useful for admin panel)
     */
    public static List<String> getAllMessages() {
        List<String> messages = new ArrayList<>();

        String sql = "SELECT id, first_name, last_name, email, phone, message, submission_date FROM NBUSER.CONTACT_MESSAGES ORDER BY submission_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String msg = String.format("[%d] %s %s: %s", rs.getInt("id"),
                        rs.getString("first_name"), rs.getString("last_name"), rs.getString("message"));
                messages.add(msg);
            }

        } catch (Exception e) {
            System.err.println("Error retrieving contact messages:");
            e.printStackTrace();
        }

        return messages;
    }
}
