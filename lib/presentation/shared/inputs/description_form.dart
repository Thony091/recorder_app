import 'package:formz/formz.dart';

// Define input validation errors
enum DescriptionFormError { empty, format, length}

// Extend FormzInput and provide the input type and error type.
class DescriptionForm extends FormzInput<String, DescriptionFormError> {


  // Call super.pure to represent an unmodified form input.
  const DescriptionForm.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const DescriptionForm.dirty( String value ) : super.dirty(value);



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == DescriptionFormError.empty ) return 'El campo es requerido';


    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DescriptionFormError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return DescriptionFormError.empty;

    return null;
  }
}