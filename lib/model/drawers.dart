import 'package:flutter/material.dart';
import 'package:jkv/view/form/gallery/categories_page.dart';
import 'package:jkv/view/form/gallery/gallery_list_screen.dart';
import 'package:jkv/view/form/learning_paths.dart';
import 'package:jkv/view/form/worshops.dart';

class Drawers extends StatelessWidget {
  const Drawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Image.asset(
            'assets/images/JKV-logo.png',
          )),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined,size: 25,),
            title: const Text("Home",style: TextStyle(fontSize: 25),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WorkShops(),));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cast_for_education,size: 25,),
            title: const Text("Learning Paths",style: TextStyle(fontSize: 25),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TrainingPrograms(),));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cast_for_education,size: 25,),
            title: const Text("Gallery",style: TextStyle(fontSize: 25),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  GalleryListScreen(),));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cast_for_education,size: 25,),
            title: const Text("Categories page",style: TextStyle(fontSize: 25),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  CategoryScreen(),));
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
