import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class Dialogs {
  static void showTaskDetailsDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              '     --Sales Details-- \n${task.shopName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetail("🛒 Product", task.productSold),
                _buildDetail("📦 Quantity", "${task.quantity}"),
                _buildDetail(
                  "💰 Amount",
                  "₹ ${task.amount.toStringAsFixed(2)}",
                ),
                if (task.notes?.isNotEmpty == true)
                  _buildDetail("📝 Notes", task.notes!),
                _buildDetail(
                  "⏰ Timestamp",
                  DateFormat.yMMMd().add_jm().format(task.timestamp),
                ),
                _buildDetail(
                  "✅ Sync Status",
                  task.isSynced ? "Synced" : "Not Synced",
                  color: task.isSynced ? Colors.green : Colors.red,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  static Widget _buildDetail(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
