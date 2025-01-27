import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:time_slots_selection/screen/widgets/time_slot_widget.dart';

class TimeSlotsScreen extends StatefulWidget {
  const TimeSlotsScreen({super.key});

  @override
  State<TimeSlotsScreen> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends State<TimeSlotsScreen> {
  List<GlobalKey> timeSlotKeys = [];
  int startSelectedIndex = -1;
  int endSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    timeSlotKeys = List.generate(18, (_) => GlobalKey());
  }

  int findTimeSlotFromPosition(Offset position) {
    for (int i = 0; i < timeSlotKeys.length; i++) {
      final key = timeSlotKeys[i];
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final timeSlotPosition = renderBox.localToGlobal(Offset.zero);
        final timeSlotSize = renderBox.size;
        final rect = Rect.fromLTWH(
          timeSlotPosition.dx,
          timeSlotPosition.dy,
          timeSlotSize.width,
          timeSlotSize.height,
        );

        if (rect.contains(position)) {
          return i;
        }
      }
    }
    return -1;
  }

  bool isInRange(int index) {
    if (startSelectedIndex == -1 || endSelectedIndex == -1) return false;
    return (index >= startSelectedIndex && index <= endSelectedIndex) ||
        (index <= startSelectedIndex && index >= endSelectedIndex);
  }

  void resetSelection() {
    setState(() {
      startSelectedIndex = -1;
      endSelectedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Slots'),
        actions: [
          IconButton(
            onPressed: resetSelection,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(
            18,
            (index) => GestureDetector(
              key: timeSlotKeys[index],
              onVerticalDragStart: (DragStartDetails details) {
                final currentIndex =
                    findTimeSlotFromPosition(details.globalPosition);
                if (currentIndex != -1) {
                  setState(() {
                    startSelectedIndex = currentIndex;
                  });
                }
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                final currentIndex =
                    findTimeSlotFromPosition(details.globalPosition);
                if (currentIndex != -1) {
                  setState(() {
                    endSelectedIndex = currentIndex;
                  });
                }

                log("startSelectedIndex: $startSelectedIndex");
                log("endSelectedIndex: $endSelectedIndex");
              },
              child: TimeSlotWidget(
                index: index,
                isSelected:
                    startSelectedIndex == index || endSelectedIndex == index,
                isInRange: isInRange(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
