import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/club260/club260_screen.dart';
import '../../features/club260/club260_feed_screen.dart';
import '../../features/club260/club260_messages_screen.dart';
import '../../features/club260/club260_membership_screen.dart';
import '../../features/club260/club260_courses_screen.dart';
import '../../features/club260/club260_payment_screen.dart';
import '../../features/club260/club260_profile_screen.dart';
import '../../features/code260/code260_screen.dart';
import '../../features/events/events_screen.dart';
import '../../features/blog/blog_screen.dart';
import '../../features/admin/admin_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/club260',
      builder: (context, state) => const Club260Screen(),
      routes: [
        GoRoute(
          path: 'feed',
          builder: (context, state) => const Club260FeedScreen(),
        ),
        GoRoute(
          path: 'messages',
          builder: (context, state) => const Club260MessagesScreen(),
        ),
        GoRoute(
          path: 'membership',
          builder: (context, state) => const Club260MembershipScreen(),
        ),
        GoRoute(
          path: 'courses',
          builder: (context, state) => const Club260CoursesScreen(),
        ),
        GoRoute(
          path: 'payment',
          builder: (context, state) {
            final plan = state.uri.queryParameters['plan'] ?? 'explorer';
            final billing = state.uri.queryParameters['billing'] ?? 'monthly';
            return Club260PaymentScreen(plan: plan, billing: billing);
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const Club260ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/code260',
      builder: (context, state) => const Code260Screen(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: '/blog',
      builder: (context, state) => const BlogScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: const Color(0xFF0A0A0A),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '404',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Page not found',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
