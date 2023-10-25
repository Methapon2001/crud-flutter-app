import "package:alpine_flutter/widget/form.dart";
import "package:flutter/material.dart";
import "package:alpine_flutter/api.dart";
import 'package:intl/intl.dart';

class Work extends StatefulWidget {
  final String status;
  final Color? bgColor;
  final Color? fgColor;
  final Function? onChange;

  const Work({
    super.key,
    required this.status,
    this.bgColor,
    this.fgColor,
    this.onChange,
  });

  @override
  State<Work> createState() => _WorkState();
}

class _WorkState extends State<Work> {
  late Future<List<Map<String, dynamic>>> _data;
  @override
  void initState() {
    super.initState();

    _data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _data,
      builder: (context, snapshot) {
        final value = snapshot.data != null
            ? snapshot.data!
                .where((element) => element['status'] == widget.status)
                .toList()
            : [];

        return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      widget.bgColor ?? Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: widget.fgColor ??
                          Theme.of(context).shadowColor.withOpacity(.2),
                      blurRadius: 7,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.status[0].toUpperCase() +
                          widget.status.substring(1),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: widget.fgColor ??
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.work),
                            title: Text(value[index]['name']),
                            subtitle: Text(
                              'Description: ${value[index]['description']}\nDue: ${DateFormat("yyyy-MM-dd").format(
                                DateTime.parse(value[index]['due']),
                              )}\nPay: ${value[index]['pay']}\nAssigned to: ${value[index]['assignee']}',
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await editDialog(
                                      value[index],
                                      widget.onChange,
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await confirmDelete(value[index]['id']);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      "Total: ${value.length}",
                      style: TextStyle(
                          color: widget.fgColor ??
                              Theme.of(context).colorScheme.onPrimary),
                    ),
                    Text(
                      "Total Pay: ${value.fold<double>(0, (value, element) => value += element['pay'])}",
                      style: TextStyle(
                          color: widget.fgColor ??
                              Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future editDialog(Map<String, dynamic> data, Function? postSubmit) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Todo"),
        content: SingleChildScrollView(
          child: WorkForm(
            edit: true,
            editData: data,
            postSubmit: () {
              if (postSubmit != null) postSubmit();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Future confirmDelete(String id) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () {
              popNavigator();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await deleteData(id: id);
              setState(() {
                _data = fetchData();
              });
              popNavigator();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void popNavigator() {
    Navigator.of(context).pop();
  }
}
