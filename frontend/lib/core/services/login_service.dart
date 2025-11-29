import 'package:http/http.dart' as http;  //el teléfono para llamar a laravel
import 'dart:convert'; //para traducir el JSON


class LoginService {

//static para que el Token y el Usuario sean Memoria Global y no se borren al cambiar de pantalla
  static Map<String, dynamic>? usuarioLogueado; //caja vacía -> metemos todo lo que Laravel te ha enviado dentro de la variable usuario, Laravel envía esto: { "id": 1, "name": "Admin", "email": "a@a.com", "created_at": "..." }
  static String? apiToken;

  final String _baseUrl = 'http://10.0.2.2:8000/api';  //laravel en localhost del PC(servidor) pero llamandolo desde el emulador, a la zona de la api (comunicacion frontend-backend)
                                                        //si usara localhost estaria llamando a laravel desde el propio emulador(no tengo el servidor aqui (xampp))

 //LOGIN
  Future<bool> login(String email, String password) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {'email': email, 'password': password},
        headers: {'Accept': 'application/json'},
      );

      //LARAVEL en API.PHP FABRICA EL TOKEN y lo devuelve en JSON

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        usuarioLogueado = datos['usuario'];

        apiToken = datos['token'];

        print("Token guardado: $apiToken");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // REGISTRO
  Future<bool> registrar(String nombre, String email, String password) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/registro'),
        headers: {'Accept': 'application/json'},
        body: {'name': nombre, 'email': email, 'password': password},
      );

      if (respuesta.statusCode == 201 || respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        usuarioLogueado = datos['usuario'];
        apiToken = datos['token'];

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}






