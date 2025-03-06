
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/mappers/mappers_container.dart';
import 'package:recorder_app/presentation/presentation.dart';

final remiderFormProvider = StateNotifierProvider.autoDispose< RemiderFormNotifier,RemiderFormState >((ref) {

  final createReminderCallback = ref.watch( homeProvider.notifier ).createReminder;
  final getRemidersCallback   = ref.watch( homeProvider.notifier ).getRemidersList;

  return RemiderFormNotifier(
    createReminderCallback: createReminderCallback,
    getRemidersCallback: getRemidersCallback
  );
});

class RemiderFormNotifier extends StateNotifier<RemiderFormState> {

  final Function(Map<String, dynamic>) createReminderCallback;
  final Function() getRemidersCallback;

  RemiderFormNotifier({
    required this.createReminderCallback,
    required this.getRemidersCallback,
  }): super( RemiderFormState() );
  
  onTitleChange( String value ) {
    final newTitle = TitleForm.dirty(value);
    state = state.copyWith(
      title: newTitle,
      isValid: Formz.validate([ newTitle, state.description, state.selectedTime ])
    );
  }

  onDescriptionChanged( String value ) {
    final newDescription = DescriptionForm.dirty(value);
    state = state.copyWith(
      description: newDescription,
      isValid: Formz.validate([ newDescription, state.title, state.selectedTime ])
    );
  }

  onTimeChanged(String time) {
    final newTime = RemiderTime.dirty(time); 
    state = state.copyWith(
      selectedTime: newTime,
      isValid: Formz.validate([ newTime, state.description, state.title ])
    );
  }

  onFrecuencyChanged(String frecuency) { 
    state = state.copyWith(
      selectedFrequency: frecuency,
    );
  }

  onStatusChanged(String status) { 
    state = state.copyWith(
      selectedStatus: status,
    );
  }

  _touchEveryField() {

    final description = DescriptionForm.dirty(state.description.value);
    final title       = TitleForm.dirty(state.title.value);
    final time        = RemiderTime.dirty(state.selectedTime.value);

    state = state.copyWith(
      isFormPosted: true,
      title: title,
      description: description,
      selectedTime: time,
      isValid: Formz.validate([ title, description, time ])
    );

  }

  onFormSubmit() async {

    try {
      
      _touchEveryField();
      if ( !state.isValid ) return;

      state = state.copyWith(isPosting: true);

      final reminderList = getRemidersCallback();

      // Crear el nuevo recordatorio
      int newId = (reminderList.isNotEmpty)
        ? reminderList.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) + 10
        : 10; // Si está vacío, empezamos desde 10

      final newReminderList = reminderList.map((r) => UserDataMapper.userDataToModel( r )).toList();

      final newReminder = {
        'id': newId,
        'title': state.title.value,
        'description': state.description.value,
        'time': state.selectedTime.value,
        'frequency': state.selectedFrequency,
        'status': state.selectedStatus,
      };

      // Mapa que se enviará a Firestore
      final Map<String, dynamic> firestoreData = {
        'reminders': [...newReminderList.map((r) => r.toJson()), newReminder]
      };

      await createReminderCallback( firestoreData );

      state = state.copyWith(isPosting: false);

    } catch (e) {
      state = state.copyWith(isPosting: false);
      print("Error creando recordatorio: $e");
      throw Exception(e.toString());
    }

  }

}

class RemiderFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final TitleForm title;
  final DescriptionForm description;
  final RemiderTime selectedTime;
  final String selectedFrequency;
  final String selectedStatus;
  final List<Reminder> reminders;

  RemiderFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.title = const TitleForm.pure(),
    this.description = const DescriptionForm.pure(),
    this.selectedTime = minValidTime,
    this.selectedFrequency = 'Único',
    this.selectedStatus = 'Pendiente',
    this.reminders = const [],
  });

  RemiderFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    TitleForm? title,
    DescriptionForm? description,
    RemiderTime? selectedTime,
    String? selectedFrequency,
    String? selectedStatus,
    List<Reminder>? reminders,
  }) => RemiderFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    title: title ?? this.title,
    description: description ?? this.description,
    selectedTime: selectedTime ?? this.selectedTime,
    selectedFrequency: selectedFrequency ?? this.selectedFrequency,
    selectedStatus: selectedStatus ?? this.selectedStatus,
    reminders: reminders ?? this.reminders,
  );

  @override
  String toString() {
    return '''
    RemiderFormState{
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      title: $title,
      description: $description,
      selectedTime: $selectedTime,
      selectedFrequency: $selectedFrequency,
      selectedStatus: $selectedStatus
      reminders: $reminders
    }
    ''';
  }
}

const RemiderTime minValidTime = RemiderTime.dirty('00:00'); // Asumiendo un formato válido