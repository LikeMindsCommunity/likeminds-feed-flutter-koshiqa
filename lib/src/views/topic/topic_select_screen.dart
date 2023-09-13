import 'dart:async';

import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/topic/bloc/topic_bloc.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';

class TopicSelectScreen extends StatefulWidget {
  static const String route = "/topicSelectScreen";

  final List<TopicUI> selectedTopic;
  final Function(List<TopicUI>) onTopicSelected;
  final bool? isEnabled;

  const TopicSelectScreen({
    Key? key,
    required this.selectedTopic,
    required this.onTopicSelected,
    this.isEnabled,
  }) : super(key: key);

  @override
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  List<TopicUI> selectedTopics = [];
  FocusNode keyboardNode = FocusNode();
  Set<String> selectedTopicId = {};
  TextEditingController searchController = TextEditingController();
  String searchType = "";
  String search = "";
  TopicUI allTopics = (TopicUIBuilder()
        ..id("0")
        ..isEnabled(true)
        ..name("All Topics"))
      .build();
  final int pageSize = 20;
  TopicBloc topicBloc = TopicBloc();
  bool isSearching = false;
  ValueNotifier<bool> rebuildTopicsScreen = ValueNotifier<bool>(false);
  PagingController<int, TopicUI> topicsPagingController =
      PagingController(firstPageKey: 1);

  int _page = 1;

  Timer? _debounce;

