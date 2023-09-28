import 'package:flutter/material.dart';


class CustomTextField extends StatefulWidget {
  final IconData? icon;
  final String hint;
  final TextEditingController? controller;
  bool passType;
  final String? value;
  final String? Function(String?)? validator;

   CustomTextField(
      {
        super.key,
        this.icon,
        required this.hint,
        this.value,
        required this.passType,
        required this.controller,
        required this.validator
      });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool isObsecure = false;
  @override
  void initState() {
    if (widget.value != null) {
      widget.controller!.text = widget.value ?? '';
    }
    if(widget.passType){
      isObsecure = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 60,
        child: Center(
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: isObsecure,
            keyboardType: TextInputType.number,
            enableSuggestions: !widget.passType,
            autocorrect: !widget.passType,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: widget.icon != null
                  ? Icon(
                widget.icon,
                color: const Color(0xff757879),
              )
                  : null,
              suffixIcon:widget.passType ? IconButton(
                icon: Icon(isObsecure
                    ? Icons.visibility
                    : Icons.visibility_off,color: const Color(0xff757879),),
                onPressed: () {
                  setState(() {
                          isObsecure = !isObsecure;
                          },
                  );
                },
              ) : null,
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color:  Color(0xff757879),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}