// lib/services/database_service.dart

import 'package:baked/models/customer.dart';
import 'package:baked/models/kasir.dart';
import 'package:baked/models/katalog.dart';
import 'package:baked/models/order.dart' as app_order_model; // Alias untuk model Order Anda
import 'package:baked/models/pembayaran.dart'; // Import model Pembayaran
import 'package:baked/models/shift.dart'; // Import model Shift
import 'package:baked/models/transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String CUSTOMERS_COLLECTION = 'customers';
  static const String KASIR_COLLECTION = 'kasir';
  static const String KATALOG_COLLECTION = 'katalog';
  static const String TRANSAKSI_COLLECTION = 'transaksi';
  static const String ORDERS_COLLECTION = 'orders'; // Untuk kumpulan pesanan transaksi (Firestore)
  static const String SHIFTS_COLLECTION = 'shifts'; // Untuk definisi shift (Firestore)
  static const String PEMBAYARAN_COLLECTION = 'pembayaran'; // Untuk data pembayaran (Firestore)

  // Customer Operations
  Future<void> createCustomer(Customer customer) async {
    try {
      // Jika customer.id adalah null, Firestore akan auto-generate ID dokumen.
      // Jika customer.id ada, gunakan itu sebagai ID dokumen.
      // Pastikan customer.id adalah String?
      await _firestore
          .collection(CUSTOMERS_COLLECTION)
          .doc(customer.id) // customer.id sudah String?
          .set(customer.toJson());
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  Future<Customer?> getCustomer(String id) async { // Parameter id harus String
    try {
      DocumentSnapshot doc = await _firestore
          .collection(CUSTOMERS_COLLECTION)
          .doc(id)
          .get();

      if (doc.exists) {
        return Customer.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get customer: $e');
    }
  }

  Future<Customer?> getCustomerByEmail(String email) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(CUSTOMERS_COLLECTION)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Customer.fromJson(query.docs.first.data() as Map<String, dynamic>, query.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get customer by email: $e');
    }
  }

  // Kasir Operations
  Future<void> createKasir(Kasir kasir) async {
    try {
      // Pastikan kasir.id adalah String?
      await _firestore
          .collection(KASIR_COLLECTION)
          .doc(kasir.id) // kasir.id sudah String?
          .set(kasir.toJson());
    } catch (e) {
      throw Exception('Failed to create kasir: $e');
    }
  }

  Future<Kasir?> getKasirByEmail(String email) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(KASIR_COLLECTION)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Kasir.fromJson(query.docs.first.data() as Map<String, dynamic>, query.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get kasir by email: $e');
    }
  }

  Stream<List<Kasir>> getAllKasirStream() {
    return _firestore
        .collection(KASIR_COLLECTION)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Kasir.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Katalog Operations (Asumsi sudah diatur oleh MenuController juga)
  Future<String> addKatalog(Katalog katalog) async { // addKatalog akan menghasilkan ID otomatis
    try {
      DocumentReference docRef = await _firestore
          .collection(KATALOG_COLLECTION)
          .add(katalog.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add katalog: $e');
    }
  }

  Future<void> updateKatalog(Katalog katalog) async {
    try {
      if (katalog.id == null) {
        throw Exception('Cannot update katalog without an ID.');
      }
      await _firestore
          .collection(KATALOG_COLLECTION)
          .doc(katalog.id!) // Gunakan ! karena sudah dicek tidak null
          .update(katalog.toJson());
    } catch (e) {
      throw Exception('Failed to update katalog: $e');
     fungicide('Failed to update katalog: $e');
    }
  }

  Future<void> deleteKatalog(String id) async { // Parameter id harus String
    try {
      await _firestore
          .collection(KATALOG_COLLECTION)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete katalog: $e');
    }
  }

  Stream<List<Katalog>> getAllKatalogStream() {
    return _firestore
        .collection(KATALOG_COLLECTION)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Katalog.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<List<Katalog>> getAllKatalog() async {
    try {
      QuerySnapshot query = await _firestore
          .collection(KATALOG_COLLECTION)
          .get();

      return query.docs
          .map((doc) => Katalog.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all katalog: $e');
    }
  }

  Stream<List<Katalog>> getKatalogByCategory(String category) {
    return _firestore
        .collection(KATALOG_COLLECTION)
        .where('kategori', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Katalog.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Transaksi Operations
  Future<String> createTransaksi(Transaksi transaksi) async {
    try {
      // Pastikan transaksi.id adalah String?
      DocumentReference docRef = await _firestore
          .collection(TRANSAKSI_COLLECTION)
          .add(transaksi.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create transaksi: $e');
    }
  }

  Stream<List<Transaksi>> getTransaksiByCustomer(String customerId) { // Parameter customerId harus String
    return _firestore
        .collection(TRANSAKSI_COLLECTION)
        .where('customer_id', isEqualTo: customerId)
        .orderBy('tanggal_order', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaksi.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<Transaksi>> getAllTransaksiStream() {
    return _firestore
        .collection(TRANSAKSI_COLLECTION)
        .orderBy('tanggal_order', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaksi.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<List<Transaksi>> getTransaksiByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(TRANSAKSI_COLLECTION)
          .where('tanggal_order', isGreaterThanOrEqualTo: startDate)
          .where('tanggal_order', isLessThanOrEqualTo: endDate)
          .orderBy('tanggal_order', descending: true)
          .get();

      return query.docs
          .map((doc) => Transaksi.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get transaksi by date range: $e');
    }
  }

  // Pembayaran Operations
  Future<String> createPembayaran(Pembayaran pembayaran) async {
    try {
      // Pastikan pembayaran.id adalah String?
      DocumentReference docRef = await _firestore
          .collection(PEMBAYARAN_COLLECTION)
          .add(pembayaran.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create pembayaran: $e');
    }
  }

  // Shift Operations (Tambahan, jika perlu diakses selain dari ShiftController)
  Future<String> addShift(Shift shift) async {
    try {
      // Pastikan shift.id adalah String?
      DocumentReference docRef = await _firestore
          .collection(SHIFTS_COLLECTION)
          .add(shift.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add shift: $e');
    }
  }

  Stream<List<Shift>> getAllShiftsStream() {
    return _firestore
        .collection(SHIFTS_COLLECTION)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Shift.fromJson(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Order Operations (for real-time orders/penjualan, bukan keranjang)
  // Ini adalah untuk mencatat keseluruhan order yang sudah selesai/diproses
  Future<String> createOrder(List<app_order_model.Order> orders, String customerId, String kasirId) async {
    try {
      Map<String, dynamic> orderData = {
        'customer_id': customerId,
        'kasir_id': kasirId,
        'orders': orders.map((order) => order.toJson()).toList(),
        'total_amount': orders.fold(0.0, (sum, order) => sum + (order.price * order.quantity)),
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
      };

      DocumentReference docRef = await _firestore
          .collection(ORDERS_COLLECTION)
          .add(orderData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getPendingOrdersStream() {
    return _firestore
        .collection(ORDERS_COLLECTION)
        .where('status', isEqualTo: 'pending')
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
            .toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection(ORDERS_COLLECTION)
          .doc(orderId)
          .update({
        'status': status,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Analytics
  Future<Map<String, double>> getDailySalesReport(DateTime date) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot query = await _firestore
          .collection(TRANSAKSI_COLLECTION)
          .where('tanggal_order', isGreaterThanOrEqualTo: startOfDay)
          .where('tanggal_order', isLessThanOrEqualTo: endOfDay)
          .orderBy('tanggal_order', descending: true)
          .get();

      double totalSales = 0;
      int totalTransactions = query.docs.length;

      for (var doc in query.docs) {
        Transaksi transaksi = Transaksi.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        totalSales += transaksi.subtotal;
      }

      return {
        'total_sales': totalSales,
        'total_transactions': totalTransactions.toDouble(),
      };
    } catch (e) {
      throw Exception('Failed to get daily sales report: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTopSellingItems(int limit) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(TRANSAKSI_COLLECTION)
          .limit(100)
          .get();

      Map<String, Map<String, dynamic>> itemSales = {};

      for (var doc in query.docs) {
        Transaksi transaksi = Transaksi.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        String itemId = transaksi.idMakanan; // Ini sudah String, tidak perlu toString()

        if (itemSales.containsKey(itemId)) {
          itemSales[itemId]!['quantity'] += transaksi.quantity;
          itemSales[itemId]!['total_sales'] += transaksi.subtotal;
        } else {
          itemSales[itemId] = {
            'id_makanan': itemId,
            'quantity': transaksi.quantity,
            'total_sales': transaksi.subtotal,
          };
        }
      }

      List<Map<String, dynamic>> sortedItems = itemSales.values.toList();
      sortedItems.sort((a, b) => b['quantity'].compareTo(a['quantity']));

      return sortedItems.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get top selling items: $e');
    }
  }
}