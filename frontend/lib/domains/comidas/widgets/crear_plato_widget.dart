import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';  //Selección de la imagen

typedef GuardarPlatoCallback = void Function(String nombre, String descripcion, List<String> ingredientes, String tiempo, String calorias, double estrellas, File? imagen, );

class CrearPlatoWidget extends StatefulWidget {
  final GuardarPlatoCallback onGuardar;
  //datos para la EDICIÓN:
  final String? inicialNombre;
  final String? inicialDescripcion;
  final List<String>? inicialIngredientes;
  final String? inicialTiempo;
  final String? inicialCalorias;
  final double? inicialEstrellas;
  final String? inicialImagenUrl;


  const CrearPlatoWidget({super.key, required this.onGuardar, this.inicialNombre, this.inicialDescripcion,this.inicialIngredientes, this.inicialTiempo, this.inicialCalorias, this.inicialEstrellas, this.inicialImagenUrl,});

  @override
  State<CrearPlatoWidget> createState() => _CrearPlatoWidgetState();
}

class _CrearPlatoWidgetState extends State<CrearPlatoWidget> {
  //contoladores de las cajas de texto (TextField) -> leer lo que el usuario escribe o para modificar el texto desde el código
  late TextEditingController _nombreCtrl; //late: pq se inicializarán más tarde, en el inistate
  late TextEditingController _descCtrl;
  late TextEditingController _ingredientesCtrl;
  late TextEditingController _tiempoCtrl;
  late TextEditingController _caloriasCtrl;
  double _estrellas = 3.0;

  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();  //herramienta para abrir la galería o la cámara.


  String? _errorNombre;

  //----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // los controladores empiezan con el valor q tienen ya los datos del plato en sí
    // Si widget.inicialNombre trae lentejas por ejemplo, el controlador se inicia con ese texto, en el caso de no traer nada se inicia con ""
    _nombreCtrl = TextEditingController(text: widget.inicialNombre ?? "");
    _descCtrl = TextEditingController(text: widget.inicialDescripcion ?? "");
    _ingredientesCtrl = TextEditingController(text: widget.inicialIngredientes?.join(", ") ?? "");
    _tiempoCtrl = TextEditingController(text: widget.inicialTiempo ?? "");
    _caloriasCtrl = TextEditingController(text: widget.inicialCalorias ?? "");
    _estrellas = widget.inicialEstrellas ?? 3.0;
  }

  @override
  void dispose() {    // Limpieza de memoria obligatoria al usar controladores
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    _ingredientesCtrl.dispose();
    _tiempoCtrl.dispose();
    _caloriasCtrl.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.inicialNombre != null ? "Editar Plato" : "Nuevo Plato"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            //foto--------------------------------------------------------------
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Galería'),
                          onTap: () {
                            Navigator.pop(context);
                            _seleccionarImagen(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Cámara'),
                          onTap: () {
                            Navigator.pop(context);
                            _seleccionarImagen(ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                height: 150, width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200], borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                // USAMOS LA NUEVA FUNCIÓN VISUAL
                child: _buildImagenPreview(),
              ),
            ),
            const SizedBox(height: 15),

            //------------------------------------------------------------------

            // NOMBRE
            TextField(
              controller: _nombreCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Nombre",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.restaurant),
                errorText: _errorNombre,
              ),
            ),
            const SizedBox(height: 15),

            // DESCRIPCIÓN
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Descripción", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),

            // Tiempo y Calorías
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tiempoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Tiempo", border: OutlineInputBorder(), prefixIcon: Icon(Icons.access_time)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _caloriasCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Kcal", border: OutlineInputBorder(), prefixIcon: Icon(Icons.local_fire_department)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // INGREDIENTES
            TextField(
              controller: _ingredientesCtrl,
              minLines: 1,
              maxLines: null,
              decoration: const InputDecoration(labelText: "Ingredientes (separados por coma)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.shopping_basket)),
            ),
            const SizedBox(height: 15),

            // ESTRELLAS
            const Text("Valoración:", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSelectorEstrellas(),
          ],
        ),
      ),

      // BOTONES
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _guardarPlato,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text("Guardar"),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // PREVIEW FOTO
  Widget _buildImagenPreview() {

    if (_imagenSeleccionada != null) {  // CASO 1: cambio, foto nueva seleccionada -> la mostramos
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_imagenSeleccionada!, fit: BoxFit.cover),
      );
    }

    else if (widget.inicialImagenUrl != null && widget.inicialImagenUrl!.isNotEmpty) { //CASO 2: no hay cambio, mostrar la foto antigua
      return ClipRRect(
        child: Image.network(widget.inicialImagenUrl!, fit: BoxFit.cover), //Esto descarga la foto de tu servidor Laravel para mostrarla
      );
    }

    else {  //CASO 3: nada, mostramos el icono de la camara
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
          Text("Añadir foto", style: TextStyle(color: Colors.grey)),
        ],
      );
    }
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagenSeleccionada = File(pickedFile.path);
      });
    }
  }

  //----------------------------------------------------------------------------

  Widget _buildSelectorEstrellas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        IconData icono = Icons.star_border;
        if (_estrellas >= index + 1) {
          icono = Icons.star;
        } else if (_estrellas >= index + 0.5) {
          icono = Icons.star_half;
        }

        return IconButton(
          icon: Icon(icono, color: Colors.orange, size: 32),
          onPressed: () {
            setState(() {
              double valorPulsado = index + 1.0;

              if (_estrellas == valorPulsado) {
                _estrellas = valorPulsado - 0.5;
              } else {
                _estrellas = valorPulsado;
              }
            });
          },
        );
      }),
    );
  }

  //----------------------------------------------------------------------------

  void _guardarPlato() {
    setState(() {   //limpiamos errores previos
      _errorNombre = null;
    });

    if (_nombreCtrl.text.trim().isEmpty) {  //Comprobamso que el nombre no este vacío
      setState(() {
        _errorNombre = "Introduce un nombre";
      });
      return;
    }

    List<String> listaIngredientes = _ingredientesCtrl.text.isNotEmpty
        ? _ingredientesCtrl.text.split(',').map((e) => e.trim()).toList()
        : [];

    widget.onGuardar(
      _nombreCtrl.text, // .text para sacar lo que haya escrito el usuario
      _descCtrl.text,
      listaIngredientes,
      _tiempoCtrl.text,
      _caloriasCtrl.text,
      _estrellas,
      _imagenSeleccionada,
    );
    Navigator.pop(context);
  }
}