import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytodoapp/bloc/cubit.dart';

Widget defaultTextForm({
  double borderRadius = 20,
  required String lable,
  String? hint,
  required IconData prefIcon,
  required TextInputType inputKeyboard,
  required TextEditingController controller,
  Function? onsubmit,
  required FormFieldValidator<String> validate,
  bool hiddenPassword = false,
  IconData? sufixIcon,
  Function? sufixPress,
  Function? ontap,
}) =>
    TextFormField(
      onTap: () {
        ontap!();
      },
      obscureText: hiddenPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        labelText: lable,
        hintText: hint,
        suffixIcon: IconButton(
          onPressed: () {
            sufixPress!();
          },
          icon: Icon(
            sufixIcon,
          ),
        ),
        prefixIcon: Icon(
          prefIcon,
        ),
      ),
      keyboardType: inputKeyboard,
      controller: controller,
      onFieldSubmitted: (String? s) {
        onsubmit!(s!);
      },
      validator: validate,
    );

Widget builtTaskItems(Map model, context) => Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.deepPurple,
            child: Center(
              child: Text(
                '${model['time']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 200,
              height: 88,
              color: Colors.deepPurple,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${model['title']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: const Icon(Icons.check_box),
                color: Colors.green,
              ),
              SizedBox(
                width: 1.5,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: 'archive',
                    id: model['id'],
                  );
                },
                icon: const Icon(Icons.archive_rounded),
                color: Colors.black26,
              ),
              SizedBox(
                width: 1.5,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).deleteData(id: model['id']);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
