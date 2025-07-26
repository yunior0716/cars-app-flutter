import 'package:car_app/Models/client.dart';
import 'package:car_app/ViewModels/client_viewmodel.dart';
import 'package:car_app/Widgets/custom_button.dart';
import 'package:car_app/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddClientScreen extends StatefulWidget {
  final Client? client;
  const AddClientScreen({
    super.key,
    this.client,
  });

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isEdit = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final client = widget.client;

    if (client != null) {
      isEdit = true;
      nameController.text = client.name;
      emailController.text = client.email;
      phoneController.text = client.phone.toString();
      addressController.text = client.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(isEdit ? 'Editar cliente' : 'Agregar cliente'),
        centerTitle: true,
      ),
      body: ListView(children: [
        CustomTextFormField(
          paddingTop: 20.0,
          controller: nameController,
          hintText: "Ingresa el nombre...",
          obscureText: false,
          labelText: "Nombre",
          icon: Icons.person,
        ),
        CustomTextFormField(
          controller: emailController,
          hintText: "Ingresa el correo...",
          obscureText: false,
          labelText: "Correo electrónico",
          icon: Icons.email,
        ),
        CustomTextFormField(
          controller: phoneController,
          hintText: "Ingresa el teléfono...",
          obscureText: false,
          labelText: "Teléfono",
          icon: Icons.phone,
          keyboardType: TextInputType.number,
        ),
        CustomTextFormField(
          controller: addressController,
          hintText: "Ingresa la dirección...",
          obscureText: false,
          labelText: "Dirección",
          icon: Icons.location_on,
        ),
        const SizedBox(
          height: 20,
        ),
        isLoading
            ? const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              )
            : CustomButton(
                height: 50,
                text: isEdit ? "Actualizar cliente" : "Agregar cliente",
                onPressed: () {
                  isEdit ? editClient() : addClient();
                },
              ),
      ]),
    );
  }

  void addClient() async {
    setState(() {
      isLoading = true;
    });

    final clientViewModel =
        Provider.of<ClientViewModel>(context, listen: false);
    await clientViewModel.addClient(nameController, emailController,
        phoneController, addressController, context);

    setState(() {
      isLoading = false;
    });
  }

  void editClient() async {
    setState(() {
      isLoading = true;
    });

    final clientViewModel =
        Provider.of<ClientViewModel>(context, listen: false);
    await clientViewModel.updateClient(widget.client!.id, nameController,
        emailController, phoneController, addressController, context);

    setState(() {
      isLoading = false;
    });
  }
}
