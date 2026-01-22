import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatters {
  
  // Ex.: "Seg"
  static String dayTextFormat(DateTime date) {
    final day = DateFormat.E('pt_BR').format(date).replaceAll('.', '');
    return day[0].toUpperCase() + day.substring(1);
  }

  // Ex.: "06"
  static String dayFormat(DateTime date) {
    return DateFormat('dd').format(date);
  }

  // Ex.: "6 de out"
  static String dayExtensionFormat(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).toString(); 
  return DateFormat("d 'de' MMM", locale).format(date);
  }

  // Ex.: "6 de outubro"
  static String dayExtensionFullMonthFormat(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).toString(); 
  return DateFormat("d 'de' MMMM", locale).format(date);
  }

  // Ex.: "06/10/2025"
  static String ptDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  // Ex.: "06/10, SEG"
  static String formatarDataComDia(String isoDate) {
    final date = DateTime.parse(isoDate);
    final diaMes = DateFormat('dd/MM').format(date);
    final semana = DateFormat.E('pt_BR').format(date).toUpperCase();
    return '$diaMes, $semana';
  }

  static String fullWeekdayDayMonthYear(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat("EEEE, d 'de' MMMM 'de' y", locale).format(date);
  }

  // Ex.: "segunda-feira, 2 nov"
  static String weekdayDayMonth(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat("EEEE, d MMM", locale).format(date);
  }

  // Ex.: "terça 16 dez"
  static String weekdayDayMonthShort(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formatted = DateFormat("EEEE d MMM", locale).format(date);
    final weekday = formatted.split(' ')[0];
    final shortWeekday = weekday.replaceAll('-feira', '');
    return formatted.replaceFirst(weekday, shortWeekday);
  }

  // Ex.: "12:15"
  static String timeFormat(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Ex.: "há 6 dias"
  static String relativeTimeFormat(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return 'há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'agora';
    }
  }
}
