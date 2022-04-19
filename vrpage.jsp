<!--Jesus Mendoza-->
<html>
<head>
<link href="Airline.css" rel="stylesheet" type="text/css" />
<title>A N Airlines|View Reservation</title>
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
      <form action="vrpage.jsp" id="vrForm" method="post">
         <fieldset>
           <legend>Find Your Reservation</legend>
             <lable for="ctid">Customer ID:</lable>
               <input type="text" id="custid" name="custID" maxlength="3"/>
             
             <button type="submit" value="submit" form="vrForm" >
                Submit
             </button>
         </fieldset>
      </form>

      <%@ page import="java.sql.*"%>
      <% /*START OF JSP SCRIPT*/
            String ctID = request.getParameter("custID");
            /*out.println(ctID); --> use to make sure that parameters are being recieved*/

            /*Making sure nothing is null when passed to the database*/
            if( ctID != null && !ctID.trim().isEmpty() ){

                try{/*Establishing connection*/
                    Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","ADBDEVELOPER2","Sp123456qq");      
                    /*Calling Stored Procedure*/
                    CallableStatement vcr = conn.prepareCall("{call View_Customer_Reservation(?,?,?,?,?,?,?)}");
                    /*Setting parameters taken from website into the stored procedure*/
                    vcr.setString(1,ctID);
                    /* .setString or .setter???*/

                    vcr.registerOutParameter(2,oracle.jdbc.OracleTypes.CURSOR);
                    vcr.registerOutParameter(3,Types.CHAR);
                    vcr.registerOutParameter(4,Types.VARCHAR);
                    vcr.registerOutParameter(5,Types.VARCHAR);
                    vcr.registerOutParameter(6,Types.CHAR);
                    vcr.registerOutParameter(7,Types.CHAR);
                    /*register out parameters*/

                    vcr.execute();
                    /* .executeUpdate? */

                    ResultSet rs = (ResultSet) vcr.getObject(2);

                    if(rs.next() == false){
                        
                        %> <fieldset> <legend>Reservations Unavailable:</legend> <%
                        out.print("You have no reservations registered at this time");
                        %> </fieldset> <% 

                    } 

                    else{

                        do{

                            String conf = rs.getString(1);
                            String fn = rs.getString(2);
                            String ln = rs.getString(3);
                            String flID = rs.getString(4);
                            String sts = rs.getString(5);
                            /*retrieve id from procedure*/
                        
                            %> <fieldset> <legend>Your Reservations:</legend> <%
                            out.print("Confirmation#: " + conf + " |  Name: |" + fn + " " + ln + " |  Flight ID: |" + flID +
                                  " |  Seats Confirmed: | " + sts );

                            %> <br/> </fieldset> <% /*ADDS BREAK IN OUTPUTS*/
                          }

                        while(rs.next());
                      }
                    
                }

                catch(Exception e){
                    %> <fieldset> <legend>SYSTEM ERROR!</legend> <%
                        out.println("Something went wrong...");
                        out.print(e);
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
     <img class="mySlides" src="https://images.unsplash.com/photo-1582578598772-1a1da19d7839?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGFpcnBvcnQlMjBsb3VuZ2V8ZW58MHx8MHx8&auto=format&fit=crop&w=700&q=60" />
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
</html>
