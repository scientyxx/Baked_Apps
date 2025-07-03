// import 'package:image_picker/image_picker.dart'; // Hapus import ini
// import 'dart:io'; // Hapus import ini
import 'package:baked/controllers/menu_controller.dart' as app_controller;
import 'package:baked/models/katalog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Menu Items"),
        centerTitle: true,
        backgroundColor: Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<app_controller.MenuController>(
        builder: (context, menuController, child) {
          if (menuController.menuItems.isEmpty) {
            return Center(child: Text("No menu items yet. Add some!"));
          }
          return ListView.builder(
            itemCount: menuController.menuItems.length,
            itemBuilder: (context, index) {
              final item = menuController.menuItems[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  // Menampilkan gambar dari assets lokal
                  leading: item.imagePath != null && item.imagePath!.isNotEmpty
                      ? Image.asset(
                          'images/${item.imagePath}', // Asumsi path adalah images/nama_file.png
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
                        )
                      : Icon(Icons.image, size: 50), // Icon default jika tidak ada gambar
                  title: Text(item.namaMakanan),
                  subtitle: Text("Rp ${item.harga.toStringAsFixed(0)} - Stock: ${item.stock}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showMenuItemForm(context, menuController, item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Delete Item"),
                              content: Text("Are you sure you want to delete ${item.namaMakanan}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    menuController.deleteMenuItem(item.id!);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMenuItemForm(context, Provider.of<app_controller.MenuController>(context, listen: false), null);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFC35A2E),
      ),
    );
  }

  // Fungsi untuk menampilkan form tambah/edit menu
  void _showMenuItemForm(BuildContext context, app_controller.MenuController menuController, Katalog? item) {
    final _formKey = GlobalKey<FormState>();
    final namaMakananController = TextEditingController(text: item?.namaMakanan ?? '');
    final deskripsiController = TextEditingController(text: item?.deskripsi ?? '');
    final kategoriController = TextEditingController(text: item?.kategori ?? '');
    final hargaController = TextEditingController(text: item?.harga.toString() ?? '');
    final stockController = TextEditingController(text: item?.stock.toString() ?? '');
    final imagePathController = TextEditingController(text: item?.imagePath ?? ''); // Controller untuk imagePath
    DateTime tanggalKadaluarsa = item?.tanggalKadaluarsa ?? DateTime.now().add(Duration(days: 30));

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(item == null ? "Add New Menu Item" : "Edit Menu Item"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Input untuk nama file gambar
                      TextFormField(
                        controller: imagePathController,
                        decoration: InputDecoration(
                          labelText: 'Nama File Gambar (misal: apple_pie.png)',
                          hintText: 'Pastikan gambar ada di folder images/assets'
                        ),
                        validator: (value) {
                          // Opsional: Validasi apakah formatnya .png/.jpg/.jpeg
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      // Preview gambar (jika ada inputnya)
                      if (imagePathController.text.isNotEmpty)
                        Image.asset(
                          'images/${imagePathController.text}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Text('Error loading image. Check filename.'),
                        ),
                      SizedBox(height: 10),

                      TextFormField(
                        controller: namaMakananController,
                        decoration: InputDecoration(labelText: 'Nama Makanan'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a name.';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: deskripsiController,
                        decoration: InputDecoration(labelText: 'Deskripsi'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a description.';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: kategoriController,
                        decoration: InputDecoration(labelText: 'Kategori'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter a category.';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: hargaController,
                        decoration: InputDecoration(labelText: 'Harga'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || double.tryParse(value) == null) return 'Please enter a valid price.';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: stockController,
                        decoration: InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || int.tryParse(value) == null) return 'Please enter a valid stock.';
                          return null;
                        },
                      ),
                      ListTile(
                        title: Text("Tanggal Kadaluarsa: ${tanggalKadaluarsa.toLocal().toString().split(' ')[0]}"),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: tanggalKadaluarsa,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                          );
                          if (picked != null && picked != tanggalKadaluarsa) {
                            setState(() {
                              tanggalKadaluarsa = picked;
                            });
                          }
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
                      final newOrUpdatedItem = Katalog(
                        id: item?.id,
                        namaMakanan: namaMakananController.text,
                        deskripsi: deskripsiController.text,
                        kategori: kategoriController.text,
                        harga: double.parse(hargaController.text),
                        tanggalKadaluarsa: tanggalKadaluarsa,
                        stock: int.parse(stockController.text),
                        imagePath: imagePathController.text.trim().isEmpty ? null : imagePathController.text.trim(), // Gunakan input dari textfield
                      );

                      if (item == null) {
                        await menuController.addMenuItem(newOrUpdatedItem);
                      } else {
                        await menuController.updateMenuItem(newOrUpdatedItem);
                      }
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text(item == null ? "Add" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}