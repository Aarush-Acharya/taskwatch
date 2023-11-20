import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:taskwatch/result_screen.dart';
import 'package:window_location_href/window_location_href.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client = Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject("655b10516fd64a4e4c69");
  ;
  Account account = Account(client);
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: HomeScreen(
      account: account,
    ),
  ));
}

class HomeScreen extends StatelessWidget {
  Account account;
  final Uri? location = href == null ? null : Uri.parse(href!);
  HomeScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(left: 50, top: 130),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 570),
                child: Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 55, 208, 255)),
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(204, 9, 145, 195),
                        Color.fromARGB(184, 9, 98, 146)
                      ])),
                  child: Center(
                    child: Text(
                      'Task-Watch',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Analyse, Predict Productivity, \n and Scale Yourself.',
                style: TextStyle(color: Colors.white, fontSize: 58),
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                  padding: EdgeInsets.only(right: 120),
                  child: Container(
                      width: 600,
                      child: Text(
                        'Brace the nature of your Productivity in the form of a Dashboard, having sight on its Future Prediction, along with a customised Guide to offer assistance and suggetion helping you in your journey to attain higher productivity levels',
                        style: TextStyle(
                            color: Color.fromARGB(178, 255, 255, 255),
                            fontSize: 20),
                      )))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 950, top: 250),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(174, 100, 136, 153)),
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(44, 86, 123, 131)),
            height: 300,
            width: 400,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFFFE0),
                            maximumSize: Size(250, 50),
                            minimumSize: Size(250, 50)),
                        onPressed: () async {
                          await account.createOAuth2Session(
                            provider: 'github',
                            scopes: ["public_repo"],
                            success:
                                kIsWeb ? '${location?.origin}/auth.html' : null,
                          );
                          Session session = await account.getSession(
                            sessionId: 'current',
                          );
                          String accessToken = session.providerAccessToken;
                          print(accessToken);

                          var url = Uri.parse('https://api.github.com/user');
                          var response = await http.get(
                            url,
                            headers: {
                              'Accept': 'application/vnd.github+json',
                              'Authorization': 'Bearer $accessToken',
                              'X-GitHub-Api-Version': '2022-11-28',
                            },
                          );
                          var jsonResponse;
                          if (response.statusCode == 200) {
                            jsonResponse = jsonDecode(response.body);
                            print(jsonResponse['name']);
                            // Handle the jsonResponse here
                            print(jsonResponse);
                          } else {
                            print(
                                'Request failed with status: ${response.statusCode}.');
                          }
                          var headers = {
                            'Authorization': 'bearer $accessToken',
                            'Content-Type': 'application/json'
                          };
                          var request = http.Request('POST',
                              Uri.parse('https://api.github.com/graphql'));
                          request.body = json.encode({
                            "query":
                                'query { user(login: \"${jsonResponse['login']}\") { name contributionsCollection { contributionCalendar { colors totalContributions weeks { contributionDays { color contributionCount date weekday } firstDay } } } } }'
                          });
                          request.headers.addAll(headers);

                          http.StreamedResponse response_body =
                              await request.send();
                          var data;
                          if (response.statusCode == 200) {
                            data = jsonDecode(
                                await response_body.stream.bytesToString());
                            data = data['data'];
                            data = data['user'];
                            print(data);
                          } else {
                            print(response_body.reasonPhrase);
                          }
                          var Headers = {'Content-Type': 'application/json'};
                          var request_plot = http.Request(
                              'POST', Uri.parse('http://0.0.0.0:80/predict'));
                          request_plot.body = json.encode({
                            "name": "Aarush Acharya",
                            "contributionsCollection": {
                              "contributionCalendar": {
                                "colors": [
                                  "#9be9a8",
                                  "#40c463",
                                  "#30a14e",
                                  "#216e39"
                                ],
                                "totalContributions": 508,
                                "weeks": [
                                  {
                                    "contributionDays": [
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-11-20",
                                        "weekday": 0
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-11-21",
                                        "weekday": 1
                                      },
                                      {
                                        "color": "#9be9a8",
                                        "contributionCount": 3,
                                        "date": "2022-11-22",
                                        "weekday": 2
                                      },
                                      {
                                        "color": "#9be9a8",
                                        "contributionCount": 2,
                                        "date": "2022-11-23",
                                        "weekday": 3
                                      },
                                      {
                                        "color": "#9be9a8",
                                        "contributionCount": 3,
                                        "date": "2022-11-24",
                                        "weekday": 4
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-11-25",
                                        "weekday": 5
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-11-26",
                                        "weekday": 6
                                      }
                                    ],
                                    "firstDay": "2022-11-20"
                                  },
                                  {
                                    "contributionDays": [
                                      {
                                        "color": "#9be9a8",
                                        "contributionCount": 1,
                                        "date": "2022-11-27",
                                        "weekday": 0
                                      },
                                      {
                                        "color": "#9be9a8",
                                        "contributionCount": 1,
                                        "date": "2022-11-28",
                                        "weekday": 1
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-11-29",
                                        "weekday": 2
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-11-30",
                                        "weekday": 3
                                      },
                                      {
                                        "color": "#40c463",
                                        "contributionCount": 6,
                                        "date": "2022-12-01",
                                        "weekday": 4
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-12-02",
                                        "weekday": 5
                                      },
                                      {
                                        "color": "#ebedf0",
                                        "contributionCount": 0,
                                        "date": "2022-12-03",
                                        "weekday": 6
                                      }
                                    ],
                                    "firstDay": "2022-11-27"
                                  }
                                ]
                              }
                            }
                          });
                          request_plot.headers.addAll(Headers);
                          http.StreamedResponse response_plot =
                              await request_plot.send();
                          Uint8List imageBytes;
                          if (response_plot.statusCode == 200) {
                            List<int> bytes =
                                await response_plot.stream.toBytes();
                            // Convert bytes to image
                            if (bytes.isNotEmpty) {
                              imageBytes = Uint8List.fromList(bytes);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResultScreen(imageBytes: imageBytes)),
                              );
                              // Display the image using Image.memory or use it in your UI
                            } else {
                              print('Empty response body');
                            }
                          } else {
                            print(response_plot.reasonPhrase);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset('assets/github_icon.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Log in with Github",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
