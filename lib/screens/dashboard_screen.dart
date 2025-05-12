import 'dart:async';
import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../services/task_service.dart';
import '../utils/alert.dart';
import 'add_task_screen.dart';
import 'task_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  bool _isOnline = false;
  late StreamSubscription<bool> _subscription;
  final ConnectivityService connectivityService = ConnectivityService();
  bool _hasUnsynced = false;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _checkSyncStatus();

    _subscription = connectivityService.connectionStatusStream.listen((status) {
      setState(() {
        _isOnline = status;
      });
      Alert.show(context, "You are now ${status ? 'online' : 'offline'}");
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _checkSyncStatus() async {
    final unsynced = await _taskService.getUnsyncedTaskCount();
    setState(() => _hasUnsynced = unsynced > 0);
  }

  Future<void> _syncTasks() async {
    await _taskService.syncTasks();
    await _checkSyncStatus();
    if (mounted) Alert.show(context, "Sync complete.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Task Tracker"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Icon(
            _isOnline ? Icons.wifi : Icons.wifi_off,
            color: _isOnline ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _hasUnsynced ? Colors.red.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hasUnsynced ? Colors.red : Colors.green,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _hasUnsynced ? "Some tasks are not synced." : "All tasks are synced.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _hasUnsynced ? Colors.red : Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isOnline? _hasUnsynced ? _syncTasks : null : null,
                  icon: const Icon(Icons.sync, color: Colors.white,),
                  label: const Text("Sync Now", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasUnsynced ? Colors.indigo : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 240,),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add New Task"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen()));
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text("View All Tasks"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskListScreen()));
            },
          ),
        ],
      ),
    );
  }
}
