import 'package:firebase_core/firebase_core.dart';
import 'package:laxtop/init/SystemInit.dart';

class InitFirebase extends ProcessInit {
  List<Type> after() => [];

  Future<void> init() async {
    await Firebase.initializeApp();
  }
}
