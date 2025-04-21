import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/car.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

class AddCarScreen extends StatefulWidget {
  final User user;

  const AddCarScreen({super.key, required this.user});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  String _registrationNumber = '';
  double _fuelConsumption = 0;
  String _lastOilChangeDate = '';
  int _lastOilChangeKm = 0;
  String _insuranceDueDate = '';
  String _vignetteDueDate = '';
  String _technicalDueDate = '';
  double _totalSpent = 0;

  File? _capturedImage;
  final picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });

      // TODO Тук ще добавим OCR по-късно
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заснета е снимка – OCR предстои')),
      );
    }
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Car newCar = Car(
        userId: widget.user.id!,
        registrationNumber: _registrationNumber,
        fuelConsumption: _fuelConsumption,
        lastOilChangeDate: _lastOilChangeDate,
        lastOilChangeKm: _lastOilChangeKm,
        insuranceDueDate: _insuranceDueDate,
        vignetteDueDate: _vignetteDueDate,
        technicalDueDate: _technicalDueDate,
        totalSpent: _totalSpent,
      );

      await DatabaseHelper.instance.insertCar(newCar);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добави автомобил')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_capturedImage != null)
                Image.file(_capturedImage!, height: 150),

              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Снимай номер'),
                onPressed: _pickImageFromCamera,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Регистрационен номер'),
                validator: (value) => value!.isEmpty ? 'Въведи номер' : null,
                onSaved: (value) => _registrationNumber = value!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Разход (л/100км)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Въведи разход' : null,
                onSaved: (value) => _fuelConsumption = double.parse(value!),
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Дата на последна смяна на масло'),
                validator: (value) => value!.isEmpty ? 'Въведи дата' : null,
                onSaved: (value) => _lastOilChangeDate = value!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Километри при смяна на масло'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Въведи километри' : null,
                onSaved: (value) => _lastOilChangeKm = int.parse(value!),
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Крайна дата на гражданска отговорност'),
                validator: (value) => value!.isEmpty ? 'Въведи дата' : null,
                onSaved: (value) => _insuranceDueDate = value!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Крайна дата на винетка'),
                validator: (value) => value!.isEmpty ? 'Въведи дата' : null,
                onSaved: (value) => _vignetteDueDate = value!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Крайна дата на технически преглед'),
                validator: (value) => value!.isEmpty ? 'Въведи дата' : null,
                onSaved: (value) => _technicalDueDate = value!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Общо похарчени средства'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _totalSpent = double.tryParse(value ?? '') ?? 0,
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCar,
                child: const Text('Запази автомобила'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}