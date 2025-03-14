
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/mappers/mappers_container.dart';
import 'package:recorder_app/presentation/presentation.dart';

final remiderFormProvider = StateNotifierProvider.autoDispose< RemiderFormNotifier,RemiderFormState >((ref) {

  final updateReminderCallback = ref.watch( homeProvider.notifier ).updateReminder;
  final createReminderCallback = ref.watch( homeProvider.notifier ).createReminder;
  final getRemidersCallback   = ref.watch( homeProvider.notifier ).getRemidersList;
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return RemiderFormNotifier(
    updateReminderCallback: updateReminderCallback,
    createReminderCallback: createReminderCallback,
    getRemidersCallback: getRemidersCallback,
    keyValueStorageService: keyValueStorageService,
  );
});

class RemiderFormNotifier extends StateNotifier<RemiderFormState> {

  final Function(Map<String, dynamic>) updateReminderCallback;
  final Function(Map<String, dynamic>) createReminderCallback;
  final Function() getRemidersCallback;
  final KeyValueStorageService keyValueStorageService;

  RemiderFormNotifier({
    required this.updateReminderCallback,
    required this.createReminderCallback,
    required this.getRemidersCallback,
    required this.keyValueStorageService,
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
    // final time        = RemiderTime.dirty(state.selectedTime.value);
    final time        = state.selectedDateTime;

    state = state.copyWith(
      isFormPosted: true,
      title: title,
      description: description,
      selectedDateTime: time,
      isValid: Formz.validate([ title, description ])
    );

  }

  /// Función para crear un nuevo recordatorio.
  onFormSubmit() async {

    try {
      
      _touchEveryField();
      if ( !state.isValid ) return;

      state = state.copyWith(isPosting: true);

      final reminderList = getRemidersCallback();

      final userId = await keyValueStorageService.getValue<String>('userId');

      switch ( state.isEditReminder ) {
        case true:

          // Buscar el recordatorio por ID y actualizarlo
          int index = reminderList.indexWhere((r) => r.id == state.reminderSelected!.id);
          if (index == -1) return; // No encontrado
          final updatedData = {
            'id': state.reminderSelected!.id,
            'userId': userId,
            'title': state.title.value,
            'description': state.description.value,
            'time': state.selectedDateTime,
            'frequency': state.selectedFrequency,
            'status': state.selectedStatus,
          };

          reminderList.removeAt(index);

          final newReminderMap = reminderList.map((r) => UserDataMapper.userDataToModel(r)).toList();


          final Map<String, dynamic> newFirestoreData = { 
            'reminders': [ ...newReminderMap.map((r) => r.toJson()), updatedData ]
          }; 

          await updateReminderCallback( newFirestoreData );

          await _scheduleNotification( index, updatedData );
          state = state.copyWith(selectedDateTime: '');

          break;

        case false:
          // Crear el nuevo recordatorio
          int newId = (reminderList.isNotEmpty)
            ? reminderList.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) + 10
            : 10; // Si está vacío, empezamos desde 10

          final newReminderList = reminderList.map((r) => UserDataMapper.userDataToModel( r )).toList();

          final newReminder = {
            'id': newId,
            'userId': userId,
            'title': state.title.value,
            'description': state.description.value,
            'time': state.selectedDateTime,
            'frequency': state.selectedFrequency,
            'status': state.selectedStatus,
          };

          // Mapa que se enviará a Firestore
          final Map<String, dynamic> firestoreData = {
            'reminders': [...newReminderList.map((r) => r.toJson()), newReminder]
          };

          await createReminderCallback( firestoreData );
          await _scheduleNotification(newId, newReminder);

          state = state.copyWith(
            selectedDateTime: '',
            
          );

          break;
      }

      state = state.copyWith(isPosting: false);

    } catch (e) {
      state = state.copyWith(isPosting: false);
      print("Error creando recordatorio: $e");
      throw Exception(e.toString());
    }

  }


  Future<void> _scheduleNotification(int id, Map<String, dynamic> reminder) async {
    final String title = reminder['title'] ?? 'Sin título';
    final String body = reminder['description'] ?? 'Sin descripción';
    final String time = reminder['time'] ?? '00:00';
    final String? frequency = reminder['frequency'];

    // final now = DateTime.now();
    // final List<String> timeParts = time.split(':');
    final DateTime scheduledDate = DateTime.parse(time);

    if (frequency == 'Único') {
      await NotificationService.scheduleNotification(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
      );
    } else {
      RepeatInterval repeatInterval;
      switch (frequency) {
        case 'Diario':
          repeatInterval = RepeatInterval.daily;
          break;
        case 'Semanal':
          repeatInterval = RepeatInterval.weekly;
          break;
        default:
          print("⏳ Frecuencia no soportada para notificaciones repetitivas.");
          return;
      }

      await NotificationService.scheduleRepeatingNotification(
        id: id,
        title: title,
        body: body,
        repeatInterval: repeatInterval,
      );
    }
  }

  void setEditReminder(bool editReminder) {
    state = state.copyWith(isEditReminder: editReminder);
  }

  void setReminderSelected(Reminder reminder) {
    state = state.copyWith(reminderSelected: reminder);
  }

  Future<void> deleteReminder() async {

    try {
      
      final reminderList = getRemidersCallback();
      // Buscar el recordatorio por ID y actualizarlo
      int index = reminderList.indexWhere((r) => r.id == state.reminderSelected!.id);
      if (index == -1) return; // No encontrado

      reminderList.removeAt(index);

      final newReminderMap = reminderList.map((r) => UserDataMapper.userDataToModel(r)).toList();
      final Map<String, dynamic> newFirestoreData = { 
        'reminders': [ ...newReminderMap.map((r) => r.toJson()) ]
      }; 
      await updateReminderCallback( newFirestoreData );

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void onDateTimeChanged(String dateTime) {
    state = state.copyWith(selectedDateTime: dateTime);
  }

}

class RemiderFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isEditReminder;
  final TitleForm title;
  final DescriptionForm description;
  final RemiderTime selectedTime;
  final String selectedFrequency;
  final String selectedStatus;
  final List<Reminder> reminders;
  final Reminder? reminderSelected;
  final String selectedDateTime; 

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
    this.isEditReminder = false,
    this.reminderSelected,
    this.selectedDateTime = '',
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
    bool? isEditReminder,
    Reminder? reminderSelected,
    String? selectedDateTime,
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
    isEditReminder: isEditReminder ?? this.isEditReminder,
    reminderSelected: reminderSelected ?? this.reminderSelected,
    selectedDateTime: selectedDateTime ?? this.selectedDateTime,
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
      selectedStatus: $selectedStatus,
      reminders: $reminders,
      isEditReminder: $isEditReminder,
      reminderSelected: $reminderSelected,
      selectedDateTime: $selectedDateTime,
    }
    ''';
  }
}

const RemiderTime minValidTime = RemiderTime.dirty('00:00'); // Asumiendo un formato válido