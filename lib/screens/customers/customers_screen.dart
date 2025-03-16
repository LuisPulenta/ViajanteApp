import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viajanteapp/components/loader_component.dart';
import 'package:viajanteapp/helpers/api_helper.dart';
import 'package:viajanteapp/helpers/helpers.dart';

import '../../models/models.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  //----------------------- Variables -----------------------------

  List<Customer> _customers = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  bool _isVisible = false;

//----------------------- initState -----------------------------

  @override
  void initState() {
    super.initState();
    _getCustomers();
  }

//----------------------- Pantalla -----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 172, 93),
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: const Icon(Icons.filter_none))
              : IconButton(
                  onPressed: _showFilter, icon: const Icon(Icons.filter_alt)),
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _isVisible = true;
          setState(() {});
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

//------------------------------ _filter --------------------------

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Customer> filteredList = [];
    for (var customer in _customers) {
      if (customer.name.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(customer);
      }
    }

    setState(() {
      _customers = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

//-----------------------------------------------------------------------
//------------------------------ _removeFilter --------------------------
//-----------------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getCustomers();
  }

//---------------------------------------------------------------------
//------------------------------ _showFilter --------------------------
//---------------------------------------------------------------------

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Filtrar Clientes'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'Escriba texto a buscar en Nombre: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Criterio de búsqueda...',
                    labelText: 'Buscar',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Filtrar')),
            ],
          );
        });
  }

//---------------------------------------------------------------------
//------------------------------ _getContent --------------------------
//---------------------------------------------------------------------

  Widget _getContent() {
    final ancho = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: <Widget>[
            _showCustomersCount(),
            Expanded(
              child: _customers.isEmpty ? _noContent() : _getListView(),
            )
          ],
        ),
        if (_isVisible)
          Container(
            width: ancho * 0.8,
            height: 200,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 176, 234, 168),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              const Text("NUEVO CLIENTE",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () {
                  _isVisible = false;
                  setState(() {});
                },
                icon: const Icon(FontAwesomeIcons.floppyDisk),
                label: const Text('Guardar'),
              )
            ]),
          )
      ],
    );
  }

//------------------------------ _showCustomersCount ------------------

  Widget _showCustomersCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Clientes: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_customers.length.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

//------------------------------ _noContent -----------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Clientes con ese criterio de búsqueda'
              : 'No hay Clientes registrados',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//------------------------------ _getListView ---------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getCustomers,
      child: ListView(
        children: _customers.map((e) {
          return Card(
            color: Colors.white,
            shadowColor: const Color(0xFFC7C7C8),
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(e.name,
                                          style: const TextStyle(
                                            fontSize: 26,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          color: Colors.orange,
                          size: 28,
                        ),
                        onPressed: () {
                          _isVisible = true;
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                          size: 34,
                        ),
                        onPressed: () async {
                          await _deleteCustomer(e);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//-------------------- _deleteCustomer -------------------------

  _deleteCustomer(Customer e) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(''),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text('¿Está seguro de borrar el Cliente ${e.name}?'),
              const SizedBox(
                height: 10,
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('NO')),
              TextButton(
                  onPressed: () async {
                    await ApiHelper.delete('/api/Customers/', e.id.toString())
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                    _getCustomers();
                    setState(() {});
                  },
                  child: const Text('SI')),
            ],
          );
        });
  }

//----------------------- _getCustomers -------------------------

  Future<void> _getCustomers() async {
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

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCustomers();

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

    setState(() {
      _showLoader = false;
      _customers = response.result;
      _customers.sort((a, b) {
        return a.name
            .toString()
            .toLowerCase()
            .compareTo(b.name.toString().toLowerCase());
      });
    });
  }

//---------------------------------------------------------------
//----------------------- _goInfoCustomer -----------------------
//---------------------------------------------------------------

  // void _goInfoCustomer(Customer customer) async {
  //   String? result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => CustomerInfoScreen(
  //               customer: customer,
  //               )));

  //     _getCustomers();
  //     setState(() {});
  // }
}
