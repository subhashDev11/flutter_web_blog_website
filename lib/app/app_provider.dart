import 'package:autoformsai_blogs/app/app_widget.dart';
import 'package:autoformsai_blogs/src/home/state/blog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BlogCubit(),),
      ],
      child: AppWidget(),
    );
  }
}
