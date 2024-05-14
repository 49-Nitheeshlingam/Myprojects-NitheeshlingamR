<%-- 
    Document   : Payment1process
    Created on : Apr 21, 2024, 5:56:39 PM
    Author     : DELL
--%>
<%-- Your JSP code --%>

<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Processing</title>
</head>
<body>
    <%
        Connection conn = null;
        PreparedStatement stmt1 = null;
        PreparedStatement stmt2 = null;
        PreparedStatement stmt3 = null;
        PreparedStatement stmt4 = null;
        ResultSet rs = null; // Declare ResultSet in higher scope
        try {
            String amount = request.getParameter("amount");
            String mobileno = request.getParameter("mobileno");

            if (amount != null && mobileno != null) {
                int amount1 = Integer.parseInt(amount);
                long mobileno1 = Long.parseLong(mobileno);
                String driver = "com.mysql.cj.jdbc.Driver";
                String user = "administrator";
                String dbPassword = "Niti#@123";
                String url = "jdbc:mysql://localhost:3306/MyDB?useSSL=false&allowPublicKeyRetrieval=true";

                Class.forName(driver);
                conn = DriverManager.getConnection(url, user, dbPassword);

                // Check if the mobile number exists and has no current plan
                String checkQuery = "SELECT Current_PlanStatus FROM Customer_details WHERE MobileNo = ?";
                stmt1 = conn.prepareStatement(checkQuery);
                stmt1.setLong(1, mobileno1);
                rs = stmt1.executeQuery(); // Assign result to rs

                if (rs.next() && rs.getString("Current_PlanStatus").equals("no")) {
                    // Update user's plan status to 'yes'
                    String updateQuery = "UPDATE Customer_details SET Current_PlanStatus = 'yes' WHERE MobileNo = ?";
                    stmt2 = conn.prepareStatement(updateQuery);
                    stmt2.setLong(1, mobileno1);
                    int rowsAffected = stmt2.executeUpdate();
                    
                    String fetchPlanIdQuery = "SELECT Plan_id FROM Plan_Types WHERE amount = ?";
                    stmt3 = conn.prepareStatement(fetchPlanIdQuery);
                    stmt3.setInt(1, amount1);
                    ResultSet rs1 = stmt3.executeQuery();

                    int planId = 0;
                    if (rs1.next()) {
                        planId = rs1.getInt("Plan_id");
                    }

                    // Insert into Postpaid_customers table
                    String insertQuery = "INSERT INTO Postpaid_customers (Plan_id, Mobile_No, Bill_generateddate, Due_date) VALUES (?, ?, DATE_ADD(CURDATE(), INTERVAL 30 DAY), DATE_ADD(CURDATE(), INTERVAL 40 DAY))";
                    stmt4 = conn.prepareStatement(insertQuery);
                    stmt4.setInt(1, planId); // Example Plan_id
                    stmt4.setLong(2, mobileno1); // Corrected to use long type
                    int rowsInserted = stmt4.executeUpdate();

                    // Check if updates were successful
                    if (rowsAffected > 0 && rowsInserted > 0) {
                        out.println("<script>alert('Plan added successfully.'); window.location.href='index.html';</script>");
                    } else {
                        out.println("<script>alert('Error adding plan. Please try again.');</script>");
                    }
                } else {
                    out.println("<script>alert('Error: Mobile number does not exist or already has an active plan.');</script>");
                }
            } else {
                out.println("<script>alert('Error: Required parameters are missing.');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error processing payment. Please try again.');</script>");
        } finally {
            // Close resources in finally block
            try { if (rs != null) rs.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt1 != null) stmt1.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt2 != null) stmt2.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt3 != null) stmt3.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt4 != null) stmt4.close(); } catch (Exception e) { /* Ignored */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignored */ }
        }
    %>
</body>
</html>
