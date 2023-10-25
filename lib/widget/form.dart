import 'package:alpine_flutter/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WorkForm extends StatefulWidget {
  final bool? edit;
  final Map<String, dynamic>? editData;
  final Function? postSubmit;

  const WorkForm({super.key, this.postSubmit, this.edit, this.editData});

  @override
  State<WorkForm> createState() => _WorkFormState();
}

const List<String> statusList = <String>['todo', 'doing', 'done'];

class _WorkFormState extends State<WorkForm> {
  String dropdownValue = statusList.first;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  TextEditingController dueDateText = TextEditingController();
  TextEditingController assigneeText = TextEditingController();
  TextEditingController payText = TextEditingController();

  Map<String, dynamic> newData = {};

  @override
  void initState() {
    super.initState();
    if (widget.edit != null && widget.editData != null) {
      newData = widget.editData!;

      dropdownValue = newData['status'] = widget.editData!['status'];
      nameText.text = widget.editData!['name'];
      descriptionText.text = widget.editData!['description'];
      dueDateText.text = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(widget.editData!['due']));
      assigneeText.text = widget.editData!['assignee'];
      payText.text = '${widget.editData!['pay']}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameText,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Please enter at least 3 charactor';
                  } else {
                    newData['name'] = value.toString();
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descriptionText,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Please enter at least 3 charactor';
                  } else {
                    newData['description'] = value.toString();
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: dueDateText,
                decoration: const InputDecoration(
                  labelText: 'Due',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      DateTime.tryParse(value) == null) {
                    return 'Please enter valid date';
                  } else {
                    newData['due'] = value;
                    return null;
                  }
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    newData['due'] = dueDateText.text =
                        DateFormat("yyyy-MM-dd").format(pickedDate);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: payText,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pay',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter something';
                  } else {
                    newData['pay'] = value.toString();
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: assigneeText,
                decoration: const InputDecoration(
                  labelText: 'Assignee',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter assignee';
                  } else {
                    newData['assignee'] = value.toString();
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'Status : ',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(height: 2, color: Colors.blue),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: statusList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (newData['status'] == null) {
                    newData['status'] = dropdownValue;
                  }

                  if (widget.edit != null && widget.editData != null) {
                    print(widget.editData!['id']);
                    print(newData);
                    await putData(id: widget.editData!['id'], data: newData);
                  } else {
                    await postData(data: newData);
                  }

                  if (widget.postSubmit != null) {
                    widget.postSubmit!();
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
