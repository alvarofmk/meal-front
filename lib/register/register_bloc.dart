import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RegisterFormBloc extends FormBloc<String, String> {
  final registerAsOwner = BooleanFieldBloc();

  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  final verifyPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  final email = TextFieldBloc<String>(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final name = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  RegisterFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [registerAsOwner],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [username, password, verifyPassword, email, name],
    );
  }

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      emitSuccess();
    } else if (state.currentStep == 1) {
      if (password.value != verifyPassword.value) {
        verifyPassword.addFieldError("Las contraseñas no coinciden");
        emitFailure();
      } else {
        emitSuccess();
      }
    }
  }
}
