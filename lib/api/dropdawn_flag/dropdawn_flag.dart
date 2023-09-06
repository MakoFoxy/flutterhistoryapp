import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DropdawnFlag extends StatefulWidget {
  const DropdawnFlag({
    super.key,
    required this.changedLanguage,
  });

  final ValueChanged<String> changedLanguage;

  @override
  State<DropdawnFlag> createState() => DropdawnFlagState();
}

class DropdawnFlagState extends State<DropdawnFlag> {
  String dropdownValue = "";

  @override
  void didUpdateWidget(covariant DropdawnFlag oldWidget) {
    dropdownValue = context.locale.languageCode;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    dropdownValue = context.locale.languageCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Row(
          children: [
            Text(dropdownValue),
            const SizedBox(
              width: 12,
            ),
            Image.asset('lib/assets/images/$dropdownValue.png'),
          ],
        ),
        buttonStyleData: const ButtonStyleData(
          height: 40,
          width: 90,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownStyleData: const DropdownStyleData(
          width: 90,
        ),
        underline: const SizedBox(),
        items: List.generate(context.supportedLocales.length, (index) {
          return DropdownMenuItem<String>(
            onTap: () {
              setState(() {
                dropdownValue = context.supportedLocales[index].languageCode;
                widget.changedLanguage(dropdownValue);
              });
            },
            value: context.supportedLocales[index].languageCode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  context.supportedLocales[index].languageCode,
                ),
                SizedBox(
                  width: 12,
                ),
                Image.asset(
                  'lib/assets/images/${context.supportedLocales[index].languageCode}.png',
                  width: 30,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}
