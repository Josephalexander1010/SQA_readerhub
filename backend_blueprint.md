# Reader-HUB Backend Architecture Specification

**Technology Stack:**
*   **Frontend:** Flutter
*   **Backend:** Django (Python) / Express / Go (Sesuai preferensi)
*   **Database:** PostgreSQL / MySQL
*   **Auth:** JWT (JSON Web Token)
*   **Storage:** AWS S3 / Cloudinary / Local Media (untuk gambar/video)

---

## 1. Database Schema (ERD Concept)

### A. Users Table (`users`)
Menyimpan data akun pengguna.
*   `id` (Primary Key, UUID/Int)
*   `username` (String, Unique)
*   `email` (String, Unique)
*   `password_hash` (String)
*   `profile_picture` (URL/Path)
*   `is_verified` (Boolean) - Untuk verifikasi email
*   `interests` (JSON/Array) - Hasil dari Topic Selection Page
*   `created_at` (DateTime)

### B. Channels Table (`channels`)
Menyimpan data Channel yang dibuat user.
*   `id` (Primary Key)
*   `owner_id` (Foreign Key -> `users.id`)
*   `name` (String) - Contoh: "[M]Harry Potter"
*   `description` (Text)
*   `avatar_url` (URL/Path)
*   `created_at` (DateTime)

### C. Sub-Channels Table (`sub_channels`)
Bagian dari Channel (General, Announcements, dll).
*   `id` (Primary Key)
*   `channel_id` (Foreign Key -> `channels.id`)
*   `name` (String) - Contoh: "General"
*   `created_at` (DateTime)

### D. Feeds/Posts Table (`posts`)
Konten yang diposting user di dalam sub-channel.
*   `id` (Primary Key)
*   `sub_channel_id` (Foreign Key -> `sub_channels.id`)
*   `author_id` (Foreign Key -> `users.id`)
*   `content` (Text) - Caption
*   `media_url` (URL/Path) - Gambar/Video
*   `media_type` (Enum: 'image', 'video', 'none')
*   `created_at` (DateTime)

### E. Interactions Table (`likes`, `saves`, `follows`)
Untuk fitur sosial.
*   **Follows:** `user_id` mem-follow `channel_id`.
*   **Likes:** `user_id` menyukai `post_id`.
*   **Saves:** `user_id` menyimpan `post_id`.
*   **Comments:** `user_id`, `post_id`, `content`.

---

## 2. API Flow & Endpoints

### PHASE 1: Authentication (Onboarding)

**Register (Sign Up)**
*   **Frontend:** `signup_page.dart`
*   **Endpoint:** `POST /api/auth/register`
*   **Body:** `username`, `email`, `password`
*   **Logic:** Buat user baru di DB, set `is_verified = false`. Kirim email OTP.

**Verify Email (OTP)**
*   **Frontend:** `SignupVerifyPage`
*   **Endpoint:** `POST /api/auth/verify-email`
*   **Body:** `email`, `otp_code`
*   **Logic:** Cek kode. Jika benar, set `is_verified = true`. Kembalikan `access_token` (JWT).

**Select Topics**
*   **Frontend:** `topic_selection_page.dart`
*   **Endpoint:** `POST /api/user/interests`
*   **Body:** `['Entertainment', 'Community', ...]`
*   **Header:** `Authorization: Bearer <token>`

**Login**
*   **Frontend:** `login_page.dart`
*   **Endpoint:** `POST /api/auth/login`
*   **Body:** `email`, `password`
*   **Response:** `user_id`, `username`, `pfp`, `access_token`.

**Forgot Password**
*   **Frontend:** `forgot_password.dart`
*   **Endpoint 1:** `POST /api/auth/forgot-password` (Kirim email).
*   **Endpoint 2:** `POST /api/auth/reset-password` (Verifikasi OTP & ganti password).

### PHASE 2: Dashboard & Discovery

