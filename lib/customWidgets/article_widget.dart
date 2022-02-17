
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/configs/dimens.dart';
import 'package:news_app/configs/routes.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/customWidgets/article_details.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleDetails(article: article,)),
        );},
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
          children: [

            Stack(
              children: [
                Hero(
                  tag: "ImageTag" + article.title!,
                  child: Container(
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
            const SizedBox(height: 10,),
            Text(article.title.toString(),style: const TextStyle(color: Colors.white,fontSize: 18),),
            Text("${article.description}",style: const TextStyle(color: Colors.white54,fontSize: 12),),
          ],
        )
      ),
    );
  }
}
