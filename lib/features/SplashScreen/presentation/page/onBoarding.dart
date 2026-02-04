import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import '../../../../core/di/injection.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widget/class_onnoarding_scrren.dart';
import '../../../auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingBloc onboardingBloc;
  late final PageController _pageController;

  @override
  void initState() {
    onboardingBloc = sl<OnboardingBloc>()..add(InitSplash());
    _pageController = PageController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    onboardingBloc.close();
    super.dispose();
    AppVariables.isFirstTime=false;

  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 42, 38, 38),
              Color.fromARGB(255, 79, 77, 77),
            ],
          ),
        ),
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          bloc: onboardingBloc,
          builder: (context, state) {
            return Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged:
                      (index) => onboardingBloc.add(
                        OnPageChanged(index),
                      ),
                  children:
                      state.pages
                          .map(
                            (e) => ClassOnnoardingScrren(
                              title: e.$1,
                              description: e.$2,

                              image: e.$3,
                            ),
                          )
                          .toList(),
                ),
                Positioned(
                  bottom: isSmallScreen ? 110 : 130,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.blue,
                        dotColor: Colors.white24,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: isSmallScreen ? 30 : 50,
                  left: screenSize.width * 0.08,
                  right: screenSize.width * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginPage(),
                              transitionsBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              )
                              {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(
                                milliseconds: 1900,
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "تخطي",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(18),
                        ),
                        onPressed: () {
                          print(state.isLastPage);
                          if (!state.isLastPage) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                    LoginPage(),
                                transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                    )
                                {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(
                                  milliseconds: 1900,
                                ),
                              ),
                                  (route) => false,
                            );
                          }
                        },
                        child: const Icon(Icons.arrow_forward_ios, size: 22),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
