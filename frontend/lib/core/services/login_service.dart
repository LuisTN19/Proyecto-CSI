import 'dart:convert'; // Para entender el JSON de Laravel
import 'package:http/http.dart' as http; // El teléfono

class LoginService {

  static String? usuarioLogueado; // Para guardar el nombre

  // LA IP MÁGICA DEL EMULADOR (Apunta a tu PC)
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  // --- FUNCIÓN DE LOGIN REAL ---
  /*Future<bool> validar(String email, String password) async {
    try {
      // 1. Llamamos a Laravel
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {
          'email': email,
          'password': password
        },
      );

      // 2. Comprobamos la respuesta
      if (respuesta.statusCode == 200) {
        // Si es 200 (OK), leemos el nombre del usuario
        final datos = jsonDecode(respuesta.body);
        usuarioLogueado = datos['usuario']['name'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return false;
    }
  }*/
  Future<bool> validar(String email, String password) async {
    try {
      print("--- INTENTANDO LOGIN ---");
      print("1. URL: $_baseUrl/login");
      print("2. Datos: $email / $password");

      final respuesta = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: {
          'email': email,
          'password': password
        }
      );
      
      print("3. Respuesta del Servidor: ${respuesta.statusCode}");
      print("4. Cuerpo: ${respuesta.body}");

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        usuarioLogueado = datos['usuario']['name'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("!!! ERROR CRÍTICO DE CONEXIÓN !!!");
      print(e); // Esto nos dirá si es culpa del emulador
      return false;
    }
  }

  // --- FUNCIÓN DE REGISTRO REAL ---
  /*Future<bool> registrar(String nombre, String email, String password) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/registro'),
        body: {
          'name': nombre,
          'email': email,
          'password': password
        },
      );

      if (respuesta.statusCode == 201) { // 201 = Creado
        final datos = jsonDecode(respuesta.body);
        usuarioLogueado = datos['usuario']['name'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return false;
    }
  }*/

// --- FUNCIÓN DE REGISTRO CON DEPURACIÓN ---
  Future<bool> registrar(String nombre, String email, String password) async {
    try {
      print("--- INTENTANDO REGISTRO ---");
      print("1. Enviando a: $_baseUrl/registro");

      final respuesta = await http.post(
        Uri.parse('$_baseUrl/registro'),
        // ¡IMPORTANTE! Le decimos a Laravel que queremos JSON, no HTML
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'name': nombre, // Ojo: en Laravel pusimos 'name', aquí debe coincidir
          'email': email,
          'password': password
        },
      );

      print("2. Código de Respuesta: ${respuesta.statusCode}");
      print("3. Mensaje del Servidor: ${respuesta.body}");

      if (respuesta.statusCode == 201) { // 201 = Creado con éxito
        final datos = jsonDecode(respuesta.body);
        usuarioLogueado = datos['usuario']['name'];
        return true;
      } else {
        // Si falla, imprimimos por qué
        print("!!! ERROR EN EL REGISTRO !!!");
        return false;
      }
    } catch (e) {
      print("!!! ERROR DE CONEXIÓN !!!: $e");
      return false;
    }
  }


}

