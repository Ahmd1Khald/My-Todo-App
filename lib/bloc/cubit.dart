import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytodoapp/bloc/states.dart';
import 'package:mytodoapp/modules/archive_tasks.dart';
import 'package:mytodoapp/modules/done_tasks.dart';
import 'package:mytodoapp/modules/new_tasks.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int barIndex = 0;
  List<Widget> barScreens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];

  List<String> barName = ['New tasks', 'Done tasks', 'Archive tasks'];

  void changeBarIndex(index) {
    barIndex = index;
    emit(AppChangeBottemNavBar());
  }

  bool togelFloatingButtonIcon = true;
  IconData floatingIcon = Icons.edit;

  void changeIcon({
    required bool fb,
    required IconData fi,
  }) {
    togelFloatingButtonIcon = fb;
    floatingIcon = fi;
    emit(AppChangeFloatingIcon());
  }

  late Database database;

  void creatDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) {
// When creating the db, create the table
        print('Database created');
        db
            .execute(
                'CREATE TABLE tasksDb (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('${error.toString()} is error when creat database');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database opened');
        emit(AppGetDatabaseState());
      },
    ).then((value) {
      database = value;
    });
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO tasksDb(title, time, date, status) VALUES("$title", "$time", "$date", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
        emit(AppGetDatabaseState());
      }).catchError((error) {
        print('${error.toString()} is error when insert database');
      });
    });
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    database.rawQuery('SELECT * FROM tasksDb').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasksDb SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
      emit(AppGetDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasksDb WHERE id = ?',
      [id],
    ).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    });
  }
}
