import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quote_provider.dart';
import 'home_screen.dart';
import 'theme_notifier.dart';
import 'favourites_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuoteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Daily Quotes',
          theme: themeNotifier.isDarkMode ? darkTheme : lightTheme,
          home: HomeScreen(),
        );
      },
    );
  }
}

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Raleway',
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  cardColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.redAccent, // Set your desired app bar color here
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'Raleway',
      fontSize: 20,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Raleway',
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
  cardColor: Colors.grey[900],
);

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Quotes', style: TextStyle(fontFamily: 'Raleway')),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          Switch(
            value: themeNotifier.isDarkMode,
            onChanged: (value) {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeNotifier.isDarkMode
                    ? [Colors.blue.shade700, Colors.purple.shade700, Colors.pink.shade700]
                    : [Colors.orange.shade300, Colors.red.shade300, Colors.brown.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QuoteCard(
                      quote: Provider.of<QuoteProvider>(context).currentQuote,
                    ),
                    SizedBox(height: 20),
                    Consumer<ThemeNotifier>(
                      builder: (context, themeNotifier, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<QuoteProvider>(context, listen: false).shareQuote();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo, // Button background color
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                foregroundColor: Colors.white, // Text color
                              ),
                              child: Text('Share Quote'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<QuoteProvider>(context, listen: false).addFavorite();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo, // Button background color
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                foregroundColor: Colors.white, // Text color
                              ),
                              child: Text('Add to Favorites'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: Icon(Icons.double_arrow_rounded),
                color: Colors.white,
                iconSize: 40,
                onPressed: () {
                  Provider.of<QuoteProvider>(context, listen: false).nextQuote();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final String quote;

  const QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 300, // Increased height here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.format_quote,
                color: Colors.purple,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                quote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Raleway',
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes', style: TextStyle(fontFamily: 'Raleway')),
      ),
      body: Consumer<QuoteProvider>(
        builder: (context, quoteProvider, child) {
          return ListView.builder(
            itemCount: quoteProvider.favorites.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        quoteProvider.favorites[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        quoteProvider.removeFavorite(quoteProvider.favorites[index]);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
