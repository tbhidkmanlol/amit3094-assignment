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
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Add admin reply to a review
    public static boolean addAdminReply(int reviewId, String reply) {
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

}
