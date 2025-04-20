package listener;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebListener;
import java.io.*;
import java.nio.file.*;
import java.util.logging.*;

@WebListener
public class ImageInitListener implements ServletContextListener {
    
    private static final String PERMANENT_IMAGE_DIR = "D:\\college stuffs (please help i cant do this)\\gui\\GUI_ASS\\permanent_images";
    private static final Logger logger = Logger.getLogger(ImageInitListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        String deploymentPath = context.getRealPath("/Images");
        
        logger.info("Application starting - initializing product images");
        
        try {
            // Create directories if they don't exist
            File deploymentDir = new File(deploymentPath);
            if (!deploymentDir.exists()) {
                deploymentDir.mkdirs();
                logger.info("Created deployment image directory: " + deploymentPath);
            }
            
            File permanentDir = new File(PERMANENT_IMAGE_DIR);
            if (!permanentDir.exists()) {
                permanentDir.mkdirs();
                logger.info("Created permanent image directory: " + PERMANENT_IMAGE_DIR);
                return; // No images to copy yet
            }
            
            // Copy all images from permanent to deployment directory
            File[] imageFiles = permanentDir.listFiles();
            if (imageFiles != null) {
                int count = 0;
                for (File imageFile : imageFiles) {
                    if (imageFile.isFile()) {
                        Path source = imageFile.toPath();
                        Path destination = Paths.get(deploymentPath, imageFile.getName());
                        Files.copy(source, destination, StandardCopyOption.REPLACE_EXISTING);
                        count++;
                    }
                }
                logger.info("Successfully copied " + count + " product images to deployment directory");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initializing product images", e);
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do when application shuts down
    }
}