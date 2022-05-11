import 'package:flutter/material.dart';

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
  _ProfileInfoEditState createState() => _ProfileInfoEditState();
}

class _ProfileInfoEditState extends State<ProfileInfoEdit> {
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
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.black,
                  ),
                  onPressed: widget.submission(
                    _textController!.text,
                  ),
                ),
              ],
            ),
          )
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
