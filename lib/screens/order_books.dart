import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrderbookPage extends StatefulWidget {
  @override
  _OrderbookPageState createState() => _OrderbookPageState();
}

class _OrderbookPageState extends State<OrderbookPage> {
  late WebSocketChannel channel;
  List<dynamic> bids = [];
  List<dynamic> asks = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws/bnbusdt@depth');
    channel.stream.listen((message) {
      setState(() {
        final data = orderBookDataFromJson(message);
        bids = data.bids;
        asks = data.asks;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binance Orderbook'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                return ListTile(
                  title: Text('Price: ${bid[0]}'),
                  subtitle: Text('Quantity: ${bid[1]}'),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: asks.length,
              itemBuilder: (context, index) {
                final ask = asks[index];
                return ListTile(
                  title: Text('Price: ${ask[0]}'),
                  subtitle: Text('Quantity: ${ask[1]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderBookData {
  List<List<dynamic>> bids;
  List<List<dynamic>> asks;

  OrderBookData({
    required this.bids,
    required this.asks,
  });
}

OrderBookData orderBookDataFromJson(String str) {
  final data = json.decode(str);
  return OrderBookData(
    bids: List<List<dynamic>>.from(data['bids'].map((x) => List<dynamic>.from(x))),
    asks: List<List<dynamic>>.from(data['asks'].map((x) => List<dynamic>.from(x))),
  );
}