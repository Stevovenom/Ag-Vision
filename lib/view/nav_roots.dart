// Name: Michael Olang
// Email: olangmichael@gmail.com
// phone: +254768241008
// github: @mikeyolang
import 'package:agrotech_hackat/view/farmxAI/agvisionai.dart';
import 'package:agrotech_hackat/view/home.dart';
import 'package:agrotech_hackat/view/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class NavBarRoots extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const NavBarRoots({key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectIndex = 0;
  final _screens = [
    //Home Screen
    const HomePageScreen(),
    //  Bookings Screen
    const Scan(),
    //  Profile Screen
    const AiChatBot(),
    //  Settings screen
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectIndex,
          onTap: (index) {
            setState(() {
              _selectIndex = index;
            });
          },
          items:  [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SvgPicture.asset(
                "assets/svgs/Vector.svg",
                semanticsLabel: 'Product',
               
              ),
            ),
              label: "Tools",
            ),

            // BottomNavigationBarItem(Icon(Icons.people), label: "Community")
            const BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: "Agvision Ai",
            ),
          ],
        ),
      ),
    );
  }
}