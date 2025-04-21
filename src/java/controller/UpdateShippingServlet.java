/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author wonghx
 */

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateShippingServlet")
public class UpdateShippingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String shippingOption = request.getParameter("shippingOption");
        request.getSession().setAttribute("shippingOption", shippingOption);
        
        // Redirect back to checkout page
        response.sendRedirect("Checkout.jsp");
    }
}
