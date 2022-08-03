// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytodoapp/bloc/cubit.dart';
import 'package:mytodoapp/bloc/states.dart';
import 'package:mytodoapp/shared/components.dart';


class DoneTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state){
          var tasks = AppCubit.get(context).doneTasks;

          return ListView.separated(
            itemBuilder: (context, index) => builtTaskItems(tasks[index],context),
            separatorBuilder: (context, index) =>Container(
              color: Colors.grey,
              width: double.infinity,
              height: 1,
            ),
            itemCount:tasks.length,
            physics:const BouncingScrollPhysics(),
          );
        }
    );
  }
}
