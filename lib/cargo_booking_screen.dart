import 'package:flutter/material.dart';

class CargoBookingScreen extends StatefulWidget {
  final String namaArmada;
  final String kapasitasMaks;

  const CargoBookingScreen({
    super.key,
    required this.namaArmada,
    required this.kapasitasMaks,
  });

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  String _kategoriKargo = 'General Cargo';

  bool _asuransi = false;
  bool _forklift = false;
  bool _pengawalan = false;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  double _tonase = 1.0;
  bool _isReeferActive = false;

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  double _hitungTotalBiaya() {
    double base = 1500000;
    base += _tonase * 250000;
    if (_asuransi) base += 200000;
    if (_forklift) base += 350000;
    if (_pengawalan) base += 500000;
    if (_isReeferActive) base += 450000;
    return base;
  }

  void _showCostCalculationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final total = _hitungTotalBiaya();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rincian Biaya Surat Jalan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Text('Tipe Armada: ${widget.namaArmada}'),
              Text('Kategori Kargo: $_kategoriKargo'),
              Text('Tonase Muatan: ${_tonase.toStringAsFixed(1)} Ton'),
              Text('Reefer Active: ${_isReeferActive ? "Ya" : "Tidak"}'),
              Text(
                'Jadwal: ${_selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : "-"} @ ${_selectedTime != null ? _selectedTime!.format(context) : "-"}',
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL ESTIMASI BIAYA:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _showConfirmationDialog();
                  },
                  child: const Text('PROSES TERBITKAN SURAT JALAN'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Penerbitan'),
        content: const Text(
          'Apakah Anda yakin data manifes kargo sudah benar dan ingin menerbitkan surat jalan resmi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A)),
            onPressed: () {
              Navigator.pop(context);
              final noResi = 'CF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
              Navigator.pop(
                context,
                'Surat Jalan $noResi Berhasil Diterbitkan untuk ${widget.namaArmada}!',
              );
            },
            child: const Text('Ya, Terbitkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Booking: ${widget.namaArmada}'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF1E3A8A)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Armada Terpilih: ${widget.namaArmada} (${widget.kapasitasMaks})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '1. Kategori Muatan Kargo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            RadioListTile<String>(
              title: const Text('General Cargo (Barang Umum)'),
              value: 'General Cargo',
              groupValue: _kategoriKargo,
              onChanged: (val) => setState(() => _kategoriKargo = val!),
            ),
            RadioListTile<String>(
              title: const Text('Makanan Beku / Perishable'),
              value: 'Makanan Beku/Perishable',
              groupValue: _kategoriKargo,
              onChanged: (val) => setState(() => _kategoriKargo = val!),
            ),
            RadioListTile<String>(
              title: const Text('Alat Berat / Heavy Material'),
              value: 'Alat Berat',
              groupValue: _kategoriKargo,
              onChanged: (val) => setState(() => _kategoriKargo = val!),
            ),

            const Divider(),

            const Text(
              '2. Layanan Proteksi & Tambahan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            CheckboxListTile(
              title: const Text('Asuransi Barang Rusak / Hilang'),
              value: _asuransi,
              onChanged: (val) => setState(() => _asuransi = val!),
            ),
            CheckboxListTile(
              title: const Text('Jasa Forklift Muat Depo'),
              value: _forklift,
              onChanged: (val) => setState(() => _forklift = val!),
            ),
            CheckboxListTile(
              title: const Text('Pengawalan Prioritas Jalan'),
              value: _pengawalan,
              onChanged: (val) => setState(() => _pengawalan = val!),
            ),

            const Divider(),

            const Text(
              '3. Jadwal Pengambilan Barang',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _selectedDate == null
                          ? 'Pilih Tanggal'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _selectedTime == null
                          ? 'Estimasi Jam'
                          : _selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(),

            const Text(
              '4. Pengaturan Muatan & Kontainer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Estimasi Tonase: ${_tonase.toStringAsFixed(1)} Ton'),
            Slider(
              value: _tonase,
              min: 0.5,
              max: 20.0,
              divisions: 39,
              label: '${_tonase.toStringAsFixed(1)} Ton',
              activeColor: const Color(0xFF1E3A8A),
              onChanged: (val) => setState(() => _tonase = val),
            ),
            SwitchListTile(
              title: const Text('Aktifkan Pendingin Reefer Container'),
              subtitle: const Text('Khusus Makanan Beku / Perishable'),
              value: _isReeferActive,
              activeColor: const Color(0xFF1E3A8A),
              onChanged: (val) => setState(() => _isReeferActive = val),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap pilih Tanggal dan Jam penjemputan!'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  _showCostCalculationSheet();
                },
                icon: const Icon(Icons.calculate),
                label: const Text(
                  'HITUNG BIAYA LOGISTIK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}