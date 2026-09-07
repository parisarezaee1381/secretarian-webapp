📱 Fakour Secretariat System

A desktop document and correspondence management application built with Flutter and Dart, designed to digitize and simplify the process of registering, organizing, and retrieving official documents and letters.

The application was designed in Figma and developed from scratch using Flutter, with a focus on usability, fast document retrieval, responsive UI, and local data storage.

 Key Features
 Register and manage official documents and letters
 Automatic document numbering
 Advanced search and filtering
 Categorize documents by subject
 Attach files to documents
 Select and save files locally
 Scan documents directly from a connected scanner
 Follow-up reminders and notifications
 Edit and delete registered documents
 User registration and authentication
 Account and password management
 Fully offline operation
 Local database using Isar
 Windows desktop application
 UI/UX Design

The application interface was designed in Figma before development.

The design process included:

User flow design
Wireframing
UI design
Prototyping
Responsive layouts
Typography and visual hierarchy
Form and interaction design

The goal was to create a simple workflow that allows users to register and retrieve documents quickly without unnecessary steps.

 Technologies & Skills
Flutter
Dart
Figma
Isar Database
Windows Desktop Development
Responsive UI
UI/UX Design
Wireframing
Prototyping
User Flow Design
 Development

This project was developed from scratch, starting with the UI/UX design and continuing through implementation and database integration.

Development process:

Defined the application's workflow and requirements
Designed user flows and wireframes
Created the UI/UX design in Figma
Implemented the interface using Flutter
Integrated the Isar local database
Implemented document registration and search functionality
Added file attachment and local file management
Implemented authentication and account management
Tested the application on Windows
 Offline & Local Storage

The application is designed to work completely offline.

Document data is stored locally on the user's computer using Isar, and the application does not require an internet connection for its core functionality.

This approach is particularly suitable for environments where document data needs to remain on the local system.

 Fast Document Retrieval

One of the main goals of the application is to make previously registered documents easy to find.

Users can search and filter the document list using relevant information, significantly reducing the time required to locate a specific document.

 System Requirements
Operating System
Windows 10 (version 1809 or later), 64-bit
Windows 11, 64-bit
Recommended Hardware
Intel Core i3 / AMD Ryzen 3 or higher
4 GB RAM minimum
8 GB RAM recommended
At least 1.5 GB available storage
Display resolution of 1366×768 or higher
Additional Software
Microsoft Visual C++ Redistributable 2015–2022
.NET Framework 4.8
 Screenshots & Demo

Screenshots and demonstration materials can be added here.

The application interface was designed in Figma and implemented in Flutter from scratch.

 Project Type

Desktop Application | Flutter | UI/UX Design | Local Database

This project demonstrates the complete workflow from UI/UX design to Flutter development and local database integration.

Application Pages & User Guide
1. Registration Page

The registration page allows a new user to create an account.

The user is required to enter:

Full name
Password
Password confirmation
Favorite color

All fields are required, and the registration button remains disabled until all required fields are completed.

2. Login Page

The login page allows users to access the application using their account credentials.

The user enters their username and password and clicks the Login button.

If the entered credentials are incorrect, an error message is displayed.

The page also provides access to the password recovery process.

3. Password Recovery Page

The password recovery page allows users to recover access to their account if they forget their password.

The user enters their previously selected favorite color and confirms the information.

If the information is correct, the user can proceed with account recovery.

4. Main Dashboard

The main dashboard provides quick access to the application's most frequently used features.

From the dashboard, users can:

Register a new document
View the five most recently registered documents
Edit or delete recent documents
Open the complete document list
Access application settings

The dashboard is designed to provide a clear overview of the user's documents and quick access to essential actions.

5. Settings & Password Management

The settings section allows users to manage their account information.

Users can:

Change their username
Change their password
Update their favorite color
6. Document List

The document list page displays all registered documents in one place.

Users can search, filter, and browse their documents to quickly find a specific record.

