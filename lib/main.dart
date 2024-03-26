import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRScanPage(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class QRScanPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  List<Map<String, dynamic>> codes = [];

  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  var BarcodeScanner;

  @override
  void initState() {
    super.initState();
  }

  Future<void> startScanner() async {
    try {
      String code = await BarcodeScanner.scan();
      bool found = false;
      for (var item in codes) {
        if (item['codigo'] == code) {
          found = true;
          item['quantidade'] += 1;
          break;
        }
      }
      if (!found) {
        codes.add({'codigo': code, 'quantidade': 1});
      }
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // ignore: avoid_print
        print('Acesso à câmera negado.');
      } else {
        // ignore: avoid_print
        print('Erro desconhecido: $e');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao escanear o código: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('Code Reader'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: codes.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(codes[index]['codigo']),
                  trailing: Text('Quantidade: ${codes[index]['quantidade']}x'),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await startScanner();
        },
        tooltip: 'Iniciar Leitura',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
