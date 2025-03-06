import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? styleText;
  final Color startColor;
  // final Color? mediumColor;
  final Color endColor;
  final Radius topRadius;
  final Radius bottomRadius;
  final IconData? customIcon;
  final double iconSize;
  final VoidCallback? onIconPressed; // Callback para acciones del ícono
  final Color? iconColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.styleText = const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500,),
    required this.startColor,
    // this.mediumColor,
    required this.endColor,
    this.topRadius = const Radius.circular(0),
    this.bottomRadius = const Radius.circular(0),
    this.customIcon,
    this.iconSize = 20,
    this.iconColor,
    this.onIconPressed, // Constructor modificado para aceptar un callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    return Container(
      height: size.height * 0.1,
      // height: kToolbarHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            startColor,
            // mediumColor ?? startColor, 
            endColor
          ],
          stops: const [0.5, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: bottomRadius, // Redondea las esquinas inferior
          bottomRight: bottomRadius,
          topLeft: topRadius,
          topRight: topRadius,
        ), // Redondea las esquinas
      ), // Altura predeterminada del AppBar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          
          GestureDetector(
            onTap: onIconPressed, // Manejo del tap en el ícono
            child:  Padding(
              padding: const EdgeInsets.only(top: 12, left: 10), // Espacio alrededor del ícono
              child: Icon(
                customIcon, 
                color: iconColor,
                size: iconSize,
              ), // Cambia el ícono según sea necesario
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(
              top: 12,
              left: (size.width * 0.9 - 100) / 2, // Centra el título
            ),
            child: Center(
              child: Text(
                title,
                style: styleText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Define la altura preferida
}
