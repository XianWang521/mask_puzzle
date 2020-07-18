import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      theme: new ThemeData(
        primaryColor: Colors.grey,
      ),
      home: Encode(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Encode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Encode();
}

class _Encode extends State<Encode> {
  //手机号的控制器
  TextEditingController inputController = TextEditingController();
  static List key = ['a','b','c','d','e','f','g','h','i','j','k','l','m',
                    'n','o','p','q','r','s','t','u','v','w','x','y','z',
                    'A','B','C','D','E','F','G','H','I','J','K','L','M',
                    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
                    '0','1','2','3','4','5','6','7','8','9','\n',
                    ',','?','!','@','#','\$','%','.','\\','*','(',')','-','_','+','=','[',']'];
  String resultText="";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: new Stack(
          children: [
            new SingleChildScrollView(
              child: new Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text(
                      "Secure Message",
                      style: new TextStyle(color: Colors.blue
                          .withOpacity(0.8),fontSize: 25, fontWeight: FontWeight.w800),
                    ),
                    new SizedBox(
                      height: 70,
                    ),
                    new TextField(
                      controller: inputController,
                      keyboardType: TextInputType.multiline,
                      maxLines:null,
                      autocorrect: false,
                      decoration: new InputDecoration(
                        labelText: "Plaintext/Ciphertext"
                      ),
                    ),
                    new SizedBox(
                      height: 30,
                    ),
                    new Row(
                      children: <Widget>[
                        SizedBox(width: 20,),
                        new RaisedButton(
                          child: new Text("Encode",
                              style: new TextStyle(color: Colors.white)),
                          color: Colors.blue,
                          elevation: 15.0,
                          shape: StadiumBorder(),
                          splashColor: Colors.white54,
                          onPressed: () {
                            setState(() {
                              try {
                                this.resultText = encrypt(inputController.text);
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return CupertinoAlertDialog(
                                      title: Text("Wrong Type"),
                                    );
                                  },
                                );
                              }
                            });
                          },
                        ),
                        SizedBox(width: width/3,),
                        new RaisedButton(
                          child: new Text("Decode",
                              style: new TextStyle(color: Colors.white)),
                          color: Colors.blue,
                          elevation: 15.0,
                          shape: StadiumBorder(),
                          splashColor: Colors.white54,
                          onPressed: () {
                            setState(() {
                              try {
                                this.resultText = decrypt(inputController.text);
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (context){
                                    return CupertinoAlertDialog(
                                      title: Text("Wrong Type"),
                                    );
                                  },
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    new SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      child: Text(this.resultText),
                      onLongPress: (){
                        ClipboardData data = new ClipboardData(text: this.resultText);
                        Clipboard.setData(data);
                        showDialog(
                          context: context,
                          builder: (context){
                            return CupertinoAlertDialog(
                              title: Text("Copy successfully"),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  String encrypt(String text)
  {
    String encryptText = "";
    var lines = text.split('\n');

    for(int i = 0; i < lines.length; i++){
      var words = lines[i].split(' ');
      for(int j = 0; j < words.length; j++){
        for(int k = 0; k < words[j].length; k++){
          if(k == 0) encryptText += "(";
          encryptText += key.indexOf(words[j][k]).toString();
          if(k == words[j].length-1) encryptText += ")";
          else encryptText += ".";
        }
        if(j < words.length-1 && words[j+1] != "") encryptText += ",";
      }
      if(i!=lines.length-1) encryptText+="\n";
    }
    return encryptText;
  }

  String decrypt(String text){
    String decryptText="";
    var lines = text.split('\n');

    for(int i = 0; i < lines.length; i++){
      var words = lines[i].split(',');
      for(int j = 0; j < words.length; j++){
        words[j] = words[j].replaceAll('(', '').replaceAll(')', '');

        var temp = words[j].split('.');
        for(int k = 0; k < temp.length; k++){
          decryptText += key[int.parse(temp[k])];
        }
        decryptText += " ";
      }
      if(i != lines.length-1) decryptText+="\n";
    }
    return decryptText;
  }
}