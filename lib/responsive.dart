/*
constrained scaffold
for web browsers
responsive
*/
import 'package:flutter/material.dart';

class constrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Color backgroundColor;
  final bool   resizeToAvoidBottomInset;
  const constrainedScaffold({super.key,required, this.appBar,required this.body, this.drawer,required this.backgroundColor,required this.resizeToAvoidBottomInset });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: ConstrainedBox(constraints: const BoxConstraints(
          maxWidth: 430//apply your global constraint here

        ),
        child: body,
        ),
      ),
    );
  }
}
