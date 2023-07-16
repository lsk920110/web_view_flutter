import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [TextButton(onPressed: () {}, child: Text('Go javascript'))],
      ),
      body: WebViewArea(),
    );
  }
}

class WebViewArea extends StatefulWidget {
  const WebViewArea({super.key});

  @override
  State<WebViewArea> createState() => _WebViewAreaState();
}

class _WebViewAreaState extends State<WebViewArea> {
  var controller = WebViewController();

  @override
  // TODO: implement context
  BuildContext get context => super.context;

  @override
  Widget build(BuildContext context) {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          var data = message.message;
          print(data);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Column(children: [Text(data)]),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        gotoJavascript(controller);
                      },
                      child: Text('확인')),
                ],
              );
            },
          );
        },
      )
      ..loadRequest(Uri.parse('http://192.168.219.189:3000'));

    return WebViewWidget(controller: controller);
  }

  void gotoJavascript(WebViewController controller) {
    controller.runJavaScript('window.fromFlutter()');
  }
}
