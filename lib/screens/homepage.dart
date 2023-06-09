import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/candle.dart';
import '../models/candleTicker_model.dart';
import '../models/indicator.dart';
import '../models/order_book.dart';
import '../services/websocket_services.dart';
import '../utils/indicators/bollinger_bands_indicator.dart';
import '../utils/indicators/weighted_moving_average.dart';
import '../utils/styles.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/bottom_section.dart';
import '../widgets/candle_sticks_chart.dart';
import '../widgets/toolbar_action.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum TabSelection { charts, orderBook, recentTrades }

class _HomePageState extends State<HomePage> {
  BinanceRepository repository = BinanceRepository();

  TabSelection selectedTab = TabSelection.charts;

  void updateTabSelection(TabSelection newSelection) {
    setState(() {
      selectedTab = newSelection;
    });
  }

  List<Candle> candles = [];
  WebSocketChannel? _channel;
  bool themeIsDark = true;
  OrderBookModel? orderBookData;
  String currentInterval = "1d";
  final intervals = [
    '1m',
    '3m',
    '5m',
    '15m',
    '30m',
    '1h',
    '2h',
    '4h',
    '6h',
    '8h',
    '12h',
    '1d',
    '3d',
    '1w',
    '1M',
  ];
  List<String> symbols = [];
  String currentSymbol = "";

  List<Indicator> indicators = [
    BollingerBandsIndicator(
      length: 20,
      stdDev: 2,
      upperColor: const Color(0xFF2962FF),
      basisColor: const Color(0xFFFF6D00),
      lowerColor: const Color(0xFF2962FF),
    ),
    WeightedMovingAverageIndicator(
      length: 100,
      color: Colors.green.shade600,
    ),
  ];
  @override
  void dispose() {
    if (_channel != null) _channel!.sink.close();
    super.dispose();
  }

  void updateOrderBook(Map<String, dynamic> map) {
    setState(() {
      orderBookData = OrderBookModel.fromJson(map);
    });
  }

  Future<void> fetchCandles(String symbol, String interval) async {
    // close current channel if exists
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    // clear last candle list
    setState(() {
      candles = [];
      currentInterval = interval;
    });

    try {
      // load candles info
      final data =
          await repository.fetchCandles(symbol: symbol, interval: interval);
      // connect to binance stream
      _channel =
          repository.establishConnection(symbol.toLowerCase(), currentInterval);
      // update candles
      setState(() {
        candles = data;
        currentInterval = interval;
        currentSymbol = symbol;
      });
    } catch (e) {
      // handle error
      return;
    }
  }

  Future<List<String>> fetchSymbols() async {
    try {
      // load candles info
      final data = await repository.fetchSymbols();
      // print(data);
      return data;
    } catch (e) {
      // handle error
      return [];
    }
  }

  @override
  void initState() {
    print("init");
    fetchSymbols().then((value) {
      symbols = value;
      if (symbols.isNotEmpty) fetchCandles(symbols[0], currentInterval);
    });
    super.initState();
  }

