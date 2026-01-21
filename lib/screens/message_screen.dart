import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final List<String> doctorImages = [
    'assets/d1.png',
    'assets/d2.png',
    'assets/d3.png',
    'assets/d4.webp',
    'assets/d5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Messages", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),


            Text("Active Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Container(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: doctorImages.length,
                separatorBuilder: (_, __) => SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(doctorImages[index]),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.green,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            Text("Recent Chat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),


            Expanded(
              child: ListView.builder(
                itemCount: doctorImages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            doctorName: "Dr. Doctor ${index + 1}",
                            doctorImage: doctorImages[index],
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(doctorImages[index]),
                    ),
                    title: Text("Dr. Doctor ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Hello, Doctor are you there?"),
                    trailing: Text("12:30"),
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final String doctorName;
  final String doctorImage;

  const ChatDetailScreen({
    required this.doctorName,
    required this.doctorImage,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(doctorName),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ChatBubble(
                    message: "Hello Doctor, are you there?",
                    isSender: false,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ChatBubble(
                    message: "Yes, how can I help you?",
                    isSender: true,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    // Send button tapped
                    if (_messageController.text.trim().isNotEmpty) {
                      print("Send: ${_messageController.text}");
                      _messageController.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({
    required this.message,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSender ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(isSender ? 16 : 0),
          bottomRight: Radius.circular(isSender ? 0 : 16),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(color: isSender ? Colors.white : Colors.black),
      ),
    );
  }
}
