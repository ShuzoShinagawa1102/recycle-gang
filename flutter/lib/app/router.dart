import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_pages.dart';
import '../features/booking/booking_pages.dart';
import '../features/activity/activity_pages.dart';
import '../features/profile/profile_pages.dart';
import '../core/config.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(path: state.uri.path, child: child),
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
        GoRoute(path: '/request', builder: (_, _) => const RequestPage()),
        GoRoute(path: '/activity', builder: (_, _) => const ActivityPage()),
        GoRoute(path: '/me', builder: (_, _) => const ProfilePage()),
      ],
    ),
    GoRoute(
      path: '/tasks',
      builder: (_, _) => const ActivityPage(tasksOnly: true),
    ),
    GoRoute(
      path: '/notifications',
      builder: (_, _) => const NotificationsPage(),
    ),
    GoRoute(path: '/guide', builder: (_, _) => const GuidePage()),
    GoRoute(path: '/prices', builder: (_, _) => const PricesPage()),
    GoRoute(path: '/drafts', builder: (_, _) => const DraftsPage()),
    GoRoute(path: '/booking', builder: (_, _) => const BookingPage()),
    GoRoute(path: '/booking/items', builder: (_, _) => const ItemsPage()),
    GoRoute(path: '/booking/location', builder: (_, _) => const LocationPage()),
    GoRoute(path: '/booking/date', builder: (_, _) => const DatePage()),
    GoRoute(path: '/booking/review', builder: (_, _) => const ReviewPage()),
    GoRoute(
      path: '/facilities/:id',
      builder: (_, s) => FacilityPage(id: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/complete/:id',
      builder: (_, s) => CreatedPage(id: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/activity/:id',
      builder: (_, s) => DetailPage(id: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/activity/:id/qr',
      builder: (_, s) => QrPage(id: s.pathParameters['id']!),
    ),
    GoRoute(path: '/profile/edit', builder: (_, _) => const EditProfilePage()),
    GoRoute(path: '/addresses', builder: (_, _) => const AddressesPage()),
    GoRoute(path: '/payments', builder: (_, _) => const PaymentsPage()),
    GoRoute(path: '/transactions', builder: (_, _) => const TransactionsPage()),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.path, required this.child});
  final String path;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final index = switch (path) {
      '/request' => 1,
      '/activity' => 2,
      '/me' => 3,
      _ => 0,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco_outlined),
            SizedBox(width: 8),
            Text(
              'リサイクルギャング',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              label: Text(
                AppConfig.useMocks ? 'MOCK' : 'LOCAL API',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            context.go(['/', '/request', '/activity', '/me'][i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            label: '依頼する',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'アクティビティ',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'マイページ',
          ),
        ],
      ),
    );
  }
}

class SubPage extends StatelessWidget {
  const SubPage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
  });
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottom;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      ),
      actions: actions,
    ),
    body: body,
    bottomNavigationBar: bottom == null
        ? null
        : SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SizedBox(width: double.infinity, child: bottom),
              ),
            ),
          ),
  );
}
