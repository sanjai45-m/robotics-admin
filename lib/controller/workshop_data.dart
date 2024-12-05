import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:jkv/model/workshop_templete.dart';

class WorkshopDataProvider with ChangeNotifier {
  List<WorkshopModel> _workshopModel = [];
  List<WorkshopModel> get workshopModel => _workshopModel;

  void addWorkshopModelData(DateTime id, String workshopName, String collegeName, String dateTime, File? image) {
    _workshopModel.add(
      WorkshopModel(
        id,
        workshopName: workshopName,
        collegeName: collegeName,
        dateTime: dateTime,
        image: image,
      ),
    );
    notifyListeners();
  }

  void addWorkshopDetails(DateTime id, AboutWorkshopDetails details) {
    final workshop = _workshopModel.firstWhere((w) => w.id == id);
    workshop.aboutWorkshopDetails = details;
    notifyListeners();
  }
}
