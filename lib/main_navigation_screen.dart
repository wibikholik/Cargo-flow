import 'package:flutter/material.dart';
import 'cargo_booking_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String staffId;
  const MainNavigationScreen({super.key, required this.staffId});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ManifesMuatanTab(),
      const RekapResiTab(),
      const InformasiDepoTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CargoFlow - Staf Lapangan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
              ),
              accountName: Text(
                'Staf ID: ${widget.staffId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: const Text('Depo Utama Subang - Zona 1'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.airport_shuttle),
              title: const Text('Armada Terdaftar'),
              subtitle: const Text('3 Unit Siap Jalan'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Rekapitulasi Resi'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.warehouse),
              title: const Text('Informasi Depo'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar (Logout)', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Manifes Muatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart_outlined),
            activeIcon: Icon(Icons.table_chart),
            label: 'Rekap Resi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse_outlined),
            activeIcon: Icon(Icons.warehouse),
            label: 'Informasi Depo',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SUB-HALAMAN: MANIFES MUATAN
// -----------------------------------------------------------------------------
class ManifesMuatanTab extends StatelessWidget {
  const ManifesMuatanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.grey[100],
            child: const TabBar(
              labelColor: Color(0xFF1E3A8A),
              indicatorColor: Color(0xFF1E3A8A),
              tabs: [
                Tab(
                  icon: Icon(Icons.local_shipping),
                  text: 'Armada Tersedia',
                ),
                Tab(
                  icon: Icon(Icons.warning_amber),
                  text: 'Syarat Muatan Berbahaya',
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                ArmadaTersediaSubTab(),
                SyaratMuatanBerbahayaSubTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArmadaTersediaSubTab extends StatelessWidget {
  const ArmadaTersediaSubTab({super.key});

  final List<Map<String, String>> armadaList = const [
    {
      'nama': 'Colt Diesel',
      'kapasitas': 'Maks 3.5 Ton',
      'dimensi': '4.2m x 2.0m x 1.9m',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUnBtXrNamD016WWFtteOQtKD0E5502qFEGoOZCGzL6w&s',
    },
    {
      'nama': 'Fuso Heavy Duty',
      'kapasitas': 'Maks 8.0 Ton',
      'dimensi': '6.0m x 2.4m x 2.2m',
      'imageUrl': 'https://imgcdnblog.carbay.com/wp-content/uploads/2019/07/21190545/Fuso-Fighter-Superlong.jpg',
    },
    {
      'nama': 'Tronton Container',
      'kapasitas': 'Maks 20.0 Ton',
      'dimensi': '9.5m x 2.4m x 2.5m',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-L5egAFGDBbB64iWmcvfiblgRz_xODoBYaRBIE5ce3IZyHH8HiOXaEKOV&s=10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: armadaList.length,
      itemBuilder: (context, index) {
        final item = armadaList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.blueGrey[200],
                    child: Image.network(
                      item['imageUrl']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.blueGrey,
                        child: const Icon(
                          Icons.directions_bus,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                      child: Text(
                        item['kapasitas']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text(
                  item['nama']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text('Dimensi Kargo: ${item['dimensi']}'),
                trailing: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CargoBookingScreen(
                          namaArmada: item['nama']!,
                          kapasitasMaks: item['kapasitas']!,
                        ),
                      ),
                    );

                    if (result != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notifikasi Transaksi: $result',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.green[700],
                          duration: const Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Pilih Armada'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SyaratMuatanBerbahayaSubTab extends StatefulWidget {
  const SyaratMuatanBerbahayaSubTab({super.key});

  @override
  State<SyaratMuatanBerbahayaSubTab> createState() =>
      _SyaratMuatanBerbahayaSubTabState();
}

class _SyaratMuatanBerbahayaSubTabState
    extends State<SyaratMuatanBerbahayaSubTab> {
  final List<Map<String, dynamic>> _hazmatList = [
    {
      'title': 'Kelas 1: Bahan Peledak & Flammable',
      'content':
          'Memerlukan izin Kepolisian & Kemenhub. Wajib menggunakan truk dengan sistem pemadam otomatis serta pendingin kabin kargo terisolasi.',
      'isExpanded': false,
    },
    {
      'title': 'Kelas 2: Gas Bertekanan / B3',
      'content':
          'Tabung gas wajib terikat braket baja. Pengemudi harus mengantongi sertifikat pengangkutan B3 resmi.',
      'isExpanded': false,
    },
    {
      'title': 'Kelas 3: Cairan Mudah Terbakar',
      'content':
          'Kapasitas maksimum kontainer cair 15,000 Liter. Kecepatan armada dibatasi maksimal 60 km/jam.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            _hazmatList[index]['isExpanded'] = isExpanded;
          });
        },
        children: _hazmatList.map<ExpansionPanel>((item) {
          return ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.amber),
                title: Text(
                  item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item['content'],
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
            isExpanded: item['isExpanded'],
          );
        }).toList(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SUB-HALAMAN: REKAP RESI
// -----------------------------------------------------------------------------
class RekapResiTab extends StatelessWidget {
  const RekapResiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!),
            headingRowColor: WidgetStateProperty.all(const Color(0xFF1E3A8A)),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            columns: const [
              DataColumn(label: Text('No. Resi')),
              DataColumn(label: Text('Tipe Armada')),
              DataColumn(label: Text('Kategori Kargo')),
              DataColumn(label: Text('Tonase')),
              DataColumn(label: Text('Status')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('CF-2026-001')),
                DataCell(Text('Tronton')),
                DataCell(Text('Alat Berat')),
                DataCell(Text('18 Ton')),
                DataCell(Chip(
                  label: Text('Dalam Perjalanan', style: TextStyle(color: Colors.white, fontSize: 11)),
                  backgroundColor: Colors.blue,
                )),
              ]),
              DataRow(cells: [
                DataCell(Text('CF-2026-002')),
                DataCell(Text('Colt Diesel')),
                DataCell(Text('Makanan Beku')),
                DataCell(Text('2.5 Ton')),
                DataCell(Chip(
                  label: Text('Selesai', style: TextStyle(color: Colors.white, fontSize: 11)),
                  backgroundColor: Colors.green,
                )),
              ]),
              DataRow(cells: [
                DataCell(Text('CF-2026-003')),
                DataCell(Text('Fuso Heavy')),
                DataCell(Text('General Cargo')),
                DataCell(Text('6.0 Ton')),
                DataCell(Chip(
                  label: Text('Menunggu Muat', style: TextStyle(color: Colors.white, fontSize: 11)),
                  backgroundColor: Colors.orange,
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SUB-HALAMAN: INFORMASI DEPO
// -----------------------------------------------------------------------------
class InformasiDepoTab extends StatelessWidget {
  const InformasiDepoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.warehouse, size: 48, color: Color(0xFF1E3A8A)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gudang Utama Depo Subang',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Jl. Brigjen Katamso No. 37, Subang, Jawa Barat',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Kode Tracking API Pusat (Dapat Disalin):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: const SelectableText(
              'https://api.cargoflow.logistics.co.id/v2/depo/SUBANG-MAIN-HUB/manifest/stream',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}