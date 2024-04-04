import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nodejs_mongo/homepage.dart';


class CreatePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();



  Future<void> createProduct() async {
    final response = await http.post(
      Uri.parse('https://mushy-tutu-cow.cyclic.app/products'),  // data send korte hobe tai (post) use kora hoyese
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': titleController.text,
        'price': priceController.text,
        'rating': ratingController.text,
        'description': descriptionController.text,
      }),
    );

    if (response.statusCode == 201) {
   Fluttertoast.showToast(
          msg: "Product created successfully",
          toastLength: Toast.LENGTH_SHORT,

          backgroundColor: Colors.green,
          textColor: Colors.white,

      );
    } else {
       Fluttertoast.showToast(
          msg: "Failed to create product",
          toastLength: Toast.LENGTH_SHORT,

          backgroundColor: Colors.red,
          textColor: Colors.white,

      );
      throw Exception('Failed to create product');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  createProduct();  // data successfully send to database

                  titleController.clear();    // all textField clean
                  priceController.clear();
                  ratingController.clear();
                  descriptionController.clear();

                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));

                },
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}