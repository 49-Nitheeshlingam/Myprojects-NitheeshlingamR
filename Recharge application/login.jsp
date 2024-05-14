<%-- 
    Document   : login.jsp
    Created on : 15-Apr-2024, 11:55:09?pm
    Author     : DELL
--%>
<%--
    Document   : login.jsp
    Created on : 15-Apr-2024, 11:55:09?pm
    Author     : DELL
--%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <script>
        function showAlert(message) {
            alert(message);
        }
    </script>
</head>
<body>
    <%
        String driver = "com.mysql.cj.jdbc.Driver";
        String user = "administrator";
        String dbPassword = "Niti#@123";
        String url = "jdbc:mysql://localhost:3306/MyDB?useSSL=false&allowPublicKeyRetrieval=true";

        // Get form parameters
        String mobileNo = request.getParameter("mobileNo");
        String password = request.getParameter("password");

        try {
            // Load and register the JDBC driver
            Class.forName(driver);

            // Establish the database connection
            Connection conn = DriverManager.getConnection(url, user, dbPassword);

            // Check if the user exists in the Login table
            String checkLoginQuery = "SELECT * FROM Login WHERE MobileNo = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkLoginQuery);
            checkStmt.setString(1, mobileNo);
            ResultSet loginResult = checkStmt.executeQuery();

            if (!loginResult.next()) {
                // User not found in Login table, insert them
                String insertLoginQuery = "INSERT INTO Login (MobileNo, Password) VALUES (?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertLoginQuery);
                insertStmt.setString(1, mobileNo);
                insertStmt.setString(2, password);
                insertStmt.executeUpdate();
                insertStmt.close();
            }
            checkStmt.close();
            loginResult.close();

            // Prepare the SQL statement to check customer login
            String sql = "SELECT * FROM Customer_details WHERE MobileNo = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, mobileNo);

            // Execute the SQL statement
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // Customer exists
                if (rs.getString("Password").equals(password)) {
                    if (rs.getString("Current_PlanStatus").equals("no")) {
    %>
                        <script>
                            showAlert("Please choose a plan in our prepaid or postpaid plans.");
                            window.location.href = "prepaid.html"; // Redirect to plans page
                        </script>
    <%
                    } else {
    %>
                        <script>
                            showAlert("Successfully Logged In!");
                            window.location.href = "index.html"; // Redirect to dashboard page
                        </script>
    <%
                    }
                } else {
    %>
                    <script>
                        showAlert("Incorrect Password!");
                    </script>
    <%
                }
            } else {
    %>
                <script>
                    window.location.href = "SignUp.html"; // Redirect to SignUp page
                </script>
    <%
            }

            // Close resources
            rs.close();
            pstmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            // Handle exceptions
            e.printStackTrace();
            // Redirect or display an error message as needed
            response.sendRedirect("error.jsp");
        }
    %>
</body>
</html>
