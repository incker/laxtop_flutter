import 'package:firebase_core/firebase_core.dart';
import 'package:laxtop/init/SystemInit.dart';

class InitFirebase extends ProcessInit {
  List<Type> after() => List(0);

  Future<void> init() async {
    await Firebase.initializeApp();
  }
}
