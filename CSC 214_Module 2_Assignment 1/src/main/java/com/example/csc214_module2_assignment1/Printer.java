package com.example.csc214_module2_assignment1;

import java.util.Scanner;

public class Printer
{
    Scanner input = new Scanner(System.in);

    // Declare any variables needed for class.
    private String deviceName; // Name of print
    private String iPv4Address; // IP Address of printer
    private String lastCommunicationTime; // Last time printer communicated with system.
    private String serialNumber; // printer Serial number
    private int pageCount; // store total # of pages printed.
    private int blackCartridgeLevel; // Black toner level of printer
    private int colorCartridgeLevel; // Color toner level of printer

    // Constructors
    Printer(String deviceName, String iPv4Address, String lastCommunicationTime, String serialNumber, int pageCount, int blackCartridgeLevel, int colorCartridgeLevel)
    {
        this.deviceName = deviceName;
        this.iPv4Address = iPv4Address;
        this.lastCommunicationTime = lastCommunicationTime;
        this.serialNumber = serialNumber;
        this.pageCount = pageCount;
        this.blackCartridgeLevel = blackCartridgeLevel;
        this.colorCartridgeLevel = colorCartridgeLevel;
    }

    // Method used to obtain name of device
    String getDeviceName() {return this.deviceName;}

    // Method used to obtain IP Address
    String getiPv4Address() {return this.iPv4Address;}

    // Method used to obtain last communication time with device.
    String getLastCommunicationTime() {return this.lastCommunicationTime;}

    // Method used to obtain device serial number
    String getSerialNumber() {return this.serialNumber;}

    // Method used to obtain total pages printed on device
    int getPageCount() {return this.pageCount;}

    // Method used to obtain toner level for black cartridge.
    int getBlackCartridgeLevel() {return this.blackCartridgeLevel;}

    // Method used to obtain toner level for color cartridge.
    int getColorCartridgeLevel() {return this.colorCartridgeLevel;}


    // Method used to set name of device
    void setDeviceName(String deviceName) {this.deviceName = deviceName;}

    // Method used to set IP Address
    void setiPv4Address(String iPv4Address) {this.iPv4Address = iPv4Address;}

    // Method used to set last communication time with device.
    void setLastCommunicationTime(String lastCommunicationTime) {this.lastCommunicationTime = lastCommunicationTime;}

    // Method used to set device serial number
    void setSerialNumber(String serialNumber) {this.serialNumber = serialNumber;}

    // Method used to set total pages printed on device
    void setPageCount(int pageCount) {this.pageCount = pageCount;}

    // Method used to set toner level for black cartridge.
    void setBlackCartridgeLevel(int blackCartridgeLevel) {this.blackCartridgeLevel = blackCartridgeLevel;}

    // Method used to set toner level for color cartridge.
    void setColorCartridgeleveLevel(int colorCartridgeleveLevel) {this.colorCartridgeLevel = colorCartridgeleveLevel;}



    // Method to display information about gift card.
    public String toString() {return "Printer[Device Name: " + getDeviceName() + ", IPv4Address: " + getiPv4Address() + ", Last Communication Time: " + getLastCommunicationTime() + ", Serial #: " + getSerialNumber() + ", Page Count: " + getPageCount() + ", Black Cartrige Toner Level: " + getBlackCartridgeLevel() + "% , Color Cartridge: " + getColorCartridgeLevel() + "%]";}

    // Method to display device info on JavaFx
    public String menuDisplay(){return "Device Name: " + getDeviceName() + " --- Black Cartridge Toner Level: " + getBlackCartridgeLevel() + "% --- Color Cartridge Toner Level: " + getColorCartridgeLevel() +"% --- [SEE TERMINAL FOR MORE INFORMATION]";}

    // Method to display device info on Terminal
    public String terminalDisplay()
    {
        return "Device Name: " + getDeviceName() + "\nIPv4Address: " + getiPv4Address() + "\nLast Communication Time: " + getLastCommunicationTime() + "\nSerial #: " + getSerialNumber() + "\nPage Count: " + getPageCount() + "\nBlack Cartridge Toner Level: " + getBlackCartridgeLevel() + "%\nColor Cartridge Toner Level: " + getColorCartridgeLevel() + "%";
    }
}
