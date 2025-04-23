package model;

public class OrderItem {
    private int itemId;
    private int orderId;
    private int productId;
    private int quantity;
    private double pricePerUnit;
    private double subtotal;
    private String productName; // 用于报表显示

    public OrderItem() {
    }

    public OrderItem(int productId, int quantity, double pricePerUnit) {
        this.productId = productId;
        this.quantity = quantity;
        this.pricePerUnit = pricePerUnit;
        this.subtotal = quantity * pricePerUnit;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        // 自动更新小计
        if (this.pricePerUnit > 0) {
            this.subtotal = this.quantity * this.pricePerUnit;
        }
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
        // 自动更新小计
        if (this.quantity > 0) {
            this.subtotal = this.quantity * this.pricePerUnit;
        }
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
} 