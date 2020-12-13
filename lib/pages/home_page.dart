import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../constant/data_json.dart';
import '../theme/colors.dart';
import '../widgets/column_social_icon.dart';
import '../widgets/header_home_page.dart';
import '../widgets/left_panel.dart';
import '../widgets/tik_tok_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return VideoPlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            songName: items[index]['songName'],
            profileImg: items[index]['profileImg'],
            likes: items[index]['likes'],
            comments: items[index]['comments'],
            shares: items[index]['shares'],
            albumImg: items[index]['albumImg'],
          );
        }),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;
  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.caption,
      this.songName,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.albumImg,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((value) {
        _videoController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: black),
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_videoController),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: isPlaying(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          HeaderHomePage(),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                LeftPanel(
                                  size: widget.size,
                                  name: "${widget.name}",
                                  caption: "${widget.caption}",
                                  songName: "${widget.songName}",
                                ),
                                RightPanel(
                                  size: widget.size,
                                  likes: "${widget.likes}",
                                  comments: "${widget.comments}",
                                  shares: "${widget.shares}",
                                  profileImg: "${widget.profileImg}",
                                  albumImg: "${widget.albumImg}",
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class RightPanel extends StatefulWidget {
  @override
  _RightPanelState createState() => _RightPanelState();

  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key key,
    @required this.size,
    this.likes,
    this.comments,
    this.shares,
    this.profileImg,
    this.albumImg,
  }) : super(key: key);

  final Size size;
}

class _RightPanelState extends State<RightPanel>
    with SingleTickerProviderStateMixin {
  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    rotationController.repeat();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: widget.size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: widget.size.height * 0.3,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getProfile(widget.profileImg),
                getIcons(TikTokIcons.heart, widget.likes, 35.0),
                getIcons(TikTokIcons.chat_bubble, widget.comments, 35.0),
                getIcons(TikTokIcons.reply, widget.shares, 25.0),
                AnimatedBuilder(
                  animation: rotationController,
                  child: getAlbum(widget.albumImg),
                  builder: (BuildContext context, Widget _widget) {
                    return new Transform.rotate(
                      angle: rotationController.value * 6.3,
                      child: _widget,
                    );
                  },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

// class RightPanel extends StatelessWidget {
//   final String likes;
//   final String comments;
//   final String shares;
//   final String profileImg;
//   final String albumImg;
//   const RightPanel({
//     Key key,
//     @required this.size,
//     this.likes,
//     this.comments,
//     this.shares,
//     this.profileImg,
//     this.albumImg,
//   }) : super(key: key);

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         height: size.height,
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: size.height * 0.3,
//             ),
//             Expanded(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 getProfile(profileImg),
//                 getIcons(TikTokIcons.heart, likes, 35.0),
//                 getIcons(TikTokIcons.chat_bubble, comments, 35.0),
//                 getIcons(TikTokIcons.reply, shares, 25.0),
//                 RotationTransition(
//                   child:  getAlbum(albumImg),
//                   turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),

//                 )

//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
