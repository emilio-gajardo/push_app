import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/screens/details_screen.dart';
import 'package:push_app/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen()
    ),

    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) {
        final pushMessageId = state.pathParameters['messageId'] ?? '0';
        if (kDebugMode) print('>> [app_router.dart] pushMessageId: $pushMessageId');
        return DetailsScreen(pushMessageId: pushMessageId);
      }
    ),
  ]
);