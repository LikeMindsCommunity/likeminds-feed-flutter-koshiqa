import 'dart:io';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_carousel.dart';
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
import 'package:overlay_support/overlay_support.dart';

List<Attachment> attachments = [];

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
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool uploaded = false;
  bool isUploading = false;
  late final User user;
  late final FeedRoomBloc feedBloc;
  late final int feedRoomId;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    feedRoomId = widget.feedRoomId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhiteColor,
        // appBar: const GeneralAppBar(
        //     autoImplyEnd: false,
        //     title: ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Text(
                  'Create a Post',
                  style: TextStyle(fontSize: 18, color: kGrey1Color),
                ),
                TextButton(
                  onPressed: () async {
                    if (_textEditingController.text.isNotEmpty) {
                      final AddPostRequest request = AddPostRequest(
                        text: _textEditingController.text,
                        attachments: attachments,
                        feedroomId: feedRoomId,
                      );
                      final AddPostResponse response =
                          await locator<LikeMindsService>().addPost(request);
                      if (response.success) {
                        LMAnalytics.get().track(
                          AnalyticsKeys.postCreationCompleted,
                          {
                            "user_tagged": "no",
                            "link_attached": "no",
                            "image_attached": {
                              "yes": {"image_count": attachments.length},
                            },
                            "video_attached": "no",
                            "document_attached": "no",
                          },
                        );
                        Navigator.of(context).pop();
                      }
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
                )
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
            Expanded(
              child: TextField(
                controller: _textEditingController,
                style: const TextStyle(fontSize: 18),
                maxLines: 100,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write something here",
                ),
              ),
            ),
            kVerticalPaddingXLarge,
            if (isUploading) const CircularProgressIndicator(),
            if (uploaded && attachments.isNotEmpty)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kGrey2Color.withOpacity(0.2),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          NetworkImage(attachments.first.attachmentMeta.url!),
                    ),
                  ),
                ),
              ),
            kVerticalPaddingXLarge,
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
            ),
            // AddAssetsButton(
            //     leading: SvgPicture.asset(
            //         'packages/feed_sx/assets/icons/add_video.svg'),
            //     title: const Text('Add Video'),
            //     picker: _picker),
            // AddAssetsButton(
            //     leading: SvgPicture.asset(
            //         'packages/feed_sx/assets/icons/add_attachment.svg'),
            //     title: const Text('Attach Files'),
            //     picker: _picker),
          ]),
        ));
  }
}

class AddAssetsButton extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final ImagePicker picker;
  final Function(bool uploadResponse) onUploaded;
  final Function() uploading;

  const AddAssetsButton({
    super.key,
    required this.leading,
    required this.title,
    required this.picker,
    required this.onUploaded,
    required this.uploading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        uploading();
        final list = await picker.pickMultiImage();
        for (final image in list) {
          try {
            File file = File.fromUri(Uri(path: image.path));
            final String? response =
                await locator<LikeMindsService>().uploadFile(file);
            if (response != null) {
              attachments.add(Attachment(
                attachmentType: 1,
                attachmentMeta: AttachmentMeta(
                  url: response,
                ),
              ));
            } else {
              throw ('Error uploading file');
            }
          } catch (e) {
            print(e);
          }
        }
        // if (image != null) {
        //   File file = File.fromUri(Uri(path: image.path));
        //   final String? response =
        //       await locator<LikeMindsService>().uploadFile(file);
        //   if (response != null) {
        //     onUploaded(response);
        //   } else {
        //     print('Error uploading file');
        //   }
        // } else {
        //   print('No image selected');
        //   onUploaded(null);
        // }
        onUploaded(true);
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // decoration: const BoxDecoration(
        //     border: Border(bottom: BorderSide(color: kBorderColor, width: 1))),
        child: Row(
          children: [leading, kHorizontalPaddingLarge, title],
        ),
      ),
    );
  }
}
