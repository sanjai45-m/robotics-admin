import 'package:flutter/material.dart';
import 'package:jkv/controller/theme_provider.dart';
import 'package:jkv/view/form/email.dart';
import 'package:jkv/view/form/gallery/categories_page.dart';
import 'package:jkv/view/form/gallery/gallery_list_screen.dart';
import 'package:jkv/view/form/learning_paths.dart';
import 'package:jkv/view/form/settings.dart';
import 'package:jkv/view/form/worshops.dart';
import 'package:provider/provider.dart';

class Drawers extends StatelessWidget {
  final String activePage;

  const Drawers({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.7, // Small drawer width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepPurple.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/new-logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home_outlined,
            title: "Home",
            isActive: activePage == "Home",
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const WorkShops(),
              ));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.backup_table_outlined,
            title: "Learning Paths",
            isActive: activePage == "Learning Paths",
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const TrainingPrograms(),
              ));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.cast_for_education,
            title: "Gallery",
            isActive: activePage == "Gallery",
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => GalleryListScreen(),
              ));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category_outlined,
            title: "Categories page",
            isActive: activePage == "Categories page",
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CategoryScreen(),
              ));
            },
          ), _buildDrawerItem(
            context,
            icon: Icons.email_outlined,
            title: "Email",
            isActive: activePage == "Email",
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const EmailData(),
              ));
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: "Settings",
            isActive: activePage == "Settings",
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Settings(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool isActive,
        required VoidCallback onTap,
      }) {
    // Access ThemeProvider to check the theme mode
    final theme = Provider.of<ThemeProvider>(context).themeMode;

    return Container(
      color: isActive ? Colors.blue[50] : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          size: 25,
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: theme == ThemeMode.light ? Colors.black : Colors.blue, // Check ThemeMode
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}