import 'package:flutter/material.dart';


class CustomProductField extends StatelessWidget {

  final bool isTopField; // La idea es que tenga bordes redondeados arriba
  final bool isBottomField; // La idea es que tenga bordes redondeados abajo
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Color color;
  final Color textColor;
  final List<Shadow>? textShadows;
  final double? textSize;
  final FontWeight? textWeight;


  const CustomProductField({
    super.key, 
    this.isTopField = false, 
    this.isBottomField = false, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.initialValue = '',
    this.onChanged, 
    this.onFieldSubmitted, 
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.textShadows,
    this.textSize,
    this.textWeight,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: isTopField ? borderRadius : Radius.zero, 
          topRight: isTopField ? borderRadius : Radius.zero, 
          bottomLeft: isBottomField ? borderRadius : Radius.zero,
          bottomRight: isBottomField ? borderRadius : Radius.zero,
        ),
        boxShadow: [
          if (isBottomField)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 5,
              offset: const Offset(0,3)
            )
        ]
      ),
      child: TextFormField(
        readOnly: readOnly,
        onChanged: onChanged,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 20, color: Colors.black87 ),
        maxLines: maxLines,
        initialValue: initialValue,
        decoration: InputDecoration(
          floatingLabelBehavior: maxLines > 1 ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          focusedErrorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          isDense: true,
          label: label != null 
            ? Text( 
              label!, 
              style: TextStyle( 
                color: textColor, 
                shadows: textShadows, 
                fontWeight: textWeight, 
                fontSize: textSize 
              ), 
            )
            : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}