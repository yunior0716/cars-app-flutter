import 'package:first_app/Models/client.dart';
import 'package:first_app/Screens/add_client.dart';
import 'package:first_app/Screens/car_list.dart';
import 'package:first_app/Screens/login_screen.dart';
import 'package:first_app/ViewModels/auth_viewmodel.dart';
import 'package:first_app/ViewModels/client_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  List<Client> clients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: const Text('Customer List'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                  child: Text('Menu',
                      style: TextStyle(
                        fontSize: 24,
                      ))),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Cars', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  navigateToCarList();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Logout', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  logout();
                },
              ),
            ),
          ],
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: () async {
            getClients();
          },
          child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                final id = client.id;
                return Card(
                  color: Colors.blue[50],
                  child: ListTile(
                    leading: const Icon(Icons.person_2_rounded, size: 40),
                    title: Text(client.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client.email,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(client.phone.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditClient(client);
                        } else if (value == 'delete') {
                          deleteClient(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: navigateToClientRegister,
        label: const Text('Add Customer'),
      ),
    );
  }

  Future<void> navigateToClientRegister() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddClientScreen(),
    );

    await Navigator.push(context, route);
    getClients();
  }

  Future<void> navigateToCarList() async {
    final route = MaterialPageRoute(
      builder: (context) => const CarListScreen(),
    );

    await Navigator.push(context, route);
  }

  Future<void> navigateToEditClient(Client client) async {
    final route = MaterialPageRoute(
      builder: (context) => AddClientScreen(client: client),
    );

    await Navigator.push(context, route);
    getClients();
  }

  Future<void> logout() async {
    final authViewModel = Provider.of<UserViewModel>(context, listen: false);
    authViewModel.logout();

    final route = MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );

    await Navigator.pushReplacement(context, route);
  }

  void getClients() async {
    final clientViewModel =
        Provider.of<ClientViewModel>(context, listen: false);
    final clientResult = await clientViewModel.getClients(context);

    setState(() {
      clients = clientResult;
    });

    setState(() {
      isLoading = false;
    });
  }

  void deleteClient(String id) async {
    final clientViewModel =
        Provider.of<ClientViewModel>(context, listen: false);
    await clientViewModel.deleteClient(id, context);

    getClients();
  }
}
