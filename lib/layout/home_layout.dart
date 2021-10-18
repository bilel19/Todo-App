
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/compoments/compomants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

//create database
//create table
//open database
//insert into databse
//get from database
//updete in database
//delete from database

class HomeLayout extends StatelessWidget
{


  var scaffoldkey= GlobalKey<ScaffoldState>();
  var formkey= GlobalKey<FormState>();
  var titlecontroller=TextEditingController();
  var timecontroller=TextEditingController();
  var datecontroller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..createdatabase(),
      child: BlocConsumer<AppCubit,AppStates>
        (
        listener: (BuildContext context,AppStates state){
          if(state is AppInsertIntoDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates state)
        {
          AppCubit cubit= AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentindex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataFromLoadingDatabaseState,
              builder: (context)=> cubit.screens[cubit.currentindex],
              fallback:(context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:()
              {
                if(cubit.isbuttomsheetshown)
                {
                  if(formkey.currentState.validate())
                  {
                    cubit.insertdatabase(
                        title: titlecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text
                    );

                    /*insertdatabase(
                      title: titlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text,
                    ).then((value){
                      getDataFromDataBase(database).then((value){
                        Navigator.pop(context);
                        *//*setState(() {
                      isbuttomsheetshown=false;
                      sheeticon=Icons.edit;
                      tasks=value;
                    });*//*
                      });
                    });*/
                  }
                }else
                {
                  scaffoldkey.currentState.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formkey,
                            child: Column
                              (
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>
                              [
                                defaulttextfield(
                                  controller: titlecontroller,
                                  type: TextInputType.text,
                                  validate: (String value)
                                  {
                                    if(value.isEmpty){
                                      return 'title must be not empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(height: 15,),
                                defaulttextfield(
                                  controller: timecontroller,
                                  type: TextInputType.datetime,
                                  ontap:()
                                  {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value){
                                      timecontroller.text=value.format(context).toString();
                                    });
                                  } ,
                                  validate: (String value)
                                  {
                                    if(value.isEmpty){
                                      return 'time must be not empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task time',
                                  prefix: Icons.watch_later,
                                ),
                                SizedBox(height: 15,),
                                defaulttextfield(
                                  controller: datecontroller,
                                  type: TextInputType.datetime,
                                  ontap:()
                                  {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.parse('2020-05-07'),
                                      lastDate: DateTime.parse('2022-05-07'),
                                    ).then((value){
                                      datecontroller.text=DateFormat().add_yMMMd().format(value);
                                    });
                                  } ,
                                  validate: (String value)
                                  {
                                    if(value.isEmpty){
                                      return 'date must be not empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],

                            ),
                          ),
                        ),
                    elevation: 20,
                  ).closed.then((value){
                    cubit.changeBottomSheetState(isshow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isshow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.sheeticon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentindex,
                onTap: (index)
                {
                  cubit.changeindex(index);
                },
                items:
                [
                  BottomNavigationBarItem(
                    icon:Icon(Icons.menu),
                    title: Text('Tasks'),
                  ),
                  BottomNavigationBarItem(
                    icon:Icon(Icons.check_circle_outline),
                    title: Text('Done'),
                  ),
                  BottomNavigationBarItem(
                    icon:Icon(Icons.archive),
                    title: Text('Archived'),
                  ),
                ]
            ),

          );
        },
      ),
    );
  }


  //Future<String> getName() async
  //{
  //return 'bilel kasdi';
  //}


}

