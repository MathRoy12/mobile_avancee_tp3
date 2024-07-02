class AppTask {
  String id = '';
  int percentageDone = 0;
  DateTime creationDate = DateTime(0);
  DateTime deadline = DateTime(0);
  String name = '';
  String imgURL = '';

  double get percentageTimeSpent {
    Duration totalTime = deadline.difference(creationDate);
    Duration timeSpent = DateTime.now().difference(creationDate);
    double percentageTimeSpent =
        (timeSpent.inMilliseconds * 100 / totalTime.inMilliseconds * 10)
                .round() /
            10;
    return percentageTimeSpent < 100 ? percentageTimeSpent : 100;
  }
}
