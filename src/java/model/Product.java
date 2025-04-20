package model;

public class Product {
    private int id;
    private String name;
    private double price;
    private String image;
    private String description; 
    private int quantity;

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
     public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}