import 'dart:io';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/blocs/feedroom/feedroom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:image_picker/image_picker.dart';

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
  List<Attachment> attachments = [];
  bool uploaded = false;
  bool isUploading = false;
  late final String uploadedUrl;
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
                              "yes": {"image_count": "1"}
                            },
                            "video_attached": "no",
                            "document_attached": "no",
                          },
                        );
                        Navigator.of(context).pop();
                      }
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
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: kPrimaryColor,
                ),
                child: user.imageUrl.isNotEmpty
                    ? Image.network(user.imageUrl)
                    : Center(
                        child: Text(
                        user.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
              ),
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
                    border: InputBorder.none, hintText: "Write something here"),
              ),
            ),
            kVerticalPaddingXLarge,
            if (isUploading) const CircularProgressIndicator(),
            if (uploaded)
              // const Text(
              //   "Successfully uploaded",
              //   style: TextStyle(
              //     color: Colors.green,
              //     fontSize: 24,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kGrey2Color.withOpacity(0.2),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(uploadedUrl),
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
              onUploaded: (String? response) {
                if (response != null && response.isNotEmpty) {
                  attachments.add(Attachment(
                    attachmentType: 1,
                    attachmentMeta: AttachmentMeta(
                      url: response,
                    ),
                  ));
                  setState(() {
                    uploaded = true;
                    isUploading = false;
                    uploadedUrl = response;
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
  final Function(String? response) onUploaded;
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
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          File file = File.fromUri(Uri(path: image.path));
          final String? response =
              await locator<LikeMindsService>().uploadFile(file);
          if (response != null) {
            onUploaded(response);
          } else {
            print('Error uploading file');
          }
        } else {
          print('No image selected');
          onUploaded(null);
        }
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
