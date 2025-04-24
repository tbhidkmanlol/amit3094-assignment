<%@ page import="dao.OrderDAO, model.SalesReport, model.TopProduct, model.User, java.util.List, java.util.Map, java.util.HashMap, java.text.SimpleDateFormat, java.util.Date, java.util.Calendar, java.text.DecimalFormat" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"MANAGER".equals(user.getRole())) {
        response.sendRedirect("../login.jsp?error=unauthorized");
        return;
    }
    
    // Get query parameters
    String periodType = request.getParameter("periodType");
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    
    // Set default values
    if (periodType == null || periodType.isEmpty()) {
        periodType = "month"; // Default to monthly view
    }
    
    // If no date is set, use the current month
    if (startDate == null || startDate.isEmpty()) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        startDate = dateFormat.format(cal.getTime());
        
        cal.add(Calendar.MONTH, 1);
        cal.add(Calendar.DAY_OF_MONTH, -1);
        endDate = dateFormat.format(cal.getTime());
    }
    
    // Get sales data
    List<SalesReport> salesData = OrderDAO.getSalesByDate(periodType, startDate, endDate);
    
    // Get top selling products
    List<TopProduct> topProducts = OrderDAO.getTopSellingProducts(10);
    
    // Format currency
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
    // Summary data
    double totalRevenue = 0;
    int totalOrders = 0;
    int totalProducts = 0;
    
    // Calculate totals
    Map<Integer, Boolean> uniqueOrders = new HashMap<>();
    
    try {
        for (SalesReport report : salesData) {
            totalRevenue += report.getSubtotal();
            totalProducts += report.getQuantity();
            
            // Count unique orders
            if (!uniqueOrders.containsKey(report.getOrderId())) {
                uniqueOrders.put(report.getOrderId(), true);
                totalOrders++;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #4a6cf7;
            --secondary-color: #6580e2;
            --text-color: #333;
            --light-gray: #f5f5f5;
            --medium-gray: #ddd;
            --dark-gray: #888;
            --border-color: #e0e0e0;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            color: var(--text-color);
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .header h1 {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 24px;
            color: var(--primary-color);
            margin: 0;
        }
        
        .header-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }
        
        .filter-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .filter-section h2 {
            font-size: 18px;
            margin-top: 0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .filter-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            color: var(--dark-gray);
        }
        
        .form-group select,
        .form-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            font-size: 14px;
        }
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .summary-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .summary-card .title {
            font-size: 14px;
            color: var(--dark-gray);
            margin-bottom: 10px;
        }
        
        .summary-card .value {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .data-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .data-section h2 {
            font-size: 18px;
            margin-top: 0;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--medium-gray);
        }
        
        th {
            background-color: var(--light-gray);
            font-weight: 500;
        }
        
        tbody tr:hover {
            background-color: var(--light-gray);
        }
        
        .top-products {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .product-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .product-rank {
            width: 30px;
            height: 30px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
        }
        
        .product-info {
            flex: 1;
        }
        
        .product-name {
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .product-stats {
            display: flex;
            gap: 10px;
            font-size: 13px;
            color: var(--dark-gray);
        }

        /* New styles for charts */
        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }
        
        .chart-panel {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .chart-panel h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: var(--primary-color);
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
        }
        
        @media (max-width: 768px) {
            .chart-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media print {
            .chart-grid {
                grid-template-columns: 1fr 1fr;
            }
            .chart-panel {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-chart-line"></i> Sales Reports</h1>
            <div class="header-actions">
                <a href="dashboard.jsp" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
                <a href="#" class="btn" onclick="window.print()"><i class="fas fa-print"></i> Print Report</a>
            </div>
        </div>
        
        <div class="filter-section">
            <h2><i class="fas fa-filter"></i> Filter Options</h2>
            <form class="filter-form" method="GET" action="sales-report.jsp">
                <div class="form-group">
                    <label>Period Type</label>
                    <select name="periodType">
                        <option value="day" <%= "day".equals(periodType) ? "selected" : "" %>>Daily</option>
                        <option value="month" <%= "month".equals(periodType) ? "selected" : "" %>>Monthly</option>
                        <option value="year" <%= "year".equals(periodType) ? "selected" : "" %>>Yearly</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Start Date</label>
                    <input type="date" name="startDate" value="<%= startDate %>">
                </div>
                <div class="form-group">
                    <label>End Date</label>
                    <input type="date" name="endDate" value="<%= endDate %>">
                </div>
                <button type="submit" class="btn"><i class="fas fa-search"></i> Search</button>
            </form>
        </div>
        
        <div class="summary-cards">
            <div class="summary-card">
                <div class="title">Total Revenue</div>
                <div class="value">RM <%= df.format(totalRevenue) %></div>
            </div>
            <div class="summary-card">
                <div class="title">Order Count</div>
                <div class="value"><%= totalOrders %></div>
            </div>
            <div class="summary-card">
                <div class="title">Products Sold</div>
                <div class="value"><%= totalProducts %></div>
            </div>
            <div class="summary-card">
                <div class="title">Average Order Value</div>
                <div class="value">RM <%= totalOrders > 0 ? df.format(totalRevenue / totalOrders) : "0.00" %></div>
            </div>
        </div>
        
        <div class="data-section">
            <h2><i class="fas fa-table"></i> Sales Data</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Order Number</th>
                        <th>Payment Method</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Unit Price (RM)</th>
                        <th>Subtotal (RM)</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (salesData.isEmpty()) { %>
                        <tr>
                            <td colspan="7" style="text-align: center;">No sales records found for the selected period</td>
                        </tr>
                    <% } else { 
                        for (SalesReport report : salesData) {
                            // Format date
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            String formattedDate = sdf.format(report.getOrderDate());
                    %>
                        <tr>
                            <td><%= formattedDate %></td>
                            <td><%= report.getOrderNumber() %></td>
                            <td><%= report.getPaymentMethod() %></td>
                            <td><%= report.getProductName() %></td>
                            <td><%= report.getQuantity() %></td>
                            <td><%= df.format(report.getPricePerUnit()) %></td>
                            <td><%= df.format(report.getSubtotal()) %></td>
                        </tr>
                    <% } 
                    } %>
                </tbody>
            </table>
        </div>
        
        <!-- New section for product performance charts -->
        <div class="data-section">
            <h2><i class="fas fa-chart-pie"></i> Product Performance</h2>
            
            <div class="chart-grid">
                <!-- Top Products by Revenue Chart -->
                <div class="chart-panel">
                    <h3><i class="fas fa-chart-bar"></i> Top Products by Revenue</h3>
                    <div class="chart-container">
                        <canvas id="topProductsChart"></canvas>
                    </div>
                </div>
                
                <!-- Payment Method Distribution Chart -->
                <div class="chart-panel">
                    <h3><i class="fas fa-credit-card"></i> Payment Method Distribution</h3>
                    <div class="chart-container">
                        <canvas id="paymentMethodsChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="data-section">
            <h2><i class="fas fa-award"></i> TOP 10 Selling Products</h2>
            <div class="top-products">
                <% if (topProducts.isEmpty()) { %>
                    <p>No sales data available</p>
                <% } else { 
                    int rank = 1;
                    for (TopProduct product : topProducts) {
                %>
                    <div class="product-card">
                        <div class="product-rank"><%= rank++ %></div>
                        <div class="product-info">
                            <div class="product-name"><%= product.getProductName() %></div>
                            <div class="product-stats">
                                <span><i class="fas fa-box"></i> Quantity: <%= product.getTotalQuantitySold() %></span>
                                <span><i class="fas fa-money-bill-wave"></i> Revenue: RM <%= df.format(product.getTotalRevenue()) %></span>
                            </div>
                        </div>
                    </div>
                <% } 
                } %>
            </div>
        </div>
    </div>
    
    <!-- Add Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Initialize charts -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            <% if (!salesData.isEmpty()) { 
                // Get payment method data
                Map<String, Double> paymentMethods = new HashMap<>();
                for (SalesReport report : salesData) {
                    String method = report.getPaymentMethod();
                    paymentMethods.put(method, paymentMethods.getOrDefault(method, 0.0) + report.getSubtotal());
                }
            %>
                // Payment Methods Pie Chart
                const paymentCtx = document.getElementById('paymentMethodsChart').getContext('2d');
                
                const paymentLabels = [
                    <% for (String method : paymentMethods.keySet()) { %>
                        '<%= method %>',
                    <% } %>
                ];
                
                const paymentData = [
                    <% for (Double amount : paymentMethods.values()) { %>
                        <%= amount %>,
                    <% } %>
                ];
                
                const paymentColors = ['#4a6cf7', '#36a2eb', '#ff6384', '#ff9f40'];
                
                new Chart(paymentCtx, {
                    type: 'pie',
                    data: {
                        labels: paymentLabels,
                        datasets: [{
                            data: paymentData,
                            backgroundColor: paymentColors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    boxWidth: 12,
                                    padding: 20
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = Math.round((value / total) * 100);
                                        return `${label}: RM ${value.toFixed(2)} (${percentage}%)`;
                                    }
                                }
                            }
                        }
                    }
                });
            <% } %>
            
            <% if (!topProducts.isEmpty()) { %>
                // Top Products Horizontal Bar Chart
                const productCtx = document.getElementById('topProductsChart').getContext('2d');
                
                const productNames = [
                    <% for (TopProduct product : topProducts) { %>
                        '<%= product.getProductName() %>',
                    <% } %>
                ];
                
                const productRevenues = [
                    <% for (TopProduct product : topProducts) { %>
                        <%= product.getTotalRevenue() %>,
                    <% } %>
                ];
                
                new Chart(productCtx, {
                    type: 'bar',
                    data: {
                        labels: productNames,
                        datasets: [{
                            label: 'Revenue (RM)',
                            data: productRevenues,
                            backgroundColor: '#4a6cf7',
                            borderColor: '#4a6cf7',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Revenue (RM)'
                                }
                            },
                            y: {
                                ticks: {
                                    autoSkip: false
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            }
                        },
                        barPercentage: 0.6
                    }
                });
            <% } %>
        });
    </script>
</body>
</html>