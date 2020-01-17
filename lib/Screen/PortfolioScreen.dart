import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_album_new/Common/Services.dart';
import 'package:insta_album_new/Components/LoadinComponent.dart';
import 'package:insta_album_new/Components/NoDataComponent.dart';
import 'package:insta_album_new/Components/PortfolioComponents.dart';

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portfolio"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List>(
          future: Services.GetportfolioGalleryList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data != null && snapshot.data.length > 0
                    ? StaggeredGridView.countBuilder(
                        padding:
                            const EdgeInsets.only(left: 3, right: 3, top: 5),
                        itemCount: snapshot.data.length,
                        //shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 4,
                        addRepaintBoundaries: false,
                        staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return PortfolioComponents(snapshot.data[index]);
                        },
                      )
                    : NoDataComponent()
                : LoadinComponent();
          },
        ),
      ),
    );
  }
}
