import 'package:get/get.dart';
import 'package:termare_app/app/modules/setting/controllers/setting_controller.dart';

import '../controllers/terminal_controller.dart';

class TerminalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingController>(SettingController());
    Get.lazyPut<TerminalController>(
      () => TerminalController(),
    );
  }
}
