import '../model/alert_model.dart';
import '../repository/alert_repository.dart';

class AlertController {
  final AlertRepository _repository = AlertRepository();

  List<AlertModel> getRecentAlerts() {
    return _repository.fetchRecentAlerts();
  }

  List<AlertModel> getEarlierAlerts() {
    return _repository.fetchEarlierAlerts();
  }
}