import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'ListView.dart';
import 'Quiz.dart';

class Page3 extends StatefulWidget {
  final String colorName;
  final Color color;

  const Page3({Key? key, required this.colorName, required this.color}) : super(key: key);

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

    // Set up event listeners
    _player.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isLoading = state == PlayerState.playing ? false : _isLoading;
      });
    });

    _player.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _isLoading = false;
      });
    });

    _player.onLog.listen((log) {
      print('Audio Log: $log');
    });
  }

  Future<void> _playColorAudio() async {
    try {
      if (_isPlaying) {
        await _player.stop();
      }

      setState(() {
        _isLoading = true;
      });

      final filename = "${widget.colorName.toLowerCase()}.mp3";
      final assetPath = "assets_audio/$filename";

      print("🎵 Attempting to play: $assetPath");

      // Stop any current playback
      await _player.stop();

      // Small delay to ensure clean state
      await Future.delayed(const Duration(milliseconds: 50));

      // Play the audio
      await _player.play(AssetSource(assetPath));

    } catch (e) {
      print("❌ Audio error: $e");
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });

      // Show error message to user
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
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentIndex <= 0
                    ? null
                    : () {
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
              ElevatedButton(
                onPressed: currentIndex >= colorsItem.length - 1
                    ? null
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : (_isPlaying ? _stopAudio : _playColorAudio),
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