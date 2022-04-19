<!--Jesus Mendoza-->
<html>
<head>
<link href="Airline.css" rel="stylesheet" type="text/css" />
<title>A N Airlines|Register</title>
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
      <form action="regpage.jsp" id="regForm" method="post">
         <fieldset>
           <legend>Customer Information</legend>
             <lable for="f">First Name:</lable>
               <input type="text" id="fname" name="first" maxlength="20"/>
             <lable for="l">Last Name:</lable> 
               <input type="text" id="lname" name="last" maxlength="30"/>
             <lable for="aD">Address:</lable>
               <input type="text" id="address" name="adrs" maxlength="30"/>
            <br/>
             <lable for="cITY">City:</lable>
               <input type="text" id="city" name="ct" maxlength="20"/>
             <lable for="sTATE">State:</lable>
               <input type="text" id="state" name="st" maxlength="2" placeholder="ST"/>
             <lable for="pHN">Phone:</lable>
               <input type="text" id="phone" name="pNum" maxlength="13"/>
               
             <button type="submit" value ="submit" form="regForm" >
                Submit
             </button>
         </fieldset>
      </form>
            <%@ page import="java.sql.*"%>
            <% /*START OF JSP SCRIPT*/

               /*acquiring parameters typed in through website*/
                String fName = request.getParameter("first");
                String lName = request.getParameter("last");
                String address = request.getParameter("adrs");
                String city = request.getParameter("ct");
                String state = request.getParameter("st");
                String phone = request.getParameter("pNum");
                /*out.println(fName+lName+address+city+state+phone);-->can be used 
                  to check and see if parameters are being retrieved*/

                /*Making sure nothing is null when passed to the database*/
                if( fName != null && !fName.trim().isEmpty()
                    && lName != null && !lName.trim().isEmpty()
                    && address != null && !address.trim().isEmpty()
                    && city != null && !city.trim().isEmpty()
                    && state != null && !state.trim().isEmpty()
                    && phone != null && !phone.trim().isEmpty() ){

                    try{/*Establishing connection*/
                        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","ADBDEVELOPER2","Sp123456qq");      
                        /*Calling Stored Procedure*/
                        CallableStatement rgstc = conn.prepareCall("{call Register_Customer(?,?,?,?,?,?,?)}");
                        /*Setting parameters taken from website into the stored procedure*/
                        rgstc.setString(1,fName);
                        rgstc.setString(2,lName);
                        rgstc.setString(3,address);
                        rgstc.setString(4,city);
                        rgstc.setString(5,state);
                        rgstc.setString(6,phone);
                        /* .setString or .setter???*/

                        rgstc.registerOutParameter(7,Types.VARCHAR);
                        /*register out parameters*/

                        rgstc.execute();
                        /* .executeUpdate? */

                        String id = rgstc.getString(7);
                        /*retrieve id from procedure*/

                        %> <fieldset> <legend>Registration Successful</legend> <%
                        out.print("You have successfully registered. Your customer ID is: " + id + ". Please be sure to remember "
                        + "your ID as it will be needed for further access on the site. Thank you!");
                        %> </fieldset> <% 

                        /* closing connections
                        rgstc.close();
                        conn.close();
                        rgstc = null;
                        conn = null;  */  
                    }
    
                    catch(SQLException e){
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
     <img class="mySlides" src="https://media.istockphoto.com/photos/passengers-commercial-airplane-flying-above-clouds-picture-id955952680?b=1&k=20&m=955952680&s=170667a&w=0&h=10Sjo1ug45dq3zLtzBo8jeUksElPYgCOUMi4GgvBRQU=" />
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
</html><!--END OF HTML SCRIPT-->