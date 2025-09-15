# IFEO Tool

כלי פשוט לניהול Image File Execution Options (IFEO) ב-Windows.  
הכלי מאפשר חסימה וביטול של קבצי EXE דרך הוספה או מחיקה של ערך Debugger ברגיסטרי, הצגת הקבצים החסומים, וסגירה עם ספירה לאחור.

---

## תכונות

- חסימת קבצי EXE  
  מוסיף ערך Debugger = debugger.exe תחת המפתח:  
  `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\<filename.exe>`  
  → מונע הרצת הקובץ.

- הצגת קבצים חסומים בפועל  
  מציג רק קבצי EXE שמכילים את ערך ה-Debugger (כלומר, באמת חסומים).

- ביטול חסימה  
  מסיר את ערך ה-Debugger או את מפתח הרגיסטרי אם נדרש.

- הרצת מנהל באופן אוטומטי  
  הסקריפט עולה מחדש בהרשאות מנהל אם הוא לא רץ כמנהל.

- יציאה עם ספירה לאחור  
  בהפסקת התוכנית, הסקריפט מציג ספירה לאחור של 5 שניות לפני סגירה אוטומטית.

---

## שימוש

1. הורד או שכפל את הריפוזיטורי.  
2. הרץ את `IFEO_Tool.cmd` כמנהל.  
3. בחר מתוך התפריט:

Block EXE file(s)

List actually blocked EXE files (with Debugger)

Unblock EXE file(s)

Exit



1. עקוב אחרי ההנחיות להזנת שמות הקבצים (עם או בלי .exe).

---

## דוגמאות

**חסימת מספר קבצים:**

Enter EXE filenames to block (comma separated, with or without .exe): notepad.exe, calc



**הצגת קבצים חסומים:**

Currently blocked EXE files (with Debugger):
notepad.exe
calc.exe



**ביטול חסימה:**

Enter EXE filenames to unblock (comma separated, with or without .exe): notepad.exe
SUCCESS: Block removed for notepad.exe



---

## הערות

- נבדק על Windows 10 / 11.  
- עובד רק עבור EXE files.  
- יש להריץ בהרשאות Administrator.  
- הכלי משנה ערכי רגיסטרי – יש להשתמש בזהירות.

---

## רישיון

MIT License

---

## הסבר

כלי זה נועד למטרות לימודיות ומנהליות בלבד. המחבר אינו אחראי על שימוש לרעה או נזק כתוצאה משינויי רגיסטרי.
