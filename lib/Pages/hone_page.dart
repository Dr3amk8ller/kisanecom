import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Pages/CartModel.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Drawer.dart';
import 'Homepagecontent/CatalogHeader.dart';
import 'Homepagecontent/CatalogList.dart';
import 'dialog.dart';
import 'package:http/http.dart' as http;

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
    // loadData();
    loadDataFromDjango();
  }

  Future<void> loadDataFromDjango() async {
    final url = "http://10.0.2.2:8000/"; // Replace with your Django API URL.

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Item> items = List<Item>.from(
          data.map(
            (itemData) {
              return Item(
                  // Map the fields from your JSON data to the corresponding Item properties.
                  // For example:
                  // name: itemData['name'],
                  name: itemData['name'],
                  desc: itemData['desc'],
                  price: itemData['price'],
                  image: itemData['image'],
                  color: itemData['color'],
                  id: itemData['id']);
            },
          ),
        );

        // Now, you can update your local state or your catalog data with 'items'.
        // For example, you might have a CatalogModel to store these items.
        CatalogModel.items = items;

        setState(() {});
      } else {
        // Handle errors here.
        print("Failed to load data from Django backend.");
      }
    } catch (error) {
      // Handle network errors or exceptions here.
      print("Error: $error");
    }
  }
  // final url = "https://api.jsonbin.io/b/604dbddb683e7e079c4eefd3";
  /*Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    // final response = await http.get(Uri.parse(url));
    final stringjson =
        await rootBundle.loadString("Assests/files/catalog.json");
    final decodedata = jsonDecode(stringjson);
    var productdata = decodedata["products"];
    CatalogModel.items =
        List.from(productdata).map<Item>((item) => Item.fromMap(item)).toList();
    setState(() {});
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
            backgroundColor: context.canvasColor,
            child: const Icon(Icons.shopping_cart),
          ).badge(
              count: _cart.items.length,
              color: Vx.red600,
              size: 25,
              textStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold));
        },
        mutations: const {AddMutation, RemoveMutation},
      ),
      backgroundColor: context.canvasColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CatalogHeader(),
            if (CatalogModel.items.isNotEmpty)
              CatalogList().expand()
            else
              const CircularProgressIndicator().centered().expand(),
          ],
        ),
      ),
    );
  }
}
