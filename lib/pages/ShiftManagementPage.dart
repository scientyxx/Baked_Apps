import 'package:baked/controllers/auth_controller.dart'; // Impor AuthController
import 'package:baked/controllers/shift_controller.dart' as app_shift_controller;
import 'package:baked/models/shift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShiftManagementPage extends StatefulWidget { // UBAH MENJADI StatefulWidget
  const ShiftManagementPage({Key? key}) : super(key: key);

  @override
  State<ShiftManagementPage> createState() => _ShiftManagementPageState();
}

class _ShiftManagementPageState extends State<ShiftManagementPage> { // State untuk StatefulWidget
  late Future<List<Shift>> _shiftsFuture;
  List<Map<String, dynamic>> _allCashiers = []; // Untuk menyimpan data semua kasir

  @override
  void initState() {
    super.initState();
    _loadData(); // Memuat shift dan kasir
  }

  // Fungsi baru untuk memuat kedua jenis data
  Future<void> _loadData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final shiftController = Provider.of<app_shift_controller.ShiftController>(context, listen: false);

    // Ambil daftar shift
    _shiftsFuture = shiftController.fetchShifts().then((_) {
      return shiftController.shifts;
    });

    // Ambil daftar kasir
    try {
      _allCashiers = await authController.getAllUsers();
      _allCashiers = _allCashiers.where((user) => user['role'] == 'kasir').toList();
      setState(() {}); // Memperbarui state setelah kasir dimuat
    } catch (e) {
      print('Error loading all cashiers in ShiftManagementPage: $e');
      // Handle error, mungkin tampilkan pesan ke user
    }
  }


  // Fungsi _showShiftForm yang sudah ada (tidak perlu diubah di sini)
  void _showShiftForm(BuildContext context, app_shift_controller.ShiftController shiftController, AuthController authController, Shift? shift) async {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController namaShiftController = TextEditingController(text: shift?.namaShift ?? '');
    final TextEditingController waktuMulaiController = TextEditingController(text: shift?.waktuMulai ?? '07:00');
    final TextEditingController waktuSelesaiController = TextEditingController(text: shift?.waktuSelesai ?? '14:00');

    String? _selectedCashierUid = 'Belum Ditentukan';

    List<Map<String, dynamic>> allUsers = await authController.getAllUsers(); // Ambil lagi untuk dialog
    List<Map<String, dynamic>> allCashiersInDialog = allUsers.where((user) => user['role'] == 'kasir').toList();

    if (shift != null) {
      final assignedCashier = allCashiersInDialog.firstWhere(
        (cashier) => cashier['shift'] == shift.namaShift,
        orElse: () => {},
      );
      if (assignedCashier.isNotEmpty) {
        _selectedCashierUid = assignedCashier['uid'];
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(shift == null ? "Tambah Shift Baru" : "Edit Shift"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: namaShiftController,
                        decoration: const InputDecoration(labelText: 'Nama Shift (contoh: Shift Pagi, Shift Sore)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a shift name.';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: waktuMulaiController,
                        decoration: const InputDecoration(labelText: 'Waktu Mulai (contoh: 07:00)'),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              waktuMulaiController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Time cannot be empty.';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: waktuSelesaiController,
                        decoration: const InputDecoration(labelText: 'Waktu Selesai (contoh: 14:00)'),
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              waktuSelesaiController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Time cannot be empty.';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Pilih Kasir untuk Shift Ini:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedCashierUid,
                        hint: const Text('Pilih Kasir'),
                        decoration: const InputDecoration(labelText: 'Kasir'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: 'Belum Ditentukan',
                            child: Text('Belum Ditentukan'),
                          ),
                          if (allCashiersInDialog.isNotEmpty) // Menggunakan allCashiersInDialog di sini
                            ...allCashiersInDialog.map((cashier) {
                              return DropdownMenuItem<String>(
                                value: cashier['uid'],
                                child: Text(cashier['name'] ?? cashier['email']),
                              );
                            }).toList(),
                          if (allCashiersInDialog.isEmpty && _selectedCashierUid == 'Belum Ditentukan')
                            const DropdownMenuItem<String>(
                                value: 'NO_CASHIER_AVAILABLE',
                                child: Text('Tidak ada kasir tersedia'),
                                enabled: false,
                            ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCashierUid = newValue;
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newOrUpdatedShift = Shift(
                        id: shift?.id,
                        namaShift: namaShiftController.text,
                        shiftType: namaShiftController.text,
                        waktuMulai: waktuMulaiController.text,
                        waktuSelesai: waktuSelesaiController.text,
                      );

                      try {
                        if (shift == null) {
                          await shiftController.addShift(newOrUpdatedShift);
                        } else {
                          await shiftController.updateShift(newOrUpdatedShift);
                        }

                        final String shiftNameForAssignment = newOrUpdatedShift.namaShift;

                        for (var cashier in allCashiersInDialog) { // Menggunakan allCashiersInDialog di sini
                          final String cashierUid = cashier['uid'];
                          final String? currentCashierShift = cashier['shift'];

                          if (cashierUid == _selectedCashierUid) {
                            if (_selectedCashierUid != 'Belum Ditentukan' && currentCashierShift != shiftNameForAssignment) {
                               await authController.updateUserShift(cashierUid, shiftNameForAssignment);
                            } else if (_selectedCashierUid == 'Belum Ditentukan' && currentCashierShift == shiftNameForAssignment) {
                               await authController.updateUserShift(cashierUid, 'Belum Ditentukan');
                            }
                          } else if (currentCashierShift == shiftNameForAssignment) {
                            await authController.updateUserShift(cashierUid, 'Belum Ditentukan');
                          }
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Shift ${newOrUpdatedShift.namaShift} berhasil disimpan dan penugasan kasir diperbarui!')),
                        );
                        // Setelah menyimpan, muat ulang semua data (shift dan kasir)
                        await _loadData(); // Panggil _loadData untuk refresh tampilan utama
                        Navigator.of(ctx).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal menyimpan shift: $e')),
                        );
                      }
                    }
                  },
                  child: Text(shift == null ? "Add" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil instance controller (tidak perlu listen di sini karena sudah ada di _loadData)
    final shiftController = Provider.of<app_shift_controller.ShiftController>(context);
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Shift'),
        backgroundColor: const Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Shift>>( // FutureBuilder untuk daftar Shift
        future: _shiftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada shift ditemukan. Tambahkan satu!'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final shift = snapshot.data![index];
                // Cari kasir yang ditugaskan ke shift ini
                final assignedCashier = _allCashiers.firstWhere(
                  (cashier) => cashier['shift'] == shift.namaShift,
                  orElse: () => {'name': 'Belum Ditentukan', 'email': ''}, // Default jika tidak ada kasir yang ditugaskan
                );
                final String cashierName = assignedCashier['name'] ?? assignedCashier['email'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("${shift.namaShift} (${shift.shiftType})"),
                    subtitle: Text("Pukul: ${shift.waktuMulai} - ${shift.waktuSelesai}\nKasir: $cashierName"), // Tampilkan kasir yang bertugas
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showShiftForm(context, shiftController, authController, shift);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Shift"),
                                content: Text("Yakin ingin menghapus shift ${shift.namaShift}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await shiftController.deleteShift(shift.id!);
                                        final allCurrentUsers = await authController.getAllUsers();
                                        for (var user in allCurrentUsers) {
                                          if (user['role'] == 'kasir' && user['shift'] == shift.namaShift) {
                                            await authController.updateUserShift(user['uid'], 'Belum Ditentukan');
                                          }
                                        }
                                        await _loadData(); // Refresh data setelah penghapusan
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Shift ${shift.namaShift} berhasil dihapus.')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Gagal menghapus shift: $e')),
                                        );
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}