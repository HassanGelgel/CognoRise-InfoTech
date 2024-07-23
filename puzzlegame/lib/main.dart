import 'package:flutter/material.dart';
import 'dart:math';

import 'package:quickalert/quickalert.dart';

void main() {
  runApp(CardboardPuzzleGame());
}

class CardboardPuzzleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardboard Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  void _navigateToDifficultySelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DifficultySelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to the Cardboard Puzzle Game!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _navigateToDifficultySelection(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Start Game',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DifficultySelectionPage extends StatelessWidget {
  void _startGame(BuildContext context, int gridSize) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PuzzleHomePage(gridSize: gridSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Game'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _startGame(context, 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
                child: Text(
                  'Easy (3x3)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: () => _startGame(context, 4),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Medium (4x4)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: () => _startGame(context, 5),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 92, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Hard (5x5)',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PuzzleHomePage extends StatefulWidget {
  final int gridSize;

  PuzzleHomePage({required this.gridSize});

  @override
  _PuzzleHomePageState createState() => _PuzzleHomePageState();
}

class _PuzzleHomePageState extends State<PuzzleHomePage> {
  late List<int> _tiles;
  late int _emptyTile;

  @override
  void initState() {
    super.initState();
    _initializeTiles();
  }

  void _initializeTiles() {
    int numTiles = widget.gridSize * widget.gridSize;
    _tiles = List.generate(numTiles, (index) => index);
    _emptyTile = numTiles - 1;
    _shuffleTiles();
  }

  void _shuffleTiles() {
    _tiles.shuffle(Random());
    _emptyTile = _tiles.indexOf(_tiles.length - 1);
    setState(() {});
  }

  void _onTileTap(int index) {
    if (_isMovable(index)) {
      setState(() {
        _tiles[_emptyTile] = _tiles[index];
        _tiles[index] = _tiles.length - 1;
        _emptyTile = index;
      });
      if (_isSolved()) {
        _showSolvedDialog();
      }
    }
  }

  bool _isMovable(int index) {
    int gridSize = widget.gridSize;
    int row = index ~/ gridSize;
    int col = index % gridSize;
    int emptyRow = _emptyTile ~/ gridSize;
    int emptyCol = _emptyTile % gridSize;
    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  bool _isSolved() {
    for (int i = 0; i < _tiles.length - 1; i++) {
      if (_tiles[i] != i) return false;
    }
    return true;
  }

  void _showSolvedDialog() {
    QuickAlert.show(context: context, type: QuickAlertType.success,text: 'You solved the puzzle',title: "Congratulations!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardboard Puzzle Game'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.gridSize,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTileTap(index),
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: _tiles[index] == _tiles.length - 1
                              ? Colors.transparent
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: _tiles[index] == _tiles.length - 1
                              ? []
                              : [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _tiles[index] == _tiles.length - 1
                                ? ''
                                : '${_tiles[index] + 1}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _tiles.length,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _shuffleTiles,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Shuffle',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: _showSolvedDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Test After Solving',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
