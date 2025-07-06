import 'package:baked/controllers/menu_controller.dart' as app_controller;
import 'package:baked/models/katalog.dart';
import 'package:baked/models/order.dart';
import 'package:baked/pages/MenuPage.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MenuHomeWidget extends StatefulWidget {
  @override
  _MenuHomeWidgetState createState() => _MenuHomeWidgetState();
}

class _MenuHomeWidgetState extends State<MenuHomeWidget> {
  String formatCurrency(double amount) {
    try {
      final formatCurrency =
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return formatCurrency.format(amount);
    } catch (e) {
      print('Error formatting currency: $e');
      return 'Rp 0';
    }
  }

  void updateCart(BuildContext context, Katalog item, int quantity) {
    if (mounted) {
      try {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        Order order = Order(
          name: item.namaMakanan,
          price: item.harga.toDouble(),
          quantity: quantity,
          imagePath: item.imagePath,
        );
        orderProvider.updateOrderQuantity(context, order, quantity);
      } catch (e) {
        print('Error updating cart: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<app_controller.MenuController>(
      builder: (context, menuController, child) {
        if (menuController.menuItems.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No menu items available.")),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Menu List",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPageContent(),
                        ),
                      );
                    },
                    child: Text(
                      "See More",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 350,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: menuController.menuItems.length > 4 ? 4 : menuController.menuItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  return MenuHomeItemWidget(
                    key: ValueKey(menuController.menuItems[index].namaMakanan),
                    item: menuController.menuItems[index],
                    formatCurrency: formatCurrency,
                    updateCart: (Katalog item, int quantity) => updateCart(context, item, quantity),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MenuHomeItemWidget extends StatefulWidget { // ATAU MenuHomeItemWidget untuk MenuHomeWidget
  final Katalog item;
  final String Function(double) formatCurrency;
  final void Function(Katalog, int) updateCart;

  const MenuHomeItemWidget({
    Key? key,
    required this.item,
    required this.formatCurrency,
    required this.updateCart,
  }) : super(key: key);

  @override
  _MenuHomeItemWidgetState createState() => _MenuHomeItemWidgetState(); // ATAU _MenuHomeItemWidgetState
}

class _MenuHomeItemWidgetState extends State<MenuHomeItemWidget> { // ATAU _MenuHomeItemWidgetState
  @override
  Widget build(BuildContext context) {
    final currentQuantity = Provider.of<OrderProvider>(context, listen: true)
        .getOrderQuantity(widget.item.namaMakanan);

    // Tentukan apakah tombol tambah harus dinonaktifkan
    final bool isStockZero = widget.item.stock <= 0;
    // Tentukan apakah tombol tambah harus dinonaktifkan karena kuantitas di keranjang sudah sama dengan stok
    final bool isMaxStockReached = currentQuantity >= widget.item.stock;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: widget.item.imagePath != null && widget.item.imagePath!.isNotEmpty
                  ? Image.asset(
                      'images/${widget.item.imagePath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 40),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.namaMakanan,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.formatCurrency(widget.item.harga),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Tampilkan stok
                        Text(
                          isStockZero ? "Stok Habis" : "Stok: ${widget.item.stock}",
                          style: TextStyle(
                            fontSize: 10,
                            color: isStockZero ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (currentQuantity > 0) {
                              widget.updateCart(widget.item, currentQuantity - 1);
                            }
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC35A2E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        Text(
                          currentQuantity.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          // Nonaktifkan tombol tambah jika stok 0 atau kuantitas di keranjang sudah sama dengan stok
                          onTap: isStockZero || isMaxStockReached
                              ? null // Jika kondisi true, onTap jadi null (dinonaktifkan)
                              : () {
                                  widget.updateCart(widget.item, currentQuantity + 1);
                                },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isStockZero || isMaxStockReached
                                  ? Colors.grey // Warna abu-abu jika dinonaktifkan
                                  : const Color(0xFFC35A2E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.add,
                              color: isStockZero || isMaxStockReached ? Colors.grey[300] : Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}