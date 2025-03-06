import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/domain/domain.dart';
import 'package:recorder_app/infrastructure/infrastructure.dart';
import 'package:recorder_app/infrastructure/repositories/firestore_service_repository_impl.dart';


final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {

  final firestoreRepository = FirestoreServiceRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return HomeNotifier(
    firestoreServiceRepository: firestoreRepository,
    keyValueStorageService: keyValueStorageService,
  );
});
class HomeNotifier extends StateNotifier<HomeState> {

  final FirestoreServiceRepository firestoreServiceRepository;
  final KeyValueStorageService keyValueStorageService;

  HomeNotifier({
    required this.firestoreServiceRepository,
    required this.keyValueStorageService,
  }) : super(HomeState()){
    getRemiders();
  }

  Future<List<Reminder>> getRemiders() async {

    try {

      state = state.copyWith(isLoading: true);

      final userId = await keyValueStorageService.getValue<String>('userId');

      final data = await firestoreServiceRepository.getUserDataFromFirestore( 'reminders', userId ?? '' );

      final userDataFirestore = UserDataFirestoreResponse.fromJson( data );

      final reminders = userDataFirestore.reminders.map((e) => UserDataMapper.userDataToEntity( e ) ).toList();

      state = state.copyWith(reminders: reminders);

      return reminders;
      
    } catch (e) {
      print("Error getting reminders: $e");
      return [];
    }

  }

  List<Reminder> getRemidersList() {
    return state.reminders;
  }

  Future<void> createReminder( Map< String, dynamic > remiderData ) async {

    try {

      state = state.copyWith(isLoading: true);

      final userId = await keyValueStorageService.getValue<String>('userId');

      await firestoreServiceRepository.addDataToFirestore( remiderData, 'reminders', userId ?? '' );
      
      await Future.delayed(const Duration(seconds: 1), () async => getRemiders() );
      state = state.copyWith(
        isLoading: false,
        isFormSelected: false,
      );
      
    } catch (e) {
      throw Exception(e.toString());
    }

  }

  void setIsFormSelected(bool isFormSelected) {
    state = state.copyWith(isFormSelected: isFormSelected);
  }

  void cleanReminders() {
    state = state.copyWith(reminders: []);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

}

class HomeState {

  final bool isFormSelected;
  final bool isLoading;
  final List<Reminder> reminders;
  final String selectedFilter;

  HomeState({
    this.isFormSelected = false,
    this.isLoading = false,
    this.reminders = const [],
    this.selectedFilter = 'Todos',
  });

  HomeState copyWith({
    bool? isFormSelected,
    bool? isLoading,
    List<Reminder>? reminders,
    String? selectedFilter,
  }) => HomeState(
    isFormSelected: isFormSelected ?? this.isFormSelected,
    isLoading: isLoading ?? this.isLoading,
    reminders: reminders ?? this.reminders,
    selectedFilter: selectedFilter ?? this.selectedFilter,
  );

  @override
  String toString() {
    return '''
    isFormSelected: $isFormSelected,
    isLoading: $isLoading
    reminders: $reminders
    selectedFilter: $selectedFilter
    ''';
  }
}