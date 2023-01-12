import 'package:egp_app/pages/homepage.dart';
import 'package:egp_app/pages/recentpage.dart';
import 'package:egp_app/pages/settingpage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _page = [recentPage(), homePage(), settingPage()];
  final _controller = PageController(
    initialPage: 1,
    keepPage: true,
  );
  int _selectedIndex = 1;

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          height: 70,
          clipBehavior:
              Clip.hardEdge, //or better look(and cost) using Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
          ),
          child: BottomNavigationBar(
            iconSize: 30,
            backgroundColor: Color.fromARGB(255, 35, 43, 110),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled),
                label: 'Recent',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red,
            onTap: ((index) {
              setState(() {
                _selectedIndex = index;
                _controller.animateToPage(index,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            }),
          ),
        ),
        body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              pageChanged(index);
            },
            children: _page));
  }
}
