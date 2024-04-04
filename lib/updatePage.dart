import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> product;

  UpdatePage({required this.product});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController ratingController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  Future<void> updateProduct() async {
    final response = await http.put(
      Uri.parse(
          'https://mushy-tutu-cow.cyclic.app/products/${widget.product['_id']}'),
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

    if (response.statusCode == 200) {
      print('Product updated successfully');
    } else {
      throw Exception('Failed to update product');
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.product['title'];
    priceController.text = widget.product['price'].toString();
    ratingController.text = widget.product['rating'].toString();
    descriptionController.text = widget.product['description'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  updateProduct();
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}