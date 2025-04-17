package controller;

import controller.DBConnection;
import java.sql.Connection;

public class DBTest {

    public static void main(String[] args) {
        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("Database connection successful!");
            conn.close();
        } catch (Exception e) {
            System.err.println("Connection failed:");
            e.printStackTrace();
        }
    }
}
