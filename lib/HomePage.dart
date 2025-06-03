import 'package:flutter/material.dart';

// Stateful widget voor de startpagina
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override   // Maakt de bijbehorende state aan
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  // Sleutel voor toegang tot de Scaffold
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override // Bouwt de interface van de pagina
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          title: const Text(
            'I\'m still standing!',
            style: TextStyle(
              fontFamily: 'Inter Tight',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Welkom bij I\'m still standing, de app om u te helpen goed op uw benen te staan.\n\n'
                          'Zodat u weer met zelfvertrouwen door het leven kunt!\n\n'
                          'Druk op de \'Camera\' knop om uw houding te meten.\n\n'
                          'En druk op de \'Graph\' knop om de resultaten hiervan in te zien.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  // Opent het grafiekoverzicht
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/graph');
                  },
                  child: const Text(
                    'Graph',
                    style: TextStyle(
                      fontFamily: 'Inter Tight',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  // Opent de camerafunctie
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/camera');
                  },
                  child: const Text(
                    'Camera',
                    style: TextStyle(
                      fontFamily: 'Inter Tight',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
