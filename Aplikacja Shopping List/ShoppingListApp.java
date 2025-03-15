package org.example.shoppinglist;


import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

import java.io.*;
import java.nio.charset.StandardCharsets;

public class ShoppingListApp extends Application {

    private final ObservableList<Category> categories = FXCollections.observableArrayList();

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) {
        Category fruits = new Category("Fruits");
        Category vegetables = new Category("Vegetables");
        Category meat = new Category("Meat");
        Category sweets = new Category("Sweets");
        Category chemicals = new Category("Chemicals");
        Category drinks = new Category("Drinks");
        Category alcohol = new Category("Alcohol");
        Category furniture = new Category("Furniture");
        Category tools = new Category("Tools");
        Category electronics = new Category("Electronics");
        Category animals = new Category("Animals");

        categories.addAll(fruits, vegetables, meat, sweets, chemicals, drinks, alcohol, furniture, tools, electronics, animals);

        primaryStage.setTitle("Shopping List");

        // Ekran 1

        Label nameLabel = new Label("Product Name:");
        TextField nameField = new TextField();

        Label categoryLabel = new Label("Category:");
        ComboBox<Category> categoryComboBox = new ComboBox<>(categories);
        categoryComboBox.prefWidthProperty().bind(nameField.widthProperty());
        categoryComboBox.setEditable(true);

        Label quantityLabel = new Label("Quantity:");
        TextField quantityField = new TextField();

        ComboBox<String> unitComboBox = new ComboBox<>(FXCollections.observableArrayList("kg", "pcs", "liters", "meters"));
        unitComboBox.getSelectionModel().selectFirst();

        Button addButton = new Button("Add Product");
        addButton.setMinWidth(115);
        addButton.setMaxWidth(115);

        Button viewListButton = new Button("View List");
        viewListButton.setMinWidth(115);
        viewListButton.setMaxWidth(115);
        Button exportButton = new Button("Export List");
        exportButton.setMinWidth(115);
        exportButton.setMaxWidth(115);
        Button importButton = new Button("Import List");
        importButton.setMinWidth(115);
        importButton.setMaxWidth(115);

        GridPane inputGrid = new GridPane();
        inputGrid.setHgap(10);
        inputGrid.setVgap(10);

        ColumnConstraints column1 = new ColumnConstraints();

        column1.setMaxWidth(240);
        column1.setMinWidth(240);

        inputGrid.getColumnConstraints().addAll(column1);

        inputGrid.addRow(0, nameLabel);
        inputGrid.addRow(1, nameField);
        inputGrid.addRow(2, categoryLabel);
        inputGrid.addRow(3, categoryComboBox);
        inputGrid.addRow(4, quantityLabel);
        inputGrid.addRow(5, new HBox(10, quantityField, unitComboBox));
        inputGrid.addRow(7, new HBox(10, addButton, viewListButton));
        inputGrid.addRow(8, new HBox(10, exportButton, importButton));

        VBox inputBox = new VBox(inputGrid);
        inputBox.setPadding(new Insets(10));

        Scene inputScene = new Scene(inputBox, 270, 400);
        primaryStage.setScene(inputScene);
        primaryStage.show();

        // Ekran 2

        VBox vbox = new VBox();
        vbox.setSpacing(10);
        vbox.setPadding(new Insets(10));

        ListView<String> shoppingListView = new ListView<>();
        shoppingListView.setPrefWidth(400);

        Button backButton = new Button("Back");
        backButton.setMinWidth(115);
        backButton.setMaxWidth(115);

        Button removeProductButton = new Button("Remove");
        removeProductButton.setMinWidth(115);
        removeProductButton.setMaxWidth(115);

        HBox buttonBox = new HBox(10);
        buttonBox.getChildren().addAll(removeProductButton, backButton);
        vbox.getChildren().addAll(shoppingListView, buttonBox);

        Scene listScene = new Scene(vbox, 270, 400);

        importButton.setOnAction(event -> {
            FileChooser fileChooser = new FileChooser();
            fileChooser.setTitle("Select Shopping List File");
            fileChooser.getExtensionFilters().addAll(new FileChooser.ExtensionFilter("Shopping List Files", "*.sl"));
            File selectedFile = fileChooser.showOpenDialog(primaryStage);

            if (selectedFile != null) {
                try (BufferedReader reader = new BufferedReader(new FileReader(selectedFile))) {
                    String line;
                    String categoryName = "";
                    boolean isProduct = false;

                    while ((line = reader.readLine()) != null) {
                        if (!line.startsWith("  ")) {
                            categoryName = line.substring(0, line.length() - 1).trim();
                            Category inCategory = null;

                            for (Category category : categories) {
                                if (category.getName().equals(categoryName)) {
                                    inCategory = category;
                                    break;
                                }
                            }

                            if (inCategory == null) {
                                inCategory = new Category(categoryName);
                                categories.add(inCategory);
                            }
                        } else {
                            String[] parts = line.trim().split("[\\s()]+");

                            String productName = parts[0];
                            float quantity = Float.parseFloat(parts[1]);
                            String unit = parts[2];

                            Category inCategory = null;
                            for (Category category : categories) {
                                if (category.getName().equals(categoryName)) {
                                    inCategory = category;
                                    break;
                                }
                            }

                            for (Category category : categories) {
                                for (Product product : category.getProducts()){
                                    if (productName.equals(product.getName()) && unit.equals(product.getUnit()) && categoryName.equals(category.getName())){
                                        product.setQuantity(product.getQuantity() + quantity);
                                        isProduct = true;
                                        break;
                                    }
                                }
                                if (isProduct)
                                    break;
                            }

                            if(!isProduct){
                                inCategory.addProduct(new Product(productName, quantity, unit));
                                isProduct = false;
                            }
                        }
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    showAlert("Error", "Failed to import shopping list from file.");
                }
            }
        });

        exportButton.setOnAction(event -> {
            // Tworzenie okna dialogowego wyboru miejsca na komputerze
            FileChooser fileChooser = new FileChooser();
            fileChooser.setTitle("Export Shopping List");

            // Ustawienie filtrów dla wyboru pliku
            FileChooser.ExtensionFilter txtFilter = new FileChooser.ExtensionFilter("Shopping List Files", "*.sl");
            fileChooser.getExtensionFilters().add(txtFilter);

            // Wyświetlenie okna dialogowego i pobranie wybranej lokalizacji do zapisu pliku
            File selectedFile = fileChooser.showSaveDialog(primaryStage);

            // Sprawdzenie czy użytkownik wybrał miejsce i nazwę pliku
            if (selectedFile != null) {
                // Eksport listy zakupów do pliku tekstowego
                try (PrintWriter writer = new PrintWriter(selectedFile, StandardCharsets.UTF_8)) {
                    for (Category category : categories) {
                        if (!category.getProducts().isEmpty()) {
                            writer.println(category.getName() + ":");
                            for (Product product : category.getProducts()) {
                                writer.println("    " + product.getName() + " (" + product.getQuantity() + " " + product.getUnit() + ")");
                            }
                        }
                    }
                } catch (IOException e) {
                    showAlert("Error", "An error occurred while exporting the shopping list.");
                }
            }
        });

        addButton.setOnAction(event -> {
            String productName = nameField.getText();
            String categoryName = categoryComboBox.getEditor().getText();
            String quantityText = quantityField.getText();
            String unit = unitComboBox.getValue();

            if (productName.isEmpty() || categoryName.isEmpty() || quantityText.isEmpty()) {
                showAlert("Error", "All fields must be selected.");
                return;
            }

            Category selectedCategory = null;
            float quantity;
            boolean isProduct = false;

            for (Category category : categories) {
                if (category.getName().equals(categoryName)) {
                    selectedCategory = category;
                    break;
                }
            }

            if (selectedCategory == null) {
                selectedCategory = new Category(categoryName);
                categories.add(selectedCategory);
            }

            try {
                quantity = Float.parseFloat(quantityText);
            } catch (NumberFormatException e) {
                showAlert("Error", "Quantity must be a number.");
                return;
            }

            if (unit.equals("pcs")) {
                try {
                    quantity = Integer.parseInt(quantityText);
                } catch (NumberFormatException e) {
                    showAlert("Error", "Quantity must be an integer for 'pcs' unit.");
                    return;
                }
            }

            if (quantity <= 0) {
                showAlert("Error", "Quantity must be a positive number.");
            }

            for (Category category : categories) {
                for (Product product : category.getProducts()){
                    if (productName.equals(product.getName()) && unit.equals(product.getUnit()) && categoryName.equals(category.getName())){
                        product.setQuantity(product.getQuantity() + quantity);
                        isProduct = true;
                        break;
                    }
                }
                if (isProduct)
                    break;
            }

            if(!isProduct)
                selectedCategory.addProduct(new Product(productName, quantity, unit));
        });

        viewListButton.setOnAction(event -> {
            updateShoppingListView(shoppingListView);
            primaryStage.setScene(listScene);
        });

        backButton.setOnAction(event -> primaryStage.setScene(inputScene));

        removeProductButton.setOnAction(event -> {
            String selectedOption = shoppingListView.getSelectionModel().getSelectedItem();
            selectedOption = parseName(selectedOption);
            boolean isCategory = false;

            if (selectedOption != null) {
                for (Category category : categories) {
                    if (selectedOption.equals(category.getName())) {
                        isCategory = true;
                        category.getProducts().clear();
                        updateShoppingListView(shoppingListView);
                        break;
                    }
                }

                if (!isCategory) {
                    for (Category category : categories) {
                        for (Product product : category.getProducts()) {
                            if (selectedOption.equals(product.getName())) {
                                category.removeProduct(product);
                                updateShoppingListView(shoppingListView);
                                break;
                            }
                        }
                    }
                }
            } else
                showAlert("Error", "Please select a product or category to remove.");
        });
    }

    private void updateShoppingListView(ListView<String> shoppingListView) {
        shoppingListView.getItems().clear();
        for (Category category : categories) {
            if (!category.getProducts().isEmpty()) {
                shoppingListView.getItems().add(category.getName());
                for (Product product : category.getProducts()) {
                    shoppingListView.getItems().add("    " + product.getName() + " (" + product.getQuantity() + " " + product.getUnit() + ")");
                }
            }
        }
    }

    private String parseName(String Format) {
        if (Format.startsWith("    ")) {
            return Format.substring(4, Format.indexOf(" ("));
        } else {
            return Format;
        }
    }

    private void showAlert(String title, String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }
}
