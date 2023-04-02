import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Food.dart';

class editing_page extends StatefulWidget {
  const editing_page({Key? key, required this.fooditem}) : super(key: key);

  @override
  _editing_pageState createState() => _editing_pageState();

  final Food fooditem;
}

class _editing_pageState extends State<editing_page> {
  bool favorite = false;
  DateTime expDate = DateTime.now();
  DateTime buyDate = DateTime.now();
  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController expDateController;
  late TextEditingController buyDateController;
  late String dropdownValue; // contains the value inside the dropdown menu

  final DateFormat formatter = DateFormat('MM-dd-yyyy');

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.fooditem.name);
    amountController = TextEditingController(text: widget.fooditem.amount);
    expDateController = TextEditingController(text: DateFormat('MM-dd-yyyy').format(widget.fooditem.expDate));
    buyDateController = TextEditingController(text: DateFormat('MM-dd-yyyy').format(widget.fooditem.dayBought));
    dropdownValue = widget.fooditem.location;
    favorite = widget.fooditem.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {Navigator.pop(context, Food());},),
        actions: [
          IconButton(
              iconSize: 30.0,
              icon: favorite == true
                  ? const Icon(Icons.favorite, color: Colors.red,)
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                setState(() {
                  favorite = !favorite;
                });
              }),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 25.0, left: 10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Product Name: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  width: 150,
                  child: TextField(
                    controller: nameController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "Amount: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  width: 150,
                  child: TextField(
                    controller: amountController,
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "Expiration Date: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    width: 150,
                    child: TextField(
                      controller: expDateController, //editing controller of this TextField
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                      ),
                      readOnly: true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2050));
                        
                        if (pickedDate != null) {
                          setState(() {
                            expDateController.text = DateFormat('MM-dd-yyyy').format(pickedDate);
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Buy Date: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    width: 150,
                    child: TextField(
                      controller: buyDateController, //editing controller of this TextField
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                      ),
                      readOnly: true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          setState(() {
                            buyDateController.text = DateFormat('MM-dd-yyyy').format(pickedDate);;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Location: ",
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton(
                    value: dropdownValue,
                    underline: Container(
                      height: 2,
                      color: Colors.black26,
                    ),
                    items: <String>['Fridge', 'Freezer', 'Pantry']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    })
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(child: SizedBox(
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, Food());
              },
              icon: const Icon(Icons.backspace),
              label: const Text("Cancel"),
            ),
          ),
          ),
          Expanded(child: SizedBox(
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, Food.fill(nameController.text,amountController.text,formatter.parse(expDateController.text),formatter.parse(buyDateController.text),dropdownValue,favorite));
              },
              icon: const Icon(Icons.check),
              label: const Text("OK"),
            ),
          ),
          )
        ],
      ),
    );
  }
}
