import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/media_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'new_post_event.dart';
part 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvents, NewPostState> {
  NewPostBloc() : super(NewPostInitiate()) {
    on<NewPostEvents>((event, emit) async {
      if (event is CreateNewPost) {
        try {
          List<MediaModel>? postMedia = event.postMedia;
          int imageCount = 0;
          int videoCount = 0;
          int documentCount = 0;
          List<Attachment> attachments = [];
          int index = 0;

          StreamController<double> progress =
              StreamController<double>.broadcast();
          progress.add(0);
          emit(
            NewPostUploading(
              progress: progress.stream,
              thumbnailMedia: postMedia != null ? postMedia[0] : null,
            ),
          );
          // Upload post media to s3 and add links as Attachments
          if (postMedia != null) {
            for (final media in postMedia) {
              if (media.mediaType == MediaType.link) {
                attachments.add(
                  Attachment(
                    attachmentType: 4,
                    attachmentMeta: AttachmentMeta(
                        url: media.ogTags!.url,
                        ogTags: AttachmentMetaOgTags(
                          description: media.ogTags!.description,
                          image: media.ogTags!.image,
                          title: media.ogTags!.title,
                          url: media.ogTags!.url,
                        )),
                  ),
                );
              } else {
                File mediaFile = media.mediaFile!;
                index += 1;
                final String? response = await locator<LikeMindsService>()
                    .uploadFile(mediaFile, event.user!.userUniqueId);
                if (response != null) {
                  attachments.add(Attachment(
                    attachmentType: media.mapMediaTypeToInt(),
                    attachmentMeta: AttachmentMeta(
                        url: response,
                        size: media.mediaType == MediaType.document
                            ? media.size
                            : null,
                        format: media.mediaType == MediaType.document
                            ? media.format
                            : null,
                        duration: media.mediaType == MediaType.video
                            ? media.duration
                            : null),
                  ));
                  progress.add(index / postMedia.length);
                } else {
                  throw ('Error uploading file');
                }
              }
            }
            // For counting the no of attachments
            for (final attachment in attachments) {
              if (attachment.attachmentType == 1) {
                imageCount++;
              } else if (attachment.attachmentType == 2) {
                videoCount++;
              } else if (attachment.attachmentType == 3) {
                documentCount++;
              }
            }
          }
          final AddPostRequest request = (AddPostRequestBuilder()
                ..text(event.postText)
                ..attachments(attachments)
                ..feedroomId(event.feedRoomId))
              .build();

          final AddPostResponse response =
              await locator<LikeMindsService>().addPost(request);

          if (response.success) {
            LMAnalytics.get().track(
              AnalyticsKeys.postCreationCompleted,
              {
                "user_tagged": "no",
                "link_attached": "no",
                "image_attached": imageCount == 0
                    ? "no"
                    : {
                        "yes": {
                          "image_count": imageCount,
                        },
                      },
                "video_attached": videoCount == 0
                    ? "no"
                    : {
                        "yes": {
                          "video_count": videoCount,
                        },
                      },
                "document_attached": documentCount == 0
                    ? "no"
                    : {
                        "yes": {
                          "document_count": documentCount,
                        },
                      },
              },
            );
            emit(NewPostUploaded(
                postData: response.post!, userData: response.user!));
          } else {
            emit(NewPostError(
                message: response.errorMessage ?? 'An error occurred'));
          }
        } catch (err) {
          emit(const NewPostError(message: 'An error occurred'));
          print(err.toString());
        }
      }
    });
  }
}