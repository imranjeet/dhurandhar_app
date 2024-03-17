import 'package:dhurandhar/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableOtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const EditableOtpField({Key? key, this.length = 6, required this.onChanged})
      : super(key: key);

  @override
  State<EditableOtpField> createState() => _EditableOtpFieldState();
}

class _EditableOtpFieldState extends State<EditableOtpField> {
  late List<String> _otpValues;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _otpValues = List.generate(widget.length, (_) => '');
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.isNotEmpty &&
            _controllers[i].text.length <= 1) {
          setState(() {
            _otpValues[i] = _controllers[i].text;
            widget.onChanged(_otpValues.join());
          });
        }
      });

      _controllers[i].value = _controllers[i].value.copyWith(
            text: _otpValues[i],
            selection:
                TextSelection.collapsed(offset: _controllers[i].text.length),
          );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _requestFocus(int index) {
    if (index >= 0 && index < widget.length) {
      _focusNodes[index].requestFocus();
    }
  }

  void _onTextChanged(String value, int index) {
    if (value.length <= 1) {
      setState(() {
        _otpValues[index] = value;
        widget.onChanged(_otpValues.join());
      });

      if (value.isNotEmpty) {
        if (index < widget.length - 1) {
          _requestFocus(index + 1);
        } else {
          _focusNodes[index].unfocus();
        }
      }
    } else if (value.length > 1) {
      String newValue = value.substring(value.length - 1);
      setState(() {
        _otpValues[index] = newValue;
        widget.onChanged(_otpValues.join());
      });

      _controllers[index].text = newValue;
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);

      if (index < widget.length - 1) {
        _requestFocus(index + 1);
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onBackspacePressed(int index) {
    if (index > 0) {
      _requestFocus(index - 1);
    }

    setState(() {
      if (_controllers[index].text.isNotEmpty) {
        _otpValues[index] = '';
        _controllers[index].value = _controllers[index].value.copyWith(
              text: '',
              selection: const TextSelection.collapsed(offset: 0),
            );
      } else if (index > 0) {
        _otpValues[index - 1] = '';
        _controllers[index - 1].value = _controllers[index - 1].value.copyWith(
              text: '',
              selection: const TextSelection.collapsed(offset: 0),
            );
        _requestFocus(index - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
          _onBackspacePressed(_focusNodes.indexWhere((node) => node.hasFocus));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.length,
          (index) => Container(
            width: size.height * 0.053,
            height: size.height * 0.062,
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            decoration: BoxDecoration(
              color: const Color(0XFFFAFAFA),
              border: Border.all(color: const Color(0XFFEEEEEE)),
              // border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                // maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onTextChanged(value, index),
                onSubmitted: (value) {
                  if (value.isEmpty && index > 0) {
                    _requestFocus(index - 1);
                  }
                },
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFFEEEEEE))),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0XFFEEEEEE), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  ),
                ),
                onTap: () {
                  // if (_otpValues[index].isNotEmpty) {
                  //   setState(() {
                  //     _otpValues[index] = '';
                  //     _controllers[index].text = '';
                  //   });
                  // }
                  _requestFocus(index);
                },
                onEditingComplete: () => _focusNodes[index].unfocus(),

                // onBackspacePressed: () => _onBackspacePressed(index),
                style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(30, 60, 87, 1),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
