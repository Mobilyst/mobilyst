import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilyst/Hesabim/hesabimPage.dart';
import 'package:mobilyst/GirisOlaylari/tabs/button/girisButton.dart';
import 'package:mobilyst/GirisOlaylari/tabs/secondSignUp.dart';
import 'package:mobilyst/GirisOlaylari/tabs/sifreUnuttumPage.dart';
import 'package:mobilyst/GirisOlaylari/tabs/textfield/testField.dart';
import 'package:mobilyst/homePage.dart';
import 'package:mobilyst/navigationBar.dart';
import '../girisPage.dart';

class SignInPage extends StatefulWidget {
  final TabController? tabController;
  const SignInPage({Key? key, this.tabController}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // text duzenleme kontrolleri
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //giris kulanici method
  Future<void> signUserIn() async {
    // yukleniyor
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Hata',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Lütfen tüm alanları doldurun.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // yukleniyordan cikis
                  Navigator.pop(context);
                },
                child: Text(
                  "Tamam",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((userCredential) {
      // yukleniyordan cikis
      Navigator.pop(context);
      // Oturum açma başarılı olduğunda yönlendirme işlemini gerçekleştir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HesabimPage()),
      );
    }).catchError((error) {
      // yukleniyordan cikis
      Navigator.pop(context);

      // Hata durumuna göre mesaj göster
      String errorMessage = 'Bir hata oluştu.';

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'wrong-password':
            errorMessage = 'Yanlış şifre.';
            break;
          case 'user-not-found':
            errorMessage = 'E-posta yanlış.';
            break;
          case 'invalid-email':
            errorMessage = 'Geçersiz e-posta formatı.';
            break;
          case 'user-not-found':
            errorMessage = 'Kullanıcı bulunamadı.';
            break;
          case 'user-disabled':
            errorMessage = 'Kullanıcı hesabı devre dışı bırakıldı.';
            break;
          case 'too-many-requests':
            errorMessage =
                'Çok fazla istek yapıldı. Lütfen daha sonra tekrar deneyin.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Bu işlem izin verilmiyor.';
            break;
          // Diğer hata durumlarına göre gerekirse eklemeler yapabilirsiniz.
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Hata',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // İletişim kutusunu kapat
              },
              child: Text(
                "Tamam",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 88,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(
                      left: 25), // Başlangıçtan sağa boşluk ekleyin
                  child: Text(
                    'E-posta',
                    style: TextStyle(
                      fontSize: 15, // Metin boyutunu 18 olarak ayarlar
                      fontWeight: FontWeight.normal, // Metni kalınlaştırır
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            //email textfield
            MyTextField(
              controller: emailController,
              hintText: 'Lütfen e-posta adresi giriniz',
              obscureText: false,
              // ??
            ),

            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(
                      left: 25), // Başlangıçtan sağa boşluk ekleyin
                  child: Text(
                    'Şifre',
                    style: TextStyle(
                      fontSize: 15, // Metin boyutunu 18 olarak ayarlar
                      fontWeight: FontWeight.normal, // Metni kalınlaştırır
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            //sifre textfield
            MyTextField(
              controller: passwordController, //??
              hintText: 'Lütfen parola giriniz',
              obscureText: true, // gizliyor yazilan seyleri
            ),

            const SizedBox(
              height: 10,
            ),

            // sifreyi unutma
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MyForgetPasswordPage();
                        },
                      ));
                    }, //??
                    child: const Text(
                      'Şifremi Unuttum',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //kayit olma button
            MyButton(
              onTap: signUserIn,
              text: 'Giriş Yap', //??
            ),

            const SizedBox(
              height: 25,
            ),

            // uye degilmisin kayit ol
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' Henüz üye değil misiniz?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  //birseyleri butona cevirmeye yariyor
                  onTap: () {
                    widget.tabController
                        ?.animateTo(1); // Tab bar'da ikinci sekmeye geçiş yap
                  }, //??
                  child: const Text(
                    'Üye ol',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}