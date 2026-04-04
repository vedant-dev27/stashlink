import 'package:flutter/material.dart';
import 'package:stashlink/models/list_model.dart';
import 'package:stashlink/widgets/add_link_dialog.dart';
import 'package:stashlink/widgets/link_card.dart';
import 'package:stashlink/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ListModel> items = [];

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    final loaded = await StorageService.loadLink();
    setState(() => items = loaded);
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
            icon: const Icon(
              Icons.search_rounded,
            ),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
            ),
            tooltip: 'Filter',
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => LinkCard(
          onDelete: () async {
            await StorageService.delLink(items[index].url);
            setState(() {
              items.removeAt(index);
            });
          },
          link: items[index],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<ListModel>(
            context: context,
            builder: (context) => const AddLinkDialog(),
          );

          if (result != null) {
            await StorageService.addLink(result);

            setState(() {
              items.add(result);
            });
          }
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
    );
  }
}
