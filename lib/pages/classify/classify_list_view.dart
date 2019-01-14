import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:it_resource_exchange_app/widgets/indicator_factory.dart';
import 'package:it_resource_exchange_app/pages/home/goods_item_view.dart';
class ClassifyListView extends StatefulWidget {

  final String title;

  ClassifyListView(this.title);

  @override
  _ClassifyListViewState createState() => _ClassifyListViewState();
}

class _ClassifyListViewState extends State<ClassifyListView> with AutomaticKeepAliveClientMixin {

  bool _isLoading = true;
  int _page = 1;
  int _tempCount = 10;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _getCategoryData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: _isLoading,
            child: SmartRefresher(
              controller: _refreshController,
              headerBuilder: buildDefaultHeader,
              footerBuilder: (context, mode) =>
                  buildDefaultFooter(context, mode, () {
                    _refreshController.sendBack(false, RefreshStatus.refreshing);
                  }),
              onRefresh: _onRefresh,
              enablePullUp: true,
              child: ListView.builder(
                itemCount: _tempCount,
                itemBuilder: (context, index) {
                  return GoodsItemView(index: index);
                },
              ),  
            ),
          ),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        ],
      ),
    );
  }


  void _onRefresh(bool up) {
    if (!up) {
      _page++;
      _getCategoryData(loadMore: true);
    }else {
      _page = 1;
      _getCategoryData(loadMore: false);
    }
  }

  void _getCategoryData({bool loadMore = false}) {
    Future.delayed(Duration(seconds: 3), () {
      if (loadMore) {
        _refreshController.sendBack(false, RefreshStatus.idle);
        setState(() {
          _tempCount += 10;
          _isLoading = false;
         });
      }else {
         _refreshController.sendBack(true, RefreshStatus.completed);
         setState(() {
          _tempCount = 10;
          _isLoading = false;
         });
      }
    });
  }
}