import 'package:flutter/material.dart';
import 'package:solar_app/widgets/search_input.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portales Solar'),
      ),
      body: const SearchInput(),
    );
  }
}
