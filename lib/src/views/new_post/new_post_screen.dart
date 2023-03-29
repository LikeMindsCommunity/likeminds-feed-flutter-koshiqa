import 'dart:io';

import 'package:feed_sx/src/views/feed/components/post/post_dialog.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/media_model.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:feed_sx/src/views/feed/components/post/post_media/post_media.dart';
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
    'title': 'Attach Files',
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
  final FilePicker _filePicker = FilePicker.platform;
  Size? screenSize;
  bool isUploading = false;
  late final User user;
  late final FeedRoomBloc feedBloc;
  late final int feedRoomId;
  List<Attachment> attachments = [];
  List<MediaModel> postMedia = [];

  List<UserTag> userTags = [];
  String? result;
  bool isDocumentPost = false;
  bool isMediaPost = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    attachments.clear();
    feedRoomId = widget.feedRoomId;
  }

  void removeAttachmenetAtIndex(int index) {
    if (postMedia.isNotEmpty) {
      postMedia.removeAt(index);
      if (postMedia.isEmpty) {
        isDocumentPost = false;
        isMediaPost = false;
      }
      setState(() {});
    }
  }

  // this function initiliases postMedia list
  // with photos/videos picked by the user
  void setPickedMediaFiles(List<MediaModel> pickedMediaFiles) {
    if (postMedia.isEmpty) {
      postMedia = <MediaModel>[...pickedMediaFiles];
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
  void onUploadedMedia(bool uploadResponse) {
    if (uploadResponse) {
      isMediaPost = true;
      setState(() {
        isUploading = false;
      });
    } else {
      if (postMedia.isEmpty) {
        isMediaPost = false;
      }
      setState(() {
        isUploading = false;
      });
    }
  }

  void onUploadedDocument(bool uploadResponse) {
    if (uploadResponse) {
      isDocumentPost = true;
      setState(() {
        isUploading = false;
      });
    } else {
      if (postMedia.isEmpty) {
        isDocumentPost = false;
      }
      setState(() {
        isUploading = false;
      });
    }
  }

  Widget getPostDocument(double width) {
    return ListView.builder(
      itemCount: postMedia.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => PostDocument(
        size: getFileSizeString(bytes: postMedia[index].size!),
        type: postMedia[index].format!,
        docFile: postMedia[index].mediaFile,
        removeAttachment: (index) => removeAttachmenetAtIndex(index),
        index: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (postMedia.isNotEmpty ||
            (_controller != null && _controller!.text.isNotEmpty)) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Discard Post'),
                    content: const Text(
                        'Are you sure want to discard the current post?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'No'.toUpperCase(),
                          style: TextStyle(fontSize: 14),
                        ),
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
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(
                      onPressed: () {
                        if (postMedia.isNotEmpty ||
                            (_controller != null &&
                                _controller!.text.isNotEmpty)) {
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
                        if (_controller != null &&
                            _controller!.text.isNotEmpty) {
                          userTags = TaggingHelper.matchTags(
                              _controller!.text, userTags);
                          result = TaggingHelper.encodeString(
                              _controller!.text, userTags);
                          locator<NavigationService>().goBack(result: {
                            "feedroomId": feedRoomId,
                            "isBack": true,
                            "mediaFiles": postMedia,
                            "result": result
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            confirmationToast(
                                content: "The text in a post can't be empty",
                                backgroundColor: kGrey1Color),
                          );
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              kVerticalPaddingLarge,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Row(
                  children: [
                    ProfilePicture(
                        user: PostUser(
                      id: user.id,
                      imageUrl: user.imageUrl,
                      name: user.name,
                      userUniqueId: user.userUniqueId,
                      isGuest: user.isGuest,
                      isDeleted: false,
                    )),
                    kHorizontalPaddingLarge,
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: kGrey1Color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              kVerticalPaddingLarge,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 72,
                        ),
                        decoration: const BoxDecoration(
                          color: kWhiteColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
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
                      ),
                      kVerticalPaddingXLarge,
                      if (isUploading)
                        const Padding(
                          padding: EdgeInsets.only(
                            top: kPaddingMedium,
                            bottom: kPaddingLarge,
                          ),
                          child: Loader(),
                        ),
                      if ((attachments.isNotEmpty || postMedia.isNotEmpty))
                        postMedia.first.mediaType == MediaType.document
                            ? getPostDocument(screenSize!.width)
                            : Container(
                                padding: const EdgeInsets.only(
                                  top: kPaddingSmall,
                                ),
                                alignment: Alignment.center,
                                child: PostMedia(
                                  height: screenSize!.width,
                                  removeAttachment: removeAttachmenetAtIndex,
                                  //min(constraints.maxHeight, screenSize!.width),
                                  mediaFiles: postMedia,
                                  postId: '',
                                ),
                              ),
                      kVerticalPaddingMedium,
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: kGrey3Color.withOpacity(0.2),
                      offset: const Offset(0.0, -1.0),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                  ],
                ),
                child: Column(
                  children: [
                    isDocumentPost
                        ? const SizedBox.shrink()
                        : AddAssetsButton(
                            mediaType: 1, // 1 for photos
                            picker: _picker,
                            filePicker: _filePicker,
                            uploading: onUploading,
                            onUploaded: onUploadedMedia,
                            postMedia: setPickedMediaFiles,
                            mediaListLength: postMedia.length,
                            preUploadCheck: () {
                              if (postMedia.length >= 10) {
                                return false;
                              }
                              return true;
                            },
                          ),
                    isDocumentPost
                        ? const SizedBox.shrink()
                        : AddAssetsButton(
                            mediaType: 2, // 2 for videos
                            picker: _picker,
                            filePicker: _filePicker,
                            uploading: onUploading,
                            onUploaded: onUploadedMedia,
                            postMedia: setPickedMediaFiles,
                            mediaListLength: postMedia.length,
                            preUploadCheck: () {
                              if (postMedia.length >= 10) {
                                return false;
                              }
                              return true;
                            },
                          ),
                    isMediaPost
                        ? const SizedBox.shrink()
                        : AddAssetsButton(
                            mediaType: 3, // 2 for videos
                            picker: _picker,
                            filePicker: _filePicker,
                            uploading: onUploading,
                            onUploaded: onUploadedDocument,
                            postMedia: setPickedMediaFiles,
                            mediaListLength: postMedia.length,
                            preUploadCheck: () {
                              if (postMedia.length >= 10) {
                                return false;
                              }
                              return true;
                            },
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddAssetsButton extends StatelessWidget {
  final ImagePicker picker;
  final FilePicker filePicker;
  final int mediaListLength;
  final int mediaType; // 1 for photo 2 for video
  final Function(bool uploadResponse) onUploaded;
  final Function() uploading;
  final Function() preUploadCheck;
  final Function(List<MediaModel>)
      postMedia; // only return in List<File> format

  const AddAssetsButton({
    super.key,
    required this.mediaType,
    required this.filePicker,
    required this.mediaListLength,
    required this.picker,
    required this.onUploaded,
    required this.uploading,
    required this.postMedia,
    required this.preUploadCheck,
  });

  void pickImages(BuildContext context) async {
    uploading();
    final List<XFile> list = await picker.pickMultiImage();

    if (list.isNotEmpty) {
      if (mediaListLength + list.length > 10) {
        ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
            content: 'A total of 10 attachments can be added to a post',
            backgroundColor: kGrey1Color));
        onUploaded(false);
        return;
      }
      for (XFile image in list) {
        int fileBytes = await image.length();
        double fileSize = getFileSizeInDouble(fileBytes);
        if (fileSize > 100) {
          ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
              content: 'File size should be smaller than 100MB',
              backgroundColor: kGrey1Color));
          onUploaded(false);
          return;
        }
      }
      MultiImageCrop.startCropping(
        context: context,
        activeColor: kWhiteColor,
        files: list.map((e) => File(e.path)).toList(),
        aspectRatio: 1.0,
        callBack: (List<File> images) {
          List<MediaModel> mediaFiles = images
              .map((e) => MediaModel(
                  mediaFile: File(e.path), mediaType: MediaType.image))
              .toList();
          postMedia(mediaFiles);
          onUploaded(true);
        },
      );
    } else {
      onUploaded(false);
    }
  }

  void pickVideos(BuildContext context) async {
    uploading();

    final pickedFiles = await filePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      dialogTitle: 'Select files',
      allowedExtensions: [
        '3gp',
        'mp4',
      ],
    );
    if (pickedFiles != null) {
      if (mediaListLength + pickedFiles.files.length > 10) {
        ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
            content: 'A total of 10 attachments can be added to a post',
            backgroundColor: kGrey1Color));
        onUploaded(false);
        return;
      }
      for (var pickedFile in pickedFiles.files) {
        if (getFileSizeInDouble(pickedFile.size) > 100) {
          ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
              content: 'File size should be smaller than 100MB',
              backgroundColor: kGrey1Color));
          onUploaded(false);
          return;
        } else {
          File video = File(pickedFile.path!);
          VideoPlayerController controller = VideoPlayerController.file(video);
          await controller.initialize();
          Duration videoDuration = controller.value.duration;
          MediaModel videoFile = MediaModel(
              mediaType: MediaType.video,
              mediaFile: video,
              duration: videoDuration.inSeconds);
          List<MediaModel> videoFiles = [];
          videoFiles.add(videoFile);
          postMedia(videoFiles);
          onUploaded(true);
        }
      }
    } else {
      onUploaded(false);
    }
  }

  void pickFiles(BuildContext context) async {
    uploading();
    final pickedFiles = await filePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      dialogTitle: 'Select files',
      allowedExtensions: [
        'pdf',
      ],
    );

    if (pickedFiles != null) {
      if (mediaListLength + pickedFiles.files.length > 10) {
        ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
            content: 'A total of 10 attachments can be added to a post',
            backgroundColor: kGrey1Color));
        onUploaded(false);
        return;
      }
      for (var pickedFile in pickedFiles.files) {
        if (getFileSizeInDouble(pickedFile.size) > 100) {
          ScaffoldMessenger.of(context).showSnackBar(confirmationToast(
              content: 'File size should be smaller than 100MB',
              backgroundColor: kGrey1Color));
          onUploaded(false);
          return;
        }
      }
      List<MediaModel> attachedFiles = [];
      attachedFiles = pickedFiles.files
          .map((e) => MediaModel(
              mediaType: MediaType.document,
              mediaFile: File(e.path!),
              format: e.extension,
              size: e.size))
          .toList();
      postMedia(attachedFiles);
      onUploaded(true);
    } else {
      onUploaded(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (preUploadCheck()) {
          if (mediaType == 1) {
            pickImages(context);
          } else if (mediaType == 2) {
            pickVideos(context);
          } else if (mediaType == 3) {
            pickFiles(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              width: screenSize.width * 0.7,
              backgroundColor: kGrey1Color,
              elevation: 5,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: const Text(
                "A total of 10 attachments can be added to a post",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: kFontSmallMed),
              ),
            ),
          );
        }
      },
      child: Container(
        height: 48,
        width: screenSize.width,
        // decoration: BoxDecoration(
        //   color: kWhiteColor,
        //   border: Border.all(
        //     color: kGreyColor,
        //     width: 1,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                assetButtonData[mediaType]['svg_icon'],
                height: 28,
              ),
              kHorizontalPaddingLarge,
              Text(
                assetButtonData[mediaType]['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
