import 'package:flutter/material.dart';

class MyYearPicker extends StatefulWidget {
  const MyYearPicker({
    super.key,
  });

  @override
  State<MyYearPicker> createState() => _MyYearPickerState();
}

class _MyYearPickerState extends State<MyYearPicker> {
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text("Select Year"),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Select a year"),
              content: YearPicker(
                selectedDate: DateTime(selectedYear),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                onChanged: (date) {
                  setState(() {
                    selectedYear = date.year;
                  });
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}
