// ReviewDAO.java
package dao;

import model.Review;
import model.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // Add a new review
    public static boolean addReview(Review review) throws SQLException, Exception {
        String sql = "INSERT INTO NBUSER.REVIEW (PRODUCT_ID, CUSTOMER_NAME, RATING, COMMENT) VALUES (?, ?, ?, ?)";

        System.out.println("Executing SQL: " + sql);
        System.out.println("With values: " + review.getProductId() + ", "
                + review.getCustomerName() + ", " + review.getRating() + ", " + review.getComment());

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, review.getProductId());
            stmt.setString(2, review.getCustomerName());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());

            int rows = stmt.executeUpdate();
            System.out.println("Rows affected: " + rows);

            return rows > 0;
        }
    }

    // Get all reviews for a product
    public static List<Review> getReviewsByProduct(int productId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM NBUSER.REVIEW WHERE PRODUCT_ID = ? ORDER BY REVIEW_DATE DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("REVIEW_ID"));
                review.setProductId(rs.getInt("PRODUCT_ID"));
                review.setCustomerName(rs.getString("CUSTOMER_NAME"));
                review.setRating(rs.getInt("RATING"));
                review.setComment(rs.getString("COMMENT"));
                review.setReviewDate(rs.getTimestamp("REVIEW_DATE"));
                review.setAdminReply(rs.getString("ADMIN_REPLY"));
                review.setReplyDate(rs.getTimestamp("REPLY_DATE"));
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Get all reviews (for admin)
    public static List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM NBUSER.REVIEW ORDER BY REVIEW_DATE DESC";

        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("REVIEW_ID"));
                review.setProductId(rs.getInt("PRODUCT_ID"));
                review.setCustomerName(rs.getString("CUSTOMER_NAME"));
                review.setRating(rs.getInt("RATING"));
                review.setComment(rs.getString("COMMENT"));
                review.setReviewDate(rs.getTimestamp("REVIEW_DATE"));
                review.setAdminReply(rs.getString("ADMIN_REPLY"));
                review.setReplyDate(rs.getTimestamp("REPLY_DATE"));
                // Check if RESPONDER_ROLE column exists and set it if it does
                try {
                    review.setResponderRole(rs.getString("RESPONDER_ROLE"));
                } catch (SQLException e) {
                    // Column doesn't exist yet, will be added later
                    review.setResponderRole("Admin"); // Default for backward compatibility
                }
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Add admin reply to a review
    public static boolean addAdminReply(int reviewId, String reply) {
        return addAdminReply(reviewId, reply, "Admin");
    }
    
    // Overloaded method to add admin reply with role
    public static boolean addAdminReply(int reviewId, String reply, String responderRole) {
        String sql = "UPDATE NBUSER.REVIEW SET ADMIN_REPLY = ?, REPLY_DATE = CURRENT_TIMESTAMP, RESPONDER_ROLE = ? WHERE REVIEW_ID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reply);
            stmt.setString(2, responderRole);
            stmt.setInt(3, reviewId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            // If the RESPONDER_ROLE column doesn't exist yet, try to add it
            if (e.getMessage().contains("RESPONDER_ROLE")) {
                try {
                    // First try to add the column
                    addResponderRoleColumn();
                    
                    // Then try the update again
                    try (Connection conn = DBConnection.getConnection(); 
                         PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, reply);
                        stmt.setString(2, responderRole);
                        stmt.setInt(3, reviewId);
                        return stmt.executeUpdate() > 0;
                    }
                } catch (Exception ex) {
                    // If adding the column fails too, fall back to the old method
                    return addAdminReplyLegacy(reviewId, reply);
                }
            } else {
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Legacy method for backward compatibility
    private static boolean addAdminReplyLegacy(int reviewId, String reply) {
        String sql = "UPDATE NBUSER.REVIEW SET ADMIN_REPLY = ?, REPLY_DATE = CURRENT_TIMESTAMP WHERE REVIEW_ID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reply);
            stmt.setInt(2, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Add RESPONDER_ROLE column to the REVIEW table if it doesn't exist
    private static void addResponderRoleColumn() {
        String sql = "ALTER TABLE NBUSER.REVIEW ADD COLUMN RESPONDER_ROLE VARCHAR(20)";
        try (Connection conn = DBConnection.getConnection(); 
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
            
            // Set default values for existing records
            String updateSql = "UPDATE NBUSER.REVIEW SET RESPONDER_ROLE = 'Admin' WHERE ADMIN_REPLY IS NOT NULL";
            stmt.executeUpdate(updateSql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
