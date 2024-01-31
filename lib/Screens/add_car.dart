import 'package:first_app/Models/car.dart';
import 'package:first_app/ViewModels/car_viewmodel.dart';
import 'package:first_app/Widgets/custom_button.dart';
import 'package:first_app/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCarScreen extends StatefulWidget {
  final Car? car;
  const AddCarScreen({
    super.key,
    this.car,
  });

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  bool isEdit = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final car = widget.car;

    if (car != null) {
      isEdit = true;
      brandController.text = car.brand;
      modelController.text = car.model;
      colorController.text = car.color;
      yearController.text = car.year.toString();
      priceController.text = car.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(isEdit ? 'Edit Todo' : 'Add Car'),
        centerTitle: true,
      ),
      body: ListView(children: [
        CustomTextFormField(
          paddingTop: 20.0,
          controller: brandController,
          hintText: "Enter the brand...",
          obscureText: false,
          labelText: "Brand",
          icon: Icons.car_repair,
        ),
        CustomTextFormField(
          controller: modelController,
          hintText: "Enter the model...",
          obscureText: false,
          labelText: "Model",
          icon: Icons.car_repair,
        ),
        CustomTextFormField(
          controller: colorController,
          hintText: "Enter the color...",
          obscureText: false,
          labelText: "Color",
          icon: Icons.color_lens,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: yearController,
                hintText: "Enter the year...",
                obscureText: false,
                labelText: "Year",
                keyboardType: TextInputType.number,
                icon: Icons.calendar_today,
              ),
            ),
            Expanded(
              child: CustomTextFormField(
                controller: priceController,
                hintText: "Enter the price...",
                obscureText: false,
                labelText: "Price",
                keyboardType: TextInputType.number,
                icon: Icons.money,
              ),
            ),
          ],
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
                text: isEdit ? "Update Car" : "Add Car",
                onPressed: () {
                  isEdit ? editCar() : addCar();
                },
              ),
      ]),
    );
  }

  void addCar() async {
    setState(() {
      isLoading = true;
    });

    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    await carViewModel.addCar(colorController, brandController, modelController,
        yearController, priceController, context);

    setState(() {
      isLoading = false;
    });
  }

  void editCar() async {
    setState(() {
      isLoading = true;
    });

    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    await carViewModel.updateCar(
        widget.car!.id,
        colorController,
        brandController,
        modelController,
        yearController,
        priceController,
        context);

    setState(() {
      isLoading = false;
    });
  }
}
