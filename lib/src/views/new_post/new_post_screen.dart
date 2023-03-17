import 'dart:io';

import 'package:flutter/material.dart';

import 'package:feed_sx/src/views/feed/components/post/post_media/post_media.dart';
import 'package:feed_sx/src/views/tagging/bloc/tagging_bloc.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/views/tagging/tagging_textfield_ta.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';

import 'package:likeminds_feed/likeminds_feed.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:video_player/video_player.dart';

/* key is mediatype, contains all asset button data 
related to a particular media type */
const Map<int, dynamic> assetButtonData = {
  1: {
    'title': 'Add Photo',
    'svg_icon': 'packages/feed_sx/assets/icons/add_photo.svg',
  },
  2: {
    'title': 'Add Video',
    'svg_icon': 'packages/feed_sx/assets/icons/add_video.svg',
  },
  3: {
    'title': 'Add Document',
    'svg_icon': 'packages/feed_sx/assets/icons/add_attachment.svg',
  },
};

class NewPostScreen extends StatefulWidget {
  static const String route = "/new_post_screen";
  final int feedRoomId;
  final User user;

  const NewPostScreen({
    super.key,
    required this.feedRoomId,
    required this.user,
  });

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  TextEditingController? _controller;
  final ImagePicker _picker = ImagePicker();
  Size? screenSize;
  bool isUploading = false;
  late final User user;
  late final FeedRoomBloc feedBloc;
  late final int feedRoomId;
  List<Attachment> attachments = [];
  List<Map<String, dynamic>> postMedia = [];

  List<UserTag> userTags = [];
  String? result;
  late final TaggingBloc taggingBloc;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    attachments.clear();
    feedRoomId = widget.feedRoomId;

