import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String pdfUrl =
      'https://firebasestorage.googleapis.com/v0/b/onbdados.appspot.com/o/Doc.pdf?alt=media&token=5196e9c4-9e55-40d0-a26a-f57589dbfa10';

  Future<void> sharePdf() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Não foi possível compartilhar o PDF. Verifique as permissões do aplicativo.'),
        ));
        return;
      }

      final file = File('${directory.path}/meu_pdf.pdf');
      final response = await http.get(Uri.parse(pdfUrl));
      await file.writeAsBytes(response.bodyBytes);
      final filePaths = [file.path];
      await Share.shareFiles(filePaths);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao compartilhar PDF: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Contrato'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => sharePdf(),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 5,
              child: SfPdfViewer.network(pdfUrl),
            ),
          ),
        ],
      ),
    );
  }
}
