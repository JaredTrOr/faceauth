import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String imagePath;
  final BluetoothDevice device;
  final BluetoothConnection connection;

  const HomePage(
      {required this.username,
      required this.imagePath,
      required this.device,
      required this.connection,
      Key? key})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedSection = 'Cuarto';
  bool isLedOn = false;
  bool isDoorOpen = false;
  String temperature = '';

  @override
  void initState() {
    super.initState();

    String buffer = "";

    widget.connection.input!.listen((Uint8List data) {
      buffer += String.fromCharCodes(data);

      // Procesar datos hasta el delimitador de nueva línea
      while (buffer.contains('\n')) {
        int endIndex = buffer.indexOf('\n');
        String receivedData = buffer.substring(0, endIndex).trim();
        buffer = buffer.substring(endIndex + 1);

        // Manejar datos recibidos
        if (receivedData.isNotEmpty) {
          print(receivedData); // Imprime el dato recibido
          setState(() {
            temperature = receivedData;
          });
        }
      }
    });
  }

  void toggleLed() {
    if (widget.connection.isConnected) {
      setState(() {
        isLedOn = !isLedOn;
      });

      widget.connection.output.add(Uint8List.fromList(
          [isLedOn ? 49 : 48])); // ASCII: '1' -> 49, '0' -> 48
    } else {
      print("No se puede enviar datos, no está conectado");
    }
  }

  void toggleDoor() {
    if (widget.connection.isConnected) {
      setState(() {
        isDoorOpen = !isDoorOpen;
      });

      widget.connection.output.add(Uint8List.fromList(
          [isDoorOpen ? 51 : 50])); // ASCII: '3' -> 51, '2' -> 50
    } else {
      print("No se puede enviar datos, no está conectado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  backgroundImage: FileImage(File(widget
                      .imagePath)), // Reemplaza con la ruta de tu imagen de usuario
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.black),
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Conectado al dispositivo ${widget.device.name}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  // Lista de secciones
                  ListTile(
                    title: Text('Cuarto'),
                    onTap: () {
                      setState(() {
                        selectedSection = 'Cuarto';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Sala'),
                    onTap: () {
                      setState(() {
                        selectedSection = 'Sala';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Cocina'),
                    onTap: () {
                      setState(() {
                        selectedSection = 'Cocina';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  // Agrega las demás secciones aquí...
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
            SliverFillRemaining(
              child: Align(
                child: ListTile(
                  leading: Icon(Icons.arrow_back_outlined,
                      color: Colors.red, size: 30),
                  title: Text(
                    'Salir',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop()
                  },
                ),
                alignment: Alignment.bottomCenter,
              ),
              hasScrollBody: false,
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Text(
              'Sección: $selectedSection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Image.asset(
              'assets/${selectedSection}_${isLedOn ? 'light' : 'dark'}.png', // Asegúrate de tener imágenes para cada sección
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Temperatura: $temperature°C',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                        isLedOn ? Icons.lightbulb : Icons.lightbulb_outline),
                    iconSize: 48,
                    color: isLedOn ? Colors.yellow : Colors.grey,
                    onPressed: () => toggleLed(),
                  ),
                  Text(isLedOn ? 'LED On' : 'LED Off'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(isDoorOpen ? Icons.lock_open : Icons.lock),
                    iconSize: 48,
                    color: isDoorOpen ? Colors.green : Colors.grey,
                    onPressed: () => toggleDoor(),
                  ),
                  Text(isDoorOpen ? 'Door Open' : 'Door Closed'),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
