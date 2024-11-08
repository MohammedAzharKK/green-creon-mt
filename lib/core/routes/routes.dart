import 'package:flutter_signin/features/authentication/view/pages/signin_page.dart';
import 'package:flutter_signin/features/authentication/view/pages/signup_page.dart';
import 'package:flutter_signin/features/weather/views/pages/homescreen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: "/signup",
  routes: [
    GoRoute(
      path: "/signup",
      name: "signup",
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: "/signin",
      name: "signin",
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: "/home",
      name: "HomePage",
      builder: (context, state) => const Homescreen(),
    ),
  ],
);
