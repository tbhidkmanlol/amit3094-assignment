/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Product;
import model.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import static model.DBConnection.getConnection;

public class ProductDAO {

    // Get all products
    public static List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        System.out.println("Start Searching All Products....");  // Debug

        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM NBUSER.PRODUCT")) {

            System.out.println("SQL query execution successful");  // Debug

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("ID"));
                product.setName(rs.getString("NAME"));
                product.setPrice(rs.getDouble("PRICE"));
                product.setImage(rs.getString("IMAGE"));
                product.setDescription(rs.getString("DESCRIPTION"));
                product.setQuantity(rs.getInt("QUANTITY"));
                products.add(product);

                System.out.println("Load Product: " + product.getName());  // Debug
            }
        } catch (Exception e) {
            System.err.println("Error Database Checking:");
            e.printStackTrace();
        }

        System.out.println("Total Searched Products: " + products.size());  // Debug
        return products;
    }

    // Get product by ID
    public static Product getProductById(int productId) {
        Product product = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM NBUSER.PRODUCT WHERE ID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("ID"));
                product.setName(rs.getString("NAME"));
                product.setPrice(rs.getDouble("PRICE"));
                product.setImage(rs.getString("IMAGE"));
                product.setDescription(rs.getString("DESCRIPTION"));
                product.setQuantity(rs.getInt("QUANTITY"));
            }

            conn.close();
        } catch (Exception e) {
            System.err.println("Error getting product by ID:");
            e.printStackTrace();
        }
        return product;
    }

    // Add new product
    public static boolean addProduct(Product product) {
        String sql = "INSERT INTO NBUSER.PRODUCT (NAME, PRICE, QUANTITY, IMAGE, DESCRIPTION) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, product.getName());
            stmt.setDouble(2, product.getPrice());
            stmt.setInt(3, product.getQuantity());
            stmt.setString(4, product.getImage());
            stmt.setString(5, product.getDescription());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        product.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete product
    public static boolean deleteProduct(int productId) {
        System.out.println("Attempting to delete product with ID: " + productId);  // Debug
        boolean success = false;

        String sql = "DELETE FROM NBUSER.PRODUCT WHERE ID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();

            success = rowsAffected > 0;

            if (success) {
                System.out.println("Product deleted successfully!");  // Debug
            } else {
                System.out.println("No product found with ID: " + productId);  // Debug
            }
        } catch (Exception e) {
            System.err.println("Error deleting product:");
            e.printStackTrace();
        }
        return success;
    }

    public static List<Product> searchProductsByName(String name) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM NBUSER.PRODUCT WHERE LOWER(NAME) LIKE LOWER(?)";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + name + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("ID"));
                product.setName(rs.getString("NAME"));
                product.setPrice(rs.getDouble("PRICE"));
                product.setImage(rs.getString("IMAGE"));
                product.setDescription(rs.getString("DESCRIPTION"));
                product.setQuantity(rs.getInt("QUANTITY"));
                products.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public static boolean updateProductQuantity(int productId, int quantityChange) {
        String sql = "UPDATE NBUSER.PRODUCT SET QUANTITY = QUANTITY - ? WHERE ID = ? AND QUANTITY >= ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantityChange);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantityChange); // Ensures we don't go negative

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deductProductQuantity(int productId, int quantity) {
        String sql = "UPDATE NBUSER.PRODUCT SET QUANTITY = QUANTITY - ? WHERE ID = ? AND QUANTITY >= ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean restoreProductQuantity(int productId, int quantity) {
        String sql = "UPDATE NBUSER.PRODUCT SET QUANTITY = QUANTITY + ? WHERE ID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean restockProduct(int productId, int quantity) {
        String sql = "UPDATE NBUSER.PRODUCT SET QUANTITY = QUANTITY + ? WHERE ID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

   // Add these methods to your ProductDAO class
public static boolean reduceProductQuantity(int productId, int quantity) {
        String sql = "UPDATE NBUSER.PRODUCT SET QUANTITY = QUANTITY - ? WHERE ID = ? AND QUANTITY >= ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity); // Ensures we don't go negative
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int getProductQuantity(int productId) {
        String sql = "SELECT QUANTITY FROM NBUSER.PRODUCT WHERE ID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("QUANTITY");
            }
            return -1; // Product not found
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }


public static int getCurrentQuantity(int productId) {
    String sql = "SELECT QUANTITY FROM NBUSER.PRODUCT WHERE ID = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, productId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("QUANTITY");
        }
        return -1; // Product not found
    } catch (Exception e) {
        e.printStackTrace();
        return -1;
    }
}

