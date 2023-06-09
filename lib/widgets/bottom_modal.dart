import 'package:flutter/material.dart';
import 'package:sisyphus/utils/styles.dart';

class BuySellBottomModal extends StatelessWidget {
  const BuySellBottomModal({Key? key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).backgroundColor,
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.16),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0XFF25C26E)),
                          color: const Color(0XFFE9F0FF).withOpacity(0.05),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Text('Buy',
                              style: isDarkMode
                                  ? TextStyles.darkSubtitleStyle.copyWith(
                                      color: Colors.white,
                                    )
                                  : TextStyles.lightSubtitleStyle
                                      .copyWith(color: Color(0xFF1C2127))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Text('Sell',
                              style: isDarkMode
                                  ? TextStyles.darkSubtitleStyle.copyWith(
                                      color: Color(0xFFA7B1BC),
                                    )
                                  : TextStyles.lightSubtitleStyle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0XFF353945)
                        : Color(0xFFCFD3D8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('Limit',
                      style: isDarkMode
                          ? TextStyles.darkBoldStyle
                          : TextStyles.lightBoldStyle),
                ),
                Text('Market',
                    style: isDarkMode
                        ? TextStyles.darkBoldStyle.copyWith(
                            color: Color(0xFFA7B1BC),
                          )
                        : TextStyles.lightBoldStyle.copyWith(
                            color: Color(0xFF737A91),
                          )),
                Text(
                  'Stop Limit',
                  style: isDarkMode
                      ? TextStyles.darkBoldStyle.copyWith(
                          color: Color(0xFFA7B1BC),
                        )
                      : TextStyles.lightBoldStyle.copyWith(
                          color: Color(0xFF737A91),
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            customBar('Limit price', '0.00 USD', isDarkMode),
            const SizedBox(
              height: 20,
            ),
            customBar('Amount', '0.00 USD', isDarkMode),
            const SizedBox(
              height: 20,
            ),
            customBar('Type', 'Good till Cancelled', isDarkMode),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                    width: 20,
                    height: 20,
                  ),
                  child: Checkbox(
                    fillColor:
                        const MaterialStatePropertyAll(Color(0XFF1C2127)),
                    side: const BorderSide(
                      width: 0.5,
                      color: Color(0XFF373B3F),
                    ),
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('Post only',
                    style: isDarkMode
                        ? TextStyles.darkSubtitleStyle.copyWith(
                            color: Color(0xFFA7B1BC),
                          )
                        : TextStyles.lightSubtitleStyle),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.info_outline_rounded,
                  color: isDarkMode ? Color(0xFFA7B1BC) : Color(0xFF737A91),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: isDarkMode
                        ? TextStyles.darkSubtitleStyle.copyWith(
                            color: Color(0xFFA7B1BC),
                          )
                        : TextStyles.lightSubtitleStyle),
                Text('0.00',
                    style: isDarkMode
                        ? TextStyles.darkSubtitleStyle.copyWith(
                            color: Color(0xFFA7B1BC),
                          )
                        : TextStyles.lightSubtitleStyle),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0XFF483BEB),
                    Color(0XFF7847E1),
                    Color(0XFFDD568D),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Buy BTC', style: TextStyles.buttonTextStyle),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 0,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Account Value',
                        style: isDarkMode
                            ? TextStyles.darkSubtitleStyle.copyWith(
                                color: Color(0xFFA7B1BC),
                              )
                            : TextStyles.lightSubtitleStyle),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('0.00',
                        style: isDarkMode
                            ? TextStyles.darkBoldStyle
                            : TextStyles.lightBoldStyle),
                  ],
                ),
                Row(
                  children: [
                    Text('NGN',
                        style: isDarkMode
                            ? TextStyles.darkSubtitleStyle.copyWith(
                                color: Color(0xFFA7B1BC),
                              )
                            : TextStyles.lightSubtitleStyle),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 15,
                      color: isDarkMode ? Color(0xFFA7B1BC) : Color(0xFF737A91),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Open Orders',
                        style: isDarkMode
                            ? TextStyles.darkSubtitleStyle.copyWith(
                                color: Color(0xFFA7B1BC),
                              )
                            : TextStyles.lightSubtitleStyle),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('0.00',
                        style: isDarkMode
                            ? TextStyles.darkBoldStyle
                            : TextStyles.lightBoldStyle),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available',
                        style: isDarkMode
                            ? TextStyles.darkSubtitleStyle.copyWith(
                                color: Color(0xFFA7B1BC),
                              )
                            : TextStyles.lightSubtitleStyle),
                    Text('0.00',
                        style: isDarkMode
                            ? TextStyles.darkBoldStyle
                            : TextStyles.lightBoldStyle),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0XFF2764FF),
              ),
              child: Text('Deposit',
                  style: TextStyles.buttonTextStyle.copyWith(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget customBar(String text1, String text2, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0XFF373B3F),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(text1,
                  style: isDarkMode
                      ? TextStyles.darkSubtitleStyle.copyWith(
                          color: Color(0xFFA7B1BC),
                        )
                      : TextStyles.lightSubtitleStyle),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.info_outline_rounded,
                color: isDarkMode ? Color(0xFFA7B1BC) : Color(0xFF737A91),
                size: 15,
              ),
            ],
          ),
          Text(text2,
              style: isDarkMode
                  ? TextStyles.darkSubtitleStyle.copyWith(
                      color: Color(0xFFA7B1BC),
                    )
                  : TextStyles.lightSubtitleStyle),
        ],
      ),
    );
  }
}
