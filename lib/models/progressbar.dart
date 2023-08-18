import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  late List <Icon> icons;
  late int  count;
  late int total;
  ProgressBar(
    this.icons,
    this.count,
    this.total,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              "$count - $total",
            ),
          ),
          SizedBox(width: 10),
          ...icons,
        ],
      ),
    );
  }
}
