import 'dart:io';

import 'package:flutter/material.dart';

import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/views/feed/components/new_post_button.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_video.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/simple_bloc_observer.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:feed_sx/feed.dart';

import 'package:likeminds_feed/likeminds_feed.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

//const List<int> DUMMY_FEEDROOMS = [72345, 72346, 72347];
//const List<int> DUMMY_FEEDROOMS = [72200, 72232, 72233];
const int DUMMY_FEEDROOM = 72200;

class FeedRoomScreen extends StatefulWidget {
  final bool isCm;
  final User user;
  final int feedRoomId;
  String? feedRoomTitle;
  FeedRoomScreen(
      {super.key,
      required this.isCm,
      required this.user,
      required this.feedRoomId,
      this.feedRoomTitle});

  @override
  State<FeedRoomScreen> createState() => _FeedRoomScreenState();
}

class _FeedRoomScreenState extends State<FeedRoomScreen> {
  late final FeedRoomBloc _feedBloc;
  String? title;
  bool? isCm;

  final ValueNotifier _rebuildAppBar = ValueNotifier(false);

  // to control paging on FeedRoom View
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _addPaginationListener();
    Bloc.observer = SimpleBlocObserver();
    _feedBloc = FeedRoomBloc();
    title = widget.feedRoomTitle;
    _feedBloc.add(GetFeedRoom(feedRoomId: widget.feedRoomId, offset: 1));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      _feedBloc.add(GetFeedRoom(
          feedRoomId: widget.feedRoomId,
          offset: pageKey,
          isPaginationLoading: true));
    });
  }

  refresh() => _pagingController.refresh();

  int _pageFeedRoom = 1; // current index of FeedRoom

  void updatePagingControllers(Object? state) {
    if (state is FeedRoomLoaded) {
      _pageFeedRoom++;
      if (state.feed.posts!.length < 10) {
        _pagingController.appendLastPage(state.feed.posts ?? []);
      } else {
        _pagingController.appendPage(state.feed.posts ?? [], _pageFeedRoom);
      }
      setTitleWidget(state.feedRoom.title);
    } else if (state is FeedRoomEmpty) {
      setTitleWidget(state.feedRoom.title);
    }
  }

  setTitleWidget(String feedRoomTitle) {
    if (title == null) {
      title = feedRoomTitle;
      _rebuildAppBar.value = !_rebuildAppBar.value;
    }
  }

  void clearPagingController() {
    /* Clearing paging controller while changing the
     event to prevent duplication of list */
    if (_pagingController.itemList != null) _pagingController.itemList!.clear();
    _pageFeedRoom = 1;
  }

  @override
  Widget build(BuildContext context) {
    isCm = widget.isCm;
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        leading: isCm!
            ? BackButton(
                color: Colors.white,
                onPressed: () {
                  locator<NavigationService>().goBack();
                },
              )
            : null,
        title: ValueListenableBuilder(
            valueListenable: _rebuildAppBar,
            builder: (context, _, __) {
              return Text(title ?? '');
            }),
        backgroundColor: kPrimaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _feedBloc.add(GetFeedRoom(feedRoomId: widget.feedRoomId, offset: 0));
          clearPagingController();
        },
        child: BlocConsumer(
          bloc: _feedBloc,
          buildWhen: (prev, curr) {
            // Prevents changin the state while paginating the feed
            if (prev is FeedRoomLoaded && curr is PaginationLoading) {
              return false;
            }
            return true;
          },
          listener: (context, state) => updatePagingControllers(state),
          builder: ((context, state) {
            if (state is FeedRoomLoaded) {
              // Log the event in the analytics
              LMAnalytics.get().logEvent(
                AnalyticsKeys.feedOpened,
                {
                  "feed_type": {
                    "feedroom": {
                      "id": state.feedRoom.id,
                    }
                  }
                },
              );
              return FeedRoomView(
                isCm: isCm!,
                feedResponse: state.feed,
                feedRoomBloc: _feedBloc,
                feedRoom: state.feedRoom,
                feedRoomPagingController: _pagingController,
                user: user,
                onRefresh: refresh,
                onPressedBack: clearPagingController,
              );
            } else if (state is FeedRoomError) {
              return FeedRoomErrorView(message: state.message);
            } else if (state is FeedRoomEmpty) {
              return FeedRoomEmptyView(
                isCm: isCm!,
                feedBloc: _feedBloc,
                onRefresh: refresh,
                user: user,
                feedRoom: state.feedRoom,
                onPressedBack: clearPagingController,
              );
            }

            return Scaffold(
                backgroundColor: kBackgroundColor,
                body: Center(
                  child: const Loader(),
                ));
          }),
        ),
      ),
    );
  }
}

