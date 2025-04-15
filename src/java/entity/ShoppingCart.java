/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class ShoppingCart implements Serializable {
    private List<CartItem> items;
    private static final double TAX_RATE = 0.07; // 7% sales tax
    private static final double SHIPPING_RATE = 5.99;
    
    public ShoppingCart() {
        this.items = new ArrayList<>();
    }
    
    public List<CartItem> getItems() {
        return items;
    }
    
    public void addItem(Product product, int quantity) {
        boolean found = false;
        
        for (CartItem item : items) {
            if (item.getProduct().getId() == product.getId()) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }
        
        if (!found) {
            items.add(new CartItem(product, quantity));
        }
    }
    
    public void removeItem(int productId) {
        items.removeIf(item -> item.getProduct().getId() == productId);
    }
    
    public void updateQuantity(int productId, int quantity) {
        for (CartItem item : items) {
            if (item.getProduct().getId() == productId) {
                if (quantity <= 0) {
                    removeItem(productId);
                } else {
                    item.setQuantity(quantity);
                }
                break;
            }
        }
    }
    
    public double getSubtotal() {
        double subtotal = 0.0;
        for (CartItem item : items) {
            subtotal += item.getSubtotal();
        }
        return subtotal;
    }
    
    public double getTax() {
        return getSubtotal() * TAX_RATE;
    }
    
    public double getShippingCost() {
        if (getSubtotal() > 50.0) {
            return 0.0; // Free shipping over $50
        }
        return SHIPPING_RATE;
    }
    
    public double getTotal() {
        return getSubtotal() + getTax() + getShippingCost();
    }
    
    public int getItemCount() {
        int count = 0;
        for (CartItem item : items) {
            count += item.getQuantity();
        }
        return count;
    }
    
    public void clear() {
        items.clear();
    }
}
