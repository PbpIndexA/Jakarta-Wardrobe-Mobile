<details>
<summary> TK Proyek Akhir Semester </summary>

## I. Anggota Kelompok B04

1. Sayyid Thariq Gilang Muttaqien (2306275714)
2. Rizki Amani Hasanah (2306213376)
3. Andi Muhammad Adlyn Fakhreyza Khairi Putra (2306241713)
4. Dara Zakya Apriani (2306165906)
5. Rama Aditya Rifki Harmono (2306165502)
6. Salomo Immanuel Putra (2306219745)

## II. Tautan Deployment APK

## III. Deskripsi Aplikasi 
# Jakarta Wardrobe (JaWa)  – Connecting You to Jakarta's Trends

Jakarta Wardrobe (JaWa) adalah aplikasi informasi yang menyediakan data lengkap mengenai produk fashion yang tersedia di berbagai toko di wilayah DKI Jakarta. Aplikasi ini bukanlah sebuah platform berbelanja online, melainkan sebuah wadah informasi yang memudahkan pengguna, baik warga Jakarta maupun pendatang, untuk menemukan dan mengeksplorasi produk fashion, seperti celana, baju, dress, sepatu, dan lainnya. Kategori yang disediakan di antaranya adalah women’s clothing, men’s clothing, dan footwear.

Keberadaan aplikasi JaWa diharapkan dapat membantu pengguna untuk mengakses dan mendapatkan informasi setiap produk yang dicari, termasuk deskripsi, detail produk, ulasan, dan lokasi toko yang menjual produk tersebut. Aplikasi ini dilengkapi dengan berbagai fitur menarik, seperti rating dan comment yang akan tersedia pada laman ulasan, memungkinkan pengguna memberikan penilaian serta ulasan terhadap produk, sehingga dapat membantu pengguna lain dalam mengambil keputusan yang lebih terinformasi. Selain itu, pengguna juga dapat menyimpan produk favorit mereka ke dalam halaman khusus yang disebut user choice, di mana mereka dapat dengan mudah mengakses kembali produk-produk yang mereka sukai di masa mendatang. Selain fitur-fitur di atas JaWa juga menyediakan fitur categories yang mengelompokkan produk berdasarkan jenis fashion, serta modul filter location, yang memungkinkan pengguna menyaring produk berdasarkan lokasi toko, sehingga mereka dapat menemukan produk fashion yang tersedia di daerah terdekat. 

Jakarta Wardrobe (JaWa) juga hadir dengan fitur Global Chat, sebuah modul yang dirancang untuk mendorong interaksi komunitas pengguna. Fitur ini memungkinkan pengguna untuk berdiskusi, bertanya, dan berbagi informasi seputar produk fashion yang ada di aplikasi. Global Chat dilengkapi dengan antarmuka yang user-friendly dan mendukung aktivitas seperti comment, like pada diskusi, serta kemampuan untuk menandai konten yang relevan. Selain itu, pengguna dapat memanfaatkan fitur ini untuk memulai diskusi baru atau mencari topik tertentu melalui fungsi pencarian.

Dengan fitur-fitur yang tersedia, Jakarta Wardrobe menjadi solusi efektif bagi pengguna yang ingin mengetahui ketersediaan produk fashion di Jakarta sebelum mengunjungi toko, sehingga dapat menghemat waktu dan memastikan produk yang diinginkan tersedia. Aplikasi ini menyediakan informasi yang berguna bagi para warga Jakarta maupun pengunjung untuk merencanakan pembelian produk dengan lebih efisien.


__Manfaat Aplikasi:__ 

1. __Memberikan informasi yang komprehensif__ tentang produk fashion di Jakarta, sehingga pengguna dapat dengan mudah menemukan produk yang  dicari.
2. __Membantu pengguna memilih produk berdasarkan lokasi serta rating dan ulasan__ yang diberikan oleh pengguna lain, meningkatkan pengalaman eksplorasi.
3. __Menawarkan fitur personalisasi__ melalui fitur __*User Choice*__, yang memungkinkan pengguna menyimpan produk favorit mereka untuk referensi di masa mendatang.
4. __Mempermudah pencarian produk__ dengan fitur filter berdasarkan jenis fashion, nama produk (*alphabetical*), dan lokasi toko.
5. __Mendorong interaksi komunitas__ melalui fitur komentar dan ulasan, di mana pengguna dapat berbagi pengalaman mereka mengenai produk tertentu. 