class FeedRoomErrorView extends StatelessWidget {
  final String message;
  const FeedRoomErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor, body: Center(child: Text(message)));
  }
}

class FeedRoomEmptyView extends StatefulWidget {
  FeedRoomEmptyView(
      {Key? key,
      required this.isCm,
      required this.onPressedBack,
      required this.onRefresh,
      required this.feedBloc,
      required this.user,
      required this.feedRoom});

  final bool isCm;
  final User user;
  final FeedRoom feedRoom;
  final FeedRoomBloc feedBloc;
  final VoidCallback onRefresh;
  final VoidCallback onPressedBack;

  @override
  State<FeedRoomEmptyView> createState() => _FeedRoomEmptyViewState();
}

class _FeedRoomEmptyViewState extends State<FeedRoomEmptyView> {
  final ValueNotifier postUploading = ValueNotifier(false);
  Size? screenSize;

  List<File> imageFiles = [];

  int imageUploadProgress = 0;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: [
        ValueListenableBuilder(
            valueListenable: postUploading,
            builder: (context, _, __) {
              if (postUploading.value) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    color: kWhiteColor,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              imageFiles != null && imageFiles.isNotEmpty
                                  ? Image.file(
                                      imageFiles[0],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                              kHorizontalPaddingMedium,
                              Text('Posting')
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: imageFiles != null && imageFiles.isNotEmpty
                                ? CircularProgressIndicator(
                                    value:
                                        imageUploadProgress / imageFiles.length,
                                    backgroundColor: kGrey3Color,
                                    valueColor:
                                        AlwaysStoppedAnimation(kLinkColor),
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ]),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  kAssetPostsIcon,
                  color: kGrey3Color,
                ),
                SizedBox(height: 12),
                Text("No posts to show",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 12),
                Text("Be the first one to post here",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: kGrey2Color)),
                SizedBox(height: 28),
                NewPostButton(
                  onTap: () {
                    locator<NavigationService>()
                        .navigateTo(
                      NewPostScreen.route,
                      arguments: NewPostScreenArguments(
                        feedroomId: widget.feedRoom.id,
                        user: widget.user,
                      ),
                    )
                        .then((result) async {
                      if (result != null && result['isBack']) {
                        imageFiles = result['imageFiles'];
                        postUploading.value = true;
                        await postContent(result, widget.feedRoom.id,
                            (int progress) {
                          imageUploadProgress = progress;
                          postUploading.value = false;
                          postUploading.value = true;
                        });
                        postUploading.value = false;
                        widget.onRefresh();
                        widget.onPressedBack();
                        widget.feedBloc.add(
                          GetFeedRoom(
                              feedRoomId: widget.feedRoom.id, offset: 1),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

class FeedRoomView extends StatefulWidget {
  final bool isCm;
  final FeedRoom feedRoom;
  final User user;
  final FeedRoomBloc feedRoomBloc;
  final VoidCallback onPressedBack;
  final GetFeedOfFeedRoomResponse feedResponse;
  final PagingController<int, Post> feedRoomPagingController;
  final VoidCallback onRefresh;

  FeedRoomView({
    super.key,
    required this.isCm,
    required this.feedResponse,
    required this.onPressedBack,
    required this.feedRoomBloc,
    required this.feedRoom,
    required this.feedRoomPagingController,
    required this.user,
    required this.onRefresh,
  }) {
    locator<LikeMindsService>().setFeedroomId = feedRoom.id;
  }

  @override
  State<FeedRoomView> createState() => _FeedRoomViewState();
}

class _FeedRoomViewState extends State<FeedRoomView> {
  ValueNotifier<bool> rebuildPostWidget = ValueNotifier(false);
  final ValueNotifier postUploading = ValueNotifier(false);

  List<Map<String, dynamic>> imageFiles = [];

  Widget getLoaderThumbnail() {
    if (imageFiles[0]['mediaType'] == 1) {
      return Image.file(
        imageFiles[0]['mediaFile'],
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox(
        height: 50,
        width: 50,
        child: PostVideo(
          videoFile: imageFiles[0]['mediaFile'],
        ),
      );
    }
  }

  int imageUploadProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: postUploading,
              builder: (context, _, __) {
                if (postUploading.value) {
                  return Container(
                    height: 60,
                    color: kWhiteColor,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              imageFiles != null && imageFiles.isNotEmpty
                                  ? getLoaderThumbnail()
                                  : const SizedBox(),
                              kHorizontalPaddingMedium,
                              Text('Posting')
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: imageFiles != null && imageFiles.isNotEmpty
                                ? CircularProgressIndicator(
                                    value:
                                        imageUploadProgress / imageFiles.length,
                                    backgroundColor: kGrey3Color,
                                    valueColor:
                                        AlwaysStoppedAnimation(kLinkColor),
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ]),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
          kVerticalPaddingLarge,
          Expanded(
            child: PagedListView<int, Post>(
              pagingController: widget.feedRoomPagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                  noItemsFoundIndicatorBuilder: (context) => Scaffold(
                      backgroundColor: kBackgroundColor,
                      body: Center(
                        child: const Loader(),
                      )),
                  itemBuilder: (context, item, index) {
                    return ValueListenableBuilder(
                        valueListenable: rebuildPostWidget,
                        builder: (context, _, __) {
                          return PostWidget(
                            postType: 1,
                            postDetails: item,
                            user: widget.feedResponse.users[item.userId]!,
                            refresh: (bool isDeleted) async {
                              if (!isDeleted) {
                                final GetPostResponse updatedPostDetails =
                                    await locator<LikeMindsService>().getPost(
                                  GetPostRequest(
                                    postId: item.id,
                                    page: 1,
                                    pageSize: 10,
                                  ),
                                );
                                item = updatedPostDetails.post!;
                                List<Post>? feedRoomItemList =
                                    widget.feedRoomPagingController.itemList;
                                feedRoomItemList![index] =
                                    updatedPostDetails.post!;
                                widget.feedRoomPagingController.itemList =
                                    feedRoomItemList;
                                rebuildPostWidget.value =
                                    !rebuildPostWidget.value;
                              } else {
                                widget.onRefresh();
                                widget.onPressedBack();
                              }
                            },
                            //onRefresh,
                          );
                        });
                  }),
            ),
          )
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: NewPostButton(
        onTap: () {
          locator<NavigationService>()
              .navigateTo(
            NewPostScreen.route,
            arguments: NewPostScreenArguments(
              feedroomId: widget.feedRoom.id,
              user: widget.user,
            ),
          )
              .then((result) async {
            if (result != null && result['isBack']) {
              imageFiles = result['mediaFiles'];
              postUploading.value = true;
              await postContent(result, widget.feedRoom.id, (int progress) {
                imageUploadProgress = progress;
                postUploading.value = false;
                postUploading.value = true;
              });
              postUploading.value = false;
              widget.onRefresh();
              widget.onPressedBack();
            }
          });
        },
      ),
    );
  }
}

Future postContent(Map<String, dynamic> postData, int feedRoomId,
    Function(int) updateProgress) async {
  List<Attachment> attachments =
      await uploadImages(postData['mediaFiles'], updateProgress);
  int imageCount = 0;
  int videoCount = 0;
  for (final attachment in attachments) {
    if (attachment.attachmentType == 1) {
      imageCount++;
    } else if (attachment.attachmentType == 2) {
      videoCount++;
    }
  }
  final AddPostRequest request = AddPostRequest(
    text: postData['result'] ?? '',
    attachments: attachments,
    feedroomId: feedRoomId,
  );
  final AddPostResponse response =
      await locator<LikeMindsService>().addPost(request);
  if (response.success) {
    LMAnalytics.get().track(AnalyticsKeys.postCreationCompleted, {
      "user_tagged": "no",
      "link_attached": "no",
      "image_attached": imageCount == 0
          ? "no"
          : {
              "yes": {"image_count": imageCount},
            },
      "video_attached": videoCount == 0
          ? "no"
          : {
              "yes": {"video_count": videoCount},
            },
      "document_attached": "no",
    });
  }
}

Future<List<Attachment>> uploadImages(List<Map<String, dynamic>> croppedFiles,
    Function(int) updateProgress) async {
  List<Attachment> attachments = [];
  int imageUploadCount = 0;
  for (final media in croppedFiles) {
    try {
      final String? response =
          await locator<LikeMindsService>().uploadFile(media['mediaFile']);
      if (response != null) {
        attachments.add(Attachment(
          attachmentType: media['mediaType'],
          attachmentMeta: AttachmentMeta(
              url: response,
              duration: media['mediaType'] == 2 ? media['duration'] : null),
        ));
        imageUploadCount += 1;
        updateProgress(imageUploadCount);
      } else {
        throw ('Error uploading file');
      }
    } catch (e) {
      print(e);
    }
  }
  return attachments;
}
