import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> labelItems;
  final String? selectedLabel;
  final String label;
  final double buttonSize;
  final ValueChanged<String?> onChanged;
  const CustomDropDown({
    super.key,
    required this.label,
    required this.labelItems,
    this.selectedLabel,
    required this.onChanged,
    required this.buttonSize,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectLabel;
  @override
  void initState() {
    super.initState();
    _selectLabel = widget.selectedLabel;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: SizedBox(
        width: widget.buttonSize,
        child: DropdownButton2<String>(
          isExpanded: true,
          items: widget.labelItems
              .map(
                (String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectLabel == item ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
              )
              .toList(),
          value: _selectLabel,
          onChanged: (String? value) {
            setState(() {
              _selectLabel = value;
            });
            widget.onChanged(value);
          },
          customButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(225, 255, 255, 255),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 76, 80, 98),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
