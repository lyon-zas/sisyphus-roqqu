import 'package:flutter/material.dart';
import 'package:sisyphus/utils/styles.dart';

class CustomBottomSection extends StatelessWidget {
  const CustomBottomSection({Key? key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(top: 16),
      color: Theme.of(context).backgroundColor,
      width: double.infinity,
      child: Column(
        children: [
          _buildButtonRow(context),
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No open Orders',
                      style: isDarkMode
                          ? TextStyles.darkMainStyle
                          : TextStyles.lightMainStyle),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Id pulvinar nullam sit imperdiet pulvinar.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyles.darkSubtitleStyle.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget _buildButton({
      required String text,
      required VoidCallback onTap,
      required Color color,
    }) {
      return InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(text,
              style: isDarkMode
                  ? TextStyles.darkBoldStyle
                  : TextStyles.lightBoldStyle),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black.withOpacity(0.16) : Color(0XFFF1F1F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            text: 'Open Orders',
            onTap: () {},
            color: isDarkMode
                ? const Color(0XFFE9F0FF).withOpacity(0.05)
                : Colors.white,
          ),
          _buildButton(
            text: 'Positions',
            onTap: () {},
            color: Colors.transparent,
          ),
          _buildButton(
            text: 'History',
            onTap: () {},
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
