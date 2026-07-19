import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.speed, color: FurColors.primary),
              title: const Text('发音速度'),
              subtitle: const Text('正常'),
              trailing: const Icon(Icons.chevron_right, color: FurColors.outline),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: FurColors.primary),
              title: const Text('关于 FurEnglish'),
              subtitle: const Text('v0.1.0'),
              trailing: const Icon(Icons.chevron_right, color: FurColors.outline),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