Dengan fitur-fitur ini, Jakarta Wardrobe menjadi solusi efektif bagi pengguna yang ingin mengetahui ketersediaan produk fashion di Jakarta sebelum mengunjungi toko, sehingga dapat menghemat waktu dan memastikan produk yang diinginkan tersedia. Aplikasi ini menyediakan informasi yang berguna bagi para warga Jakarta maupun pengunjung untuk merencanakan pembelian produk dengan lebih efisien.


## IV. Daftar Module dan Pembagian Kerja

1. #### *Rating (Review Page)* 
**Dikerjakan oleh Rama Aditya Rifki Harmono**

Modul ini bertanggung jawab untuk menyimpan dan menampilkan rating setiap produk. Rating diberikan dalam bentuk angka dengan range 1 sampai 5 yang disimpan sebagai atribut rating_value dalam tabel. Pada impleemntasinya, modul ini akan mengumpulkan dan menghitung rata-rata rating dari semua pengguna untuk setiap produk.

#### *Attributes*:
- id: Primary Key 
- product_id: Foreign Key yang terhubung ke tabel Produk 
- user_id: Foreign Key yang terhubung ke tabel Pengguna 
- rating_value: Integer yang menyimpan nilai rating (1–5) 
- timestamp: Timestamp untuk merekam waktu pemberian rating 

2. #### *Comment (Review Page)* 
**Dikerjakan oleh Salomo Immanuel Putra **

Modul ini bertanggung jawab dalam menyimpan komentar yang diberikan oleh pengguna pada setiap produk. Setiap komentar dihubungkan dengan produk dan pengguna melalui __product_id__ dan __user_id__. Modul ini memungkinkan penyimpanan komentar dalam bentuk teks (comment_text), dengan waktu pembuatan disimpan dalam timestamp. Implementasi comment dan rating akan dijadikan satu dalam review page.

#### *Attributes*:
- id: Primary Key 
- product_id: Foreign Key yang mengacu pada tabel Produk 
- user_id: Foreign Key yang mengacu pada tabel Pengguna 
- comment_text: Text yang menyimpan isi komentar 
- timestamp: Timestamp untuk waktu pemberian komentar 

3. #### *Profile Page* 
**Dikerjakan oleh Dara Zakya Apriani**

Modul __*Profile Page*__ memberikan pengguna kendali penuh atas data profil mereka, sekaligus menyajikan ringkasan aktivitas yang dilakukan dalam aplikasi __Jakarta Wardrobe__. Di dalam halaman profil, pengguna dapat melihat rekapan dari aktivitas-aktivitas mereka, termasuk ulasan yang diberikan, artikel atau blog yang mungkin mereka tulis serta interaksi dalam fitur __*Global Chat*__. Dengan fitur ini, pengguna memiliki akses langsung untuk mengelola aktivitas mereka, baik itu mengedit, menghapus, maupun memperbarui konten sesuai keinginan.


#### *Attributes*:
- id: Primary Key
- username: String untuk nama pengguna
- profile_image: URL atau path untuk menyimpan gambar profil
- email: String untuk alamat email pengguna
- date_joined: Timestamp untuk tanggal bergabung
- activity_summary: Relasi One-to-Many dengan tabel Aktivitas yang mencakup ringkasan ulasan, artikel, dan interaksi di Global Chat
- total_reviews: Integer yang menyimpan jumlah total ulasan pengguna
- total_articles: Integer yang menyimpan jumlah total artikel atau blog pengguna
- total_chat_interactions: Integer yang menyimpan jumlah total interaksi di Global Chat
- activity_history: Array atau relasi dengan tabel Aktivitas yang mencatat perubahan atau penghapusan yang dilakukan pengguna


