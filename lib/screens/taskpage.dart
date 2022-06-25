import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_furans/screens/widgets.dart';

import '../database_helper.dart';
import '../models/task.dart';

class Taskpage extends StatefulWidget {
  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
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
                            onSubmitted: (value) async {
                              if (value != "") {
                                //Mengecek apakah judul yang dimasukan kosong atau tidak.
                                DatabaseHelper _dbHelper =
                                    DatabaseHelper(); //menyimpan data kalau judul yang dimasukkan berisi value.

                                Task _newTask = Task(
                                  title: value,
                                ); //membuat instance task

                                await _dbHelper.insertTask(_newTask);
                              }
                            },
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
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Masukan Deskripsi...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          )),
                    ),
                  ),
                  TodoWidget(
                    text: "Mengerjakan UAS Pemrograman Mobile sampai mati.",
                    isDone: false,
                  ),
                  TodoWidget(
                    text: "Menyiapkan presentasi UAS Pemrograman Mobile.",
                    isDone: false,
                  ),
                  TodoWidget(
                    isDone: true,
                  ),
                  TodoWidget(
                    isDone: false,
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Taskpage()),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}
