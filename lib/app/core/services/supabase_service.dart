import 'dart:io';

import 'package:get/get_connect/http/src/http/interface/request_base.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';

class SupabaseService{
  static SupabaseClient? _client;

  static SupabaseClient get client {
    if(_client==null){
      throw Exception('supabase not yet initialize');
    }
    return _client!;
  }
  static Future<void> init() async{
    await Supabase.initialize(url: AppConstants.supabaseUrl, anonKey: AppConstants.supabaseAnonKey);
    _client= Supabase.instance.client;
  }
  //auth helper
static User? get currentUser => _client?.auth.currentUser;
  static String? get currentUserid => currentUser?.id;
  static bool get  isLoggedIn => currentUser!= null;

  //get signed url for private image from pc
static Future<String?> getSignedUrl(String bucket, String path) async{
  try{
    final signedUrl= await _client!.storage.from(bucket).createSignedUrl(path,3600);
    return signedUrl;
  }catch(e){
    print('there is error in signedurl:$e');
    return null;
  }
}
// upload im age and return path of it
static Future<String?> uploadImage ({
    required String bucket,
  required String filePath,
  required List<int> fileBytes
}) async{
  try{
    await _client!.storage.from(bucket).upload(filePath,
        fileBytes as File,
        fileOptions: const FileOptions(cacheControl:'3600',upsert:false));
    return filePath;
  }catch(e){
    print('error in  uploading image:$e');
    return null;
  }
}
static Future<bool> deleteImage(String bucket,String path) async{
  try{
    await _client!.storage.from(bucket).remove([path]);
    return true;
  }catch(e){
    print('error in deleting image:$e');
    return false;
  }
}

}