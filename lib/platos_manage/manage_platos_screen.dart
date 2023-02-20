import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/platos_manage/platos_manage_bloc.dart';

import '../landing/landing_screen.dart';
import '../model/plato_list_result.dart';
import '../restaurantmenu/restaurant_screen.dart';

String id = "";
const String imgBasePlato = "http://localhost:8080/plato/";
const String imgSuffix = "/img/";

class ManagePlatosScreen extends StatelessWidget {
  ManagePlatosScreen({super.key, required this.restaurantId});

  String restaurantId;

  @override
  Widget build(BuildContext context) {
    id = restaurantId;
    return BlocProvider(
      create: (context) =>
          PlatosManageBloc()..add(PlatosFetchedEvent(restaurantId)),
      child: ManagePlatosScreenUI(),
    );
  }
}

class ManagePlatosScreenUI extends StatefulWidget {
  @override
  State<ManagePlatosScreenUI> createState() => _ManagePlatosScreenUIState();
}

class _ManagePlatosScreenUIState extends State<ManagePlatosScreenUI> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatosManageBloc, PlatosManageState>(
      builder: (context, state) {
        switch (state.status) {
          case PlatosManageStatus.failure:
            return const Center(child: Text('Fallo al cargar los platos'));
          case PlatosManageStatus.success:
            return Scaffold(
              appBar: AppBar(
                title: Text("Platos"),
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.platos.length
                            ? const BottomLoader()
                            : PlatoManageItem(plato: state.platos[index]);
                      },
                      itemCount: state.hasReachedMax
                          ? state.platos.length
                          : state.platos.length + 1,
                      controller: _scrollController,
                    ))
                  ]),
            );
          case PlatosManageStatus.initial:
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
    if (_isBottom) context.read<PlatosManageBloc>().add(PlatosFetchedEvent(id));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class PlatoManageItem extends StatelessWidget {
  const PlatoManageItem({super.key, required this.plato});

  final PlatoGeneric plato;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Container(
        height: 70,
        child: ListTile(
          leading: Image.network(
            imgBasePlato + plato.id! + imgSuffix,
            fit: BoxFit.contain,
          ),
          title: Text(plato.nombre!),
          subtitle: Text("${plato.precio!} €"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade700,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: Icon(Icons.image),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade700,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade700,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () => _dialogBuilder(context, plato),
                    icon: Icon(Icons.delete),
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext dialogContext, PlatoGeneric plato) {
    return showDialog<void>(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Eliminar ${plato.nombre}?'),
          content: Text(
              """¿Estás seguro de querer eliminar ${plato.nombre}? Esta acción no se puede deshacer. Se eliminarán además todas las valoraciones que tenga el plato."""),
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
                BlocProvider.of<PlatosManageBloc>(dialogContext)
                  ..add(DeletePlatoEvent(plato.id!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
