package entity;

import entity.Product;
import java.util.ArrayList;
import java.util.List;

public class Cart {

    private List<Product> items = new ArrayList<>();

    public void addProduct(Product product) {
        items.add(product);
    }

    public void removeProduct(int productId) {
        items.removeIf(p -> p.getId() == productId);
    }

    public List<Product> getItems() {
        return items;
    }

    public int getItemCount() {
        return items.size();
    }
}
