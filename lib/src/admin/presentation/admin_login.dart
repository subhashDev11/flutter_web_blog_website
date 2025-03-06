import 'package:autoformsai_blogs/core/app_router.dart';
import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/layout_components/column_spacer.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: ColumnSpacer(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacerWidget: SizedBox(
          height: 25,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Text(
              "Admin Login",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            controller: _usernameCtrl,
            decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          TextField(
            controller: _passwordCtrl,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 15,
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
              ),
              child: Text(
                errorText!,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () async {
              getIt<EasyLoadingService>().show();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              getIt<EasyLoadingService>().hide();
              if (_passwordCtrl.text == "Subhash10" && _usernameCtrl.text == "Subhash Admin") {
                setState(() {
                  errorText = null;
                });
                await prefs.setBool("authenticated", true,);
                context.go(RouteName.adminHome);
              } else {
                await prefs.setBool("authenticated", false,);
                setState(() {
                  errorText = "Invalid Credentials";
                });
              }
            },
            child: Text(
              "Submit",
            ),
          ),
        ],
      ),
    );
  }
}
