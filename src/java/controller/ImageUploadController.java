package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet("/upload-image")
@MultipartConfig
public class ImageUploadController extends HttpServlet {
    
    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Use your EXACT image folder path
        String basePath = getServletContext().getRealPath("/Images");
        File uploadDir = new File(basePath);
        
        // 2. Create directory if needed
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            // 3. Get the uploaded file
            Part filePart = request.getPart("image");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // 4. Create simple output file
            File outputFile = new File(uploadDir, System.currentTimeMillis() + "_" + fileName);
            
            // 5. Manual file copy (bypasses GlassFish path issues)
            try (InputStream input = filePart.getInputStream();
                 OutputStream output = new FileOutputStream(outputFile)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }
            
            // 6. Prepare response
            request.setAttribute("message", "Image uploaded successfully!");
            request.setAttribute("imagePath", "Images/" + outputFile.getName());
            
        } catch (Exception e) {
            request.setAttribute("error", "Upload failed: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("upload-image.jsp").forward(request, response);
    }
}