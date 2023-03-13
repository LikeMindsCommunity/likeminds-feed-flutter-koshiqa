import 'dart:async';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/tagging/bloc/tagging_bloc.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TaggingAheadTextField extends StatefulWidget {
  final bool isDown;
  final Function(UserTag) onTagSelected;
  final Function(TextEditingController) getController;
  final InputDecoration? decoration;
  final Function(String)? onChange;
  final int feedroomId;

  const TaggingAheadTextField({
    super.key,
    required this.isDown,
    required this.feedroomId,
    required this.onTagSelected,
    required this.getController,
    this.decoration,
    this.onChange,
  });

  @override
  State<TaggingAheadTextField> createState() => _TaggingAheadTextFieldState();
}

class _TaggingAheadTextFieldState extends State<TaggingAheadTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();

  List<UserTag> userTags = [];

  int page = 1;
  int tagCount = 0;
  bool tagComplete = false;
  String textValue = "";
  String tagValue = "";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      // page++;
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        final taggingData = await locator<LikeMindsService>().getTags(
          feedroomId: widget.feedroomId,
          page: page,
          pageSize: TaggingBloc.FIXED_SIZE,
        );
        if (taggingData.members != null && taggingData.members!.isNotEmpty) {
          userTags.addAll(taggingData.members!.map((e) => e).toList());
          // return userTags;
        }
      }
    });
  }

  TextEditingController? get controller => _controller;

  FutureOr<Iterable<UserTag>> _getSuggestions(String query) async {
    String currentText = query.trim();
    if (currentText.isEmpty) {
      return const Iterable.empty();
    } else if (!tagComplete && currentText.contains('@')) {
      String tag = tagValue.substring(1).replaceAll(' ', '');
      final taggingData = await locator<LikeMindsService>().getTags(
        feedroomId: widget.feedroomId,
        page: 1,
        pageSize: TaggingBloc.FIXED_SIZE,
        searchQuery: tag,
      );
      if (taggingData.members != null && taggingData.members!.isNotEmpty) {
        userTags = taggingData.members!.map((e) => e).toList();
        return userTags;
      }
      return const Iterable.empty();
    } else {
      return const Iterable.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.getController(_controller);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: TypeAheadField<UserTag>(
        onTagTap: (p) {
          // print(p);
        },
        suggestionsBoxController: _suggestionsBoxController,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 4,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.22,
          ),
        ),
        // keepSuggestionsOnLocading: true,
        noItemsFoundBuilder: (context) => const SizedBox.shrink(),
        hideOnEmpty: true,
        debounceDuration: const Duration(milliseconds: 500),
        scrollController: _scrollController,
        textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          focusNode: _focusNode,
          minLines: 2,
          maxLines: 100,
          decoration: widget.decoration ??
              const InputDecoration(
                hintText: 'Write something here...',
                border: InputBorder.none,
              ),
          onChanged: ((value) {
            // widget.onChange!(value);
            final int newTagCount = '@'.allMatches(value).length;
            if (tagCount != newTagCount && value.contains('@')) {
              tagValue = value.substring(value.lastIndexOf('@'));
              tagComplete = false;
            } else {
              textValue = _controller.value.text;
              print(textValue);
            }
          }),
        ),
        direction: widget.isDown ? AxisDirection.down : AxisDirection.up,
        suggestionsCallback: (suggestion) => _getSuggestions(suggestion),
        itemBuilder: ((context, opt) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: kGrey3Color,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ProfilePicture(
                      user: PostUser(
                        id: opt.id!,
                        imageUrl: opt.imageUrl!,
                        name: opt.name!,
                        userUniqueId: opt.userUniqueId!,
                        isGuest: opt.isGuest!,
                        isDeleted: false,
                      ),
                      size: 36,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      opt.name!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        onSuggestionSelected: ((suggestion) {
          print(suggestion);
          widget.onTagSelected.call(suggestion);
          setState(() {
            tagComplete = true;
            tagCount = '@'.allMatches(_controller.text).length;
            textValue += "@${suggestion.name!}~";
            _controller.text = textValue + " ";
            tagValue = '';
          });
          if (_focusNode.canRequestFocus) {
            // _focusNode.requestFocus();
          }
        }),
      ),
    );
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
