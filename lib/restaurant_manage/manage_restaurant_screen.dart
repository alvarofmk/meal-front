import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/model/restaurante_detail.dart';
import 'package:front/restaurant_form/restaurant_form_screen.dart';
import '../home_screen.dart';
import '../platos_manage/manage_platos_screen.dart';
import 'manage_restaurant_bloc.dart';

const String imgBase = "http://localhost:8080/restaurante/";
const String imgBasePlato = "http://localhost:8080/plato/";
const String imgSuffix = "/img/";

class ManageRestaurantScreen extends StatelessWidget {
  ManageRestaurantScreen({super.key, required this.restaurantId});

  String restaurantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ManageRestaurantBloc()..add(RestaurantFetched(restaurantId)),
      child: ManageRestaurantUI(),
    );
  }
}

class ManageRestaurantUI extends StatefulWidget {
  @override
  State<ManageRestaurantUI> createState() => _ManageRestaurantUIState();
}

class _ManageRestaurantUIState extends State<ManageRestaurantUI> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageRestaurantBloc, ManageRestaurantState>(
      builder: (context, state) {
        switch (state.status) {
          case ManageRestaurantStatus.failure:
            return const Center(child: Text('Fallo al cargar el restaurante'));
          case ManageRestaurantStatus.success:
            return _buildScreen(state);
          case ManageRestaurantStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case ManageRestaurantStatus.deleted:
            return const DeletedScreen();
        }
      },
    );
  }

  Scaffold _buildScreen(ManageRestaurantState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.restaurante!.nombre!),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(alignment: Alignment.bottomCenter, children: <Widget>[
              Image.network(
                imgBase + state.restaurante!.id! + imgSuffix,
              ),
              Positioned(
                  right: 15,
                  bottom: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.red.shade700,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                  )),
            ]),
            Padding(
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text("Nombre"),
                      ),
                      Expanded(
                          flex: 10,
                          child: Text(
                            state.restaurante!.nombre!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text("Descripción"),
                      ),
                      Expanded(
                          flex: 10,
                          child: Text(
                            state.restaurante!.descripcion!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text("Hora apertura"),
                      ),
                      Expanded(
                          flex: 10,
                          child: Text(
                            state.restaurante!.apertura!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text("Hora cierre"),
                      ),
                      Expanded(
                          flex: 10,
                          child: Text(
                            state.restaurante!.cierre!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RestaurantForm.edit(state.restaurante))),
                      child: Text("Editar datos")),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagePlatosScreen(
                                    restaurantId: state.restaurante!.id!,
                                  ))),
                      child: Text("Gestionar platos")),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Añadir nuevo plato")),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white),
                      onPressed: () =>
                          _dialogBuilder(context, state.restaurante!),
                      child: Text("Eliminar restaurante"))
                ])),
          ]),
    );
  }

  Future<void> _dialogBuilder(
      BuildContext dialogContext, RestauranteDetailResult restaurante) {
    return showDialog<void>(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Eliminar ${restaurante.nombre}?'),
          content: Text(
              """¿Estás seguro de querer eliminar ${restaurante.nombre}? Esta acción no se puede deshacer. Por seguridad, debe eliminar los platos antes de poder eliminar el restaurante, le recomendamos desactivar los pedidos antes de optar por borrar definitivamente el restaurante de la aplicación."""),
          actions: <Widget>[
            ElevatedButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white),
              child: const Text('Borrar'),
              onPressed: () {
                BlocProvider.of<ManageRestaurantBloc>(dialogContext)
                  ..add(DeleteRestaurantEvent(restaurante.id!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DeletedScreen extends StatefulWidget {
  const DeletedScreen({Key? key}) : super(key: key);

  @override
  State<DeletedScreen> createState() => _DeletedScreenState();
}

class _DeletedScreenState extends State<DeletedScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            const Text(
              'Borrado con éxito',
              style: TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
