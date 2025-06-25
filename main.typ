#import "@local/abdimasku-template:0.0.1": abdimasku

#show table.cell: it => {
  if it.y == 0 {
    return strong(it)
  }
  it
}

#set table(fill: (x, y) => {
  if y == 0 { gray.lighten(40%) }
})

// TODO:
// - abstract
// - keywords
// - title
#show: abdimasku.with(
  title: [Klasifikasi Perubahan di _Repository_ Git Menggunakan Model
    Transformer],
  pub_date: datetime.today(),
  authors: (
    (
      name: "Steven Staria Nugraha",
      department_id: 1,
      email: "111202214433@mhs.dinus.ac.id",
    ),
  ),
  departments: (
    "Fakultas Ilmu Komputer, Universitas Dian Nuswantoro Semarang",
  ),
)

= Pendahuluan

Salah satu alat yang digunakan di dalam proses pengembangan perangkat lunak
merupakan penggunaan sebuah VCS. Version Control System atau biasa disingkat
sebagai VCS merupakan tipe alat yang membantu pengembang perangkat lunak
menjejakkan perubahan seiring perkembangan sebuah proyek perangkat lunak. Sebuah
VCS pada umumnya menyimpan versi-versi perubahan perangkat lunak@Zolkifli2018-eb
yang memperbolehkan seorang pengembang perangkat lunak untuk kembali ke versi
proyek yang diinginkan@Spinellis2005-fh.

Git merupakan VCS yang paling sering digunakan dalam pengembangan proyek
perangkat lunak masa kini. Dua konsep Git yang relevan dalam artikel ini
merupakan konsep repository dan commit.
Sebuah repository merupakan folder yang berisi basis kode serta file-file terkait
sebuah proyek perangkat lunak. Perubahan-perubahan yang terjadi di folder ini
akan dikelola oleh Git@chacon2014pro
Sedangkan sebuah commit merupakan _checkpoint_ atau titik perubahan yang terjadi
pada sebuah proyek perangkat lunak. Setiap commit dihimbau untuk memiliki pesan
terkait perubahan yang terjadi@chacon2014pro.

Pesan untuk sebuah commit berbentuk teks dengan format bebas. Untuk memberi
keseragaman pesan commit terdapat sebuah standar baru bernama Conventional
Commits@conventional-commits.
// TODO: Conventional Commits history
Sesuai dengan namanya, standar ini memberi konvensi terhadap pesan sebuah
commit. Menurut spesifikasinya, sebuah pesan konvensional memiliki format
berikut:

#figure(
  ```COMMIT_EDITMSG
  <tipe>[lingkup perubahan opsional]: <deskripsi singkat>

  [deskripsi rinci opsional]

  [footer opsional]
  ```,
  caption: "Format Conventional Commits",
) <ccformat>

Dari format yang tercantum di @ccformat, lingkup dokumen ini akan fokus ke
bagian *`<tipe>`*. Bagian ini mengklarifikasikan tipe perubahan yang terjadi
pada sebuah commit. Tipe perubahan ini lah yang akan dijadikan topik klasifikasi
penelitian pada dokumen ini. Conventional Commits memberikan 2 tipe spesifik
yang dapat digunakan oleh pengembang proyek perangkat lunak untuk
mengklasifikasikan perubahan yang terjadi pada sebuah commit, yaitu: `feat` dan
`fix`. Selain kedua tipe tersebut, Conventional Commits juga memperbolehkan
penggunaan tipe-tipe tambahan sesuai kebutuhan sebuah proyek perangkat lunak.
Namun, untuk memberi lingkup klasifikasi pada penelitian ini, hanya kedua tipe
yang diklasifikasikan oleh Conventional Commits (`feat` dan `fix`) yang akan
dipertimbangkan.

Tipe `feat` merupakan klasifikasi perubahan yang menambah sebuah fitur
(_feature_) ke repository proyek.

#figure(
  ```COMMIT_EDITMSG
  feat: tema gelap

  Implementasikan pemilihan tema gelap untuk pengguna
  ```,
  caption: [Contoh commit bertipe `feat`],
) <egfeat>

Sedangkan, tipe `fix` merupakan klasifikasi
perubahan yang membenarkan kecacatan (_bug_) dalam proyek perangkat lunak.

#figure(
  ```COMMIT_EDITMSG
  fix(backend)!: perbaiki sesi masuk

  Perbaiki kasus dimana sesi masuk pengguna tidak tersimpan

  BREAKING CHANGE: pengguna yang telah memiliki sesi masuk, harus melakukan
  otorisasi kembali
  ```,
  caption: [Contoh commit bertipe `fix` pada lingkup _backend_ dengan perubahan
    merusak (_breaking change_)],
) <egfix>

