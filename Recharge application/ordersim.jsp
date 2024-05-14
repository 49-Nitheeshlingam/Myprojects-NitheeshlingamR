<%-- 
    Document   : ordersim
    Created on : 14-Apr-2024, 8:33:46 pm
    Author     : DELL
--%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.IOException" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page isErrorPage="false" %>

<%
// Database connection parameters
String driver = "com.mysql.cj.jdbc.Driver";
String user = "administrator";
String dbPassword = "Niti#@123";
String url = "jdbc:mysql://localhost:3306/MyDB?useSSL=false&allowPublicKeyRetrieval=true";

// Generate a random mobile number as a string
Random rand = new Random();
int firstDigit = rand.nextInt(4) + 6; // Generates a random number from 6 to 9
String mobileNoPrefix = Integer.toString(firstDigit);
for (int i = 0; i < 9; i++) {
    mobileNoPrefix += rand.nextInt(10); // Append 9 random digits
}

try {
    // Load and register the JDBC driver
    Class.forName(driver);

    // Establish the database connection
    Connection conn = DriverManager.getConnection(url, user, dbPassword);

    // Prepare the SQL statement for insertion
 String sql = "INSERT INTO Customer_details (Cus_Name, MobileNo, Password, Current_PlanStatus) VALUES (?, ?, ?, ?)";
 PreparedStatement pstmt = conn.prepareStatement(sql);

    // Get form parameters
    String cusName = request.getParameter("oname");
    String userPassword = request.getParameter("opass");

    // Set values for the prepared statement
    pstmt.setString(1, cusName);
    pstmt.setString(2, mobileNoPrefix); // Store mobile number prefix as string
    pstmt.setString(3, userPassword);
    pstmt.setString(4, "no");

    // Execute the SQL statement
    int rowsAffected = pstmt.executeUpdate();

    // Close resources
    pstmt.close();
    conn.close();

    // Display success message to the user
    response.setContentType("text/html;charset=UTF-8");
    PrintWriter responseWriter = response.getWriter();
    responseWriter.println("<html><body>");
    responseWriter.println("<h1>Congratulations!</h1>");
    responseWriter.println("<p>Your order has been placed successfully.</p>");
    responseWriter.println("<p>Your mobile number is: " + mobileNoPrefix + "</p>");
    responseWriter.println("</body></html>");

} catch (ClassNotFoundException | SQLException e) {
    // Handle exceptions
    e.printStackTrace();
    // Redirect or display an error message as needed
    response.sendRedirect("error.jsp");
}
%>
