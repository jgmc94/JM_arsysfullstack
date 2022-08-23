#Jesus Mendoza
import cgi, cgitb
import cx_Oracle
import webbrowser

print ("Content-type: text/html\n\n")
print('''
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
''')

#instance of field storage
ffForm = cgi.FieldStorage()

#acquiring parameters typed in through website
src = ffForm.getvalue("from")
dst = ffForm.getvalue("to")
date = ffForm.getvalue("dt")
#print(src, dst, date) --> use to check if parameters are being retrieved

#Making sure nothing is null when passed to the database*/
if((src and not src.isspace())
  and (dst and not dst.isspace())
  and (date and not date.isspace())):
    try: #Establishing connection username/password@localhost
        conn = cx_Oracle.connect("ADBDEVELOPER2/Sp123456qq@localhost:1521/orcl")      
        #Calling Stored Procedure
    except Exception as err:
            print("Exception occurred while creating a connection ", err) 
    else:
        try:#Calling Stored Procedure
            #Setting parameters taken from website into the stored procedure
            #data = [src, dst, date]
            cur = conn.cursor()
            sys_cur = cur.var(cx_Oracle.CURSOR)
            fid = cur.var(cx_Oracle.STRING)
            fare = cur.var(cx_Oracle.NUMBER)
            seats = cur.var(cx_Oracle.STRING)
            cur.callproc('Find_Flight', [src, dst, date, sys_cur, fid, fare, seats])
            #Setting 
        except Exception as err:
            print('<fieldset> <legend>SYSTEM ERROR!</legend>')
            print("Exception raised while executing the procedure ", err)
            print('</fieldset>')
        else:
            rs = sys_cur.getvalue().fetchall()
            #print(rs)
            if not rs:
                print('<fieldset> <legend>Flights Unavailable:</legend>')
                print("No flights available for these locations on this day.")
                print('</fieldset>')
            else:
                l = []
                #iterate using index and enumerate function
                for index, tuple in enumerate(rs):
                    #access through index by appending to list
                    l.append(rs[index])
                #iterate through list
                for x in l:
                    #list comprehesion to assign variables from list
                    fid, fare, seats = [x[i] for i in (0, 1, 2)]
                    print('<fieldset> <legend>Flight Number:</legend>')
                    print(str(fid) + "   | Source: |" + src + "    | Destination: |" + dst + "   | Fare: |$" + str(fare) + 
                    "   | Date: |" + date + "   | Available Seating: |" + str(seats))
                    print('<br/> </fieldset>')#ADDS BREAK IN OUTPUTS
        finally:
                cur.close()
    finally:
        conn.close()
else:
    print('<fieldset> <legend>ALERT!</legend>')
    print("All boxes must be filled in. Thank you!")
    print('</fieldset>')

print('''
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
''')
