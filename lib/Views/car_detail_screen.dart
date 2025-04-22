import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/repair.dart';
import '../database/database_helper.dart';
import 'add_repair_screen.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  List<Repair> _repairs = [];

  @override
  void initState() {
    super.initState();
    _loadRepairs();
  }

  Future<void> _loadRepairs() async {
    final data = await DatabaseHelper.instance.getRepairsByCar(widget.car.id!);
    setState(() {
      _repairs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(title: Text('Детайли за ${car.registrationNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _infoTile('Разход', '${car.fuelConsumption} л/100км'),
            _infoTile('Смяна на масло – дата', car.lastOilChangeDate),
            _infoTile('Смяна на масло – километри', '${car.lastOilChangeKm} км'),
            _infoTile('ГО до', car.insuranceDueDate),
            _infoTile('Винетка до', car.vignetteDueDate),
            _infoTile('Тех. преглед до', car.technicalDueDate),
            _infoTile('Общо похарчено', '${car.totalSpent.toStringAsFixed(2)} лв'),
            const SizedBox(height: 24),
            const Text('Ремонти', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._repairs.map((r) => ListTile(
                  title: Text(r.description),
                  subtitle: Text(r.date),
                  trailing: Text('${r.cost.toStringAsFixed(2)} лв'),
                )),
            if (_repairs.isEmpty)
              const Text('Няма ремонти.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRepairScreen(car: widget.car),
            ),
          );
          _loadRepairs();
        },
        tooltip: 'Добави ремонт',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return ListTile(
      dense: true,
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
