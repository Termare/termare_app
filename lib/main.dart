import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

import 'app/routes/app_pages.dart';
import 'config/config.dart';

void main() {
  PlatformUtil.setPackageName('com.nightmare.termare');
  if (PlatformUtil.isDesktop()) {
    Config.dataPath = PlatformUtil.getDataPath();
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
