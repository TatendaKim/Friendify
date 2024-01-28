import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendify/controllers/googleAuth.dart';
import 'package:friendify/views/globalUsers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';



class LoginSignupScreen extends StatefulWidget {
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  File? _profileImage;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<FormState> signupFormKey;

  @override
  void initState() {
    super.initState();
    loginFormKey = GlobalKey<FormState>();
    signupFormKey = GlobalKey<FormState>();
  }

  // Register a user
  Future<void> registerWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      print('User registered successfully: ${credential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error during registration: $e');
      }
    } catch (e) {
      print('Unexpected error during registration: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/friendly.jpeg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          
            const SizedBox(height: 8),
            // Bold Heading Text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.21,
              left: MediaQuery.of(context).size.width * 0.18,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 8),
                  // Bold Heading Text with Custom Color
                  SizedBox(
                    child: Center(
                      child: Text(
                        'friendify',
                        style: TextStyle(
                          fontFamily: 'Roboto', 
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 121, 240, 25),
                          fontStyle: FontStyle.italic, 
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          text: 'Login',
                        ),
                        Tab(
                          text: 'Sign Up',
                        ),
                      ],
                      labelColor: Colors.black,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          LoginForm(),
                          SingleChildScrollView(
                            child: SignupForm(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget _uploadPictureButton() {
    return GestureDetector(
      onTap: () async {
        await _pickProfilePicture();

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: const Text(
          'Upload Photo',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _googleButton() {
  return ElevatedButton(
      onPressed: () {
        signInWithGoogle();
        print('Login with Google');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), 
            bottomLeft: Radius.circular(8),
            bottomRight:
                Radius.circular(0), 
            topRight: Radius.circular(8), 
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.white,
                  width: 50,
                  height: 50,
                ),
                Image.asset(
                  'assets/google_icon.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 25),
                child: const Text(
                  'Login with Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {
       AuthService auth =AuthService();
        auth.signIn(email:_emailController.text,password: _passwordController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalUsersPage(),
        ),
      );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _signUpSubmitButton() {
  return GestureDetector(
    onTap: () async {
      final AuthService authentication = AuthService();

      await authentication.signUp(
        fullname: _fullnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        imageUrl: _profileImage!,
      ).then((success) {
        if (success != null) {
          _showVerificationDialog();
        } else {
        }
      });
    },

    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(2, 4),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  );
}


  Widget LoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(2.0),
      child: Form(
        key: loginFormKey,
        child: Column(
          children: [
            Container(
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]+$')
                      .hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your password';
                } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]+$')
                    .hasMatch(value!)) {
                  return 'Please enter a valid password address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            _googleButton(),
            const SizedBox(height: 20),
            _submitButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget SignupForm() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Form(
        key: signupFormKey,
        child: Column(
          children: [
            Container(
              child: TextFormField(
              controller: _fullnameController,
              decoration: InputDecoration(
                hintText: 'Enter Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
             ),
            const SizedBox(height: 16),
              
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]+$')
                      .hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
           

            
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 255, 255),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please confirm your password';
                } else if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            
            const SizedBox(height: 16),
            _uploadPictureButton(),
            const SizedBox(height: 20),
            _signUpSubmitButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  Future<void> _pickProfilePicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
}


void _showVerificationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Verification Link Sent'),
        content: const Text('A verification link has been sent to your email.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}
void main() {
  runApp(MaterialApp(
    home: LoginSignupScreen(),
  ));
}
}