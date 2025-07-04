import 'package:baked/controllers/order_controller.dart';
import 'package:baked/models/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionHistoryPage extends StatelessWidget {
  final String? customerId; // <--- TAMBAHKAN INI (Opsional, untuk filter per pelanggan)

  const TransactionHistoryPage({Key? key, this.customerId}) : super(key: key); // <--- TAMBAHKAN INI

  String formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customerId != null ? "My Order History" : "Transaction History"), // Ubah judul
        centerTitle: true,
        backgroundColor: const Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<OrderController>(
        builder: (context, orderController, child) {
          List<Transaksi> filteredTransactions = orderController.transaksiItems;

          // --- LOGIKA FILTER TRANSAKSI PER PELANGGAN ---
          if (customerId != null && customerId!.isNotEmpty) {
            filteredTransactions = filteredTransactions
                .where((transaksi) => transaksi.idCustomer == customerId)
                .toList();
          }
          // ---------------------------------------------

          if (filteredTransactions.isEmpty) {
            return const Center(
              child: Text("No transactions recorded yet for this user."), // Ubah pesan
            );
          }

          // Group transaksi berdasarkan idOrder (untuk mengelompokkan item dalam satu pesanan)
          Map<String, List<Transaksi>> groupedTransactions = {};
          for (var transaksi in filteredTransactions) { // Gunakan filteredTransactions
            groupedTransactions.putIfAbsent(transaksi.idOrder, () => []).add(transaksi);
          }

          List<String> sortedOrderIds = groupedTransactions.keys.toList();
          sortedOrderIds.sort((a, b) {
            DateTime dateA = groupedTransactions[a]![0].tanggalOrder;
            DateTime dateB = groupedTransactions[b]![0].tanggalOrder;
            return dateB.compareTo(dateA);
          });


          return ListView.builder(
            itemCount: sortedOrderIds.length,
            itemBuilder: (context, index) {
              String orderId = sortedOrderIds[index];
              List<Transaksi> transactionsInOrder = groupedTransactions[orderId]!;

              double totalOrderPrice = transactionsInOrder.fold(0.0, (sum, item) => sum + item.totalHargaItem);

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: $orderId",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Date: ${DateFormat('dd-MM-yyyy HH:mm').format(transactionsInOrder[0].tanggalOrder)}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      Text(
                        "Customer ID: ${transactionsInOrder[0].idCustomer}", // Tetap tampilkan Customer ID
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const Divider(),
                      ...transactionsInOrder.map((transaksi) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              transaksi.imagePath != null && transaksi.imagePath!.isNotEmpty
                                  ? Image.asset('images/${transaksi.imagePath!}', width: 30, height: 30, fit: BoxFit.cover)
                                  : const Icon(Icons.image, size: 30),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${transaksi.namaMakanan} x${transaksi.jumlahItem}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                formatCurrency(transaksi.totalHargaItem),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Total: ${formatCurrency(totalOrderPrice)}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC35A2E)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}