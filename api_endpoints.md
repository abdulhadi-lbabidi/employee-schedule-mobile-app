# API Endpoints List

## 1. Authentication & Profile
- `POST`   `/auth/login`
- `POST`   `/auth/logout`
- `GET`    `/profile`
- `PATCH`  `/profile/update`
- `PATCH`  `/profile/fcm-token`

## 2. Attendance (Employee)
- `GET`    `/workshops`
- `POST`   `/attendance/check-in`
- `POST`   `/attendance/check-out`
- `GET`    `/attendance/history`
- `GET`    `/attendance/my-status`

## 3. Admin - Employee Management
- `GET`    `/admin/employees`
- `POST`   `/admin/employees` (إضافة موظف جديد)
- `GET`    `/admin/employees/{id}`
- `PUT`    `/admin/employees/{id}` (تعديل بيانات موظف)
- `DELETE` `/admin/employees/{id}`

## 4. Admin - Workshop Management
- `GET`    `/admin/workshops`
- `POST`   `/admin/workshops` (إضافة ورشة جديدة)
- `PUT`    `/admin/workshops/{id}`
- `DELETE` `/admin/workshops/{id}`

## 5. Admin - Advanced Controls (New POSTs)
- `POST`   `/admin/attendance/manual` (إضافة سجل حضور لموظف يدوياً من قبل الأدمن)
- `POST`   `/admin/notifications/send` (إرسال إشعار يدوي لموظف معين أو للكل)
- `POST`   `/admin/payments/pay` (تسجيل دفعة مالية لموظف)

## 6. Admin - Reports
- `GET`    `/admin/reports/attendance`
- `GET`    `/admin/reports/financial`
- `GET`    `/admin/payments`
