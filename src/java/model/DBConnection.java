/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() throws Exception {
        // 使用正确的 Derby 网络驱动
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        
        // 连接字符串
        String url = "jdbc:derby://localhost:1527/ass";
        String user = "nbuser";
        String password = "nbuser";
        
        System.out.println("尝试连接数据库: " + url);  // 调试输出
        Connection conn = DriverManager.getConnection(url, user, password);
        System.out.println("数据库连接成功！");
        return conn;
    }
}