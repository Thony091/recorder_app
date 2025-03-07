
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recorder_app/config/config.dart';
import 'package:recorder_app/presentation/presentation.dart';

class HomeBodyView extends ConsumerStatefulWidget {
  const HomeBodyView({super.key});

  @override
  _HomeBodyPageState createState() => _HomeBodyPageState();
}

class _HomeBodyPageState extends ConsumerState<HomeBodyView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read( homeProvider.notifier ).getRemiders;
  }

  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final textStyle     = AppTheme().getTheme().textTheme;
    final homeNotifier  = ref.read(homeProvider.notifier);
    final reminderFormNotifier  = ref.watch(remiderFormProvider.notifier); 

    return Stack(
      children : [
        Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Mis Recordatorios',
                style: textStyle.titleMedium,
              ),
            ),
            const SizedBox(height: 20),
        
            // Controles de Paginación
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300), 
                      curve: Curves.easeInOut
                    );
                    homeNotifier.setFilter('Todos');
                  }, 
                  child: Text('Mis Recordatorios', style: textStyle.bodySmall,),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300), 
                    curve: Curves.easeInOut
                  ),
                  child: Text('Ordenar por Estado', style: textStyle.bodySmall,),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Linea de separación
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
        
            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _RemindersPage(pageController: _pageController,),
                  _SortOptionsPage( pageController: _pageController ,),
                ],
              ),
            ),

            SizedBox( height: 100,)
          ],
        ),

        Positioned(
          bottom: 30,
          left: 25,
          height: 50,
          child: CustomFilledButton(
            radius: const Radius.circular(100),
            shadowColor: const Color.fromARGB(255, 115, 114, 114),
            spreadRadius: 2,
            blurRadius: 10,
            offsetY: 2,
            text: 'Crear Recordatorio',
            fontSize: 20,
            fontTextWeight: FontWeight.bold,
            buttonColor: Colors.blueAccent.shade400,
            mainAxisAlignment: MainAxisAlignment.start,
            onPressed: () {
              homeNotifier.setIsFormSelected(true);
              reminderFormNotifier.setEditReminder(false);
            },
          )
        ),
      ]
    );
  }
}

// Página de recordatorios creados
class _RemindersPage extends ConsumerWidget {

  final PageController pageController;

  const _RemindersPage({ required this.pageController });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final textStyle = AppTheme().getTheme().textTheme;
    final homeNotifier = ref.read(homeProvider.notifier);

    // Filtrar recordatorios según el estado seleccionado
    final filteredReminders = homeState.selectedFilter == 'Todos'
        ? homeState.reminders
        : homeState.reminders.where((r) => r.status == homeState.selectedFilter).toList();

    return Column(
      children: [
        if (homeState.selectedFilter != 'Todos') //  Botón para regresar
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  homeNotifier.setFilter('Todos');
                  pageController.jumpToPage(1);
                },
                iconSize: 35,
              ),
            ),
          ),
        Expanded(
          child: filteredReminders.isEmpty
              ? Center(
                  child: Text('No hay recordatorios disponibles', style: textStyle.bodyMedium),
                )
              : ListView.builder(
                  itemCount: filteredReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = filteredReminders[index];
                    return ReminderCard(reminder: reminder);
                  },
                ),
        ),
      ],
    );
  }
}



// Página de opciones para ordenar recordatorios
class _SortOptionsPage extends ConsumerWidget {
  final PageController pageController;

  const _SortOptionsPage({required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textStyle     = AppTheme().getTheme().textTheme;
    final homeNotifier = ref.read(homeProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Ordenar por estado:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListTile(
          title:  Text('Pendientes', style: textStyle.bodyMedium,),
          leading: const Icon(Icons.pending_actions),
          onTap: () {
            homeNotifier.setFilter('Pendiente');
            pageController.jumpToPage(0);
          },
        ),
        ListTile(
          title: const Text('Completados'),
          leading: const Icon(Icons.check_circle),
          onTap: () {
            homeNotifier.setFilter('Completado');
            pageController.jumpToPage(0);
          },
        ),
        ListTile(
          title: const Text('Omitidos'),
          leading: const Icon(Icons.cancel),
          onTap: () {
            homeNotifier.setFilter('Omitido');
            pageController.jumpToPage(0);
          },
        ),
      ],
    );
  }
}
