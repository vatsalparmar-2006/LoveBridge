import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../DashBoard/dashBoardScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();
  bool isHide = true;
  bool isRegister = false;
  File? _image;
  String? savedEmail;
  String? savedPassword;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmail = prefs.getString('savedEmail');
      savedPassword = prefs.getString('savedPassword');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() => _image = pickedFile != null ? File(pickedFile.path) : null);
  }

  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: color,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(Icons.info_outline, color: Colors.white),
    )..show(context);
  }

  void _handleAuth() async {
    if (!_key.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isRegister) {
      await prefs.setString('savedEmail', emailController.text);
      await prefs.setString('savedPassword', passController.text);

      _showFlushbar('Signup successful! Please login.', Colors.green);
      setState(() => isRegister = false);
    } else {
      savedEmail = prefs.getString('savedEmail');
      savedPassword = prefs.getString('savedPassword');

      if (savedEmail == null || savedPassword == null) {
        _showFlushbar('Please sign up first', Colors.orange);
      } else if (emailController.text == savedEmail && passController.text == savedPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              name: nameController.text,
              email: emailController.text,
              password: passController.text,
              profileImage: _image,
            ),
          ),
        );
      } else {
        _showFlushbar('Invalid email or password', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.pink.shade200, Colors.purple.shade200],
                ),
              ),
              child: CustomPaint(painter: BubblePainter()),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400, minWidth: 300),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isRegister ? "Sign Up" : "Login",
                          style: TextStyle(
                            color: Colors.pink.shade700,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (isRegister)
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.pink.shade100,
                              backgroundImage: _image != null ? FileImage(_image!) : null,
                              child: _image == null ? Icon(Icons.camera_alt, size: 40, color: Colors.pink) : null,
                            ),
                          ),
                        SizedBox(height: 20),
                        if (isRegister) _buildTextField(nameController, 'Enter username', Icons.person, (value) {
                          if (value==null || value.isEmpty) return "Enter username";
                          return null;
                        }),
                        _buildTextField(emailController, 'Enter email', Icons.email, (value) {
                          if (value!.isEmpty) return "Enter email";
                          return null;
                        }),
                        _buildTextField(passController, 'Enter password', Icons.lock, (value) {
                          if (value!.length < 8) return "Password must be at least 8 characters";
                          return null;
                        }, isPassword: true),
                        if (isRegister) _buildTextField(conPassController, 'Confirm password', Icons.lock, (value) {
                          if (value != passController.text) return "Passwords don't match";
                          return null;
                        }, isPassword: true),
                        SizedBox(height: 30),
                        _buildButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _handleAuth,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
          child: Text(isRegister ? 'Sign Up' : 'Login', style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
        SizedBox(width: 20),
        TextButton(
          onPressed: () => setState(() => isRegister = !isRegister),
          child: Text(isRegister ? 'Login' : 'Sign Up', style: TextStyle(fontSize: 16, color: Colors.pink)),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, String? Function(String?) validator, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword ? isHide : false,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: Icon(icon, color: Colors.pink.shade700),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(isHide ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => isHide = !isHide),
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.1), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 60, paint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.7), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.9), 55, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}