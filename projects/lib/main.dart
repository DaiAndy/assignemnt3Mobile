import 'dart:ffi';

import 'package:flutter/material.dart';
import 'foodAppDatabaseHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // setup for the main page
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: foodPage(),
    );
  }
}

// this widget will manage the display of list of foods
class foodPage extends StatefulWidget {
  @override
  foodPageState createState() => foodPageState();
}

class foodPageState extends State<foodPage> {

  // list to hold all food items and selected order items
  List<Map<String, dynamic>> foodItems = [];
  StringBuffer orderedItems = StringBuffer();
  final TextEditingController targetTotal = TextEditingController();
  var currentCost = 0.0;

  // creates variable for the database
  var db = foodAppDatabaseHelper();

  // initialization
  @override
  void initState() {
    super.initState();
    loadFood();
  }

  // called when main page has loaded
  void loadFood() async {
    var items = await db.getAllFoodItems();
    setState(() {
      foodItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // title to be displayed at the top of the app
      appBar: AppBar(title: Text("Food Items")),
      body: Column(
        children: [

          // textfield to hold the inputted target total from the user
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: TextField(
              controller: targetTotal,
              decoration: InputDecoration(
                labelText: "Enter your target cost",
                border: OutlineInputBorder(),
              ),
            ),
          ),


          // the second view for the list of foods
          Expanded(
            child: ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {

                var food = foodItems[index];

                return ListTile(

                  // display of the list item
                  title: Text(food["name"]),
                  subtitle: Text("\$${food["cost"]}"),

                  // once the user presses this food item
                  onTap: () {

                    // adds the entry name and cost to two different variables to be added
                    var itemCost = double.parse(food["cost"]);
                    var tappedItem = food["name"];
                    currentCost = currentCost + itemCost;
                    orderedItems.write(tappedItem);
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(

        // once done selecting foods, this button will add all those foods to an order for the database
        onPressed: () async {
          double budget = double.tryParse(targetTotal.text) ?? 0.00;
          if (currentCost < budget) {
          // takes the inputted target total and the date and ordered items, adds it to an order for the database table orderTable, default to 0.0

          await db.addOrderPlan("tuesday", orderedItems.toString(), budget);

          // used for testing
          print("Ordered items: ${orderedItems.toString()}");
          print("Target Total: $budget");
          print("Order Cost: $currentCost");

          // tells user order was saved
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Order saved with your target total!")));
          } else {
            // tells user order was not saved
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Went over Budget, did not save order!")));
          }
        },
        // icon on the button is a +
        child: Icon(Icons.add),
      ),
    );
  }
}
