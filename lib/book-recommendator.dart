import 'package:firebase_ml_text_recognition/model/book-recommendation.dart';
import 'package:firebase_ml_text_recognition/services/recommendation-service.dart';
import 'package:firebase_ml_text_recognition/widget/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookRecommendationInput extends StatefulWidget {
  @override
  _BookRecommendationInputState createState() => _BookRecommendationInputState();
}

class _BookRecommendationInputState extends State<BookRecommendationInput> {

  var bookName = TextEditingController();
  var key = GlobalKey<ScaffoldState>();
  List<Info> booksList = [];
  
  void findRecommendation(String bookName) async {
    openLoadingDialog(context, "Finding recommendations");
    BookRecommendation recommendation = await RecommendationService().getRecommendation(bookName);
    Navigator.pop(context);
    if(recommendation.similar.results.isNotEmpty){
      setState(() {
        booksList = recommendation.similar.results;
      });
    } else {
      setState(() {
        booksList.clear();
      });
      key.currentState.showSnackBar(
          SnackBar(content: Text("Sorry we could not find books similar to $bookName."),
            behavior: SnackBarBehavior.floating,));
    }
    // for(var rec in recommendation.similar.results)
    //   print(rec.name);

    // print(recommendation.similar.results.map((e) => e.name));

    print(recommendation.similar.results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: true,
            titleSpacing: 0,
            actions: <Widget>[SizedBox(width: 15)],
            title: CupertinoTextField(
              controller: bookName,
              cursorColor: Colors.grey,
              autofocus: true,
              textInputAction: TextInputAction.go,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)),
              placeholder: "Book Name...",
              clearButtonMode: OverlayVisibilityMode.editing,
              onSubmitted: (String value){
                if(value.isNotEmpty)
                  findRecommendation(value.trim());
                else
                  key.currentState.showSnackBar(
                      SnackBar(content: Text("Please input a book name."),
                    behavior: SnackBarBehavior.floating,));
              },
              prefix: Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 2, 8),
                child: Icon(CupertinoIcons.search,
                    size: 18, color: Colors.grey.shade700),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),

          // SliverToBoxAdapter(
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: booksList.length,
          //       itemBuilder: (context,index){
          //       var book = booksList[index];
          //       return ListTile(
          //         title: Text(book.name),
          //       );
          //   })),
          booksList.isNotEmpty ?
              SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var book = booksList[index];
                          return ListTile(
                            title: Text(book.name,style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87
                            ),),
                          );
                          },
                    childCount: booksList.length),
              ) :  SliverToBoxAdapter(
                child: Center(
                 child: Container(
                   height: MediaQuery.of(context).size.height/1.2,
                     child: Image.asset("assets/book-recommender.jpg")),
          ),
              )
        ],
      ),
    );
  }
}
