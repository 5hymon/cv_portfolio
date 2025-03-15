package org.example.shoppinglist;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

class Category {
    private final String name;
    private final ObservableList<Product> products;

    protected Category(String name) {
        this.name = name;
        this.products = FXCollections.observableArrayList();
    }

    protected String getName() {
        return name;
    }

    protected ObservableList<Product> getProducts() {
        return products;
    }

    protected void addProduct(Product product) {
        products.add(product);
    }

    protected void removeProduct(Product product) {
        products.remove(product);
    }

    @Override
    public String toString() {
        return name;
    }
}
