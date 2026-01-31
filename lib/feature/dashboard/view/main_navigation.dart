import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemNavigator ke liye
import 'package:google_fonts/google_fonts.dart';
import '../../Category/view/category_menu_page.dart';
import '../../ProfilePage/view/ProfilePage.dart';
import '../../products/view/stock_catalogue_page.dart';
import '../../wishlist/view/wishlist_page.dart';
import '../Main_View/Homepage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Luxury Theme Colors
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);

  final List<Widget> _pages = [
    Dashboard(),
    ProductCataloguePage(),
    CategoryMenuPage(),
    WishlistPage(),
    ProfilePage(),
  ];

  // --- Exit Confirmation Dialog ---
  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ivoryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Exit App",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: deepBlack),
        ),
        content: Text(
          "Are you sure you want to exit the app?",
          style: GoogleFonts.poppins(color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => SystemNavigator.pop(), // App close karne ke liye
            child: Text("Exit", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Default back navigation block karein
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Agar user Home index (0) par nahi hai, toh pehle Home par le jayein
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        } else {
          // Agar Home par hi hai, toh confirmation dialog dikhayein
          final shouldPop = await _showExitConfirmation(context);
          if (shouldPop && context.mounted) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: ivoryWhite,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: goldAccent,
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Icon(Icons.grid_view_rounded),
                label: "Catalogue",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_outlined),
                activeIcon: Icon(Icons.auto_awesome_rounded),
                label: "Collections",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.heart_broken_outlined),
                activeIcon: Icon(Icons.heart_broken),
                label: "Wishlist",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: "Account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}