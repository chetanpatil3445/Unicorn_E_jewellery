import 'package:get/get.dart';
import '../feature/Adresses/view/AddressScreen.dart';
import '../feature/cart/view/CartPage.dart';
import '../feature/cr_dr/binding/cr_dr_binding.dart';
import '../feature/cr_dr/view/AdvanceDetails.dart';
import '../feature/cr_dr/view/cr_dr_list_view.dart';
import '../feature/cr_dr/view/udharDetail.dart';
import '../feature/dashboard/binding/binding.dart';
import '../feature/dashboard/view/AboutUsPage.dart';
import '../feature/dashboard/view/ContactUsPage.dart';
import '../feature/dashboard/view/HelpPage.dart';
import '../feature/dashboard/Main_View/Homepage.dart';
import '../feature/dashboard/view/Notification.dart';
import '../feature/dashboard/view/main_navigation.dart';
import '../feature/homeProducts/views/HomeProductList.dart';
import '../feature/login/Binding.dart';
import '../feature/login/view/CreatePasscodeScreen.dart';
import '../feature/login/view/ForgotPasscodeScreen.dart';
import '../feature/login/view/PasscodeLoginScreen.dart';
import '../feature/login/view/login_page.dart';
import '../feature/login/view/otp_verify.dart';
import '../feature/login/view/splash_screen.dart';
import '../feature/products/view/StockDetailPage.dart';
import '../feature/reviews/view/MyReviewsPage.dart';
import '../feature/wishlist/view/wishlist_page.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [

     GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.DashboardView,
      page: () => Dashboard(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.MainNavigation,
      page: () => MainNavigation(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.otpVerify,
      page: () => OtpVerify(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.CreatePasscodeView,
      page: () => CreatePasscodeScreen(),
      binding: PasscodeBinding(),

    ),
    GetPage(
      name: AppRoutes.PasscodeLoginView,
      page: () => PasscodeLoginScreen(),
      binding: PasscodeBinding(),

    ),
    GetPage(
      name: AppRoutes.ForgotPasscodeView,
      page: () => ForgotPasscodeScreen(),
      binding: PasscodeBinding(),

    ),
    GetPage(
      name: AppRoutes.NotificationPage,
      page: () => NotificationPage(),
      binding: NotificationBinding(),
    ),

    GetPage(
      name: AppRoutes.aboutUs,
      page: () => const AboutUsPage(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsPage(),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
    ),


     GetPage(
      name: AppRoutes.stockDetail,
      page: () => ProductDetailPage(),
    ),

    GetPage(
      name: AppRoutes.crDrList,
      page: () {
        final bool showButton = Get.arguments as bool? ?? false;
        return CrDrListView(showAddButton: showButton);
      },
      binding: CrDrBinding(),
    ),
    GetPage(
      name: AppRoutes.udhaarDetailsScreen,
      page: () =>   UdhaarDetailsScreen(),
     ),
    GetPage(
      name: AppRoutes.advanceDetailsScreen,
      page: () =>   AdvanceDetailsScreen(),
     ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () =>   WishlistPage(),
     ),
    GetPage(
      name: AppRoutes.homeProductsList,
      page: () =>   HomeProductList(),
     ),
    GetPage(
      name: AppRoutes.cartPage,
      page: () =>   CartPage(),
     ),
    GetPage(
      name: AppRoutes.myReviewsPage,
      page: () =>   MyReviewsPage(),
     ),
    GetPage(
      name: AppRoutes.addressScreen,
      page: () =>   AddressScreen(),
     ),

  ];
}
