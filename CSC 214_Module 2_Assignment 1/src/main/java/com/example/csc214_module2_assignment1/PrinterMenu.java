/*
 =====================================================================================================
 AUTHOR:        ALEJANDRO PANTOJA-ZURITA
 COLLEGE:       DELAWARE TECHNICAL COMMUNITY COLLEGE
 COURSE:        CSC 214: COMPUTER SCIENCE III
 INSTRUCTOR:    TIAN Z. DING
 DATE:          SEPTEMBER 6, 2025
 PROJECT:       PRINTER TONER LEVELS
 NOTES:         PROGRAM CREATED TO CHECK THE TONER LEVELS OF PRINTERS OBTAINED FROM A CSV FILE.

 I WROTE ALL THE CODE SUBMITTED, OTHERWISE, I HAVE PROVIDED CITATIONS AND REFERENCES WHERE APPROPRIATE.
 =====================================================================================================
*/

package com.example.csc214_module2_assignment1;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class PrinterMenu extends Application {
    @Override
    public void start(Stage stage) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(PrinterMenu.class.getResource("printer-menu.fxml"));
        Scene scene = new Scene(fxmlLoader.load(), 1200, 800);
        stage.setTitle("Printer Menu");
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}