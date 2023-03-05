import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'privacy_page.dart';

FontWeight? _bold = GetPlatform.isLinux ? null : FontWeight.bold;
String _defaultApplicationName(BuildContext context) {
  // This doesn't handle the case of the application's title dynamically
  // changing. In theory, we should make Title expose the current application
  // title using an InheritedWidget, and so forth. However, in practice, if
  // someone really wants their application title to change dynamically, they
  // can provide an explicit applicationName to the widgets defined in this
  // file, instead of relying on the default.
  final Title? ancestorTitle = context.findAncestorWidgetOfExactType<Title>();
  return ancestorTitle?.title ?? Platform.resolvedExecutable.split(Platform.pathSeparator).last;
}

/// 关于页面
class AboutPage extends StatelessWidget {
  const AboutPage({
    Key? key,
    this.appVersion = '1.0.0',
    this.versionCode = '1',
    this.applicationName,
    this.coolapkLink,
    this.license,
    this.logo = const SizedBox(),
  }) : super(key: key);

  final String appVersion;
  final String versionCode;
  final String? applicationName;
  final String? coolapkLink;
  final String? license;
  final Widget logo;

  @override
  Widget build(BuildContext context) {
    AppBar? appBar;
    final appName = applicationName ?? _defaultApplicationName(context);
    if (ResponsiveWrapper.of(context).isPhone) {
      appBar = AppBar(
        title: Text('关于'),
        automaticallyImplyLeading: false,
      );
    }
    return Scaffold(
      body: Column(
        children: [
          if (appBar != null) appBar,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: ScrollController(),
                padding: EdgeInsets.only(bottom: 48.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.w),
                    logo,
                    SizedBox(height: 8.w),
                    Text(
                      appName,
                      style: TextStyle(
                        fontSize: 20.w,
                        fontWeight: _bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24.w),
                    GlobalCardItem(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _SettingItem(
                            title: '当前版本',
                            suffix: Text(
                              '$appVersion($versionCode)',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                            ),
                          ),
                          _SettingItem(
                            title: '分支',
                            suffix: Text(
                              'dev',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                            ),
                          ),
                          _SettingItem(
                            title: '更新日志',
                            onTap: () {
                              Get.to(const ChangeLogPage());
                            },
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                          ),
                          _SettingItem(
                            title: '其他版本下载',
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                            onTap: () async {
                              const String url = 'http://nightmare.fun/YanTool/resources/ADBTool/?C=N;O=A';
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(
                                  url,
                                  mode: LaunchMode.externalNonBrowserApplication,
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w),
                    GlobalCardItem(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _SettingItem(
                            title: '服务条款',
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                          ),
                          _SettingItem(
                            title: '隐私政策',
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                            onTap: () {
                              Get.to(const PrivacyPage());
                            },
                          ),
                          _SettingItem(
                            title: '开源协议',
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                            onTap: () {
                              Get.to(LicensePage(
                                applicationName: appName,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w),
                    GlobalCardItem(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          _SettingItem(
                            title: 'github.com/mengyanshou',
                            subTitle: '关注开发者Github',
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.w),
                              child: ClipOval(
                                child: Image.network(
                                  'http://nightmare.fun/YanTool/image/hong.jpg',
                                  width: 44.w,
                                ),
                              ),
                            ),
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                            onTap: () async {
                              const String url = 'https://github.com/mengyanshou';
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(
                                  url,
                                  mode: LaunchMode.externalNonBrowserApplication,
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          SizedBox(height: 8.w),
                          _SettingItem(
                            title: '梦魇兽',
                            subTitle: '关注开发者酷安',
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.w),
                              child: ClipOval(
                                child: Image.network(
                                  'http://nightmare.fun/YanTool/image/hong.jpg',
                                  width: 44.w,
                                ),
                              ),
                            ),
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                            onTap: () async {
                              const String url = 'http://www.coolapk.com/u/1345256';
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(
                                  url,
                                  mode: LaunchMode.externalNonBrowserApplication,
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                          SizedBox(height: 8.w),
                          _SettingItem(
                            title: '其他相关软件下载',
                            subTitle: '“无界”、“魇·工具箱”、“速享”、“Code FA”等相关作品下载',
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.w),
                              child: ClipOval(
                                child: Image.network(
                                  'http://nightmare.fun/YanTool/image/hong.jpg',
                                  width: 44.w,
                                ),
                              ),
                            ),
                            suffix: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.w,
                            ),
                            onTap: () async {
                              const String url = 'http://nightmare.fun';
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(
                                  url,
                                  mode: LaunchMode.externalNonBrowserApplication,
                                );
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w),
                    GlobalCardItem(
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Text(
                            license ?? '',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatefulWidget {
  const _SettingItem({
    Key? key,
    this.title,
    this.onTap,
    this.subTitle = '',
    this.suffix = const SizedBox(),
    this.prefix,
  }) : super(key: key);

  final String? title;
  final String subTitle;
  final void Function()? onTap;
  final Widget suffix;
  final Widget? prefix;
  @override
  State createState() => _SettingItemState();
}

class _SettingItemState extends State<_SettingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      // highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.w,
          horizontal: 16.w,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 48.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (widget.prefix != null)
                  Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: widget.prefix,
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.title ?? '',
                              style: TextStyle(
                                // color: Theme.of(context).colorScheme.primaryVariant,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.w,
                                // height: 1.0,
                              ),
                            ),
                            if (widget.subTitle.isNotEmpty)
                              Builder(builder: (_) {
                                final String content = widget.subTitle;
                                return Column(
                                  children: [
                                    SizedBox(height: 4.w),
                                    Text(
                                      content,
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                        fontWeight: FontWeight.w400,
                                        // height: 1.0,
                                        fontSize: 12.w,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          ],
                        ),
                      ),
                      widget.suffix,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlobalCardItem extends StatelessWidget {
  const GlobalCardItem({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12.w),
      clipBehavior: Clip.hardEdge,
      color: backgroundColor,
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.w),
        child: child,
      ),
    );
  }
}
