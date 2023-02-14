import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/tagging/bloc/tagging_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class TaggingTestView extends StatefulWidget {
  const TaggingTestView({super.key});

  @override
  State<TaggingTestView> createState() => _TaggingTestViewState();
}

class _TaggingTestViewState extends State<TaggingTestView> {
  late final TaggingBloc taggingBloc;

  @override
  void initState() {
    super.initState();
    taggingBloc = TaggingBloc()..add(GetTaggingListEvent(feedroomId: 72200));
  }

  static String _displayStringForOption(UserTag option) =>
      "@${option.name}" ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
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
                  final userTags = taggingData.members;

                  return Column(
                    children: [
                      Autocomplete<UserTag>(
                        displayStringForOption: _displayStringForOption,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable.empty();
                          } else if (textEditingValue.text.startsWith('@')) {
                            String text = textEditingValue.text.substring(1);
                            return userTags!.where((userTag) {
                              return userTag.name!.toLowerCase().contains(
                                    text.toLowerCase(),
                                  );
                            });
                          } else {
                            return const Iterable.empty();
                          }
                          // return userTags!.where((userTag) {
                          //   return userTag.name!
                          //       .toLowerCase()
                          //       .contains(textEditingValue.text.toLowerCase());
                          // });
                        },
                      ),
                    ],
                  );
                }
                if (state is TaggingError) {
                  return const Center(child: Text('Error'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ));
  }
}
