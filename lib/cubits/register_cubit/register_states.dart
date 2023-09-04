abstract class RegisterState{}

class RegisterInitState extends RegisterState{}

class ChangePassVision extends RegisterState{}

class RegisterSuccess extends RegisterState{}

class SameName extends RegisterState{}

class LoadingCANCEL extends RegisterState{}


class RegisterFail extends RegisterState{
  String message;
  RegisterFail(this.message);
}

class LoadingState extends RegisterState{}