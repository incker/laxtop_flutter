import 'package:flutter/material.dart';

class ReorderHintScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подсказка'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  Text('Вы можете изментять порядок поставщиков на ваш вкус',
                      style: const TextStyle(fontSize: 20.0)),
                  Text(
                      'Для этого удерживайте любого посавщика пока он не отделится от списка. И перетащите туда где вам его будет проще находить'),
                  Padding(
                    padding: EdgeInsets.all(60.0),
                    child: const Image(
                        image: AssetImage('assets/reorder_hint.gif')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
