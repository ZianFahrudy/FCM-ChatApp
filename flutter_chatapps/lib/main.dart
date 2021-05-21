import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/app_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppWidgets());
}
