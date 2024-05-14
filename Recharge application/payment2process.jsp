<%-- 
    Document   : payment2process
    Created on : Apr 21, 2024, 9:41:56 PM
    Author     : DELL
--%><%@ page import="java.sql.*" %>
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
        PreparedStatement stmt4 = null;
        try {
            String amount = request.getParameter("amount");
            String mobileno = request.getParameter("mobileno");

            if (amount != null && mobileno != null) {
                double amount1 = Double.parseDouble(amount);
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
                    PreparedStatement stmt5 = conn.prepareStatement(updateuserBalanceQuery);
                    stmt5.setDouble(1, amount1);
                    stmt5.setLong(2, mobileno1);
                    int updateduserBalanceRows1 = stmt5.executeUpdate();
                    
                    // Update company's balance in Bank_accountdetails
                    String updateCompanyBalanceQuery = "UPDATE Bank_accountdetails SET Current_Balance = Current_Balance + ? WHERE MobileNo = ?";
                    PreparedStatement stmt6 = conn.prepareStatement(updateCompanyBalanceQuery);
                    stmt6.setDouble(1, amount1);
                    stmt6.setLong(2, 9999999999L); // Company's MobileNo
                    int updatedCompanyBalanceRows = stmt6.executeUpdate();

                    if (updateduserBalanceRows1 > 0 && updatedCompanyBalanceRows > 0) {
                        // Update Billstatus to "Yes" after successful payment
                        String updateBillStatusQuery = "UPDATE Postpaid_customers SET Billstatus = 'Yes' WHERE Mobile_No = ?";
                        PreparedStatement updateBillStatusStmt = conn.prepareStatement(updateBillStatusQuery);
                        updateBillStatusStmt.setLong(1, mobileno1);
                        int billStatusUpdated = updateBillStatusStmt.executeUpdate();

                        if (billStatusUpdated > 0) {
                            // Balance and Billstatus updated successfully
                            out.println("<script>alert('Payment Successful!');window.location.href='index.html';</script>");
                        } else {
                            // Error updating Billstatus
                            out.println("<script>alert('Error updating Billstatus. Please try again.');</script>");
                        }
                    } else {
                        // Error updating balance
                        out.println("<script>alert('Error updating balance. Please try again.');</script>");
                    }
                } else {
                    // Insufficient balance, display alert
                    out.println("<script>alert('Insufficient balance. Please recharge your account.');</script>");
                }

            } else {
                out.println("<script>alert('Error: Required parameters are missing.');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error processing payment. Please try again.');</script>");
        } finally {
            try { if (stmt4 != null) stmt4.close(); } catch (Exception e) { /* Ignored */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignored */ }
        }
    %>
</body>
</html>