// Method to get products by category
public static List<Product> getProductsByCategory(String category) {
    List<Product> products = new ArrayList<>();
    String sql = "SELECT * FROM NBUSER.PRODUCT WHERE LOWER(DESCRIPTION) LIKE LOWER(?)";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, "%" + category + "%");
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Product product = new Product();
            product.setId(rs.getInt("ID"));
            product.setName(rs.getString("NAME"));
            product.setPrice(rs.getDouble("PRICE"));
            product.setImage(rs.getString("IMAGE"));
            product.setDescription(rs.getString("DESCRIPTION"));
            product.setQuantity(rs.getInt("QUANTITY"));
            products.add(product);
        }
        
        System.out.println("Found " + products.size() + " products in category: " + category);
    } catch (Exception e) {
        System.err.println("Error getting products by category:");
        e.printStackTrace();
    }
    return products;
}

// Method to search products by name or description
public static List<Product> searchProducts(String search) {
    List<Product> products = new ArrayList<>();
    String sql = "SELECT * FROM NBUSER.PRODUCT WHERE LOWER(NAME) LIKE LOWER(?) OR LOWER(DESCRIPTION) LIKE LOWER(?)";
    
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, "%" + search + "%");
        stmt.setString(2, "%" + search + "%");
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            Product product = new Product();
            product.setId(rs.getInt("ID"));
            product.setName(rs.getString("NAME"));
            product.setPrice(rs.getDouble("PRICE"));
            product.setImage(rs.getString("IMAGE"));
            product.setDescription(rs.getString("DESCRIPTION"));
            product.setQuantity(rs.getInt("QUANTITY"));
            products.add(product);
        }
    } catch (Exception e) {
        System.err.println("Error searching products:");
        e.printStackTrace();
    }
    return products;
}

// Enhanced method to get product categories
public static List<String> getAllCategories() {
    Set<String> uniqueCategories = new HashSet<>();
    String sql = "SELECT DISTINCT DESCRIPTION FROM NBUSER.PRODUCT WHERE DESCRIPTION IS NOT NULL";
    
    try (Connection conn = getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            String description = rs.getString("DESCRIPTION");
            if (description != null && !description.trim().isEmpty()) {
                // Extract main category from description (assuming format contains category)
                // Common categories to extract
                String[] possibleCategories = {"Phone Case", "Cable", "Charger", "Power Bank", 
                                             "Screen Protector", "Earphone", "Keyboard", "Holder", 
                                             "Extension", "Wallpaper"};
                
                String category = null;
                for (String cat : possibleCategories) {
                    if (description.toLowerCase().contains(cat.toLowerCase())) {
                        category = cat;
                        break;
                    }
                }
                
                // If we found a specific category, add it
                if (category != null) {
                    uniqueCategories.add(category);
                } else {
                    // For descriptions that don't match any preset category
                    // Use the first 15 characters or first word as a fallback
                    String shortDesc = description.length() > 15 ? 
                        description.substring(0, 15) : description;
                    
                    if (shortDesc.contains(" ")) {
                        shortDesc = shortDesc.substring(0, shortDesc.indexOf(" "));
                    }
                    
                    uniqueCategories.add(shortDesc);
                }
            }
        }
        
        System.out.println("Found " + uniqueCategories.size() + " unique categories");
    } catch (Exception e) {
        System.err.println("Error getting all categories:");
        e.printStackTrace();
    }
    
    return new ArrayList<>(uniqueCategories);
}

    /**
     * Updates an existing product in the database
     * 
     * @param product The product object with updated values
     * @return true if update was successful, false otherwise
     */
    public static boolean updateProduct(Product product) {
        String sql = "UPDATE NBUSER.PRODUCT SET NAME = ?, PRICE = ?, QUANTITY = ?, " +
                     "IMAGE = ?, DESCRIPTION = ? WHERE ID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setDouble(2, product.getPrice());
            stmt.setInt(3, product.getQuantity());
            stmt.setString(4, product.getImage());
            stmt.setString(5, product.getDescription());
            stmt.setInt(6, product.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error updating product:");
            e.printStackTrace();
            return false;
        }
    }
}
