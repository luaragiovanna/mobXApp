import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:mobx/mobx.dart';
part 'connectivity_store.g.dart';

class ConnectivityStore = _ConnectivityStoreBase with _$ConnectivityStore;

abstract class _ConnectivityStoreBase with Store {
 _ConnectivityStore() {
    _setupListener();
  }

  void _setupListener() {
    DataConnectionChecker().checkInterval = Duration(seconds: 5);
    DataConnectionChecker().onStatusChange.listen((event) {
      setConnected(event == DataConnectionStatus.connected);
    });
  }

  @observable
  bool connected = true;

  @action
  void setConnected(bool value) => connected = value;
}
