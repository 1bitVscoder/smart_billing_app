import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/billing_controller.dart';

class SalesHistoryView extends StatefulWidget {
  const SalesHistoryView({super.key});

  @override
  State<SalesHistoryView> createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryView> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String dateStr = _selectedDate.toIso8601String().split('T')[0];
    final controller = Provider.of<BillingController>(context);
    final daySales = controller.salesHistory[dateStr] ?? [];

    double dayTotalSum = daySales.fold(0.0, (sum, sale) => sum + (sale['total'] as num).toDouble());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Sales Ledger', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFE8EBF0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Selected Audit Date", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.calendar_today_rounded, size: 16),
                    label: const Text("Change"),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${daySales.length} checkouts completed", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                Text("Total: ₹${dayTotalSum.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: daySales.isEmpty
                ? const Center(child: Text("No transactions recorded on this date.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: daySales.length,
                    itemBuilder: (context, index) {
                      final sale = daySales[index];
                      final itemsList = sale['items'] as List;
                      
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFE8EBF0)),
                        ),
                        child: ExpansionTile(
                          title: Text("Invoice #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Amount Received: ₹${(sale['total'] as num).toStringAsFixed(2)}", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500)),
                          leading: const Icon(Icons.receipt_long_rounded, color: Colors.black54),
                          children: [
                            // 1. The Itemized Preview
                            ...itemsList.map((item) {
                              return ListTile(
                                title: Text(item['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                trailing: Text("${item['qty']}x  -  ₹${(item['price'] * item['qty']).toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey)),
                              );
                            }),
                            const Divider(color: Colors.black12, height: 1),
                            
                            // 🚀 FIXED: The New Print Duplicate Invoice Button
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (controller.isPrinterConnected) {
                                      controller.printPastReceipt(sale);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Printing duplicate receipt... 🖨️")));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Printer offline! Connect via dashboard first.", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.orange),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.print_rounded, size: 18),
                                  label: const Text("Print Duplicate Receipt", style: TextStyle(fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE8F5E9), // Light green background
                                    foregroundColor: Colors.green[800], // Dark green text
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}