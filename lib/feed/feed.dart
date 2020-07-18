import 'package:flutter/material.dart';
import 'package:hamstercare/add/add.dart';
import 'package:hamstercare/discussion/discussion.dart';
import 'package:hamstercare/models/gallery.dart';
import 'package:hamstercare/models/mock_feed.dart';
import 'package:hamstercare/models/mock_user.dart';
import 'package:hamstercare/models/user.dart';
import 'package:hamstercare/reminder/reminderscreen.dart';
import 'package:hamstercare/userProfile/userProfile.dart';

class FeedNews extends StatefulWidget {
  final List<Gallery> feed;
  final User user;

  FeedNews(this.feed, this.user);

  @override
  _FeedNewsState createState() => _FeedNewsState();
}

class _FeedNewsState extends State<FeedNews> {
  final _caption = TextEditingController();

  void _editCaption(int index) {
    setState(() {
      Gallery g = Gallery.copy(widget.feed[index]);
      g.feedText = _caption.text;
      widget.feed[index].feedText = g.feedText;
    });
  }

  void _deletePost(int index) {
    setState(() {
      int j;
      for (var i = 0; i < widget.user.photoUrl.length; i++) {
        if(widget.feed[index].feedImage == widget.user.photoUrl[i].feedImage)
        {
          j =i;
        }
      }

      widget.user.photoUrl.removeAt(j);
      widget.feed.removeAt(index);
    });
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNavigationBar(),
      // appBar: AppBar(
      //   backgroundColor: Colors.orange,
      //   leading: Icon(Icons.announcement),
      //   title:
      // //   Column(
      // //   crossAxisAlignment: CrossAxisAlignment.start,
      // //   children: <Widget>[
      // //     Container(
      // //       height: 100,
      // //       padding: EdgeInsets.only(
      // //         right: 10,
      // //         left: 10,
      // //         bottom: 10,
      // //         top: 40,
      // //       ),
      // //       child: Row(
      // //         children: <Widget>[
      // //           Expanded(
      // //               child: Container(
      // //             decoration: BoxDecoration(
      // //               borderRadius: BorderRadius.circular(50),
      // //               color: Colors.grey[200],
      // //             ),
      // //             child: TextField(
      // //               decoration: InputDecoration(
      // //                 prefixIcon: Icon(Icons.search, color: Colors.grey),
      // //                 border: InputBorder.none,
      // //                 hintStyle: TextStyle(color: Colors.grey),
      // //                 hintText: "Search",
      // //               ),
      // //             ),
      // //           ))
      // //         ],
      // //       ),
      // //     )
      // //   ],
      // // ),
      //   // Row(
      //   //   mainAxisAlignment: MainAxisAlignment.center,
      //   //   children: <Widget>[
      //   //     Text('HamsterCare'),
      //   //   ],
      //   // ),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 0,
              top: 20,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.orange[50],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.search, color: Colors.orange[700]),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.orange[600]),
                        hintText: "Search",
                      ),
                    ),
                  ),
                ),
                // jarak tepi SizedBox(width: 20,),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              // scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: feed.length,
                        itemBuilder: (BuildContext context, int index) {
                          return makeFeed(feed[index], index);
                        }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget makeFeed(Gallery feed, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(feed.userImage), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        feed.userName,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        feed.feedTime,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              widget.user.username == feed.userName
                  ? PopupMenuButton<int>(
                      onSelected: (value) {
                        if(value == 1)
                        {
                          //share 
                        }
                        else if(value == 2)
                        {
                          showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Edit Caption"),
                                      content: TextField(
                                        controller: _caption,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: feed.feedText,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Edit Caption'),
                                          onPressed: () {
                                            _editCaption(index);
                                            _caption.clear();
                                            Navigator.of(context)
                                                .pop(widget.feed);
                                          },
                                        ),
                                        FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              _caption.clear();
                                              Navigator.of(context).pop(null);
                                            }),
                                      ],
                                    );
                                  });
                        }
                        else
                        {
                          _deletePost(index);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Share",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(
                              "Edit",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                
                        PopupMenuItem(
                          value: 3,
                          child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        
                      ],
                      icon: Icon(Icons.more_vert),
                      offset: Offset(0, 100),
                    )
                  : PopupMenuButton<int>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Share",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      icon: Icon(Icons.more_vert),
                      offset: Offset(0, 100),
                    ),

              /*IconButton(
                icon: Icon(Icons.more_horiz, size: 30, color: Colors.grey[600],), 
                onPressed: () {
                  PopupMenuButton(
                    item
                    itemBuilder: null)
                },
              )*/
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            feed.feedText,
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
                letterSpacing: .7),
          ),
          SizedBox(
            height: 20,
          ),
          feed.feedImage != ''
              ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage(feed.feedImage),
                          fit: BoxFit.cover)),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLike(),
                  Transform.translate(offset: Offset(-5, 0), child: makeLove()),
                  SizedBox(
                    width: 5,
                  ),
                  //like number
                  Text(
                    feed.like,
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  )
                ],
              ),
              //like comment
              Text(
                feed.comment,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              makeLikeButton(isActive: true),
              makeCommentButton(),
              makeShareButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget makeShareButton() {
    return Container(
      width: 12,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      height: 30,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.share, color: Colors.grey, size: 18),
            //SizedBox(width: ,),
            FlatButton(
              onPressed: null,
              child: Text(
                "Share",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeCommentButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      height: 30,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.chat, color: Colors.grey, size: 18),
            //  SizedBox(width: 5,),
            FlatButton(
              onPressed: null,
              child: Text(
                "Comment",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeLikeButton({isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      height: 30,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: isActive ? Colors.blue : Colors.grey,
              size: 18,
            ),
            // SizedBox(width: 3,),
            FlatButton(
              onPressed: null,
              child: Text(
                "Like",
                style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeLove() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.favorite, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLike() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            title: Text('QnA'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('Add'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Reminder'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text('Profile'),
          ),
        ],
        onTap: (index) {
          switch (index) {
           case 0:
              Navigator.push(context,MaterialPageRoute(builder: (context) => FeedNews(feed,widget.user)));
             break;
             case 1:
              Navigator.push(context,MaterialPageRoute(builder: (context) => DiscussionScreen(mockUser[0])));
             break;
             case 2:
              Navigator.push(context,MaterialPageRoute(builder: (context) => AddScreen(mockUser[0])));
             break;
             case 3:
             Navigator.push(context,MaterialPageRoute(builder: (context) => ReminderScreen(mockUser[0]),));
             break;
             case 4:
             Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage(mockUser[0]),));
             break;
          }
          setState(() {
            _currentIndex = index;
          });
        });
  }
}
