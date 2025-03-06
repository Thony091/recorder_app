import 'package:formz/formz.dart';

// Define input validation errors
enum TitleFormError { empty, format, length}

// Extend FormzInput and provide the input type and error type.
class TitleForm extends FormzInput<String, TitleFormError> {


  // Call super.pure to represent an unmodified form input.
  const TitleForm.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const TitleForm.dirty( String value ) : super.dirty(value);



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == TitleFormError.empty ) return 'El campo es requerido';


    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TitleFormError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return TitleFormError.empty;

    return null;
  }
}