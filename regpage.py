#Jesus Mendoza
import cgi, cgitb
import cx_Oracle
import webbrowser

print ("Content-type: text/html\n\n")
print('''
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
            </form>''')

#instance of field storage
regForm = cgi.FieldStorage()

#acquiring parameters typed in through website
fName = regForm.getvalue("first")
lName = regForm.getvalue("last")
address = regForm.getvalue("adrs")
city = regForm.getvalue("ct")
state = regForm.getvalue("st")
phone = regForm.getvalue("pNum")

#print (fName, lName, address, city, state, phone)
#can be used to check and see if parameters are being retrieved

if ((fName and not fName.isspace())
    and (lName and not lName.isspace())
    and (address and not address.isspace())
    and (city and not city.isspace())
    and (state and not state.isspace())
    and (phone and not phone.isspace())):
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
                #data = ['fName','lName','address','city','state','phone']
                cur = conn.cursor()
                id = cur.var(cx_Oracle.STRING)
                cur.callproc('Register_Customer', [fName, lName, address, city, state, phone, id])
            except Exception as err:
                print('<fieldset> <legend>SYSTEM ERROR!</legend>')
                print("Exception raised while executing the procedure ", err)
                print('</fieldset>')
            else:
                print('<fieldset> <legend>Registration Successful</legend>')
                print("You have successfully registered. Your customer ID is: " + id.getvalue() + ". Please be sure to remember "
                + "your ID as it will be needed for further access on the site. Thank you!")
                print('</fieldset>')
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
            <img class="mySlides" src="https://media.istockphoto.com/photos/passengers-commercial-airplane-flying-above-clouds-picture-id955952680?b=1&k=20&m=955952680&s=170667a&w=0&h=10Sjo1ug45dq3zLtzBo8jeUksElPYgCOUMi4GgvBRQU=" />
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
</html><!--END OF HTML SCRIPT-->
''')
