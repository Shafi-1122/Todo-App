// ignore_for_file: prefer_const_constructors

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
  List<String> list = [];
  List<bool> blist = [];
  List<String> option = [];
  bool value1 = false;

  void storeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('task', list);
  }

  void storeBoolData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('opt', option);
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    List w = [];
    if (prefs.getStringList('task') != null) {
      list = prefs.getStringList('task') ?? prefs.getStringList('task')!;
      w = prefs.getStringList('opt') ?? prefs.getStringList('opt')!;
    }
    for (int i = 0; i < w.length; i++) {
      if (w[i] == 'no') {
        blist.add(false);
      } else {
        blist.add(true);
      }
    }
    setState(() {});
  }

  void getBooldata() async {
    final prefs = await SharedPreferences.getInstance();
    option = prefs.getStringList('opt')!;
  }

  removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('task');
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("TODO APP"),
        leading: IconButton(
            onPressed: () {
              removeData();
              setState(() {});
            },
            icon: Icon(Icons.chevron_left)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          // height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            // ignore: prefer_const_literals_to_create_immutables
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Work',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "3",
                style: TextStyle(fontSize: 20),
              )
            ]),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: ListView.builder(
                  itemCount: list.length,

                  /// physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: blist[index],
                        title: Text(list[index]),
                        onChanged: (value) {
                          if (value!) {
                            option.add('yes');
                          } else {
                            option.add('no');
                          }

                          storeBoolData();
                          setState(() {
                            blist[index] = !blist[index];
                            
                          });
                        });
                  }),
            ),
          ]),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                        content: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(7)),
                              hintText: "Enter your work here"),
                          controller: editingController,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              setState(() {
                                editingController.clear();
                              });
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.red,
                                elevation: 2,
                                backgroundColor: Colors.amber),
                            child: Text('OK'),
                            onPressed: () {
                              setState(() {
                                if (editingController.text.isNotEmpty) {
                                  list.add(editingController.text);
                                  storeData();
                                  blist.add(false);

                                  storeBoolData();
                                  print(list);
                                }

                                editingController.clear();
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ]));
          },
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
