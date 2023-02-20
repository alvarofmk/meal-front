import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RestaurantFormBloc extends FormBloc<String, String> {
  final nombre = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final descripcion = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final apertura = InputFieldBloc<TimeOfDay?, Object>(
    initialValue: TimeOfDay(hour: 12, minute: 00),
    validators: [FieldBlocValidators.required],
  );

  final cierre = InputFieldBloc<TimeOfDay?, Object>(
    initialValue: TimeOfDay(hour: 12, minute: 00),
    validators: [FieldBlocValidators.required],
  );

  RestaurantFormBloc() {
    addFieldBlocs(fieldBlocs: [nombre, descripcion, apertura, cierre]);
  }

  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      emitFailure();
    }
  }
}
