import 'package:flutter/material.dart';
import 'package:hunger/constants.dart';
import 'package:hunger/screens/main/screens/Fav_screen.dart';
import 'package:hunger/screens/main/screens/home_screen.dart';
import 'package:hunger/screens/sign_in/sign_in_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PageController _pageController = PageController();
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildPageView(),
          buildBottomNav(),
        ],
      ),
      appBar: AppBar(
        title: const Text(
          'Food Finder',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return Expanded(
      child: SizedBox(
        //  height: MediaQuery
        // .of(context)
        // .size
        // .height * 0.8409,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeScreen(),
            RestaurantList(),
            SignInScreen(
              buttonPressed: '',
            ),
          ],
          onPageChanged: (index) {
            onPageChange(index);
          },
        ),
      ),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      selectedLabelStyle:
          const TextStyle(color: Colors.black), // Selected label color
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedPage,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(
            Icons.home,
            color: kTextColor,
          ),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
          label: 'Food Places',
          icon: Icon(
            Icons.list_alt_sharp,
            color: kTextColor,
          ),
          backgroundColor: kPrimaryColor,
        ),
        BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(
              Icons.account_box_sharp,
              color: kTextColor,
            ),
            backgroundColor: kPrimaryColor),
      ],
      onTap: (int index) {
        _pageController.animateToPage(index,
            duration: const Duration(microseconds: 1000), curve: Curves.easeIn);
      },
    );
  }

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
