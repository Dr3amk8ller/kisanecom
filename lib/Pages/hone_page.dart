import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Pages/CartModel.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/store.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Homepagecontent/CatalogHeader.dart';
import 'Homepagecontent/CatalogList.dart';
import 'dialog.dart';
// import 'package:http/http.dart' as http; // Commented out: Using mock data instead of API

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Using local JSON file instead of API
    loadDataFromLocalJson();

    // COMMENTED OUT: API call to Django backend
    // loadDataFromDjango();
  }

  // Mock function: Load data from local JSON file
  Future<void> loadDataFromLocalJson() async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      final stringjson =
          await rootBundle.loadString("Assests/files/catalog.json");
      final decodedata = jsonDecode(stringjson);
      var productdata = decodedata["products"];
      CatalogModel.items = List.from(productdata)
          .map<Item>((item) => Item.fromMap(item))
          .toList();
      setState(() {});
    } catch (error) {
      print("Error loading local JSON: $error");
    }
  }

  // COMMENTED OUT: API call to Django backend
  /* Future<void> loadDataFromDjango() async {
    final url = "http://10.0.2.2:8000/"; // Replace with your Django API URL.

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Item> items = List<Item>.from(
          data.map(
            (itemData) {
              return Item(
                  name: itemData['name'],
                  desc: itemData['desc'],
                  price: itemData['price'],
                  image: itemData['image'],
                  color: itemData['color'],
                  id: itemData['id']);
            },
          ),
        );

        CatalogModel.items = items;
        setState(() {});
      } else {
        print("Failed to load data from Django backend.");
      }
    } catch (error) {
      print("Error: $error");
    }
  } */

  @override
  Widget build(BuildContext context) {
    final CartModel _cart = (VxState.store as MyStore).cart;
    return Scaffold(
      floatingActionButton: VxBuilder(
        builder: (BuildContext context, store, VxStatus? status) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutes.CartPage);
            },
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? MyTheme.darkBluishColor
                : MyTheme.lightBluishColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.shopping_cart),
          ).badge(
              count: _cart.items.length,
              color: Vx.red600,
              size: 25,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold));
        },
        mutations: const {AddMutation, RemoveMutation},
      ),
      backgroundColor: context.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: const CatalogHeader(),
            ),
            Expanded(
              child: CatalogModel.items.isNotEmpty
                  ? CatalogList()
                  : const CircularProgressIndicator().centered(),
            ),
          ],
        ),
      ),
    );
  }
}
