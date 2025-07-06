import 'package:baked/controllers/menu_controller.dart' as app_controller;
import 'package:baked/models/katalog.dart';
import 'package:baked/models/order.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MenuListWidget extends StatefulWidget {
  final int limit;

  const MenuListWidget({Key? key, this.limit = 0}) : super(key: key);

  @override
  _MenuListWidgetState createState() => _MenuListWidgetState();
}

class _MenuListWidgetState extends State<MenuListWidget> {
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

        List<Katalog> displayedItems = menuController.menuItems;
        if (widget.limit > 0 && menuController.menuItems.length > widget.limit) {
          displayedItems = menuController.menuItems.take(widget.limit).toList();
        }

        if (widget.limit > 0) {
          return Container(
            height: 350,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: displayedItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return MenuItemWidget(
                  key: ValueKey(displayedItems[index].namaMakanan),
                  item: displayedItems[index],
                  formatCurrency: formatCurrency,
                  updateCart: (Katalog item, int quantity) => updateCart(context, item, quantity),
                );
              },
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return MenuItemWidget(
                key: ValueKey(displayedItems[index].namaMakanan),
                item: displayedItems[index],
                formatCurrency: formatCurrency,
                updateCart: (Katalog item, int quantity) => updateCart(context, item, quantity),
              );
            },
          ),
        );
      },
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  final Katalog item;
  final String Function(double) formatCurrency;
  final void Function(Katalog, int) updateCart;

  const MenuItemWidget({
    Key? key,
    required this.item,
    required this.formatCurrency,
    required this.updateCart,
  }) : super(key: key);

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
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
                        // Tampilkan stok jika diperlukan
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
                            // Selalu bisa mengurangi jika quantity > 0
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
                          // Nonaktifkan tombol tambah jika stok 0 atau kuantitas di keranjang sama dengan stok
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
                              color: isStockZero || isMaxStockReached ? Colors.grey[300] : Colors.white, // Warna ikon
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