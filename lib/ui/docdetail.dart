import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_tet/flutter_masked_text.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../model/model.dart';
import '../util/utils.dart';
import '../util/dbhelper.dart';

const menuDelete="Delete";
final List<String> menuOptions=const <String>[
  menuDelete
];

class DocDetail extends StatefulWidget{
  Doc doc;
  final DbHelper dbh=DbHelper();
  DocDetail(thisdoc);
  @override 
  State<StatefulWidget> createState() => DocDetailState();

}

class DocDetailState extends State<DocDetail>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey<ScaffoldState>();

  final int daysAhead= 5475; //15 years in the future
  final TextEditingController titleCtrl=TextEditingController();
  final TextEditingController expirationCtrl=MaskedTextController(mask: '2000-00-00'); //declared as final 

  bool fqYearCtrl=true;
  bool fqHalfYearCtrl=true;
  bool fqQuarterCtrl=true;
  bool fqMonthCtrl=true;
  bool fqLessMonthCtrl=true;

  //Initialization Code
  void _initCtrls(){
    titleCtrl.text=widget.doc.title != null ? widget.doc.title: "";
    expirationCtrl.text=widget.doc.expiration != null ? widget.doc.expiration: "";
    fqYearCtrl=widget.doc.fqYear != null ? Val.IntToBool(widget.doc.fqYear): false;
    fqHalfYearCtrl=widget.doc.fqHalfYear != null ? Val.IntToBool(widget.doc.fqHalfYear): false;
    fqQuarterCtrl=widget.doc.fqQuarter != null ? Val.IntToBool(widget.doc.fqQuarter): false;
    fqMonthCtrl=widget.doc.fqMonth != null ? Val.IntToBool(widget.doc.fqMonth): false;
  }

  Future _chooseDate(BuildContext context, String initialDateString) async{
    var now=new DateTime.now();
    var initialDate=DateUtils.convertToDate(initialDateString) ?? now;
    initialDate=(initialDate.year >= now.year && initialDate.isAfter(now) ? initialDate : now);

    DatePicker.showDatePicker(context, showTitleActions: true, onConfirm:(date){
      setState((){
        DateTime dt=date;
        String r=DateUtils.ftDateAsStr(dt);
        expirationCtrl.text=r;
      });
    },
    currentTime: initialDate);
  }
  //Upper Menu

  void _selectMenu(String value) async{
    switch (value){
      case menuDelete:
      if (widget.doc.id ==-1){
        return;
      }
      await _deleteDoc(widget.doc.id);

    }
  }

  //Delete Doc
  void _deleteDoc(int id) async{
    int r=await widget.dbh.deleteDoc(widget.doc.id);
    Navigator.pop(context,true);
  }

  //save a doc
  void _saveDoc(){
    widget.doc.title=titleCtrl.text;
    widget.doc.expiration=expirationCtrl.text;

    widget.doc.fqYear=Val.BoolToInt(fqYearCtrl);
    widget.doc.fqHalfYear=Val.BoolToInt(fqHalfYearCtrl);
    widget.doc.fqQuarter=Val.BoolToInt(fqQuarterCtrl);
    widget.doc.fqMonth=Val.BoolToInt(fqMonthCtrl);

    if (widget.doc.id > -1){  //we are modifing an exiting document
      debugPrint("_update->Doc Id: "+ widget.doc.id.toString());
      widget.dbh.updateDoc(widget.doc);
      Navigator.pop(context, true);
    }
    else{ //we are saving a new document
      Future<int> idd=widget.dbh.getMaxId();
      idd.then((result){
        debugPrint("_insert->Doc Id:"+ widget.doc.id.toString());
        widget.doc.id=(result != null) ? result + 1: 1;
        widget.dbh.insertDoc(widget.doc);
        Navigator.pop(context,true);
      });
    }
  }

  //submit form
  void _submitForm(){
    final FormState form = _formKey.currentState; //get the current state of the firm
    if(!form.validate()){
      showMessage('Some data is invalid.Please correct');

    }else{
      _saveDoc();
    }
  }

  void showMessage(String message,[MaterialColor color=Colors.red]){
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color,content: new Text(message)));
  }
  
}

