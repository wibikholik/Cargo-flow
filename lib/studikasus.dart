import 'package:flutter/material.dart';

// ---------------- Screen 1: Input Suhu ----------------
class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final TextEditingController _suhuController = TextEditingController();
  String _selectedUnit = 'Celsius';
  final List<String> _units = ['Celsius', 'Fahrenheit', 'Reamur', 'Kelvin'];

  void _konversi() {
    double? inputSuhu = double.tryParse(_suhuController.text);
    if (inputSuhu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan angka suhu yang valid!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen2(
          nilaiSuhu: inputSuhu,
          satuanAsal: _selectedUnit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Suhu - Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _suhuController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Masukkan Suhu',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedUnit,
              isExpanded: true,
              items: _units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _konversi,
              child: const Text('Konversi'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Screen 2: Hasil Konversi ----------------
class Screen2 extends StatelessWidget {
  final double nilaiSuhu;
  final String satuanAsal;

  const Screen2({
    super.key,
    required this.nilaiSuhu,
    required this.satuanAsal,
  });

  Map<String, double> _hitungKonversi() {
    double celsius = 0;

    // 1. Konversi dari satuan asal ke Celsius terlebih dahulu
    switch (satuanAsal) {
      case 'Celsius':
        celsius = nilaiSuhu;
        break;
      case 'Fahrenheit':
        celsius = (nilaiSuhu - 32) * 5 / 9;
        break;
      case 'Reamur':
        celsius = nilaiSuhu * 5 / 4;
        break;
      case 'Kelvin':
        celsius = nilaiSuhu - 273.15;
        break;
    }

    // 2. Hitung ke 3 satuan lainnya berdasarkan Celsius
    Map<String, double> hasil = {};
    if (satuanAsal != 'Celsius') {
      hasil['Celsius'] = celsius;
    }
    if (satuanAsal != 'Fahrenheit') {
      hasil['Fahrenheit'] = (celsius * 9 / 5) + 32;
    }
    if (satuanAsal != 'Reamur') {
      hasil['Reamur'] = celsius * 4 / 5;
    }
    if (satuanAsal != 'Kelvin') {
      hasil['Kelvin'] = celsius + 273.15;
    }

    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> hasilKonversi = _hitungKonversi();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Suhu - Hasil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Input: ${nilaiSuhu.toStringAsFixed(1)} $satuanAsal',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...hasilKonversi.entries.map((entry) {
                String unitSymbol = '';
                if (entry.key == 'Celsius') unitSymbol = '°C';
                if (entry.key == 'Fahrenheit') unitSymbol = '°F';
                if (entry.key == 'Reamur') unitSymbol = '°R';
                if (entry.key == 'Kelvin') unitSymbol = 'K';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${entry.key}: ${entry.value.toStringAsFixed(2)} $unitSymbol',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}