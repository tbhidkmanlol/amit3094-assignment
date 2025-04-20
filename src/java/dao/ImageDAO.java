package dao;

import java.io.*;
import java.sql.*;
import java.util.Base64;
import model.DBConnection;

public class ImageDAO {
    
    static {
        // Try to create the table when the class is loaded
        initializeTable();
    }
    
    /**
     * Initialize the image storage table in the database if it doesn't exist
     */
    private static void initializeTable() {
        try (Connection conn = DBConnection.getConnection()) {
            // Check if table exists
            DatabaseMetaData dbm = conn.getMetaData();
            ResultSet tables = dbm.getTables(null, "NBUSER", "PRODUCT_IMAGES", null);
            
            if (!tables.next()) {
                // Table doesn't exist, create it
                System.out.println("Creating PRODUCT_IMAGES table in database");
                
                try (Statement stmt = conn.createStatement()) {
                    String createTableSQL = 
                        "CREATE TABLE NBUSER.PRODUCT_IMAGES (" +
                        "IMAGE_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), " +
                        "IMAGE_NAME VARCHAR(255), " +
                        "IMAGE_DATA BLOB, " +
                        "UPLOAD_DATE TIMESTAMP, " +
                        "PRIMARY KEY (IMAGE_ID))";
                    
                    stmt.executeUpdate(createTableSQL);
                    System.out.println("PRODUCT_IMAGES table created successfully");
                }
            } else {
                System.out.println("PRODUCT_IMAGES table already exists");
            }
            
        } catch (Exception e) {
            System.err.println("Error initializing PRODUCT_IMAGES table:");
            e.printStackTrace();
        }
    }
    
    /**
     * Stores an image in the database and returns the assigned image ID
     * 
     * @param imageInputStream The input stream containing the image data
     * @param imageName The original name of the image
     * @return The ID assigned to the stored image, or -1 if an error occurred
     */
    public static int storeImage(InputStream imageInputStream, String imageName) {
        int imageId = -1;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO NBUSER.PRODUCT_IMAGES (IMAGE_NAME, IMAGE_DATA, UPLOAD_DATE) VALUES (?, ?, CURRENT_TIMESTAMP)",
                     Statement.RETURN_GENERATED_KEYS)) {

            // Read image data into byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead;
            
            while ((bytesRead = imageInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            
            byte[] imageData = outputStream.toByteArray();
            
            // Set parameters and execute
            stmt.setString(1, imageName);
            stmt.setBytes(2, imageData);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated ID
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        imageId = generatedKeys.getInt(1);
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error storing image in database:");
            e.printStackTrace();
        }
        
        return imageId;
    }
    
    /**
     * Retrieves an image from the database by its ID
     * 
     * @param imageId The ID of the image to retrieve
     * @return A byte array containing the image data, or null if not found
     */
    public static byte[] getImageById(int imageId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT IMAGE_DATA FROM NBUSER.PRODUCT_IMAGES WHERE IMAGE_ID = ?")) {
            
            stmt.setInt(1, imageId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBytes("IMAGE_DATA");
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error retrieving image from database:");
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Converts an image ID to a base64 data URL for embedding in HTML
     * 
     * @param imageId The ID of the image to convert
     * @param defaultImagePath Path to a default image if the ID is invalid
     * @return A data URL containing the base64-encoded image
     */
    public static String getImageDataUrl(int imageId, String defaultImagePath) {
        byte[] imageData = getImageById(imageId);
        
        if (imageData != null) {
            String base64Image = Base64.getEncoder().encodeToString(imageData);
            // Determine content type based on first few bytes (simple version)
            String contentType = determineContentType(imageData);
            return "data:" + contentType + ";base64," + base64Image;
        }
        
        return defaultImagePath;
    }
    
    /**
     * Simple function to determine image content type based on first few bytes
     */
    private static String determineContentType(byte[] data) {
        if (data.length >= 2) {
            if (data[0] == (byte)0xFF && data[1] == (byte)0xD8) {
                return "image/jpeg";
            } else if (data[0] == (byte)0x89 && data[1] == (byte)0x50) {
                return "image/png";
            } else if (data[0] == (byte)0x47 && data[1] == (byte)0x49) {
                return "image/gif";
            } else if (data[0] == (byte)0x42 && data[1] == (byte)0x4D) {
                return "image/bmp";
            }
        }
        return "image/jpeg"; // Default to JPEG
    }
}