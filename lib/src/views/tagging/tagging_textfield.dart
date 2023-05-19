import 'package:extended_text_field/extended_text_field.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class TaggingTextField extends StatefulWidget {
  final Function(UserTag) onTagSelected;
  final Function(String) result;
  final Function(TextEditingController) getController;
  final List<UserTag> userTags;
  final InputDecoration? decoration;
  final Function(String)? onChange;

  const TaggingTextField({
    super.key,
    required this.onTagSelected,
    required this.result,
    required this.userTags,
    required this.getController,
    this.decoration,
    this.onChange,
  });

  @override
  State<TaggingTextField> createState() => _TaggingTextFieldState();
}

class _TaggingTextFieldState extends State<TaggingTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late final List<UserTag> userTags;
  late final Function(TextEditingController) getController;

  int tagCount = 0;
  bool tagComplete = false;
  String textValue = "";

  @override
  void initState() {
    super.initState();
    userTags = widget.userTags;
    getController = widget.getController;
  }

  TextEditingController? get controller => _controller;

  @override
  Widget build(BuildContext context) {
    getController.call(_controller);
    return RawAutocomplete<UserTag>(
      textEditingController: _controller,
      focusNode: _focusNode,
      displayStringForOption: (selected) {
        return "$textValue@${selected.name!}~ ";
      },
      onSelected: (UserTag selection) {
        widget.onTagSelected.call(selection);
        tagComplete = true;
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          child: SizedBox(
            height: 240,
            width: double.infinity,
            child: ListView(
              padding: const EdgeInsets.all(4),
              children: [
                Column(
                  children: options.map((opt) {
                    return InkWell(
                      onTap: () {
                        onSelected(opt);
                      },
                      child: Container(
                        // padding: const EdgeInsets.only(right: 60),
                        child: Card(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ProfilePicture(
                                    user: User(
                                  id: opt.id!,
                                  imageUrl: opt.imageUrl!,
                                  name: opt.name!,
                                  userUniqueId: opt.userUniqueId!,
                                  isGuest: opt.isGuest!,
                                  isDeleted: false,
                                )),
                                const SizedBox(width: 12),
                                Text(
                                  opt.name!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
      optionsBuilder: ((textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        } else if (!tagComplete) {
          return userTags.where((tag) {
            String currentText = textEditingValue.text;
            if (tagCount > 1) {
              int index = currentText.nThIndexOf('@', tagCount);
              String newTag = currentText.substring(index);
              return tag.name!.contains(newTag.substring(1));
            } else {
              return tag.name!.contains(textEditingValue.text.substring(1));
            }
          });
        } else {
          return const Iterable.empty();
        }
      }),
      fieldViewBuilder: ((
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return ExtendedTextField(
          focusNode: focusNode,
          controller: textEditingController,
          specialTextSpanBuilder:
              MySpecialTextSpanBuilder(showAtBackground: true),
          style: const TextStyle(fontSize: 18),
          textInputAction: TextInputAction.done,
          minLines: 2,
          maxLines: 100,
          decoration: widget.decoration ??
              const InputDecoration(
                border: InputBorder.none,
                hintText: "Write something here",
              ),
          onChanged: (String value) {
            final int newTagCount = '@'.allMatches(value).length;
            if (tagCount != newTagCount) {
              // setState(() {
              tagCount = newTagCount;
              tagComplete = false;
              textValue = value.substring(0, value.length - 1);
              // });
            }
            widget.onChange?.call(textValue);
          },
        );
      }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ExtendedTextField(
  //     // focusNode: _focusNode,
  //     controller: _controller,
  //     specialTextSpanBuilder: MySpecialTextSpanBuilder(showAtBackground: true),
  //     style: const TextStyle(fontSize: 18),
  //     maxLines: 100,
  //     textInputAction: TextInputAction.done,
  //     decoration: const InputDecoration(
  //       border: InputBorder.none,
  //       hintText: "Write something here",
  //     ),
  //     onChanged: (String value) {
  //       final int newTagCount = '@'.allMatches(value).length;
  //       if (tagCount != newTagCount) {
  //         tagCount = newTagCount;
  //         tagComplete = false;
  //       }
  //       if (tagCount > 0 && !tagComplete) {
  //         _showUserTagsPopup(context);
  //       }
  //     },
  //     onSubmitted: ((value) {
  //       widget.result.call(value);
  //     }),
  //   );
  // }

  void _showUserTagsPopup(BuildContext context) {
    showMenu<UserTag>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 0, 24, 24),
      items: userTags.map((tag) {
        return PopupMenuItem<UserTag>(
          value: tag,
          child: Text(tag.name ?? ""),
        );
      }).toList(),
    ).then((selectedTag) {
      if (selectedTag != null) {
        String currentText = _controller.text;
        // String newText = currentText.indexOf(pattern)
        if (tagCount > 1) {
          int index = currentText.nThIndexOf('@', tagCount);
          String newTag = currentText.substring(index);
          String newText = newTag.replaceFirst('@', '@${selectedTag.name}~ ');
          _controller.text =
              currentText.substring(0, currentText.length - 1) + newText;
        } else {
          String newText =
              currentText.replaceFirst('@', '@${selectedTag.name}~ ');
          _controller.text = newText;
        }
        widget.onTagSelected.call(selectedTag);
        tagComplete = true;
      } else {
        tagComplete = true;
      }
    });
  }
}

class AtText extends SpecialText {
  static const String flag = "@";
  @override
  final SpecialTextGestureTapCallback onTap;
  final int start;

  /// whether show background for @somebody
  final bool showAtBackground;

  AtText(
    TextStyle textStyle, {
    this.showAtBackground = false,
    required this.start,
    required this.onTap,
  }) : super(
          flag,
          "~",
          textStyle,
        );

  @override
  InlineSpan finishText() {
    TextStyle textStyle = this.textStyle!.copyWith(
          color: Colors.blue,
          fontSize: 16.0,
        );

    final String atText = toString();
    final String atTextWithoutFlag = atText.replaceAll('~', '');

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atTextWithoutFlag,
            actualText: atText,
            start: start,

            ///caret can move into special text
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
 onTap(atText);
              }),
          )
        : SpecialTextSpan(
            text: atTextWithoutFlag,
            actualText: atText,
            start: start,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
 onTap(atText);
              }),
          );
  }
}

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false});

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, AtText.flag)) {
      return AtText(
        textStyle ?? const TextStyle(),
        onTap: onTap ??
            (d) {
              TaggingHelper.routeToProfile(d);
            },
        start: index! - (AtText.flag.length),
        showAtBackground: showAtBackground,
      );
    }
    return null;
  }
}

extension NthOccurrenceOfSubstring on String {
  int nThIndexOf(String stringToFind, int n) {
    if (indexOf(stringToFind) == -1) return -1;
    if (n == 1) return indexOf(stringToFind);
    int subIndex = -1;
    while (n > 0) {
      subIndex = indexOf(stringToFind, subIndex + 1);
      n -= 1;
    }
    return subIndex;
  }

  bool hasNthOccurrence(String stringToFind, int n) {
    return nThIndexOf(stringToFind, n) != -1;
  }
}
