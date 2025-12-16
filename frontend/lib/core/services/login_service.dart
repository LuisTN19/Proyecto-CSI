import 'package:http/http.dart' as http;  //el teléfono para llamar a laravel
import 'dart:convert'; //para traducir el JSON


class LoginService {

//static para que el Token y el Usuario sean Memoria Global y no se borren al cambiar de pantalla
  static Map<String, dynamic>? usuarioLogueado; //caja vacía -> metemostodo lo que Laravel envía dentro de la variable usuario, Laravel envía esto: { "id": 1, "name": "Admin", "email": "a@a.com", "created_at": "..." }
  static String? apiToken;

  //final String _baseUrl = 'http://10.0.2.2:8000/api';  //laravel en localhost del PC(servidor) pero llamandolo desde el emulador, a la zona de la api (comunicacion frontend-backend)
                                                        //si usara localhost estaria llamando a laravel desde el propio emulador(no tengo el servidor aqui (xampp))
                                                        //10.0.2.2 -> IP q solo existe dentro del emulador para conectarse al ordenador
  final String _baseUrl = 'http://192.168.1.170:8000/api';                    //Mi móvil


  //----------------------------------------------------------------------------

 //LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {'email': email, 'password': password},
        headers: {'Accept': 'application/json'},
      );

      //LARAVEL en API.PHP FABRICA EL TOKEN y lo devuelve en JSON

      //CASO: EXITO
      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        usuarioLogueado = datos['usuario'];
        apiToken = datos['token'];

        print("Token guardado: $apiToken");
        return {'exito': true};
      }

      //CASO: CORREO NO VERIFICADO
      else if (respuesta.statusCode == 403) {
        final datos = jsonDecode(respuesta.body);
        if (datos['status'] == 'unverified') {  // Si laravel nos mandó la marca 'unverified'
          return {'exito': false, 'status': 'unverified'};
        }
      }

      //CASO: ERROR GENÉRICO
      return {'exito': false, 'status': 'error'};

    } catch (e) {
      print("Error: $e");
      return {'exito': false, 'status': 'error'};
    }
  }

  //----------------------------------------------------------------------------

  // REGISTRO
  Future<bool> registrar(String nombre, String email, String password) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/registro'),
        headers: {'Accept': 'application/json'},
        body: {'name': nombre, 'email': email, 'password': password},
      );

      if (respuesta.statusCode == 201 || respuesta.statusCode == 200) {
        return true; // Solo comprobamos si se creó
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  //----------------------------------------------------------------------------

  //RECUPERAR CONTRASEÑA
  Future<bool> recuperarContrasena(String email) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/cambiar-contraseña'),
        body: {'email': email},
        headers: {'Accept': 'application/json'},
      );

      if (respuesta.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error recuperando contraseña: $e");
      return false;
    }
  }
}


