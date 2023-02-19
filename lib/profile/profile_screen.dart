import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/auth/auth_bloc.dart';
import 'package:front/model/RestauranteListResult.dart';
import 'package:front/profile/profile_bloc.dart';

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
  bool _showAccOptions = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        switch (state.status) {
          case ProfileStatus.failure:
            return const Center(child: Text('Fallo al cargar el usuario'));
          case ProfileStatus.standard:
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
                          onPressed: () {},
                          child: Text(
                            "Cambiar contraseña",
                          )),
                    ),
                  Visibility(
                    visible: _showAccOptions,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Borrar cuenta",
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: OutlinedButton(
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(UserLoggedOut());
                        },
                        child: Text(
                          "Log out",
                          style: TextStyle(color: Colors.red.shade600),
                        )),
                  ),
                ]),
              ),
            ));
          case ProfileStatus.owner:
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
                  OutlinedButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(UserLoggedOut());
                      },
                      child: Text("Gestionar cuenta")),
                  SizedBox(
                    height: 5,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(UserLoggedOut());
                      },
                      child: Text(
                        "Log out",
                        style: TextStyle(color: Colors.red.shade600),
                      )),
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

  rate() {}
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
                    leading: Image.network(
                      imgBase + restaurantes[index].id! + imgSuffix,
                      fit: BoxFit.fill,
                    ),
                    title: Text(restaurantes[index].nombre!),
                    trailing: OutlinedButton(
                        onPressed: () {}, child: Text("Gestionar")),
                  ),
                ),
              ),
            );
          },
          itemCount: restaurantes.length,
        ),
      ],
    );
  }
}
