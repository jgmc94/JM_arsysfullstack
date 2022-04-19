<!--Jesus Mendoza-->
<html>
<head>
<link href="Airline.css" rel="stylesheet" type="text/css" />
<title>A N Airlines|Reserve Now</title>
<link rel="icon" type="image/png" href="AN_logo.jpg" />
</head>

<body>
<!--Beginning of container-->
<div id="Container">
   <!--Header-->
   <div id="Header">
     <a href="RegisterPage.html">
       <img src="AN_logo.jpg" alt="AN Airline Logo" />
     </a>
   </div>
   <!--Bar-->
   <div id="Bar">
     <ul>
       <li><a href="ViewReservationPage.html">View Reservation</a></li>
       <li><a href="ReservePage.html">Reserve</a></li>
       <li><a href="FindFlightPage.html">Find Flight</a></li>
       <li><a href="RegisterPage.html">Register</a></li>
     </ul>
   </div>
   <!--Form-->
   <div id="Form">
      <form action="respage.jsp" id="resForm" method="post">
         <fieldset>
           <legend>Book a Flight</legend>
             <lable for="custid">Customer ID:</lable>
               <input type="text" id="custid" name="custID" maxlength="3"/>
             <lable for="flyid">Flight ID:</lable> 
               <input type="text" id="flyid" name="flyID" maxlength="3"/>
            <br/>
             <lable for="seats">Seats Required:</lable>
               <input type="text" id="sts" name="seats" maxlength="3"/>

             <button type="submit" value="submit" form="resForm" ">
                Submit
             </button>
         </fieldset>
      </form>
        <%@ page import="java.sql.*"%>
        <%/*START OF JSP SCRIPT*/
            String ctID = request.getParameter("custID");
            String flID = request.getParameter("flyID");
            String sts = request.getParameter("seats");
            /*out.println(ctID+flID+sts); --> use to check if parameters are being received*/

            /*Making sure nothing is null when passed to the database*/
            if( ctID != null && !ctID.trim().isEmpty()
                && flID != null && !flID.trim().isEmpty()
                && sts != null && !sts.trim().isEmpty() ){

                try{/*Establishing connection*/
                    Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","ADBDEVELOPER2","Sp123456qq");      
                    /*Calling Stored Procedure*/
                    CallableStatement mar = conn.prepareCall("{call Make_A_Reservation(?,?,?,?)}");
                    /*Setting parameters taken from website into the stored procedure*/
                    mar.setString(1,ctID);
                    mar.setString(2,flID);
                    mar.setString(3,sts);
                    /* .setString or .setter???*/

                    mar.registerOutParameter(4,Types.CHAR);
                    /*register out parameters*/

                    mar.execute();
                    /* .executeUpdate? */

                    String conf = mar.getString(4);
                    /*retrieve id from procedure*/

                    %> <fieldset> <legend>Reservation Successful</legend> <%
                    out.print("Customer " + ctID + " has made a reservation on flight " + flID + " with " + sts + " confirmed seat(s)."
                    + " Your confirmation number is: " + conf);
                    %> <br/> </fieldset> <% /*ADDS BREAK IN OUTPUTS*/

                }
        
                catch(Exception e){
                    %> <fieldset> <legend>ALERT!</legend> <%
                        out.println("Incorrect Customer and/or Flight ID");
                        /*out.print(e);*/
                    %> </fieldset> <%
                }
            }
    
            else{
                %> <fieldset> <legend>ALERT!</legend> <%
                    out.print("All boxes must be filled in. Thank you!");
                %> </fieldset> <% 
            }
          /*END OF JSP SCRIPT*/
        %>
   </div>
   <!--MainBody-->
   <div id="MainBody">
     <img class="mySlides" src="https://images.unsplash.com/photo-1596395819057-e37f55a8516b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8YWlycG9ydHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=700&q=60" />
   </div>
   
<!--<script>
var myIndex = 0;
carousel();

function carousel() {
    var i;
    var x = document.getElementsByClassName("mySlides");
    for (i = 0; i < x.length; i++) {
       x[i].style.display = "none";  
    }
    myIndex++;
    if (myIndex > x.length) {myIndex = 1}    
    x[myIndex-1].style.display = "block";  
    setTimeout(carousel, 3000);
}
</script>-->
   <!--Footer-->
   <div id="Footer">
     <p>A N Airlines Inc. 
     <br/> Terms and conditions apply to all offers and ANA benefits.
      See specific offer for details. | Travel may be on other airlines.</p>
   </div>
</div>
<!--End of container-->


</body>
</html> <!--END OF HTML SCRIPT-->
