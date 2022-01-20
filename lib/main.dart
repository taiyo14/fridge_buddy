import 'package:cs4750_project/editing_page.dart';
import 'package:cs4750_project/settings_page.dart';
import 'package:flutter/material.dart';
import 'Food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  Food item = Food('', '', DateTime(0), DateTime(0), '', false);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
     with TickerProviderStateMixin {
  _MyHomePageState();
  List<Food> foodList = [];
  List<Food> fridgeList = [];
  List<Food> freezerList = [];
  List<Food> pantryList = [];

  String _selectedView = 'name';

  static const List<Tab> myTabs = [
    Tab(text: 'All'),
    Tab(text: 'Fridge'),
    Tab(text: 'Freezer'),
    Tab(text: 'Pantry'),
  ];

  static const List<String> storageKey = ['All', 'Fridge', 'Freezer', 'Pantry'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    decodeList();
    setState(() {});

    _tabController = TabController(
      initialIndex: 0,
      length: myTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fridge Buddy"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) => setState(() {
              switch (value) {
                case 'settings':
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const settings_page()),
                    );
                  }
                  break;
                case 'clear':
                  {
                    _clearData();
                  }
                  break;
              }
            }),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Data'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Column(
          children: [
            if (foodList.length > 0)
              Expanded(
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        margin: EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(foodList[index].name)),
                                Expanded(child: Text(foodList[index].amount))
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${foodList[index].daysUntilExp} days until expiration on ${foodList[index].expDate?.month}/${foodList[index].expDate?.day}${foodList[index].expDate?.year}'),
                                Text('${foodList[index].age} days old, bought on ${foodList[index].dayBought?.month}/${foodList[index].dayBought?.day}${foodList[index].dayBought?.year}')
                              ],
                            ),
                          ),
                          trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: foodList[index].favorite,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )),
                        ));
                  },
                ),
              )
            else
              Visibility(
                child: Text("No product"),
                visible: false,
              )
          ],
        ),
        Column(
          children: [
            if (fridgeList.length > 0)
              Expanded(
                child: ListView.builder(
                  itemCount: fridgeList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        margin: EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(fridgeList[index].name)),
                                Expanded(child: Text(fridgeList[index].amount))
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${fridgeList[index].daysUntilExp} days until expiration on ${fridgeList[index].expDate?.month}/${fridgeList[index].expDate?.day}${fridgeList[index].expDate?.year}'),
                                Text('${fridgeList[index].age} days old, bought on ${fridgeList[index].dayBought?.month}/${fridgeList[index].dayBought?.day}${fridgeList[index].dayBought?.year}')
                              ],
                            ),
                          ),
                          trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: fridgeList[index].favorite,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )),
                        ));
                  },
                ),
              )
            else
              Visibility(
                child: Text("No product"),
                visible: false,
              )
          ],
        ),
        Column(
          children: [
            if (freezerList.length > 0)
              Expanded(
                child: ListView.builder(
                  itemCount: freezerList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        margin: EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(freezerList[index].name)),
                                Expanded(child: Text(freezerList[index].amount))
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${freezerList[index].daysUntilExp} days until expiration on ${freezerList[index].expDate?.month}/${freezerList[index].expDate?.day}${freezerList[index].expDate?.year}'),
                                Text('${freezerList[index].age} days old, bought on ${freezerList[index].dayBought?.month}/${freezerList[index].dayBought?.day}${freezerList[index].dayBought?.year}')
                              ],
                            ),
                          ),
                          trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: freezerList[index].favorite,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )),
                        ));
                  },
                ),
              )
            else
              Visibility(
                child: Text("No product"),
                visible: false,
              )
          ],
        ),
        Column(
          children: [
            if (pantryList.length > 0)
              Expanded(
                child: ListView.builder(
                  itemCount: pantryList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                        margin: EdgeInsets.all(15.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text(pantryList[index].name)),
                                Expanded(child: Text(pantryList[index].amount))
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${pantryList[index].daysUntilExp} days until expiration on ${pantryList[index].expDate?.month}/${pantryList[index].expDate?.day}${pantryList[index].expDate?.year}'),
                                Text('${pantryList[index].age} days old, bought on ${pantryList[index].dayBought?.month}/${pantryList[index].dayBought?.day}${pantryList[index].dayBought?.year}')
                              ],
                            ),
                          ),
                          trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Visibility(
                                visible: pantryList[index].favorite,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )),
                        ));
                  },
                ),
              )
            else
              Visibility(
                child: Text("No product"),
                visible: false,
              )
          ],
        ),

      ]),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 35),
            child: PopupMenuButton(
              icon: Icon(Icons.filter_list_sharp),
              onSelected: (value) => setState(() {
                _selectedView = value.toString();
                _sortFoodList();
              }),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'tag',
                  child: Text('Sort by:'),
                  enabled: false,
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'name',
                  value: 'name',
                  child: Text('Name'),
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'age',
                  value: 'age',
                  child: Text('Age'),
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'expDate',
                  value: 'expDate',
                  child: Text('Exp Date'),
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'favorite',
                  value: 'favorite',
                  child: Text('Favorite'),
                ),
              ],
            ),
          ),
          Spacer(),
          FloatingActionButton(
            onPressed: () {
              _navigateAndDisplaySelection(context);
              setState(() {});
            },
            tooltip: 'Add new item',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const editing_page()),
    );

    setState(() {
      widget.item = result;
      foodList.add(result);
      _sortFoodList();
      encodeList();
    });
  }

  _clearData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove('All');
  }

  Future<void> encodeList() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('All', jsonEncode(foodList));
    setState(() {});
  }

  Future<void> decodeList() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? userPref = sharedPref.getString('All');
    if (userPref != null) {
      foodList =
          (json.decode(userPref) as List).map((i) => Food.fromJson(i)).toList();
      _sortFoodList();
      for (int i = 1; i <= storageKey.length - 1; i++) {
        switch (storageKey[i]) {
          case 'Fridge':
            {
              //fridgeList.clear();
              for (int j = 0; j <= foodList.length - 1; j++) {
                if (foodList[j].location == storageKey[i])
                  fridgeList.add(foodList[j]);
              }
            }
            break;
          case 'Freezer':
            {
              // freezerList.clear();
              for (int j = 0; j <= foodList.length - 1; j++) {
                if (foodList[j].location == storageKey[i])
                  freezerList.add(foodList[j]);
              }
            }
            break;
          case 'Pantry':
            {
              // pantryList.clear();
              for (int j = 0; j <= foodList.length - 1; j++) {
                if (foodList[j].location == storageKey[i])
                  pantryList.add(foodList[j]);
              }
            }
            break;
        }
      }
    }
  }

  _sortFoodList() {
    switch (_selectedView) {
      case 'name':
        foodList.sort((a, b) => a.name.compareTo(b.name));
        break;

      case 'age':
        foodList.sort((a, b) => a.age.compareTo(b.age));
        break;

      case 'expDate':
        foodList.sort((a, b) => a.daysUntilExp.compareTo(b.daysUntilExp));
        break;

      case 'favorite':
        foodList.sort((a, b) {
          if (b.favorite) {
            return 1;
          }
          return -1;
        });
        break;
    }
  }
}
