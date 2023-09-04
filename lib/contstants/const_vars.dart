import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examy/shared/user_info/user_credential.dart';

final DocumentReference teacher = FirebaseFirestore.instance.collection('teachers').doc(uId);
final DocumentReference students = FirebaseFirestore.instance.collection('students').doc(uId);
