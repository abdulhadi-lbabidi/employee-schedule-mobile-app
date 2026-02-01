# Database Tables Structure

## 1. Users Table (Admin & Employee)
- `id`: (Primary Key)
- `full_name`: String
- `email`: String (Required for Admin)
- `phone_number`: String (Unique - Used for Login)
- `password`: String (Hashed)
- `role`: Enum (admin, employee)
- `profile_image_url`: String (Nullable)
- `position`: String (e.g., Accountant, Manager)
- `department`: String
- `hourly_rate`: Double (For Employees)
- `overtime_rate`: Double (For Employees)
- `fcm_token`: String (For Notifications)
- `is_online`: Boolean
- `current_location`: String (Last known location)

## 2. Workshops Table
- `id`: (Primary Key)
- `name`: String
- `location`: String
- `description`: Text

## 3. Attendance Table
- `id`: (Primary Key)
- `user_id`: (Foreign Key -> Users)
- `workshop_id`: (Foreign Key -> Workshops)
- `date`: Date
- `check_in`: Timestamp
- `check_out`: Timestamp
- `week_number`: Integer
- `note`: Text
- `regular_hours`: Double
- `overtime_hours`: Double

## 4. Payments Table
- `id`: (Primary Key)
- `user_id`: (Foreign Key -> Users)
- `week_number`: Integer
- `total_amount`: Double
- `amount_paid`: Double
- `is_paid`: Boolean
- `payment_date`: Timestamp
