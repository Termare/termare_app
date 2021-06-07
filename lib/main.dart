import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

import 'app/routes/app_pages.dart';

void main() {
  if (PlatformUtil.isDesktop()) {
    RuntimeEnvir.initEnvirForDesktop();
  } else {
    RuntimeEnvir.initEnvirWithPackageName('com.nightmare.termare');
  }
  runApp(
    NiToastNew(
      child: GetMaterialApp(
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
  // Global.instance.initGlobal();
}

void injectEnvironment() {
  // NiEW
}
