import 'dart:async';

import 'package:crypto_currencies_list_app/features/crypto_list/bloc/crypto_list_bloc.dart';
import 'package:crypto_currencies_list_app/features/crypto_list/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/crypto_coins/crypto_coins.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final _cryptoListBloc = CryptoListBloc(GetIt.I<AbstractCoinsRepository>());

  @override
  void initState() {
    _cryptoListBloc.add(LoadCryptoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CryptoCurrenciesList'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5.0),
            child: Container(
              height: 2.0,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final completer = Completer();
            _cryptoListBloc.add(LoadCryptoList(completer: completer));
            return completer.future;
          },
          child: BlocBuilder<CryptoListBloc, CryptoListState>(
            bloc: _cryptoListBloc,
            builder: (context, state) {
              if (state is CryptoListLoaded) {
                return ListView.separated(
                  itemCount: state.coinsList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, i) {
                    final coin = state.coinsList[i];
                    return CryptoCoinTile(coin: coin);
                  },
                );
              }
              if (state is CryptoListLoadingFailure) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Text(
                        'Something went wrong',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color:
                                  Theme.of(context).textTheme.labelSmall?.color,
                            ),
                      ),
                      Text('Please try again later',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 16)),
                      SizedBox(height: 30),
                      TextButton(
                          onPressed: () {
                            _cryptoListBloc.add(LoadCryptoList());
                          },
                          child: Text('Try again'))
                    ]));
              }
              return const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ));
            },
          ),
      ));
  }
}
