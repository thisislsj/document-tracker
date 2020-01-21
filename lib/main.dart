import 'package:flutter/material.dart'; //import material design libarary
import './ui/doclist.dart'; //logic for creating and displaying the list of documents

void main()=>runApp(DocTrackerApp());

class DocTrackerApp extends StatelessWidget{ //widgrt without a state
  @override  //overriding the build class inherited from stateless widget class
  Widget build(BuildContext context){
    return MaterialApp(  
      debugShowCheckedModeBanner: false, //shows a debug flag on the corner of the screen
      title: 'DocTrackerApp',
      theme: new ThemeData(  
        primarySwatch: Colors.indigo, //main color used for the app
      ),
      home: DocList(), //the home property is assigned to the DocList method
    );
  }
}