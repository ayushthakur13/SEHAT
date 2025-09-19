import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PrimaryScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  const PrimaryScaffold({super.key, this.appBar, required this.body, this.bottomNavigationBar});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [SEHATTheme.primaryColor.withOpacity(0.06), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final EdgeInsets padding;
  const Pill(this.label, {super.key, required this.color, this.textColor, this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6)});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}


