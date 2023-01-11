import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/widgets/general_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewPostScreen extends StatefulWidget {
  static const String route = "/new_post_screen";
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhiteColor,
        appBar: const GeneralAppBar(
            autoImplyEnd: false,
            title: Text(
              'Create a Post',
              style: TextStyle(fontSize: 20, color: kGrey1Color),
            )),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: Image.asset('packages/feed_sx/assets/images/avatar.png'),
              ),
              kHorizontalPaddingLarge,
              const Text(
                'Theresa Webb',
                style: TextStyle(
                    fontSize: kFontMedium,
                    color: kGrey1Color,
                    fontWeight: FontWeight.w500),
              ),
            ]),
            kVerticalPaddingMedium,
            Expanded(
              child: TextField(
                controller: TextEditingController(),
                style: const TextStyle(fontSize: 18),
                maxLines: 100,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Write something here"),
              ),
            ),
            AddAssetsButton(
                leading: SvgPicture.asset(
                    'packages/feed_sx/assets/icons/add_photo.svg'),
                title: const Text('Add Photo')),
            AddAssetsButton(
                leading: SvgPicture.asset(
                    'packages/feed_sx/assets/icons/add_video.svg'),
                title: const Text('Add Video')),
            AddAssetsButton(
                leading: SvgPicture.asset(
                    'packages/feed_sx/assets/icons/add_attachment.svg'),
                title: const Text('Attach Files')),
          ]),
        ));
  }
}

class AddAssetsButton extends StatelessWidget {
  final Widget title;
  final Widget leading;
  const AddAssetsButton(
      {super.key, required this.leading, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor, width: 1))),
      child: Row(
        children: [leading, kHorizontalPaddingLarge, title],
      ),
    );
  }
}
