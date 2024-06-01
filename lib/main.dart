import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:zeffaf/services/notification.service.dart';
import 'package:zeffaf/services/socketService.dart';

import 'appController.dart';
import 'firebase_options.dart';
import 'pages/settings/settings.provider.dart';
import 'routes.dart';
import 'utils/languages.dart';
import 'utils/theme.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  initServices();

//   if (GetPlatform.isAndroid) {
// //    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//   }
//this is our main widget

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChangeFontSize()),
      ],
      child: DynamicTheme(
        defaultThemeId: 0,
        builder: (BuildContext context, ThemeData theme) {
          var fontSize = Provider.of<ChangeFontSize>(context).fontSize;
          fontSize = Get.find<AppController>().fontSize.value;
          return GetMaterialApp(
            title: 'زفاف | Zefaaf',
            debugShowCheckedModeBanner: false,
            theme: theme.copyWith(
                useMaterial3: true,
                textTheme: theme.textTheme.copyWith(
                  bodyMedium: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: fontSize + 14.0),
                  bodyLarge: theme.textTheme.bodyLarge!
                      .copyWith(fontSize: fontSize + 14.0),
                  headlineSmall: theme.textTheme.headlineSmall!
                      .copyWith(fontSize: fontSize + 14.0),
                  headlineMedium: theme.textTheme.headlineMedium!
                      .copyWith(fontSize: fontSize + 14.0),
                  displaySmall: theme.textTheme.displaySmall!
                      .copyWith(fontSize: fontSize + 16.0),
                  displayMedium: theme.textTheme.displayMedium!
                      .copyWith(fontSize: fontSize + 18.0),
                  displayLarge: theme.textTheme.displayLarge!
                      .copyWith(fontSize: fontSize + 14.0),
                  titleMedium: theme.textTheme.titleMedium!
                      .copyWith(fontSize: fontSize + 14.0),
                  titleLarge: theme.textTheme.titleLarge!
                      .copyWith(fontSize: fontSize + 16.0),
                  bodySmall: theme.textTheme.bodySmall!
                      .copyWith(fontSize: fontSize + 10.0),
                )),
            initialRoute: "/",
            getPages: routes(),
            debugShowMaterialGrid: false,
            initialBinding: PagesBind(),
            translations: LanguageTranslation(),
            builder: (_, Widget? child) => Scaffold(
              body: InkWell(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: child,
              ),
            ),
            locale: const Locale('ar', 'EG'),
          );
        },
        themeCollection: ThemeCollection(themes: {
          0: AppTheme.appTheme(Brightness.light),
          1: AppTheme.appTheme(Brightness.dark)
        }),
      ),
    );
  }
}

void initServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut<AppController>(() => AppController());
  await Get.putAsync(() => SocketService().init());
  await Get.putAsync(() => NotificationsService().init());
  await GetStorage.init();
}