Seperti yang dicantumkan di @egfix, sebuah commit dapat memiliki perubahan
merusak atau _breaking change_, yaitu sebuah perubahan yang berdampak pada
kinerja pengembangan maupun penggunaan perangkat lunak sedemikian rupa sehingga
diperlukan untuk melakukan proses penyesuaian. Sifat ini menambah klasifikasi
yang dapat dilakukan dari 2 tipe ke 4 tipe seperti yang dicantumkan pada @types.

#figure(
  table(
    columns: 2,
    align: (left, left),
    table.header([Tipe], [Keterangan]),
    `feat`, [penambahan fitur],
    `fix`, [perbaikan kecacatan],
    `feat!`, [penambahan fitur dengan perubahan merusak],
    `fix!`, [perbaikan kecacatan dengan perubahan merusak],
  ),
  caption: "Tipe commit yang akan diklasifikasikan",
) <types>


Untuk melakukan klasifikasi tipe commit, model-model _machine learning_ berbasis
transformer akan digunakan. Penjelasan alasan penggunaan model-model transformer
akan dibahas pada @classification-method. Model-model transformer umumnya
memiliki bagian arsitektur encoder, yang bekerja untuk memetakan masukan menjadi
token yang dapat dipahami oleh sebuah komputer dan bagian arsitektur decoder
yang bekerja untuk memetakan kembali token-token yang telah diproses menjadi
tipe keluaran yang diinginkan@Tunstall2022-iq.

= Metode

// TODO: data mining

== Klasifikasi <classification-method>

Metode klasifikasi yang digunakan untuk penelitian ini melibatkan penggunaan
model transformer. Penggunaan model-model transformer dikarenakan model-model
ini dapat memahami konteks dari sebuah kutipan kode, sifat ini sangat penting
untuk menentukan kategori tipe commit yang akan diklasifikasikan.

Pada lingkup penelitian ini, bagian decoder dari sebuah model transformer tidak
relevan, dikarenakan untuk proses klasifikasi tidak diperlukan keluaran spesifik
yang tidak dapat diproses oleh algoritma sederhana. Sehingga penggunaan sebuah
decoder, yang umumnya memiliki kompleksitas algoritma yang lebih tinggi hanya
akan memboroskan sumber daya dan waktu komputasi.

=== Model yang Digunakan

Tiga model yang dipertimbangkan untuk mengklasifikasikan perubahan pada
penelitian ini yaitu CodeBERT@codebert, CodeT5@codet5 dan CodeT5+@codet5p.

CodeBERT merupakan perkembangan dari BERT (Bidirectional Encoder Representations
from Transformer), model transformer yang identik dengan sifat pemahaman dua
arah (_bidirectional_), sehingga model ini memiliki keunggulan di pemahaman
konteks. Model-model BERT pada umumnya juga hanya mengimplementasikan bagian
encoder dari sebuah transformer, sehingga sangat cocok digunakan untuk proses
klasifikasi. CodeBERT dapat mengklasifikasikan kecacatan pada perangkat lunak
dengan akurasi antara 62.08%@codet5 dan 64.31%@gfsa. Sesuai dengan waktu
publikasi dokumen penelitian-nya, model ini terbit padat tahun 2020 oleh
peneliti-peneliti di Microsoft.

Sedangkan CodeT5 merupakan model transformer lebih baru dibandingkan dengan
CodeBERT, model ini diterbitkan pada tahun 2021 oleh tim peneliti di Salesforce.
CodeT5 merupakan penerusan dari model transformer T5 yang pertama diterbitkan
oleh Google pada tahun 2019@t5. Model-model berbasis T5 umumnya
mengimplementasikan encoder dan decoder, sehingga penggunaan model-model ini
untuk proses klasifikasi kurang tepat. Namun, CodeT5 memiliki nilai akurasi
deteksi kecacatan yang lebih tinggi secara rata-rata: 63.25%@gfsa hingga
65.78%@codet5, tergantung dengan jumlah parameter antara penyesuaian lain.

Perkembangan dari CodeT5: CodeT5+, diterbitkan pada tahun 2023 juga oleh tim
peneliti Salesforce. Model ini meningkatkan akurasi deteksi kecacatan dari
CodeT5 secara signifikan dengan nilai antara 66.1%@codet5p hingga 66.7%@codet5p.
Selain itu, CodeT5+ juga memberikan varian encoder dan decoder yang terpisah,
sehingga dapat dioptimalkan untuk penggunaan klasifikasi, menggunakan varian encoder.

// TODO: bias peneliti

#figure(
  table(
    columns: 4,
    table.header(
      [Model],
      [Arsitektur Transformer],
      [Akurasi Deteksi Kecacatan],
      [Tahun Terbit],
    ),

    [CodeBERT], [Encoder], [62.08% - 64.31%], [2020],
    [CodeT5], [Encoder dan decoder], [63.25% - 65.78%], [2021],
    [CodeT5+], [Encoder, decoder atau keduanya], [66.1% - 66.7%], [2023],
  ),
  caption: "Perbandingan model-model yang dipertimbangkan",
)

= Hasil dan Pembahasan

= Kesimpulan

#bibliography("refs.bib")
