import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hr_management_app/worker_details_screen.dart';
import 'package:hr_management_app/request_form.dart'; // Ensure this import is correct
import 'package:hr_management_app/login_screen.dart'; // Ensure you have a login_page.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Good Morning, Dear",
                              style: TextStyle(
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueAccent,
                            image: DecorationImage(
                              image: AssetImage("assets/user1.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          enabled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Feather.search,
                            color: Colors.black,
                            size: 25,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Departments",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 20),
                        departmentCard(
                          "Development",
                          88,
                          "techies",
                          Colors.blueAccent,
                          "💻",
                        ),
                        departmentCard(
                          "UI/UX Design",
                          45,
                          "creatives",
                          Colors.orangeAccent,
                          "🎨",
                        ),
                        departmentCard(
                          "QA Engineers",
                          24,
                          "helpers",
                          Colors.redAccent,
                          "💻",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "You recently worked with",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      usersWokredWith(
                        "Zeid Ayouni",
                        "assets/user2.jpg",
                        Colors.blueAccent,
                        "Frontend Developer",
                      ),
                      usersWokredWith(
                        "Amir Ayouni",
                        "assets/user3.jpg",
                        Colors.redAccent,
                        "QA Assistant",
                      ),
                      usersWokredWith(
                        "Aziz Ayouni",
                        "assets/user4.jpg",
                        Colors.orangeAccent,
                        "UI/UX Designer",
                      ),
                    ],
                  ),
                  SizedBox(
                      height: 70), // To ensure there's space for the fixed box
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen()), // Ensure you have a LoginPage
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RequestPage()), // Use RequestPage
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget usersWokredWith(
      String name, String image, Color color, String jobTitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          String _job;
          if (color == Colors.blueAccent) {
            _job = "Developer";
          } else if (color == Colors.redAccent) {
            _job = "Engineer";
          } else {
            _job = "Designer";
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerDetailsScreen(
                name: name,
                image: image,
                color: color,
                jobTitle: jobTitle,
                job: _job,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: ListTile(
              leading: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blueAccent,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                jobTitle,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              trailing: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(
                    child: Icon(
                      FontAwesome5Regular.edit,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget departmentCard(
      String name, int number, String title, Color color, String emoji) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                number.toString() + " " + title,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
