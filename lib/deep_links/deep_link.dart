import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../students_modules/invitation_acception.dart';

class DeepLinkProvider{




static Future<String> createLink({
  required String collectionName,
  required String uId,
  required String userName,
  bool isTeacher = false,
  String? sessionName,
  String? dayName,
  String? groupName,
})async{
  //Normal link (not Teacher)
  String url = 'https://com.example.examy?collectionName=$collectionName&uId=$uId&userName=$userName';

  //Teacher Link
if(isTeacher==true){
  url =
'https://com.example.examy?collectionName=$collectionName&uId=$uId&userName=$userName'
'&sessionName=$sessionName&dayName=$dayName&groupName=$groupName'

  ;
}


 DynamicLinkParameters parameters = DynamicLinkParameters(
     link: Uri.parse(url),
     uriPrefix: 'https://examy.page.link',
     androidParameters: const AndroidParameters(
       packageName: 'com.example.examy',
       minimumVersion: 0,

     ),

 );

  final FirebaseDynamicLinks link = await FirebaseDynamicLinks.instance;

  final refLink = await link.buildShortLink(
    parameters,
    shortLinkType: ShortDynamicLinkType.unguessable
  );

  return refLink.shortUrl.toString();


}

static Future<Map<String,String?>?>? initDynamicLink()async{

  final  instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

  if(instanceLink!=null){
    final Uri  refLink = instanceLink.link;

    if(refLink.queryParameters.containsKey('groupName')){
    return {
      'recType' :'student',
      'senderName':refLink.queryParameters['userName'],
      'sessionName':refLink.queryParameters['sessionName'],
      'dayName':refLink.queryParameters['dayName'],
      'groupName':refLink.queryParameters['groupName'],
      'senderUid':refLink.queryParameters['uId'],
      'collectionName':refLink.queryParameters['collectionName'],





    } ;


    }




  }
}
}