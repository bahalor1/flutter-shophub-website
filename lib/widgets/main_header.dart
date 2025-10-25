import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:alisveris_sitesi/views/favorites_screen.dart";
import 'package:provider/provider.dart';
import 'package:alisveris_sitesi/services/cart_service.dart';
import 'package:alisveris_sitesi/views/cart_screen.dart';
import 'package:alisveris_sitesi/views/login_screen.dart';
import 'package:alisveris_sitesi/views/profile_screen.dart';
import 'package:alisveris_sitesi/views/admin_screen.dart';

const String adminEmail = 'admin@hotmail.com';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  final ScrollController? scrollController;
  final Function(String) onSearchChanged;
  final TextEditingController? searchController;
  final VoidCallback onLogoTap;

  const MainHeader({
    super.key,
    this.scrollController,
    required this.onSearchChanged,
    this.searchController,
    required this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final bool isLoggedIn = user != null;

    return Container(
      color: Color(0xFF1D2951),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 300),
              InkWell(
                onTap: onLogoTap,

                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: const [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: Color.fromARGB(255, 45, 137, 212),
                      size: 32,
                    ),
                    SizedBox(width: 5),

                    Text(
                      "ShopHub",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Aradığınız ürün, marka veya kategori...",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.favorite_border, color: Colors.white),
                tooltip: "Favorilerim",
              ),
              Consumer<CartService>(
                builder: (context, cart, child) {
                  return Tooltip(
                    message: 'Sepetim',
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 23,
                              ),
                            ),

                            if (cart.itemCount > 0)
                              Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.cyan,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${cart.itemCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (isLoggedIn) ...[
                PopupMenuButton<String>(
                  tooltip: 'Hesabım',
                  onSelected: (value) async {
                    if (value == 'logout') {
                      await FirebaseAuth.instance.signOut();
                    } else if (value == 'profile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    } else if (value == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminScreen(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuEntry<String>> menuItems = []; // Boş liste

                    menuItems.add(
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Profilim'),
                        ),
                      ),
                    );
                    menuItems.add(const PopupMenuDivider());

                    if (user.email == adminEmail) {
                      menuItems.add(
                        const PopupMenuItem<String>(
                          value: 'admin',
                          child: ListTile(
                            leading: Icon(Icons.admin_panel_settings),
                            title: Text('Admin Paneli'),
                          ),
                        ),
                      );
                      menuItems.add(const PopupMenuDivider());
                    }

                    menuItems.add(
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Çıkış Yap'),
                        ),
                      ),
                    );

                    return menuItems;
                  },

                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    foregroundColor: Color(0xFF1D2951),
                    radius: 18,
                    child: Text(
                      user.displayName?.isNotEmpty == true
                          ? user.displayName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ] else ...[
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.person, size: 25),
                  label: const Text('Giriş Yap'),
                ),
              ],
              const SizedBox(width: 300),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
