import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/connectivity_service.dart';
import '../services/task_service.dart';
import '../utils/alert.dart';
import '../utils/dialogs.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isSyncing = false;
  bool _isOnline = false;
  ConnectivityService connectivityService = ConnectivityService();
  late final StreamSubscription<bool> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadTasks();

    _connectivitySubscription = connectivityService.connectionStatusStream
        .listen((status) {
          setState(() {
            _isOnline = status;
          });
        });

    // Optional auto sync when coming online
    // _connectivitySubscription = connectivityService.connectionStatusStream.listen((isOnline) async {
    //   if (isOnline) {
    //     await _taskService.syncTasks();
    //     await _loadTasks();
    //   }
    // });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.fetchAllLocalTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _syncTasks() async {
    setState(() => _isSyncing = true);
    await _taskService.syncTasks();
    // await _taskService.deleteAllTaskLocally();
    await _loadTasks();
    setState(() => _isSyncing = false);
    Alert.show(context, "Sync complete.");
  }

  void _alreadySynced() {
    Alert.show(context, "Already synced.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Icon(
            _isOnline ? Icons.wifi : Icons.wifi_off,
            color: _isOnline ? Colors.greenAccent : Colors.redAccent,
          ),
          SizedBox(width: 4),
          IconButton(
            icon:
                _isSyncing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.sync, color: Colors.white),
            onPressed: _isSyncing ? _alreadySynced : _syncTasks,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (_, i) {
            final task = _tasks[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(task.shopName),
                subtitle: Text(
                  "${task.productSold} x${task.quantity} => Rs. ${task.amount}\n${DateFormat.yMd().add_jm().format(task.timestamp)}",
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      task.isSynced ? Icons.check_circle : Icons.sync_problem,
                      color: task.isSynced ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                onTap: () => Dialogs.showTaskDetailsDialog(context, task),
                isThreeLine: true,
                tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                selectedTileColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.2),
                splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
