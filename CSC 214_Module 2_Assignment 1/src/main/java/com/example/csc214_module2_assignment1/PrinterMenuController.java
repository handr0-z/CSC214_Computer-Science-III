package com.example.csc214_module2_assignment1;

import javafx.beans.property.ReadOnlyStringWrapper;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ListView;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.ToggleButton;
import javafx.scene.input.MouseEvent;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class PrinterMenuController {

    // Declare any variables needed to run program.
    private String fileName = "Mini Project Toner Report - Sheet1.csv";
    private String csvFile = "src/main/resources/com/example/csc214_module2_assignment1/" + fileName;
    private String line;
    private String csvSplitBy = ",";

    //private ArrayList<Printer> deviceList = new ArrayList<>();
    private ObservableList<Printer> deviceList = FXCollections.observableArrayList();

    private String choice1 = "Show All Devices";
    private String choice2 = "Devices with Low Toner";
    private String filterSelection = null;
    private String message;

    @FXML
    private TableColumn<Printer, String> blackCartridgeLevelColumn;

    @FXML
    private TableColumn<Printer, String> colorCartridgeLevelColumn;

    @FXML
    private TableColumn<Printer, String> iPv4AddressColumn;

    @FXML
    private TableColumn<Printer, String> lastCommunicationTimeColumn;

    @FXML
    private TableColumn<Printer, String> pageCountColumn;

    @FXML
    private TableColumn<Printer, String> printerNameColumn;

    @FXML
    private TableColumn<Printer, String> serialNumberColumn;

    @FXML
    private TableView<Printer> devicesTableView;

    @FXML
    private ChoiceBox<String> filterList;

    @FXML
    private ListView<String> menuListView;

    @FXML
    private ToggleButton filterButton;

    @FXML
    private TextField itemInfoTextField;

    public void initialize()
    {
        // Add options to choice box
        filterList.getItems().add(choice1);
        filterList.getItems().add(choice2);

        // Create list of devices
        createDeviceList(deviceList);

        filterList.getSelectionModel().selectFirst();

        // Populate ListView with menu items.
        for (int i = 0; i < deviceList.size(); i++) {menuListView.getItems().add(deviceList.get(i).getDeviceName());}

        // Populate Columns with correct information on the Table View
        devicesTableView.setItems(FXCollections.observableArrayList(deviceList));
        printerNameColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(cellData.getValue().getDeviceName()));
        iPv4AddressColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(cellData.getValue().getiPv4Address()));
        lastCommunicationTimeColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(cellData.getValue().getLastCommunicationTime()));
        serialNumberColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(cellData.getValue().getSerialNumber()));
        pageCountColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(String.valueOf(cellData.getValue().getPageCount())));
        blackCartridgeLevelColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(String.valueOf(cellData.getValue().getBlackCartridgeLevel() +"%")));

        colorCartridgeLevelColumn.setCellValueFactory(cellData ->
                new ReadOnlyStringWrapper(String.valueOf(cellData.getValue().getColorCartridgeLevel() +"%")));
    }

    @FXML
    void filterMenuHandler(ActionEvent event)
    {
        /*filterSelection = filterList.getValue(); // Obtain filter selection from user.
        menuListView.getItems().clear();

        for (int i = 0; i < deviceList.size(); i++)
        {
            if (filterSelection.equals(choice2) && (deviceList.get(i).getBlackCartridgeLevel() <= 10) || (deviceList.get(i).getColorCartridgeLevel() <= 10)) {menuListView.getItems().add(deviceList.get(i).getDeviceName());}
            else if (filterSelection.equals(choice1)) {menuListView.getItems().add(deviceList.get(i).getDeviceName());}
        }*/

        filterSelection = filterList.getValue(); // Get user's selection

        ObservableList<Printer> filteredList = FXCollections.observableArrayList();

        for (Printer printer : deviceList)
        {
            if (filterSelection.equals(choice2))
            {
                if (printer.getBlackCartridgeLevel() <= 10 || printer.getColorCartridgeLevel() <= 10)
                {
                    filteredList.add(printer);
                }
            }
            else if (filterSelection.equals(choice1))
            {
                filteredList.add(printer); // Show all
            }
        }
        // Update TableView and ListView
        devicesTableView.setItems(filteredList);

        menuListView.getItems().clear();
        for (Printer printer : filteredList)
        {
            menuListView.getItems().add(printer.getDeviceName());
        }
    }

    @FXML
    void listViewSelectionHandler(MouseEvent event)
    {
        String selection = String.valueOf(menuListView.getSelectionModel().getSelectedItems());

        for (int i = 0; i < deviceList.size(); i++)
        {
            if (selection.equals("[" + deviceList.get(i).getDeviceName() + "]"))
            {
                itemInfoTextField.setText(deviceList.get(i).menuDisplay());
                System.out.println("--------------------------------------------------------------------------------------------------------------------");
                System.out.println(deviceList.get(i).terminalDisplay());

                // Check Toner Levels are low and notify user.
                if (deviceList.get(i).getBlackCartridgeLevel() < 10) {System.out.println("\n\nWARNING! BLACK CARTRIDGE TONER LEVEL AT " + deviceList.get(i).getBlackCartridgeLevel() + "%");}

                if (deviceList.get(i).getColorCartridgeLevel() < 10) {System.out.println("\n\nWARNING! COLOR CARTRIDGE TONER LEVEL AT " + deviceList.get(i).getColorCartridgeLevel() + "%");}
            }
        }
    }

    // Method used to obtain device information from CSV file.
    /*void createDeviceList(ArrayList<Printer> deviceList)
    {
        // Obtain information from CSV file
        try (BufferedReader br = new BufferedReader(new FileReader(csvFile)))
        {
            System.out.println("--------------------------------------------------------------------------------------------------------------------");
            System.out.println("File: " + fileName + " opened successfully!");
            System.out.println("--------------------------------------------------------------------------------------------------------------------");
            System.out.println("NOTE: When Adding devices to list, be sure to follow outline below. Information is separated by ,(comma)\n");
            System.out.println("WARNING: DO NOT REMOVE HEADER (FIRST LINE) FROM CSV FILE.");
            System.out.println("--------------------------------------------------------------------------------------------------------------------");
            System.out.println("DEVICE NAME, IP ADDRESS, LAST COMMUNICATION TIME, SERIAL #, PAGE COUNT, BLACK TONER LEVEL, COLOR TONER LEVEL");
            System.out.println("--------------------------------------------------------------------------------------------------------------------");

            // Skip the header to avoid storage issues.
            br.readLine();

            // Store information obtained from CSV fil (1 line at a time.)
            while ((line = br.readLine()) != null)
            {
                String[] data = line.split(csvSplitBy);
                deviceList.add(new Printer(data[0], data[1], data[2], data[3], Integer.parseInt(data[4]), Integer.parseInt(data[5]), Integer.parseInt(data[6])));
            }
        }
        catch (IOException e) {e.printStackTrace();}
    }*/

    // Method used to obtain device information from CSV file.
    void createDeviceList(ObservableList<Printer> deviceList)
    {
        // Obtain information from CSV file
        try (BufferedReader br = new BufferedReader(new FileReader(csvFile)))
        {
            System.out.println("--------------------------------------------------------------------------------------------------------------------");
            System.out.println("File: " + fileName + " opened successfully!");
            System.out.println("--------------------------------------------------------------------------------------------------------------------");
            System.out.println("NOTE: When Adding devices to list, be sure to follow outline below. Information is separated by ,(comma)\n");
            System.out.println("WARNING: DO NOT REMOVE HEADER (FIRST LINE) FROM CSV FILE.");
            System.out.println("--------------------------------------------------------------------------------------------------------------------");
            System.out.println("DEVICE NAME, IP ADDRESS, LAST COMMUNICATION TIME, SERIAL #, PAGE COUNT, BLACK TONER LEVEL, COLOR TONER LEVEL");
            System.out.println("--------------------------------------------------------------------------------------------------------------------");

            // Skip the header to avoid storage issues.
            br.readLine();

            // Store information obtained from CSV fil (1 line at a time.)
            while ((line = br.readLine()) != null)
            {
                String[] data = line.split(csvSplitBy);
                deviceList.add(new Printer(data[0], data[1], data[2], data[3], Integer.parseInt(data[4]), Integer.parseInt(data[5]), Integer.parseInt(data[6])));
            }
        }
        catch (IOException e) {e.printStackTrace();}
    }
}