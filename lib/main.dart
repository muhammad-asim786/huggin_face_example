import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Uint8List?> fetchImage() async {
    log('this is your text which you take form the input:${inputText}');
    String apiURL =
        "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0";

    final Map<String, String> headers = {
      "Authorization": "Bearer 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",
    };

    final Map<String, dynamic> payload = {
      "inputs": inputText,
    };

    final http.Response response = await http.post(
      Uri.parse(apiURL),
      headers: headers,
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      // Handle the error here
      log("Error: ${response.statusCode}");
      return null;
    }
  }

  bool checkTheWidget = false;

  TextEditingController controller = TextEditingController();

  String? inputText;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Display Example'),
        ),
        body: SizedBox(
          height: 700,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  checkTheWidget
                      ? Center(
                          child: FutureBuilder<Uint8List?>(
                            future: fetchImage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 500,
                                        height: 500,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                        ),
                                        child: Column(
                                          children: [
                                            ClipPath(
                                              clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Image.memory(
                                                snapshot
                                                    .data!, // Display the image bytes
                                                fit: BoxFit
                                                    .fill, // You can adjust BoxFit as needed
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const Text('No image data available.');
                              }
                            },
                          ),
                        )
                      : Center(
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                  hintText: 'Enter a search term',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                        ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          inputText = controller.text;
                          checkTheWidget = !checkTheWidget;
                        });
                      },
                      child: const Text('Convert To Image'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
