import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageViewController(),
    );
  }
}

class PageViewController extends StatefulWidget {
  const PageViewController({Key? key}) : super(key: key);

  @override
  _PageViewControllerState createState() => _PageViewControllerState();
}

class _PageViewControllerState extends State<PageViewController> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              FirstPage(title: 'Flutter Test'),
              SecondPage(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SmoothPageIndicator(
                    effect: const WormEffect(
                      radius: 16,
                      activeDotColor: Colors.blue,
                      dotWidth: 12,
                      dotHeight: 12,
                    ),
                    controller: _pageController,
                    count: 2,
                    onDotClicked: (index) => _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  final String title;
  const FirstPage({Key? key, required this.title}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SecondPage()));
            },
            child: const Text('Next')),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);
  Future<String> simSim() async {
    final response = await http.get(
        Uri.parse(
            'https://us-central1-gettheemailtest.cloudfunctions.net/start'),
        headers: {HttpHeaders.authorizationHeader: 'sim-sim'});
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<String>(
          future: simSim(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data.toString(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              );
            } else {
              return const Text('Empty data');
            }
          }),
    );
  }
}
