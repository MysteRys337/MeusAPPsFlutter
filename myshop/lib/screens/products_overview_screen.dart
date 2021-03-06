import 'package:flutter/material.dart';
import 'package:myshop/providers/cart_provider.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:myshop/providers/products_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverview extends StatefulWidget {
  static const routeName = '/';
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = true;
  var _isLoading = false;

  void initState() {
    _refreshData();
    super.initState();
  }

  Future<void> _refreshData() async {
    return Future.delayed(Duration(microseconds: 20)).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchDataFromServer();
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget buildFilterOptionsButton() {
    return PopupMenuButton(
        onSelected: (FilterOptions selected) {
          setState(() {
            if (selected == FilterOptions.All) {
              _showOnlyFavorites = true;
            } else {
              _showOnlyFavorites = false;
            }
          });
        },
        icon: Icon(
          Icons.more_vert,
        ),
        itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorite'), value: FilterOptions.Favorites),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ]);
  }

  Widget buildCartButton() {
    return Consumer<CartsProvider>(
      builder: (_, cartData, widget) => Badge(
        child: widget,
        value: cartData.itemCount.toString(),
      ),
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: <Widget>[
            buildFilterOptionsButton(),
            buildCartButton(),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid(_showOnlyFavorites));
  }
}
