import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin/features/authentication/view/pages/signin_page.dart';
import 'package:flutter_signin/features/authentication/view/pages/signup_page.dart';
import 'package:flutter_signin/features/weather/views/pages/homescreen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    // Show loading while checking auth state
    if (state.matchedLocation == '/') {
      return FirebaseAuth.instance.currentUser != null ? '/home' : '/signup';
    }

    final isAuthenticated = FirebaseAuth.instance.currentUser != null;

    if (!isAuthenticated &&
        !state.matchedLocation.startsWith('/signup') &&
        !state.matchedLocation.startsWith('/signin')) {
      return '/signup';
    }

    if (isAuthenticated &&
        (state.matchedLocation.startsWith('/signup') ||
            state.matchedLocation.startsWith('/signin'))) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),
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
  errorBuilder: (context, state) => const SignUpPage(),
);
