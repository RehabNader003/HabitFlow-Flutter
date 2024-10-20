import 'package:flutter/material.dart';
import 'CompletedTask.dart';
import 'TaskItem.dart';

 class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}
class _TodayState extends State<Today> {
  List<QueryDocumentSnapshot> data=[];
  getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("daily").get();
    data.addAll(querySnapshot.docs);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
@override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        for (var task in data)
          TaskItem(
            icon: Icons.track_changes,
            TaskName: task['task_name'], // Task title from Firestore
            TaskColor: Color(task['color']), // Task color from Firestore (saved as int)
          ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Completed'),
            SizedBox(width: 10),
            Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // CompletedTask(
        //   TaskName: 'Sleep Over 8h',
        //   TaskColor: Colors.blueAccent,
        // ),
        // CompletedTask(
        //   TaskName: 'Playing Games',
        //   TaskColor: Colors.pinkAccent,
        // ),
        // CompletedTask(
        //   TaskName: 'Exercise or Workout',
        //   TaskColor: Colors.greenAccent,
        // ),
      ],
    );
  }
}
