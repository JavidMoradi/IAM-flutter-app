import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iam_flutter/requests.dart';

class Pages extends StatelessWidget {
  const Pages({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'pages',
      home: Scaffold(
        body: Center(
          child: PagesWidget(),
        ),
      ),
    );
  }
}

class PagesWidget extends StatefulWidget {
  const PagesWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PagesWidget();
}

class _PagesWidget extends State<PagesWidget> {
  var pages = [];

  @override
  Widget build(BuildContext context) {
    getPages().then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {
        pages = jsonDecode(value.body);

        print(pages);
      } else {
        throw Exception('Failed to retrieve pages.');
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(pages.length, (index) {
        return Column(
          children: [
            Text(
              pages[index]['name'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            Column(
              children: List.generate(pages[index]['pageMethods'].length, (i) {
                return ElevatedButton(
                    onPressed: () {
                      getMethod(pages[index]['pageMethods'][i]['id'])
                          .then((value) {
                        if (value.statusCode == 200) {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    title: Text(
                                      'Success!',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                        'You have permission for this method!'),
                                  ));

                          print('You have permission for this method!');
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    title: Text(
                                      'Error!',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                        'You don\'t have permission for this method!'),
                                  ));

                          throw Exception(
                              'You don\'t have permission for this method!');
                        }
                      });
                    },
                    child: Text(pages[index]['pageMethods'][i]['name']));
              }),
            )
          ],
        );
        // Text(pages[index]['name']);
      }),
    );
  }
}
