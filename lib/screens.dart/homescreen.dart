import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:stashlink/models/list_model.dart';
import 'package:stashlink/services/share_service.dart';
import 'package:stashlink/services/storage_service.dart';
import 'package:stashlink/widgets/add_link_dialog.dart';
import 'package:stashlink/widgets/link_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ListModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinks();
    // Wait one frame so the widget tree is fully built before showing dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShareService.listen((url) async {
        if (!mounted) return;
        final result = await showDialog<ListModel>(
          context: context,
          builder: (_) => AddLinkDialog(initialUrl: url),
        );
        if (result != null) await _saveLink(result);
        await ReceiveSharingIntent.instance.reset();
      });
    });
  }

  @override
  void dispose() {
    ShareService.dispose();
    super.dispose();
  }

  Future<void> _loadLinks() async {
    final loaded = await StorageService.loadLink();
    if (!mounted) return;
    setState(() {
      _items = loaded;
      _isLoading = false;
    });
  }

  Future<void> _saveLink(ListModel link) async {
    await StorageService.addLink(link);
    if (!mounted) return;
    setState(() => _items.add(link));
  }

  Future<void> _deleteLink(int index) async {
    await StorageService.delLink(_items[index].url);
    if (!mounted) return;
    setState(() => _items.removeAt(index));
  }

  Future<void> _openAddDialog({String? initialUrl}) async {
    final result = await showDialog<ListModel>(
      context: context,
      builder: (_) => AddLinkDialog(initialUrl: initialUrl),
    );
    if (result != null) await _saveLink(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        title: const Text(
          'StashLink',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        tooltip: 'Add bookmark',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'No bookmarks yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: _items.length,
      itemBuilder: (context, index) => LinkCard(
        link: _items[index],
        onDelete: () => _deleteLink(index),
      ),
    );
  }
}
