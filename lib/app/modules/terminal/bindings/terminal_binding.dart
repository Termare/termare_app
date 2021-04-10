import 'package:get/get.dart';

import '../controllers/terminal_controller.dart';

class TerminalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TerminalController>(
      () => TerminalController(),
    );
  }
}
