<%-- 
    Document   : Payment
    Created on : 19-Apr-2024, 7:56:07?pm
    Author     : DELL
--%><%-- Payment.jsp --%>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="pay.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <title>Payment Method</title>
    <link rel="stylesheet" href="pay.css">
</head>
<body>
    <%
        try {
            String amount = request.getParameter("amount");
            String validity = request.getParameter("validity");
            String data = request.getParameter("data");

            if (amount != null && validity != null && data != null) {
                int amount1 = Integer.parseInt(amount);
                int validity1 = Integer.parseInt(validity);
                double data1 = Double.parseDouble(data);
    %>
    <div class="box-container">
        <div class="box">
            <h1>Payment Here</h1>
            <img src="img/pay.png" alt="">
            <h3>₹<%= amount1 %></h3>
            <form action="paymentprocess.jsp" method="post">
                <input type="hidden" name="amount" value="<%= amount1 %>">
                <input type="hidden" name="validity" value="<%= validity1 %>">
                <input type="hidden" name="data" value="<%= data1 %>">
                <pre>Enter your MobileNo:</pre>
                <pre><input type="text" name="mobileno"></pre>
                <pre>VALIDITY <%= validity1 %> days</pre>
                <pre>DATA <%= data1 %> GB/day</pre>
                <a class="btn"><input type="submit" value="Pay ₹<%= amount1 %>"></a>
            </form>
        </div>
    </div>
    <%
            } else {
                out.println("<p>Error: Required parameters are missing.</p>");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            out.println("<p>Error parsing parameters.</p>");
        }
    %>
</body>
</html>
