// Tur pengenalan enam halaman dengan penanda pemakaian pertama.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/app_providers.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/presentation/login_page.dart';
import '../../auth/presentation/register_page.dart';
import '../../splash/presentation/welcome_view.dart';
import 'tour_slides.dart';

/// Lima slide fitur lalu layar sambutan; tur ditandai selesai di halaman akhir.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const AppText text = AppStrings.id;
  static const int _slideCount = 5;

  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onPageChanged(int index) async {
    setState(() => _page = index);
    if (index == _slideCount) {
      await ref.read(onboardingStorageProvider).markSeen();
    }
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _restartTour() {
    _controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    const List<Widget> bodies = [
      LogSlideBody(),
      DiarySlideBody(),
      ReviewSlideBody(),
      ActivitySlideBody(),
      ListSlideBody(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: _onPageChanged,
            children: [
              for (int i = 0; i < _slideCount; i++)
                TourSlide(caption: text.tourCaptions[i], child: bodies[i]),
              WelcomeView(
                onSignIn: () => _open(const LoginPage()),
                onCreateAccount: () => _open(const RegisterPage()),
                onOpenTour: _restartTour,
              ),
            ],
          ),
          if (_page < _slideCount)
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.lg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  _slideCount + 1,
                  (int i) => Container(
                    width: AppSizes.dot,
                    height: AppSizes.dot,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs / 2 + 1,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
