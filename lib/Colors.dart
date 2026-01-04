import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'Quiz.dart';
import 'global.dart';

// main URL for REST pages
const String _baseURL = 'http://hananalyassine.atwebpages.com';

// --- CLASS TO REPRESENT A COLOR ROW ---
class ColorItem {
  final int _id;
  final String _name;
  final String _hexCode;
  final String _audioFile;
  final int _orderNum;

  ColorItem(this._id, this._name, this._hexCode, this._audioFile, this._orderNum);

  // Convert hex string to Color object
  Color get backgroundColor {
    try {
      String hex = _hexCode.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF' + hex;
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  // Determines readable text color based on background brightness
  Color get color {
    final bgColor = backgroundColor;
    final luminance = bgColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  String get audioFileName => _audioFile;

  @override
  String toString() {
    return 'Color: $_name\nHex: $_hexCode\nAudio: $_audioFile\nOrder: $_orderNum';
  }
}

// Global list that stores colors fetched from the database
List<ColorItem> _colors = [];



// ================= FETCH COLORS FROM SERVER =================
// Asynchronously loads colors from backend and updates list
 void updateColors(Function(bool success) update) async {
  try {
    // FIXED: Using Uri.parse for more reliable URL construction
    final url = Uri.parse('$_baseURL/getColors.php');

    final response = await http.get(url).timeout(const Duration(seconds: 10));

    // Clear old data
    _colors.clear();

    // Check for successful response
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);

      // Ensure returned data is a list
      if (jsonResponse is List) {
        // Convert each row into ColorItem

        for (var row in jsonResponse) {
          ColorItem c = ColorItem(
              int.parse(row['id'].toString()),
              row['name'].toString(),
              row['hex_code'].toString(),
              row['audio_file']?.toString() ?? '',
              int.parse(row['order_num'].toString())
          );
          _colors.add(c);
        }

  // Sort colors by order number
  _colors.sort((a, b) => a._orderNum.compareTo(b._orderNum));
        update(true);
      } else {
        update(false);
      }
    } else {
      update(false);
    }
  } catch (e) {
    debugPrint("Error fetching colors: $e");
    update(false);
  }
}

// ================= COLORS LIST VIEW =================

class ShowColors extends StatelessWidget {
  const ShowColors({
    super.key
  });

  @override
  Widget build(BuildContext context) {

    // Show message if no colors exist
    if (_colors.isEmpty) {
      return const Center(child: Text("No colors found."));
    }

    // Build scrollable list of colors
    return ListView.builder(
      itemCount: _colors.length,
      itemBuilder: (context, index) => Column(
        children: [
          const SizedBox(height: 10),
          // Detect tap on color item
          GestureDetector(
            onTap: () {
              // Navigate to color detail page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Page3(colorItem: _colors[index]

                  ),
                ),
              );
            },

            // Color card UI
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              height: 90,
              decoration: BoxDecoration(
                color: _colors[index].backgroundColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),

              // Color name
              child: Center(
                child: ListTile(
                  title: Text(
                    _colors[index]._name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _colors[index].color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Comic Sans MS',
                    ),
                  ),


                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- COLOR DETAIL PAGE ---
class Page3 extends StatefulWidget {
  final ColorItem colorItem;

  const Page3({Key? key, required this.colorItem}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _player = AudioPlayer();

    _player.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _isLoading = state == PlayerState.playing ? false : _isLoading;
        });
      }
    });

    _player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _playColorAudio() async {
    try {
      final audioFile = widget.colorItem.audioFileName;
      if (audioFile.isEmpty) return;

      setState(() => _isLoading = true);

      // Path format for assets
      final assetPath = "assets_audio/$audioFile";

      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Audio error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _stopAudio() async {
    await _player.stop();
    setState(() {
      _isPlaying = false;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = _colors.indexWhere((c) => c._id == widget.colorItem._id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Colors! 🖌️🌟',
          style: TextStyle(fontFamily: 'Comic Sans MS', color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 100,
            backgroundColor: widget.colorItem.backgroundColor,
          ),
          Text(
            widget.colorItem._name,
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: widget.colorItem.backgroundColor,
              fontFamily: 'Comic Sans MS',
            ),
          ),

          // Previous / Next navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentIndex <= 0
                    ? null
                    : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Page3(colorItem: _colors[currentIndex - 1]))),
                child: const Text("Previous",
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                  ),

                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(width: 25),

              ElevatedButton(
                onPressed: currentIndex >= _colors.length - 1
                    ? null
                    : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Page3(colorItem: _colors[currentIndex + 1]))),
                child: const Text("Next",
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                  ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

          // Bottom buttons (Back, Voice, Quiz)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // ======= Back Button ===========
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                ),


                // ============ Play / Stop audio button =============
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : (_isPlaying ? _stopAudio : _playColorAudio),
                  icon: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                  label: Text(
                    _isLoading ? '...' : (_isPlaying ? 'Stop' : 'Voice'),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                ),


                // ============ Quiz button==============
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage(
                    childId: globalChildId!,
                  ))),
                  icon: const Icon(Icons.quiz),
                  label: const Text('Quiz',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}