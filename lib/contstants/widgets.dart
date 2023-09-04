import 'package:examy/contstants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';


//Navigator
void defaultNavigator({
  required BuildContext context,
  required Widget screen

}){
  Navigator.push(
      context, MaterialPageRoute(builder: (context) =>screen )
  );

}
//Text Form

Widget defaultInput({
  required double width,
  String? hintText,
  String? labelText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool isBottom = false,
  TextInputType? keyBoardType,
  bool isPass = false,
  String? Function(String?)? onValidate,
  TextEditingController? controller



}){
  return TextFormField(
    controller: controller,
    cursorColor: whiteCl,
    validator: onValidate,
    obscureText: isPass,
    style: TextStyle(
      color: whiteCl,
      fontSize: width/19
    ),
    decoration: InputDecoration(
      labelText: labelText,
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: orangeCl,
              width: 1
          )
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: orangeCl,
              width: 1
          )
      ),
      errorStyle: TextStyle(
        color: whiteCl
      ),
      labelStyle: TextStyle(
          color: whiteCl.withOpacity(.5)
      ),
      floatingLabelStyle: TextStyle(
          color: whiteCl
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: whiteCl
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: whiteCl,
              width: 1
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: whiteCl,
              width: 1
          )
      ),
      enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: whiteCl,
              width: 1
          )
      ),




    ),
    keyboardType: keyBoardType,

  );
}

Widget defaultText({
  required String text,
  required double fontSize ,
  FontWeight? fontWeight ,
  Color color = Colors.white,
  TextDecoration? decoration,
  int? maxLines,
  TextAlign? align,
  TextOverflow? textOverflow = TextOverflow.ellipsis

}){
  return Text(
    text,
    style: TextStyle(
      color: color,
      decoration: decoration,
      fontSize: fontSize,
      fontWeight: fontWeight
    ),
    overflow: textOverflow,
    maxLines: maxLines,
    textAlign: align,
  );
}

Widget defaultButton({
  required Widget child ,
  double width = double.infinity,
  double? height,
  void Function()? onPress,
  Color? color ,
  BoxShape shape = BoxShape.rectangle,
  double radius = 15,
}){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: color??secCl,
      shape: shape,
      borderRadius: BorderRadius.circular(radius)
    ),
    child: MaterialButton(
        onPressed: onPress,
         child: child,
    ),
  );
}

Widget squareButton(
{
  required String text,
  required void Function()? onTap
}
    ){
  return Container(
    decoration: BoxDecoration(
        color: greyCl.withOpacity(.5),
        borderRadius: BorderRadius.circular(15)
    ),
    height: 80.h,
    child: Padding(
      padding:  EdgeInsets.symmetric(
          horizontal: 10.w
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: defaultText(
                text: text,
                maxLines: 1,
                fontSize: 25.sp
            ),
          )],
      ),
    ),
  );
}



void defaultToast(
{
  required String text,
  required BuildContext context,
   ToastState? state
}
    ){

  FToast().init(context);
 FToast().showToast(
     child: toastBuilder( text: text, state: state ),
    toastDuration: Duration(
     seconds: 2
   ),
    gravity: ToastGravity.BOTTOM
 );
}

Widget toastBuilder(
{
  required String text,
   ToastState? state
}
    ){
  return Container(

    padding: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 10.w,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(state == ToastState.success)
        Icon(
          Icons.check,
          color: Colors.greenAccent,
          size: 22.w,
        ),
        if(state == ToastState.error)
          Icon(
            Icons.close,
            color: Colors.redAccent,
            size: 22.w,
          ),
        if(state == ToastState.warning)
          Icon(
            Icons.error_outline,
            color: Colors.yellow.shade800,
            size: 22.w,
          ),
        if(state!=null)
        SizedBox(
            width: 10.w,
          ),
        Flexible(
            child: defaultText(
                text: text,
                fontSize: 22.sp,
                maxLines: 2
            )
        ),

      ],
    ),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: greyCl.withOpacity(.8),


    ),

  );
}
enum ToastState {
  error,
  success,
  warning
}

Widget defaultDialog({
  Widget? content,
  List<Widget>? actions,
  String? title,

}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
    ),
    backgroundColor: mainCl.withOpacity(.7),
    title: title != null ? Container(
      child: defaultText(
        text: title,
        fontSize: 20.w,

      ),
    ) : null,
    content: content,
    actions: actions,

  );
}



