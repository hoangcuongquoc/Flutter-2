import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {

  List todos = [];

  var box = Hive.box('myBox');

  void initData() {

    box.put('todoList', todos);
  }

  void loadData(){
    todos = box.get('todoList');
  }

  void updateData(){
    box.put('todoList', todos);
  }

}