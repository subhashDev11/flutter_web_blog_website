
import 'package:autoformsai_blogs/core/app_logger.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> getItLocator() async {
  try {
    getIt.registerSingleton<EasyLoadingService>(EasyLoadingService());
  }catch(e){
    AppLogger.d(e.toString());
  }
}
