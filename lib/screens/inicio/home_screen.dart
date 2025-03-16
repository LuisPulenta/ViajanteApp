import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viajanteapp/screens/bills/bills_screen.dart';
import 'package:viajanteapp/screens/customers/customers_screen.dart';
import 'package:viajanteapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:viajanteapp/widgets/boton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//----------------------- Pantalla ------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viajante App'),
        centerTitle: true,
      ),
      body: _getBody(),
    );
  }

//---------------------------------------------------------------
//----------------------- _getBody ------------------------------
//---------------------------------------------------------------
  Widget _getBody() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.secondary,
              AppTheme.secondary,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 250,
              width: 800,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomersScreen(),
                  ),
                );
              },
              child: SizedBox(
                width: ancho * 0.95,
                child: const Boton(
                  icon: FontAwesomeIcons.peopleArrows,
                  texto: "Clientes",
                  color1: Color.fromARGB(255, 7, 22, 194),
                  color2: Color.fromARGB(255, 71, 158, 196),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BillsScreen(),
                  ),
                );
              },
              child: SizedBox(
                width: ancho * 0.95,
                child: const Boton(
                  icon: FontAwesomeIcons.fileInvoiceDollar,
                  texto: "Facturas",
                  color1: Color.fromARGB(255, 102, 9, 100),
                  color2: Color.fromARGB(255, 227, 48, 231),
                ),
              ),
            ),
          ],
        ));
  }
}
