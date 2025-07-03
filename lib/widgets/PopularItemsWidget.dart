import 'package:baked/controllers/menu_controller.dart' as app_menu_controller;
import 'package:baked/controllers/order_controller.dart';
import 'package:baked/models/katalog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PopularItemsWidget extends StatelessWidget {
  String formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Consumer2<app_menu_controller.MenuController, OrderController>(
      builder: (context, menuController, orderController, child) {
        if (menuController.menuItems.isEmpty) {
          return const Center(child: Text("No menu items available."));
        }

        Map<String, int> mostSoldItemIds = orderController.getMostSoldItemIds();

        List<MapEntry<String, int>> sortedSoldItems = mostSoldItemIds.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        List<String> topSoldKatalogIds = sortedSoldItems
            .take(4)
            .map((entry) => entry.key)
            .toList();

        List<Katalog> bestSellerItems = [];
        for (String idMakanan in topSoldKatalogIds) {
          // --- PERBAIKI DI SINI: Gunakan firstWhereOrNull ---
          Katalog? item = menuController.menuItems.firstWhereOrNull(
            (katalogItem) => katalogItem.id == idMakanan,
          );
          if (item != null) {
            bestSellerItems.add(item);
          }
        }

        if (bestSellerItems.isEmpty) {
          bestSellerItems = menuController.menuItems.take(4).toList();
          if (bestSellerItems.isEmpty) {
             return const Center(child: Text("No best seller items yet."));
          } else {
             print("Falling back to first 4 menu items as no sales data.");
          }
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Our Best Seller",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: bestSellerItems.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(top: 80, right: 15, left: 25),
                    width: 320,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(251, 187, 88, 1),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -height * 0.17,
                          left: width * 0.01,
                          child: item.imagePath != null && item.imagePath!.isNotEmpty
                              ? Image(
                                  height: 280,
                                  width: 300,
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'images/${item.imagePath}',
                                  ),
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 280),
                                )
                              : const Icon(Icons.image, size: 280),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 60),
                              Text(
                                formatCurrency(item.harga),
                                style: const TextStyle(
                                  color: Color.fromRGBO(195, 90, 45, 1),
                                  fontFamily: 'Baloo Chettan',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item.namaMakanan,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  item.deskripsi,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(195, 90, 45, 1),
                                    fontFamily: 'Baloo Chettan',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}