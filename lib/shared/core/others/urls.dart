import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CoreAppUrls {
  // static String webSocketUrl =
  //     "wss://afa9c347-a29b-46a6-8d53-4a526b430d9c-00-3vyzookhufa6u.pike.replit.dev/";
  static String webSocketUrl = "wss://webchotuws.dodoozy.com/";
  static String dioUrl = "https://doozystart.dodoozy.com/";
  static const baseUrl = "https://ultimate.dodoozy.com";

  static String accessToken =
      "eyJhbGciOiJIUzI1NiIsImtpZCI6ImdaZm9vT2VVdDFLZC9GOWgiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzEyOTE2NjU4LCJpYXQiOjE3MTI5MTMwNTgsImlzcyI6Imh0dHBzOi8vanp1emN4dnVzZGh5cmFheWRiYmQuc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6Ijk0YzVhZmM5LTdlYTItNDY5OC1hZGExLTNhMzg0YWRhNDU0MSIsImVtYWlsIjoiIiwicGhvbmUiOiI5MTgxNjkzNzcwNTgiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJwaG9uZSIsInByb3ZpZGVycyI6WyJwaG9uZSJdfSwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInBob25lX3ZlcmlmaWVkIjpmYWxzZSwic3ViIjoiOTRjNWFmYzktN2VhMi00Njk4LWFkYTEtM2EzODRhZGE0NTQxIn0sInJvbGUiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib3RwIiwidGltZXN0YW1wIjoxNzEyOTEzMDU4fV0sInNlc3Npb25faWQiOiJlYWFhMjM4Zi1iNTg0LTQ3ODYtODQ3MS0xZTJkNWMwOWY0ZjciLCJpc19hbm9ueW1vdXMiOmZhbHNlfQ.u2b4IaTjxNKERjGsSaLlvWZV3HPrGCZgdmPUrMbmoXs";
  static const String APIKEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6dXpjeHZ1c2RoeXJhYXlkYmJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI1NjMyMjksImV4cCI6MjAyODEzOTIyOX0.yZ-XfDZ9C6gFkiRVIX8JboGNh_lX_5Qzs5EZ7vCwELs";

  static const String APIURL = "https://jzuzcxvusdhyraaydbbd.supabase.co";

  // static SupabaseClient supabaseClient = SupabaseClient(APIURL, APIKEY);

  static late Supabase supabase;

  static User? user;
  static Session? session;

  static WebSocketChannel? channel;
}
