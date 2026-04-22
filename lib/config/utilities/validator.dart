import 'dart:developer';

extension Validator on String {
  String? isValid(int characters, String filed) {
    if (length < characters) {
      return "$filed at least $characters character";
    } else if (isEmpty) {
      return "Please enter $filed";
    }
    return null;
  }

  String? isNumber() {
    if (isEmpty) {
      return "Invalid Number";
    } else if (num.tryParse(this) != null) {
      return "Invalid Number";
    }
    return null;
  }

  String? isPasswordValidator(
      int characters, String filed, String password, String confirmpassword) {
    if (length < characters) {
      return "$filed at least $characters character";
    } else if (isEmpty) {
      return "Please enter $filed";
    } else if (password != confirmpassword) {
      return "Create password & Confirm password does not match ";
    }
    return null;
  }

  String? isEmptyValidator(String filedName) {
    if (isEmpty) {
      return "$filedName could not be empty";
    }
    return null;
  }

  String? isEmailORPhone() {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = RegExp(pattern);
    // if(int.tryParse(filed)){}
    // if (isEmpty) {
    //   return "$filed could not be empty";
    //
    log(length.toString());
    if (int.tryParse(this).runtimeType == int) {
      if (!regExp.hasMatch(this)) {
        return "Invalid Phone Number ";
      }
    } else {
      return isEmail();
    }
    return null;
  }

  bool isTextPhone() {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    // ignore: unused_local_variable
    RegExp regExp = RegExp(pattern);

    if (int.tryParse(this).runtimeType == int) {
      return true;
    } else {
      return false;
    }
  }

  String? isValidGender(int characters, String filed) {
    if (length < characters) {
      return "Please select $filed";
    } else if (isEmpty) {
      return "Please Select $filed";
    }
    return null;
  }

  String? isValidDOB(DateTime? filed) {
    int? day = filed?.day;
    int? year = filed?.year;
    int? month = filed?.month;
    if (day == null || month == null || year == null) {
      return "Invalid Birth Day";
    }
    log(filed.toString());
    return null;
  }

  String? isEmail() {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);

    if (!emailValid) {
      return "Please enter valid Email";
    }
    return null;
  }

  String? isConfirmPassword(String oldPass) {
    if (this != oldPass) {
      return "Please enter valid confirm password";
    }
    return null;
  }

  String? bothMatch(String other) {
    if (this != other) {
      return "Password didn't match";
    }
    return null;
  }

  String? isPhone() {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = RegExp(pattern);
    if (length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(this)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  bool isPhoneNumber() {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (length == 0) {
      return false;
    } else if (length != 11) {
      return false;
    } else if (!regExp.hasMatch(this)) {
      return false;
    }
    return true;
  }
}
