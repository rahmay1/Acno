import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acne_detector/pages/root_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:acne_detector/search/searchPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  String? errormsg;
  bool? error, showprogress;
  String? username, password, email;
  //String? fullname;
  bool signupOrLogin = true;
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // startLogin() async {
  //   String apiurl = "http://10.0.2.2:8000/login.php"; //api url
  //   print(username);
  //
  //   var response = await http.post(Uri.parse(apiurl), body: {
  //     'username': username, //send the username text
  //     'password': password //send password text
  //   });
  //
  //   if (response.statusCode == 200) {
  //     var jsondata = json.decode(response.body);
  //     if (jsondata["error"]) {
  //       setState(() {
  //         showprogress = false;  //don't show progress indicator
  //         error = true;
  //         errormsg = jsondata["message"];
  //       });
  //     } else {
  //       if (jsondata["success"]) {
  //         setState(() {
  //           error = false;
  //           showprogress = false;
  //         });
  //         //save the data returned from server
  //         //and navigate to home page
  //         String user_id = jsondata["user_id"];
  //         String fullname = jsondata["fullname"];
  //         print(user_id);
  //         print(fullname);
  //         Navigator.of(context).push(
  //           MaterialPageRoute(
  //             builder: (context) => const RootApp(),
  //           ),
  //         );
  //
  //       } else {
  //         showprogress = false;
  //         error = true;
  //         errormsg = "Something went wrong.";
  //       }
  //     }
  //   } else {
  //     setState(() {
  //       showprogress = false;
  //       error = true;
  //       errormsg = "Error during connecting to server.";
  //     });
  //   }
  // }
  //
  // startSignup() async {
  //
  //   String apiurl = "http://10.0.2.2:8000/signup.php"; //api url
  //   print(username);
  //
  //   var response = await http.post(Uri.parse(apiurl), body: {
  //     'fullname': fullname, //send the fullname text
  //     'email': email, //send the email text
  //     'username': username, //send the username text
  //     'password': password //send password text
  //   });
  //   if (response.statusCode == 200) {
  //     var jsondata = json.decode(response.body);
  //     if (jsondata["error"]) {
  //       setState(() {
  //         showprogress = false; //don't show progress indicator
  //         error = true;
  //         errormsg = jsondata["message"];
  //       });
  //     } else {
  //       if (jsondata["success"]) {
  //         setState(() {
  //           error = false;
  //           showprogress = false;
  //         });
  //         //save the data returned from server
  //         //and navigate to home page
  //         String user_id = jsondata["user_id"];
  //         String fullname = jsondata["fullname"];
  //         print(user_id);
  //         print(fullname);
  //         Navigator.of(context).push(
  //           MaterialPageRoute(
  //             builder: (context) => const RootApp(),
  //           ),
  //         );
  //
  //       } else {
  //         showprogress = false;
  //         error = true;
  //         errormsg = "Something went wrong.";
  //       }
  //     }
  //   } else {
  //     setState(() {
  //       showprogress = false;
  //       error = true;
  //       errormsg = "Error during connecting to server.";
  //     });
  //   }
  // }

  startLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email as String, password: password as String);
      // Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) => const MyApp(),
      //             ),
      //           );
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => MyApp()));
      Navigator.pushReplacementNamed(context, '/searchPage');
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errormsg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errormsg = "Wrong password provided for that user.";
      }else{
        errormsg = "Error connecting to server.";
      }
      print(e);
      showprogress = false;
      error = true;
      setState(() {});
    }catch (e){
      errormsg = "Error connecting to server.";
      showprogress = false;
      error = true;
      setState(() {});
    }
  }

  validateLogin() async {

    // bool fullnameValid =
    //     RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
    //         .hasMatch(fullname as String);
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email as String);
    bool passValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password as String);

    // if (!fullnameValid) {
    //   showprogress = false; //don't show progress indicator
    //   error = true;
    //   errormsg = "Please enter a valid Full Name.";
    //   setState(() {});
    // } else
    if (!emailValid) {
      showprogress = false; //don't show progress indicator
      error = true;
      errormsg = "Please enter a valid Email.";
      setState(() {});
    } else if (!passValid) {
      showprogress = false; //don't show progress indicator
      error = true;
      errormsg = "Please enter a valid Password of atleast 8 characters. Use Lowercase, Uppercase, a Digit, and a Special Character (Includes: ! @ # \$ & * ~ ).";
      setState(() {});
    } else {
      error = false;
      startLogin();
    }
  }

  startSignup() async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email as String, password: password as String);
      User user = result.user as User;
      user.updateDisplayName(username);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const MyApp(),
      //   ),
      // );
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => MyApp()));
      Navigator.pushReplacementNamed(context, '/searchPage');
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errormsg = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errormsg = "The account already exists for that email.";
      }else{
        errormsg = "Error connecting to server.";
      }
      print(e);
      showprogress = false;
      error = true;
      setState(() {});
    }catch (e){
      errormsg = "Error connecting to server.";
      showprogress = false;
      error = true;
      setState(() {});
    }
  }

  // Validate the values for Signup
  validateSignup() async {

    // bool fullnameValid =
    //     RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
    //         .hasMatch(fullname as String);
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email as String);
    bool userValid = !((username as String) == "");
    bool passValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password as String);

    // if (!fullnameValid) {
    //   showprogress = false; //don't show progress indicator
    //   error = true;
    //   errormsg = "Please enter a valid Full Name.";
    //   setState(() {});
    // } else
    if (!emailValid) {
      showprogress = false; //don't show progress indicator
      error = true;
      errormsg = "Please enter a valid Email.";
      setState(() {});
    } else if (!userValid) {
      showprogress = false; //don't show progress indicator
      error = true;
      errormsg = "Please enter a valid Username.";
      setState(() {});
    } else if (!passValid) {
      showprogress = false; //don't show progress indicator
      error = true;
      errormsg = "Please enter a valid Password of atleast 8 characters. Use Lowercase, Uppercase, a Digit, and a Special Character (Includes: ! @ # \$ & * ~ ).";
      setState(() {});
    } else {
      error = false;
      startSignup();
    }
  }

  checkConnection() async {

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        signupOrLogin ? validateSignup():validateLogin();
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {});
      showprogress = false; //don't show progress indicator
      showAlertDialog(context);
    }

  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No Connection"),
      content: Text("Could not connect to internet."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void clearText() {
    //_fullname.text = "";
    _username.text = "";
    _password.text = "";
    _email.text = "";
    errormsg = "";
    error = false;
  }

  @override
  void initState() {
    //fullname = "";
    username = "";
    password = "";
    email = "";
    errormsg = "";
    error = false;
    showprogress = false;

    //_username.text = "defaulttext";
    //_password.text = "defaultpassword";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));

    return WillPopScope(
        onWillPop: () async => false,
    child: Scaffold(
      body: SingleChildScrollView(
          child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height
                //set minimum height equal to 100% of VH
                ),
        width: MediaQuery.of(context).size.width,
        //make width of outer wrapper to 100%
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.orange,
              Colors.deepOrangeAccent,
              Colors.red,
              Colors.redAccent,
            ],
          ),
        ),
        //show linear gradient background of page

        padding: const EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: signupOrLogin
                ? const Text(
                    "Sign up System",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  )
                : const Text(
                    "Sign In System",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ), //title text
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: signupOrLogin
                ? const Text(
                    "Sign up using Personal Info.",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                : const Text(
                    "Sign in using Email and Password",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ), //subtitle text
          ),
          Container(
            //show error message here
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(10),
            child: (error as bool) ? errmsg(errormsg as String) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          // Visibility(
          //   child: Container(
          //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //     margin: const EdgeInsets.only(top: 10),
          //     child: TextField(
          //       controller: _fullname, //set username controller
          //       style: TextStyle(color: Colors.orange[100], fontSize: 20),
          //       decoration: myInputDecoration(
          //         label: "Full Name",
          //         icon: Icons.person,
          //       ),
          //       onChanged: (value) {
          //         //set username  text on change
          //         fullname = value;
          //       },
          //     ),
          //   ),
          //   visible: signupOrLogin ? true : false,
          // ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _email, //set username controller
              style: TextStyle(color: Colors.orange[100], fontSize: 20),
              decoration: myInputDecoration(
                label: "Email",
                icon: Icons.mail,
              ),
              onChanged: (value) {
                email = value;
              },
            ),
          ),

          Visibility(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _username, //set username controller
                style: TextStyle(color: Colors.orange[100], fontSize: 20),
                decoration: myInputDecoration(
                  label: "Username",
                  icon: Icons.person,
                ),
                onChanged: (value) {
                  //set username  text on change
                  username = value;
                },
              ),
            ),
            visible: signupOrLogin ? true : false,
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _password,
              //set password controller
              style: TextStyle(color: Colors.orange[100], fontSize: 20),
              obscureText: true,
              decoration: myInputDecoration(
                label: "Password",
                icon: Icons.lock,
              ),
              onChanged: (value) {
                // change password text
                password = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    //show progress indicator on click
                    showprogress = true;
                  });
                  checkConnection();
                },
                child: (showprogress as bool)
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.orange[100],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.deepOrangeAccent),
                        ),
                      )
                    : signupOrLogin
                        ? const Text(
                            "SIGN UP NOW",
                            style: TextStyle(fontSize: 20),
                          )
                        : const Text(
                            "LOGIN NOW",
                            style: TextStyle(fontSize: 20),
                          ),
                // if showprogress == true then show progress indicator
                // else show "LOGIN NOW" text
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                  // RoundedRectangleBorder
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: InkResponse(
                onTap: () {
                  if (signupOrLogin == true) {
                    signupOrLogin = false;
                  } else {
                    signupOrLogin = true;
                  }

                  clearText();

                  setState(() {});
                },
                child: signupOrLogin
                    ? const Text(
                        "Already have an account? Login.",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    : const Text(
                        "Don't have an account? Signup.",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
          )
        ]),
      )),
    )
    );
  }

  InputDecoration myInputDecoration({String? label, IconData? icon}) {
    return InputDecoration(
      hintText: label,
      //show label as placeholder
      hintStyle: TextStyle(color: Colors.orange[100], fontSize: 20),
      //hint text style
      prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Icon(
            icon,
            color: Colors.orange[100],
          )
          //padding and icon for prefix
          ),

      contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.orange[300] as Color, width: 1)),
      //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.orange[200] as Color, width: 1)),
      //focus border

      fillColor: const Color.fromRGBO(251, 140, 0, 0.5),
      filled: true, //set true if you want to show input background
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: const EdgeInsets.all(15.00),
      margin: const EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
          border: Border.all(color: Colors.red[300] as Color, width: 2)),
      child: Row(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 6.00),
          child: const Icon(Icons.info, color: Colors.white),
        ), // icon for error message
        Flexible( child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18), softWrap: true, overflow: TextOverflow.visible,),),
        //show error message text
      ]),
    );
  }
}