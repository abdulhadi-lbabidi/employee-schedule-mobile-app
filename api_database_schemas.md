# توثيق جداول قواعد البيانات (Backend Schemas)
هذا الملف يحتوي على توصيف الجداول المطلوبة لدعم ميزات التطبيق الحالية (Clean Architecture).

---

## 1. جدول الموظفين (Employees)
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `id` | UUID / String | المعرف الفريد للموظف |
| `name` | String | الاسم الكامل |
| `phone_number` | String | رقم الهاتف (اسم المستخدم) |
| `password` | String | كلمة المرور المشفرة |
| `image` | String (URL) | رابط الصورة الشخصية |
| `hourly_rate` | Double | أجر الساعة العادية |
| `overtime_rate` | Double | أجر ساعة الإضافي |
| `workshop_id` | Foreign Key | معرف الورشة الحالية |
| `is_online` | Boolean | حالة التواجد الآن |
| `is_archived` | Boolean | هل الحساب مؤرشف (0 أو 1) |

---

## 2. جدول الورشات (Workshops)
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `id` | UUID / String | معرف الورشة |
| `name` | String | اسم الورشة |
| `latitude` | Double | الإحداثي العرضي للموقع |
| `longitude` | Double | الإحداثي الطولي للموقع |
| `radius` | Double | قطر منطقة التحضير (بالأمتار) |
| `is_archived` | Boolean | حالة الأرشفة |

---

## 3. جدول الحضور والانصراف (Attendance)
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `id` | BigInt | معرف السجل |
| `employee_id` | Foreign Key | معرف الموظف |
| `check_in` | Timestamp | وقت الدخول |
| `check_out` | Timestamp | وقت الخروج |
| `lat_in / long_in` | Double | موقع الموظف عند الدخول |
| `lat_out / long_out`| Double | موقع الموظف عند الخروج |

---

## 4. جدول سجل العمل الأسبوعي (Weekly History)
*يستخدم لحساب المستحقات المالية والفلترة الشهرية.*
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `employee_id` | Foreign Key | معرف الموظف |
| `week_number` | Integer | رقم الأسبوع في السنة |
| `month` | Integer | الشهر (1 - 12) |
| `year` | Integer | السنة |
| `total_regular_hours`| Double | مجموع الساعات النظامية |
| `total_overtime_hours`| Double | مجموع الساعات الإضافية |
| `amount_paid` | Double | المبالغ المدفوعة لهذا الأسبوع |
| `is_paid` | Boolean | هل تم دفع كامل المستحقات |

---

## 5. جدول السلف (Loans)
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `id` | UUID | معرف السلفة |
| `employee_id` | Foreign Key | معرف الموظف |
| `amount` | Double | القيمة الإجمالية للسلفة |
| `paid_amount` | Double | المبلغ المسدد حتى الآن |
| `status` | Enum | (pending, partially_paid, fully_paid) |
| `created_at` | Timestamp | تاريخ الطلب |

---

## 6. جدول المكافآت (Rewards)
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `id` | UUID | معرف المكافأة |
| `employee_id` | Foreign Key | الموظف المستلم |
| `admin_id` | Foreign Key | المدير المانح |
| `amount` | Double | قيمة المكافأة |
| `reason` | Text | سبب المنح |
| `date_issued` | Timestamp | تاريخ الصرف |

---

## 7. جدول الإشعارات (Notifications)
| الحقل | النوع | الوصف |
| :--- | :--- | :--- |
| `id` | UUID | معرف الإشعار |
| `title` | String | العنوان |
| `body` | Text | نص الرسالة |
| `type` | String | (admin_broadcast, private, workshop) |
| `target_id` | String | معرف (موظف أو ورشة) |
| `is_read` | Boolean | حالة القراءة |

---

### ملاحظات تقنية لمطور الباك اند:
1. يرجى توفير فلترة في روابط (GET) لسجل العمل الأسبوعي بناءً على `month` و `year`.
2. استخدام نظام الـ API الموحد (JSON) بحيث يحتوي الرد دائماً على حقل `data` للنتائج و `message` للتوضيح.
