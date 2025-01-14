import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_avancee_tp3/widgets/my_drawer.dart';

import '../generated/l10n.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'creation_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void createNew() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CreationPage()));
  }

  detail(String id) {
     Navigator.push(
         context, MaterialPageRoute(builder: (context) => DetailPage(id: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).home),
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: FutureBuilder<List<AppTask>>(
          future: getTasks(),
          builder: (context, lst) {
            if (lst.hasData) {
              return buildListView(lst.data!);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNew,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView buildListView(List<AppTask> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return MaterialButton(
            onPressed: () {
              detail(items[index].id);
            },
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(items[index].name),
                    subtitle: Text(
                        "${S.of(context).deadline} : ${DateFormat(S.current.dateFormat).format(items[index].deadline)}"),
                  ),
                  buildImage(items, index),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(S
                          .of(context)
                          .percentageDoneHome(items[index].percentageDone)),
                      Text(S
                          .of(context)
                          .timeElapsed(items[index].percentageTimeSpent))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  SizedBox buildImage(List<AppTask> items, int index) {
    if(items[index].imgURL != ""){
      return SizedBox(
        height: 200,
        width: 325,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: items[index].imgURL,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    }
    else{
      return const SizedBox();
    }
  }
}
