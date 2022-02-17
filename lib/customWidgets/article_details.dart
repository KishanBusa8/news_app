
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/configs/dimens.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/models/article.dart';

class ArticleDetails extends StatelessWidget {
  const ArticleDetails(
      {Key? key,
         this.article,})
      : super(key: key);

  final Article? article;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeClass.purpleColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          IconButton(onPressed: () {
            Get.back();
          }, icon: Icon(Icons.chevron_left_outlined),color: Colors.white,iconSize: 40,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "ImageTag" + article!.title!,
                  child: Container(

                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        child: article!.urlToImage != null
                            ? FadeInImage(
                          placeholder: const AssetImage('assets/img/giphy.gif'),
                          image: CachedNetworkImageProvider(article!.urlToImage!,),
                        )
                            : const Image(
                          image: AssetImage('assets/img/no-image.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                article!.author == null ? Container() : Text("- "+article!.author.toString(),style: const TextStyle(color: Colors.amberAccent,fontSize: 18),),
                const SizedBox(height: 10,),
                Text("Source: ${article!.source!.name}",style:   TextStyle(color: Colors.amberAccent.shade200,fontSize: 14),),
                const SizedBox(height: 10,),
                Text(article!.title.toString(),style: const TextStyle(color: Colors.white,fontSize: 18),),
                const SizedBox(height: 10,),
                Text("${article!.description}",style: const TextStyle(color: Colors.white70,fontSize: 14),),
                const SizedBox(height: 10,),
                Text("${article!.content}",style: const TextStyle(color: Colors.white54,fontSize: 14),),

              ],
            )
    ),
        ],
      ),);
  }
}