  Future<void> loadMoreCandles() async {
    try {
      // load candles info
      final data = await repository.fetchCandles(
          symbol: currentSymbol,
          interval: currentInterval,
          endTime: candles.last.date.millisecondsSinceEpoch);
      candles.removeLast();
      setState(() {
        candles.addAll(data);
      });
    } catch (e) {
      // handle error
      return;
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<Object?> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k") == true) {
        final candleTicker = CandleTickerModel.fromJson(map);

        // cehck if incoming candle is an update on current last candle, or a new one
        if (candles[0].date == candleTicker.candle.date &&
            candles[0].open == candleTicker.candle.open) {
          // update last candle
          candles[0] = candleTicker.candle;
        }
        // check if incoming new candle is next candle so the difrence
        // between times must be the same as last existing 2 candles
        else if (candleTicker.candle.date.difference(candles[0].date) ==
            candles[0].date.difference(candles[1].date)) {
          // add new candle to list
          candles.insert(0, candleTicker.candle);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: MyAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: _channel == null ? null : _channel!.stream,
                    builder: (context, snapshot) {
                      updateCandlesFromSnapshot(snapshot);
                      return Container(
                        // height: MediaQuery.of(context).size.height,
                        color:
                            isDarkMode ? Color(0xFF262932) : Color(0xFFF1F1F1),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 130,
                                width: width,
                                color: Theme.of(context).backgroundColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/Group 237550.png",
                                          fit: BoxFit.contain,
                                          width: 48,
                                          height: 48,
                                        ),
                                        if (!snapshot.hasData)
                                          const Text(
                                            'Loading... ',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        if (snapshot.hasData)
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return SymbolsSearchModal(
                                                    onSelect: (symbol) {
                                                      setState(() {
                                                        currentSymbol = symbol;
                                                        fetchCandles(symbol,
                                                            currentInterval);
                                                      });
                                                    },
                                                    symbols: symbols,
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  currentSymbol,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Image.asset(
                                                  "assets/Vector.png",
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(width: 20),
                                        Text(
                                          "\$${candles.isNotEmpty ? candles.last.close.toStringAsFixed(2) : "0.00"}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: candles.isNotEmpty
                                                ? candles.last.close >
                                                        candles[candles.length -
                                                                2]
                                                            .close
                                                    ? Color(0xFF00C076)
                                                    : Colors.red
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Satoshi',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/Line.svg',
                                                  width: 18,
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "24h change",
                                                  style: isDarkMode
                                                      ? TextStyles
                                                          .darkSubtitleStyle
                                                      : TextStyles
                                                          .lightSubtitleStyle,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${candles.isNotEmpty ? candles.last.close.toStringAsFixed(2) : "0.00"} ${candles.isNotEmpty ? (candles.last.close - candles.last.open).toStringAsFixed(2) : "0.00"}%",
                                              style: isDarkMode
                                                  ? TextStyles.darkMiddleStyle
                                                      .copyWith(
                                                          color: candles
                                                                  .isNotEmpty
                                                              ? candles.last
                                                                          .close >
                                                                      candles[candles.length -
                                                                              2]
                                                                          .close
                                                                  ? Color(
                                                                      0xFF00C076)
                                                                  : Colors.red
                                                              : Colors.grey)
                                                  : TextStyles.lightMiddleStyle
                                                      .copyWith(
                                                          color: candles
                                                                  .isNotEmpty
                                                              ? candles.last
                                                                          .close >
                                                                      candles[candles.length -
                                                                              2]
                                                                          .close
                                                                  ? Color(
                                                                      0xFF00C076)
                                                                  : Colors.red
                                                              : Colors.grey),
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: 1,
                                          color: const Color(0XFFE0FAFE),
                                          height: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.arrow_upward,
                                                  color: Color(0XFFA7B1BC),
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '24h High',
                                                  style: isDarkMode
                                                      ? TextStyles
                                                          .darkSubtitleStyle
                                                      : TextStyles
                                                          .lightSubtitleStyle,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              candles.isNotEmpty
                                                  ? candles.last.high
                                                      .toStringAsFixed(2)
                                                  : "0.00",
                                              style: isDarkMode
                                                  ? TextStyles.darkMiddleStyle
                                                  : TextStyles.lightMiddleStyle,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 1,
                                          color: const Color(0XFFE0FAFE),
                                          height: 30,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.arrow_downward,
                                                  color: Color(0XFFA7B1BC),
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '24h Low',
                                                  style: isDarkMode
                                                      ? TextStyles
                                                          .darkSubtitleStyle
                                                      : TextStyles
                                                          .lightSubtitleStyle,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              candles.isNotEmpty
                                                  ? candles.last.low
                                                      .toStringAsFixed(2)
                                                  : "0.00",
                                              style: isDarkMode
                                                  ? TextStyles.darkMiddleStyle
                                                  : TextStyles.lightMiddleStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: width,
                              color: Theme.of(context).backgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 6),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? const Color(0XFF1C2127)
                                          : Color(0XFFF1F1F1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isDarkMode
                                            ? const Color(0XFF262932)
                                            : Color(0XFFF1F1F1),
                                      )),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          updateTabSelection(
                                              TabSelection.charts);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedTab ==
                                                    TabSelection.charts
                                                ? (isDarkMode
                                                    ? const Color(0XFFE9F0FF)
                                                        .withOpacity(0.05)
                                                    : Colors.white)
                                                : Colors.transparent,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Text(
                                            'Charts',
                                            style: isDarkMode
                                                ? TextStyles.darkMiddleStyle
                                                : TextStyles.lightMiddleStyle,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          updateTabSelection(
                                              TabSelection.orderBook);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedTab ==
                                                    TabSelection.orderBook
                                                ? (isDarkMode
                                                    ? const Color(0XFFE9F0FF)
                                                        .withOpacity(0.05)
                                                    : Colors.white)
                                                : Colors.transparent,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Text(
                                            'Order Book',
                                            style: isDarkMode
                                                ? TextStyles.darkMiddleStyle
                                                : TextStyles.lightMiddleStyle,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          updateTabSelection(
                                              TabSelection.recentTrades);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedTab ==
                                                    TabSelection.recentTrades
                                                ? (isDarkMode
                                                    ? const Color(0XFFE9F0FF)
                                                        .withOpacity(0.05)
                                                    : Colors.white)
                                                : Colors.transparent,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: Text(
                                            'Recent Trades',
                                            style: isDarkMode
                                                ? TextStyles.darkMiddleStyle
                                                : TextStyles.lightMiddleStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            toggle(selectedTab, MediaQuery.of(context).size),
                            //tab 1

                            CustomBottomSection()
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: double.infinity,
              child: Row(children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) {
                          return SizedBox(
                              height: height * 0.75,
                              child: const BuySellBottomModal());
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0XFF25C26E),
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text('Buy', style: TextStyles.buttonTextStyle),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) {
                          return SizedBox(
                              height: height * 0.75,
                              child: const BuySellBottomModal());
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0XFFFF554A),
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text('Sell', style: TextStyles.buttonTextStyle),
                    ),
                  ),
                )),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget toggle(TabSelection selection, Size size) {
    if (selection == TabSelection.charts) {
      return Container(
        height: size.height / 1.7,
        width: size.width,
        color: Theme.of(context).backgroundColor,
        child: Candlesticks(
          key: Key(currentSymbol + currentInterval),
          indicators: indicators,
          candles: candles,
          onLoadMoreCandles: loadMoreCandles,
          onRemoveIndicator: (String indicator) {
            setState(() {
              indicators = [...indicators];
              indicators.removeWhere((element) => element.name == indicator);
            });
          },
          actions: [
            ToolBarAction(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        width: 200,
                        color: Theme.of(context).backgroundColor,
                        child: Wrap(
                          children: intervals
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 50,
                                      height: 30,
                                      child: RawMaterialButton(
                                        elevation: 0,
                                        fillColor: const Color(0xFF494537),
                                        onPressed: () {
                                          fetchCandles(currentSymbol, e);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                            color: Color(0xFFF0B90A),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                currentInterval,
              ),
            ),
            ToolBarAction(
              width: 100,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SymbolsSearchModal(
                      symbols: symbols,
                      onSelect: (value) {
                        fetchCandles(value, currentInterval);
                      },
                    );
                  },
                );
              },
              child: Text(
                currentSymbol,
              ),
            )
          ],
        ),
      );
    } else if (selection == TabSelection.orderBook) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: size.height * 0.4,
          child: Center(
            child: Text(
              'Order books',
            ),
          ),
        ),
      );
    } else if (selection == TabSelection.recentTrades) {
      return SizedBox(
        height: size.height * 0.4,
        child: Center(
          child: Text(
            'No Recent Trades',
          ),
        ),
      );
    }

    // Return a default widget or null if needed
    return Container();
  }
}

