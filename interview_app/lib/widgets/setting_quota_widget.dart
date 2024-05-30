import 'package:flutter/material.dart';

class SettingQuota extends StatelessWidget {
  const SettingQuota({
    super.key,
    required this.onClose,
    required this.goalValue,
    required this.onChanged,
  });
  final VoidCallback onClose;
  final double goalValue;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: const Color(0xFFf2f3f8),
      child: Column(
        children: [
          Slider(
            inactiveColor: const Color(0xFFE1E3E6),
            thumbColor: Colors.white,
            activeColor: const Color(0xFF2688EB),
            value: goalValue,
            min: 0,
            max: 50,
            divisions: 10,
            label: goalValue.round().toString(), //user.quota
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '목표량: ',
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                child: Text(
                  '${goalValue.round()}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: onClose,
                child: const Text('save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
