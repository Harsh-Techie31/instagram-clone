import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  var isvis = false;
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      
      controller: widget.textEditingController,
      style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),

      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
        // labelStyle: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
        
        fillColor: Colors.white,
        
        
        suffixIcon: widget.isPass
            ? (isvis
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isvis = false;
                      });
                      
                    },
                    icon: const Icon(Icons.visibility))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isvis = true;
                      });
                      
                    },
                    icon: const Icon(Icons.visibility_off)))
            : null,
        hintText: widget.hintText,

        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass && !isvis,
    );
  }
}
