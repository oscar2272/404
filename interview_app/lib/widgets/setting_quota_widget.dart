import 'package:flutter/material.dart';
import 'package:interview_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SettingQuota extends StatefulWidget {
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
  State<SettingQuota> createState() => _SettingQuotaState();
}

class _SettingQuotaState extends State<SettingQuota> {
  late UserProvider userState;
  @override
  void initState() {
    super.initState();
    userState = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> settingQuota(BuildContext context, double goalvalue) async {
    try {
      await userState.settingQuota(widget.goalValue.toInt());

      await userState.fetchUserData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('목표량이 저장되었습니다.')),
      );

      widget.onClose(); // 저장 후 설정 창 닫기
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 400 / 430,
      color: const Color(0xFFf2f3f8),
      child: Column(
        children: [
          Slider(
            inactiveColor: const Color(0xFFE1E3E6),
            thumbColor: Colors.white,
            activeColor: const Color(0xFF2688EB),
            value: widget.goalValue,
            min: 0,
            max: 50,
            divisions: 10,
            label: widget.goalValue.toInt().toString(), //user.quota
            onChanged: widget.onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  '목표량: ${widget.goalValue.round()}',
                  style: TextStyle(fontSize: width * 18 / 430),
                ),
              ),
              SizedBox(
                width: width * 50 / 430,
              ),
              ElevatedButton(
                onPressed: () async {
                  await settingQuota(context, widget.goalValue);
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
