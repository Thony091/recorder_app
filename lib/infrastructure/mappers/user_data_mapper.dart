

import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/models/user/reminder_model_response.dart';

class UserDataMapper {

  static Reminder userDataToEntity( ReminderModelResponse userDataFs) => Reminder(
    id: userDataFs.id,
    title: userDataFs.title,
    description: userDataFs.description,
    time: userDataFs.time,
    frequency: userDataFs.frequency,
    status: userDataFs.status,
  );

  static ReminderModelResponse userDataToModel( Reminder userData) => ReminderModelResponse(
    id: userData.id,
    title: userData.title,
    description: userData.description,
    time: userData.time,
    frequency: userData.frequency,
    status: userData.status,
  );
}
