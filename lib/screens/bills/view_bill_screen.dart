import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:viajanteapp/components/loader_component.dart';
import 'package:viajanteapp/helpers/helpers.dart';
import 'package:viajanteapp/models/models.dart';
import 'package:viajanteapp/themes/app_theme.dart';

class ViewBillScreen extends StatefulWidget {
  final Bill bill;

  const ViewBillScreen({Key? key, required this.bill}) : super(key: key);

  @override
  State<ViewBillScreen> createState() => _ViewBillScreenState();
}

class _ViewBillScreenState extends State<ViewBillScreen> {
  //----------------------- Variables --------------------------------
  bool _showLoader = false;

  //----------------------- Pantalla --------------------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 176, 234, 168),
      appBar: AppBar(
        title: FittedBox(
          child: Text(
              '${widget.bill.customer} - ${widget.bill.type} N°: ${widget.bill.number}'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(children: [
            Card(
              color: Colors.white,
              shadowColor: const Color(0xFFC7C7C8),
              elevation: 10,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                        child: Text(widget.bill.customer,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Fecha: ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    widget.bill.billDate)),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("${widget.bill.type} N°: ",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(widget.bill.number,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Monto: ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                            NumberFormat.currency(symbol: '\$')
                                                .format(widget.bill.amount),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      widget.bill.deliver
                                          ? Text(
                                              "ENTREGADO - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.bill.deliverDate!))}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primary))
                                          : const Text("NO ENTREGADO",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      widget.bill.charge
                                          ? Text(
                                              "COBRADO - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.bill.chargeDate!))}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primary))
                                          : const Text("NO COBRADO",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Fecha de carga: ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    widget.bill.createDate)),
                                            style: const TextStyle(
                                              fontSize: 16,
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Stack(
                          children: [
                            InteractiveViewer(
                              boundaryMargin:
                                  const EdgeInsets.all(double.infinity),
                              child: SizedBox(
                                width: size.width,
                                height: size.height,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/loading.gif',
                                  image: widget.bill.photoFullPath,
                                  fit: BoxFit.contain,
                                  width: size.width,
                                  height: size.height,
                                ),
                              ),
                            ),
                            Positioned(
                                top: size.height * 0.08,
                                right: 5,
                                child: IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.rectangleXmark,
                                    color: Colors.red,
                                    size: 36,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ))
                          ],
                        );
                      });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.bill.photoFullPath.toString(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.contain,
                        height: 660,
                        width: 560,
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/loading.gif'),
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //--------------------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    await _entregado();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      widget.bill.deliver
                          ? const Text('No entregado',
                              style: TextStyle(color: Colors.white))
                          : const Text('Entregado',
                              style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    await _cobrado();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.paid_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      widget.bill.charge
                          ? const Text('No cobrado',
                              style: TextStyle(color: Colors.white))
                          : const Text('Cobrado',
                              style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  //--------------------- _entregado --------------------------------
  Future<void> _entregado() async {
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

    String ahora = DateTime.now().toString().substring(0, 10);

    Map<String, dynamic> request = {
      'Id': widget.bill.id,
      'Customer': widget.bill.customer,
      'Type': widget.bill.type,
      'Number': widget.bill.number,
      'CreateDate': widget.bill.createDate.substring(0, 10),
      'BillDate': widget.bill.billDate.substring(0, 10),
      'Amount': widget.bill.amount,
      'ChargeDate':
          widget.bill.chargeDate == '' ? null : widget.bill.chargeDate,
      'Charge': widget.bill.charge,
      'DeliverDate': widget.bill.deliver == false ? ahora : null,
      'Deliver': !widget.bill.deliver,
      'ImageArray': '',
    };
    await ApiHelper.put('/api/Bills/', widget.bill.id.toString(), request)
        .then((value) {
      Navigator.pop(context, 'yes');
    });
  }

  //--------------------- _cobrado --------------------------------
  Future<void> _cobrado() async {
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

    String ahora = DateTime.now().toString().substring(0, 10);

    Map<String, dynamic> request = {
      'Id': widget.bill.id,
      'Customer': widget.bill.customer,
      'Type': widget.bill.type,
      'Number': widget.bill.number,
      'CreateDate': widget.bill.createDate.substring(0, 10),
      'BillDate': widget.bill.billDate.substring(0, 10),
      'Amount': widget.bill.amount,
      'ChargeDate': widget.bill.charge == false ? ahora : null,
      'Charge': !widget.bill.charge,
      'DeliverDate':
          widget.bill.deliverDate == '' ? null : widget.bill.deliverDate,
      'Deliver': widget.bill.deliver,
      'ImageArray': null,
    };
    await ApiHelper.put('/api/Bills/', widget.bill.id.toString(), request)
        .then((value) {
      Navigator.pop(context, 'yes');
    });
  }
}
