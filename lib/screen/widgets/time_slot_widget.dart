import 'package:flutter/material.dart';

class TimeSlotWidget extends StatelessWidget {
  final int index;
  final bool isSelected;
  final bool isInRange;

  const TimeSlotWidget({
    super.key,
    required this.index,
    this.isSelected = false,
    this.isInRange = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.green
            : isInRange
                ? Colors.lightGreen
                : Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        textAlign: TextAlign.center,
        'Time Slot $index',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
