import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recorder_app/domain/datasources/datasuorces_container.dart';
import 'package:recorder_app/domain/entities/reminder.dart';

class IsarDatasource extends LocalStorageDatasource {

    late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {

    final dir = await getApplicationDocumentsDirectory();
    
    if ( Isar.instanceNames.isEmpty ) {
      return await Isar.open(
        [ ReminderSchema ], 
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }



  @override
  Future<bool> isReminderFavorite(int id) async {
    final isar = await db;

    final Reminder? isFavoriteMovie = await isar.reminders
      .filter()
      .idEqualTo(id)
      .findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<List<Reminder>> loadReminders() async {
    
    final isar = await db;

    return isar.reminders.where()
      .findAll();
  }

  @override
  Future<void> toggleFavorite(Reminder reminder) async {

    final isar = await db;

    final favoriteReminder = await isar.reminders
      .filter()
      .idEqualTo(reminder.id)
      .findFirst();

    if ( favoriteReminder != null ) {
      // Borrar
      isar.writeTxnSync(() => isar.reminders.deleteSync( favoriteReminder.isarId! ));
      return;
    }

    // Insertar
    isar.writeTxnSync(() => isar.reminders.putSync(reminder));

  }

}