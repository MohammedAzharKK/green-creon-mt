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
    var isloading = useState(false);

    final formkey = useMemoized(() => GlobalKey<FormState>());

    Future<void> signUp() async {
      try {
        isloading.value = true;

        if (formkey.currentState!.validate()) {
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

            if (context.mounted) {
              // Check if context is still valid
              context.goNamed("signin");
            }
          }
        }
      } catch (e) {
        // Handle any Firebase authentication errors
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        isloading.value = false;
      }
    }

    Future<void> handleGoogleSignIn() async {
      await GoogleAuthServices.signInWithGoogle(context);
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
                TextFieldWidget(
                  controller: emailController,
                  fieldname: "Email",
                  validator: RegisterController.validateEmail,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: passwordController,
                  fieldname: "Password",
                  validator: RegisterController.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
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
                    onPressed: signUp,
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
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: handleGoogleSignIn,
                    icon: Image.asset(
                      'assets/images/google-logo.png',
                      height: 20,
                    ),
                    label: const Text(
                      "Continue with Google",
                      style: TextStyle(color: Colors.black),
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
