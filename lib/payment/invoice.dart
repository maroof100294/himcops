import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Invoice Reciept'),
        backgroundColor: const Color(0xFFB9DA6B),
      ),
      drawer: const AppDrawer(),
      body:  Padding(
        padding: const EdgeInsets.all(20),
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'asset/images/pcc_rec.png',
                    //width: 620,
                    height: 520,
                  ),
                ],
              ),
            ),
    );
  }
}