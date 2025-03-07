import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/theme/app_theme.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/presentation/presentation.dart';

class EditReminderFormView extends ConsumerStatefulWidget {

  static const name = 'EditReminderFormView';
  final Reminder? reminder;

  const EditReminderFormView({
    super.key,
    required this.reminder,
  });

  @override
  ReminderFormViewState createState() => ReminderFormViewState();
}

class ReminderFormViewState extends ConsumerState<EditReminderFormView> {
  
  final _formKey      = GlobalKey<FormState>();
  final textStyle     = AppTheme().getTheme().textTheme;
  final colorTheme    = AppTheme().getTheme().colorScheme;

  void _pickTime() async {
    final now = TimeOfDay.now();
    final isUnique = ref.read(remiderFormProvider).selectedFrequency == 'Único';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 350,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Seleccionar Hora',
                style: textStyle.titleMedium,
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm, // Solo horas y minutos
                  initialTimerDuration: Duration(
                    hours: ref.read(remiderFormProvider).selectedTime.value != '00:00'
                        ? int.parse(ref.read(remiderFormProvider).selectedTime.value.split(':')[0])
                        : now.hour,
                    minutes: ref.read(remiderFormProvider).selectedTime.value != '00:00'
                        ? int.parse(ref.read(remiderFormProvider).selectedTime.value.split(':')[1])
                        : now.minute,
                  ),
                  onTimerDurationChanged: (Duration newTime) {
                    final selectedHours = newTime.inHours;
                    final selectedMinutes = newTime.inMinutes % 60;

                    // Si la frecuencia es "Único", validar que la hora no sea menor a la actual
                    if (isUnique && (selectedHours < now.hour || (selectedHours == now.hour && selectedMinutes < now.minute))) {
                      return; // No actualizar si la hora es menor a la actual
                    }

                    final formattedTime = '${selectedHours.toString().padLeft(2, '0')}:${selectedMinutes.toString().padLeft(2, '0')}';
                    ref.read(remiderFormProvider.notifier).onTimeChanged(formattedTime);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Aceptar', style: textStyle.bodyMedium,),
              )
            ],
          ),
        );
      },
    );
  }

  @override 
  Widget build(BuildContext context) {

    final textStyle = AppTheme().getTheme().textTheme;
    final homeNotifier = ref.watch(homeProvider.notifier);
    final remiderState = ref.watch(remiderFormProvider);
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
                  'Crear Recordatorio',
                  style: textStyle.titleMedium,
                ),
              ),
              const SizedBox(height: 20),

              // Campo de Título
              TextFormField(
                initialValue: widget.reminder?.title,
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
                initialValue: widget.reminder?.description,
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
                  ref.watch(remiderFormProvider).selectedTime.value == '00:00'
                    ? 'Seleccionar Hora'
                    : 'Hora: ${ref.watch(remiderFormProvider).selectedTime.value}',
                ),
                trailing: const Icon(Icons.access_time), // Icono de reloj en lugar de calendario
                onTap: _pickTime,
              ),

              if ( remiderState.isFormPosted ) Text( remiderState.selectedTime.errorMessage.toString() ),
              const SizedBox(height: 16),

              // Frecuencia del recordatorio
              DropdownButtonFormField<String>(
                value: widget.reminder?.frequency ?? 'Único',
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
                value: widget.reminder?.status ?? 'Pendiente',
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
                      'Crear',
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
