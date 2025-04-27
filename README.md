# PocketGadget E-Commerce Platform

An integrated e-commerce and inventory management system for tech gadgets and accessories, built using Java technologies.

---

## Requirements

- **NetBeans** (any reasonably recent version)
- **JDK 11**  
  Get it from [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) or [OpenLogic](https://www.openlogic.com/openjdk-downloads)
- **GlassFish 6.2.5**

---

## How to Run

1. **Clone the Repository**
   - Copy the repo URL:  
     `https://github.com/tbhidkmanlol/amit3094-assignment.git`
   - Open NetBeans → `Team > Git > Clone`
   - Paste the link in the *Repository URL* field
   - Select the **`master`** branch
   - Choose your local directory and a project name, then click **Finish**

2. **Set Up the Database**
   - Create a Derby database with:
     ```java
     String url = "jdbc:derby://localhost:1527/ass";
     String user = "nbuser";
     String password = "nbuser";
     ```

3. **Run the SQL File**
   - Open the **Files** tab (`Ctrl + 2` if it’s hidden)
   - Expand the project tree and locate the `.sql` file
   - Open it and set the connection to the above Derby database
   - Run the SQL script  
     *(Ignore any errors related to `DROP TABLE` – they’re harmless)*

4. **Build and Run**
   - Right-click the project → **Clean and Build**
   - Then right-click again → **Run**

---

## Tech Stack

- Java EE (JSP, JDBC, JPA)
- Apache Derby
- GlassFish 6.2.5
- NetBeans IDE
- HTML/CSS/JavaScript

---