The search and filtering functionality is designed to make document retrieval faster and more convenient, especially when working with a large number of records.

7. New Document Registration

The new document registration page allows users to register a new document or letter in the system.

Basic Document Information

Users can enter information such as:

Document title
Document number
Date
Sender
Recipient
Subject
Other relevant document information

Fields marked with an asterisk (*) are required.

Follow-up Reminder

The Follow-up Required option allows users to mark a document for follow-up.

When enabled, the user can specify a follow-up date. The application can then display a reminder through the notification section.

File Storage

The Save File option allows users to save a local file associated with the document.

When enabled, the user can select a location on the computer where the file should be stored.

File Attachments

Users can attach files to a document in two ways:

Select from Computer: Choose an existing file from the computer.
Scan: Scan a physical document using a connected scanner and attach the resulting file.
Registering the Document

After completing the required information and adding any optional attachments, the user can click Register to save the document.

Contact

For questions or project inquiries:

Email: parisarezaee1381@gmail.com

GitHub:
https://github.com/parisarezaee1381/secretarian-webapp
#  سیستم دبیرخانه فکور

## معرفی
 این اپلیکیشن فلاتر با دیجیتال‌سازی کامل فرآیند، امکان شماره‌گذاری خودکار، دسته‌بندی موضوعی و جست‌وجوی پیشرفته را فراهم کرده و زمان بازیابی هر نامه را از چند دقیقه به کمتر از ۵ ثانیه کاهش می‌دهد.

---

## نیازمندی‌ها

### سخت‌افزار مورد نیاز
- **سیستم‌عامل:** ویندوز ۱۰ (نسخه ۱۸۰۹ یا بالاتر) یا ویندوز ۱۱ - فقط ۶۴ بیتی
- **پردازنده:** Intel Core i3 / AMD Ryzen 3 یا بالاتر
- **حافظه رم:** حداقل ۴ گیگابایت (۸ گیگابایت پیشنهاد می‌شود)
- **فضای ذخیره‌سازی:**  حداقل ۱.۵ گیگ برای نصب و اجرا نیاز است.
- **رزولوشن صفحه‌نمایش:** ۱۳۶۶×۷۶۸ یا بالاتر