**Get User Feed (Timeline)**
*   **Frontend:** `homepage.dart` ("Your Channel Feed")
*   **Endpoint:** `GET /api/feeds/timeline`
*   **Logic:** Ambil semua postingan dari Channel yang di-follow oleh user, urutkan dari terbaru.

**Get User Channels (Horizontal Scroll & Collection)**
*   **Frontend:** `homepage.dart` (Header) & `my_channel_collection.dart`
*   **Endpoint:** `GET /api/user/channels`
*   **Logic:** Ambil daftar channel yang dimiliki (`isOwned`) DAN channel yang difollow.
*   **Response:** List of Channel Objects (`id`, `name`, `avatar`, `is_owned`).

**Search Channels**
*   **Frontend:** `searchpage.dart`
*   **Endpoint:** `GET /api/channels/search?q={keyword}`
*   **Logic:** Cari channel orang lain berdasarkan nama.

### PHASE 3: Creation & Management (Fitur Inti)

**Create Channel**
*   **Frontend:** `createchannel.dart`
*   **Endpoint:** `POST /api/channels/create`
*   **Format:** `Multipart/Form-Data` (Karena upload gambar).
*   **Body:** `name`, `description`, `avatar_file`.
*   **Backend Logic:** Simpan gambar ke storage, simpan data ke DB, otomatis buat 2 sub-channel default ("General", "Announcements").

**Get Channel Details**
*   **Frontend:** `channel_detail.dart`
*   **Endpoint:** `GET /api/channels/{channel_id}`
*   **Response:** Detail channel + List Sub-Channels.

**Create Sub-Channel**
*   **Frontend:** Dialog di `channel_detail.dart`
*   **Endpoint:** `POST /api/channels/{channel_id}/subchannels`
*   **Body:** `name` (misal: "Fan Art").

**Delete Channel / Sub-Channel**
*   **Frontend:** Long press di `my_channel_collection.dart`
*   **Endpoint:**
    *   `DELETE /api/channels/{channel_id}`
    *   `DELETE /api/subchannels/{sub_id}`

**Create Feed (Post)**
*   **Frontend:** `createfeed.dart`
*   **Endpoint:** `POST /api/feeds/create`
*   **Format:** `Multipart/Form-Data`
*   **Body:** `channel_id`, `sub_channel_id`, `caption`, `media_file`.

**Get Sub-Channel Feeds**
*   **Frontend:** `subchannel_page.dart`
*   **Endpoint:** `GET /api/feeds?sub_channel_id={id}`
*   **Logic:** Ambil semua post di sub-channel tertentu.

**Follow / Unfollow**
*   **Frontend:** Tombol di `channel_detail.dart` (untuk channel orang lain)
*   **Endpoint:** `POST /api/channels/{id}/follow`
*   **Endpoint:** `POST /api/channels/{id}/unfollow`

---

## 3. Catatan Penting untuk Backend Developer

1.  **Image Handling:**
    *   Frontend Flutter mengirim gambar dalam format `File` (Multipart).
    *   Backend harus menerimanya, menyimpannya (di folder `media/` atau S3), dan mengembalikan URL publik (contoh: `https://api.readerhub.com/media/profile123.jpg`).
    *   Frontend akan menggunakan `Image.network(url)` untuk menampilkannya.

2.  **Authentication Middleware:**
    *   Hampir semua endpoint (kecuali Login/Register) harus diproteksi.
    *   Backend harus mengecek Header `Authorization: Bearer <token>` untuk mengetahui siapa user yang sedang request.

3.  **Pagination:**
    *   Untuk `GET /feeds`, backend sebaiknya menerapkan pagination (misal: load 10 postingan per request) agar aplikasi tidak berat saat data sudah banyak.

---

### Langkah Awal untuk Backend Developer:
1.  **Setup Project** (Django/Node.js/Go).
2.  **Buat Database** sesuai skema di poin 1.
3.  **Buat API Login & Register** terlebih dahulu agar bisa dites koneksinya dari Flutter.
