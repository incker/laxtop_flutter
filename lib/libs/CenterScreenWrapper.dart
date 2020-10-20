import 'package:flutter/material.dart';

class CenterScreenWrapper extends StatelessWidget {
  final String title;
  final List<Widget> widgetList;
  final EdgeInsetsGeometry padding;
  final Key scaffoldKey;

  CenterScreenWrapper(this.title, this.widgetList,
      {this.padding = const EdgeInsets.only(bottom: 65.0),
      Key key,
      this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: this.widgetList,
          ),
        ),
      ),
    );
  }
}
