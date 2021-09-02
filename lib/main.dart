import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app-homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Book Scanner';

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
          primaryColor: Color(0xFFF47D15),
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Colors.white)),
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          ),
          dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
        ),
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: title,
          home: MainPage(title: title),
          localizationsDelegates: [
            DefaultMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
        ),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    @required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(body: AppHomePage()

      // TextRecognitionWidget(),

      );
}
