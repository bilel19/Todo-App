import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultbutton({
  double width = double.infinity,
  Color backgroundcolor=Colors.blue,
  @required Function function,
  double radius=0,
  @required String text,
  bool isoppercase=true,
})=> Container(
   width: width,
   child:
   MaterialButton(
          onPressed: (){
            function;
       },
   child: Text(
    isoppercase ? text.toUpperCase() : text,
   style: TextStyle(color: Colors.white),
   ),
   ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
        radius,
    ),
    color: backgroundcolor,
  ),
   );

Widget defaulttextfield
({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onsubmit,
  Function onchange,
  bool isPassword=false,
  Function ontap,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressd,
  bool isenable=true,
})=>
    TextFormField(
      controller:controller,
      keyboardType: type,
      onFieldSubmitted: onsubmit,
      obscureText:isPassword,
      onChanged: onchange,
      validator: validate,
      enabled: isenable,
      onTap: ontap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
            prefix
        ),
        suffixIcon: suffix != null ? IconButton(
            onPressed:suffixPressd,
            icon: Icon(suffix)) : null,
      ),

    );

Widget buildtaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: <Widget>[
        Column(
          children: [
            Row(
              children: [

                CircleAvatar(

                  radius: 35,

                  child: Text('${model['time']}'

                    ,style: TextStyle(fontSize: 15),

                  ),

                ),

              ],

            ),

          ],

        ),

        SizedBox(width: 10,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[

              Text('${model['title']}'

                ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),

              ),

              Text('${model['date']}'

                ,style: TextStyle(fontSize: 15,color: Colors.grey),

              ),

            ],

          ),

        ),

        SizedBox(width: 10,

        ),

        IconButton(

          onPressed: ()

          {

            AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);

          },

            icon: Icon(Icons.check_circle,color: Colors.blue,),

        ),

        IconButton(

          onPressed: ()

          {

            AppCubit.get(context).updateDatabase(status: 'archive', id: model['id']);

          },

          icon: Icon(Icons.archive,color: Colors.black45,),

        ),

      ],

    ),

  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteDatabase(id: model['id']);

  },
);

 Widget TasksBuilder({
  @required List<Map> tasks
}) =>ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=>ListView.separated(
    itemBuilder: (context,index)=> buildtaskItem(tasks[index],context),
    separatorBuilder: (context,index)=> Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100,color: Colors.blue,),
        Text("No Tasks yet, Please add some tasks!",
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey),
        ),
      ],
    ),
  ),
);
