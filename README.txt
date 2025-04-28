PocketGadget E-Commerce Platform

An integrated e-commerce and inventory management system for tech gadgets and accessories, built using Java technologies.

---

Requirements:
- NetBeans (any reasonably recent version)
- JDK 11 (can be downloaded from Oracle or OpenLogic)
- GlassFish 6.2.5

---

How to Run:

1. Download the Project Files:
   - Obtain the PocketGadget source files (e.g., via ZIP file or direct download).
   - Extract the files to a local directory.

2. Import the Project into NetBeans:
   - Open NetBeans and go to File > Open Project.
   - Navigate to the directory where you extracted the files and select the PocketGadget project folder.
   - Click "Open Project" to import the project into NetBeans.

3. Set Up the Database:
   - Create a Derby database with the following credentials:
     String url = "jdbc:derby://localhost:1527/ass";
     String user = "nbuser";
     String password = "nbuser";

4. Run the SQL File:
   - In NetBeans, open the "Files" tab (Ctrl + 2 if it's hidden).
   - Expand the project structure and find the .sql file.
   - Open the file and set the connection to the Derby database URL mentioned above.
   - Run the SQL script.
   - If you see errors related to "DROP TABLE", you can ignore them.

5. Build and Run the Project:
   - Right-click the project in the "Projects" tab and select "Clean and Build".
   - After the build completes, right-click again and select "Run" to start the project.

---

Tech Stack:
- Java EE (JSP, JDBC, JPA)
- Apache Derby
- GlassFish 6.2.5
- NetBeans IDE
- HTML/CSS/JavaScript

---

Troubleshooting:
- "Connection to the database failed":
  - Solution: Make sure the Derby database is running and accessible at jdbc:derby://localhost:1527/ass.

- Errors when running SQL script:
  - Solution: Ignore errors related to "DROP TABLE"; these are non-critical.