### نیازمندی‌های نرم‌افزاری
- **Microsoft Visual C++ Redistributable** (نسخه ۲۰۱۵-۲۰۲۲) - [لینک دانلود](https://aka.ms/vs/17/release/vc_redist.x64.exe)
- **دات‌نت فریم‌ورک ۴.۸** (معمولاً روی ویندوز ۱۰ و ۱۱ به‌صورت پیش‌فرض نصب هست)

### نکات مهم اجرایی
-  برنامه **کاملاً آفلاین** کار می‌کند و نیازی به اینترنت ندارد.
-  تمام اطلاعات نامه‌ها در **سیستم خود کاربر** ذخیره می‌شود و هیچ داده‌ای به خارج ارسال نمی‌گردد.
-  در صورت مسدود شدن فایل توسط آنتی‌ویروس، فایل EXE را به لیست استثناهای آنتی‌ویروس اضافه کنید.

### تست شده روی
- ویندوز ۱۰ پرو (نسخه ۲۲H2)

---

## نحوه‌ی نصب و اجرا
1. فایل APK را از [اینجا](#) دانلود کنید.
2. روی فایل دانلود شده بزنید و **نصب** را انتخاب کنید.
3. بعد از نصب، آیکون برنامه را روی گوشی بزنید تا باز شود.

---

## راهنمای استفاده از صفحات

### صفحه‌ی ثبت نام
1. فیلد **نام و نام خانوادگی** را به طور کامل وارد کنید.
2. یک **رمز عبور** قوی انتخاب کرده و در فیلد تکرار رمز، دوباره آن را وارد کنید.
3. فیلد **رنگ مورد علاقه** را پر کنید.
4. پس از تکمیل تمام فیلدها، روی دکمه‌ی **ثبت‌نام** کلیک کنید.

**نکته مهم:**
- تمام فیلدها اجباری هستند و در صورت خالی بودن، دکمه فعال نمی‌شود.

### صفحه‌ی ورود
نام کاربری و رمزعبور خود را وارد کنید و روی دکمه‌ی **ورود** بزنید تا وارد برنامه شوید.

**نکات مهم:**
- در صورت وارد کردن اطلاعات اشتباه، پیام خطای **"نام کاربری یا رمز عبور اشتباه است"** نمایش داده می‌شود.
- در صورت فراموشی رمز عبور، روی لینک **" فراموشی رمز "** کلیک کنید 

### صفحه‌ی فراموشی رمز
رنگ مورد علاقه خود را وارد کنید و روی دکمه‌ی **تایید** بزنید تا وارد برنامه شوید.

**نکات مهم:**
- در صورت وارد کردن اطلاعات اشتباه، پیام خطای **"یا کلمه اشتباه است"** نمایش داده می‌شود.
- در صورت فراموشی رمز عبور، روی لینک **" فراموشی رمز "** کلیک کنید 

### صفحه‌ی داشبورد اصلی
در این صفحه:
می توانید سند جدید ثبت کنید.
 لیست 5 سند آخر را ببینید و آنها را ویرایش یا حذف کنید.
  برای دیدن لیست اسناد، روی دکمه آن ضربه بزنید.
  برای مشاهده تنظیمات روی آیکون تنظیمات کلیک کنید.

### صفحه ویرایش تنظیمات و تغییر رمز 
در این صفحات می توانید اطلاعات حساب کاربری یعنی نام کاربری ، رمز عبور و رنگ مورد علاقه را تغییر دهید.


### صفحه لیست اسناد 
در این صفحه می توانید لیست همه اسناد ثبات شده را به صورت یکجا مشاهده کرده و بر اساس فیلترها سند مورد نظر خود را به سرعت پیدا کنید.


### صفحات ثبت سند 

در این صفحه اطلاعات یک سند یا نامه جدید را ثبت می‌کنید. این صفحه از طریق دکمه **"ثبت سند جدید"** در داشبورد اصلی در دسترس است.

**مراحل ثبت سند:**

1. **اطلاعات اصلی سند:** تمام فیلدهای الزامی (مثل **عنوان سند، شماره، تاریخ، فرستنده و گیرنده**) را به دقت وارد کنید. فیلدهای دارای ستاره (*) اجباری هستند.

2. **فعال کردن گزینه‌های ویژه (اختیاری):** در پایین صفحه، دو دکمهٔ فعال/غیرفعال (Toggle) وجود دارد:
   - **نیاز به پیگیری:** اگر این گزینه را فعال کنید، این سند در تاریخ پیگیری‌ای که مشخص می‌کنید، در **صفحه اعلانات (نوتیفیکیشن)** به شما یادآوری می‌شود.
   - **ذخیره فایل:** اگر این گزینه را فعال کنید، پس از کلیک روی دکمه **ثبت**، از شما آدرس محلی برای ذخیره فایل دریافت می‌شود.

3. **افزودن پیوست (فایل ضمیمه):** برای ضمیمه کردن یک فایل به سند، دو روش وجود دارد:
   - **انتخاب از سیستم:** با کلیک روی دکمه **"انتخاب فایل"**، می‌توانید یک فایل را از روی کامپیوتر خود انتخاب کنید.
   - **اسکن با اسکنر:** با کلیک روی دکمه **"اسکن"**، می‌توانید سند را مستقیماً توسط اسکنر متصل به سیستم، اسکن و ضمیمه کنید.

4. **ثبت نهایی سند:** پس از تکمیل اطلاعات و افزودن پیوست (در صورت نیاز)، روی دکمه **"ثبت"** کلیک کنید.


---


## ارتباط با ما
برای پشتیبانی: [parisarezaee1381@gmail.com]  
برای گزارش باگ: [https://github.com/parisarezaee1381/secretarian-webapp]