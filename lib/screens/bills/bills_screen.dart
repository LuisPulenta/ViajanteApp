import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viajanteapp/components/loader_component.dart';
import 'package:viajanteapp/helpers/api_helper.dart';
import 'package:viajanteapp/helpers/helpers.dart';
import 'package:viajanteapp/models/models.dart';
import 'package:viajanteapp/screens/screens.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  //----------------------- Variables -----------------------------

  List<Bill> _bills = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

//----------------------- initState -----------------------------

  @override
  void initState() {
    super.initState();
    _getBills();
  }

//----------------------- Pantalla -----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 172, 93),
      appBar: AppBar(
        title: const Text('Facturas y Remitos'),
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillScreen(
                bill: Bill(
                    id: 0,
                    customer: '',
                    type: '',
                    number: '',
                    createDate: '',
                    billDate: '',
                    amount: 0,
                    photo: '',
                    chargeDate: '',
                    charge: false,
                    deliverDate: '',
                    deliver: false,
                    photoFullPath: ''),
              ),
            ),
          );
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
    List<Bill> filteredList = [];
    for (var bill in _bills) {
      if (bill.customer.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(bill);
      }
    }

    setState(() {
      _bills = filteredList;
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
    _getBills();
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
            title: const Text('Filtrar Facturas y Remitos'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'Escriba texto a buscar en Cliente: ',
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
            _showBillsCount(),
            Expanded(
              child: _bills.isEmpty ? _noContent() : _getListView(),
            )
          ],
        ),
      ],
    );
  }

//------------------------------ _showCustomersCount ------------------

  Widget _showBillsCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Facturas y Remitos: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_bills.length.toString(),
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
              ? 'No hay Facturas o Remitos con ese criterio de búsqueda'
              : 'No hay Facturas o Remitos registrados',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//------------------------------ _getListView ---------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getBills,
      child: ListView(
        children: _bills.map((e) {
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
                                      child: Text(e.customer,
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
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                          size: 34,
                        ),
                        onPressed: () async {
                          await _deleteBill(e);
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

//-------------------- _deleteBill -------------------------

  _deleteBill(Bill e) async {
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
              Text('¿Está seguro de borrar el Remito/Factura ${e.customer}?'),
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
                    await ApiHelper.delete('/api/Bills/', e.id.toString())
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                    _getBills();
                    setState(() {});
                  },
                  child: const Text('SI')),
            ],
          );
        });
  }

//----------------------- _getBills -------------------------

  Future<void> _getBills() async {
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

    response = await ApiHelper.getBills();

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
      _bills = response.result;
      _bills.sort((a, b) {
        return a.customer
            .toString()
            .toLowerCase()
            .compareTo(b.customer.toString().toLowerCase());
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
