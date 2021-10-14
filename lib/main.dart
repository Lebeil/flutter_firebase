import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase'),
        backgroundColor: Colors.amber,
      ),
      body: const Center(
        child: FirebaseMessage(),
      ),
    );
  }
}

class FirebaseMessage extends StatelessWidget {
  const FirebaseMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('message');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc('success').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose s'est mal passé");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return MessageDesign(
            titleMessage: data["title"],
            subtitleMessage: data["sub_title"],
            textMessage: data["text"],
          );
        }
        return const Text("Chargement en cours");
      },
    );
  }
}

class MessageDesign extends StatelessWidget {
  final String titleMessage;
  final String subtitleMessage;
  final String textMessage;
  const MessageDesign(
      {Key? key,
      required this.titleMessage,
      required this.textMessage,
      required this.subtitleMessage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Image.network(
                'https://www.gstatic.com/devrel-devsite/prod/vf2803d8fceba443283ee4e8627acfcc1365957a4f42d24f2965d2cb7faab19ba/firebase/images/touchicon-180.png'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.done, size: 50, color: Colors.green),
              const SizedBox(width: 10),
              Text(
                titleMessage,
                style:
                    const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 20),
          Text(
            subtitleMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Text(
            textMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
