package org.example.shoppinglist;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

class Product {
    private final String name;
    private String category;
    private float quantity;
    private final String unit;

    protected Product(String name, float quantity, String unit) {
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
    }

    protected float getQuantity() {
        return quantity;
    }

    protected String getUnit() {
        return unit;
    }

    protected String getName() {
        return name;
    }

    protected void setQuantity(float quantity) {
        this.quantity = quantity;
    }
}
