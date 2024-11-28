import "dart:convert";
import "package:sqflite/sqflite.dart";

class foodAppDatabaseHelper {

  // initializes the two tables, one to hold food items, and the other to hold order
  static String foodTable = "food_items";
  static String orderPlansTable = "order_plans";

  // function to grab the database
  static Future<Database> getDatabase() async {

    return openDatabase(
      "food_ordering.db",
      // database version
      version: 3,

      // create function of the database
      onCreate: (db, version) async {

        // creates table for each food on the list
        await db.execute('''
          CREATE TABLE $foodTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            cost REAL 
          )
        ''');

        // creates table for each order plan
        await db.execute('''
          CREATE TABLE $orderPlansTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            date TEXT, 
            orderedFoods TEXT,
            cost REAL
          )
        ''');

        // sets up 20 foods
        await db.insert(foodTable, {"name": "Hot Dog", "cost": 10.99});
        await db.insert(foodTable, {"name": "Rice", "cost": 5.99});
        await db.insert(foodTable, {"name": "Kimchi", "cost": 1.99});
        await db.insert(foodTable, {"name": "Bugolgi", "cost": 5.99});
        await db.insert(foodTable, {"name": "Fried Chicken", "cost": 12.99});
        await db.insert(foodTable, {"name": "Kimchi Fried Rice", "cost": 11.99});
        await db.insert(foodTable, {"name": "Lamb Skewers", "cost": 7.99});
        await db.insert(foodTable, {"name": "Chicken Skewers", "cost": 4.99});
        await db.insert(foodTable, {"name": "Cheese Pizza", "cost": 2.99});
        await db.insert(foodTable, {"name": "Pepperoni Pizza", "cost": 1.99});
        await db.insert(foodTable, {"name": "Chocolate Cake", "cost": 7.99});
        await db.insert(foodTable, {"name": "Lamb Racks", "cost": 8.99});
        await db.insert(foodTable, {"name": "Sirloin Steak", "cost": 9.99});
        await db.insert(foodTable, {"name": "Ribeye Steak", "cost": 5.99});
        await db.insert(foodTable, {"name": "Pork Chops", "cost": 4.99});
        await db.insert(foodTable, {"name": "Spaghetti", "cost": 9.99});
        await db.insert(foodTable, {"name": "Chicken Noodle Soup", "cost": 14.99});
        await db.insert(foodTable, {"name": "Wonton Soup", "cost": 21.99});
        await db.insert(foodTable, {"name": "Chowmein", "cost": 23.99});
        await db.insert(foodTable, {"name": "Boston Clam Chowder Soup", "cost": 11.99});
      },
    );
  }

  // function to get all food item
  Future<List<Map<String, dynamic>>> getAllFoodItems() async {
    final db = await foodAppDatabaseHelper.getDatabase();

    // returns the list for the table
    return await db.query(foodTable);
  }

  // function to add order plan to the database
  Future<void> addOrderPlan(String date, String foodNames, double cost) async {
    final db = await foodAppDatabaseHelper.getDatabase();

    String foodList = "";

    // call the table to be inserted, then the parameters into the column indicated
    await db.insert(
      "order_plans",
      {
        "date": date,
        "orderedFoods": foodNames,
        "cost": cost,
      },
    );
  }

  // function to retrieve an order plan in the database, takes a date as a parameter
  Future<List<Map<String, dynamic>>> getOrders(String day) async {
    final db = await getDatabase();
    return await db.query(orderPlansTable, where: "day = ?", whereArgs: [day]);
  }
}
