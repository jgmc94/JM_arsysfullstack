#Jesus Mendoza
import cgi, cgitb
import cx_Oracle
import webbrowser

print ("Content-type: text/html\n\n")
print('''
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
        /div>
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
                        <button type="submit" value="submit" form="resForm" >
                            Submit
                        </button>
                </fieldset>
            </form>
''')
#instance of field storage
resForm = cgi.FieldStorage()

#acquiring parameters typed in through website
ctID = resForm.getvalue("custID")
flID = resForm.getvalue("flyID")
sts = resForm.getvalue("seats")

#print (fName, lName, address, city, state, phone)
#can be used to check and see if parameters are being retrieved

if ((ctID and not ctID.isspace())
    and (flID and not flID.isspace())
    and (sts and not sts.isspace())):
        try:#Establishing connection username/password@localhost
            #username = ADBDEVELOPER2
            #pw = Sp123456qq
            #dsn = localhost
            #port = 1521
            conn = cx_Oracle.connect("ADBDEVELOPER2/Sp123456qq@localhost:1521/orcl")
        except Exception as err:
            print('<fieldset> <legend>SYSTEM ERROR!</legend>')
            print("Exception occurred while creating a connection ", err)
            print('</fieldset>')
        else:
            try:#Calling Stored Procedure
                #Setting parameters taken from website into the stored procedure
                #data = [ctID,flID,sts]
                cur = conn.cursor()
                conf = cur.var(cx_Oracle.STRING)
                cur.callproc('Make_A_Reservation', [ctID, flID, sts, conf])
            except Exception as err:
                print('<fieldset> <legend>SYSTEM ERROR!</legend>')
                print("Exception raised while executing the procedure ", err)
                print('</fieldset>')
            else:
                print('<fieldset> <legend>Registration Successful</legend>')
                print("Customer " + ctID + " has made a reservation on flight " + flID + " with " + sts + " confirmed seat(s)."
                    + " Your confirmation number is: " + conf.getvalue())
                print('</fieldset>')
            finally:
                cur.close()
        finally:
            conn.close()
else:
    print('<fieldset> <legend>ALERT!</legend>')
    print("All boxes must be filled in. Thank you!")
    print(' </fieldset>')

print('''
        </div>
        <!--MainBody-->
        <div id="MainBody">
            <img class="mySlides" src="https://images.unsplash.com/photo-1596395819057-e37f55a8516b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8YWlycG9ydHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=700&q=60" />
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
</html> <!--END OF HTML SCRIPT-->
''')