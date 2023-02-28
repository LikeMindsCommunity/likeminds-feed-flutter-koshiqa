import 'dart:async';
import 'package:feed_sx/src/views/feed/feedroom_screen.dart';
import 'package:feed_sx/src/views/tagging/bloc/tagging_bloc.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TaggingAheadTextField extends StatefulWidget {
  final bool isDown;
  final Function(UserTag) onTagSelected;
  final Function(TextEditingController) getController;
  final InputDecoration? decoration;
  final Function(String)? onChange;

  TaggingAheadTextField({
    super.key,
    required this.isDown,
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
  final TaggingBloc taggingBloc = TaggingBloc();
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();

  List<UserTag> userTags = [];

  int page = 1;
  int tagCount = 0;
  bool tagComplete = false;
  String textValue = "";

  @override
  void initState() {
    super.initState();
    taggingBloc.add(GetTaggingListEvent(
      feedroomId: DUMMY_FEEDROOM,
      page: 1,
      limit: TaggingBloc.FIXED_SIZE,
    ));
  }

  TextEditingController? get controller => _controller;

  FutureOr<Iterable<UserTag>> _getSuggestions(String query) {
    if (query.isEmpty) {
      return const Iterable.empty();
    } else if (!tagComplete) {
      return userTags.where((tag) {
        String currentText = query.trim();
        if (tagCount > 1) {
          int index = currentText.nThIndexOf('@', tagCount);
          String newTag = currentText.substring(index);
          return tag.name!.contains(newTag.substring(1));
        } else {
          return tag.name!.contains(currentText.substring(1));
        }
      });
    } else {
      return const Iterable.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.getController(_controller);
    return BlocConsumer<TaggingBloc, TaggingState>(
      bloc: taggingBloc,
      listener: (context, state) {
        if (state is TaggingLoaded) {
          ++page;
          userTags.addAll(
            state.taggingData.members!.map((e) => e),
          );
          if (_suggestionsBoxController.suggestionsBox != null) {
            String text = _controller.text;
            _controller.clear();
            _controller.text = text;
          }
        }
      },
      buildWhen: (previous, current) {
        if (previous is TaggingLoaded && current is TaggingPaginationLoading) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is TaggingLoading) {
          return const Loader();
        } else if (state is TaggingLoaded) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              taggingBloc.add(GetTaggingListEvent(
                  feedroomId: DUMMY_FEEDROOM,
                  page: page,
                  limit: TaggingBloc.FIXED_SIZE,
                  isPaginationEvent: true));
            }
          });
          return TypeAheadField<UserTag>(
            onTagTap: (p) {
              print(p);
            },
            suggestionsBoxController: _suggestionsBoxController,
            keepSuggestionsOnLoading: true,
            hideOnEmpty: true,
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
                widget.onChange!(value);
                final int newTagCount = '@'.allMatches(value).length;
                if (tagCount != newTagCount) {
                  setState(() {
                    tagCount = newTagCount;
                    tagComplete = false;
                  });
                }
              }),
            ),
            direction: widget.isDown ? AxisDirection.down : AxisDirection.up,
            suggestionsCallback: (suggestion) => _getSuggestions(suggestion),
            itemBuilder: ((context, opt) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
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
            }),
            onSuggestionSelected: ((suggestion) {
              print(suggestion);
              widget.onTagSelected.call(suggestion);
              setState(() {
                tagComplete = true;
                _controller.text = "$textValue@${suggestion.name!}~ ";
              });
              textValue = _controller.text;
            }),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _showUserTagsPopup(BuildContext context) {
    showMenu<UserTag>(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 24, 24),
      items: userTags.map((tag) {
        return PopupMenuItem<UserTag>(
          value: tag,
          child: Text(tag.name ?? ""),
        );
      }).toList(),
    ).then((selectedTag) {
      if (selectedTag != null) {
        String currentText = _controller.text;
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
        tagComplete = true;
      } else {
        tagComplete = true;
      }
    });
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
