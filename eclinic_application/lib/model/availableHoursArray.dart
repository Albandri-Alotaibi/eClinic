class availableHoursArray {
  final String title;
  List hours;
  String allhours;

  availableHoursArray({
    required this.title,
    required this.hours,
    this.allhours = "",
  });

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   String srting = "";
  //   for (int i = 0; i < hours.length; i++)
  //     String srting =
  //         "\n" + "start: ${hours[i]['starttime']} - end ${hours[i]['endtime']}";
  //   return srting;
  // }
}
