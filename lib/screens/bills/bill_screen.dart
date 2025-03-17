import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viajanteapp/components/loader_component.dart';
import 'package:viajanteapp/helpers/helpers.dart';
import 'package:viajanteapp/models/models.dart';
import 'package:viajanteapp/screens/screens.dart';
import 'package:viajanteapp/themes/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

enum Type { Factura, Remito }

class BillScreen extends StatefulWidget {
  final Bill bill;
  const BillScreen({Key? key, required this.bill}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  //----------------------- Variables --------------------------------

  bool _showLoader = false;
  List<Customer> _customers = [];
  bool _photoChanged = false;
  late XFile _image;
  DateTime selectedDate = DateTime.now();

  Type selectedType = Type.Factura;

  String _customer = 'Elija un Cliente...';
  String _customerError = '';
  bool _customerShowError = false;

  String _number = '';
  String _numberError = '';
  bool _numberShowError = false;
  TextEditingController _numberController = TextEditingController();

  String _amount = '';
  String _amountError = '';
  bool _amountShowError = false;
  TextEditingController _amountController = TextEditingController();

  //----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//--------------------- _loadData ---------------------------------
  void _loadData() async {
    await _getCostumers();
  }

  //--------------------- _getCostumers ------------------------
  Future<void> _getCostumers() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
    }
    Response response = Response(isSuccess: false);
    response = await ApiHelper.getCustomers();

    if (response.isSuccess) {
      _customers = response.result;
    }
    setState(() {});
  }

  //----------------------- Pantalla --------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 176, 234, 168),
      appBar: AppBar(
        title: widget.bill.id == 0
            ? const Text('Nueva Factura/Remito')
            : const Text('Editar Factura/Remito'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                _showCustomers(),
                _showType(),
                _showNumber(),
                _showDate(),
                _showAmount(),
                _showPhoto(),
                const SizedBox(
                  height: 15,
                ),
                _showButton(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//--------------------- _showCustomers ----------------------------
  Widget _showCustomers() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: _customers.isEmpty
          ? const Text('Cargando clientes...')
          : DropdownButtonFormField(
              value: _customer,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Cliente...',
                labelText: 'Cliente',
                errorText: _customerShowError ? _customerError : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: _getComboCustomers(),
              onChanged: (value) {
                _customer = value.toString();
              },
            ),
    );
  }

//--------------------- _getComboCustomers ------------------------
  List<DropdownMenuItem<String>> _getComboCustomers() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      value: 'Elija un Cliente...',
      child: Text('Elija un Cliente...'),
    ));

    for (var customer in _customers) {
      list.add(DropdownMenuItem(
        value: customer.name,
        child: Text(customer.name),
      ));
    }
    return list;
  }

//--------------------- _showType ------------------------
  Widget _showType() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            activeColor: Colors.black,
            title: const Text('Factura'),
            value: Type.Factura,
            groupValue: selectedType,
            onChanged: (value) => setState(() {
              selectedType = Type.Factura;
            }),
          ),
        ),
        Expanded(
          child: RadioListTile(
            activeColor: Colors.black,
            title: const Text('Remito'),
            value: Type.Remito,
            groupValue: selectedType,
            onChanged: (value) => setState(() {
              selectedType = Type.Remito;
            }),
          ),
        ),
      ],
    );
  }

  //--------------------- _showDate ------------------------
  Widget _showDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Fecha: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
            const Spacer(),
            IconButton(
                onPressed: () {
                  _selectDate(context);
                },
                icon: const Icon(FontAwesomeIcons.calendar))
          ],
        ),
      ),
    );
  }

//--------------------- _showNumber ------------------------
  Widget _showNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _numberController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese N° de Factura/Remito...',
            labelText: 'N° de Factura/Remito',
            errorText: _numberShowError ? _numberError : null,
            suffixIcon: const Icon(Icons.numbers),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _number = value;
        },
      ),
    );
  }

  //--------------------- _selectDate -------------------------------
  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().add(const Duration(days: -60)),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  //--------------------- _showAmount ------------------------
  Widget _showAmount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Monto...',
            labelText: 'Monto',
            errorText: _amountShowError ? _amountError : null,
            suffixIcon: const Icon(Icons.attach_money_outlined),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _amount = value;
        },
      ),
    );
  }

//--------------------- _showPhoto -------------------------------
  Widget _showPhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //----------------- FOTO 1 -----------------------------
        InkWell(
          child: Stack(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: !_photoChanged
                  ? const Image(
                      image: AssetImage('assets/noimage.png'),
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover)
                  : Image.file(
                      File(_image.path),
                      width: 160,
                      fit: BoxFit.contain,
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 100,
              child: InkWell(
                onTap: () => _takePicture(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.green[50],
                    height: 60,
                    width: 60,
                    child: const Icon(
                      Icons.photo_camera,
                      size: 40,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

//--------------------- _takePicture -----------------------------
  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'Trasera'),
          const AlertDialogAction(key: 'yes', label: 'Delantera'),
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _image = response.result;
        });
      }
    }
  }

//--------------------- _showButton -------------------------------
  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar Factura/Rermito',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//--------------------- _save -------------------------------------
  _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

//--------------------- validateFields ----------------------------
  bool validateFields() {
    bool isValid = true;

    if (_customer == 'Elija un Cliente...') {
      isValid = false;
      _customerShowError = true;
      _customerError = 'Debe elegir un Cliente';

      setState(() {});
      return isValid;
    } else {
      _customerShowError = false;
    }

    if (_number == '') {
      isValid = false;
      _numberShowError = true;
      _numberError = 'Debe ingresar el N° de Factura/Remito';

      setState(() {});
      return isValid;
    } else {
      _numberShowError = false;
    }

    if (_amount == '') {
      isValid = false;
      _amountShowError = true;
      _amountError = 'Debe ingresar el Monto';

      setState(() {});
      return isValid;
    } else {
      _amountShowError = false;
    }
    setState(() {});
    return isValid;
  }

//--------------------- _addRecord --------------------------------
  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
    }

    XFile smallImage = await resizeImage(_image);

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await smallImage.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    String ahora = DateTime.now().toString().substring(0, 10);

    Map<String, dynamic> request = {
      'Id': 0,
      'Customer': _customer,
      'Type': selectedType.name,
      'Number': _number,
      'CreateDate': ahora,
      'BillDate': selectedDate.toString().substring(0, 10),
      'Amount': double.tryParse(_amount),
      'ChargeDate': null,
      'Charge': false,
      'DeliverDate': null,
      'Deliver': false,
      'ImageArray': base64image,
    };

    Response response = await ApiHelper.post('/api/Bills', request);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    Navigator.pop(context, 'yes');
  }

  //---------------------------------------------------------------
  Future<XFile> resizeImage(XFile originalFile,
      {int width = 120, int height = 160}) async {
    // Cargar la imagen original desde el archivo
    File file = File(originalFile.path);
    List<int> imageBytes = await file.readAsBytes();

    // Decodificar la imagen
    img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

    // Redimensionar la imagen
    img.Image resizedImage =
        img.copyResize(image, width: width, height: height);

    // Obtener el directorio temporal para guardar el nuevo archivo
    final directory = await getTemporaryDirectory();
    final resizedImagePath = '${directory.path}/resized_image.jpg';

    // Guardar la imagen redimensionada en un nuevo archivo
    File resizedFile = File(resizedImagePath)
      ..writeAsBytesSync(img.encodeJpg(resizedImage));

    // Retornar el archivo redimensionado como un XFile
    return XFile(resizedFile.path);
  }
}
