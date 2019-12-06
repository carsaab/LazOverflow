import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:snackingaz/questions_page.dart';
import "home_page.dart";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Demo",
        theme: new ThemeData(
            primarySwatch: Colors.blue
        ),
        home: new LoginPage()
    );
  }
}

enum FormType {
  login,
  register
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          moveToHome();
        } else {
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          moveToHome();
        }
      } catch (error) {
        debugPrint(error);
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToHome() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuestionsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text("LAZ Overflow"),
        ),
        body: new Container(
            padding: EdgeInsets.all(10.0),
            child: new Form(
                key: formKey,
                child: new Column(
                    children: buildInputs() + buildSubmitButtons()
                )
            )
        )
    );
  }

  String checkEmail(emailField) {
    if (emailField.isEmpty) {
      return "Email field cannot be empty";
    }
    return null;
  }

  void saveEmail(email) {
    _email = email;
  }

  String checkPassword(emailField) {
    if (emailField.isEmpty) {
      return "Password field cannot be empty";
    }
    return null;
  }

  void savePassword(password) {
    _password = password;
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
          decoration: new InputDecoration(
              labelText: "Email",
              fillColor: Colors.white,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.0))),
          validator: checkEmail,
          onSaved: saveEmail
      ),
      new Padding(padding: new EdgeInsets.only(top: 10.0)),
      new TextFormField(
          decoration: new InputDecoration(
              labelText: "Password",
              fillColor: Colors.white,
              border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(15.0))),
          obscureText: true,
          validator: checkPassword,
          onSaved: savePassword
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return loginButtons();
    } else {
      return registerButtons();
    }
  }

  List<Widget> loginButtons() {
    return [
      new RaisedButton(
          child: new Text("Login"),
          onPressed: validateAndSubmit
      ),
      new FlatButton(
          child: new Text("Create an account"),
          onPressed: moveToRegister
      )
    ];
  }

  List<Widget> registerButtons() {
    return [
      new RaisedButton(
          child: new Text("Create an account"),
          onPressed: validateAndSubmit
      ),
      new FlatButton(
          child: new Text("Have an account? Login"),
          onPressed: moveToLogin
      )
    ];
  }
}