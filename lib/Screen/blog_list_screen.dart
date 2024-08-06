import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subspace_assignment/BLoC/blog_bloc.dart';
import 'package:subspace_assignment/Models/blog.dart';
import 'package:subspace_assignment/Screen/blog_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  List<Blog> _allBlogs = [];
  List<Blog> _filteredBlogs = [];
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
              _filterBlogs(_searchQuery);
            });
          },
        )
            : Text(
          'Blogs and Articles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isSearching ? Icons.clear : Icons.search,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                  _filterBlogs(_searchQuery);
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPysG6SomwDLiLhA8-Pz2ppdrP9xczRMhQFY08VEFKrkFTEVQM',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.info, color: Colors.black),
                      title: Text(
                        'Subspace AI',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        _launchURL('https://subspace.money/blog/whatsub-single-docs-onboarding-subspace-business-api');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.vpn_lock, color: Colors.black),
                      title: Text(
                        'Subspace VPN',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        _launchURL('https://play.google.com/store/apps/details?id=org.grow90.subspaceVPN');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.web, color: Colors.black),
                      title: Text(
                        'Subspace Web',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        _launchURL('https://app.subspace.money/');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[900],
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _categoryButton('All'),
                _categoryButton('Merchant'),
                _categoryButton('Business'),
                _categoryButton('Tutorial'),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BlogBloc, BlogState>(
              builder: (context, state) {
                if (state is BlogLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is BlogLoaded) {
                  _allBlogs = state.blogs;
                  _filterBlogs(_searchQuery);

                  return _filteredBlogs.isNotEmpty
                      ? ListView.builder(
                    itemCount: _filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = _filteredBlogs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetailScreen(blog: blog),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              blog.imageUrl != null
                                  ? Container(
                                width: double.infinity,
                                height: 200,
                                child: Image.network(
                                  blog.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading image: $error');
                                    return Icon(Icons.broken_image, size: 50, color: Colors.white);
                                  },
                                ),
                              )
                                  : Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey[800],
                                child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        blog.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        blog.isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: blog.isFavorite ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          blog.isFavorite = !blog.isFavorite;
                                          _updateFavoriteStatusInDatabase(blog);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : Center(child: Text('No blogs available for this category', style: TextStyle(color: Colors.white)));
                } else if (state is BlogError) {
                  return Center(child: Text('Error: ${state.message}', style: TextStyle(color: Colors.white)));
                }
                return Center(child: Text('Press button to fetch blogs', style: TextStyle(color: Colors.white)));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
          _filterBlogs(_searchQuery);
        });
      },
      style: ElevatedButton.styleFrom(
        primary: _selectedCategory == category ? Colors.blue : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _filterBlogs(String query) {
    if (_allBlogs.isNotEmpty) {
      _filteredBlogs = _allBlogs
          .where((blog) {
        bool matchesCategory = _selectedCategory == 'All' || blog.category == _selectedCategory;
        bool matchesQuery = blog.title.toLowerCase().contains(query.toLowerCase());
        return matchesCategory && matchesQuery;
      })
          .toList();
    } else {
      _filteredBlogs = [];
    }
  }

  Future<void> _updateFavoriteStatusInDatabase(Blog blog) async {
    // Your logic to update the favorite status in SQLite or other local storage
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
