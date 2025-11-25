import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'ListView.dart';
import 'Quiz.dart';

// This page shows a single color with its name and plays its audio.
class Page3 extends StatefulWidget {
  final String colorName; // The name of the selected color
  final Color color; // The color value

  const Page3({Key? key, required this.colorName, required this.color}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  // --------------- Audio -----------------------
  late AudioPlayer _player; // Audio player object
  bool _isPlaying = false;  // To check if audio is currently playing
  bool _isLoading = false;  // To show loading indicator before playing audio

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();  // Prepare the audio player when the page loads
  }

  // Initialize the audio player and listen for events
  Future<void> _initAudioPlayer() async {
    _player = AudioPlayer();

    // Listen for changes in the audio state (playing, stopped...)
    _player.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;  // true if audio is playing
        _isLoading = state == PlayerState.playing ? false : _isLoading;
      });
    });


    // When audio finishes completely
    _player.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _isLoading = false;
      });
    });

    // Debug logs (useful when something goes wrong)
    _player.onLog.listen((log) {
      print('Audio Log: $log');
    });
  }

  // Function to play the audio file for this color
  Future<void> _playColorAudio() async {
    try {
      // If something is playing now, stop it
      if (_isPlaying) {
        await _player.stop();
      }

      setState(() {
        _isLoading = true; // Show loading animation
      });

      // Convert color name to filename (ex: Red → red.mp3)
      final filename = "${widget.colorName.toLowerCase()}.mp3";
      final assetPath = "assets_audio/$filename";

      print("🎵 Attempting to play: $assetPath");

      // Stop previous audio
      await _player.stop();

      // Small delay to ensure clean state
      await Future.delayed(const Duration(milliseconds: 50));

      // Play the audio from assets folder
      await _player.play(AssetSource(assetPath));

    } catch (e) {
      print("❌ Audio error: $e");
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });

      // Show error message to user on screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not play audio. Please try again."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Stop button action
  Future<void> _stopAudio() async {
    try {
      await _player.stop();
      setState(() {
        _isPlaying = false;
        _isLoading = false;
      });
    } catch (e) {
      print("Stop error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();   // Clean up the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the index of current color inside the list (for next/previous buttons)
    int currentIndex = colorsItem.indexWhere((c) => c.name == widget.colorName);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Let\'s have fun learning colors today! 🖌️🌟',
          style: TextStyle(
              fontFamily: 'Comic Sans MS',
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
            backgroundColor: widget.color,
          ),
          Text(
            widget.colorName,
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: widget.color,
              fontFamily: 'Comic Sans MS',
            ),
          ),
          const SizedBox(height: 10),
          // -------------- NEXT + PREVIOUS Color Buttons -----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentIndex <= 0
                    ? null // Disable button if this is the first color
                    : () {
                  // Go to previous color
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Page3(
                            colorName: colorsItem[currentIndex - 1].name,
                            color: colorsItem[currentIndex - 1].backgroundColor,
                          )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Previous Color",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(width: 25),

              //---------- NEXT COLOR button--------------
              ElevatedButton(
                onPressed: currentIndex >= colorsItem.length - 1
                    ? null // Disable on last color
                    : () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Page3(
                            colorName: colorsItem[currentIndex + 1].name,
                            color: colorsItem[currentIndex + 1].backgroundColor,
                          )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Row(
                  children: [
                    Text("Next Color",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),

          // ----------- Bottom buttons---------------------
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Go back to ListView page
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text('Previous Page',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),

                // ------ audio button -------------
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null // the button is disabled
                      : (_isPlaying ? _stopAudio : _playColorAudio),
                  // Show loading icon
                  icon: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Icon(
                      _isPlaying ? Icons.stop : Icons.volume_up,
                      color: Colors.white
                  ),
                  label: Text(
                    _isLoading ? 'Loading...' : (_isPlaying ? 'Stop' : 'Voice'),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlaying ? Colors.red : Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),

                //---------- Go to Quiz page------------
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const QuizPage()));
                  },
                  icon: const Icon(Icons.quiz, color: Colors.white),
                  label: const Text('Quiz',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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