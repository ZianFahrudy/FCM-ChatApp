import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading, {
    Key key,
  }) : super(key: key);

  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
  ) submitFn;

  bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";

  bool _isLogin = true;

  void submitFn() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();

      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword,
        _isLogin,
      );

      // send field value to firebase
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (v) {
                      _userEmail = v;
                    },
                    validator: (v) {
                      if (v.isEmpty || !v.contains("@")) {
                        return "Please enter the valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      onSaved: (v) {
                        _userName = v;
                      },
                      validator: (v) {
                        if (v.isEmpty || v.length < 4) {
                          return "Username must be 4 character";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                  TextFormField(
                    onSaved: (v) {
                      _userPassword = v;
                    },
                    validator: (v) {
                      if (v.isEmpty || v.length < 6) {
                        return "Password must be 6 character";
                      }

                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                        child: Text(_isLogin ? "Login" : "Sign Up"),
                        onPressed: submitFn),
                  SizedBox(
                    height: 20,
                  ),
                  if (!widget.isLoading)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Create new account"
                            : "I already have an account",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
