import 'package:flutter/material.dart';

abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottemNavBar extends AppStates{}

class AppChangeFloatingIcon extends AppStates{}

class AppGetDatabaseState extends AppStates{}

class AppInsertDatabaseState extends AppStates{}

class AppUpdateDatabaseState extends AppStates{}

class AppDeleteDatabaseState extends AppStates{}

