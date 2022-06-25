import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_furans/screens/widgets.dart';

import '../database_helper.dart';
import '../models/task.dart';
import '../models/todo.dart';

class Taskpage extends StatefulWidget {
  final Task? task;
  Taskpage({this.task});

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper =
      DatabaseHelper(); //menyimpan data kalau judul yang dimasukkan berisi value.
  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task!.title!;
      _taskId = widget.task!.id!;
      _taskDescription = widget.task!.description!;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                'assets/images/back_arrow_icon.png',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            autocorrect: false,
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              if (value != "") {
                                //Mengecek apakah task kosong.
                                if (widget.task == null) {
                                  //Mengecek apakah judul yang dimasukan kosong atau tidak.

                                  Task _newTask = Task(
                                    title: value,
                                  ); //membuat instance task

                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              hintText: "Masukan Judul...",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF9F9F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        autocorrect: false,
                        onSubmitted: (value) {
                          if (value != "") {
                            if (_taskId != 0) {
                              _dbHelper.updateTaskDescription(_taskId, value);
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Masukan Deskripsi...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data![index].isDone == 0) {
                                    await _dbHelper.updateTodoChecklist(
                                        snapshot.data![index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoChecklist(
                                        snapshot.data![index].id, 0);
                                  }
                                  setState(() {});
                                  //Biar tercentang..
                                },
                                child: TodoWidget(
                                  text: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Color(0xFF86829D),
                                width: 1.5,
                              ),
                            ),
                            child: Image(
                              image: AssetImage(
                                'assets/images/check_icon.png',
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              autocorrect: false,
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (widget.task != null) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: widget.task!.id,
                                    );
                                    await _dbHelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                  } else {
                                    print("muncul kalau gamau");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Masukan Todo's...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 242, 58, 58),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image(
                        image: AssetImage(
                          'assets/images/delete_icon.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
