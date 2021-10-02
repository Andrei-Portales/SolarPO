import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/search_input.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SolarPO'),
            const SizedBox(width: 5),
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset('assets/icons/sunny.svg'),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: const SearchInput(),
    );
  }
}
