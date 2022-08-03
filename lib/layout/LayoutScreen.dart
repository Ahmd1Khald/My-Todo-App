import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytodoapp/bloc/cubit.dart';
import 'package:mytodoapp/bloc/states.dart';
import 'package:mytodoapp/shared/components.dart';

class LayoutScreen extends StatelessWidget {

  @override

  var scafoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formValidate=GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              title: Text(AppCubit.get(context)
                  .barName[AppCubit.get(context).barIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(AppCubit.get(context).togelFloatingButtonIcon) {
                  scafoldKey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.deepPurpleAccent[100],
                            child: Form(
                              key: formValidate,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10,),
                                  //Title
                                  defaultTextForm(
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Title must be not empty';
                                      }
                                      return null;
                                    },
                                    lable: 'Task Title',
                                    ontap: () {},
                                    onsubmit:(s){} ,
                                    inputKeyboard: TextInputType.emailAddress,
                                    prefIcon: Icons.title,
                                    controller: titleController,
                                  ),
                                  const SizedBox(height: 10,),

                                  //Time
                                  defaultTextForm(
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Time must be not empty';
                                      }
                                      return null;
                                    },
                                    lable: 'Task Time',
                                    inputKeyboard: TextInputType.emailAddress,
                                    prefIcon: Icons.watch_later_sharp,
                                    controller: timeController,
                                    onsubmit:(s){} ,
                                    ontap: (){
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text=value!.format(context);
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10,),

                                  //Date
                                  defaultTextForm(
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must be not empty';
                                      }
                                      return null;
                                    },
                                    lable: 'Task Date',
                                    inputKeyboard: TextInputType.emailAddress,
                                    prefIcon: Icons.date_range,
                                    controller: dateController,
                                      onsubmit:(s){} ,
                                    ontap: (){
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse("2025-08-29"),
                                      ).then((value) {
                                        dateController.text =DateFormat.yMMMd().format(value!);
                                      });
                                    }
                                  ),
                                  const SizedBox(height: 10,),
                                ],
                              ),
                            )
                        ),
                  ).closed.then((value)=>AppCubit.get(context).changeIcon(fb:true, fi: Icons.edit));
                  AppCubit.get(context).changeIcon(
                    fb:false, fi:Icons.add,
                  );
                }
                else{
                  if(formValidate.currentState!.validate())
                  {
                    AppCubit.get(context).changeIcon(
                      fb:true, fi:Icons.edit,
                    );
                    AppCubit.get(context).insertDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }


                }
              },
              child: Icon(AppCubit.get(context).floatingIcon),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.deepPurple,
              items:  <Widget>[
                Icon(
                  Icons.menu,
                  size: 25,
                  semanticLabel: 'New Tasks',
                  color: Colors.deepPurple,
                ),
                Icon(
                  Icons.check_circle_outline,
                  size: 25,
                  semanticLabel: 'Done Tasks',
                  color: Colors.deepPurple,
                ),
                Icon(
                  Icons.archive_outlined,
                  size: 25,
                  semanticLabel: 'Archive Tasks',
                  color: Colors.deepPurple,
                ),
              ],
              onTap: (index) {
                AppCubit.get(context).changeBarIndex(index);
              },
            ),
            body: AppCubit.get(context)
                .barScreens[AppCubit.get(context).barIndex],
          );
        },
      ),
    );
  }
}
/*

    */
