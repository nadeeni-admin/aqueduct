import 'package:test/test.dart';
import '../lib/monadart.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

main() {

  var app = new Application();
  app.port = 8080;
  app.addControllerForPath(TController, "t");
  app.addControllerForPath(RController, "r");

  test("Application starts", () async {
    await app.start();
    expect(app.servers.length, 1);
  });

  ////////////////////////////////////////////

  test("Application responds to request", () async {
    var response = await http.get("http://localhost:8080/t");
    expect(response.statusCode, 200);
  });

  test("Application properly routes request", () async {
    var tResponse = await http.get("http://localhost:8080/t");
    var rResponse = await http.get("http://localhost:8080/r");

    expect(tResponse.body, '"t_ok"');
    expect(rResponse.body, '"r_ok"');
  });
}

class TController extends ResourceController {
  @httpGet
  Future<Response> getAll() async {
    return new Response.ok("t_ok");
  }
}

class RController extends ResourceController {
  @httpGet
  Future<Response> getAll() async {
    return new Response.ok("r_ok");
  }
}
