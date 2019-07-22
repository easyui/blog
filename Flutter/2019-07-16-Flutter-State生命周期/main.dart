import 'package:flutter/material.dart';
import 'NewRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      // home: Text('delete MyHomePage',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
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
    print('build');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return new NewRoute(title: 'New Page');
                }));
              },
              child: Text("push"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _MyHomePageState() {
    print('constructor');
  }

  @override
  void initState() {
    print('initState');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("addPostFrameCallback");
    });
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    print('reassemble');
    super.reassemble();
  }

  @override
  void deactivate() {
    print('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///生命周期变化时回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState : ' + state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        // print('AppLifecycleState.inactive'); //用户可见，但不可响应用户操作
        break;
      case AppLifecycleState.paused:
        // print('AppLifecycleState.paused'); // 已经暂停了，用户不可见、不可操作
        break;
      case AppLifecycleState.resumed:
        // print('AppLifecycleState.resumed'); //应用可见并可响应用户操作
        break;
      case AppLifecycleState.suspending:
        // print('AppLifecycleState.suspending'); //应用被挂起，此状态iOS永远不会回调
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  ///低内存回调
  @override
  void didHaveMemoryPressure() {
    print("didHaveMemoryPressure");
    super.didHaveMemoryPressure();
  }

  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Size size = WidgetsBinding.instance.window.physicalSize;
    print("didHaveMemoryPressure  ：宽：${size.width} 高：${size.height}");
  }
}
