#import "@local/abdimasku-template:0.0.1": abdimasku
#import "@preview/fletcher:0.5.8"
#import fletcher: diagram, edge, node, shapes.cylinder

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
#show: abdimasku.with(
  title: [Klasifikasi Perubahan _Repository_ Git Menggunakan Transformer
    CodeT5+],
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

Tanpa permintaan eksplisit (yaitu menggunakan _flag_ `--allow-empty-message`),
pengembang yang menggunakan Git diwajibkan untuk menulis pesan saat merancang
sebuah commit. Sehingga tanggung jawab penulisan pesan turun ke pengembang.
Walaupun pesan commit berfungsi sebagai identifikasi semantik utama sebuah
commit, proses ini dapat menjadi salah satu hambatan waktu dan tenaga untuk
pengembang. Salah satu tujuan dari penelitian ini adalah untuk membantu
pengembang perangkat lunak untuk mengotomatiskan sebagian proses penulisan pesan
saat perancangan sebuah commit. Selain itu, proses otomatisasi pada umumnya juga
menimbulkan standardisasi; sehingga, penelitian ini juga dapat berguna untuk
membantu khususnya pengembang-pengembang pemula untuk menulis pesan commit
berstandar.

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

== Penelitian Terkait

GCC (Git Change Classifier) merupakan alat yang juga mengklasifikasikan
perubahan pada repository Git@Kaur2018-bh. GCC menggunakan ekspresi reguler
sebagai metode klasifikasi yang digunakan. Tipe-tipe perubahan yang
diklasifikasikan dengan GCC jatuh pada 3 kelompok, yaitu: Bug Repairing Changes
(BRC), Feature Introducing Changes (FIC) dan General Changes (GC). BRC setara
dengan tipe `fix` dan FIC setara dengan tipe `feat` sedangkan GC merupakan
perubahan generik. GCC tidak mengklasifikasikan perubahan merusak. Terdapat juga
berbagai penelitian yang menggunakan machine learning untuk klasifikasi commit,
antara lain: penelitian @9307651 yang menghasilkan nilai F1 87% dan penelitian
@levin menghasilkan nilai akurasi 76%. Kedua penelitian ini@levin@9307651
menggunakan pengelompokan @swansondimensions yang mengklasifikasikan tipe
perubahan menjadi "_Corrective_", "_Adaptive_" dan "_Perfective_". Perubahan
_corrective_ merupakan tipe perubahan yang memperbaiki kecacatan, _adaptive_
merupakan penambahan fitur dan _perfective_ merupakan peningkatan kinerja. Jika
dibandingkan dengan tipe-tipe Conventional Commits, tipe _corrective_ memiliki
arti semantik yang sama dengan tipe `fix` dan tipe _adaptive_ dengan tipe
`feat`, sedangkan tipe _perfective_ tidak memiliki tipe sebanding yang
didiskusikan pada lingkup penelitian ini. Perbedaan antara penelitian @levin dan
@9307651 terletak pada penerapan metode yang digunakan, @9307651 menggunakan
model transformer DistilBERT@distilbert untuk mempertimbangkan klasifikasi tipe
perubahan dari pesan commit, sedangkan @levin mengembangkan model secara
independen yang mempertimbangkan perubahan pada kode, dan frekuensi kata pada
pesan commit. Walaupun hasil yang memuaskan, penelitian @levin dan @9307651 juga
tidak melakukan klasifikasi tipe perubahan yang merusak, dan kedua penelitian
tersebut memiliki ketergantungan dengan pesan commit yang telah tertulis.

= Metode

#figure(
  {
    diagram(debug: false, node-stroke: black, node-shape: rect, {
      node(name: <gh>, (1, -1), [GitHub], shape: cylinder)
      node(name: <preproc>, (1, 0), [Preprocessing])
      let dsn = node.with(shape: cylinder)
      dsn(name: <ds2>, (2, 0), [
        #set align(left)
        #set par(first-line-indent: 0em, justify: false)
        #set list(indent: 0em)
        Dataset dengan label:
        - `feat`
        - `fix`
        - `breaking`
      ])
      let t5p = node.with()
      t5p(name: <t52>, (7, 0), [CodeT5+])

      edge(<gh>, <preproc>, "->")
      edge(<preproc>, <ds2>, "->")
      edge(<ds2>, <t52>, "->", bend: 15deg, [$90%$ training])
      edge(<ds2>, <t52>, "->", bend: -15deg, [$10%$ testing])

      node(inset: 3.2em, enclose: ((4, 0), (7, 0)), place(
        bottom + center,
        dy: 4.5em,
      )[Klasifikasi])
      node(
        inset: 1.5em,
        enclose: (<gh>, <preproc>, <ds2>),
        name: <mining>,
        place(bottom + center, dy: 3em)[Penambangan Data],
      )
    })
  },
  gap: 3em,
  caption: [Gambaran diagram untuk metode yang diusulkan],
)

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
akan memboroskan sumber daya dan waktu komputasi. Tiga model yang
dipertimbangkan untuk mengklasifikasikan perubahan pada penelitian ini yaitu
CodeBERT@codebert, CodeT5@codet5 dan CodeT5+@codet5p.

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
) <models_cmp>

Seperti yang tercantum pada @models_cmp, model dengan rentang akurasi tertinggi
saat digunakan untuk mendeteksi kecacatan merupakan CodeT5+. Selain itu, model
ini juga memiliki tahun terbit terkini yang dapat mengklasifikasikan model ini
sebagai model _state of the art_. Sehingga, model inilah yang akan digunakan
pada penelitian ini.
= Hasil dan Pembahasan

= Kesimpulan

#bibliography("refs.bib")
