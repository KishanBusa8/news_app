
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/configs/dimens.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/models/article.dart';

class ArticleWidget extends StatelessWidget {
  const ArticleWidget(
      {Key? key,
        required this.article,
        required this.isBookMarked,

        required this.onAddBookMark})
      : super(key: key);

  final Article article;
  final Function onAddBookMark;
  final bool isBookMarked;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
        children: [

          Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    child: article.urlToImage != null
                        ? FadeInImage(
                      placeholder: const AssetImage('assets/img/giphy.gif'),
                      image: CachedNetworkImageProvider(article.urlToImage!),
                    )
                        : const Image(
                      image: AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: 10,
                  top: 10,
                  child: Column(
                children: [
                  IconButton(
                    iconSize: 20,
                    onPressed: () {
                    onAddBookMark();
                  }, icon:  Icon(isBookMarked ? Icons.bookmark :Icons.bookmark_add  ),color: Colors.amber,),
                  IconButton(
                      iconSize: 20,
                      onPressed: () {
                    onAddBookMark();
                  }, icon: Icon(Icons.open_in_browser,color: Colors.amber,))
                ],
              ))

            ],
          ),
          SizedBox(height: 10,),
          Container(
            child: Text(article.title.toString(),style: TextStyle(color: Colors.white,fontSize: 18),),
          ),
          Container(
            child: Text("${article.description}",style: TextStyle(color: Colors.white54,fontSize: 12),),
          ),
        ],
      )
    );
  }
}
