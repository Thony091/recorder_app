import 'package:recorder_app/domain/datasources/datasuorces_container.dart';
import 'package:recorder_app/domain/entities/reminder.dart';
import 'package:recorder_app/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {

  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<bool> isReminderFavorite(int id) {
    return datasource.isReminderFavorite(id);
  }

  @override
  Future<List<Reminder>> loadReminders() {
    return datasource.loadReminders();
  }

  @override
  Future<void> toggleFavorite(Reminder reminder) {
    return datasource.toggleFavorite(reminder);
  }

}