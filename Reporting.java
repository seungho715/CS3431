//Phase 3 - Group 10 - Ken Snoddy, Seungho Lee

import java.util.Scanner;
import java.sql.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class part3 {
    public static void main(String[] argv){
        int numArgs = argv.length;

        if(numArgs <2 || numArgs > 3)
        {
            System.out.println("Wong num of arguments");
            System.out.println("Example: >java Reporting <username> <password> [option]");
            System.exit(-1);
        }
        String username = argv[0];
        String password = argv[1];

        Connection c = connectToDatabase(username, password);

        if(numArgs == 2)
        {
            System.out.println("print everything");
            reportUserOptions();
        }
        else
        {
            Scanner s = new Scanner(System.in);
            int tries;
            switch(Integer.parseInt(argv[2])){
                case 1:
                    String regex = "^[0-9]{3}-[0-9]{2}-[0-9]{4}$";
                    Pattern pat = Pattern.compile(regex);
                    String patSSN = null;

                    tries = 3;

                    while(tries > 0)
                    {
                        System.out.println("Enter Patient SSN (Example: 000-00-0000): ");
                        patSSN = s.nextLine();

                        Matcher m = pat.matcher(patSSN);
                        if(!m.matches())
                        {
                            System.out.println("SSN must be in format " +tries-- + " tries left");
                        }
                        else
                            break;
                        if(tries == 0)
                        {
                            System.out.println("Too many tries...");
                            try{
                                c.close();
                            }catch(SQLException e){
                                e.printStackTrace();
                            }
                            System.exit(-1);
                        }
                    }

                    reportPatientBasicInfo(c, patSSN);

                    try{
                        c.close();
                    }catch(SQLException e){
                        e.printStackTrace();
                    }

                    break;

                case 2:
                    String docID = null;
                    tries = 3;

                    while(tries >0)
                    {
                        System.out.println("Enter Doctor ID: ");
                        docID = s.nextLine();

                        if(isInteger(docID) == -1)
                            System.out.println("DoctorID must be valid " + tries-- + " tries left");
                        else
                            break;
                        if(tries == 0)
                        {
                            System.out.println("Too many tries");
                            try{
                                c.close();
                            }catch(SQLException e){
                                e.printStackTrace();
                            }
                            System.exit(-1);
                        }
                    }

                    reportDocBasicInfo(c, Integer.parseInt(docID));

                    try{
                        c.close();
                    }catch(SQLException e){
                        e.printStackTrace();
                    }

                    break;
                case 3:
                    String adminNum = null;
                    tries = 3;

                    while(tries > 0)
                    {
                        System.out.println("Enter adminNum: ");
                        adminNum = s.nextLine();

                        if(isInteger(adminNum) == -1)
                            System.out.println("adminNum must be valid " + tries-- + " tries left");
                        else
                            break;
                        if(tries == 0)
                        {
                            System.out.println("Too many tries");
                            try{
                                c.close();
                            }catch(SQLException e){
                                e.printStackTrace();
                            }
                            System.exit(-1);
                        }
                    }

                    reportAdminInfo(c, Integer.parseInt(adminNum));

                    try{
                        c.close();
                    }catch(SQLException e){
                        e.printStackTrace();
                    }

                    break;

                case 4:
                    String mAdminNum = null;
                    tries = 3;

                    while(tries > 0)
                    {
                        System.out.println("Enter Admission Number: ");
                        mAdminNum = s.nextLine();

                        if(isInteger(mAdminNum) == -1)
                            System.out.println("mAdminNum must be valid " + tries-- + " tries left");
                        else
                            break;
                        if(tries == 0)
                        {
                            System.out.println("Too many tries");
                            try{
                                c.close();
                            }catch(SQLException e){
                                e.printStackTrace();
                            }
                            System.exit(-1);
                        }
                    }

                    String newTotalPayment = null;
                    tries = 3;

                    while(tries > 0)
                    {
                        System.out.println("Enter new total payment: ");
                        newTotalPayment = s.nextLine();

                        if(isInteger(newTotalPayment) == -1)
                            System.out.println("Total Payment must be valid " + tries-- + " tries left");
                        else
                            break;

                        if(tries == 0)
                        {
                            System.out.println("Too many tries");
                            try{
                                c.close();
                            }catch(SQLException e){
                                e.printStackTrace();
                            }
                            System.exit(-1);
                        }
                    }

                    updateAdminPayment(c, Integer.parseInt(mAdminNum), Integer.parseInt(newTotalPayment));

                    try{
                        c.close();
                    }catch(SQLException e){
                        e.printStackTrace();
                    }
                    break;
                default:
                    System.out.println("Option argument can only be from 1-4");
                    try{
                        c.close();
                    }catch(SQLException e){
                        e.printStackTrace();
                    }
                    System.exit(-1);
            }
        }
    }

    private static void reportUserOptions(){
        System.out.println("Inside of reportUserOptions!");
        System.out.println("Welcome to Alexander Antaya & Leo Gonsalve's Program!\n\n" +
                "Example: >java Reporting <username> <password> [option]\n" +
                "1 -- Report Patients Basic Information\n" +
                "2 -- Report Doctors Basic Information\n" +
                "3 -- Report Admissions Information\n" +
                "4 -- Update Admissions Payment\n");
    }

    private static void reportPatientBasicInfo(Connection c, String ssn){
        try{
            PreparedStatement stmt = c.prepareStatement("SELECT * FROM Patient Where ssn=?"); // Empty statement object
            stmt.setString(1,ssn);
            ResultSet rset = stmt.executeQuery();

            String mSsn = "";
            String firstName = "";
            String lastName = "";
            String address = "";
/*
            //The query did not find any results
            if(!rset.isBeforeFirst()){
                System.out.println("That query did not return any results!");

                // Close Statements
                rset.close();
                stmt.close();
                c.close();

                System.exit(1);
            }
*/
            // Process the results
            while (rset.next()) { // Runs through results row by row
                // Sets column names and assigns values to them
                mSsn = rset.getString("SSN");
                firstName = rset.getString("FirstName");
                lastName = rset.getString("LastName");
                address = rset.getString("Address");

                if(!mSsn.equals(ssn)){
                    System.out.println("Problem with database... Exiting.");
                    System.exit(-1);
                }

                // Print Patient Information
                System.out.println("\nBasic Patient Information\n" +
                        "SSN: " + ssn + "\n" +
                        "First Name: " + firstName + "\n" +
                        "Last name: " + lastName + "\n" +
                        "Address: " + address + "\n");
            }

            // Close Statements
            rset.close();
            stmt.close();
            c.close();

        }catch (SQLException e){
            System.out.println("Failed to communicate with database... Exiting.");
            e.printStackTrace();
            System.exit(-1);
        }
    }

    private static void reportDocBasicInfo(Connection c, int doctorId){
        try{
            PreparedStatement stmt = c.prepareStatement("SELECT *  FROM Doctor WHERE DoctorID=?"); // Empty statement object
            stmt.setInt(1,doctorId);
            ResultSet rset = stmt.executeQuery();

            int mDoctorId = -1;
            String firstName = "";
            String lastName = "";
            String gender = "";
/*
            //The query did not find any results
            if(!rset.isBeforeFirst()){
                System.out.println("That query did not return any results!");

                // Close Statements
                rset.close();
                stmt.close();
                c.close();

                System.exit(1);
            }*/
            // Process the results
            while (rset.next()) { // Runs through results row by row
                mDoctorId = rset.getInt("DoctorID");
                firstName = rset.getString("FirstName");
                lastName = rset.getString("LastName");
                gender = rset.getString("Gender");

                if(mDoctorId != doctorId){
                    System.out.println("Problem with database... Exiting.");
                    System.exit(-1);
                }

                // Print Patient Information
                System.out.println("\nBasic Doctor Information\n" +
                        "Doctor ID: " + doctorId + "\n" +
                        "First Name: " + firstName + "\n" +
                        "Last name: " + lastName + "\n" +
                        "Gender: " + gender + "\n");
            }

            // Close Statements
            rset.close();
            stmt.close();
            c.close();

        }catch (SQLException e){
            System.out.println("Failed to communicate with database... Exiting.");
            e.printStackTrace();
            /*
            try {
                c.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }*/
            System.exit(-1);
        }
    }

    private static void reportAdminInfo(Connection c, int admissionId){
        try{
            //-----First Part of Query
            PreparedStatement stmt = c.prepareStatement("SELECT * FROM Admission WHERE AdminID=?"); // Empty statement object
            stmt.setInt(1,admissionId);
            ResultSet rset = stmt.executeQuery();
/*
            //The query did not find any results
            if(!rset.isBeforeFirst()){
                System.out.println("That query 1 did not return any results!");

                // Close Statements
                rset.close();
                stmt.close();
                c.close();

                System.exit(1);
            }*/

            // Initialize Columns
            String patient = "";
            String admissionDate = "";
            int totalPayment = -1;

            // Process the results for first query
            while (rset.next()) { // Runs through results row by row
                patient = rset.getString("PatientSSN");
                admissionDate = rset.getString("AdminDate");
                totalPayment = rset.getInt("TotalPayment");
            }

            //-----Second Part of Query
            stmt = c.prepareStatement("SELECT * FROM StaysIn WHERE AdmissionAdminID=?"); // Empty statement object
            stmt.setInt(1,admissionId);
            rset = stmt.executeQuery();
/*
            //The query did not find any results
            if(!rset.isBeforeFirst()){
                System.out.println("That query 2 did not return any results!");

                // Close Statements
                rset.close();
                stmt.close();
                c.close();

                System.exit(1);
            }*/

            // Initialize Columns
            int roomNum = -1;
            String startTime = "";
            String endTime = "";

            // String to hold all room results in proper format
            String rooms = "";

            // Process the results for first query
            while (rset.next()) { // Runs through results row by row
                roomNum = rset.getInt("RoomNumber");
                startTime = rset.getString("StartDate");
                endTime = rset.getString("EndDate");

                rooms += "\tRoomNum: " + roomNum + "\tFromDate: " + startTime + "\tToDate: " + endTime + "\n";
            }


            //-----Third Part of Query
            stmt = c.prepareStatement("SELECT DoctorID FROM Examines WHERE AdmissionAdminID=?"); // Empty statement object
            stmt.setInt(1,admissionId);
            rset = stmt.executeQuery();
/*
            //The query did not find any results
            if(!rset.isBeforeFirst()){
                System.out.println("That query 3 did not return any results!");

                // Close Statements
                rset.close();
                stmt.close();
                c.close();

                System.exit(1);
            }*/

            // Initialize Columns
            int doctorId = -1;

            // String to hold all doctor results in proper format
            String doctors = "";

            // Process the results for first query
            while (rset.next()) { // Runs through results row by row
                doctorId = rset.getInt("DoctorID");
                doctors += "\tDoctor ID: " + doctorId + "\n";
            }

            // Finished Queries, Print Admission Information
            System.out.println("\nAdmission Information\n" +
                    "Admission ID: " + admissionId + "\n" +
                    "Patient SSN: " + patient + "\n" +
                    "Admission Date (Start Date): " + admissionDate + "\n" +
                    "Total Payment: " + totalPayment + "\n" +
                    "Rooms: \n" +
                    rooms +
                    "Doctors examined the patient in this admission: \n" +
                    doctors);

            // Close Statements
            rset.close();
            stmt.close();
            c.close();

        }catch (SQLException e){
            System.out.println("Failed to communicate with database... Exiting.");
            e.printStackTrace();
/*
            try {
                c.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }*/

            System.exit(-1);
        }
    }

    private static void updateAdminPayment(Connection c, int admissionId, int newPaymentTotal){
        try{
            PreparedStatement stmt = c.prepareStatement("Update Admission SET TotalPayment=? WHERE AdminID=?"); // Empty statement object
            stmt.setInt(1, newPaymentTotal);
            stmt.setInt(2,admissionId);
            int count = stmt.executeUpdate();

            //If count is 0 then no rows were effected so we failed to update successfully
            if(!(count > 0)){
                System.out.println("That query did not effect any rows");
                System.exit(1);
            }

            System.out.println("\nUpdated total cost to " + newPaymentTotal + " for Admission ID " + admissionId + "!");

            // Close Statements
            stmt.close();
            c.close();

        }catch (SQLException e){
            System.out.println("Failed to communicate with database... Exiting.");
            e.printStackTrace();
/*
            try {
                c.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }*/

            System.exit(-1);
        }
    }

    //-----Helper methods-----//

    //Helper method to connect to db. Will terminate program if connection is not successful.
    public static Connection connectToDatabase(String username, String password){
        System.out.println("-------Oracle JDBC Connection Testing ---------");

        // Register the driver
        try { Class.forName("oracle.jdbc.driver.OracleDriver");}
        catch (ClassNotFoundException e) {
            System.out.println("Could not register JDBC driver");
            e.printStackTrace();
            System.exit(-1);
        }

        System.out.println("Oracle JDBC Driver Registered!");

        Connection connection = null;

        // Establish Connection to DB
        try {
            connection = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", username, password);
        }catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            System.exit(-1);
        }

        // Print Connection Success!
        System.out.println("Oracle JDBC Driver Connected!");
        System.out.println("Connection:" + connection);

        return connection;
    }

    //Helper method to ensure that a string (usually from std_in) is a valid Integer before passing to other methods
    public static int isInteger(String s) {
        int retVal;
        try {
            retVal = Integer.parseInt(s);
        } catch(NumberFormatException e) {
            return -1;
        } catch(NullPointerException e) {
            return -1;
        }
        // only got here if we didn't return false
        return retVal;
    }
}



