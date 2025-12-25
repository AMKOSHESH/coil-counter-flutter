IconButton(
  icon: const Icon(Icons.settings),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (_) => const SettingsSheet(),
    );
  },
)
