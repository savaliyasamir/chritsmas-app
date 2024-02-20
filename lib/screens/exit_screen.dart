// ignore_for_file: sized_box_for_whitespace

import 'dart:io';
import 'package:Santa_prank_call/screens/selet_categories.dart';
import 'package:Santa_prank_call/widget/constant.dart';
import 'package:flutter/material.dart';

class ExitScreen extends StatefulWidget {
  const ExitScreen({Key? key}) : super(key: key);

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PinkColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/exit_screen12.png",
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.53,
            child: Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    exit(0);
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 50,
                    width: 150,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeletctCategerioesScreen(),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 50,
                    width: 150,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
