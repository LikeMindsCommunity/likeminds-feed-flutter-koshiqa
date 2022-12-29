// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/data/local_db/local_db_impl.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:feed_sx/src/data/repositories/branding/branding_repository.dart';
import 'package:feed_sx/src/sdk/branding_sdk.dart';
import 'package:feed_sx/src/simple_bloc_observer.dart';
import 'package:feed_sx/src/theme.dart';
import 'package:feed_sx/src/views/feed/components/custom_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Bloc.observer = SimpleBlocObserver();
  }

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
                              PostWidget(postType: 1),
                              PostWidget(postType: 2),
                              PostWidget(postType: 3),
                              PostWidget(postType: 1),
                              PostWidget(postType: 4),
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
