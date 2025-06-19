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
  title: [Klasifikasi Perubahan di _Repository_ Git],
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
menjejakkan perubahan seiring perkembangan sebuah proyek perangkat lunak.

== Git

Git merupakan VCS yang paling sering digunakan dalam pengembangan proyek
perangkat lunak masa kini. Dua konsep Git yang relevan dalam artikel ini
merupakan konsep repository dan commit.
Sebuah repository merupakan folder yang berisi basis kode serta file-file terkait
sebuah proyek perangkat lunak. Perubahan-perubahan yang terjadi di folder ini
akan dikelola oleh Git.
Sedangkan sebuah commit merupakan _checkpoint_ atau titik perubahan yang terjadi
pada sebuah proyek perangkat lunak. Setiap commit dihimbau untuk memiliki pesan
terkait perubahan yang terjadi.

== Conventional Commits

Pesan untuk sebuah commit berbentuk teks dengan format bebas. Untuk memberi
keseragaman pesan commit terdapat sebuah standar baru bernama Conventional
Commits.
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

= Metode

= Hasil dan Pembahasan

= Kesimpulan
