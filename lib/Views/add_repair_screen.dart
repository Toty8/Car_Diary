import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/repair.dart';
import '../database/database_helper.dart';

class AddRepairScreen extends StatefulWidget {
  final Car car;

  const AddRepairScreen({super.key, required this.car});

  @override
  State<AddRepairScreen> createState() => _AddRepairScreenState();
}

class _AddRepairScreenState extends State<AddRepairScreen> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _date = '';
  double _cost = 0;

  Future<void> _saveRepair() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Repair newRepair = Repair(
        carId: widget.car.id!,
        description: _description,
        date: _date,
        cost: _cost,
      );

      await DatabaseHelper.instance.insertRepair(newRepair);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добави ремонт')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Описание'),
                validator: (value) => value!.isEmpty ? 'Въведи описание' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Дата'),
                validator: (value) => value!.isEmpty ? 'Въведи дата' : null,
                onSaved: (value) => _date = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Цена (лв)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Въведи цена' : null,
                onSaved: (value) => _cost = double.parse(value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRepair,
                child: const Text('Запази ремонта'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}