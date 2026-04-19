import 'package:car_api_final_app/models/about_dev_model.dart';
import 'package:car_api_final_app/widgets/dev_about_item.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final List<AboutDev> dev = [
    AboutDev(
      name: "César Antonio",
      lastname: "Aybar Vargas",
      matricula: "2024-0096",
      phone: "+18298907122",
      email: "20240096@itla.edu.do",
      imageFile: "",
    ),
    AboutDev(
      name: "Karla Michelle",
      lastname: "Virgil Bencosme",
      matricula: "2024-0066",
      phone: "+18498812443",
      email: "20240066@itla.edu.do",
      imageFile: "",
    ),
    AboutDev(
      name: "Jamil",
      lastname: "Gúzman Feliz",
      matricula: "2024-0100",
      phone: "+18498022082",
      email: "jamilguzman202@gmail.com",
      imageFile: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sobre Nosotros",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: dev.length,
            itemBuilder: (BuildContext context, int index) {
              return DevAboutItem(dev: dev[index]);
            },
          ),
        ),
      ],
    );
  }
}
