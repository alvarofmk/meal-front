import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
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
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
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
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
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
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              onPressed: () {}, child: Text("Editar datos")),
                          SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ManagePlatosScreen(
                                            restaurantId:
                                                state.restaurante!.id!,
                                          ))),
                              child: Text("Gestionar platos")),
                          SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text("Añadir nuevo plato"))
                        ])),
                  ]),
            );
          case ManageRestaurantStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
