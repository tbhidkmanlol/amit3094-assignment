<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sales Report</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            position: sticky;
            top: 0;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <h1>Sales Report</h1>
    
    <table>
        <thead>
            <tr>
                <th>Last Name</th>
                <th>Email</th>
                <th>Address</th>
                <th>Order ID</th>
                <th>Product Name</th>
                <th>Quantity</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="record" items="${salesRecords}">
                <tr>
                    <td>${record.lastName}</td>
                    <td>${record.email}</td>
                    <td>${record.address}</td>
                    <td>${record.orderId}</td>
                    <td>${record.productName}</td>
                    <td>${record.quantity}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>