class SymbolsSearchModal extends StatefulWidget {
  final Function(String symbol) onSelect;

  final List<String> symbols;
  const SymbolsSearchModal({
    Key? key,
    required this.onSelect,
    required this.symbols,
  }) : super(key: key);

  @override
  State<SymbolsSearchModal> createState() => _SymbolSearchModalState();
}

class _SymbolSearchModalState extends State<SymbolsSearchModal> {
  String symbolSearch = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height * 0.75,
          color: Theme.of(context).backgroundColor.withOpacity(0.5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  onChanged: (value) {
                    setState(() {
                      symbolSearch = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: widget.symbols
                      .where((element) => element
                          .toLowerCase()
                          .contains(symbolSearch.toLowerCase()))
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 50,
                              height: 30,
                              child: RawMaterialButton(
                                elevation: 0,
                                fillColor: const Color(0xFF494537),
                                onPressed: () {
                                  widget.onSelect(e);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    color: Color(0xFFF0B90A),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget orderBook() {
  OrderBookModel? orderBookData;
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              multiColorTile(const Color(0XFF353945)),
              const SizedBox(
                width: 5,
              ),
              multiColorTile(Colors.transparent),
              const SizedBox(
                width: 5,
              ),
              multiColorTile(Colors.transparent)
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0XFF353945),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Text(
                  '10',
                  // style: AppStyles.boldText.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0XFF777190),
                )
              ],
            ),
          )
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
              Text(
                'Price',
                // style: AppStyles.boldText
                //     .copyWith(color: const Color(0XFFA7B1BC), fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'USDT',
                // style: AppStyles.boldText
                //     .copyWith(color: const Color(0XFFA7B1BC), fontSize: 12),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amounts',
                // style: AppStyles.boldText
                //     .copyWith(color: const Color(0XFFA7B1BC), fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'BTC',
                // style: AppStyles.boldText
                //     .copyWith(color: const Color(0XFFA7B1BC), fontSize: 12),
              )
            ],
          ),
          Text(
            'Total',
            // style: AppStyles.boldText
            //     .copyWith(color: const Color(0XFFA7B1BC), fontSize: 12),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Column(
        children: List.generate(
            orderBookData!.asks!.length > 5 ? 5 : orderBookData.asks!.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        double.parse(orderBookData.asks![index]![0]!.toString())
                            .toInt()
                            .toString(),
                        // style: AppStyles.boldText
                        //     .copyWith(color: const Color(0XFFFF6838)),
                      ),
                      Text(
                        double.parse(orderBookData.asks![index]![1]!.toString())
                            .toStringAsFixed(3),
                        // style: AppStyles.boldText.copyWith(color: Colors.white),
                      ),
                      Text(
                        '367829',
                        // style:
                        // AppStyles.boldText.copyWith(color: Colors.white)
                      ),
                    ],
                  ),
                )),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '36,641',
            // style: AppStyles.boldText.copyWith(color: const Color(0XFF25C26E)),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.arrow_upward,
            color: Color(0XFF25C26E),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '36,641',
            // style: AppStyles.boldText.copyWith(color: Colors.white),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Column(
        children: List.generate(
            orderBookData.asks!.length > 5 ? 5 : orderBookData.asks!.length,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        double.parse(orderBookData.asks![index]![0]!.toString())
                            .toInt()
                            .toString(),
                        // style: AppStyles.boldText
                        //     .copyWith(color: const Color(0XFFFF6838)),
                      ),
                      Text(
                        double.parse(orderBookData.asks![index]![1]!.toString())
                            .toStringAsFixed(3),
                        // style: AppStyles.boldText.copyWith(color: Colors.white),
                      ),
                      Text(
                        '367829',
                        // style:
                        // AppStyles.boldText.copyWith(color: Colors.white)
                      ),
                    ],
                  ),
                )),
      ),
    ],
  );
}

Widget multiColorTile(Color bg) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: bg,
    ),
    width: 25,
    height: 25,
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        width: 15,
        height: 2,
        decoration: const BoxDecoration(color: Color(0XFFFF3868)),
      ),
      Container(
        width: 15,
        height: 2,
        decoration: const BoxDecoration(color: Color(0XFFB1B5C3)),
      ),
      Container(
        width: 15,
        height: 2,
        decoration: const BoxDecoration(color: Color(0XFF25C26E)),
      ),
    ]),
  );
}

class CustomTextField extends StatelessWidget {
  final void Function(String) onChanged;
  const CustomTextField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      cursorColor: const Color(0xFF494537),
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Color(0xFF494537),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color(0xFF494537)), //<-- SEE HER
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color(0xFF494537)), //<-- SEE HER
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 3, color: Color(0xFF494537)), //<-- SEE HER
        ),
      ),
      onChanged: onChanged,
    );
  }
}
