import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/brands/presentation/views/product_detail_view.dart';
import '../../features/brands/presentation/views/select_branch_view.dart';
import '../../features/brands/presentation/views/application_process_view.dart';
import '../../features/brands/presentation/views/review_order_view.dart';
import '../../features/brands/presentation/views/order_submitted_view.dart';
import '../../features/home/presentation/views/plan_detail_view.dart';
import '../../features/profile/presentation/views/profile_settings_view.dart';
import '../../features/profile/presentation/views/recover_account_view.dart';
import '../../features/profile/presentation/views/forgot_password_verify_view.dart';
import '../../features/profile/presentation/views/verification_completed_view.dart';
import '../../features/profile/presentation/views/set_new_password_view.dart';
import '../../features/profile/presentation/views/notifications_view.dart';
import '../../features/auth/presentation/views/set_pin_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/profile/presentation/views/edit_profile_view.dart';
import '../../features/brands/presentation/views/comments_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingView();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterView();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: '/product-detail',
        builder: (BuildContext context, GoRouterState state) {
          final product = state.extra as Map<String, dynamic>;
          return ProductDetailView(product: product);
        },
      ),
      GoRoute(
        path: '/select-branch',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          final product = extra['product'] as Map<String, dynamic>;
          final plan = extra['plan'] as String;
          return SelectBranchView(product: product, plan: plan);
        },
      ),
      GoRoute(
        path: '/application-process',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          final product = extra['product'] as Map<String, dynamic>;
          final plan = extra['plan'] as String;
          final branch = extra['branch'] as Map<String, dynamic>;
          return ApplicationProcessView(
            product: product,
            plan: plan,
            branch: branch,
          );
        },
      ),
      GoRoute(
        path: '/review-order',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          final product = extra['product'] as Map<String, dynamic>;
          final plan = extra['plan'] as String;
          final branch = extra['branch'] as Map<String, dynamic>;
          final personalDetails =
              extra['personalDetails'] as Map<String, String>;
          final frontCnic = extra['frontCnic'] as String;
          final backCnic = extra['backCnic'] as String;
          final frontCnicRelative = extra['frontCnicRelative'] as String;
          final backCnicRelative = extra['backCnicRelative'] as String;
          return ReviewOrderView(
            product: product,
            plan: plan,
            branch: branch,
            personalDetails: personalDetails,
            frontCnic: frontCnic,
            backCnic: backCnic,
            frontCnicRelative: frontCnicRelative,
            backCnicRelative: backCnicRelative,
          );
        },
      ),
      GoRoute(
        path: '/order-submitted',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          final transactionId = extra['transactionId'] as String;
          return OrderSubmittedView(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: '/plan-detail',
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          final modelName = extra['modelName'] as String;
          final planDuration = extra['planDuration'] as String;
          final isActive = extra['isActive'] as bool;
          final paid = extra['paid'] as String;
          final remaining = extra['remaining'] as String;
          final monthly = extra['monthly'] as String;
          final downpayment = extra['downpayment'] as String;
          return PlanDetailView(
            modelName: modelName,
            planDuration: planDuration,
            isActive: isActive,
            paid: paid,
            remaining: remaining,
            monthly: monthly,
            downpayment: downpayment,
          );
        },
      ),
      GoRoute(
        path: '/profile-settings',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileSettingsView();
        },
      ),
      GoRoute(
        path: '/recover-account',
        builder: (BuildContext context, GoRouterState state) {
          return const RecoverAccountView();
        },
      ),
      GoRoute(
        path: '/verify-phone',
        builder: (BuildContext context, GoRouterState state) {
          final flow = state.uri.queryParameters['flow'] ?? 'recovery';
          final phone = state.uri.queryParameters['phone'];
          return ForgotPasswordVerifyView(flow: flow, phone: phone);
        },
      ),
      GoRoute(
        path: '/verification-complete',
        builder: (BuildContext context, GoRouterState state) {
          final flow = state.uri.queryParameters['flow'] ?? 'recovery';
          return VerificationCompletedView(flow: flow);
        },
      ),
      GoRoute(
        path: '/set-pin',
        builder: (BuildContext context, GoRouterState state) {
          return const SetPinView();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginView();
        },
      ),
      GoRoute(
        path: '/set-new-password',
        builder: (BuildContext context, GoRouterState state) {
          return const SetNewPasswordView();
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationsView();
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (BuildContext context, GoRouterState state) {
          return const EditProfileView();
        },
      ),
      GoRoute(
        path: '/comments',
        builder: (BuildContext context, GoRouterState state) {
          final product = state.extra as Map<String, dynamic>;
          return CommentsView(product: product);
        },
      ),
    ],
  );
}
