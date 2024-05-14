<%-- 
    Document   : Payment1.jsp
    Created on : Apr 20, 2024, 10:57:32 PM
    Author     : DELL
--%>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="false" %>
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
    <%@ page import="java.io.PrintWriter" %>
    <div class="box-container">
        <div class="box">
            <h1>Payment Here</h1>
            <img src="img/pay.png" alt="">
            <h3>₹<%= request.getParameter("amount") %></h3>
            <form action="Payment1process.jsp" method="post">
                <input type="hidden" name="amount" value="<%= request.getParameter("amount") %>">
                <input type="hidden" name="validity" value="<%= request.getParameter("validity") %>">
                <input type="hidden" name="data" value="<%= request.getParameter("data") %>">
                <pre>Enter your MobileNo:</pre>
                <pre><input type="text" name="mobileno"></pre>
                <pre>VALIDITY <%= request.getParameter("validity") %> days</pre>
                <pre>DATA <%= request.getParameter("data") %> GB/day</pre>
                <a class="btn"><input type="submit" value="GET NOW"></a>
            </form>
        </div>
    </div>
</body>
</html>
