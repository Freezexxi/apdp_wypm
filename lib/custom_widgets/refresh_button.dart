import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final Function? refreshFunction;

  RefreshButton({super.key, this.refreshFunction});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (widget.refreshFunction != null) {
          widget.refreshFunction!();
        }
      },
      icon: const Icon(
        Icons.refresh_sharp,
        color: Colors.orangeAccent,
      ),
    );
  }
}
