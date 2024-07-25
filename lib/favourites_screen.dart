import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: Consumer<QuoteProvider>(
        builder: (context, quoteProvider, child) {
          return ListView.builder(
            itemCount: quoteProvider.favorites.length,
            itemBuilder: (context, index) {
              final quote = quoteProvider.favorites[index];
              return ListTile(
                title: Text(quote),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    quoteProvider.removeFavorite(quote);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
