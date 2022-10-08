import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _DrawerHeader(),
            Expanded(child: _DrawerBody()),
            _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Material(
            type: MaterialType.circle,
            elevation: 1,
            color: colorScheme.surface,
            shadowColor: colorScheme.shadow,
            surfaceTintColor: colorScheme.surfaceTint,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.person_outline,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'User Name',
            style: theme.textTheme.titleSmall,
          ),
          Text(
            '@username',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerBody extends StatelessWidget {
  const _DrawerBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _DrawerCard(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
        ),
        _DrawerCard(
          icon: Icons.chat_bubble_outline,
          title: 'Messages',
        ),
        _DrawerCard(
          icon: Icons.settings_outlined,
          title: 'Settings',
        ),
        _DrawerCard(
          icon: Icons.call_outlined,
          title: 'Support',
        ),
        _DrawerCard(
          icon: Icons.info_outline,
          title: 'About',
        ),
        _DrawerCard(
          icon: Icons.power_settings_new_outlined,
          title: 'Logout',
        ),
      ],
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          indent: 12,
          endIndent: 12,
          thickness: 1,
          height: 1,
        ),
        FlutterLogo(
          size: 72,
          textColor: Theme.of(context).textTheme.bodyMedium!.color!,
          style: FlutterLogoStyle.horizontal,
        )
      ],
    );
  }
}

class _DrawerCard extends StatelessWidget {
  const _DrawerCard({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
