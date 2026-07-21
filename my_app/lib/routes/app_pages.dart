import 'package:get/get.dart';

import '../bindings/auth_binding.dart';
import '../bindings/edit_profile2_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/splash_binding.dart';
import '../views/auth_view.dart';
import '../views/edit_profile2_screen.dart';
import '../views/home_view.dart';
import '../views/onboarding_view.dart';
import '../views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.editProfile2,
      page: () => const EditProfile2Screen(),
      binding: EditProfile2Binding(),
    ),
  ];
}
