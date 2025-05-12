import 'package:flutter/material.dart';
import 'package:sales/utils/InputStyles.dart';
import '../services/task_service.dart';
import '../utils/alert.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopController = TextEditingController();
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  final TaskService _taskService = TaskService();

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      await _taskService.addTaskLocally(
        shopName: _shopController.text,
        productSold: _productController.text,
        quantity: int.parse(_quantityController.text),
        amount: double.parse(_amountController.text),
        notes: _notesController.text,
      );

      Alert.show(context, "Task saved locally.");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _shopController,
                decoration: InputStyles.inputDecoration('Shop Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _productController,
                decoration: InputStyles.inputDecoration('Product Sold'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: _quantityController,
                decoration: InputStyles.inputDecoration('Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: _amountController,
                decoration: InputStyles.inputDecoration('Amount'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: _notesController,
                decoration: InputStyles.inputDecoration('Notes (optional)'),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text("Save Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
