import 'package:alisveris_sitesi/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alisveris_sitesi/services/favorite_service.dart';
import 'package:alisveris_sitesi/services/cart_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('tr_TR', null);

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
        ),
        ChangeNotifierProvider(create: (context) => FavoriteService()),
        ChangeNotifierProvider(create: (context) => CartService()),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homescreen(),
      title: 'ShopHub',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
