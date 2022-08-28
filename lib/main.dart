import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iam_flutter/requests.dart';
import 'pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'IAM',
      home: Scaffold(body: Center(child: MyLoginWidget())),
    );
  }
}

class MyLoginWidget extends StatefulWidget {
  const MyLoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyLoginWidget();
}

class _MyLoginWidget extends State<MyLoginWidget> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Log In',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 32),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: username,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ElevatedButton(
                child: const Text(
                  'Log In',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
                onPressed: () async {
                  if (username.text == '' || password.text == '') {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text(
                                'Error!',
                                textAlign: TextAlign.center,
                              ),
                              content: Text('Fields cannot be left empty!'),
                            ));

                    print('fields cannot be left empty!');
                    return;
                  }

                  // Post ../api/login and get token credentials
                  verify(username.text, password.text).then((value) {
                    if (value.statusCode == 200) {
                      ATokens.accessToken =
                          jsonDecode(value.body)['accessToken'];
                    } else {
                      throw Exception('Access token retrieve failed.');
                    }
                  });

                  if (ATokens.accessToken != '') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PagesWidget()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              title: Text(
                                'Error!',
                                textAlign: TextAlign.center,
                              ),
                              content: Text('You are not a member!'),
                            ));
                  }
                },
              ),
            )
          ],
        ));
  }
}
