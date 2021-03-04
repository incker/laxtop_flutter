import 'package:laxtop/init/InitApiToken.dart';
import 'package:laxtop/init/InitBasicData.dart';
import 'package:laxtop/init/InitCheckVersion.dart';
import 'package:laxtop/init/InitFirebase.dart';
import 'package:laxtop/init/InitHive.dart';
import 'package:laxtop/init/InitPromoDir.dart';
import 'package:laxtop/init/InitSpotBox.dart';

abstract class SystemInit {
  static List<ProcessInit> initList() => [
        InitFirebase(),
        InitHive(),
        InitSpotBox(),
        InitBasicData(),
        InitCheckVersion(),
        InitApiToken(),
        InitPromoDir(),
      ];

  static Future<void> initAll() async {
    final Map<Type, Future<void>> processList = {};
    List<ProcessInit> list = SystemInit.initList();
    List<ProcessInit> nextLoopList = [];

    while (list.isNotEmpty) {
      for (ProcessInit process in list) {
        final List<Type> after = process.after();
        if (after.isEmpty) {
          processList[process.runtimeType] = process.init();
        } else {
          bool depLoaded =
              after.indexWhere((Type type) => !processList.containsKey(type)) ==
                  -1;
          if (depLoaded) {
            final Iterator<Type> depIterator = after.iterator;
            depIterator.moveNext();
            Future<void> future = processList[depIterator.current]!;
            while (depIterator.moveNext()) {
              future = _futureWait([future, processList[depIterator.current]!]);
            }
            processList[process.runtimeType] = _pushProcess(future, process);
          } else {
            nextLoopList.add(process);
          }
        }
      }

      if (nextLoopList.length == list.length) {
        throw nextLoopList.map<String>((ProcessInit systemInit) {
          return "${systemInit.runtimeType} depend on " +
              systemInit
                  .after()
                  .where((Type type) => !processList.containsKey(type))
                  .map<String>((Type type) => type.toString())
                  .join(', ') +
              ' which was not satisfied';
        }).join('\n');
      } else {
        list = nextLoopList;
        nextLoopList = [];
      }
    }
    await _futureWait(processList.values);
  }

  static Future<void> _pushProcess(
      Future<void> future, ProcessInit process) async {
    await future;
    await process.init();
  }

  static Future<void> _futureWait(Iterable<Future<void>> futures) async {
    for (Future<void> future in futures) {
      await future;
    }
  }
}

abstract class ProcessInit {
  List<Type> after();

  Future<void> init() async {}
}
