import 'dart:io';
import 'dart:math';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image.dart';
import 'package:feed_sx/src/views/tagging/bloc/tagging_bloc.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/views/tagging/tagging_textfield_ta.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_crop/multi_image_crop.dart';

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
  bool uploaded = false;
  bool isUploading = false;
  late final User user;
  late final FeedRoomBloc feedBloc;
  late final int feedRoomId;
  List<Attachment> attachments = [];
  List<File> croppedImages = [];

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
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ),
                          backgroundColor: Colors.grey.shade500,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "POST",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(children: [
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
                    fontSize: kFontMedium,
                    color: kGrey1Color,
                    fontWeight: FontWeight.w500),
              ),
            ]),
            kVerticalPaddingMedium,
            TaggingAheadTextField(
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
            const Spacer(),
            if (isUploading) const Loader(),
            if (uploaded &&
                (attachments.isNotEmpty || croppedImages.isNotEmpty))
              Expanded(
                child: LayoutBuilder(builder: (
                  context,
                  constraints,
                ) {
                  return Container(
                    alignment: Alignment.bottomRight,
                    child: PostImage(
                        height: min(constraints.maxHeight, screenSize!.width),
                        // url: attachments
                        //     .map((e) => e.attachmentMeta.url.toString())
                        //     .toList(),
                        imagesFile: croppedImages,
                        postId: ''),
                  );
                }),
              ),
            kVerticalPaddingSmall,
            AddAssetsButton(
              leading: SvgPicture.asset(
                'packages/feed_sx/assets/icons/add_photo.svg',
                height: 24,
              ),
              title: const Text('Add Photo'),
              picker: _picker,
              uploading: () {
                setState(() {
                  isUploading = true;
                });
              },
              onUploaded: (bool uploadResponse) {
                if (uploadResponse) {
                  setState(() {
                    uploaded = true;
                    isUploading = false;
                  });
                } else {
                  setState(() {
                    isUploading = false;
                  });
                }
              },
              croppedImages: (List<File> images) {
                croppedImages = images;
              },
            )
          ]),
        )),
      ),
    );
  }
}

class AddAssetsButton extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final ImagePicker picker;
  final Function(bool uploadResponse) onUploaded;
  final Function() uploading;
  final Function(List<File>) croppedImages;

  const AddAssetsButton({
    super.key,
    required this.leading,
    required this.title,
    required this.picker,
    required this.onUploaded,
    required this.uploading,
    required this.croppedImages,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        uploading();
        final list = await picker.pickMultiImage();
        MultiImageCrop.startCropping(
          context: context,
          activeColor: kWhiteColor,
          files: list.map((e) => File(e.path)).toList(),
          aspectRatio: 1.0,
          callBack: (List<File> images) {
            croppedImages(images);
            onUploaded(true);
          },
        );
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [leading, kHorizontalPaddingLarge, title],
        ),
      ),
    );
  }
}
