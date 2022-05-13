import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  RuntimeEnvir.initEnvirWithPackageName('com.nightmare.termare');
   WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isDesktop) {
    await Window.initialize();
  }
  runApp(
    ToastApp(
      child: GetMaterialApp(
        // showPerformanceOverlay: true,
        title: 'Termare开源版',
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        defaultTransition: Transition.fade,
      ),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
}