    taggingBloc = TaggingBloc()
      ..add(GetTaggingListEvent(feedroomId: feedRoomId));
  }

  // this function initiliases postMedia list
  // with photos/videos picked by the user
  void setPickedMediaFiles(List<Map<String, dynamic>> pickedMediaFiles) {
    if (postMedia == null || postMedia.isEmpty) {
      postMedia = <Map<String, dynamic>>[...pickedMediaFiles];
    } else {
      postMedia.addAll(pickedMediaFiles);
    }
  }

  /* Changes state to uploading
  for showing a circular loader while the user is 
  picking files */
  void onUploading() {
    setState(() {
      isUploading = true;
    });
  }

  /* Changes state to uploaded
  for showing the picked files */
  void onUploaded(bool uploadResponse) {
    if (uploadResponse) {
      setState(() {
        isUploading = false;
      });
    } else {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (croppedImages.isNotEmpty ||
            (_controller != null && _controller!.text.isNotEmpty)) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Discard Post'),
                    content: const Text(
                        'Are you sure want to discard the current post?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          locator<NavigationService>().goBack(
                            result: {
                              "feedroomId": feedRoomId,
                              "isBack": false,
                            },
                          );
                        },
                      ),
                    ],
                  ));
        } else {
          locator<NavigationService>().goBack(
            result: {
              "feedroomId": feedRoomId,
              "isBack": false,
            },
          );
        }
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BackButton(
                  onPressed: () {
                    if (croppedImages.isNotEmpty ||
                        (_controller != null && _controller!.text.isNotEmpty)) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Discard Post'),
                                content: const Text(
                                    'Are you sure want to discard the current post?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      locator<NavigationService>().goBack(
                                        result: {
                                          "feedroomId": feedRoomId,
                                          "isBack": false,
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ));
                    } else {
                      locator<NavigationService>().goBack(
                        result: {
                          "feedroomId": feedRoomId,
                          "isBack": false,
                        },
                      );
                    }
                  },
                ),
                const Text(
                  'Create a Post',
                  style: TextStyle(fontSize: 18, color: kGrey1Color),
                ),
                TextButton(
                  onPressed: () async {
                    if (_controller != null) {
                      userTags =
                          TaggingHelper.matchTags(_controller!.text, userTags);
                      result = TaggingHelper.encodeString(
                          _controller!.text, userTags);
                      locator<NavigationService>().goBack(result: {
                        "feedroomId": feedRoomId,
                        "isBack": true,
                        "imageFiles": croppedImages,
                        "result": result
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "The text in a post can't be empty",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ]),
                        ),
                        kVerticalPaddingMedium,
                        Container(
                          constraints: const BoxConstraints(minHeight: 150),
                          child: TaggingAheadTextField(
                            feedroomId: feedRoomId,
                            isDown: true,
                            onTagSelected: (tag) {
                              print(tag);
                              userTags.add(tag);
                            },
                            getController: ((p0) {
                              _controller = p0;
                            }),
                            onChange: (p0) {
                              print(p0);
                            },
                          ),
                        ),
                        kVerticalPaddingSmall,
                        if (isUploading)
                          const Padding(
                            padding: EdgeInsets.only(top: kPaddingSmall),
                            child: Loader(),
                          ),
                        if ((attachments.isNotEmpty || postMedia.isNotEmpty))
                          Container(
                            padding: const EdgeInsets.only(top: kPaddingSmall),
                            alignment: Alignment.bottomRight,
                            child: PostMedia(
                                height: screenSize!.width,
                                //min(constraints.maxHeight, screenSize!.width),
                                mediaFiles: postMedia,
                                postId: ''),
                          ),
                      ],
                    ),
                  ),
                ),
                kVerticalPaddingMedium,
                AddAssetsButton(
                  mediaType: 1, // 1 for photos
                  picker: _picker,
                  uploading: onUploading,
                  onUploaded: onUploaded,
                  postMedia: setPickedMediaFiles,
                ),
                AddAssetsButton(
                  mediaType: 2, // 2 for videos
                  picker: _picker,
                  uploading: onUploading,
                  onUploaded: onUploaded,
                  postMedia: setPickedMediaFiles,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddAssetsButton extends StatelessWidget {
  final ImagePicker picker;
  final int mediaType; // 1 for photo 2 for video
  final Function(bool uploadResponse) onUploaded;
  final Function() uploading;
  final Function(List<Map<String, dynamic>>)
      postMedia; // only return in List<File> format

  const AddAssetsButton({
    super.key,
    required this.mediaType,
    required this.picker,
    required this.onUploaded,
    required this.uploading,
    required this.postMedia,
  });

  void pickImages(BuildContext context) async {
    uploading();
    final List<XFile> list = await picker.pickMultiImage();
    if (list.isNotEmpty) {
      MultiImageCrop.startCropping(
        context: context,
        activeColor: kWhiteColor,
        files: list.map((e) => File(e.path)).toList(),
        aspectRatio: 1.0,
        callBack: (List<File> images) {
          List<Map<String, dynamic>> mediaFiles = images
              .map(
                (e) => {
                  'mediaType': 1,
                  'mediaFile': File(e.path),
                },
              )
              .toList();
          postMedia(mediaFiles);
          onUploaded(true);
        },
      );
    } else {
      onUploaded(true);
    }
  }

  void pickVideos() async {
    uploading();
    final XFile? xVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (xVideo != null) {
      File video = File(xVideo.path);
      VideoPlayerController controller = VideoPlayerController.file(video);
      await controller.initialize();
      Duration videoDuration = controller.value.duration;
      Map<String, dynamic> videoFile = {
        'mediaType': 2,
        'mediaFile': video,
        'duration': videoDuration.inSeconds,
      };
      List<Map<String, dynamic>> videoFiles = [];
      videoFiles.add(videoFile);
      postMedia(videoFiles);
    }
    onUploaded(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (mediaType == 1) {
          pickImages(context);
        } else if (mediaType == 2) {
          pickVideos();
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              assetButtonData[mediaType]['svg_icon'],
              height: 24,
            ),
            kHorizontalPaddingLarge,
            Text(assetButtonData[mediaType]['title']),
          ],
        ),
      ),
    );
  }
}
