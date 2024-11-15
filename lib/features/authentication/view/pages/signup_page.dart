import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin/features/authentication/controller/registeration_controller.dart';
import 'package:flutter_signin/features/authentication/services/google_auth_service/google_auth_services.dart';
import 'package:flutter_signin/features/authentication/view/widgets/text_feild_widget.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends HookWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    //to show circle progress indicator when clicking signup button
    var isloading = useState(false);

    //to show loading in signin with google
    var isGoogleLoading = useState(false);

    final formkey = useMemoized(() => GlobalKey<FormState>());

//to execute on signup ontap
    Future<void> signUpOnTap() async {
      try {
        isloading.value = true;

//to check regex and ensure no error
        if (formkey.currentState!.validate()) {
          //creating user using firebase
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

//to check the widget is in the widget tree
            if (context.mounted) {
              context.goNamed("signin");
            }
          }
        }
      } catch (e) {
        if (context.mounted) {
          //show error msg as a snack bar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        isloading.value = false;
      }
    }

//to execute on signin with google
    Future<void> googleSignInOnTap() async {
      try {
        isGoogleLoading.value = true;
        await GoogleAuthServices.signInWithGoogle(context);
      } finally {
        isGoogleLoading.value = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                //email text feild
                TextFieldWidget(
                  controller: emailController,
                  fieldname: "Email",
                  validator: RegisterController.validateEmail,
                ),
                const SizedBox(height: 20),

                //password text feild
                TextFieldWidget(
                  controller: passwordController,
                  fieldname: "Password",
                  validator: RegisterController.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

                //confirm password
                TextFieldWidget(
                  controller: confirmPasswordController,
                  fieldname: "Confirm Password",
                  validator: (value) =>
                      RegisterController.validateConfirmPassword(
                          passwordController.text, value),
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: signUpOnTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isloading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Sign Up"),
                  ),
                ),
                const SizedBox(height: 20),

                //google signin button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: isGoogleLoading.value ? null : googleSignInOnTap,
                    icon: isGoogleLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : Image.asset(
                            'assets/images/google-logo.png',
                            height: 20,
                          ),
                    label: Text(
                      isGoogleLoading.value
                          ? "Please wait..."
                          : "Continue with Google",
                      style: const TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => context.goNamed("signin"),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
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
