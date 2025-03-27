import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // Import your provider
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "deepmehta185@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "Dm@123456789");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome To Your\nPersonal Expense Tracker",
                    textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.w)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your email";
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 2.h),
                Consumer<AuthProvider>(
                  builder: (BuildContext context, AuthProvider value, Widget? child) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: value.showPassword,
                      decoration: InputDecoration(
                          suffix: GestureDetector(onTap: () => value.showPass(), child: const Icon(Icons.remove_red_eye)),
                          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                          labelText: "Password",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.w))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    );
                  },
                ),

                SizedBox(height: 2.h),

                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    return value.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.w),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Provider.of<AuthProvider>(context, listen: false).login(emailController.text, passwordController.text, context);
                                    }
                                  },
                                  child: Text("Login", style: TextStyle(fontSize: 15.sp, color: Colors.white)),
                                ),
                              ),
                            ],
                          );
                  },
                ),

                SizedBox(height: 2.h),

                // Signup Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(fontSize: 15.sp)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                      },
                      child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontSize: 16.sp)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
