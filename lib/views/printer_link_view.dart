import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../controllers/billing_controller.dart';

class PrinterLinkView extends StatefulWidget {
  const PrinterLinkView({super.key});

  @override
  State<PrinterLinkView> createState() => _PrinterLinkViewState();
}

class _PrinterLinkViewState extends State<PrinterLinkView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillingController>(context, listen: false).scanForPrinters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Printer Setup', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Consumer<BillingController>(
            builder: (context, controller, child) {
              return IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => controller.scanForPrinters(),
              );
            },
          )
        ],
      ),
      body: Consumer<BillingController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection Status Bento Block (FIXED Hex Color Code Formatting)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: controller.isPrinterConnected ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.isPrinterConnected ? Icons.print_rounded : Icons.print_disabled_rounded,
                        color: controller.isPrinterConnected ? Colors.green : Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.isPrinterConnected ? "Hardware Connected" : "Printer Offline",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.isPrinterConnected
                                  ? "Active Link: ${controller.connectedDevice?.name}"
                                  : "Select a paired 58mm thermal device below",
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      if (controller.isPrinterConnected)
                        ElevatedButton(
                          onPressed: () => controller.disconnectPrinter(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Disconnect"),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  "PAIRED DEVICES",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: controller.discoveredDevices.isEmpty
                      ? const Center(
                          child: Text(
                            "No paired Bluetooth printers found.\nPlease pair your thermal printer in Android System Settings first!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, height: 1.4),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.discoveredDevices.length,
                          itemBuilder: (context, index) {
                            BluetoothDevice device = controller.discoveredDevices[index];
                            bool isCurrent = controller.connectedDevice?.address == device.address;

                            return Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: Color(0xFFE8EBF0)), // FIXED Hex Color Code Formatting
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.bluetooth_audio_rounded, color: Colors.blueAccent),
                                title: Text(device.name ?? "Unknown Device", style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(device.address ?? ""),
                                trailing: isCurrent
                                    ? const Icon(Icons.check_circle_rounded, color: Colors.green)
                                    : ElevatedButton(
                                        onPressed: () => controller.connectToPrinter(device),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: const Text("Connect"),
                                      ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}