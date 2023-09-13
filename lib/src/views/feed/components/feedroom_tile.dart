import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:flutter/material.dart';

class FeedRoomTile extends StatelessWidget {
  const FeedRoomTile({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final FeedRoom item;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 8,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: item.chatroomImageUrl != null
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(item.chatroomImageUrl!),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.header,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${item.participantsCount} participants",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: Colors.grey, height: 1),
        ],
      ),
    );
  }
}
