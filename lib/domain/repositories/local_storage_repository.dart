import 'package:recorder_app/domain/domain.dart';

abstract class LocalStorageRepository {

  Future<void> toggleFavorite( Reminder reminder );
  Future<bool> isReminderFavorite( int id );
  Future<List<Reminder>> loadReminders();

}