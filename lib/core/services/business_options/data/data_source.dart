import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'model.dart';

abstract class BusinessOptionsRemoteDataSource {
  Future<List<SegmentsModel>> getSegments();
  Future<List<SubSegmentsModel>> getSubSegments();
  Future<List<TeamSizeModel>> getTeamSize();
  Future<List<MainObjectiveModel>> getMainObjectives();
}

class BusinessOptionsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements BusinessOptionsRemoteDataSource {
  BusinessOptionsRemoteDataSourceImpl({super.client, super.rawUrl, super.timeout});

  @override
  Future<List<TeamSizeModel>> getTeamSize() async {
    final uri = buildUriRaw('v1/business/team_size.json');

    try {
      final res = await getJson(uri);

      final List data = jsonDecode(res.body);
      return data.map((e) => TeamSizeModel.fromMap(e)).toList();
    } catch (e) {
      final localData = await rootBundle.loadString(
        'assets/raw/v1/data/team_size.json',
      );
      final List data = jsonDecode(localData);
      return data.map((e) => TeamSizeModel.fromMap(e)).toList();
    }
  }

  @override
  Future<List<MainObjectiveModel>> getMainObjectives() async {
    final uri = buildUriRaw('v1/business/main_objective.json');

    try {
      final res = await getJson(uri);

      final List data = jsonDecode(res.body);
      return data.map((e) => MainObjectiveModel.fromMap(e)).toList();
    } catch (e) {
      final localData = await rootBundle.loadString(
        'assets/raw/v1/data/main_objective.json',
      );
      final List data = jsonDecode(localData);
      return data.map((e) => MainObjectiveModel.fromMap(e)).toList();
    }
  }

  @override
  Future<List<SegmentsModel>> getSegments() async {
    final uri = buildUriRaw('v1/segments/segments.json');

    try {
      final res = await getJson(uri);

      final List data = jsonDecode(res.body);
      return data.map((e) => SegmentsModel.fromMap(e)).toList();
    } catch (e) {
      final localData = await rootBundle.loadString(
        'assets/raw/v1/data/segments.json',
      );
      final List data = jsonDecode(localData);
      return data.map((e) => SegmentsModel.fromMap(e)).toList();
    }
  }

  @override
  Future<List<SubSegmentsModel>> getSubSegments() async {
    final uri = buildUriRaw('v1/segments/sub_segments.json');

    try {
      final res = await getJson(uri);

      final List data = jsonDecode(res.body);
      return data.map((e) => SubSegmentsModel.fromMap(e)).toList();
    } catch (e) {
      final localData = await rootBundle.loadString(
        'assets/raw/v1/data/sub_segments.json',
      );
      final List data = jsonDecode(localData);
      return data.map((e) => SubSegmentsModel.fromMap(e)).toList();
    }
  }
}
