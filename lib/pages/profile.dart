import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_net_authentication/pages/bluetooth_list.dart';

class Profile extends StatelessWidget {
  const Profile(this.username, {Key? key, required this.imagePath}) : super(key: key);
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(username, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                SizedBox(width: 20,),
                CircleAvatar(
                  backgroundImage: FileImage(File(imagePath)), // Reemplaza con la ruta de tu imagen de usuario
                ),
              ],
            )
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Text('Seleccione un dispositivo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),

            // Lista de dispositivos Bluetooth
            Expanded(
              child: BlueToothList(username, imagePath),
            ),

            
            
          ],
        ),
      ),
    );
  }
}
