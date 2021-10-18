import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() :super(AppInitialStates());

    //create an object from this class appcubit
  static AppCubit get(context)=> BlocProvider.of(context);

  int currentindex=0;

  List<Widget> screens=
  [
    Newtasks(),
    donetasks(),
    archivedtasks(),
  ];
  List<String> titles=
  [
    "New tasks",
    "Done tasks",
    "Archived tasks",
  ];

  bool isbuttomsheetshown=false;
  IconData sheeticon=Icons.edit;
  Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  void changeindex(int index){
    currentindex=index;
    emit(AppChangeBottomNavState());
  }

  void createdatabase()
  {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version)
        {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRiMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value){
            print('table created');
          }).catchError((error){
            print('error when creating database ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          getDataFromDataBase(database);
          print('database opened');
        }
    ).then((value){
       database=value;
       emit(AppCreateDatabaseState());
     });
  }

  insertdatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async
  {
    database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks (title,date,time,status) VALUES("$title","$date","$time","good")'
      ).then((value){
        print('${value} inserted successfully');
        emit(AppInsertIntoDatabaseState());

        getDataFromDataBase(database);
      }).catchError((error){
        print('error when inserting new record ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDataFromLoadingDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then((value){

      value.forEach((element)
      {
        if(element['status']=='good')
          newTasks.add(element);
        else if(element['status']=='done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataFromDatabaseState());
    });
  }

  void updateDatabase({
    @required String status,
    @required int id
  })
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value)
    {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDatabase({
    @required int id
  })
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({
  @required bool isshow,
    @required IconData icon,
}){
    isbuttomsheetshown=isshow;
    sheeticon=icon;
    emit(AppChangeBottomState());
  }
}