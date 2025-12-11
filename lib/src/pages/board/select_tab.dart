import 'package:flutter/material.dart';
import 'package:global_repository/src/widgets/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SelectTab<T> extends StatefulWidget {
  const SelectTab({
    Key? key,
    required this.onTabChange,
    required this.value,
    required this.tabs,
  }) : super(key: key);
  final T value;
  final ValueChanged<T> onTabChange;
  final List<String> tabs;

  @override
  State<SelectTab<T>> createState() => _SelectTabState<T>();
}

class _SelectTabState<T> extends State<SelectTab<T>> {
  late List<String> tabs = widget.tabs;
  int selectValue = 0;
  late TextStyle style = TextStyle(
    fontSize: l(20),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context).copyWith(
      brightness: Brightness.dark,
    );
    ColorScheme colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: l(20),
        children: [
          for (int i = 0; i < tabs.length; i++)
            Builder(builder: (context) {
              bool isSelect = selectValue == i;
              return GestureDetector(
                onTap: () {
                  selectValue = i;
                  widget.onTabChange(tabs[i] as T);
                  setState(() {});
                },
                child: Container(
                  height: ResponsiveBreakpoints.of(context).isMobile ? l(36) : l(40),
                  decoration: BoxDecoration(
                    color: isSelect ? colorScheme.primary : colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(l(12)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: l(16)),
                  child: Center(
                    child: Text(
                      tabs[i],
                      style: style.copyWith(
                        color: isSelect ? colorScheme.onPrimary : colorScheme.onSurface,
                        fontSize: l(16),
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
