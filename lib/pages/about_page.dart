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
      email: "antonio_c1723@hotmail.com",
      imageFile: "assets/dev_profiles/dev_profile_Cesar.jpeg",
    ),
    AboutDev(
      name: "Karla Michelle",
      lastname: "Virgil Bencosme",
      matricula: "2024-0066",
      phone: "+18498812443",
      email: "20240066@itla.edu.do",
      imageFile: "assets/dev_profiles/dev_profile_Karla.jpeg",
    ),
    AboutDev(
      name: "Jamil",
      lastname: "Gúzman Feliz",
      matricula: "2024-0100",
      phone: "+18498022082",
      email: "jamilguzman202@gmail.com",
      imageFile: "assets/dev_profiles/dev_profile_Jamil.jpeg",
    ),
    AboutDev(
      name: "Ysauri Mariel",
      lastname: "Jiménez Morales",
      matricula: "2023-1380",
      phone: "+18096742747",
      email: "ysmajimo@gmail.com",
      imageFile: "assets/dev_profiles/dev_profile_Ysauri.jpeg",
    ),
    AboutDev(
      name: "Gabriel Alejandro",
      lastname: "Mancebo Báez",
      matricula: "2023-0252",
      phone: "+18098601893",
      email: "gabrielalejandro1893@gmail.com",
      imageFile: "assets/dev_profiles/dev_profile_Gabriel.jpeg",
    ),
    AboutDev(
      name: "Arwin Dianela",
      lastname: "Clark",
      matricula: "2024-0023",
      phone: "+18299337248",
      email: "20240023@itla.edu.do",
      imageFile: "assets/dev_profiles/dev_profile_Arwin.jpeg",
    ),
    AboutDev(
      name: "Eudy Yunior",
      lastname: "Lorenzo Ramirez",
      matricula: "2024-0171",
      phone: "+18493575980",
      email: "elorenzo.cesm@gmail.com",
      imageFile: "assets/dev_profiles/dev_profile_Eudy.jpeg",
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
