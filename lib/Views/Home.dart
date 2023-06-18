import 'package:flutter/material.dart';
import 'package:remessasentregas/Views/EntregasAndamento.dart';
import 'package:remessasentregas/Views/EntregasRealizadas.dart';
import 'package:remessasentregas/Views/NovaRemessa.dart';
import 'package:remessasentregas/Views/Remessas.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entregas App'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          RemessasPendentesPage(),
          EntregasEmAndamentoPage(),
          EntregasRealizadasPage(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'Pendentes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Andamento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Realizadas',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_currentPageIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NovaRemessaPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      );
    } else {
      return null;
    }
  }
}
