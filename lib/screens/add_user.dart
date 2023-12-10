import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/widgets/chat_list.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _searchController = SearchController();

  bool _isSearch = false;

  final List<UserChat> _searchList = [];

  List<UserChat> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            stretch: true,
            elevation: 4,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0), child: Container()),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                ],
                titlePadding: const EdgeInsets.all(10),
                title: SizedBox(
                  height: 40,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 2000),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 15, letterSpacing: 0.5),
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
                              Navigator.pop(context);
                              setState(() {
                                if (_searchController.text
                                    .contains(_searchController.text)) {
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
                        fillColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )),
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
                              itemCount:
                                  _isSearch ? _searchList.length : list.length,
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
    );
  }
}
