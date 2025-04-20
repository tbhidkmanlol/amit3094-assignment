package controller;

import dao.ImageDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/image/*")
public class ImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        // Extract image ID from URL path
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.length() < 2) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required");
            return;
        }
        
        // Parse the image ID from the URL
        int imageId;
        try {
            imageId = Integer.parseInt(pathInfo.substring(1));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image ID format");
            return;
        }
        
        // Retrieve image data from database
        byte[] imageData = ImageDAO.getImageById(imageId);
        
        // Send image to client if found
        if (imageData != null) {
            // Try to determine content type based on image data
            String contentType = getServletContext().getMimeType("image.jpg");
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            
            response.setContentType(contentType);
            response.setContentLength(imageData.length);
            
            try (OutputStream out = response.getOutputStream()) {
                out.write(imageData);
            }
        } else {
            // If image not found, send 404 error or redirect to default image
            String defaultImagePath = request.getContextPath() + "/Images/default.jpg";
            response.sendRedirect(defaultImagePath);
        }
    }
}