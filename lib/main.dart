import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:window_location_href/window_location_href.dart';
import 'package:flutter/material.dart';

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
