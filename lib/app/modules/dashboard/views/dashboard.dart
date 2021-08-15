import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/src/utils/screen_util.dart';
import 'package:termare_app/app/modules/terminal/controllers/terminal_controller.dart';
import 'package:termare_app/app/modules/terminal/views/quark_window_check.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';
import 'package:termare_app/app/widgets/custom_icon_button.dart';
import 'package:termare_app/themes/app_colors.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key, this.onSelect}) : super(key: key);
  final void Function() onSelect;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool exchangeWindow = false;
  TerminalController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    if (exchangeWindow) {
      return Material(
        child: Stack(
          alignment: Alignment.center,
          children: [
            QuarkWindowCheck(
              children: controller.getPtyTermsForCheck(),
              onSelect: (value) {
                controller.switchTo(value);
                widget.onSelect();
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NiIconButton(
                    onTap: () {
                      exchangeWindow = false;
                      setState(() {});
                    },
                    child: Icon(Icons.cached),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: Scaffold(
        backgroundColor: AppColors.grey.shade100,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '本地终端',
                      style: TextStyle(
                        color: AppColors.fontColor,
                        fontSize: 22.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NiIconButton(
                      onTap: () {
                        exchangeWindow = true;
                        setState(() {});
                      },
                      child: Icon(Icons.cached),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: GetBuilder<TerminalController>(
                    builder: (controller) {
                      final List<Widget> children = [];
                      for (int i = 0; i < controller.terms.length; i++) {
                        children.add(TerminalItem(
                          title: 'localhost',
                          onTap: () {
                            controller.switchTo(i);
                            widget.onSelect();
                          },
                        ));
                      }
                      return Wrap(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        runSpacing: 10.w,
                        children: [
                          ...children,
                          Material(
                            color: AppColors.grey.shade300,
                            borderRadius: BorderRadius.circular(12.w),
                            child: Container(
                              height: 60.w,
                              width: 80.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.createPtyTerm();
                                },
                                onTapDown: (_) {
                                  Feedback.forLongPress(context);
                                },
                                borderRadius: BorderRadius.circular(12.w),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Text(
                  '远程终端',
                  style: TextStyle(
                    color: AppColors.fontColor,
                    fontSize: 22.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Wrap(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Material(
                        color: AppColors.grey.shade300,
                        borderRadius: BorderRadius.circular(12.w),
                        child: Container(
                          height: 60.w,
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: InkWell(
                            onTap: () {
                              controller.createPtyTerm();
                            },
                            onTapDown: (_) {
                              Feedback.forLongPress(context);
                            },
                            borderRadius: BorderRadius.circular(12.w),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      value: SystemUiOverlayStyle.dark,
    );
  }
}

class TerminalItem extends StatelessWidget {
  const TerminalItem({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffe0e0e0),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.android),
              Text(
                title ?? '',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
