# 🛒 Smart Billing App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Offline First](https://img.shields.io/badge/Architecture-Offline_First-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Build-v1.0.0_Stable-success?style=for-the-badge)

A lightning-fast, offline-first Point of Sale (POS) and inventory management application built with Flutter. Designed for seamless retail operations, it features instant barcode scanning, permanent local caching, and native ESC/POS hardware integration for wireless thermal printing.

---

## ✨ Key Features

* **📴 Offline-First Architecture:** Powered by a robust local `SharedPreferences` database. No internet required to scan, bill, or print. Zero latency, zero cloud dependency.
* **🖨️ Native Hardware Printing:** Seamlessly pairs with standard 58mm Bluetooth Thermal Printers via ESC/POS byte commands for instant, professional receipt generation.
* **📦 Dynamic Inventory Management:** Interactive bottom-sheet explorer with swipe-to-delete functionality and inline price modifiers.
* **🧠 Smart Cart Engine:** Rapid item counting, real-time total calculations, and intelligent duplicate-scan detection to prevent checkout errors.
* **📊 Ledger & History:** A dedicated historical timeline view to audit past transactions, track daily sales totals, and effortlessly print duplicate invoices.
* **🎨 Premium Bento UI:** A modern, edge-to-edge dashboard layout optimized for speed, clarity, and one-handed mobile operations.

---

## 🚀 Installation 

### For End Users (Quick Install)
1. Go to the [Releases](../../releases) tab of this repository.
2. Download the latest `SmartBilling_vX.X.X.apk` file.
3. Install the APK on your Android device (you may need to allow "Install from Unknown Sources" in your settings).

### For Developers
To build this project from source:

1. Clone the repository:
   ```bash
   git clone [https://github.com/1bitVscoder/smart_billing_app.git](https://github.com/1bitVscoder/smart_billing_app.git)

   Navigate to the project directory:

Bash
cd smart_billing_app
Fetch Flutter dependencies:

Bash
flutter pub get
Run the app on your connected device or emulator:

Bash
flutter run
🛠️ Hardware Setup (Thermal Printing)
To use the physical receipt printing feature:

Turn on your 58mm Bluetooth Thermal Printer.

Pair the printer with your Android device via the native OS Bluetooth Settings.

Open the Smart Billing App and tap the Printer card on the dashboard.

Select your paired printer from the list and tap Connect.

Once the status light turns green, your checkout stream is physically armed!

👨‍💻 About the Developer
Soumya Ranjan Jana IoT & Systems Engineer • Computer Science Student at ITER (Siksha 'O' Anusandhan)

I specialize in building real-world distributed architectures, manual sorting loops, and AI-driven workflows. This application was engineered to demonstrate the power of local hardware integrations and edge-computing principles within mobile applications.

GitHub: @1bitVscoder
