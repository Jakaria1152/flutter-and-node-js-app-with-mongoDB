import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nodejs_mongo/updatePage.dart';
class ReadPage extends StatefulWidget {
  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {


  //List<dynamic> use kora hoyese karon list er vitor map thakbe onek gulo [{},{},{}]
  Future<List<dynamic>> fetchProducts() async {
    final response =
    await http.get(Uri.https('mushy-tutu-cow.cyclic.app','/products',{'q': '{http}'}));  // value read kora hobe tai (get) use kora hoyese

    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      throw Exception('Failed to fetch products');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {

             return ListView.builder(
              itemCount: snapshot.data?.length,  // list er vitor total joto gulo map ase
              itemBuilder: (context, index) {
                final Map<String,dynamic> product = snapshot.data?[index];  // list theke akta single map nibe {}
                return ListTile(
                  leading: CircleAvatar(child: Text((index+1).toString()),),
                  title: Text(product['title']),
                  subtitle: Text('Price: ${product['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // very important if you not use get an error
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigate to update page with product details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePage(product: product),
                            ),
                          );
                        },
                        icon: Icon(Icons.update),
                      ),
                      IconButton(
                        onPressed: () async {
                          final response = await http.delete(
                            Uri.parse(
                                'https://mushy-tutu-cow.cyclic.app/products/${product['_id']}'),
                          );
                          if (response.statusCode == 200) {
                            Fluttertoast.showToast(
                              msg: "Product deleted successfully",
                              toastLength: Toast.LENGTH_SHORT,

                              backgroundColor: Colors.deepOrange,
                              textColor: Colors.white,

                            );

                          } else {
                            Fluttertoast.showToast(
                              msg: "Failed to delete product",
                              toastLength: Toast.LENGTH_SHORT,

                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,

                            );
                            throw Exception('Failed to delete product');
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}