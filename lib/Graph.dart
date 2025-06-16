import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Genereert een stateful widget voor de grafiekweergave
class GraphWidget extends StatefulWidget {
  const GraphWidget({super.key});

  static String routeName = 'Graph';
  static String routePath = '/graph';

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late List<FlSpot> _data;

  @override
  void initState() {
    super.initState();
    // Initialiseert willekeurige grafiekdata bij het opstarten
    _data = _generateRandomData(5);
  }

  // Genereert een lijst met willekeurige datapunten voor de grafiek
  List<FlSpot> _generateRandomData(int count) {
    final random = Random();
    return List.generate(
      count,
          (i) => FlSpot(i.toDouble(), random.nextInt(10).toDouble()),
    );
  }

  @override
  // Bouwt de gebruikersinterface van de grafiekpagina
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Graph',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Inter Tight',
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SizedBox(
                width: 370,
                height: 400,
                // Tekent linechart
                child: LineChart(
                  LineChartData(
                    //verberg grid
                    gridData: FlGridData(show: false),
                    // Verberg border
                    borderData: FlBorderData(show: false),
                    // Instellingen voor de axis titles
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    // Line chart data en stijl
                    lineBarsData: [
                      LineChartBarData(
                        spots: _data,
                        isCurved: true,
                        barWidth: 2,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
