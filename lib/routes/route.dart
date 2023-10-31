import 'package:flutter_template/cameraPageScreen.dart';
import 'package:flutter_template/detailsScreen.dart';
import 'package:flutter_template/homeScreen.dart';
import 'package:flutter_template/loginScreen.dart';
import 'package:flutter_template/nativeSplashScreen.dart';
import 'package:flutter_template/packages/provider/view/user_view.dart';
import 'package:flutter_template/packages/riverpod/page/user_home_page.dart';
import 'package:flutter_template/pages/rootPage.dart';
import 'package:flutter_template/screens/profileScreen.dart';
import 'package:get/get.dart';

import '../packages/dio/dio_result_page.dart';

List<GetPage> routes = [
  GetPage(name: "/", page: () => const RootPage()),
  GetPage(name: '/splash', page: () => const NativeSplashScreen()),
  GetPage(name: '/home', page: () => const HomeScreen()),
  GetPage(name: '/camera', page: () => const CameraPage(param: "카메라")),
  GetPage(name: '/profile', page: () => const ProfileScreen()),
  GetPage(name: '/login', page: () => const LogInScreen()),
  GetPage(name: '/details', page: () => const DetailsScreen()),
  GetPage(name: '/riverpod', page: () => const UserHomePage()),
  GetPage(name: '/provider', page: () => const UserView()),

  /*
  GetPage(name: "/retrofit", page: () => const RetrofitScreen()),
  GetPage(name: "/freezed", page: () => const FreezedScreen()),
  GetPage(name: "/sliverappbar", page: () => const SliverAppbarScreen()),
  GetPage(name: "/retrofit_with_freezed", page: () => const ResultPage()),
  GetPage(name: "/bottomnavigation", page: () => const BottomNavigationScreen()),
  GetPage(name: '/getx_pattern', page: () => const HomePage(), binding: HomeBinding()),
  GetPage(name: '/infinite', page: () => const MyScrollPage()),
  GetPage(name: '/bloc', page: () => const BlocScreen()),
  GetPage(name: '/multi_scroll', page: () => const MultiScrollPage()),
  GetPage(name: '/screen_util', page: () => const ScreenUtilPage()),
  GetPage(name: '/filtering', page: () => const FilteringPage()),
  GetPage(name: '/shared_preferences', page: () => const SharedPreferencesPage()),
  GetPage(name: '/moor', page: () => const MoorPage()),
  GetPage(name: '/grid_view', page: () => const ResultGridView()),
  GetPage(name: '/riverpod', page: () => const RiverpodPage()),
  */
  GetPage(name: '/dio', page: () => DioResultPage()),
/*
  GetPage(name: '/stream', page: () => const StreamPage()),
  GetPage(name: '/list_view', page: () => const ListViewPage()),
  GetPage(name: '/text', page: () => const TextPage()),
  */
];
