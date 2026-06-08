import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'scaffold_with_nav_bar.dart';

import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/recent_activity_screen.dart';
import '../../features/properties/presentation/screens/property_list_screen.dart';
import '../../features/properties/presentation/screens/property_details_screen.dart';
import '../../features/tenants/presentation/screens/tenant_list_screen.dart';
import '../../features/tenants/presentation/screens/tenant_profile_screen.dart';
import '../../features/finance/presentation/screens/financial_reports_screen.dart';
import '../../features/settings/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Branch 0: Dashboard
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) =>
                    const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'recent-activity',
                    builder: (BuildContext context, GoRouterState state) =>
                        const RecentActivityScreen(),
                  ),
                ]),
          ],
        ),

        // Branch 1: Properties
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/properties',
              builder: (BuildContext context, GoRouterState state) =>
                  const PropertyListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (BuildContext context, GoRouterState state) {
                    final id = state.pathParameters['id']!;
                    return PropertyDetailsScreen(propertyId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 2: Tenants
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/tenants',
              builder: (BuildContext context, GoRouterState state) =>
                  const TenantListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (BuildContext context, GoRouterState state) {
                    final id = state.pathParameters['id']!;
                    return TenantProfileScreen(tenantId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 3: Financial
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/financial',
              builder: (BuildContext context, GoRouterState state) =>
                  const FinancialReportsScreen(),
            ),
          ],
        ),

        // Branch 4: Settings
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
