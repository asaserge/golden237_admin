import 'package:supabase_flutter/supabase_flutter.dart';

const String serverUrl = 'https://nqosbcutvdfbiclxqvyx.supabase.co';
const String flutterPublicKey = '';
const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5xb3NiY3V0dmRmYmljbHhxdnl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODMyODAwMDEsImV4cCI6MTk5ODg1NjAwMX0.KozRzAkZZQ287gD0ch1kXNfZJ3MNOb-lwIH2DRQXhCc';




class Apis {
  static final client = Supabase.instance.client;
}
