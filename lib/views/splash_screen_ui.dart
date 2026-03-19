import 'package:flutter/material.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
         //ขั้นที่ 1
         Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon/scrumban.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Task Na ja V1'
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
         ),
          //ขั้นที่ 2
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Created by Fluke026 DTI SAU'
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'SOUTH EAST ASIAN UNIVERSITY',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ), 
        ],
      ),
    );
  }
}