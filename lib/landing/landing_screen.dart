import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/landing/landing_bloc.dart';
import 'package:front/model/RestauranteListResult.dart';

const String imgBase = "http://localhost:8080/restaurante/";
const String imgSuffix = "/img/";

final TextEditingController controller = new TextEditingController();

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LandingBloc()..add(RestaurantsFetched()),
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset('assets/logo.png'),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    BlocProvider.of<LandingBloc>(context)
                        .add(RestaurantsFetched());
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.red.shade700,
                ),
              )
            ],
            elevation: 0,
            scrolledUnderElevation: 1,
            backgroundColor: Colors.white,
          ),
          body: RestaurantList()),
    );
  }
}

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingBloc, LandingState>(
      builder: (context, state) {
        switch (state.status) {
          case LandingStatus.failure:
            return const Center(
                child: Text('Fallo al cargar los restaurantes'));
          case LandingStatus.success:
            if (state.restaurantes.isEmpty) {
              return const Center(child: Text('No se encuentran restaurantes'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.restaurantes.length
                    ? const BottomLoader()
                    : RestauranteItem(restaurante: state.restaurantes[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.restaurantes.length
                  : state.restaurantes.length + 1,
              controller: _scrollController,
            );
          case LandingStatus.initial:
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
    if (_isBottom) context.read<LandingBloc>().add(RestaurantsFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}

class RestauranteItem extends StatelessWidget {
  const RestauranteItem({super.key, required this.restaurante});

  final RestauranteGeneric restaurante;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Card(
        child: Column(children: [
          Image.network(imgBase + restaurante.id! + imgSuffix),
          Text(restaurante.nombre!),
        ]),
      ),
    );
  }
}
