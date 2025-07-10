import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> main() async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(_router);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('User API server running on http://${server.address.host}:${server.port}');
}

Future<Response> _router(Request request) async {
  if (request.url.path == 'users' && request.method == 'GET') {
    final file = File('user_data.json');
    if (!await file.exists()) {
      return Response.ok(jsonEncode([]), headers: {'Content-Type': 'application/json'});
    }
    final content = await file.readAsString();
    return Response.ok(content, headers: {'Content-Type': 'application/json'});
  }
  if (request.url.path == 'users' && request.method == 'DELETE') {
    final body = await request.readAsString();
    final data = jsonDecode(body);
    final email = data['email'];
    final file = File('user_data.json');
    if (!await file.exists()) {
      return Response.notFound('User data not found');
    }
    final users = jsonDecode(await file.readAsString()) as List;
    users.removeWhere((u) => u['email'] == email);
    await file.writeAsString(jsonEncode(users));
    return Response.ok(jsonEncode({'success': true}), headers: {'Content-Type': 'application/json'});
  }
  return Response.notFound('Not Found');
}

