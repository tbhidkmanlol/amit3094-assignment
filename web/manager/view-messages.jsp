<%@ page import="dao.MessageDAO, model.Messages, model.User, java.util.List, java.text.SimpleDateFormat" %>
<%
    // Authentication check - allow both ADMIN and MANAGER roles
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"MANAGER".equals(user.getRole()))) {
        response.sendRedirect("../login.jsp?error=unauthorized");
        return;
    }

    // Get filter parameters
    String searchQuery = request.getParameter("search");
    String statusFilter = request.getParameter("statusFilter");
    String sortOrder = request.getParameter("sortOrder");
    
    // Initialize with default values if null
    if (searchQuery == null) searchQuery = "";
    if (statusFilter == null) statusFilter = "all";
    if (sortOrder == null) sortOrder = "newest";
    
    // Get messages from database with filters
    List<Messages> messages = MessageDAO.getMessages(searchQuery, statusFilter, sortOrder);
    
    // Date formatting
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contact Messages</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f5f5f5;
                color: #333;
                line-height: 1.6;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #2c3e50;
                color: white;
                padding: 15px 20px;
                border-radius: 5px 5px 0 0;
            }

            header h1 {
                font-size: 24px;
            }

            .stats {
                display: flex;
                gap: 20px;
                margin: 20px 0;
            }

            .stat-card {
                background-color: white;
                border-radius: 5px;
                padding: 15px;
                flex: 1;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .stat-card h3 {
                font-size: 14px;
                color: #7f8c8d;
                margin-bottom: 5px;
            }

            .stat-card .value {
                font-size: 24px;
                font-weight: bold;
                color: #2c3e50;
            }

            .filters {
                display: flex;
                justify-content: space-between;
                margin: 20px 0;
                background-color: white;
                padding: 15px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .search {
                display: flex;
                gap: 10px;
            }

            input, select, button {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            button {
                background-color: #3498db;
                color: white;
                border: none;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            button:hover {
                background-color: #2980b9;
            }

            .messages-table {
                background-color: white;
                border-radius: 5px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                width: 100%;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #f2f2f2;
                font-weight: 600;
            }

            tr:hover {
                background-color: #f9f9f9;
            }

            .status {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .unread {
                background-color: #e74c3c;
                color: white;
            }

            .read {
                background-color: #2ecc71;
                color: white;
            }

            .action-buttons {
                display: flex;
                gap: 5px;
            }

            .action-button {
                padding: 5px 8px;
                font-size: 12px;
            }

            .view-button {
                background-color: #3498db;
            }

            .respond-button {
                background-color: #2ecc71;
            }

            .message-modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                align-items: center;
                justify-content: center;
            }

            .modal-content {
                background-color: white;
                padding: 20px;
                border-radius: 5px;
                width: 80%;
                max-width: 600px;
                max-height: 80vh;
                overflow-y: auto;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #ddd;
            }

            .close {
                font-size: 24px;
                cursor: pointer;
            }

            .message-details p {
                margin-bottom: 10px;
            }

            .message-content {
                background-color: #f9f9f9;
                padding: 15px;
                border-radius: 5px;
                margin: 15px 0;
                white-space: pre-line;
            }

            .response-area {
                margin-top: 20px;
            }

            textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                height: 100px;
                resize: vertical;
                margin-bottom: 10px;
            }
        </style>
    </head>
<body>
    <div class="container">
        <header>
            <h1>Contact Messages</h1>
            <div>
                <button id="refresh-button" onclick="location.reload()">Refresh</button>
            </div>
        </header>

        <div class="stats">
            <div class="stat-card">
                <h3>TOTAL MESSAGES</h3>
                <div class="value"><%= MessageDAO.getTotalMessagesCount() %></div>
            </div>
            <div class="stat-card">
                <h3>UNREAD MESSAGES</h3>
                <div class="value"><%= MessageDAO.getUnreadMessagesCount() %></div>
            </div>
        </div>

        <form class="filters" method="GET" action="view-messages.jsp" onsubmit="return false;">
            <div class="search">
                <input type="text" id="searchInput" name="search" placeholder="Search by name or email" value="<%= searchQuery != null ? searchQuery : "" %>" oninput="filterMessages()">
            </div>
            <div class="filter-options">
                <select name="statusFilter" id="statusFilter" onchange="applyFilters()">
                    <option value="all" <%= "all".equals(statusFilter) ? "selected" : "" %>>All Messages</option>
                    <option value="unread" <%= "unread".equals(statusFilter) ? "selected" : "" %>>Unread</option>
                    <option value="read" <%= "read".equals(statusFilter) ? "selected" : "" %>>Read</option>
                </select>
                <select name="sortOrder" id="sortOrder" onchange="applyFilters()">
                    <option value="newest" <%= "newest".equals(sortOrder) ? "selected" : "" %>>Newest First</option>
                    <option value="oldest" <%= "oldest".equals(sortOrder) ? "selected" : "" %>>Oldest First</option>
                </select>
            </div>
        </form>

        <div class="messages-table">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Message</th>
                    </tr>
                </thead>
                <tbody id="messagesTableBody">
    <% if (messages.isEmpty()) { %>
        <tr>
            <td colspan="7" style="text-align: center;">No messages found</td>
        </tr>
    <% } else { 
        for (Messages msg : messages) { 
            String status = (msg != null && !msg.isRead()) ? "unread" : "read";
%>
            <tr>
                <td><%= msg.getId() %></td>
                <td class="msg-name"><%= msg.getFirstName() %> <%= msg.getLastName() %></td>
                <td class="msg-email"><%= msg.getEmail() %></td>
                <td><%= msg.getPhone() %></td>
                <td><%= dateFormat.format(msg.getSubmissionDate()) %></td>
                <td>
                    <span class="status <%= status %>">
                        <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                    </span>
                    <% if ("unread".equals(status)) { %>
                        <input type="checkbox" title="Mark as Read" onchange="markAsRead(<%= msg.getId() %>, this)" />
                    <% } %>
                </td>
                <td class="msg-message"><%= msg.getMessage() %></td>
            </tr>
<%  } 
    } %>
</tbody>
            </table>
        </div>
    </div>

    <script>
var contextPath = '<%= request.getContextPath() %>';
let currentMessageId = null;

function markAsRead(messageId, checkbox) {
    if (checkbox.checked) {
        fetch('/amit3094-assignment/MarkAsReadServlet?id=' + messageId, { method: 'POST' })
            .then(response => {
                if (response.ok) {
                    // Update UI: change status to 'Read', remove checkbox
                    const statusSpan = checkbox.parentElement.querySelector('.status');
                    statusSpan.textContent = 'Read';
                    statusSpan.className = 'status read';
                    checkbox.remove();
                } else {
                    alert('Failed to mark as read.');
                    checkbox.checked = false;
                }
            })
            .catch(() => {
                alert('Failed to mark as read.');
                checkbox.checked = false;
            });
    }
}

function filterMessages() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#messagesTableBody tr');
    let anyVisible = false;
    rows.forEach(row => {
        const name = row.querySelector('.msg-name')?.textContent.toLowerCase() || '';
        const email = row.querySelector('.msg-email')?.textContent.toLowerCase() || '';
        if (name.includes(input) || email.includes(input)) {
            row.style.display = '';
            anyVisible = true;
        } else {
            row.style.display = 'none';
        }
    });
    // Show a message if no results
    const noMsgRow = document.getElementById('noMsgRow');
    if (!anyVisible) {
        if (!noMsgRow) {
            const tr = document.createElement('tr');
            tr.id = 'noMsgRow';
            tr.innerHTML = '<td colspan="7" style="text-align: center;">No messages found</td>';
            document.getElementById('messagesTableBody').appendChild(tr);
        }
    } else if (noMsgRow) {
        noMsgRow.remove();
    }
}

function applyFilters() {
    const status = document.getElementById('statusFilter').value;
    const sort = document.getElementById('sortOrder').value;
    const search = document.getElementById('searchInput').value;
    const params = new URLSearchParams({
        statusFilter: status,
        sortOrder: sort,
        search: search
    });
    window.location = 'view-messages.jsp?' + params.toString();
}
    </script>
</body>
</html>