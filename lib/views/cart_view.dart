import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/billing_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Basket Checkout', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Consumer<BillingController>(
        builder: (context, controller, child) {
          if (controller.cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your basket is empty.\nGo scan some snacks! 🍫',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.4),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    
                    return Dismissible(
                      key: Key(item.barcode),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                      ),
                      onDismissed: (direction) {
                        controller.removeCartItem(item.barcode, context, item.name);
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFE8EBF0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('₹${item.price.toStringAsFixed(2)} each', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                              
                              // Sleek manual item quantity increment/decrement steppers
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F7FB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18, color: Colors.black87),
                                      onPressed: () => controller.decrementQuantity(item.barcode, context),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18, color: Colors.black87),
                                      onPressed: () => controller.incrementQuantity(item.barcode),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4))],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                          Text(
                            '₹${controller.totalCartAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent, letterSpacing: -0.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.finalizeCheckout(); // Commit variables into historical record database arrays
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: const Text("Transaction Confirmed"),
                                content: const Text("Receipt generated and committed to sales history database! 🖨️"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Done"),
                                  )
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Text('Checkout Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}