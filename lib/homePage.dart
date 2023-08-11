import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var allItems = List.generate(50, (index) => 'item $index');
  var items = <String>[];
  var searchHistory = <String>[];
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    controller.addListener(queryListener);
    // searchController.addListener(queryListener);
  }

  @override
  void dispose() {
    controller.removeListener(queryListener);
    controller.dispose();
    // searchController.removeListener(queryListener);
    // searchController.dispose();
    super.dispose();
  }

  void queryListener() {
    //search(searchController.text);
    search(controller.text);
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        items = allItems;
      });
    } else {
      setState(() {
        items = allItems
            .where((e) =>
                e.toLowerCase().contains(query.trim().toLowerCase()) ||
                e.toLowerCase().contains(query.trim().toUpperCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Implement your SearchBar widget or use Flutter's built-in TextField
            SearchAnchor(
                //viewLeading: Icon(Icons.search),
                dividerColor: const Color.fromRGBO(112, 124, 154, 1),
                viewElevation: 0,
                searchController: controller,
                viewHintText: "Search....",
                viewLeading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => controller.closeView(controller.text),
                ),
                //viewTrailing: [Icon(Icons.close)],
                // viewShape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(12)),
                builder: (context, controller) {
                  return IconButton(
                      onPressed: () => controller.openView(),
                      icon: Icon(Icons.search));
                  //     SearchBar(
                  //   controller: searchController,
                  //   hintText: 'Search...',
                  //   onTap: () => controller.openView(),
                  // );
                },
                suggestionsBuilder: (context, controller) {
                  return [
                    if (controller.text.isNotEmpty) ...[
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = items[index];
                            return ListTile(
                              title: Text(item),
                            );
                          },
                        ),
                      ),
                    ]
                  ];
                }),

            // IconButton(
            //     onPressed: () {
            //       controller.openView();
            //     },
            //     icon: Icon(Icons.search)),

            Expanded(
              child: ListView.builder(
                itemCount: items.isEmpty ? allItems.length : items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items.isEmpty ? allItems[index] : items[index];
                  return ListTile(
                    title: Text(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
