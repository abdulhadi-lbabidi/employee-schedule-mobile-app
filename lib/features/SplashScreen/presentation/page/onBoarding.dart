import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widget/class_onnoarding_scrren.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/page/main_page.dart';
import '../../../admin/presentation/pages/AdminHomePage.dart';
import '../../../auth/data/repository/login_repo.dart'; 

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingBloc>(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    if (!mounted) return;

    final authRepository = sl.get<AuthRepository>();
    
    // 1. تحقق سريع جداً: هل التوكن موجود محلياً؟
    bool hasToken = await authRepository.isTokenPresent();
    
    if (hasToken) {
        // 2. إذا كان موجوداً، جلب بيانات المستخدم المخزنة
        final user = await authRepository.getCurrentUser();
        
        if (user != null) {
            final role = user.userableType?.toLowerCase();
            // 3. توجيه فوري للواجهة المناسبة بناءً على البيانات المحلية
            if (role == 'admin') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminHomePage()));
            } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
            }
            return;
        }
    }
    
    // 4. إذا لم يوجد توكن، نذهب لصفحة تسجيل الدخول
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
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
            colors: [Color.fromARGB(255, 42, 38, 38), Color.fromARGB(255, 79, 77, 77)],
          ),
        ),
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) => context.read<OnboardingBloc>().add(OnPageChanged(index)),
                  children: const [
                    ClassOnnoardingScrren(
                      title: "مرحباً بك في Nouh agency",
                      description: "نظامك المتكامل لإدارة الحضور والرواتب الميدانية.",
                      image: "assets/image/biuilding.png",
                    ),
                    ClassOnnoardingScrren(
                      title: "سجل حضورك بلمسة",
                      description: "تقنية المزامنة الذكية تضمن وصول بياناتك حتى بدون إنترنت.",
                      image: "assets/image/project02.png",
                    ),
                    ClassOnnoardingScrren(
                      title: "شفافية مالية تامة",
                      description: "تابع مستحقاتك المالية الأسبوعية بدقة ووضوح.",
                      image: "assets/image/project03.png",
                    ),
                  ],
                ),
                Positioned(
                  bottom: isSmallScreen ? 110 : 130,
                  left: 0, right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: const ExpandingDotsEffect(activeDotColor: Colors.blue, dotColor: Colors.white24, dotHeight: 8, dotWidth: 8),
                    ),
                  ),
                ),
                Positioned(
                  bottom: isSmallScreen ? 30 : 50,
                  left: screenSize.width * 0.08, right: screenSize.width * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: _completeOnboarding, child: const Text("تخطي", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600))),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: const CircleBorder(), padding: const EdgeInsets.all(18)),
                        onPressed: () {
                          if (!state.isLastPage) {
                            _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          } else {
                            _completeOnboarding();
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
