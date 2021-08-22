import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot/pages/edit_profile_page.dart';
import 'package:spot/pages/login_page.dart';
import 'package:spot/repositories/repository.dart';

class AuthRequired {
  static Future<void> action(BuildContext context,
      {required void Function() action}) async {
    final repository = RepositoryProvider.of<Repository>(context);
    final userId = repository.userId;
    if (userId == null) {
      await Navigator.of(context).push(LoginPage.route());
      return;
    }
    await repository.statusKnown.future;
    final myProfile = repository.myProfile;
    if (myProfile == null) {
      await Navigator.of(context)
          .push(EditProfilePage.route(isCreatingAccount: true));
    } else {
      action();
    }
  }
}
