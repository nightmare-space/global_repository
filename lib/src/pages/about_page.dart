import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:global_repository/generated/l10n.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher_string.dart';


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

String baseUri = 'http://nightmare.press';

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
    this.otherVersionLink,
    this.openSourceLink,
    this.hasTerms = false,
    this.canOpenDrawer = true,
  }) : super(key: key);

  final String appVersion;
  final String versionCode;
  final String? applicationName;
  final String? coolapkLink;
  final String? license;
  final String? otherVersionLink;
  final String? openSourceLink;
  final Widget logo;
  final bool hasTerms;
  final bool canOpenDrawer;

  @override
  Widget build(BuildContext context) {
    Log.i('Localizations.localeOf(context) -> ${Localizations.localeOf(context)}');
    S.load(Localizations.localeOf(context));
    return Localizations(
      locale: Localizations.localeOf(context),
      delegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Builder(builder: (context) {
        AppBar? appBar;
        final appName = applicationName ?? _defaultApplicationName(context);
        if (ResponsiveBreakpoints.of(context).isMobile) {
          appBar = AppBar(
            title: Text(S.of(context).aboutTitle),
            leading: canOpenDrawer ? DrawerOpenButton(scaffoldContext: context) : null,
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
                          ),
                        ),
                        SizedBox(height: 24.w),
                        GlobalCardItem(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _SettingItem(
                                title: S.current.currentVersion,
                                suffix: Text(
                                  '$appVersion($versionCode)',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              _SettingItem(
                                title: S.current.ref,
                                suffix: Text(
                                  'dev',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              _SettingItem(
                                title: S.current.changelog,
                                onTap: () {
                                  openPage(const ChangeLogPage(), title: S.current.changelog);
                                },
                                suffix: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.w,
                                ),
                              ),
                              if (otherVersionLink != null)
                                _SettingItem(
                                  title: S.current.otherVersionDownload,
                                  suffix: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                  ),
                                  onTap: () async {
                                    if (otherVersionLink == null) {
                                      return;
                                    }
                                    String url = otherVersionLink!;
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
                              if (openSourceLink != null)
                                _SettingItem(
                                  title: '${applicationName ?? '应用'} ${S.current.openSourceLink}',
                                  suffix: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                  ),
                                  onTap: () async {
                                    String url = openSourceLink!;
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
                              if (hasTerms)
                                _SettingItem(
                                  title: '服务条款',
                                  suffix: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                  ),
                                ),
                              _SettingItem(
                                title: S.current.privacyPolicy,
                                suffix: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.w,
                                ),
                                onTap: () {
                                  openPage(const PrivacyPage(), title: '隐私政策');
                                },
                              ),
                              _SettingItem(
                                title: S.current.OpenSourceLicenses,
                                suffix: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.w,
                                ),
                                onTap: () {
                                  openPage(
                                    LicensePage(
                                      applicationName: appName,
                                    ),
                                    title: '开源协议',
                                  );
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
                                      '$baseUri/YanTool/image/hong.jpg',
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
                                      '$baseUri/YanTool/image/hong.jpg',
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
                                      '$baseUri/YanTool/image/hong.jpg',
                                      width: 44.w,
                                    ),
                                  ),
                                ),
                                suffix: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.w,
                                ),
                                onTap: () async {
                                  String url = baseUri;
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
      }),
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
      color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.w),
        child: child,
      ),
    );
  }
}
