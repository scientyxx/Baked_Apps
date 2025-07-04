// lib/pages/admin_shift_management_page.dart
import 'package:baked/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminShiftManagementPage extends StatefulWidget {
  const AdminShiftManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminShiftManagementPage> createState() => _AdminShiftManagementPageState();
}

class _AdminShiftManagementPageState extends State<AdminShiftManagementPage> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _usersFuture = Provider.of<AuthController>(context, listen: false).getAllUsers();
  }

  void _showShiftSelectionDialog(String uid, String currentShift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedShift = currentShift;
        return AlertDialog(
          title: const Text('Pilih Shift'),
          content: DropdownButton<String>(
            value: selectedShift,
            hint: const Text('Pilih Shift'),
            onChanged: (String? newValue) {
              setState(() {
                selectedShift = newValue;
              });
              Navigator.of(context).pop(newValue); // Tutup dialog dan kembalikan nilai
            },
            items: <String>['Pagi', 'Sore', 'Malam', 'Belum Ditentukan']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    ).then((result) async {
      if (result != null && result != currentShift) {
        try {
          await Provider.of<AuthController>(context, listen: false).updateUserShift(uid, result);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Shift berhasil diperbarui menjadi $result')),
          );
          _loadUsers(); // Muat ulang daftar pengguna setelah update
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui shift: $e')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Shift Kasir'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pengguna ditemukan.'));
          } else {
            // Filter hanya kasir (jika ada peran 'kasir' yang ditetapkan)
            final cashiers = snapshot.data!.where((user) => user['role'] == 'kasir').toList();
            if (cashiers.isEmpty) {
              return const Center(child: Text('Tidak ada kasir ditemukan.'));
            }

            return ListView.builder(
              itemCount: cashiers.length,
              itemBuilder: (context, index) {
                final user = cashiers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(user['name'] ?? 'Nama Tidak Diketahui'),
                    subtitle: Text('Email: ${user['email']}\nShift: ${user['shift'] ?? 'Belum Ditentukan'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showShiftSelectionDialog(user['uid'], user['shift'] ?? 'Belum Ditentukan'),
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