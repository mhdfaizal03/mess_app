import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';
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
  }

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
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              Container(
                height: mq.height * .15,
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: mq.height * 0.02,
                      right: mq.height * 0.02,
                      left: mq.height * 0.02),
                  child: _isSearch
                      ? Center(
                          child: TextField(
                            autofocus: true,
                            style: const TextStyle(
                                fontSize: 18, letterSpacing: 0.5),
                            onChanged: (value) {
                              _searchList.clear();

                              for (var i in list) {
                                if (i.name
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    i.email
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
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search here',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_isSearch = true) {
                                        _isSearch = false;
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.close)),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Chats',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearch = !_isSearch;
                                });
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder(
                    stream: APISystem.getAllUsers(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //when data loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

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
            ],
          ),
        ),
      ),
    );
  }
}
