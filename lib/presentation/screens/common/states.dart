import 'package:flutter/material.dart';

import '../auth/_auth_widgets.dart';
import 'state_scaffold.dart';

/// No matches state — used by search inside cook screens.
class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StateScaffold(
      title: 'Padosi Partner',
      headline: 'No matches',
      body: 'Try a different keyword or clear your filters.',
      iconChild: const Text('🔍'),
      primaryLabel: 'Clear filters',
      primaryVariant: AuthBtnVariant.ghost,
      onPrimary: () => Navigator.pop(context),
    );
  }
}

/// Offline state — shown when the device drops connection.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StateScaffold(
      title: 'Padosi Partner',
      headline: "You're offline",
      body: 'Check your connection — your orders will sync when '
          'you reconnect.',
      iconChild: const Text('📡'),
      primaryLabel: 'Retry',
      onPrimary: () => Navigator.pop(context),
    );
  }
}
