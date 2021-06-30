import 'package:auditplusmobile/providers/qsearch_provider.dart';
import 'package:auditplusmobile/widgets/shared/show_data_empty_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './../../../../../../constants.dart' as constants;

class SaleItemBatchDetail extends StatefulWidget {
  @override
  _SaleItemBatchDetailState createState() => _SaleItemBatchDetailState();
}

class _SaleItemBatchDetailState extends State<SaleItemBatchDetail> {
  QSearchProvider _qSearchProvider;
  Map arguments = {};
  List _inventoryBatches = [];
  bool _isLoading = true;
  List _selectedInventoryBatches = [];

  @override
  void didChangeDependencies() {
    _qSearchProvider = Provider.of<QSearchProvider>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    _getInventoryInfo();
    super.didChangeDependencies();
  }

  Future<void> _getInventoryInfo() async {
    final data = await _qSearchProvider.getInventoryInfo(
      arguments['inventoryId'],
      arguments['branch']['id'],
    );
    setState(() {
      _isLoading = false;
      _inventoryBatches = data['batches'];
    });
  }

  Widget _inventoryBatchDetailHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 0.0,
      ),
      child: Table(
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'BATCH NO',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  'EXPIRY',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Text(
                  'MRP',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  'STOCK',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inventoryBatchDetail() {
    return Expanded(
      child: Container(
        child: _inventoryBatches.isEmpty
            ? ShowDataEmptyImage()
            : ListView.builder(
                itemCount: _inventoryBatches.length,
                itemBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 0.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.all(0),
                          value: _selectedInventoryBatches
                              .where((element) =>
                                  element == _inventoryBatches[index])
                              .isNotEmpty,
                          onChanged: (val) {
                            setState(() {
                              if (val) {
                                _selectedInventoryBatches
                                    .add(_inventoryBatches[index]);
                              } else {
                                _selectedInventoryBatches
                                    .remove(_inventoryBatches[index]);
                              }
                            });
                          },
                          title: Table(
                            children: [
                              TableRow(
                                children: [
                                  Text(
                                    _inventoryBatches[index]['batchNo'] == null
                                        ? ''
                                        : _inventoryBatches[index]['batchNo'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                  Text(
                                    _inventoryBatches[index]['expiry'] == null
                                        ? ''
                                        : constants.defaultDate.format(
                                            DateTime.parse(
                                              _inventoryBatches[index]
                                                  ['expiry'],
                                            ),
                                          ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                  Text(
                                    double.parse(_inventoryBatches[index]['mrp']
                                            .toString())
                                        .toStringAsFixed(2),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                          letterSpacing: 0.5,
                                        ),
                                    textAlign: TextAlign.end,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      _inventoryBatches[index]['closing']
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                            letterSpacing: 0.5,
                                            fontSize: 14.0,
                                          ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.75,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Batches',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(
                _selectedInventoryBatches,
              );
              print(_selectedInventoryBatches);
            },
            child: Text(
              'ADD',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      arguments['inventoryName'].toUpperCase(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  _inventoryBatchDetailHeader(),
                  Divider(
                    thickness: 1.0,
                  ),
                  _inventoryBatchDetail(),
                ],
              ),
      ),
    );
  }
}
