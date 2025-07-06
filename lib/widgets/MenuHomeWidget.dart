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

  // Modifikasi updateCart untuk passing context
  void updateCart(BuildContext context, Katalog item, int quantity) { // TAMBAHKAN BuildContext context di sini
    if (mounted) {
      try {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        Order order = Order(
          name: item.namaMakanan,
          price: item.harga.toDouble(),
          quantity: quantity,
          imagePath: item.imagePath,
        );
        // Panggil updateOrderQuantity dengan context
        orderProvider.updateOrderQuantity(context, order, quantity); // PASS context ke OrderProvider
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
              height: 350, // Pastikan tinggi ini cukup untuk item Anda
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
                    // Sesuaikan updateCart di sini untuk passing context
                    updateCart: (Katalog item, int quantity) => updateCart(context, item, quantity), // PASS context
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

// MenuHomeItemWidget tetap sama
class MenuHomeItemWidget extends StatefulWidget {
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
  _MenuHomeItemWidgetState createState() => _MenuHomeItemWidgetState();
}

class _MenuHomeItemWidgetState extends State<MenuHomeItemWidget> {
  // `quantity` sekarang akan langsung mencerminkan nilai dari OrderProvider
  // tidak perlu `initState` atau `didChangeDependencies` untuk inisialisasi awal.

  @override
  Widget build(BuildContext context) {
    // DENGAR PERUBAHAN ORDERPROVIDER LANGSUNG DI BUILD METHOD
    final currentQuantity = Provider.of<OrderProvider>(context, listen: true)
        .getOrderQuantity(widget.item.namaMakanan);

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
                          // Harga yang ditampilkan harus harga per item, bukan total
                          // atau total jika quantity > 0
                          widget.formatCurrency(widget.item.harga),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
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
                            if (currentQuantity > 0) { // Gunakan currentQuantity
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
                          currentQuantity.toString(), // Tampilkan currentQuantity
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            widget.updateCart(widget.item, currentQuantity + 1); // Gunakan currentQuantity
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC35A2E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
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