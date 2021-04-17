import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

class NiIconButton extends StatelessWidget {
  const NiIconButton({Key key, this.child, this.onTap}) : super(key: key);
  final Widget child;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 36,
        child: InkWell(
          canRequestFocus: false,
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
