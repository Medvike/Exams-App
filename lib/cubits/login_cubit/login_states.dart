abstract class LoginStates{}

class LoginInitState extends LoginStates{}

class ChangePassVision extends LoginStates{}

class LoginSuccessStudent extends LoginStates{}

class LoginSuccessTeacher extends LoginStates{}

class LoginFail extends LoginStates{
  final String errorMessage;
  LoginFail(this.errorMessage);
}

class LoadingState extends LoginStates{

}
