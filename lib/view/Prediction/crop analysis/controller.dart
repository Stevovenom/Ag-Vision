import 'dart:io';

import 'package:agrotech_hackat/repo/analysis_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../models/analyse_response.dart';
import 'crop_analysis.dart';

class CropAnalysisController extends GetxController {
  RxString selectedImage = "".obs;
  var resp = AnalyseResponse().obs;
  RxInt selectedIndex = 0.obs;
  int useGemini = 0;
  updateIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  var selectedLang = Language(
    name: 'English',
    code: 'en',
  ).obs;
  double value = 0.5;
  updateValue(double value) {
    this.value = value;
    update();
  }

  selectLanguage(Language lang) {
    selectedLang.value = lang;
    update();
  }

  selectImage(String path) {
    selectedImage.value = path;
    update();
  }

  List<Map<String, String>> langs = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Swahili', 'code': 'sw'},
  ];

  List<Language> get languages => langs
      .map((e) => Language(name: e['name'], code: e['code']))
      .toList(growable: false);

  fetchAnalysis() async {
    if (selectedImage.value != "") {
      EasyLoading.show();
      ClientsRepository rep = Get.put(ClientsRepository());
      final data = await rep.fetchAnalysisData(File(selectedImage.value), {
        'threshold': value.toString(),
        'usecase': 'crop_disease',
        'language': selectedLang.value.code!,
        'use_gemini': useGemini.toString()
      });

      resp.value = data;
      update();
      if (data.mainData != null) {
        Get.to(() => CropAnalysis(data: data));
      }
      //print(data.toJson());
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError('Please select an image');
    }
    // Get.to(() => const PredictionsPage());
  }

  updateUseGemini(int value) {
    useGemini = value;
  }
}

class Language {
  Language({this.name, this.code});
  final String? name;
  final String? code;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}
