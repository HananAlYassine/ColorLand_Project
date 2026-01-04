import 'package:flutter/material.dart';
import 'colors.dart';
import 'global.dart';


class Page2 extends StatefulWidget {

  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool _load = false; // used toh sow colors list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show colors list
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load colors from database'))
        );
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first time
    updateColors(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9E7),
      appBar: AppBar(
        title: Text(
          'Welcome $globalChildName ✨',
          style: const TextStyle(
            fontFamily: 'Comic Sans MS',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
              onPressed: !_load ? null : () {
                setState(() {
                  _load = false; // show progress bar
                  updateColors(update); // update data asynchronously
                });
              },
              icon: const Icon(Icons.refresh)
          ),
        ],
      ),
      // load colors or progress bar
      body: _load
          ?  const ShowColors()
          : const Center(
          child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator()
          )
      ),
    );
  }
}