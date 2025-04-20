<!<!--- Simply ignore it , just for testing -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Image Upload</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 500px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        .message { color: green; margin: 10px 0; }
        .error { color: red; margin: 10px 0; }
        .preview { max-width: 300px; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Upload Image to Server</h1>
        
        <%-- Display messages --%>
        <% if (request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="upload-image" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label>Select Image:</label>
                <input type="file" name="image" accept="image/*" required>
            </div>
            <button type="submit">Upload Image</button>
        </form>
        
        <%-- Show preview if upload was successful --%>
        <% if (request.getAttribute("imagePath") != null) { %>
            <h3>Uploaded Image:</h3>
            <img src="${pageContext.request.contextPath}/${imagePath}" class="preview">
            <p>Saved to: C:\Users\Dell\Desktop\LKK-GUI\web\Images</p>
        <% } %>
    </div>
</body>
</html>