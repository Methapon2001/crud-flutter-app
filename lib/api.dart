import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://localhost:8090');

Future<List<Map<String, dynamic>>> fetchData() async {
  final records = await pb.collection("work").getFullList(sort: '-created');

  return records.map((r) {
    return {
      "id": r.id,
      "name": r.getDataValue<String>('name'),
      "description": r.getDataValue<String>('description'),
      "due": r.getDataValue<String>('due'),
      "assignee": r.getDataValue<String>('assignee'),
      "pay": r.getDataValue<double>('pay'),
      "status": r.getDataValue<String>('status'),
    };
  }).toList();
}

Future<Map<String, dynamic>> postData({
  required Map<String, dynamic> data,
}) async {
  return pb.collection("work").create(body: data).then((r) {
    return {
      "id": r.id,
      "name": r.getDataValue<String>('name'),
      "description": r.getDataValue<String>('description'),
      "due": r.getDataValue<String>('due'),
      "assignee": r.getDataValue<String>('assignee'),
      "pay": r.getDataValue<double>('pay'),
      "status": r.getDataValue<String>('status'),
    };
  });
}

Future<Map<String, dynamic>> putData({
  required String id,
  required Map<String, dynamic> data,
}) async {
  return pb.collection("work").update(id, body: data).then((r) {
    return {
      "id": r.id,
      "name": r.getDataValue<String>('name'),
      "description": r.getDataValue<String>('description'),
      "due": r.getDataValue<String>('due'),
      "assignee": r.getDataValue<String>('assignee'),
      "pay": r.getDataValue<double>('pay'),
      "status": r.getDataValue<String>('status'),
    };
  });
}

Future<void> deleteData({
  required String id,
}) async {
  return pb.collection("work").delete(id);
}
