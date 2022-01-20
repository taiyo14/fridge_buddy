import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Food.dart';

class editing_page extends StatefulWidget {
  const editing_page({Key? key}) : super(key: key);

  @override
  _editing_pageState createState() => _editing_pageState();
}

class _editing_pageState extends State<editing_page> {
  bool favorite = false;
  DateTime testing1 = DateTime(0);
  DateTime testing2 = DateTime(0);
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var expDateController = TextEditingController();
  var buyDateController = TextEditingController();
  String dropdownValue = 'Fridge'; // contains the value inside the dropdown menu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              iconSize: 30.0,
              icon: favorite == true
                  ? Icon(Icons.favorite, color: Colors.red,)
                  : Icon(Icons.favorite_border),
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
                Text(
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
                Text(
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
                Text(
                  "Expiration Date: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    width: 150,
                    child: TextField(
                      controller: expDateController, //editing controller of this TextField
                      decoration: InputDecoration(
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
                          testing1 = DateTime(pickedDate.year,pickedDate.month,pickedDate.day);
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ))
              ],
            ),
            Row(
              children: [
                Text(
                  "Buy Date: ",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                    width: 150,
                    child: TextField(
                      controller: buyDateController, //editing controller of this TextField
                      decoration: InputDecoration(
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
                          testing2 = DateTime(pickedDate.year,pickedDate.month,pickedDate.day);
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ))
              ],
            ),
            Row(
              children: [
                Text(
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
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              flex: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.backspace), Text("Cancel")],
                  )),
            ),
            Expanded(
              flex: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, Food(nameController.text,amountController.text,testing1,testing2,dropdownValue,favorite));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.check), Text("OK")],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
