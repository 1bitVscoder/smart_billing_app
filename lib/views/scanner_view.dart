import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../controllers/billing_controller.dart';
import 'cart_view.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final MobileScannerController cameraController = MobileScannerController();
  
  // Guard flag to prevent duplicate frame analysis execution loops
  bool _isProcessingScan = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final billingController = Provider.of<BillingController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Scan Billing', 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)
        ),
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            color: Colors.black87,
            icon: const Icon(Icons.flash_on_rounded),
            iconSize: 24.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Full-screen Camera Viewfinder Stream
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              
              if (barcodes.isNotEmpty && !_isProcessingScan) {
                final String? rawValue = barcodes.first.rawValue;
                
                if (rawValue != null) {
                  setState(() {
                    _isProcessingScan = true; // Lock local thread
                  });

                  // ⚡ INSTANT ACTION: Play the auditory "Ting!" confirmation sound immediately on detection
                  await billingController.playTingSound();

                  try {
                    // HARDWARE LOCK: Freeze the camera stream frames immediately to prevent double-scanning
                    await cameraController.stop(); 

                    // Pass the raw data token down to our persistent hybrid engine
                    if (mounted) {
                      await billingController.processScannedBarcode(rawValue, context);
                    }
                  } catch (e) {
                    debugPrint("Camera state frame processing error: $e");
                  } finally {
                    // Tiny decompression buffer delay to let the UI/popups settle down cleanly
                    await Future.delayed(const Duration(milliseconds: 400));

                    // Wake up the hardware camera frame stream feed again
                    if (mounted) {
                      await cameraController.start();
                      setState(() {
                        _isProcessingScan = false; // Release lock for next unique asset capture
                      });
                    }
                  }
                }
              }
            },
          ),

          // 2. Translucent Aiming Reticle Overlay (Bento Minimalist Styling)
          Center(
            child: Container(
              width: 260,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 3),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  )
                ]
              ),
            ),
          ),

          // 3. Bottom Quick-Summary Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<BillingController>(
              builder: (context, controller, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, 
                        blurRadius: 15, 
                        offset: Offset(0, -4)
                      )
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${controller.cartItems.length} unique items added',
                              style: const TextStyle(
                                fontSize: 14, 
                                color: Colors.grey, 
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${controller.totalCartAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.blueAccent,
                                letterSpacing: -0.5
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CartView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 20),
                          label: const Text(
                            'Review Order', 
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
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