4. #### *User Choice* 
**Dikerjakan oleh Andi Muhammad Adlyn Fakhreyza Khairi Putra**

Modul ini bertanggung jawab untuk mengelola fitur User Choice. Pengguna akan memiliki halaman personal yang menampilkan barang-barang yang mereka masukkan ke dalam daftar favorit, disebut sebagai __*User Choice*__. Modul ini menyimpan pilihan produk berdasarkan preferensi pengguna, yang akan ditampilkan secara khusus pada halaman tersebut. Setiap produk favorit dihubungkan dengan pengguna melalui __user_id__ dan disimpan dalam bentuk daftar produk yang telah ditambahkan ke dalam pilihan mereka. pengguna juga 

#### *Attributes*:
- id: Primary Key 
- user_id: Foreign Key yang terhubung ke pengguna tertentu 
- favorite_products: Array atau relasi *Many-to-Many* ke tabel Produk yang menyimpan daftar produk favorit pengguna 


5. #### *Produk (Filter Categories & Location)*
**Dikerjakan oleh Sayyid Thariq Gilang Muttaqien**

Modul ini bertanggung jawab untuk mengelompokkan dan menyaring produk berdasarkan kategori dan lokasi toko yang menjual setiap produk. Pengguna dapat memilih kategori produk yang mereka inginkan serta lokasi toko yang tersedia, sehingga hanya produk yang sesuai dengan preferensi tersebut yang akan ditampilkan. Setiap produk dihubungkan dengan kategori melalui __category_id__ dan dengan lokasi melalui __location_id__, yang memungkinkan pengelompokan dan penelusuran yang lebih terfokus.

#### *Attributes*:
- category_id: Primary Key untuk kategori
- category_name: String yang menyimpan nama kategori, misalnya “Women’s Clothing”, “Men’s Clothing”, “Footwear”.
- description: Text opsional untuk deskripsi kategori
- location_id: Primary Key untuk lokasi
- location_name: String untuk nama lokasi atau area toko
- Produk Attributes:
  1. product_id: Foreign Key yang menghubungkan ke produk tertentu
  2. category_id: Foreign Key untuk menghubungkan produk dengan kategori tertentu
  3. location_id: Foreign Key untuk menghubungkan produk dengan lokasi tertentu


6. #### *Global Chat* 
**Dikerjakan oleh Rizky Amani Hasanah**

Modul ini menyediakan ruang komunitas bagi pengguna Jakarta Wardrobe (JaWa) untuk saling berinteraksi dan berdiskusi. Setiap pengguna dapat mengirim dan membaca pesan di ruang obrolan umum, di mana semua pengguna dapat berpartisipasi. Modul ini menyimpan pesan dalam bentuk teks, beserta informasi pengguna yang mengirim pesan dan waktu pengiriman, untuk membangun pengalaman komunitas yang aktif dan terbuka.

#### *Attributes*:
- id: Primary Key
- user_id: Foreign Key yang menghubungkan pesan dengan pengguna tertentu
- message_text: Text yang menyimpan isi pesan
- timestamp: Timestamp untuk merekam waktu pengiriman pesan

## V. Role atau Peran Pengguna

1. *Rating* \
Pengguna dapat melihat dan memberikan penilaian terhadap produk yang ditampilkan melalui fitur ini. 

2. *Comment* \
Pengguna dapat melihat dan meninggalkan komentar terkait suatu produk yang nantinya dapat dilihat oleh pengguna lain.

3. *Edit Profile* \
Pengguna dapat menyunting profil pengguna, seperti ID, nama, dan profile picture, dan informasi terkait akun mereka secara *real-time*. 

4. *User Choice* \
Pengguna dapat menyesuaikan preferensi mereka untuk menyesuaikan konten dan pengalaman di website agar lebih interaktif dan personal.

5. *Categories* \
Pengguna dapat memilih kategori produk yang mereka inginkan dan nantinya akan ditampilkan.

6. *Location (Filter)* \
Pengguna dapat menyaring daftar produk berdasarkan lokasi yang lebih ter-filter di Jakarta.


## VI. Alur Pengintegrasian


</details>
