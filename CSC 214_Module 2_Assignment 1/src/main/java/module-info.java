module com.example.csc214_module2_assignment1 {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.csc214_module2_assignment1 to javafx.fxml;
    exports com.example.csc214_module2_assignment1;
}