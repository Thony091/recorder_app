import 'package:formz/formz.dart';

// Define input validation errors
enum RemiderTimeError { empty, format }

// Extend FormzInput and provide the input type and error type.
class RemiderTime extends FormzInput<String, RemiderTimeError> {

  // Obtener la hora y minutos actuales como referencia
  static final DateTime now = DateTime.now();

  // Call super.pure to represent an unmodified form input.
  const RemiderTime.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const RemiderTime.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case RemiderTimeError.empty:
        return 'El campo es requerido';
      case RemiderTimeError.format:
        return 'Error en la hora, la hora debe ser mayor a la actual';
      default:
        return null;
    }
  }

  // Override validator to handle validating a given input value.
  @override
  RemiderTimeError? validator(String value) {
    if (value.isEmpty) return RemiderTimeError.empty;
    
    try {
      // Convertir el valor String a DateTime (solo hora y minutos)
      List<String> partes = value.split(":");
      if (partes.length != 2) return RemiderTimeError.format;

      int horas = int.parse(partes[0]);
      int minutos = int.parse(partes[1]);

      DateTime inputTime = DateTime(now.year, now.month, now.day, horas, minutos);

      // Validar que la hora ingresada sea menor a la actual
      if ( !inputTime.isAfter(now) ) {
        return RemiderTimeError.format;
      }
    } catch (e) {
      return RemiderTimeError.format;
    }

    return null;
  }
}
