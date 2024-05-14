<%-- 
    Document   : payBills
    Created on : Apr 21, 2024, 7:35:00 PM
    Author     : DELL
--%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View and Pay Bills</title>
    <link rel="stylesheet" href="pay.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body>
    <%
        try {
            String mobileno = request.getParameter("mobileno");

            if (mobileno != null) {
                long mobileno1 = Long.parseLong(mobileno);

                // Establish database connection
                String driver = "com.mysql.cj.jdbc.Driver";
                String user = "administrator";
                String dbPassword = "Niti#@123";
                String url = "jdbc:mysql://localhost:3306/MyDB?useSSL=false&allowPublicKeyRetrieval=true";

                Class.forName(driver);
                Connection conn = DriverManager.getConnection(url, user, dbPassword);

                // Check and update penalty if due date is less than current date
                String updatePenaltyQuery = "UPDATE Postpaid_customers SET Penalty = 100 WHERE Mobile_No = ? AND Due_date < CURDATE()";
                PreparedStatement updatePenaltyStmt = conn.prepareStatement(updatePenaltyQuery);
                updatePenaltyStmt.setLong(1, mobileno1);
                int penaltyUpdated = updatePenaltyStmt.executeUpdate();

                // Query to fetch data from Plan_Types and Postpaid_customers tables
                String query = "SELECT pt.Amount + pc.Penalty AS TotalAmount, pc.Bill_generateddate, pc.Due_date " +
                               "FROM Postpaid_customers pc " +
                               "INNER JOIN Plan_Types pt ON pc.Plan_id = pt.Plan_id " +
                               "WHERE pc.Mobile_No = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setLong(1, mobileno1);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    double totalAmount = rs.getDouble("TotalAmount");
                    Date billGeneratedDate = rs.getDate("Bill_generateddate");
                    Date dueDate = rs.getDate("Due_date");
    %>
                    <div class="box-container">
                        <div class="box">
                            <h1>View Bill Details</h1>
                            <h3>₹<%= totalAmount %></h3>
                            <p>Due start Date: <%= billGeneratedDate %></p>
                            <p>Due Date: <%= dueDate %></p>
                            <form action="payment2process.jsp" method="post">
                                <input type="hidden" name="amount" value="<%= totalAmount %>">
                                <input type="hidden" name="duestartdate" value="<%= billGeneratedDate %>">
                                <input type="hidden" name="mobileno" value="<%= mobileno %>">
                                <input type="hidden" name="dueenddate" value="<%= dueDate %>">
                                <button type="submit" class="btn">Pay ₹<%= totalAmount %></button>
                            </form>
                        </div>
                    </div>
    <%
                } else {
                    out.println("<p>No bill details found for the given mobile number.</p>");
                }

                // Close resources
                rs.close();
                pstmt.close();
                updatePenaltyStmt.close();
                conn.close();
            } else {
                out.println("<p>Error: Required parameters are missing.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error processing data.</p>");
        }
    %>
</body>
</html>
