import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baked/controllers/shift_controller.dart' as app_shift_controller;
import 'package:baked/models/shift.dart';

class ShiftManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Shifts"),
        centerTitle: true,
        backgroundColor: Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<app_shift_controller.ShiftController>(
        builder: (context, shiftController, child) {
          if (shiftController.shifts.isEmpty) {
            return Center(child: Text("No shifts defined yet. Add some!"));
          }
          return ListView.builder(
            itemCount: shiftController.shifts.length,
            itemBuilder: (context, index) {
              final shift = shiftController.shifts[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text("${shift.namaShift} (${shift.shiftType})"), // <--- TAMPILKAN shiftType
                  subtitle: Text("Pukul: ${shift.waktuMulai} - ${shift.waktuSelesai}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showShiftForm(context, shiftController, shift);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Delete Shift"),
                              content: Text("Are you sure you want to delete ${shift.namaShift}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    shiftController.deleteShift(shift.id!);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Delete"),
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
          _showShiftForm(context, Provider.of<app_shift_controller.ShiftController>(context, listen: false), null);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFC35A2E),
      ),
    );
  }

  void _showShiftForm(BuildContext context, app_shift_controller.ShiftController shiftController, Shift? shift) {
    final _formKey = GlobalKey<FormState>();
    String? selectedShiftType = shift?.namaShift; // Ini akan menjadi nilai untuk shiftType

    String defaultWaktuMulai = '07:00';
    String defaultWaktuSelesai = '14:00';

    if (shift != null) {
      defaultWaktuMulai = shift.waktuMulai;
      defaultWaktuSelesai = shift.waktuSelesai;
      //selectedShiftType = shift.shiftType; // Jika Anda ingin menggunakan field shiftType yang baru untuk inisialisasi dropdown
    } else {
      selectedShiftType = 'Pagi'; // Default untuk shift baru
    }

    final TextEditingController waktuMulaiController = TextEditingController(text: defaultWaktuMulai);
    final TextEditingController waktuSelesaiController = TextEditingController(text: defaultWaktuSelesai);


    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            void _updateShiftTimes(String? newShiftType) {
              setState(() {
                if (newShiftType == 'Pagi') {
                  waktuMulaiController.text = '07:00';
                  waktuSelesaiController.text = '14:00';
                } else if (newShiftType == 'Sore') {
                  waktuMulaiController.text = '14:00';
                  waktuSelesaiController.text = '21:00';
                }
                selectedShiftType = newShiftType;
              });
            }

            if (shift == null && selectedShiftType == null) {
                 _updateShiftTimes('Pagi');
            }


            return AlertDialog(
              title: Text(shift == null ? "Add New Shift" : "Edit Shift"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedShiftType,
                        decoration: InputDecoration(labelText: 'Pilih Tipe Shift'),
                        items: <String>['Pagi', 'Sore']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          _updateShiftTimes(newValue);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please select a shift type.';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: waktuMulaiController,
                        decoration: InputDecoration(labelText: 'Waktu Mulai'),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Time cannot be empty.';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: waktuSelesaiController,
                        decoration: InputDecoration(labelText: 'Waktu Selesai'),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Time cannot be empty.';
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
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newOrUpdatedShift = Shift(
                        id: shift?.id,
                        namaShift: selectedShiftType!,
                        waktuMulai: waktuMulaiController.text,
                        waktuSelesai: waktuSelesaiController.text,
                        shiftType: selectedShiftType!, // <--- ISI FIELD shiftType DENGAN selectedShiftType
                      );

                      if (shift == null) {
                        await shiftController.addShift(newOrUpdatedShift);
                      } else {
                        await shiftController.updateShift(newOrUpdatedShift);
                      }
                      Navigator.of(ctx).pop();
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