class DateCalculate {
  final DateTime now;

  DateCalculate(this.now);

  // List of reference times
  List<String> referenceTimes = ['0200', '0500', '0800', '1100', '1400', '1700', '2000', '2300'];

  // Method to get the closest time, with 30-minute previous time consideration
  String getClosestTime() {
    String closestTime = referenceTimes.reduce((a, b) {
      int timeDiff(String time) {
        DateTime parsedTime = DateTime(now.year, now.month, now.day,
            int.parse(time.substring(0, 2)), int.parse(time.substring(2, 4)));
        return (parsedTime.difference(now).inMinutes).abs();
      }

      int diffA = timeDiff(a);
      int diffB = timeDiff(b);

      return diffA < diffB ? a : b;
    });

    DateTime closestDateTime = DateTime(now.year, now.month, now.day,
        int.parse(closestTime.substring(0, 2)), int.parse(closestTime.substring(2, 4)));

    int diffMinutes = closestDateTime.difference(now).inMinutes;

    if (diffMinutes > -30) {
      int currentIndex = referenceTimes.indexOf(closestTime);
      int previousIndex = (currentIndex - 1) % referenceTimes.length;
      return referenceTimes[previousIndex];
    }

    return closestTime;
  }


  String getFormattedDate() {
    String closestTime = getClosestTime();
    int closestTimeIndex = referenceTimes.indexOf(closestTime);
    DateTime closestDateTime = DateTime(now.year, now.month, now.day,
        int.parse(closestTime.substring(0, 2)), int.parse(closestTime.substring(2, 4)));
    DateTime forecastDate = now;

    if (now.hour < 2 || (now.hour == 2 && now.minute < 30)) {
      forecastDate = now.subtract(Duration(days: 1));
    }


    if (now.isBefore(closestDateTime.subtract(Duration(minutes: 30)))) {
      if (closestTimeIndex == 0) {
        closestTime = '2300';
        forecastDate = now.subtract(Duration(days: 1));
      } else {
        closestTime = referenceTimes[closestTimeIndex - 1];
      }
    }

    return '${forecastDate.year}${forecastDate.month.toString().padLeft(2, '0')}${forecastDate.day.toString().padLeft(2, '0')}';
  }

}

