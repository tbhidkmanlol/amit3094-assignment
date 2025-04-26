/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() throws Exception {
      
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        // link ur db here , please make it all same ( name : ass )
        String url = "jdbc:derby://localhost:1527/ass";
        String user = "nbuser";
        String password = "nbuser";
        
        System.out.println("Connecting to: " + url);  
        Connection conn = DriverManager.getConnection(url, user, password);
        System.out.println("Database connected successfully");
        return conn;
    }
}