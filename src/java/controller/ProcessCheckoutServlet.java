/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ProcessCheckoutServlet")
public class ProcessCheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Here you would typically:
        // 1. Process the payment
        // 2. Save the order to database
        // 3. Clear the cart
        // 4. Redirect to order confirmation page
        
        // For now, just redirect to a confirmation page
        response.sendRedirect("order-confirmation.jsp");
    }
}