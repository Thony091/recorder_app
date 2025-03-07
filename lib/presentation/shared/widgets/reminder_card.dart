import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/domain/entities/reminder.dart';
import 'package:recorder_app/presentation/presentation.dart'; // Usa icons de Lucide para un diseño más moderno

class ReminderCard extends ConsumerWidget {
  final Reminder reminder;

  const ReminderCard({
    super.key, 
    required this.reminder
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textStyle = AppTheme().getTheme().textTheme;

    return Container(
      width: double.infinity,
      height: 180, 
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                SizedBox(height: 5),
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reminder.title,
                        style: textStyle.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox( height: 5,),
                // Description
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only( right: 35),
                        child: Text(
                          reminder.description,
                          style: textStyle.bodyMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time
                    Row(
                      children: [
                        Icon(
                          LucideIcons.clock, 
                          color: Colors.orange,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Text(reminder.time, style: textStyle.bodySmall ),
                      ]
                    ),
                    // Frequency
                    Row(
                      children: [
                        Icon( 
                          reminder.frequency == 'Único' 
                            ? LucideIcons.repeat1
                            : LucideIcons.repeat,
                          color: reminder.frequency == 'Único'
                            ? Colors.blue
                            : Colors.green,
                          size: 30,
                        ), 
                        const SizedBox(width: 8),
                        Text(reminder.frequency, style: textStyle.bodySmall),
                      ],
                    ),
                    // Status
                    Row(
                      children: [
                        Icon(
                          reminder.status == 'Completado' 
                            ? LucideIcons.checkCircle 
                            : reminder.status == 'Pendiente' 
                              ? LucideIcons.penTool
                              : LucideIcons.xCircle,
                          color: reminder.status == 'Completado' 
                            ? Colors.green 
                            : reminder.status == 'Pendiente' 
                              ? Colors.blue
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          reminder.status,
                          style: textStyle.bodySmall
                        ),
                      ],
                    ),
          
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: -15,
            right: -12,
            child: Row(
              children: [
                Icon(
                  LucideIcons.bell, 
                  color: Colors.green,
                  size: 55,
                ),
              ],
            ),
          ),

          Positioned(
            right: 1,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white38
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon( 
                      Icons.edit, 
                      color: Colors.blue, 
                      size: 25,
                    ),
                    onPressed: () {
                      ref.read( remiderFormProvider.notifier ).setReminderSelected( reminder );
                      ref.read( remiderFormProvider.notifier ).setEditReminder(true);
                      ref.read( homeProvider.notifier ).setReminderSelected( reminder );
                      ref.read( homeProvider.notifier ).setIsFormSelected(true);
                      ref.read( homeProvider.notifier ).setEditReminder(true);
                    },
                  ),
                  // SizedBox(height: 1),
                  IconButton(
                    icon: Icon( 
                      Icons.delete, 
                      color: Colors.red, 
                      size: 30,
                    ),
                    onPressed: () async {
                      ref.read( remiderFormProvider.notifier ).setReminderSelected( reminder );
                      await ref.read( remiderFormProvider.notifier ).deleteReminder();
                    },
                  )
                ],
              ),
            )
          )

        ]
      ),
    );
  }
}
