import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {this.onSaved,
      this.onChange,
      this.prefixWidget,
      this.onFieldSubmitted,
      this.onFocusChange,
      required this.tittle,
      this.controller,
      this.suffixWidget,
      this.maxLines,
      this.textInput,
      this.fontSize,
      this.usernameInputFormatters,
      this.maxLength,
      this.focusNode,
      this.errorText});
  ValueChanged<String>? onSaved;
  ValueChanged<String>? onChange;
  void Function(String)? onFieldSubmitted;
  void Function(bool)? onFocusChange;
  double? fontSize;
  String? tittle;
  String? errorText;
  int? maxLines;
  int? maxLength;
  List<TextInputFormatter>? usernameInputFormatters;
  Widget? suffixWidget, prefixWidget;
  TextInputType? textInput;
  TextEditingController? controller;
  FocusNode? focusNode;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscure = true;
  errorMessage(hint) {
    switch (hint) {
      case 'إسم المستخدم':
        return "حقل إسم المستخدم مطلوب*";
      case 'قصتكم':
        return "حقل قصتكم مطلوب*";
      case 'كلمة المرور':
        return "حقل كلمة المرور مطلوب*";
      case 'كلمة المرور الجديدة':
        return "حقل كلمة المرور الجديدة مطلوب*";
      case 'إعادة كلمة المرور الجديدة':
        return "حقل إعادة كلمة المرور الجديدة مطلوب*";
      case 'إعادة كلمة المرور':
        return "حقل إعادة كلمة المرور مطلوب*";
      case 'مكان الأقامة':
        return "حقل مكان الأقامة مطلوب*";
      case 'المدينة':
        return "حقل المدينة مطلوب*";
      case 'يمكنك كتابة اسم المستخدم او رقم الموبايل':
        return "هذا الحقل مطلوب*";
      case 'المحتوى':
        return "يجب كتابة محتوى الرسالة";
      // case 'الإسم بالكامل':
      //   return "حقل الإسم بالكامل مطلوب*";
      case 'عنوان الرسالة':
        return "حقل عنوان الرسالة مطلوب*";
      // case 'الوظيفة':
      //   return "حقل الوظيفة مطلوب*";
      // case 'عدد الأطفال':
      //   return "حقل عدد الأطفال مطلوب*";
      case 'البريد الإلكتروني':
        return "حقل الإيميل مطلوب*";
      case 'الايميل':
        return "حقل الإيميل مطلوب*";
      case "اسم زوجك":
        return "حقل اسم زوجك مطلوب*";
      case "اسم زوجتك":
        return "حقل اسم زوجتك مطلوب*";
      case 'إكتب مواصفات شريك حياتك هنا بشيء من التفصيل':
        return "يرجى عدم تركه فارغاً";
      case 'تحدث عن نفسك هنا بشيء من التفصيل':
        return "يرجى عدم تركه فارغاً";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: .0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.tittle == "كلمة المرور" ||
                widget.tittle == "إعادة كلمة المرور" ||
                widget.tittle == "كلمة المرور الجديدة" ||
                widget.tittle == "إعادة كلمة المرور الجديدة"
            ? obscure
            : false,
        validator: (String? val) {
          if (val!.isEmpty) {
            return errorMessage(widget.tittle);
          } else if (widget.tittle == "العمر") {
            int ageNum = int.tryParse(widget.controller!.text) ?? 0;
            if (ageNum <= 17) {
              return 'يجب أن يكون أكبر من 17';
            }
          } else if (widget.tittle == "الطول") {
            int heightNum = int.tryParse(widget.controller!.text) ?? 0;
            if (heightNum <= 120) {
              return 'يجب أن يكون أكبر من 120';
            }
          } else if (widget.tittle == "الوزن") {
            int weightNum = int.tryParse(widget.controller!.text) ?? 0;
            if (weightNum <= 40) {
              return 'يجب أن يكون أكبر من 40';
            }
          } else if (widget.tittle == "إسم المستخدم"
              ? val.length < 7
              : widget.tittle == "كلمة المرور" ||
                      widget.tittle == "إعادة كلمة المرور"
                  ? val.length < 7
                  : widget.tittle ==
                              "إكتب مواصفات شريك حياتك هنا بشيء من التفصيل" ||
                          widget.tittle == "تحدث عن نفسك هنا بشيء من التفصيل"
                      ? val.length < 10
                      : false) {
            return widget.tittle == "إسم المستخدم"
                ? "يجب إدخال أكثر من 8 حروف"
                : widget.tittle == "كلمة المرور" ||
                        widget.tittle == "إعادة كلمة المرور"
                    ? "يجب إدخال أكثر من 6 حروف"
                    : (widget.tittle ==
                                "إكتب مواصفات شريك حياتك هنا بشيء من التفصيل" ||
                            widget.tittle == "تحدث عن نفسك هنا بشيء من التفصيل")
                        ? "يجب إدخال ما بين ال10 إلى 50 حرف كحد أقصى"
                        : null;
          } else if (widget.tittle == "إسم المستخدم"
              ? val.length > 13
              : widget.tittle == "كلمة المرور" ||
                      widget.tittle == "إعادة كلمة المرور" ||
                      widget.tittle == "كلمة المرور الجديدة" ||
                      widget.tittle == "إعادة كلمة المرور الجديدة"
                  ? val.length > 13
                  : widget.tittle ==
                              "إكتب مواصفات شريك حياتك هنا بشيء من التفصيل" ||
                          widget.tittle == "تحدث عن نفسك هنا بشيء من التفصيل"
                      ? val.length > 51
                      : false) {
            return widget.tittle == "إسم المستخدم"
                ? "يجب إدخال أقل من 12 حرف"
                : (widget.tittle == "كلمة المرور" &&
                            widget.tittle == "إعادة كلمة المرور") ||
                        (widget.tittle == "كلمة المرور الجديدة" &&
                            widget.tittle == "إعادة كلمة المرور الجديدة")
                    ? "يجب إدخال أقل من 12 حرف"
                    : (widget.tittle ==
                                "إكتب مواصفات شريك حياتك هنا بشيء من التفصيل" ||
                            widget.tittle == "تحدث عن نفسك هنا بشيء من التفصيل")
                        ? "يجب إدخال أقل من 50 حرف"
                        : null;
          } else if (widget.tittle == "البريد الإلكتروني"
              ? !checkEmail(val)
              : false) {
            return "يجب كتابة ايميل حقيقي";
          }
          return null;
        },
        onSaved: (String? value) {
          if (widget.onSaved != null) widget.onSaved!(value!);
        },
        onChanged: widget.onChange,
        style: const TextStyle(fontSize: 14),
        textAlign:
            widget.tittle == "رقم الموبيل" ? TextAlign.left : TextAlign.right,
        onFieldSubmitted: widget.onFieldSubmitted,
        inputFormatters: widget.tittle == "إسم المستخدم"
            ? widget.usernameInputFormatters
            : [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
        textInputAction: widget.maxLines != null
            ? TextInputAction.newline
            : TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();

          if (widget.onFocusChange != null) widget.onFocusChange!(true);
        },
        maxLength: widget.maxLength,
        scrollPadding: const EdgeInsets.only(bottom: 30),
        keyboardType: widget.tittle == "الطول" ||
                widget.tittle == "الوزن" ||
                widget.tittle == "العمر" ||
                widget.tittle == "رقم الموبيل" ||
                widget.tittle == "أدخل الكود" ||
                widget.tittle == "عدد الأطفال"
            ? TextInputType.number
            : widget.maxLines != null
                ? TextInputType.multiline
                : widget.textInput ?? TextInputType.text,
        cursorColor: Colors.black,
        maxLines: widget.maxLines ?? 1,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
            helperStyle: const TextStyle(color: Colors.black),
            hintText: "${widget.tittle}",
            prefixIcon: widget.prefixWidget,
            hintStyle: TextStyle(
                fontSize: widget.fontSize ?? 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[400]
                    : Colors.white),
            errorText: widget.errorText,
            suffixIcon: widget.tittle == "إسم المستخدم"
                ? widget.suffixWidget
                : widget.tittle == "كلمة المرور" ||
                        widget.tittle == "كلمة المرور الجديدة"
                    ? IconButton(
                        icon: Icon(
                            obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        })
                    : widget.tittle == "إعادة كلمة المرور" ||
                            widget.tittle == "إعادة كلمة المرور الجديدة"
                        ? SizedBox(
                            width: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                widget.suffixWidget ?? const SizedBox(),
                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                      icon: Icon(obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          obscure = !obscure;
                                        });
                                      }),
                                ),
                              ],
                            ),
                          )
                        : null,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Get.theme.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[400]!)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[400]!))),
      ),
    );
  }

  bool checkEmail(email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
