import 'package:get/get.dart';

import 'package:termare_app/app/modules/setting/bindings/setting_binding.dart';
import 'package:termare_app/app/modules/setting/views/setting_page.dart';
import 'package:termare_app/app/modules/terminal/bindings/terminal_binding.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => TerminalPages(),
      binding: TerminalBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),
  ];
}
