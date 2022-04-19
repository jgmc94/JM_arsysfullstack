<!--Jesus Mendoza-->
<html>
<head>
<link href="Airline.css" rel="stylesheet" type="text/css" />
<title>A N Airlines|Find Flight</title>
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
      <form action="ffpage.jsp" id="ffForm" method="post">
         <fieldset>
           <legend>Flight Specifications</legend>
             <lable for="src">From:</lable>
			  <select name="from" id="src">
				<option value="AA1" selected>JFK</option>
				<option value="BB1">LGA</option>
				<option value="CC1">LAX</option>
				<option value="DD1">PIT</option>
				<option value="EE1">BOS</option>
				<option value="FF1">MIA</option>
				<option value="GG1">DFW</option>
			  </select>
             <lable for="dst">To:</lable> 
			  <select name="to" id="dst">
				<option value="AA1">JFK</option>
				<option value="BB1">LGA</option>
				<option value="CC1" selected>LAX</option>
				<option value="DD1">PIT</option>
				<option value="EE1">BOS</option>
				<option value="FF1">MIA</option>
				<option value="GG1">DFW</option>
			  </select>
             <lable for="dt">Date:</lable>
			    <input type="text" id="dT" name="dt" maxlength="11" placeholder="01-JAN-2022"/>
                <br/>
             <button type="submit" value="submit" form="ffForm" onclick="validateForm()">
                Submit
             </button>
         </fieldset>
      </form>

      <%@ page import="java.sql.*"%>
      <% /*START OF JSP SCRIPT*/
            String src = request.getParameter("from");
            String dst = request.getParameter("to");
            String date = request.getParameter("dt");
            /*out.println(src+dst+date); --> use to check if parameters are being retrieved*/

            /*Making sure nothing is null when passed to the database*/
            if( src != null && !src.trim().isEmpty()
                && dst != null && !dst.trim().isEmpty()
                && date != null && !date.trim().isEmpty() ){

                try{/*Establishing connection*/
                    Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","ADBDEVELOPER2","Sp123456qq");      
                    /*Calling Stored Procedure*/
                    CallableStatement ff = conn.prepareCall("{call Find_Flight(?,?,?,?,?,?,?)}");
                    /*Setting parameters taken from website into the stored procedure*/
                    ff.setString(1,src);
                    ff.setString(2,dst);
                    ff.setString(3,date);
                    /* .setString or .setter???*/

                    ff.registerOutParameter(4,oracle.jdbc.OracleTypes.CURSOR);
                    ff.registerOutParameter(5,Types.CHAR);
                    ff.registerOutParameter(6,Types.NUMERIC);
                    ff.registerOutParameter(7,Types.CHAR);
                    /*register out parameters*/

                    ff.execute();
                    /* .executeUpdate? */

                    ResultSet rs = (ResultSet) ff.getObject(4);

                    if(rs.next() == false){
                        
                        %> <fieldset> <legend>Flights Unavailable:</legend> <%
                        out.print("No flights available for these locations on this day.");
                        %> </fieldset> <% 

                    }    

                    else{

                          do{

                            String fID = rs.getString(1);
                            double fare = rs.getDouble(2);
                            String oSeat = rs.getString(3);
                            /*retrieve id from procedure*/
                            %> <fieldset> <legend>Flight Number:</legend> <%
                            out.print(fID + "   | Source: |" + src + "    | Destination: |" + dst + "   | Fare: |$" + fare + 
                            "   | Date: |" + date + "   | Available Seating: |" + oSeat);
                        
                            %> <br/> </fieldset> <% /*ADDS BREAK IN OUTPUTS*/

                          }
                          while(rs.next());
                    
                        }    

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
     <img class="mySlides" src="https://media.istockphoto.com/photos/passenger-airplane-flying-above-clouds-during-sunset-picture-id155439315?b=1&k=20&m=155439315&s=170667a&w=0&h=N2BzlH2GYabhWN0LXZTqTkVODuTb8qDAESQYCPzIig8=" />
   </div> <!--extra image (https://www.telegraph.co.uk/content/dam/Travel/2018/January/white-plane-sky.jpg?imwidth=680)-->
   
<script>
function validateForm() {
    if (document.forms["ffForm"]["dt"].value == "" || document.forms["ffForm"]["dt"].value == null) {
      return false;
    }
  
    else{
        alert('Please be sure to remember the flight number' + 
             ' as it will be needed later during the reservation process!');
    }
}
</script>
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
