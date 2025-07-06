import 'package:baked/controllers/auth_controller.dart'; // Impor AuthController
import 'package:baked/controllers/shift_controller.dart' as app_shift_controller;
import 'package:baked/models/shift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShiftManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Shifts"),
        centerTitle: true,
        backgroundColor: const Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<app_shift_controller.ShiftController>(
        builder: (context, shiftController, child) {
          if (shiftController.shifts.isEmpty) {
            return const Center(child: Text("No shifts defined yet. Add some!"));
          }
          return ListView.builder(
            itemCount: shiftController.shifts.length,
            itemBuilder: (context, index) {
              final shift = shiftController.shifts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text("${shift.namaShift} (${shift.shiftType})"),
                  subtitle: Text("Pukul: ${shift.waktuMulai} - ${shift.waktuSelesai}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showShiftForm(context, shiftController, Provider.of<AuthController>(context, listen: false), shift);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete Shift"),
                              content: Text("Are you sure you want to delete ${shift.namaShift}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await shiftController.deleteShift(shift.id!);
                                      // Pastikan kasir di-unassign dari shift yang dihapus
                                      final authController = Provider.of<AuthController>(context, listen: false);
                                      final allUsers = await authController.getAllUsers();
                                      for (var user in allUsers) {
                                        if (user['role'] == 'kasir' && user['shift'] == shift.namaShift) {
                                          await authController.updateUserShift(user['uid'], 'Belum Ditentukan');
                                        }
                                      }
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
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showShiftForm(context, Provider.of<app_shift_controller.ShiftController>(context, listen: false), Provider.of<AuthController>(context, listen: false), null);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFC35A2E),
      ),
    );
  }

  // Modifikasi fungsi _showShiftForm
  void _showShiftForm(BuildContext context, app_shift_controller.ShiftController shiftController, AuthController authController, Shift? shift) async {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController namaShiftController = TextEditingController(text: shift?.namaShift ?? '');
    final TextEditingController waktuMulaiController = TextEditingController(text: shift?.waktuMulai ?? '07:00');
    final TextEditingController waktuSelesaiController = TextEditingController(text: shift?.waktuSelesai ?? '14:00');

    // --- Ambil daftar kasir DI SINI, sebelum showDialog ---
    // Ini akan dipanggil setiap kali dialog dibuka
    List<Map<String, dynamic>> allUsers = await authController.getAllUsers();
    List<Map<String, dynamic>> allCashiers = allUsers.where((user) => user['role'] == 'kasir').toList(); // Filter role kasir

    // Variabel untuk menyimpan UID kasir yang terpilih
    // Inisialisasi dengan 'Belum Ditentukan' jika tidak ada kasir yang ditugaskan ke shift ini
    String? _selectedCashierUid = 'Belum Ditentukan'; // Default option for dropdown

    // Jika mengedit shift yang sudah ada, coba cari kasir yang sudah ditugaskan ke shift ini
    if (shift != null) {
      final assignedCashier = allCashiers.firstWhere(
        (cashier) => cashier['shift'] == shift.namaShift,
        orElse: () => {}, // Mengembalikan map kosong jika tidak ditemukan
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
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), // Force 24-hour format
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              // Format manual ke HH:MM (24 jam)
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
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), // Force 24-hour format
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              // Format manual ke HH:MM (24 jam)
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
                      // Dropdown untuk memilih kasir tunggal
                      DropdownButtonFormField<String>(
                        value: _selectedCashierUid,
                        hint: const Text('Pilih Kasir'),
                        decoration: const InputDecoration(labelText: 'Kasir'),
                        items: [
                          // Opsi 'Belum Ditentukan'
                          const DropdownMenuItem<String>(
                            value: 'Belum Ditentukan',
                            child: Text('Belum Ditentukan'),
                          ),
                          // Opsi dari daftar kasir
                          ...allCashiers.map((cashier) {
                            return DropdownMenuItem<String>(
                              value: cashier['uid'],
                              child: Text(cashier['name'] ?? cashier['email']),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCashierUid = newValue;
                          });
                        },
                        validator: (value) {
                          // Validator opsional: jika shift memerlukan kasir
                          // if (value == null || value == 'Belum Ditentukan') return 'Harap pilih seorang kasir.';
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
                        shiftType: namaShiftController.text, // shiftType sama dengan namaShift
                        waktuMulai: waktuMulaiController.text,
                        waktuSelesai: waktuSelesaiController.text,
                      );

                      try {
                        // 1. Simpan/Update Definisi Shift
                        if (shift == null) {
                          await shiftController.addShift(newOrUpdatedShift);
                        } else {
                          await shiftController.updateShift(newOrUpdatedShift);
                        }

                        // 2. Perbarui Penugasan Kasir
                        final String shiftNameForAssignment = newOrUpdatedShift.namaShift;

                        // Iterasi semua kasir
                        for (var cashier in allCashiers) {
                          final String cashierUid = cashier['uid'];
                          final String? currentCashierShift = cashier['shift'];

                          if (cashierUid == _selectedCashierUid) {
                            // Ini adalah kasir yang BARU dipilih untuk shift ini
                            // Kita perbarui shift-nya, KECUALI jika yang dipilih adalah 'Belum Ditentukan'
                            if (_selectedCashierUid != 'Belum Ditentukan' && currentCashierShift != shiftNameForAssignment) {
                               await authController.updateUserShift(cashierUid, shiftNameForAssignment);
                            } else if (_selectedCashierUid == 'Belum Ditentukan' && currentCashierShift == shiftNameForAssignment) {
                               // Jika sebelumnya di shift ini tapi sekarang dipilih "Belum Ditentukan"
                               await authController.updateUserShift(cashierUid, 'Belum Ditentukan');
                            }
                          } else if (currentCashierShift == shiftNameForAssignment) {
                            // Ini adalah kasir lain yang sebelumnya ditugaskan ke shift ini,
                            // tapi sekarang kasir lain dipilih (atau shift ini tidak punya kasir yang dipilih)
                            await authController.updateUserShift(cashierUid, 'Belum Ditentukan');
                          }
                          // Jika kasirUid bukan yang dipilih dan shiftnya bukan shift ini, biarkan saja.
                        }


                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Shift ${newOrUpdatedShift.namaShift} berhasil disimpan dan penugasan kasir diperbarui!')),
                        );
                        shiftController.fetchShifts();
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
}