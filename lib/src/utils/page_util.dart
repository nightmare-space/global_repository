import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:global_repository/src/controller/tab_controller.dart';

dynamic openPage(Widget page, {String? title}) async {
  if (GetPlatform.isDesktop) {
    TabController tabController = Get.find();
    if(title == null) {
      throw 'title is null';
    }
    tabController.openPage(PageEntity(title: title, page: page));
    return null;
  } else {
    return await Get.to(() => page);
  }
}
