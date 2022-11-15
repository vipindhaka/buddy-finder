import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studypartner/models/collabPost.dart';
import 'package:studypartner/pages/postACollab.dart';
import 'package:studypartner/widgets/post.dart';

class ExamPage extends StatefulWidget {
  final DocumentSnapshot user;
  ExamPage(this.user);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage>
    with AutomaticKeepAliveClientMixin {
  List<CollabPost> cachedPosts = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: cachedPosts.isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  cachedPosts.clear();
                });
                return;
              },
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('interestRequirement',
                        whereIn: widget.user['interests'])
                    .orderBy(
                      'timestamp',
                    )

                    //.where('userId', isNotEqualTo: widget.user['uid'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> posts = snapshot.data.docs;
                  posts.removeWhere(
                      (element) => element['userId'] == widget.user['uid']);

                  if (posts.length == 0) {
                    return Center(child: Text('No Collab Posts'));
                  }
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = CollabPost.fromMap(posts[index].data());
                      cachedPosts.add(post);
                      return SinglePost(post, widget.user);
                    },
                  );
                },
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  cachedPosts.clear();
                });
                return;
              },
              child: ListView.builder(
                itemCount: cachedPosts.length,
                itemBuilder: (context, index) {
                  return SinglePost(cachedPosts[index], widget.user);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'postcollab',
        child: Icon(Icons.post_add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(PostACollab.routeName, arguments: widget.user);
        },
      ),
    );
  }

  @override
  
  bool get wantKeepAlive => true;
}
