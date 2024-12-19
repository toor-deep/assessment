
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/auth/screens/sign_in_screen.dart';
import '../features/auth/presentation/auth/screens/sign_up_screen.dart';
import '../features/product_list/presentation/screens/add_list_item.dart';
import '../features/product_list/presentation/screens/item_detail_view.dart';
import '../features/product_list/presentation/screens/list_view_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../shared/constants.dart';
import '../splash_screen.dart';

final appRouter=GoRouter(
    navigatorKey: appNavigationKey,
    initialLocation:  SplashView.path,
    routes: [
      GoRoute(path: SignInScreen.path, name: SignInScreen.name, builder: (_, __) => const SignInScreen()),
      GoRoute(path: MyProfile.path, name: MyProfile.name, builder: (_, __) => const MyProfile()),
      GoRoute(path: SplashView.path, name: SplashView.name, builder: (_, __) => const SplashView()),
      GoRoute(path: SignUpScreen.path, name: SignUpScreen.name, builder: (_, __) => const SignUpScreen()),
      GoRoute(path: ItemListScreen.path, name: ItemListScreen.name, builder: (_, __) => const ItemListScreen()),
      GoRoute(path: AddItemScreen.path, name: AddItemScreen.name, builder: (_, __) => const AddItemScreen()),
      GoRoute(path: ItemDetailScreen.path, name: ItemDetailScreen.name, builder: (_, __) => const ItemDetailScreen()),

]);


