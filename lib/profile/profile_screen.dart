import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/auth/auth_bloc.dart';
import 'package:front/model/RestauranteListResult.dart';
import 'package:front/profile/profile_bloc.dart';
import 'package:front/restaurant_form/restaurant_form_screen.dart';

import '../model/login_model.dart';
import '../password_change/password_change_screen.dart';
import '../restaurant_manage/manage_restaurant_screen.dart';

const String imgBase = "http://localhost:8080/restaurante/";
const String imgSuffix = "/img/";

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(FetchUserEvent()),
      child: ProfileUI(),
    );
  }
}

class ProfileUI extends StatefulWidget {
  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  bool _showAccOptions = false;
  bool _canDeleteAccount = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        switch (state.status) {
          case ProfileStatus.failure:
            return Center(
                child: Column(
              children: [
                Text('Fallo al cargar los restaurantes'),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationBloc>().add(UserLoggedOut());
                  },
                  child: Text("Reintentar"),
                )
              ],
            ));
          case ProfileStatus.standard:
            _canDeleteAccount = true;
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(children: [
                  Text(
                    state.user!.name,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                  ),
                  Text(state.user!.email),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAccOptions = !_showAccOptions;
                          });
                        },
                        child: Text("Gestionar cuenta")),
                  ),
                  if (_showAccOptions)
                    Container(
                      margin: EdgeInsets.all(5),
                      child: OutlinedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PassWordChangeScreen())),
                          child: Text(
                            "Cambiar contraseña",
                            style: TextStyle(color: Colors.red.shade700),
                          )),
                    ),
                  Visibility(
                    visible: _showAccOptions,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red.shade700),
                          onPressed: () => _dialogBuilder(context, state.user!),
                          child: Text(
                            "Borrar cuenta",
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.shade700),
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(UserLoggedOut());
                        },
                        child: Text(
                          "Log out",
                        )),
                  ),
                ]),
              ),
            ));
          case ProfileStatus.owner:
            if (state.restaurantes != null)
              _canDeleteAccount = state.restaurantes!.isEmpty;
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(children: [
                  Text(
                    state.user!.name,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                  ),
                  Text(state.user!.email),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAccOptions = !_showAccOptions;
                          });
                        },
                        child: Text("Gestionar cuenta")),
                  ),
                  if (_showAccOptions)
                    Container(
                      margin: EdgeInsets.all(5),
                      child: OutlinedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PassWordChangeScreen())),
                          child: Text(
                            "Cambiar contraseña",
                            style: TextStyle(color: Colors.red.shade700),
                          )),
                    ),
                  Visibility(
                    visible: _showAccOptions,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red.shade700),
                          onPressed: () => _dialogBuilder(context, state.user!),
                          child: Text(
                            "Borrar cuenta",
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.shade700),
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(UserLoggedOut());
                        },
                        child: Text(
                          "Log out",
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  OwnerSection(state.restaurantes!),
                ]),
              ),
            ));
          case ProfileStatus.initial:
            return CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext dialogContext, User user) {
    return showDialog<void>(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Eliminar cuenta?'),
          content: Text(
              """¿Estás seguro de querer eliminar su cuenta? Esta acción no se puede deshacer. Por seguridad, si usted gestiona algún restaurante elimine o desactive sus resataurantes antes de eliminar la cuenta. Le recomendamos desactivar los pedidos antes de optar por borrar definitivamente su cuenta."""),
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
              onPressed: _canDeleteAccount
                  ? () {
                      BlocProvider.of<AuthenticationBloc>(dialogContext)
                        ..add(DeleteAccountEvent());
                      Navigator.of(context).pop();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class OwnerSection extends StatelessWidget {
  const OwnerSection(this.restaurantes, {super.key});

  final List<RestauranteGeneric> restaurantes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            "Tus restaurantes",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                child: Container(
                  height: 50,
                  child: ListTile(
                    title: Text(restaurantes[index].nombre!),
                    trailing: OutlinedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageRestaurantScreen(
                                      restaurantId: restaurantes[index].id!,
                                    ))),
                        child: Text("Gestionar")),
                  ),
                ),
              ),
            );
          },
          itemCount: restaurantes.length,
        ),
        ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => RestaurantForm())),
            child: Text("Añadir nuevo resstaurante"))
      ],
    );
  }
}
