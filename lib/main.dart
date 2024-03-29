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

  Food item = Food.fill('', '', DateTime(0), DateTime(0), '', false);

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
        title: const Text("Fridge Buddy"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
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
            if(foodList.isNotEmpty)
              displayCards(foodList)
            else
              const Expanded(
                child: Center(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: Text("No product"),
                ),
              )
          ],
        ),
        Column(
          children: [
            if(fridgeList.isNotEmpty)
              displayCards(fridgeList)
            else
              const Expanded(
                child: Center(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: Text("No product"),
                ),
              )
          ],
        ),
        Column(
          children: [
            if(freezerList.isNotEmpty)
              displayCards(freezerList)
            else
              const Expanded(
                child: Center(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: Text("No product"),
                ),
              )
          ],
        ),
        Column(
          children: [
            if(pantryList.isNotEmpty)
              displayCards(pantryList)
            else
              const Expanded(
                child: Center(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: Text("No product"),
                ),
              )
          ],
        ),

      ]),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 35),
            child: PopupMenuButton(
              icon: const Icon(Icons.filter_list_sharp),
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
                  child: const Text('Name'),
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'age',
                  value: 'age',
                  child: const Text('Age'),
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'expDate',
                  value: 'expDate',
                  child: const Text('Exp Date'),
                ),
                CheckedPopupMenuItem(
                  checked: _selectedView == 'favorite',
                  value: 'favorite',
                  child: const Text('Favorite'),
                ),
              ],
            ),
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              _navigateAndDisplaySelection(context, Food());
            },
            tooltip: 'Add new item',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }

  Expanded displayCards(List<Food> list) {
    try {
      return Expanded(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, index) {
             return Card(
               child: InkWell(
                 onTap: () {
                   _navigateAndDisplaySelection(context, list[index]);
                 },
                 child: Container(
                   margin: EdgeInsets.fromLTRB(0, 12, 12, 12),
                   child: Row(
                     children: [
                       Expanded(flex: 2, child: Container(
                         child: Icon(Icons.add_photo_alternate_outlined),
                       )),
                       Expanded(flex: 7, child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(list[index].name, style: TextStyle(fontSize: 16),),
                           Text(list[index].amount, style: TextStyle(fontSize: 16),),
                           Text('Expires on ${list[index].expDate.month}/${list[index].expDate.day}/${list[index].expDate.year}, (${list[index].daysUntilExp} days left)',
                             style: TextStyle(fontSize: 12, color: Colors.grey),),
                           Text('Bought on ${list[index].dayBought.month}/${list[index].dayBought.day}/${list[index].dayBought.year}, (${list[index].age} days old)',
                             style: TextStyle(fontSize: 12, color: Colors.grey),)
                         ],
                       )),
                       Expanded(flex: 1, child: Column(
                         children: [
                           Visibility(
                             visible: list[index].favorite,
                             child: const Icon(
                               Icons.favorite,
                               color: Colors.red,
                             ),
                           ),
                           Text('')
                         ],
                       ))
                     ],
                   ),
                 ),
               ),
             );
          },
        ),
      );
    } catch (e) {
      throw Exception("Empty list");
    }

  }

  void _navigateAndDisplaySelection(BuildContext context, Food fooditem) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editing_page(fooditem: fooditem,)),
    );

    if(!result.isEmpty) {
      setState(() {
        widget.item = result;
        foodList.add(result);
        switch(result.location) {
          case 'Fridge': {fridgeList.add(result);}
          break;
          case 'Freezer': {freezerList.add(result);}
          break;
          case 'Pantry': {pantryList.add(result);}
          break;
        }

        if(!fooditem.isEmpty) {
          foodList.remove(fooditem);
          switch(fooditem.location) {
            case 'Fridge': {fridgeList.remove(fooditem);}
            break;
            case 'Freezer': {freezerList.remove(fooditem);}
            break;
            case 'Pantry': {pantryList.remove(fooditem);}
            break;
          }
        }

        _sortFoodList();
        encodeList(result);
      });
    }
  }

  _clearData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove('All');
    sharedPref.remove('Fridge');
    sharedPref.remove('Freezer');
    sharedPref.remove('Pantry');
    setState(() {
      foodList = [];
      fridgeList = [];
      freezerList = [];
      pantryList = [];
    });
  }

  Future<void> encodeList(Food item) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('All', jsonEncode(foodList));
    switch(item.location) {
      case 'Fridge': {await sharedPref.setString('Fridge', jsonEncode(fridgeList));}
        break;
      case 'Freezer': {await sharedPref.setString('Freezer', jsonEncode(freezerList));}
        break;
      case 'Pantry': {await sharedPref.setString('Pantry', jsonEncode(pantryList));}
        break;
    }
  }

  Future<void> decodeList() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    List<List<Food>> temp2d = [];
    for(int i=0; i<storageKey.length; i++){
      List<Food> temp = [];
      String? userPref = sharedPref.getString(storageKey[i]);
      if(userPref != null) {
        temp = (json.decode(userPref) as List).map((j) => Food.fromJson(j)).toList();
        temp2d.add(temp);
      }
    }
    if(temp2d.isNotEmpty) {
      setState(() {
        foodList = List.from(temp2d[0]);
        fridgeList = List.from(temp2d[1]);
        freezerList = List.from(temp2d[2]);
        pantryList = List.from(temp2d[3]);
      });
    }
  }

  _sortFoodList() {
    switch (_selectedView) {
      case 'name':{
        foodList.sort((a, b) => a.name.compareTo(b.name));
        fridgeList.sort((a, b) => a.name.compareTo(b.name));
        freezerList.sort((a, b) => a.name.compareTo(b.name));
        pantryList.sort((a, b) => a.name.compareTo(b.name));
      }

        break;

      case 'age':
        foodList.sort((a, b) => a.age.compareTo(b.age));
        fridgeList.sort((a, b) => a.age.compareTo(b.age));
        freezerList.sort((a, b) => a.age.compareTo(b.age));
        pantryList.sort((a, b) => a.age.compareTo(b.age));
        break;

      case 'expDate':
        foodList.sort((a, b) => a.daysUntilExp.compareTo(b.daysUntilExp));
        fridgeList.sort((a, b) => a.daysUntilExp.compareTo(b.daysUntilExp));
        freezerList.sort((a, b) => a.daysUntilExp.compareTo(b.daysUntilExp));
        pantryList.sort((a, b) => a.daysUntilExp.compareTo(b.daysUntilExp));
        break;

      case 'favorite':
        foodList.sort((a, b) => b.favorite ? 1 : -1);
        fridgeList.sort((a, b) => b.favorite ? 1 : -1);
        freezerList.sort((a, b) => b.favorite ? 1 : -1);
        pantryList.sort((a, b) => b.favorite ? 1 : -1);
        break;
    }
  }
}

