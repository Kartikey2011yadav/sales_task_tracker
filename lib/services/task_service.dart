import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../helpers/db_helper.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference taskCollection = FirebaseFirestore.instance
      .collection('sales_tasks');

  Future<void> addTaskLocally({
    required String shopName,
    required String productSold,
    required int quantity,
    required double amount,
    String? notes,
  }) async {
    final task = Task(
      id: const Uuid().v4(),
      shopName: shopName,
      productSold: productSold,
      quantity: quantity,
      amount: amount,
      notes: notes,
      timestamp: DateTime.now(),
    );

    await DBHelper.insertTask(task);
  }

  Future<void> deleteAllTaskLocally() async {
    await DBHelper.clearAllTasks();
  }


  Future<void> syncTasks() async {
    final unsyncedTasks = await DBHelper.getUnsyncedTasks();

    for (final task in unsyncedTasks) {
      try {
        await taskCollection.doc(task.id).set(task.toFirestore());
        await DBHelper.markTaskAsSynced(task.id);
      } catch (e) {
        // Handle sync failure here (e.g., log it)
        continue;
      }
    }
  }

  Future<int> getUnsyncedTaskCount() async {
    final unsynced = await DBHelper.getUnsyncedTasks();
    print(unsynced);
    return unsynced.length;
  }


  Future<List<Task>> fetchAllLocalTasks() async {
    return DBHelper.getAllTasks();
  }
}
