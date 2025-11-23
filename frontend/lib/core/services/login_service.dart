class LoginService {

  // DATOS FALSOS (Aquí dentro)
  final String _usuarioReal = "admin";
  final String _claveReal = "1234";

  // LÓGICA (Devuelve true o false)
  Future<bool> validar(String email, String password) async {
    if (email == _usuarioReal && password == _claveReal) {
      return true;
    } else {
      return false;
    }
  }



  // Lógica de Registro (Simulada)
  Future<bool> registrar(String nombre, String email, String password) async {

    // Simulamos que guardamos en base de datos
    // (Aquí en el futuro llamarás a: http.post(api/registro...))

    if (email.isNotEmpty && password.length > 3) {
      return true; // Se registró bien
    } else {
      return false; // Falló algo
    }
  }


}



