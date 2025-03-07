
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/presentation/providers/storage/local_storage_provider.dart';

final isFavoriteProvider = FutureProvider.family.autoDispose( (ref, int id )  {
  final localStorageRepository = ref.watch( localStorageRepositoryProvider );
  return localStorageRepository.isReminderFavorite( id );
});

final favoriteRemindersProvider = StateNotifierProvider<StorageRemindersNotifier, Map<int,Reminder>>((ref) {
  final localStorageRepository = ref.watch( localStorageRepositoryProvider );
  return StorageRemindersNotifier( localStorageRepository: localStorageRepository );
});


class StorageRemindersNotifier extends StateNotifier<Map<int, Reminder>> {
  
  final LocalStorageRepository localStorageRepository;

  StorageRemindersNotifier({
    required this.localStorageRepository
  }): super({});

  /// Metodo para obtener los recordatorios favoritos
  Future<List<Reminder>> loadReminders() async {
    final reminders = await localStorageRepository.loadReminders();
    
    final tempRemindersMap = <int, Reminder>{};
    for( final reminder in reminders ) {
      tempRemindersMap[reminder.id] = reminder;
    }

    state = { ...state, ...tempRemindersMap };

    return reminders;
  }

  /// Metodo para actualizar el estado de un recordatorio en la lista de favoritos
  Future<void> toggleFavorite( Reminder reminder ) async { 
    await localStorageRepository.toggleFavorite(reminder);
    final bool isReminderInFavorites = state[reminder.id] != null;

    if ( isReminderInFavorites ) {
      state.remove(reminder.id);
      state = { ...state };
    } else {
      state = { ...state, reminder.id: reminder };
    }

  }

}