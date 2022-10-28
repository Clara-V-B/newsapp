import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

const _BASEURL_NEWS = 'newsapi.org';
const _APIKEY = 'c06360ccff564bfc8c34b3956b7663a5';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  bool _isLoading = true;

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    categories.forEach((item) {
      this.categoryArticles[item.name] = new List.filled();
    });

    this.getArticlesByCategory(this._selectedCategory);
  }

  bool get isLoading => this.isLoading;

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this._isLoading = true;

    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategory];

  getTopHeadlines() async {
    //print('Cargando headlines...');
    final url = Uri.https(_BASEURL_NEWS, 'v2/top-headlines',
        {'country': 'ar', 'category': 'technology', 'apiKey': _APIKEY});

    final resp = await http.get(url);
    print(resp.body);
    final newsResponse = newsResponseFromJson(resp.body);

    headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    final url = Uri.https(_BASEURL_NEWS, 'v2/top-headlines',
        {'country': 'ar', 'category': category, 'apiKey': _APIKEY});

    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    categoryArticles[category].addAll(newsResponse.articles);

    _isLoading = false;
    notifyListeners();
  }
}
