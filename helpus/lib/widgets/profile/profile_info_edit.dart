import 'package:flutter/material.dart';

// Profile information edit widget
class ProfileInfoEdit extends StatefulWidget {
  final String title;
  final String value;
  final Function(String) submission;
  const ProfileInfoEdit({
    Key? key,
    required this.title,
    required this.value,
    required this.submission,
  }) : super(key: key);

  @override
  ProfileInfoEditState createState() => ProfileInfoEditState();
}

class ProfileInfoEditState extends State<ProfileInfoEdit> {
  TextEditingController? _textController;
  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: widget.value);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  widget.submission(
                    _textController!.text,
                  );
                },
                icon: const Icon(
                  Icons.navigate_next_rounded,
                ),
                label: const Text(
                  'Update',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController!.dispose();
    super.dispose();
  }
}
