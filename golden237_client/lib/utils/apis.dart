import 'package:supabase_flutter/supabase_flutter.dart';

const String serverUrl = 'https://flugbvlkubwicelziitq.supabase.co';
const String flutterPublicKey = 'FLWPUBK-80dbc8752ce16374dfb957a3750c0749-X';
const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmF'
    'zZSIsInJlZiI6ImZsdWdidmxrdWJ3aWNlbHppaXRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk'
    'wNDkyMjYsImV4cCI6MTk5NDYyNTIyNn0.9X2mno77YfpFp9cKBVkfQx_PhkSy2GtbuXQkY4qjm1o';




class Apis {
  static final client = Supabase.instance.client;
}
