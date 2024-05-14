<%-- 
    Document   : paymentprocess.jsp
    Created on : Apr 20, 2024, 11:13:23 AM
    Author     : DELL
--%>

<%@ page import="java.sql.*"%>
<%@ page import="java.io.PrintWriter"%>
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
        try {
            String amount = request.getParameter("amount");
            String validity = request.getParameter("validity");
            String mobileno = request.getParameter("mobileno");

            if (amount != null && validity != null && mobileno != null) {
                int amount1 = Integer.parseInt(amount);
                int validity1 = Integer.parseInt(validity);
                long mobileno1 = Long.parseLong(mobileno);

                String driver = "com.mysql.cj.jdbc.Driver";
                String user = "administrator";
                String dbPassword = "Niti#@123";
                String url = "jdbc:mysql://localhost:3306/MyDB?useSSL=false&allowPublicKeyRetrieval=true";

                Class.forName(driver);
                conn = DriverManager.getConnection(url, user, dbPassword);

                
                // Check user's balance before deducting
                String fetchBalanceQuery = "SELECT Current_Balance FROM Bank_accountdetails WHERE MobileNo = ?";
                stmt4 = conn.prepareStatement(fetchBalanceQuery);
                stmt4.setLong(1, mobileno1);
                ResultSet rs2 = stmt4.executeQuery();

                double currentBalance = 0.0;
                if (rs2.next()) {
                    currentBalance = rs2.getDouble("Current_Balance");
                }

                if (currentBalance >= amount1) {
                    // Sufficient balance, proceed with the transaction
                    String updateuserBalanceQuery = "UPDATE Bank_accountdetails SET Current_Balance = Current_Balance - ? WHERE MobileNo = ?";
                    stmt4 = conn.prepareStatement(updateuserBalanceQuery);
                    stmt4.setDouble(1, amount1);
                    stmt4.setLong(2, mobileno1);
                    int updateduserBalanceRows1 = stmt4.executeUpdate();
                    // Update company's balance in Bank_accountdetails
                String updateCompanyBalanceQuery = "UPDATE Bank_accountdetails SET Current_Balance = Current_Balance + ? WHERE MobileNo = ?";
                PreparedStatement stmt5 = conn.prepareStatement(updateCompanyBalanceQuery);
                stmt5.setDouble(1, amount1);
                stmt5.setLong(2, 9999999999L); // Company's MobileNo
                int updatedCompanyBalanceRows = stmt5.executeUpdate();
                
                // Update user's plan status
                String updateQuery = "UPDATE Customer_details SET current_planstatus = ? WHERE MobileNo = ?";
                stmt1 = conn.prepareStatement(updateQuery);
                stmt1.setString(1, "yes");
                stmt1.setLong(2, mobileno1);
                int rowsAffected = stmt1.executeUpdate();

                // Fetch Plan ID based on Validity
                String fetchPlanIdQuery = "SELECT Plan_id FROM Plan_Types WHERE Validity = ?";
                stmt2 = conn.prepareStatement(fetchPlanIdQuery);
                stmt2.setInt(1, validity1);
                ResultSet rs1 = stmt2.executeQuery();

                int planId = 0;
                if (rs1.next()) {
                    planId = rs1.getInt("Plan_id");
                }

                // Insert into Prepaid_customers table
                String insertQuery = "INSERT INTO Prepaid_customers (Plan_id, Mobile_No, Start_date, End_date) VALUES (?, ?, CURDATE(), DATE_ADD(CURDATE(), INTERVAL ? DAY))";
                stmt3 = conn.prepareStatement(insertQuery);
                stmt3.setInt(1, planId);
                stmt3.setLong(2, mobileno1);
                stmt3.setInt(3, validity1);
                int rowsInserted = stmt3.executeUpdate();


                    if (updateduserBalanceRows1 > 0) {
                        // Balance updated successfully
                        out.println("<script>alert('Payment Successful!');window.location.href='index.html';</script>");
                    } else {
                        // Error updating balance
                        out.println("<script>alert('Error updating balance. Please try again.')</script>");
                    }
                } else {
                    // Insufficient balance, display alert
                    out.println("<script>alert('Insufficient balance. Please recharge your account.')</script>");
                }

            } else {
                out.println("<script>alert('Error: Required parameters are missing.')</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error processing payment. Please try again.')</script>");
        } finally {
            // Close resources in a finally block
            try { if (stmt1 != null) stmt1.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt2 != null) stmt2.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt3 != null) stmt3.close(); } catch (Exception e) { /* Ignored */ }
            try { if (stmt4 != null) stmt4.close(); } catch (Exception e) { /* Ignored */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignored */ }
        }
    %>
</body>
</html>
