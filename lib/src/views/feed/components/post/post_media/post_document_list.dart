import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document.dart';
import 'package:flutter/material.dart';

class PostDocumentList extends StatefulWidget {
  PostDocumentList({super.key});

  @override
  State<PostDocumentList> createState() => _PostDocumentListState();
}

class _PostDocumentListState extends State<PostDocumentList> {
  List<String> docs = [
    'https://az764295.vo.msecnd.net/stable/d045a5eda657f4d7b676dedbfa7aab8207f8a075/VSCode-darwin-universal.zip',
    'https://storage.googleapis.com/cms-storage-bucket/847ae81f5430402216fd.svg',
    'https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png',
    // 'LOL'
  ];

  List<String> first3Docs = [];
  List<String> moreDocs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < docs.length; i++) {
      if (i > 2)
        moreDocs.add(docs[i]);
      else
        first3Docs.add(docs[i]);
    }
  }

  bool moreToggle = false;
  toggleMoreDocs() {
    setState(() {
      moreToggle = !moreToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kPaddingLarge, right: kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: first3Docs
                .map((e) => PostDocument(
                      url: e,
                      size: '230',
                      type: 'PNG',
                    ))
                .toList(),
          ),
          if (moreDocs.isNotEmpty && !moreToggle)
            GestureDetector(
              child: Text('+${moreDocs.length} more',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: kFontMedium)),
              onTap: toggleMoreDocs,
            ),
          if (moreToggle)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...moreDocs
                    .map((e) => PostDocument(
                          url: e,
                          size: '230',
                          type: 'PNG',
                        ))
                    .toList(),
                GestureDetector(
                  child: Text('Show less',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: kFontMedium)),
                  onTap: toggleMoreDocs,
                )
              ],
            ),
        ],
      ),
    );
  }
}
