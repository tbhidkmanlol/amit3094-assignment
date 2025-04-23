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
        // Get all form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String apartment = request.getParameter("apartment");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String country = request.getParameter("country");
        String shippingOption = request.getParameter("shippingOption");
        
        // Get payment details
        String merchandiseSubtotal = request.getParameter("merchandiseSubtotal");
        String shippingSubtotal = request.getParameter("shippingSubtotal");
        String shippingSST = request.getParameter("shippingSST");
        String totalPayment = request.getParameter("totalPayment");
        
        // Store shipping address in session for later use
        request.getSession().setAttribute("shippingAddress", address);
        request.getSession().setAttribute("shippingCity", city);
        request.getSession().setAttribute("shippingState", state);
        request.getSession().setAttribute("shippingPostalCode", postalCode);
        request.getSession().setAttribute("shippingOption", shippingOption);
        
        // Forward all parameters to payment page
        StringBuilder redirectURL = new StringBuilder("payment.jsp?");
        redirectURL.append("firstName=").append(firstName)
                   .append("&lastName=").append(lastName)
                   .append("&email=").append(email)
                   .append("&address=").append(address)
                   .append("&city=").append(city)
                   .append("&state=").append(state)
                   .append("&postalCode=").append(postalCode)
                   .append("&country=").append(country)
                   .append("&shippingOption=").append(shippingOption)
                   .append("&merchandiseSubtotal=").append(merchandiseSubtotal)
                   .append("&shippingSubtotal=").append(shippingSubtotal)
                   .append("&shippingSST=").append(shippingSST)
                   .append("&totalPayment=").append(totalPayment);
        
        // Redirect to payment page with all parameters
        response.sendRedirect(redirectURL.toString());
    }
}