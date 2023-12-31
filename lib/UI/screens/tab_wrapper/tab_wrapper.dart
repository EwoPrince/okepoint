import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:okepoint/constants/app_routes.dart';

import '../../../data/states/user_state.dart';
import 'components/auth.dart';

class TabWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const TabWrapper({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);

    ref.listen(userStateProvider, (oldUser, newUser) {
      if (newUser == null) navigationShell.goBranch(0);
    });

    return Material(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          onTap: (value) => navigationShell.goBranch(
            value,
            initialLocation: value == navigationShell.currentIndex,
          ),
          items: navigationShell.route.branches.map(
            (branch) {
              final path = branch.initialLocation!;
              return BottomNavigationBarItem(
                icon: Icon(getPathIcon(path), color: Theme.of(context).unselectedWidgetColor),
                activeIcon: Icon(getPathIcon(path), color: Theme.of(context).primaryColor),
                label: "",
              );
            },
          ).toList(),
        ),
        body: Stack(
          children: [
            ClipRRect(child: navigationShell),
            if (user == null) const AuthenticationView(),
          ],
        ),
      ),
    );
  }

  IconData getPathIcon(String path) {
    final route = AppRoutes.values.firstWhere((route) => path == route.path);

    switch (route) {
      case AppRoutes.profile:
        return CupertinoIcons.person_alt_circle_fill;
      default:
        return CupertinoIcons.map_fill;
    }
  }
}
