import 'package:face_net_authentication/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BlueToothList extends StatefulWidget {
  final String username;
  final String imagePath;

  const BlueToothList(this.username, this.imagePath,{Key? key}) : super(key: key);


  @override
  _BlueToothListState createState() => _BlueToothListState();
}

class _BlueToothListState extends State<BlueToothList> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  BluetoothDevice? connectedDevice;
  List<BluetoothDevice> bondedDevices = [];

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  void checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (  
        statuses[Permission.bluetoothScan]?.isGranted == true &&
        statuses[Permission.bluetooth]?.isGranted == true &&
        statuses[Permission.bluetoothConnect]?.isGranted == true &&
        statuses[Permission.location]?.isGranted == true) {
      getBondedDevices();
    } else {
      print("Permissions not granted");
    }
  }

  void getBondedDevices() async {
    bondedDevices = await bluetooth.getBondedDevices();
    setState(() {});
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        connectedDevice = device;
        //Navegar a la página de home
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: widget.username, imagePath: widget.imagePath ,  device: connectedDevice!, connection: connection!),
          ),
        ).then((_) {
          connection?.close();
          connection = null;
          connectedDevice = null;
          setState(() {});
        });
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
  padding: const EdgeInsets.all(20.0),
  children: [
    if (bondedDevices.isNotEmpty)
      ...bondedDevices.map((device) => Card(
        child: ListTile(
          leading: Icon(Icons.bluetooth, color: Colors.blue),
          title: Text(device.name ?? 'Unknown Device'),
          subtitle: Text(device.address),
          trailing: ElevatedButton(
            onPressed: () => connectToDevice(device),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Conectar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ))
    else
      Center(
        child: Text(
          "No hay dispositivos emparejados",
          style: TextStyle(fontSize: 16),
        ),
      ),
  ],
);

  }
}
