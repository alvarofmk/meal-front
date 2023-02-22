import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:front/home_screen.dart';
import 'package:front/model/restaurante_detail.dart';
import 'package:front/photo_bloc/edit_photo_screen.dart';
import 'package:front/restaurant_form/restaurant_form_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../photo_bloc/photo_bloc.dart';

class RestaurantForm extends StatefulWidget {
  RestaurantForm({Key? key}) : super(key: key);

  @override
  State<RestaurantForm> createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final picker = ImagePicker();
  late File _image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<RestaurantFormBloc>(context);

          return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: BlocProvider(
                create: (context) => PhotoBloc(),
                child: Builder(
                  builder: (context) {
                    final photoBloc = BlocProvider.of<PhotoBloc>(context);
                    return Scaffold(
                      backgroundColor: Colors.red.shade700,
                      appBar: AppBar(title: const Text('Restaurante')),
                      body:
                          FormBlocListener<RestaurantFormBloc, String, String>(
                        onSubmitting: (context, state) {
                          LoadingDialog.show(context);
                        },
                        onSuccess: (context, state) {
                          LoadingDialog.hide(context);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()));
                        },
                        onFailure: (context, state) {
                          LoadingDialog.hide(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.failureResponse!)));
                        },
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.nombre,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre',
                                    prefixIcon: Icon(Icons.business),
                                  ),
                                ),
                                TextFieldBlocBuilder(
                                  textFieldBloc: formBloc.descripcion,
                                  decoration: const InputDecoration(
                                    labelText: 'Descripción',
                                    prefixIcon: Icon(Icons.text_fields),
                                  ),
                                ),
                                TimeFieldBlocBuilder(
                                  timeFieldBloc: formBloc.apertura,
                                  format: DateFormat('hh:mm a'),
                                  initialTime: TimeOfDay(hour: 12, minute: 00),
                                  decoration: const InputDecoration(
                                    labelText: 'Apertura',
                                    prefixIcon: Icon(Icons.access_time),
                                  ),
                                ),
                                TimeFieldBlocBuilder(
                                  timeFieldBloc: formBloc.cierre,
                                  format: DateFormat('hh:mm a'),
                                  initialTime: TimeOfDay(hour: 12, minute: 00),
                                  decoration: const InputDecoration(
                                    labelText: 'Cierre',
                                    prefixIcon: Icon(Icons.time_to_leave),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    selectPhoto(ImageSource.gallery);
                                  },
                                  child: BlocBuilder<PhotoBloc, PhotoState>(
                                    bloc: photoBloc,
                                    builder: (context, state) {
                                      return Container(
                                        height: 150,
                                        width: 150,
                                        child: state is PhotoInitial
                                            ? Image.asset(
                                                'assets/default-restaurant.jpg')
                                            : Image.file(
                                                (state as PhotoSet).photo),
                                      );
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: formBloc.submit,
                                  child: const Text('SUBMIT'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
        },
      ),
    );
  }

  Future selectPhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPhotoPage(
                      image: _image,
                    )));
      } else
        print('No photo was selected or taken');
    });
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
