import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/add_user.dart';
import 'package:mess_app/widgets/chat_list.dart';

class HomeScreenItems extends StatefulWidget {

  const HomeScreenItems({super.key});

  @override
  State<HomeScreenItems> createState() => _HomeScreenItemsState();
}

class _HomeScreenItemsState extends State<HomeScreenItems> {
  @override
  void initState() {
    super.initState();
    APISystem.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('message : $message');

      if (APISystem.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APISystem.updateActiveStatus(true);
        }

        if (message.toString().contains('pause')) {
          APISystem.updateActiveStatus(false);
        }
      }

      if (message.toString().contains('inactive')) {
        APISystem.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  final _searchController = TextEditingController();
  List<UserChat> list = [];
  final List<UserChat> _searchList = [];
  bool _isSearch = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearch) {
            setState(() {
              _isSearch = !_isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddUser(),
                  ));
            },
            child: Icon(
              CupertinoIcons.person_2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(_isSearch ? 0 : 50.0),
                  ),
                ),
                // floating: true,
                pinned: true,
                stretch: true,
                elevation: 4,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Container()),
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                    ],
                    titlePadding: const EdgeInsets.all(10),
                    title: _isSearch
                        ? SizedBox(
                            height: 40,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 2000),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: const TextStyle(
                                    fontSize: 15, letterSpacing: 0.5),
                                onChanged: (value) {
                                  _searchList.clear();

                                  for (var i in list) {
                                    if (i.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        i.email
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        i.id
                                            .toLowerCase()
                                            .contains(value.toLowerCase())) {
                                      _searchList.add(i);
                                      setState(() {
                                        _searchList;
                                      });
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    size: 20,
                                  ),
                                  hintText: 'Search here',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_searchController.text.contains(
                                              _searchController.text)) {
                                            _searchController.clear();
                                            if (_isSearch == true) {
                                              _isSearch = false;
                                            }
                                          }
                                          // _searchList.clear();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        size: 20,
                                      )),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chats',
                                style: TextStyle(
                                    fontSize: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_isSearch == false) {
                                        _isSearch = true;
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.search_rounded,
                                    size: 20,
                                  ))
                            ],
                          )),
                expandedHeight: _isSearch ? 50 : 150,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: mq.height,
                  child: StreamBuilder(
                      stream: APISystem.getAllUsers(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //when data loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 1.6,
                            ));

                          //when all data is loaded
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            list = data
                                    ?.map((e) => UserChat.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (list.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No Chats',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _isSearch
                                      ? _searchList.length
                                      : list.length,
                                  itemBuilder: (context, index) {
                                    return ChatList(user: list[index]);
                                  });
                            }
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
