<%-- 
    Document   : signup.jsp
    Created on : 16-Apr-2024, 12:19:08?am
    Author     : DELL
--%>

<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>SignUp</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="login.css">
</head>
<body style="background:url('bglg.jpg') no-repeat;">
    <%
        String driver = "com.mysql.cj.jdbc.Driver";
        String user = "administrator";
        String dbPassword = "Niti#@123";
        String url = "jdbc:mysql://localhost:3306/MyDB?useSSL=false&allowPublicKeyRetrieval=true";

        // Get form parameters
        String name = request.getParameter("name");
        String mobileNo = request.getParameter("mobileno");
        long mobileno1 = Long.parseLong(mobileNo);
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmpassword");

        if (!password.equals(confirmPassword)) {
    %>
            <script>
                alert("Passwords do not match!");
                window.location.href = "SignUp.html"; // Redirect to SignUp page
            </script>
    <%
        } else {
            try {
                // Load and register the JDBC driver
                Class.forName(driver);

                // Establish the database connection
                Connection conn = DriverManager.getConnection(url, user, dbPassword);

                // Prepare the SQL statement to insert customer data
                String sql = "INSERT INTO Customer_details (Cus_Name, MobileNo, Password, Current_PlanStatus) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setLong(2, mobileno1);
                pstmt.setString(3, password);
                pstmt.setString(4, "no"); // Fixed syntax

                // Execute the SQL statement
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
    %>
                    <script>
                        alert("WELCOME TO Sparkwave");
                        window.location.href = "index.html"; // Redirect to dashboard page
                    </script>
    <%
                } else {
    %>
                    <script>
                        alert("Failed to register. Please try again.");
                        window.location.href = "SignUp.html"; // Redirect to SignUp page
                    </script>
    <%
                }

                // Close resources
                pstmt.close();
                conn.close();

            } catch (ClassNotFoundException | SQLException e) {
                // Handle exceptions
                e.printStackTrace();
                // Redirect or display an error message as needed
                response.sendRedirect("error.jsp");
            }
        }
    %>
</body>
</html>
