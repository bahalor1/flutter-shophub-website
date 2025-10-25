import 'package:alisveris_sitesi/views/homescreen.dart';
import 'package:alisveris_sitesi/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:alisveris_sitesi/widgets/main_header.dart';
import 'package:alisveris_sitesi/views/order_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: MainHeader(
        onSearchChanged: (query) {},
        onLogoTap: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 650, vertical: 150),
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 100.0,
            vertical: 30.0,
          ),
          children: [
            const Text(
              'Profilim',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade100,
                  child: Text(
                    user.displayName?.isNotEmpty == true
                        ? user.displayName![0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(user.displayName ?? 'İsim Belirtilmemiş'),
                subtitle: Text(user.email ?? 'E-posta Belirtilmemiş'),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.list_alt_outlined),
                title: const Text('Siparişlerim'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Şifre Değiştir'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: user.email!,
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Şifre sıfırlama e-postası gönderildi.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hata: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Çıkış Yap'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Homescreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
