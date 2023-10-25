import "package:alpine_flutter/view/work.dart";
import "package:alpine_flutter/widget/form.dart";
import "package:flutter/material.dart";
import "package:nanoid/nanoid.dart";

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Work Management",
      home: const Home(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Key _key = Key(nanoid());

  @override
  Widget build(BuildContext context) {
    onChange() => setState(() => _key = Key(nanoid()));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Work Management",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            key: _key,
            children: [
              Work(
                status: 'todo',
                bgColor: Colors.grey,
                fgColor: Colors.white,
                onChange: onChange,
              ),
              Work(
                status: 'doing',
                bgColor: Colors.cyan,
                fgColor: Colors.white,
                onChange: onChange,
              ),
              Work(
                status: 'done',
                bgColor: Colors.green,
                fgColor: Colors.white,
                onChange: onChange,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog(onChange);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future openDialog(Function? postSubmit) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Todo"),
        content: SingleChildScrollView(
          child: WorkForm(
            postSubmit: () {
              if (postSubmit != null) postSubmit();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
