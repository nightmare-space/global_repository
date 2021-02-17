import 'package:flutter/material.dart';

class NiNavigator {
  NiNavigator.of(this.context);
  final BuildContext context;
  Future<T> push<T>(Widget page) async {
    return await Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (_) {
          return page;
        },
      ),
    );
  }
}
