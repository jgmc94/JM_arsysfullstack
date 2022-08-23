#Jesus Mendoza
import cgi, cgitb
from operator import itemgetter
import cx_Oracle
import webbrowser

print ("Content-type: text/html\n\n")
print('''
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
            <form action="cig-bin/vrpage.py" id="vrForm" method="post">
                <fieldset>
                    <legend>Find Your Reservation</legend>
                        <lable for="ctid">Customer ID:</lable>
                            <input type="text" id="custid" name="custID" maxlength="3"/>
                        <button type="submit" value="submit" form="vrForm" >
                            Submit
                        </button>
                </fieldset>
            </form>
''')

#instance of field storage
vrForm = cgi.FieldStorage()

#acquiring parameters typed in through website
ctID = vrForm.getvalue("custID")
#print(src, dst, date) --> use to check if parameters are being retrieved

#Making sure nothing is null when passed to the database
if ctID and not ctID.isspace():
    try: #Establishing connection username/password@localhost
        conn = cx_Oracle.connect("ADBDEVELOPER2/Sp123456qq@localhost:1521/orcl")      
        #Calling Stored Procedure
    except Exception as err:
            print('<fieldset> <legend>SYSTEM ERROR!</legend>')
            print("Exception occurred while creating a connection ", err)
            print('</fieldset>')
    else:
        try:#Calling Stored Procedure
            #Setting parameters taken from website into the stored procedure
            #data = [ctID]
            cur = conn.cursor()
            sys_cur = cur.var(cx_Oracle.CURSOR)
            conf = cur.var(cx_Oracle.STRING)
            fn = cur.var(cx_Oracle.STRING)
            ln = cur.var(cx_Oracle.STRING)
            flID = cur.var(cx_Oracle.STRING)
            sts = cur.var(cx_Oracle.STRING)
            cur.callproc('View_Customer_Reservation', [ctID, sys_cur, conf, fn, ln, flID, sts])
            #Setting 
        except Exception as err:
            print('<fieldset> <legend>SYSTEM ERROR!</legend>')
            print("Exception raised while executing the procedure ", err)
            print('</fieldset>')
        else:
            rs = sys_cur.getvalue().fetchall()
            #print(rs) use to check data received
            if not rs:
                print('<fieldset> <legend>Flights Unavailable:</legend>')
                print("You have no reservations registered at this time")
                print('</fieldset>')
            else:
                #iterate using loop
                for x in rs:
                    #use itemgetter to assign value to variables
                    conf, fn, ln, flID, sts = itemgetter(0, 1, 2, 3, 4)(x)
                    print('<fieldset> <legend>Flight Number:</legend>')
                    print("Confirmation#: " + str(conf) + " |  Name: |" + str(fn) + " " + str(ln) + " |  Flight ID: |" + str(flID) +
                            " |  Seats Confirmed: | " + str(sts))
                    print('<br/> </fieldset>') 
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
            <img class="mySlides" src="https://images.unsplash.com/photo-1582578598772-1a1da19d7839?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGFpcnBvcnQlMjBsb3VuZ2V8ZW58MHx8MHx8&auto=format&fit=crop&w=700&q=60" />
        </div>   
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
''')