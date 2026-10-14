import 'package:flutter/material.dart';

import '../../models/source_model.dart';
import '../../services/navigation_service.dart';

/// Small "Bronnen" button that opens a bottom sheet.
class SourcesButton extends StatelessWidget {
  const SourcesButton({super.key, required this.sources});
  final List<HistoricalSource> sources;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();
    return TextButton.icon(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => _SourcesSheet(sources: sources),
      ),
      icon: const Icon(Icons.menu_book_outlined, size: 20),
      label: const Text('Bronnen'),
    );
  }
}

class _SourcesSheet extends StatelessWidget {
  const _SourcesSheet({required this.sources});
  final List<HistoricalSource> sources;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Text('Bronnen', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final s in sources)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.title),
              subtitle: Text(s.organization),
              trailing: s.url == null ? null : const Icon(Icons.open_in_new),
              onTap: s.url == null
                  ? null
                  : () async {
                      final ok = await const NavigationService().openUrl(
                        s.url!,
                      );
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'De link kon niet worden geopend. Is er internet?',
                            ),
                          ),
                        );
                      }
                    },
            ),
        ],
      ),
    );
  }
}
