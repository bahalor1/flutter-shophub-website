# ShopHub E-Ticaret Uygulaması (Flutter & Firebase)

Bu proje, Flutter framework'ü kullanılarak geliştirilmiş modern bir e-ticaret web uygulamasıdır. Backend hizmetleri için Google Firebase platformu (Authentication, Firestore) kullanılmıştır. Uygulama, temel e-ticaret işlevlerini barındırmaktadır ve hala geliştirme aşamasındadır.

##  Temel Özellikler

* **Kullanıcı Yönetimi:**
    * E-posta/Şifre ile Üye Olma
    * E-posta/Şifre ile Giriş Yapma
    * Şifremi Unuttum (E-posta ile Sıfırlama Bağlantısı)
    * Oturum Yönetimi (Giriş durumuna göre dinamik Header)
* **Ürün Kataloğu:**
    * Ürünleri Firestore veritabanından listeleme (Anlık güncellemeler için `StreamBuilder`)
    * Kategoriye Göre Filtreleme
    * Canlı Arama (Ürün adına göre)
* **Ürün Detay:**
    * Seçilen ürünün detaylı bilgilerini gösterme
    * Ürün görselleri, açıklama, fiyat, stok durumu
    * Benzer Ürünler önerisi (Aynı kategorideki diğer ürünler - Firestore'dan çekilir)
* **Favoriler Sistemi:**
    * Ürünleri favorilere ekleme/çıkarma (Ana sayfa kartları ve detay sayfası üzerinden)
    * Favoriler Sayfası (Kategoriye göre filtrelenebilir)
    * Favori durumu Firestore'da kullanıcıya özel saklanır (`FavoriteService` & `Provider`)
* **Alışveriş Sepeti:**
    * Ürünleri sepete ekleme (Ürün detay sayfasından)
    * Sepet Sayfası (Ürünleri listeleme, adet artırma/azaltma, ürünü silme)
    * Anlık olarak güncellenen Toplam Tutar gösterimi
    * Sepet içeriği Firestore'da kullanıcıya özel saklanır (`CartService` & `Provider`)
* **Sipariş Süreci:**
    * Alışverişi Tamamlama (Sepetteki ürünleri Firestore'da `orders` koleksiyonuna kaydeder ve sepeti temizler)
* **Kullanıcı Profili:**
    * Temel profil bilgileri gösterimi
    * Sipariş Geçmişi sayfası (Firestore'dan çekilen geçmiş siparişler)
    * Şifre Değiştirme (Sıfırlama e-postası gönderir)
    * Çıkış Yapma
* **Admin Paneli:**
    * Admin kullanıcısı için gizli panel erişimi (Belirli e-posta ile erişilir. Admin maili: admin@hotmail.com şifre: admin123) 
    * Yeni Ürün Ekleme formu (Firestore `products` koleksiyonuna yazar)
* **Arayüz (UI/UX):**
    * Tekrar kullanılabilir Header (`MainHeader`)
    * Ana sayfada kaydırılabilir Banner (`HomeBannerSlider`)
    * Animasyonlu Ürün Kartları (`ProductCard` - Üzerine gelince efektler)
    * Sabit boyutlu, responsive ürün ızgarası (`Wrap` widget'ı)
    * Temiz ve modern tasarım

## Kullanılan Teknolojiler

* **Frontend:** Flutter (Web), Dart
* **Backend:** Google Firebase
    * Firebase Authentication (Kimlik Doğrulama - Eposta/Şifre)
    * Cloud Firestore (NoSQL Veritabanı - Ürünler, Kullanıcı Verileri)
* **State Management (Durum Yönetimi):** Provider (`FavoriteService`, `CartService`, `User? StreamProvider`)
* **Temel Flutter Paketleri:**
    * `firebase_core`: Firebase'i başlatmak için.
    * `firebase_auth`: Kimlik doğrulama işlemleri için.
    * `cloud_firestore`: Firestore veritabanı işlemleri için.
    * `provider`: State management için.
    * `carousel_slider`: Ana sayfa banner'ı için.
    * `intl`: Tarih formatlama (Sipariş Geçmişi) için.
* **Geliştirme Ortamı:** Visual Studio Code
* **Versiyon Kontrol:** Git, GitHub

## Proje Yapısı (Özet)

* `lib/`: Ana Dart kodlarının bulunduğu klasör.
    * `main.dart`: Uygulamanın başlangıç noktası, Firebase ve Provider kurulumları.
    * `models/`: Veri modelleri (`cart_item_model.dart`). *Not: ProductModel'i kaldırdık, Map kullanıyoruz.*
    * `services/`: Backend (Firebase) ile iletişim ve iş mantığı (`cart_service.dart`, `favorite_service.dart`).
    * `views/`: Uygulamanın ana sayfaları (`homescreen.dart`, `product_detail_screen.dart`, `cart_screen.dart`, `login_screen.dart`, `admin_screen.dart` vb.).
    * `widgets/`: Tekrar kullanılabilir arayüz bileşenleri (`main_header.dart`, `product_card.dart`, `product_section.dart`, `homebannerslider.dart` vb.).
    * `firebase_options.dart`: Firebase bağlantı ayarları (Otomatik oluşturulur).
* `web/`: Web platformuna özel dosyalar.
* `pubspec.yaml`: Proje bağımlılıkları ve ayarları.
* `.gitignore`: Git'e hangi dosyaların gönderilmeyeceğini söyler.

## 📸 Ekran Görüntüleri

|   |   |   |
| :-: | :-: | :-: |
| ![](<img width="1917" height="1032" alt="1" src="https://github.com/user-attachments/assets/3b377d24-9dd7-48de-882f-fff6e8430b45" />
) | ![](<img width="1919" height="1030" alt="2" src="https://github.com/user-attachments/assets/33b46b44-04f3-4e59-bd7c-74a661d2ee58" />
) | ![](<img width="1920" height="1080" alt="3" src="https://github.com/user-attachments/assets/ed1e4d5b-ea74-4edd-b968-9e6f5736de66" />
) |
| ![](<img width="1920" height="1080" alt="4" src="https://github.com/user-attachments/assets/8bfc505d-c3ff-45ec-892f-50ebd4bb005b" />
) | ![](<img width="1919" height="1030" alt="5" src="https://github.com/user-attachments/assets/30d19eb1-6141-4071-9ac9-22ec498d4140" />
) | ![](<img width="1919" height="1031" alt="6" src="https://github.com/user-attachments/assets/2626e0b4-34bc-41ce-8220-d606af48a44d" />
) |
| ![](<img width="1919" height="1032" alt="7" src="https://github.com/user-attachments/assets/b9bbaf95-7a31-41ab-aa3a-80abe26b5fd2" />
) | ![](<img width="1919" height="1030" alt="8" src="https://github.com/user-attachments/assets/9e670696-fff8-439a-8263-e08db56812ef" />
) | ![](<img width="1919" height="1031" alt="9" src="https://github.com/user-attachments/assets/7f478e16-d969-4d76-b646-7f2afaf22e13" />
) |
| ![](<img width="1919" height="1028" alt="10" src="https://github.com/user-attachments/assets/1cc22acb-3ed3-4ee4-acb2-0e5c0ea5a955" />
) | ![](<img width="1919" height="1031" alt="11" src="https://github.com/user-attachments/assets/4cbcc18e-2635-4270-bd36-c3a8f6b57397" />
) | ![](<img width="1920" height="1031" alt="13" src="https://github.com/user-attachments/assets/1f482ef1-f273-4680-b526-e7dc17119a1d" />
) |
| ![](<img width="1920" height="1031" alt="14" src="https://github.com/user-attachments/assets/18acd36c-f85a-4246-acc3-6b2aedb0cd56" />
) | ![](<img width="1920" height="1031" alt="15" src="https://github.com/user-attachments/assets/482d64f2-b3d3-4866-b77e-3929df37fcfc" />
) | ![](<img width="1920" height="1031" alt="16" src="https://github.com/user-attachments/assets/bdd1d0ea-04a4-4ad0-98b0-4082f6803169" />
) |
| ![](<img width="1920" height="1032" alt="17" src="https://github.com/user-attachments/assets/a7dd1555-6b05-4d9c-8a23-024b5f987917" />
) | ![]() | ![]() |

*(**Not:** Yukarıdaki `link/to/your/screenshotX.png` kısımlarını kendi ekran görüntülerinizin URL'leri ile değiştirin.)*






##  Kurulum ve Çalıştırma

### Gereksinimler

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stabil kanal önerilir)
* [Git](https://git-scm.com/downloads)
* [Node.js](https://nodejs.org/en) (Firebase CLI için gereklidir)
* Firebase CLI: `npm install -g firebase-tools`
* FlutterFire CLI: `dart pub global activate flutterfire_cli`

### Firebase Kurulumu

1.  [Firebase Konsolu](https://console.firebase.google.com/)'nda yeni bir proje oluşturun.
2.  **Authentication:** "Get Started" -> "Sign-in method" sekmesinden "Email/Password" sağlayıcısını etkinleştirin.
3.  **Firestore Database:** "Get Started" -> "Standard edition" seçin -> Güvenlik kurallarını **"Start in test mode"** olarak başlatın -> Bir konum seçin (örn: `europe-west`).
4.  **`products` Koleksiyonu Oluşturma:** Firestore "Data" sekmesinde "+ Start collection" diyerek `products` adında bir koleksiyon oluşturun. İçine manuel olarak veya admin panelinden ürün dökümanları ekleyin. Her ürün şu alanları içermelidir (çoğu `string` olabilir): `name`, `brand`, `price`, `image`, `category`, `description`, `stock`, `tag`.
5.  *(Opsiyonel)* Admin kullanıcısını Authentication -> Users sekmesinden ekleyin ve e-posta adresini koddaki `adminEmail` sabiti ile eşleştirin.

### Frontend Kurulumu

1.  Bu repository'yi klonlayın:
    ```bash
    git clone [https://github.com/kullaniciadin/flutter-ecommerce-shophub.git](https://github.com/kullaniciadin/flutter-ecommerce-shophub.git) 
    cd flutter-ecommerce-shophub 
    ```
    *(URL'yi kendi GitHub repository URL'nizle değiştirin)*
2.  Gerekli Flutter paketlerini yükleyin:
    ```bash
    flutter pub get
    ```
3.  Flutter projesini Firebase projenize bağlayın:
    ```bash
    dart pub global run flutterfire_cli:flutterfire configure
    ```
    * Açılan listeden doğru Firebase projesini seçin.
    * Platform olarak **web**'i seçin. Bu işlem `lib/firebase_options.dart` dosyasını oluşturacaktır.
4.  *(Önemli)* `lib/main.dart` dosyasının `Firebase.initializeApp` kullandığından ve `firebase_options.dart`'ı import ettiğinden emin olun.

### Uygulamayı Çalıştırma

Uygulamayı web platformunda çalıştırmak için (CORS sorunlarını önlemek amacıyla CanvasKit renderer ile):
```bash
flutter run -d chrome --web-renderer canvaskit


