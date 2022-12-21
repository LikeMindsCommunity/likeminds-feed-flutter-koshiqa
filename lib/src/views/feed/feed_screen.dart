// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/data/local_db/local_db_impl.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:feed_sx/src/data/repositories/branding/branding_repository.dart';
import 'package:feed_sx/src/sdk/branding_sdk.dart';
import 'package:feed_sx/src/theme.dart';
import 'package:feed_sx/src/views/feed/components/custom_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post_media.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalDBImpl>(
        future: LocalDBImpl.init(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            return FutureBuilder<Branding?>(
                future: BrandingRepository(
                        mockSDK: BrandingSDK(), localDB: LocalDBImpl())
                    .getCommunityBranding('test'),
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.hasError) {
                    if (snapshot.hasData) {
                      Branding? branding = snapshot.data;
                      return Theme(
                        data: getThemeDataFromBrandingData(branding),
                        child: Scaffold(
                          backgroundColor: kBackgroundColor,
                          appBar: CustomAppBar(),
                          body: ListView(
                            children: const [
                              PostWidget(),
                              PostWidget(),
                              PostWidget(),
                              PostWidget(),
                              PostWidget(),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return Center(child: const Loader());
                });
          }
          return Center(child: const Loader());
        });
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        color: kWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            PostHeader(),
            PostDescription(),
            PostImage(),
            PostActions()
          ],
        ),
      ),
    );
  }
}
