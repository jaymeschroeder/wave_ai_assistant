import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:wave_ai_assistant/constants/constants.dart';
import 'package:wave_ai_assistant/services/shared_preferences_service.dart';

import '../models/intro_model.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import 'main_menu.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> with TickerProviderStateMixin {
  // Add TickerProviderStateMixin
  int currentPage = 0;
  List<IntroModel> introCardsList = [
    IntroModel(
        'Personal Assistant',
        'Wave AI can help you manage your tasks, set reminders, and answer your questions, making it your personal AI assistant available 24/7.',
        Icons.assistant),
    IntroModel(
        'Creative Partner',
        'Need help with writing, brainstorming, or generating creative ideas? Wave AI can collaborate with you to boost your creativity.',
        Icons.create),
    IntroModel(
        'Language Translator',
        'Traveling or communicating with people from different parts of the world? Wave AI can translate languages for you, bridging communication gaps effortlessly.',
        Icons.translate),
    IntroModel(
        'Study Buddy',
        'Studying for exams or learning something new? Wave AI can provide explanations, summaries, and study materials to support your learning journey.',
        Icons.school),
    IntroModel(
        'Content Generator',
        'Whether it\'s writing articles, creating social media posts, or crafting marketing content, Wave AI can assist in generating high-quality content quickly and efficiently.',
        Icons.create),
    IntroModel(
        'Conversational Companion',
        'Feeling lonely or just want to chat? Wave AI is here for friendly conversations, offering companionship and a listening ear whenever you need it.',
        Icons.chat),
  ];

  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeOutAnimation;

  late ValueNotifier<double> valNotifier = ValueNotifier<double>(0);

  bool shouldShowFadeOutWidgets = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.2, curve: Curves.easeIn), // Fading in at the start
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(55, 3),
    ).animate(curve);

    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.8, 1.0, curve: Curves.easeOut), // Fading out at the end
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Start fading out after a delay
        Future.delayed(Duration(seconds: 3), () {
          _controller.reset();
          _controller.forward();
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: AnimatedOpacity(
              opacity: shouldShowFadeOutWidgets ? 0.0 : 1.0,
              duration: Duration(seconds: 1),
              child: RichText(
                softWrap: false,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'Wave AI',
                      style: TextStyle(
                        color: Color(0xFF00A8E8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CardSwiper(
                    maxAngle: 90,
                    threshold: 50,
                    numberOfCardsDisplayed: 3,
                    isLoop: false,
                    cardsCount: introCardsList.length,
                    cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                      return IntroCard(
                        title: introCardsList[index].title,
                        subtitle: introCardsList[index].text,
                        currentIndex: index + 1,
                        totalCards: introCardsList.length,
                        icon: introCardsList[index].icon,
                      );
                    },
                    onSwipe: (i, index, direction) {
                      setState(() {
                        valNotifier.value = (i + 1) * (100 / introCardsList.length);
                      });

                      // Check if the last card is reached
                      if (i == introCardsList.length - 1) {
                        // Navigate to the LoginPage
                        setState(() {
                          shouldShowFadeOutWidgets = true;

                        });

                        Future.delayed(Duration(seconds: 2), () async {
                          await SharedPreferencesService.markIntroAsSeen();

                          await Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {

                                Widget nextPage;

                                print(authProvider.user);

                                (authProvider.user == null) ? nextPage = LoginPage() : nextPage = MainMenu();

                                return nextPage;
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0); // Start offscreen right
                                const end = Offset.zero; // End at the center of the screen
                                var tween = Tween(begin: begin, end: end);
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        });
                      }
                      return true;
                    },
                  ),
                ),

                if (valNotifier.value == 0)... {
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeInAnimation.value * _fadeOutAnimation.value, // Combined opacity
                          child: Transform.translate(
                            offset: _slideAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.touch_app,
                        size: 75,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                }

              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),

          AnimatedOpacity(
            opacity: shouldShowFadeOutWidgets ? 0.0 : 1.0,
            duration: Duration(seconds: 1),
            child: SimpleCircularProgressBar(
              backStrokeWidth: 5,
              progressStrokeWidth: 5,
              size: 50,
              valueNotifier: valNotifier,
              animationDuration: 1,
            ),
          )
        ],
      ),
    );
  }
}

class IntroCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final int currentIndex;
  final int totalCards;
  final IconData icon;

  const IntroCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    required this.totalCards,
    required this.icon,
  }) : super(key: key);

  @override
  _IntroCardState createState() => _IntroCardState();
}

class _IntroCardState extends State<IntroCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Adjust the duration as needed
      reverseDuration: Duration(milliseconds: 1000), // Adjust the reverse duration as needed
    );

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A8E8), Color(0xFF0062CC)],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start, // Align title to the top
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 36, // Larger font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Icon(
                      widget.icon,
                      size: 150,
                      color: Colors.white70,
                    ),
                  );
                },
              ),
              Spacer(),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Attractive font weight
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