  void _onTextChanged(String p0) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _page = 1;
      searchType = "name";
      search = p0;
      topicsPagingController.itemList?.clear();
      topicsPagingController.itemList = selectedTopics;
      topicBloc.add(
        GetTopic(
          getTopicFeedRequest: (GetTopicsRequestBuilder()
                ..page(_page)
                ..isEnabled(widget.isEnabled)
                ..pageSize(pageSize)
                ..search(search)
                ..searchType(searchType))
              .build(),
        ),
      );
    });
  }

  bool checkSelectedTopicExistsInList(TopicUI topic) {
    return selectedTopicId.contains(topic.id);
  }

  @override
  void initState() {
    super.initState();
    selectedTopics = widget.selectedTopic;
    for (TopicUI topic in selectedTopics) {
      selectedTopicId.add(topic.id);
    }
    topicsPagingController.itemList = selectedTopics;
    topicBloc.add(
      GetTopic(
        getTopicFeedRequest: (GetTopicsRequestBuilder()
              ..page(_page)
              ..isEnabled(widget.isEnabled)
              ..pageSize(pageSize)
              ..search(search)
              ..searchType(searchType))
            .build(),
      ),
    );
    _addPaginationListener();
  }

  @override
  void dispose() {
    searchController.dispose();
    topicBloc.close();
    keyboardNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _addPaginationListener() {
    topicsPagingController.addPageRequestListener(
      (pageKey) {
        topicBloc.add(GetTopic(
          getTopicFeedRequest: (GetTopicsRequestBuilder()
                ..page(pageKey)
                ..isEnabled(widget.isEnabled)
                ..pageSize(pageSize)
                ..search(search)
                ..searchType(searchType))
              .build(),
        ));
      },
    );
  }

  @override
  void didUpdateWidget(TopicSelectScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedTopics = widget.selectedTopic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onTopicSelected(selectedTopics);
          locator<NavigationService>().goBack();
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.arrow_forward,
          color: kWhiteColor,
        ),
      ),
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: ValueListenableBuilder(
          valueListenable: rebuildTopicsScreen,
          builder: (context, _, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isSearching
                    ? Expanded(
                        child: TextField(
                        controller: searchController,
                        focusNode: keyboardNode,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        onChanged: (p0) {
                          _onTextChanged(p0);
                        },
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Topic",
                            style: TextStyle(
                              fontSize: 14,
                              color: kGrey1Color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          kVerticalPaddingSmall,
                          Text(
                            "${selectedTopics.length} selected",
                            style: const TextStyle(
                              fontSize: 14,
                              color: kGrey1Color,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                GestureDetector(
                  onTap: () {
                    if (isSearching) {
                      if (keyboardNode.hasFocus) {
                        keyboardNode.unfocus();
                      }
                      searchController.clear();
                      search = "";
                      searchType = "";
                      _page = 1;
                      topicsPagingController.itemList?.clear();
                      topicBloc.add(
                        GetTopic(
                          getTopicFeedRequest: (GetTopicsRequestBuilder()
                                ..page(_page)
                                ..isEnabled(widget.isEnabled)
                                ..pageSize(pageSize)
                                ..search(search)
                                ..searchType(searchType))
                              .build(),
                        ),
                      );
                    } else {
                      if (keyboardNode.canRequestFocus) {
                        keyboardNode.requestFocus();
                      }
                    }
                    isSearching = !isSearching;
                    rebuildTopicsScreen.value = !rebuildTopicsScreen.value;
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      isSearching ? CupertinoIcons.xmark : Icons.search,
                      size: 18,
                      color: kGrey1Color,
                    ),
                  ),
                )
              ],
            );
          },
        ),
        leading: GestureDetector(
          onTap: () {
            locator<NavigationService>().goBack();
          },
          child: Container(
            color: Colors.transparent,
            child: const Icon(
              Icons.arrow_back,
              color: kGrey1Color,
            ),
          ),
        ),
      ),
      body: BlocConsumer<TopicBloc, TopicState>(
        bloc: topicBloc,
        buildWhen: (previous, current) {
          if (current is TopicLoading && _page != 1) {
            return false;
          }
          return true;
        },
        listener: (context, state) {
          if (state is TopicLoaded) {
            _page++;
            if (state.getTopicFeedResponse.topics!.isEmpty) {
              topicsPagingController.appendLastPage([]);
            } else {
              state.getTopicFeedResponse.topics?.removeWhere(
                  (element) => selectedTopicId.contains(element.id));
              topicsPagingController.appendPage(
                state.getTopicFeedResponse.topics!
                    .map((e) => TopicUI.fromTopic(e))
                    .toList(),
                _page,
              );
            }
          } else if (state is TopicError) {
            topicsPagingController.error = state.errorMessage;
          }
        },
        builder: (context, state) {
          if (state is TopicLoading) {
            return const Center(child: Loader());
          }

          if (state is TopicLoaded) {
            return ValueListenableBuilder(
                valueListenable: rebuildTopicsScreen,
                builder: (context, _, __) {
                  return Column(
                    children: [
                      isSearching
                          ? const SizedBox()
                          : LMTopicTile(
                              isSelected: selectedTopics.isEmpty,
                              height: 50,
                              topic: allTopics,
                              text: LMTextView(
                                text: allTopics.name,
                                textStyle: const TextStyle(
                                  color: kGrey1Color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: kWhiteColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0),
                              icon: const Icon(
                                Icons.check_circle,
                                color: kPrimaryColor,
                              ),
                              onTap: (TopicUI tappedTopic) {
                                selectedTopics.clear();
                                selectedTopicId.clear();
                                rebuildTopicsScreen.value =
                                    !rebuildTopicsScreen.value;
                              },
                            ),
                      Expanded(
                        child: PagedListView(
                          pagingController: topicsPagingController,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          builderDelegate: PagedChildBuilderDelegate<TopicUI>(
                            noItemsFoundIndicatorBuilder: (context) =>
                                const Center(
                                    child: Text(
                              "Opps, no topics found!",
                            )),
                            itemBuilder: (context, item, index) => LMTopicTile(
                              isSelected: checkSelectedTopicExistsInList(item),
                              topic: item,
                              height: 50,
                              text: LMTextView(
                                text: item.name,
                                textStyle: const TextStyle(
                                  color: kGrey1Color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: kWhiteColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 16.0),
                              icon: const Icon(
                                Icons.check_circle,
                                color: kPrimaryColor,
                              ),
                              onTap: (TopicUI tappedTopic) {
                                int index = selectedTopics.indexWhere(
                                    (element) => element.id == tappedTopic.id);
                                if (index != -1) {
                                  selectedTopics.removeAt(index);
                                  selectedTopicId.remove(tappedTopic.id);
                                } else {
                                  selectedTopics.add(tappedTopic);
                                  selectedTopicId.add(tappedTopic.id);
                                }
                                rebuildTopicsScreen.value =
                                    !rebuildTopicsScreen.value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else if (state is TopicError) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
