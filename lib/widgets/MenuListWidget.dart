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
        // PERUBAHAN UTAMA DI SINI: Gunakan filteredMenuItems
        List<Katalog> displayedItems = menuController.filteredMenuItems;

        if (displayedItems.isEmpty) { // Cek jika filteredItems kosong
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No menu items available.")),
          );
        }

        if (widget.limit > 0 && displayedItems.length > widget.limit) {
          displayedItems = displayedItems.take(widget.limit).toList();
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

// MenuItemWidget tetap sama seperti yang sudah saya berikan sebelumnya
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

    final int displayedStock = widget.item.stock - currentQuantity;

    final bool isDisplayedStockZero = displayedStock <= 0;

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
                        Text(
                          isDisplayedStockZero ? "Out of stock" : "Stock: $displayedStock",
                          style: TextStyle(
                            fontSize: 10,
                            color: isDisplayedStockZero ? Colors.red : Colors.green,
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
                          onTap: isDisplayedStockZero
                              ? null
                              : () {
                                  widget.updateCart(widget.item, currentQuantity + 1);
                                },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDisplayedStockZero
                                  ? Colors.grey
                                  : const Color(0xFFC35A2E),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.add,
                              color: isDisplayedStockZero ? Colors.grey[300] : Colors.white,
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