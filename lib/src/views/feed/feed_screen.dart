// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/data/local/local_db_impl.dart';
import 'package:feed_sx/src/data/models/branding.dart';
import 'package:feed_sx/src/sdk/mock_sdk.dart';
import 'package:feed_sx/src/data/repositories/mock_repository.dart';
import 'package:feed_sx/src/theme.dart';
import 'package:feed_sx/src/views/feed/components/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post_media.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalDBImpl>(
        future: LocalDBImpl.init(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            return FutureBuilder<Branding?>(
                future:
                    MockRepository(mockSDK: MockSDK(), localDB: LocalDBImpl())
                        .getCommunityBranding('test'),
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.hasError) {
                    if (snapshot.hasData) {
                      Branding? branding = snapshot.data;
                      return Theme(
                        data: getThemeDataFromBrandingData(branding),
                        child: Scaffold(
                          backgroundColor: kwhiteColor,
                          appBar: AppBar(
                            elevation: 0,
                            leading: Image.asset(
                                'packages/feed_sx/assets/images/hamburger.png'),
                            backgroundColor: kwhiteColor,
                            title: const Text(
                              'SCALIX',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            actions: const [
                              Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              kHorizontalLargeP,
                              CircleAvatar(
                                backgroundColor: Color(0xff5046E5),
                                radius: 20,
                                child: Center(
                                  child: Text(
                                    'KA',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: kwhiteColor,
                                        fontSize: kFontSmall),
                                  ),
                                ),
                              ),
                              kHorizontalLargeP,
                            ],
                          ),
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
                  return const CircularProgressIndicator();
                });
          }
          return const CircularProgressIndicator();
        });
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        PostHeader(),
        PostDescription(),
        PostImage(),
        PostActions()
      ],
    );
  }
}
