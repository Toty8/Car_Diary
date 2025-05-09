import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';
import '../models/car.dart';
import '../Views/login_register_screen.dart';
import '../Views/add_car_screen.dart';
import '../Views/car_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> _cars = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await DatabaseHelper.instance.getCarsByUser(widget.user.id!);
    setState(() {
      _cars = cars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моите автомобили'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Изход',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Изход'),
                  content: const Text('Сигурен ли си, че искаш да излезеш?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отказ'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginRegisterScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Изход'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _cars.isEmpty
          ? const Center(child: Text('Нямаш добавени автомобили.'))
          : ListView.builder(
              itemCount: _cars.length,
              itemBuilder: (context, index) {
                final car = _cars[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(car.registrationNumber),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Разход: ${car.fuelConsumption} л/100км'),
                        Text('Последна смяна на масло: ${car.lastOilChangeDate}'),
                        Text('Общи разходи: ${car.totalSpent.toStringAsFixed(2)} лв'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailScreen(car: car),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCarScreen(user: widget.user),
            ),
          ).then((_) => _loadCars());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
