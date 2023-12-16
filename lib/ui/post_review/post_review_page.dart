import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/provider/post_review_restaurant_provider.dart';
import 'package:restaurant_app/theme/styles.dart';

class PostReviewPage extends StatefulWidget {
  static const routeName = '/post_review_page';
  final String id;

  const PostReviewPage({Key? key, required this.id}) : super(key: key);

  @override
  State<PostReviewPage> createState() => _PostReviewPageState();
}

class _PostReviewPageState extends State<PostReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailRestaurantProvider>(
          create: (_) => DetailRestaurantProvider(
            apiService: ApiService(),
            id: widget.id,
          ),
        ),
        ChangeNotifierProvider<PostReviewRestaurantProvider>(
          create: (_) => PostReviewRestaurantProvider(
            apiService: ApiService(),
            id: widget.id,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Review'),
        ),
        body: Consumer<PostReviewRestaurantProvider>(
          builder: (context, state, _) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      floatingLabelStyle: TextStyle(color: secondaryColor),
                      hintText: 'Your name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Review',
                      floatingLabelStyle: TextStyle(color: secondaryColor),
                      hintText: 'Your review',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        state
                            .postReviewRestaurant(
                          _nameController.text,
                          _reviewController.text,
                        )
                            .then(
                          (_) {
                            Navigator.pop(context, true);
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
