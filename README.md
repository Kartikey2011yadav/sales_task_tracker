# 📱 Sales Task Tracker App

A Flutter mobile app for field salespersons to **log tasks offline** and **sync data to Firebase Firestore** when online.

---

## 🚀 Features

- **Offline-first**: Tasks are stored locally using SQLite.
- **Manual Sync**: Upload unsynced tasks to Firestore when network is available.
- **Sync Status**: View which tasks are synced or pending.
- **Connectivity Detection**: App detects online/offline status in real-time.
- **Clean UI**: Simple dashboard, add-task form, task list, and detail view.

---

## 📲 User Flow

1. Salesperson opens the app and lands on the **Dashboard**.
2. Taps **"Add New Task"** to log:
    - Shop Name
    - Product Sold
    - Quantity
    - Amount
    - Optional Notes
    - Timestamp (auto-filled)
3. The task is saved **locally first**.
4. Taps **"View All Tasks"** to check sync status.
5. When internet is available, taps **"Sync Now"** to upload unsynced tasks to Firebase.

---

## 📸 Screenshots

| Dashboard | Add Task | Task List |
|:--------:|:--------:|:---------:|
| ![Dashboard](screenshots/Dashboard.png) | ![Add Task](screenshots/AddTasks.png) | ![Task List](screenshots/AllTasks.png) |

| Task Syncing | Task Details |
|:------------:|:------------:|
| ![Sync](screenshots/TaskSync.png) | ![Details](screenshots/details.png) |



---

## 📦 Tech Stack

- **Flutter**
- **Firebase Firestore**
- **SQLite (sqflite)**
- **connectivity_plus**
- **floating_snackbar**

---

## 📦 APK Download

You can download and install the latest version of the app from the link below:

👉 [Download Sales Task Tracker APK](./apk/app-debug.apk)

> ⚠️ Make sure to allow installations from unknown sources on your Android device.


---

## 🛠️ Setup Instructions

1. **Clone this repo**:
   ```bash
   git clone https://github.com/Kartikey2011yadav/sales_task_tracker.git
   cd sales_task_tracker
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Add Firebase configuration**:
   - Download `google-services.json` from your Firebase Console.
   - Place it in the `android/app/` directory.

4. **Run the app**:
   ```bash
   flutter run
   ```

5. *(Optional)* To build the APK:
   ```bash
   flutter build apk --release
   ```

6. **Locate the generated APK**:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

---

