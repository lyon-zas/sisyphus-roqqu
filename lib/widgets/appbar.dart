import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:sisyphus/utils/styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Container(
        height: preferredSize.height,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDarkMode
                  ? Image.asset(
                      "assets/Fictional company logo (2).png",
                      fit: BoxFit.cover,
                      width: 121,
                      height: 34,
                    )
                  : Image.asset(
                      "assets/Fictional company logo (1).png",
                      fit: BoxFit.cover,
                      width: 121,
                      height: 34,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/81 (1).png",
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.language,
                      color: isDarkMode
                          ? const Color(0xFFA7B1BC)
                          : const Color(0xFF737A91),
                      size: 30,
                    ),
                  ),
                  PopupMenuButton(
                    splashRadius: 8,
                    icon: SvgPicture.asset(
                      'assets/Icon.svg',
                      width: 18,
                      color: isDarkMode
                          ? const Color(0xFF8D98AF)
                          : const Color(0xFF737A91),
                      height: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            suffixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF2764FF),
                            ),
                            hintStyle: isDarkMode
                                ? TextStyles.darkMiddleStyle
                                : TextStyles.lightMiddleStyle,
                            fillColor: const Color(0xffF2F4F7),
                            helperStyle: const TextStyle(
                              fontSize: 32,
                              fontFamily: 'Fakt Pro',
                              height: 5,
                              fontWeight: FontWeight.w300,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xFFCFD9E4)),
                            ),
                          ),
                        ),
                      ),
                      const PopupMenuItem(
                        child: Text('Exchange'),
                      ),
                      const PopupMenuItem(
                        child: Text('Wallets'),
                      ),
                      const PopupMenuItem(
                        child: Text('Roqqu Hub'),
                      ),
                      const PopupMenuItem(
                        child: Text('Log out '),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
