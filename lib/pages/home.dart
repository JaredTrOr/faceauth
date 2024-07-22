import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedSection = 'Cuarto';
  bool isLedOn = false;
  bool isDoorOpen = false;
  double temperature = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Smart Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: CircleAvatar(
            //   backgroundImage: AssetImage('assets/user.jpg'), // Reemplaza con la ruta de tu imagen de usuario
            // ),
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
                    decoration: BoxDecoration(color: Colors.purple.shade300),
                    child: Padding(padding: EdgeInsets.only(top: 40), child:  Text('Secciones de la casa', style: TextStyle(color: Colors.white, fontSize: 20)),) 
                  ),

                ListTile(
                  title: Text('Cuartos'),
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
                // all of your list tiles
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
          SliverFillRemaining(
            child: Align(
              child: ListTile(
                leading: Icon(Icons.arrow_back_outlined,
                    color: Colors.red, size: 30),
                title: Text('Salir', style: TextStyle(color: Colors.red),),
                onTap: () => Navigator.pop(context),
              ),
              alignment: Alignment.bottomCenter,
            ),
            hasScrollBody: false,
          )
        ],
      )),
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
                    onPressed: () {
                      setState(() {
                        print('LED ON');
                        isLedOn = !isLedOn;
                      });
                    },
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
                    onPressed: () {
                      setState(() {
                        isDoorOpen = !isDoorOpen;
                      });
                    },
                  ),
                  Text(isDoorOpen ? 'Door Open' : 'Door Closed'),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
              child: Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'Temperatura: $temperature°C',
              style: TextStyle(fontSize: 18),
            ),
          ))
        ],
      ),
    );
  }
}
