import 'package:flutter/material.dart';
import 'package:friendify/views/loginSIgnup.dart';


class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<Widget> _onboardingPages = [
    const OnboardingPage(
      title: 'Connect with Friends',
      description:
          'Stay connected with your friends and discover new connections with Friendify.',
      image: 'assets/connect_with_friends.png',
    ),
    const OnboardingPage(
      title: 'Discover Global Users',
      description:
          'Explore a global user list, find interesting people, and expand your social circle.',
      image: 'assets/discover_global_users.png',
    ),
    const OnboardingPage(
      title: 'Build Friendships',
      description:
          'Create lasting friendships by sending and accepting friend invitations on Friendify.',
      image: 'assets/build_friendships.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingPages.length,
              itemBuilder: (context, index) {
                return _onboardingPages[index];
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _currentPage < _onboardingPages.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    : () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginSignupScreen(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: Colors.black, 
                  // ignore: deprecated_member_use
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 120, vertical: 16),
                ),
                child: Text(
                  _currentPage < _onboardingPages.length - 1
                      ? 'Next'
                      : 'Get Started',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: Image.asset(
              image,
              height: 500,
              width: 500,
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
