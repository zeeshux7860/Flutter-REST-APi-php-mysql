import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
void main(){
 runApp(new MaterialApp(
   home: PhpmySql(),
   debugShowCheckedModeBanner: false,
 ));
}
class PhpmySql extends StatefulWidget {
  @override
  _PhpmySqlState createState() => _PhpmySqlState();
}

class _PhpmySqlState extends State<PhpmySql> {
 final GlobalKey<ScaffoldState> _scaf = new GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController();
  TextEditingController book = TextEditingController();
  TextEditingController searchname = TextEditingController();
File image;
var random = Random();

  void uploadimg() async{
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));

    var length = await image.length();

    var uri = Uri.parse('http://192.168.137.1/ctechviral/imgupload.php');

    var resquest = http.MultipartRequest('POST', uri);
    var multipartfile = new http.MultipartFile('image', stream, length,filename: basename(image.path));
    resquest.files.add(multipartfile);

    var response = await resquest.send();

    if(response.statusCode == 200){
      _scaf.currentState.showSnackBar(new SnackBar(content: new Text("image uploaded"),));
      setState(() {
              image = null;
            });
    }else{
  _scaf.currentState.showSnackBar(new SnackBar(content: new Text("image not uploaded"),));
    }
    
  }



  Future<List> refresh() async{
   
    done();
     await Future.delayed(new Duration(seconds: 2));
    var url = "http://192.168.137.1/ctechviral/getdata.php";

    final response = await http.get(url);
    if(response.statusCode == 200){
      print("object");
    }else{
      print("f");
    }
    return json.decode(response.body);
  }
  void done(){
    setState(() {
          
        });
  }
  void datasend(){
      var url = "http://192.168.137.1/ctechviral/insert.php";
    var res = http.post(url,body: {
      'username' : username.text,
      'book' : book.text
    }).then((hojae){
     username.clear();
     book.clear();
     
   _scaf.currentState.showSnackBar(new SnackBar(content: new Text("Successfully Added"),));
    }).catchError((nahoto){
       _scaf.currentState.showSnackBar(new SnackBar(content: new Text("Something went to wrong"),));
    });
    
  }
  void dataupdate(String id){
      var url = "http://192.168.137.1/ctechviral/update.php";
    var res = http.post(url,body: {
      'id' : id,
      'username' : username.text,
      'book' : book.text
    }).then((hojae){
     username.clear();
     book.clear();
     
   _scaf.currentState.showSnackBar(new SnackBar(content: new Text("Successfully Updated"),));
    }).catchError((nahoto){
       _scaf.currentState.showSnackBar(new SnackBar(content: new Text("Something went to wrong"),));
    });
    
  }
  void search(context){
   showDialog(
     context: context,
     barrierDismissible: false,
    builder: (context)=> new AlertDialog(
      title: new Text("Search"),
      content: new SingleChildScrollView(
        child: Form(

          child: new Column(
          children: <Widget>[
           new TextFormField(
             controller: searchname,
             decoration: InputDecoration(
               labelText: 'Search now',
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10.0),
                 borderSide: BorderSide(width: 10.0),
               )
            ),
             
           ),
           
          
          ],
        ),
      ),
      ),
       actions: <Widget>[
           new FlatButton(
           child: new Text("No Save"),
           onPressed: (){
             Navigator.pop(context);
           },
         ),
         new FlatButton(
           child: new Text("Yes Save"),
           onPressed: (){
             Navigator.push(context, new MaterialPageRoute(builder: (context)=>Search(name: searchname.text,)));
           },
         ),
        
       ],
     )
   );
  }
  void update(context,String usernamess,String booknamess,String id){
   showDialog(
     context: context,
     barrierDismissible: false,
    builder: (context)=> new AlertDialog(
      title: new Text("Update books"),
      content: new SingleChildScrollView(
        child: Form(

          child: new Column(
          children: <Widget>[
           new TextFormField(
             controller: username,
             decoration: InputDecoration(
               labelText: '$usernamess',
               
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10.0),
                 borderSide: BorderSide(width: 10.0),
               )
            ),
             
           ),
           new SizedBox(
             height: 10.0,
           ),
            new TextFormField(
              controller: book,
             decoration: InputDecoration(
               labelText: '$booknamess',
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10.0),
                 borderSide: BorderSide(width: 10.0),
               )
            ),
             
           ),
          ],
        ),
      ),
      ),
       actions: <Widget>[
         new FlatButton(
           child: new Text("Yes Save"),
           onPressed: (){
             dataupdate(id);
           },
         ),
          new FlatButton(
           child: new Text("No Save"),
           onPressed: (){
             Navigator.pop(context);
           },
         ),
       ],
     )
   );
  }
  void insert(context){
   showDialog(
     context: context,
     barrierDismissible: false,
    builder: (context)=> new AlertDialog(
      title: new Text("Add books"),
      content: new SingleChildScrollView(
        child: Form(

          child: new Column(
          children: <Widget>[
           new TextFormField(
             controller: username,
             decoration: InputDecoration(
               labelText: 'Enter Username',
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10.0),
                 borderSide: BorderSide(width: 10.0),
               )
            ),
             
           ),
           new SizedBox(
             height: 10.0,
           ),
            new TextFormField(
              controller: book,
             decoration: InputDecoration(
               labelText: 'Enter Book name',
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10.0),
                 borderSide: BorderSide(width: 10.0),
               )
            ),
             
           ),
          ],
        ),
      ),
      ),
       actions: <Widget>[
         new FlatButton(
           child: new Text("Yes Save"),
           onPressed: datasend,
         ),
          new FlatButton(
           child: new Text("No Save"),
           onPressed: (){
             Navigator.pop(context);
           },
         ),
       ],
     )
   );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaf,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          String imgname = "defalut.jpg";
          var img = await ImagePicker.pickImage(source: ImageSource.gallery);

     final tempDir = await getTemporaryDirectory();

    final path = tempDir.path;
     setState(() {
       var gen = random.nextInt(1000000000);
         imgname = gen.toString();
        });
     Img.Image imgs = Img.decodeImage(img.readAsBytesSync());
    Img.Image smallerimg = Img.copyResize(imgs, 500);

    var compressimg = new File("$path/$imgname.jpg")..writeAsBytesSync(Img.encodeJpg(smallerimg,quality: 85));
    print(compressimg.toString());
    setState(() {
      image = compressimg;
    });

