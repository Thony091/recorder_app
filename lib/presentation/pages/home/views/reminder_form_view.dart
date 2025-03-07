import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/theme/app_theme.dart';
import 'package:recorder_app/presentation/presentation.dart';

class ReminderFormView extends ConsumerStatefulWidget {

  static const name = 'ReminderFormView';

  const ReminderFormView({super.key});

  @override
  ReminderFormViewState createState() => ReminderFormViewState();
}

class ReminderFormViewState extends ConsumerState<ReminderFormView> {
  
  final _formKey      = GlobalKey<FormState>();
  final textStyle     = AppTheme().getTheme().textTheme;
  final colorTheme    = AppTheme().getTheme().colorScheme;

void _pickDateTime() async {
  final now = DateTime.now();
  final isUnique = ref.read(remiderFormProvider).selectedFrequency == 'Único';
  DateTime selectedDate = now;

  // Mostrar el selector de fecha
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return Container(
        height: 350,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Seleccionar Fecha', style: textStyle.titleMedium),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: now,
                minimumDate: now,
                maximumYear: now.year + 5,
                onDateTimeChanged: (DateTime newDate) {
                  selectedDate = newDate;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Siguiente', style: textStyle.bodyMedium),
            )
          ],
        ),
      );
    },
  );

  // Mostrar el selector de hora
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return Container(
        height: 350,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Seleccionar Hora', style: textStyle.titleMedium),
            Expanded(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: Duration(
                  hours: now.hour,
                  minutes: now.minute,
                ),
                onTimerDurationChanged: (Duration newTime) {
                  final selectedHours = newTime.inHours;
                  final selectedMinutes = newTime.inMinutes % 60;

                  // Si la frecuencia es "Único", validar que la hora no sea menor a la actual
                  if (isUnique && selectedDate.day == now.day &&
                      (selectedHours < now.hour || 
                      (selectedHours == now.hour && selectedMinutes < now.minute))) {
                    return; // No actualizar si la hora es menor a la actual
                  }

                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedHours,
                    selectedMinutes,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final formattedDateTime =
                    "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} "
                    "${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}";

                ref.read(remiderFormProvider.notifier).onDateTimeChanged(formattedDateTime);
                Navigator.pop(context);
              },
              child: Text('Aceptar', style: textStyle.bodyMedium),
            )
          ],
        ),
      );
    },
  );
}


  @override 
  Widget build(BuildContext context) {

    final textStyle       = AppTheme().getTheme().textTheme;
    final homeNotifier    = ref.watch(homeProvider.notifier);
    final homeState       = ref.watch(homeProvider);
    final remiderState    = ref.watch(remiderFormProvider);
    final remiderNotifier = ref.read(remiderFormProvider.notifier);

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              SizedBox(height: 10),
              Center(
                child: Text(
                  homeState.editReminder ? 'Editar Recordatorio' : 'Crear Recordatorio',
                  style: textStyle.titleMedium,
                ),
              ),
              const SizedBox(height: 20),

              // Campo de Título
              TextFormField(
                initialValue: homeState.editReminder ? homeState.reminderSelected?.title : null,
                onChanged: remiderNotifier.onTitleChange,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  focusColor: colorTheme.primary,
                  errorText: remiderState.isFormPosted 
                    ? remiderState.title.errorMessage
                    : null,
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Descripción
              TextFormField(
                initialValue: homeState.editReminder ? homeState.reminderSelected?.description : null,
                onChanged: remiderNotifier.onDescriptionChanged,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  focusColor: colorTheme.primary,
                  errorText: remiderState.isFormPosted 
                    ? remiderState.description.errorMessage
                    : null,
                ),
              ),
              const SizedBox(height: 16),

              // Selección de Hora
              ListTile(
                title: Text(
                  ref.watch(remiderFormProvider).selectedDateTime == ''
                    ? 'Seleccionar Hora'
                    : 'Hora: ${ref.watch(remiderFormProvider).selectedDateTime}',
                ),
                trailing: const Icon(Icons.access_time), // Icono de reloj en lugar de calendario
                onTap: _pickDateTime,
              ),

              const SizedBox(height: 16),

              // Frecuencia del recordatorio
              DropdownButtonFormField<String>(
                value: homeState.editReminder ? homeState.reminderSelected!.frequency : 'Único',
                decoration: const InputDecoration(
                  labelText: 'Frecuencia',
                  border: OutlineInputBorder(),
                ),
                items: ['Único', 'Diario', 'Semanal'].map(
                  (String option) => DropdownMenuItem( value: option, child: Text(option) )
                ).toList(),
                onChanged: (String? newValue) => remiderNotifier.onFrecuencyChanged(newValue!)
              ),
              const SizedBox(height: 20),

              // Estado del recordatorio (inicialmente "Pendiente")
              DropdownButtonFormField<String>(
                value: homeState.editReminder ? homeState.reminderSelected!.status : 'Pendiente',
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: ['Pendiente', 'Completado', 'Omitido'].map(
                  (String option) => DropdownMenuItem(value: option, child: Text(option))
                ).toList(),
                onChanged: (String? newValue) => remiderNotifier.onStatusChanged(newValue!)
              ),
              const SizedBox(height: 30),

              // Botón para Guardar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: remiderState.isPosting
                      ? null
                      : remiderNotifier.onFormSubmit,
                    child: Text(
                      homeState.editReminder ? 'Editar' : 'Crear',
                      style: textStyle.bodyMedium,
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () {
                      homeNotifier.setIsFormSelected(false);
                      homeNotifier.setEditReminder(false);
                    },
                    child: Text(
                      'Cancelar',
                      style: textStyle.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
