import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/model/plato_list_result.dart';
import 'package:front/restaurantmenu/restaurant_menu_bloc.dart';

import '../landing/landing_bloc.dart';
import '../landing/landing_screen.dart';

const String imgBase = "http://localhost:8080/restaurante/";
const String imgBasePlato = "http://localhost:8080/plato/";
const String imgSuffix = "/img/";

class RestaurantScreen extends StatelessWidget {
  RestaurantScreen({super.key, required this.restaurantId});

  String restaurantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RestaurantMenuBloc()..add(RestaurantFetched(restaurantId)),
      child: RestaurantUI(),
    );
  }
}

class RestaurantUI extends StatefulWidget {
  @override
  State<RestaurantUI> createState() => _RestaurantUIState();
}

class _RestaurantUIState extends State<RestaurantUI> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
      builder: (context, state) {
        switch (state.status) {
          case RestaurantMenuStatus.failure:
            return const Center(child: Text('Fallo al cargar el restaurante'));
          case RestaurantMenuStatus.success:
            return Scaffold(
              appBar: AppBar(
                title: Text(state.restaurante!.nombre!),
                backgroundColor: Colors.red.shade700,
              ),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      imgBase + state.restaurante!.id! + imgSuffix,
                    ),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(children: [
                          Text(
                            state.restaurante!.nombre!,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            state.restaurante!.descripcion!,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          )
                        ])),
                    Expanded(
                        child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.platos.length
                            ? const BottomLoader()
                            : PlatoItem(plato: state.platos[index]);
                      },
                      itemCount: state.hasReachedMax
                          ? state.platos.length
                          : state.platos.length + 1,
                      controller: _scrollController,
                    ))
                  ]),
            );
          case RestaurantMenuStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<RestaurantMenuBloc>();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class PlatoItem extends StatelessWidget {
  const PlatoItem({super.key, required this.plato});

  final PlatoGeneric plato;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
          child: Container(
            height: 70,
            child: ListTile(
              leading: Image.network(
                imgBasePlato + plato.id! + imgSuffix,
                fit: BoxFit.contain,
              ),
              title: Text(plato.nombre!),
              subtitle: Text("${plato.precio!} €"),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right_rounded),
                onPressed: () {},
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onTap: () => {}),
    );
  }
}
