import 'package:extended_text_field/extended_text_field.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/tagging/bloc/tagging_bloc.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/views/tagging/tagging_textfield.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class TaggingTestView extends StatefulWidget {
  const TaggingTestView({super.key});

  @override
  State<TaggingTestView> createState() => _TaggingTestViewState();
}

class _TaggingTestViewState extends State<TaggingTestView> {
  late final TaggingBloc taggingBloc;

  List<UserTag> userTags = [];
  String? result;

  @override
  void initState() {
    super.initState();
    taggingBloc = TaggingBloc()..add(GetTaggingListEvent(feedroomId: 72200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: BackButton(),
          title: const Text('Tagging Test'),
          backgroundColor: kPrimaryColor,
        ),
        body: Column(
          children: [
            kVerticalPaddingLarge,
            BlocBuilder(
              bloc: taggingBloc,
              builder: (context, state) {
                if (state is TaggingLoaded) {
                  final TagResponseModel taggingData = state.taggingData;
                  final groupTags = taggingData.groupTags;
                  final items = taggingData.members!;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Expanded(
                            child: TaggingTextField(
                              userTags: items,
                              onTagSelected: (tag) {
                                print(tag);
                                userTags.add(tag);
                              },
                              result: (text) {
                                print(text);
                                setState(() {
                                  userTags =
                                      TaggingHelper.matchTags(text, items);
                                  result = TaggingHelper.encodeString(
                                      text, userTags);
                                });
                              },
                            ),
                          ),
                          kVerticalPaddingLarge,
                          Expanded(
                            child: Text(result != null
                                ? TaggingHelper.decodeString(result!)
                                : ''),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is TaggingError) {
                  return const Center(child: Text('Error'));
                }
                return const Center(
                  child: Loader(
                    isPrimary: true,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
