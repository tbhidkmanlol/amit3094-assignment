package model;

public class User {

    private int id;
    private String username;
    private String password;
    private String role; // "CUSTOMER", "ADMIN", or "MANAGER"
    
    // Customer-specific fields
    private String customerName;
    private String contactNumber;
    private String email;

    public User() {
    }

    // Constructor for MANAGER and ADMIN users
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }
    
    // Constructor for CUSTOMER users
    public User(String username, String password, String role, String customerName, String contactNumber, String email) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.customerName = customerName;
        this.contactNumber = contactNumber;
        this.email = email;
    }
    
    // Constructor with ID
    public User(int id, String username, String password, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
    }
    
    // Full constructor with all fields
    public User(int id, String username, String password, String role, String customerName, String contactNumber, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.customerName = customerName;
        this.contactNumber = contactNumber;
        this.email = email;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getContactNumber() {
        return contactNumber;
    }
    
    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
}
