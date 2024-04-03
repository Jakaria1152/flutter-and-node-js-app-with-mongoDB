import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePage()),
                );
              },
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadPage()),
                );
              },
              child: Text('Read'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> createProduct() async {
    final response = await http.post(
      Uri.parse('https://mushy-tutu-cow.cyclic.app/products'),
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
      print('Product created successfully');
    } else {
      throw Exception('Failed to create product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                createProduct();
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadPage extends StatelessWidget {
  Future<List<dynamic>> fetchProducts() async {
    final response =
    await http.get(Uri.https('mushy-tutu-cow.cyclic.app','/products',{'q': '{http}'}));

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
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final product = snapshot.data?[index];
                return ListTile(
                  title: Text(product['title']),
                  subtitle: Text('Price: ${product['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
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
                            print('Product deleted successfully');
                          } else {
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

class UpdatePage extends StatelessWidget {
  final Map<String, dynamic> product;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  UpdatePage({required this.product}) {
    titleController.text = product['title'];
    priceController.text = product['price'].toString();
    ratingController.text = product['rating'].toString();
    descriptionController.text = product['description'];
  }

  Future<void> updateProduct() async {
    final response = await http.put(
      Uri.parse(
          'https://mushy-tutu-cow.cyclic.app/products/${product['_id']}'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
