class DateHelper {
  static int getWeekOfMonth(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int firstWeekday = firstDayOfMonth.weekday;
    // Assuming week starts on Sunday (7) or Monday (1)
    // In many Arabic regions, Sunday is the start of the week.
    // However, let's use a simple formula for week of month:
    int dayOfMonth = date.day;
    int weekNum = ((dayOfMonth + firstWeekday - 1) / 7).ceil();
    return weekNum;
  }

  static String getMonthName(int month) {
    const months = [
      "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
      "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
    ];
    return months[month - 1];
  }

  static List<int> getYearsRange() {
    int currentYear = DateTime.now().year;
    return List.generate(5, (index) => currentYear - index);
  }
}