uploadimg();
        },
        child: new Icon(Icons.file_upload),
      ),
      appBar: new AppBar(
        title: new Text("Php sql"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              insert(context);
            },
          ),
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              search(context);
            },
          )
        ],
      ),
      body: new RefreshIndicator(
        onRefresh: refresh,
        child: new FutureBuilder(
          future: refresh(),
          builder: (context,snap){
            
            if(!snap.hasData)
            return new Center(
              child: new CircularProgressIndicator(),
            );
            return new ListView.builder(
             itemCount: snap.data.length,
             itemBuilder: (context,l)=>
             new ListTile(
               onTap: (){
                 update(context,snap.data[l]['username'],snap.data[l]['bookname'],snap.data[l]['id']);
               },
               leading: new CircleAvatar(
                 backgroundColor: Colors.blueGrey,
                 backgroundImage: new NetworkImage("http://192.168.137.1/ctechviral/img/"+snap.data[l]['Picture']),
               ),
               onLongPress: (){
                  var url = "http://192.168.137.1/ctechviral/delete.php?id="+snap.data[l]['id'];
                  var res = http.get(url).then((done){
                  _scaf.currentState.showSnackBar(new SnackBar(content: new Text("Successfully deeleted" +snap.data[l]['id'] ),));
                  }).catchError((err){
                    _scaf.currentState.showSnackBar(new SnackBar(content: new Text("Failed deeleted"),));
                  });
                 },
               title: new Text(snap.data[l]['username']),
               subtitle: new Text(snap.data[l]['bookname']),
               trailing: new Text(snap.data[l]['date']),
             ),
            );

          },
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  final name;
  Search({this.name});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
   Future<List> refresh() async{
   
    done();
     await Future.delayed(new Duration(seconds: 2));
    var url = "http://192.168.137.1/ctechviral/search.php?search="+widget.name;
    final response = await http.get(url);
    return json.decode(response.body);
  }
  void done(){
    setState(() {
          
        });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    appBar: new AppBar(
    title: new Text("search " + widget.name),
    ),
    body: new FutureBuilder(
          future: refresh(),
          builder: (context,snap){
           print(snap.data.length);
            if(!snap.hasData)
            return new Center(
              child: new CircularProgressIndicator(),
            );
           return  snap.data.length == 0 ?
              new Center(child: new Text("Opps not found"),)
             : 
             new ListView.builder(
             itemCount: snap.data.length,
             itemBuilder: (context,l)=>
             new ListTile(
               title: new Text(snap.data[l]['username']),
               subtitle: new Text(snap.data[l]['bookname']),
               trailing: new Text(snap.data[l]['date']),
             ),
            );
             
           

          },
        ),
    );
  }
}