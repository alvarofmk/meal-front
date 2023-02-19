import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/auth/auth_bloc.dart';
import 'package:front/login/login_screen.dart';
import 'package:front/model/plato_detail_result.dart';
import 'package:front/platodetail/platodetail_bloc.dart';

const String imgBase = "http://localhost:8080/plato/";
const String imgSuffix = "/img/";

class PlatoScreen extends StatelessWidget {
  PlatoScreen({super.key, required this.platoId});

  String platoId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlatodetailBloc()..add(PlatoFetched(platoId)),
      child: PlatoUI(),
    );
  }
}

class PlatoUI extends StatefulWidget {
  @override
  State<PlatoUI> createState() => _PlatoUIState();
}

class _PlatoUIState extends State<PlatoUI> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatodetailBloc, PlatodetailState>(
      builder: (context, state) {
        switch (state.status) {
          case PlatodetailStatus.failure:
            return const Center(child: Text('Fallo al cargar el plato'));
          case PlatodetailStatus.success:
            return Scaffold(
                appBar: AppBar(
                  title: Text(state.plato!.nombre!),
                  backgroundColor: Colors.red.shade700,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        imgBase + state.plato!.id! + imgSuffix,
                        height: 300,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.plato!.nombre!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            Text(
                              "${state.plato!.precio!} €",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: Text(
                            state.plato!.descripcion!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          )),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ingredientes",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Wrap(
                                  children: List.generate(
                                state.plato!.ingredientes!.length,
                                (index) => Container(
                                    margin: EdgeInsets.only(right: 4, top: 4),
                                    child: Material(
                                      elevation: 2,
                                      child: Container(
                                          padding: EdgeInsets.all(3),
                                          child: Text(state
                                              .plato!.ingredientes![index])),
                                    )),
                              ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Valoraciones",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              if (state.plato!.valoracionMedia != null)
                                Text(
                                  "${state.plato!.valoracionMedia}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                            ],
                          )),
                      if (state.plato!.valoraciones != null)
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ReviewItem(
                                  valoracion:
                                      state.plato!.valoraciones![index]);
                            },
                            itemCount: state.plato!.valoraciones!.length,
                          ),
                        ),
                      if (state.plato!.valoraciones == null)
                        Center(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                child: Text(
                                  "Se el primero en dejar tu opinión.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              ),
                              BlocBuilder<AuthenticationBloc,
                                  AuthenticationState>(
                                builder: (context, state) {
                                  if (state is AuthenticationAuthenticated) {
                                    return ElevatedButton(
                                        onPressed: rate(),
                                        child: Text("Valorar"));
                                  } else if (state
                                      is AuthenticationNotAuthenticated) {
                                    return ElevatedButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen())),
                                        child: Text("Loggeate para valorar."));
                                  } else {
                                    return Text("We made a fucky wucky");
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ));
          case PlatodetailStatus.initial:
            return CircularProgressIndicator();
        }
      },
    );
  }

  rate() {}
}

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key, required this.valoracion});

  final Valoracion valoracion;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1,
        child: Container(
          height: 70,
          child: ListTile(
            leading: Text("${valoracion.nota}"),
            title: Text(valoracion.username!),
            subtitle: Text(valoracion.comentario!),
            leadingAndTrailingTextStyle: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}