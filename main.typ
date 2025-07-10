#import "@local/abdimasku-template:0.0.1": abdimasku
#import "@preview/fletcher:0.5.8"
#import fletcher: diagram, edge, node, shapes.cylinder

#show table.cell: it => {
  if it.y == 0 {
    return strong(it)
  }
  it
}

#let thead_fill = gray.lighten(40%)
#set table(fill: (x, y) => {
  if y == 0 { thead_fill }
})

#show raw.where(block: true): set block(stroke: 1pt, inset: 1em)
#set list(indent: 1em)
#set enum(indent: 1em)

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
berstandar. Selain itu, penelitian ini juga akan memberikan contoh penerapan
dan wawasan mengenai proses klasifikasi menggunakan model berbasis transformer,
yang pada umumnya digunakan untuk generasi teks.

Alasan penggunaan model berbasis transformer untuk melakukan
klasifikasi$dash.em$walaupun tidak intuitif$dash.em$dikarenakan model-model
transformer dapat memperhitungkan konteks dari sebuah fitur teks yang diberikan.
Sehingga, klasifikasi dilakukan bukan dengan fitur-fitur yang di perlu
di-ekstraksi dari sebuah pesan commit (seperti frekuensi kata, panjang teks, dan
lain-lain), namun langsung dari pesan commit tersebut sendiri. Metode ini
meringankan beban kerja dari proses penambangan data (khususnya pada tahap
_feature extraction_) dan juga dapat menambah kinerja dari hasil klasifikasi
yang dilakukan. Model yang digunakan akan dibahas secara lebih rinci pada
@model.

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
      node(
        name: <gh>,
        (1, -1),
        box(width: 5em)[Neovim Commits],
        shape: cylinder,
      )
      node(name: <preproc>, (1, 0), [Preprocessing])
      let dsn = node.with(shape: cylinder)
      dsn(name: <ds2>, (2, 0), [
        #set align(left)
        #set par(first-line-indent: 0em, justify: false)
        #set list(indent: 0em)
        Dataset dengan kolom:
        - `diff`
        - `feat`
        - `fix`
        - `breaking`
      ])
      let t5p = node.with()
      t5p(name: <t51>, (6, -0.5), [CodeT5+ `feat`])
      t5p(name: <t52>, (6, 0), [CodeT5+ `fix`])
      t5p(name: <t53>, (6, 0.5), [CodeT5+ `breaking`])

      edge(<gh>, <preproc>, "->")
      edge(<preproc>, <ds2>, "->")
      edge(<ds2>, <classification>, "->", bend: 15deg, [$90%$ training])
      edge(<ds2>, <classification>, "->", bend: -15deg, [$10%$ testing])

      node(enclose: (<t51>, <t52>, <t53>), name: <classification>, place(
        bottom + center,
        dy: 2em,
      )[_Finetuning_])
      node(
        inset: 1.5em,
        enclose: (<gh>, <preproc>, <ds2>),
        name: <mining>,
        place(bottom + center, dy: 3em)[Penambangan Data],
      )
    })
  },
  gap: 3em,
  caption: [Diagram rangkuman metode yang diusulkan],
)

Dataset yang digunakan pada penelitian ini akan memiliki 4 kolom dengan 1 kolom
fitur teks dan 3 kolom label numerik. Kolom fitur `diff` merupakan isi teks yang
didapatkan saat menjalankan perintah "```sh git diff```" (serupa dengan @diff_eg).
Sedangkan, kolom-kolom label pada dataset adalah yaitu: `feat`, `fix` dan
`breaking`. Masing-masing kolom label berisi representasi nilai kepercayaan
untuk masing-masing tipe. Kolom `breaking` merepresentasikan nilai kepastian
_breaking change_ atau perubahan merusak.

#figure(
  ```diff
    diff --git a/runtime/lua/vim/lsp/diagnostic.lua b/runtime/lua/vim/lsp/diagnostic.lua
  index 661495ecb9..97d4dce19d 100644
  --- a/runtime/lua/vim/lsp/diagnostic.lua
  +++ b/runtime/lua/vim/lsp/diagnostic.lua
  @@ -443,16 +443,16 @@ end
   --- Returns the result IDs from the reports provided by the given client.
   --- @return lsp.PreviousResultId[]
   local function previous_result_ids(client_id)
  -  local results = {}
  +  local results = {} ---@type lsp.PreviousResultId[]

     for bufnr, state in pairs(bufstates) do
       if state.pull_kind ~= 'disabled' then
         for buf_client_id, result_id in pairs(state.client_result_id) do
           if buf_client_id == client_id then
  -          table.insert(results, {
  -            textDocument = util.make_text_document_params(bufnr),
  -            previousResultId = result_id,
  -          })
  +          results[#results + 1] = {
  +            uri = vim.uri_from_bufnr(bufnr),
  +            value = result_id,
  +          }
             break
           end
         end
  ```,
  caption: [Contoh isi penuh kolom `diff`, yaitu potongan dari hasil perintah
    "```sh git show 4ee2e```" yang dijalankan pada repository Neovim (dilakukan
    dengan Git versi 2.49.0)],
) <diff_eg>

#figure(
  table(
    columns: 4,
    table.header([`diff`], [`feat`], [`fix`], [`breaking`]),

    [`diff --git a/ru`$dots$], [1.0], [0.0], [0.0],
    ..for i in range(4) { ([$dots.v$],) }
  ),
  caption: [Contoh struktur dataset yang digunakan],
) <dataset_shape>

Pembagian label menjadi 3 kategori terpisah dilakukan karena sebuah commit dapat
bersifat sebagai perubahan penambahan fitur dan perbaikan kecacatan sekaligus,
atau bukan keduanya. Selain itu ketiga label juga bersifat independen dari satu
sama lain.

== Penambangan Data

Pada saat penelitian ini, belum terdapat dataset berisi fitur-fitur dan label
yang dibutuhkan (lihat @dataset_shape). Oleh karena itu, pengembangan dataset
perlu dilakukan terlebih dahulu. Untuk mengembangkan dataset yang diinginkan,
diperlukan repository yang menggunakan standar Conventional Commits. Salah satu
proyek perangkat lunak yang menggunakan standar commit Conventional Commits
dengan sumber kode yang terbuka, adalah Neovim@neovim_repo. Repository ini
memiliki lebih dari 30 ribu commit, dengan ukuran repository \~246MiB. Tentunya,
tidak semua commit akan digunakan. Walaupun repository ini@neovim_repo
menggunakan standar Conventional Commits, tidak semua format pesan mengikuti
standar ini. Selain itu, penelitian ini hanya melingkupi tipe commit `fix` dan
`feat`. Sehingga penyaringan commit-commit perlu dilakukan pada tahap
_preprocessing_ untuk kedua kriteria tersebut. Tahap _preprocessing_ juga
bertanggung jawab untuk merancang struktur dataset yang diinginkan, masukan data
pada tahap _preprocessing_ merupakan potongan perubahan kode serta pesan terkait
perubahan tersebut. Sehingga, potongan perubahan kode akan dipetakan ke kolom
fitur `diff` pada dataset; sedangkan, pesan perubahan commit akan berguna untuk
mengisi kolom-kolom label (yaitu `feat`, `fix` dan `breaking`). Untuk memetakan
kolom-kolom label dari pesan perubahan commit, analisa pesan tersebut perlu
dilakukan dengan pendekatan ekspresi reguler@regex.

// TODO: CodeT5+ only supports: c, c++, c-sharp, go, java, javascript, php, python, ruby.

== Model yang digunakan <model>

Seperti yang tercantum pada bagian-bagian sebelumnya, model yang digunakan pada
penelitian ini merupakan sebuah model berbasis transformer. Model-model
transformer umumnya memiliki bagian arsitektur encoder, yang bekerja untuk
memetakan masukan menjadi token yang dapat dipahami oleh sebuah komputer dan
bagian arsitektur decoder yang bekerja untuk memetakan kembali token-token yang
telah diproses menjadi tipe keluaran yang
diinginkan@Tunstall2022-iq#footnote[Pendekatan encoder-decoder tidak hanya
  identik dengan transformer, pendekatan ini dikembangkan pertama dalam model
  seq2seq@seq2seq, namun karakteristik model-model berbasis transformer identik
  dengan penerapan _attention layer_ yang digunakan untuk memberi bobot
  kepentingan masing-masing token@Huyen2024-xm].

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
peneliti-peneliti di Microsoft. Sedangkan CodeT5 merupakan model transformer
lebih baru dibandingkan dengan CodeBERT, model ini diterbitkan pada tahun 2021
oleh tim peneliti di Salesforce. CodeT5 merupakan penerusan dari model
transformer T5 yang pertama diterbitkan oleh Google pada tahun 2019@t5.
Model-model berbasis T5 umumnya mengimplementasikan encoder dan decoder,
sehingga penggunaan model-model ini untuk proses klasifikasi kurang tepat.
Namun, CodeT5 memiliki nilai akurasi deteksi kecacatan yang lebih tinggi secara
rata-rata: 63.25%@gfsa hingga 65.78%@codet5, tergantung dengan jumlah parameter
antara penyesuaian lain. Perkembangan dari CodeT5: CodeT5+, diterbitkan pada
tahun 2023 juga oleh tim peneliti Salesforce. Model ini meningkatkan akurasi
deteksi kecacatan dari CodeT5 secara signifikan dengan nilai antara
66.1%@codet5p hingga 66.7%@codet5p.

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
pada penelitian ini. Karena CodeT5+ hanyalah model pondasi yang tidak memiliki
tujuan spesifik, proses _finetuning_ akan dilakukan untuk mengarahkan model
tersebut untuk melakukan proses klasifikasi yang diinginkan. Secara lebih
spesifik, proses _finetuning_ yang dilakukan adalah proses _supervised
finetuning_@Huyen2024-xm[pp. 80]. Proses ini melibatkan data masukan sebagai
contoh (training) label-label yang diinginkan dari fitur-fitur yang diberikan;
sehingga. Sehingga, 90% data di dataset yang telah diperoleh dari langkah
penambahan data akan digunakan untuk proses ini.

Untuk menghasilkan kolom-kolom label majemuk (sesuai @dataset_shape), pendekatan
_Multi-Label Classification_@Tsoumakas2008-tk (MLC) akan digunakan. Untuk itu,
tahap klasifikasi akan dibagi menjadi 3 tahap terpisah untuk masing-masing
label (`feat`, `fix` dan `breaking`). Karena masing-masing label bersifat
independen satu sama lain, metode pendekatan Binary Relevance (BR) akan
digunakan untuk mengklasifikasikan masing-masing label@Zhang2018-uc.

Walaupun pada dataset yang diberikan, label-label bertipe biner kontinu (sesuai
@dataset_shape) dan karena semua label bersifat independen, dapat terjadi kasus
dimana, jika label diimplementasikan dengan tipe biner diskret (yaitu 0 dan
1), kedua label `feat` dan `fix` berisi nilai 1. Oleh karena itu, label-label
pada dataset diimplementasikan dengan tipe kontinu (yaitu rentang
0.0 hingga 1.0). Sehingga pada proses _finetuning_, model harus diinstruksikan
untuk memberi label dengan nilai bobot kepercayaan dan tidak sepenuhnya meniru
label-label pada dataset yang diberikan.

Seperti yang tercantum di @t_notation, tipe perubahan $P$ diklasifikasikan
sebagai perubahan `feat` $p_1$, jika nilai label `feat` $l_1$ lebih dari nilai
label `fix` $l_2$. Sedangkan, $T$ merupakan perubahan `fix` $p_2$, jika $l_1$
kurang dari atau sama dengan $l_2$, dan $l_2$ lebih dari _threshold_ (batasan)
$t_t$. Jika semua kondisi sebelumnya tidak terpenuhi (maka $l_1 <= 0 and l_2 <=
t$), maka tidak tipe $T$ tidak dapat diklasifikasikan sebagai `feat` atau `fix`
dengan tingkat kepercayaan yang mencukupi, atau dinotasikan $T = nothing$.
Seperti yang tercantum pada @b_notation, perubahan pada sebuah commit dapat
diklasifikasikan sebagai perubahan merusak $b_1$, jika nilai label `breaking`
$l_3$ lebih dari _threshold_ $t_b$. Jika $l_3$ kurang dari atau sama dengan
$t_b$, maka perubahan commit dapat diklasifikasikan sebagai perubahan yang tidak
merusak.
$
  P = cases(
    p_1 & "if" l_1 > l_2,
    p_2 & "if" l_1 <= l_2 > t_t,
    nothing & "else"
  )
$ <t_notation>
$
  B = cases(
    b_1 & "if" l_3 > t_b,
    b_2 & "else",
  )
$ <b_notation>

= Hasil dan Pembahasan

Dari proses penambangan data pada repository Neovim, didapatkan berbagai macam
atribut commit yang diperoleh. Pembagian commit-commit dapat divisualisasikan
sebagai @dataset_sankey.

#figure(image("dataset_sankey.svg"), caption: [Visualisasi pembagian
  commit-commit pada repository Neovim dengan identifikasi commit terakhir
  `fccd016a0f`]) <dataset_sankey>

Dari @dataset_sankey, diperoleh bahwa hanya $~23$ ribu dari $~32$ ribu commit
dapat digunakan sebagai data _finetuning_ dan testing model. Hal ini disebabkan
commit-commit yang memiliki label `feat`, `fix` atau `breaking` hanya dapat
diperoleh dari commit-commit dengan format Conventional Commits. Dari $~23$ ribu
baris data yang dapat terpakai, seluruhnya dapat digunakan untuk training label
`breaking`, walaupun jumlah commit merusak berjumlah lebih kecil dari jumlah
commit tidak merusak dengan nilai signifikan. Sedangkan, untuk label `feat` dan
`fix` hanya $~3$ ribu data dapat digunakan untuk training model, dengan $<2$
ribu data untuk label `feat` dan $~2$ ribu data untuk label `fix`. Hal ini
dikarenakan $~21$ ribu commit bukan bertipe selain `feat` atau `fix`.

Setelah proses _finetuning_ selesai, model dievaluasi kemampuannya untuk
mengklasifikasikan tiga label independen: `feat`, `fix`, dan `breaking`. Proses
klasifikasi dilakukan dengan memprediksi nilai kepercayaan untuk setiap label,
kemudian menyerapkannya pada aturan yang dijelaskan dalam @t_notation dan
@b_notation. Kemudian bagian testing dari dataset yang digunakan digunakan untuk
dibandingkan dengan hasil nilai kepercayaan masing-masing label. Hasil kinerja
model tercantum pada @model-perf berikut.

#figure(
  table(
    columns: 4,
    table.header([Label], [Presisi], [Recall], [F1-Score]),
    `feat`, $0.91$, $0.88$, $0.89$,
    `fix`, $0.87$, $0.90$, $0.88$,
    `breaking`, $0.75$, $0.68$, $0.71$,
  ),
  caption: [Nilai presisi, recall dan F1 setelah proses _finetuning_ model],
) <model-perf>

= Kesimpulan

== Penelitian Selanjutnya

Model yang dilatih pada penelitian ini hanya melingkupi perubahan-perubahan pada
repository Neovim@neovim_repo. Walaupun repository ini memiliki berbagai ragam
bahasa kode yang digunakan (seperti Vim Script, Lua, C, Python, Shell, dll).
Untuk meningkatkan kinerja model pada analisa bahasa-bahasa lainnya, penelitian
lanjut dapat melakukan pelatihan pada berbagai repository dengan bahasa kode
yang berbeda. Selain itu, penelitian ini hanya mempertimbangkan dua tipe
perubahan yang paling generik (`fix` dan `feat`); walaupun, terdapat berbagai
macam perubahan lain yang sering digunakan (seperti `doc`, `chore` atau
`refactor`). Standar Conventional Commit tidak memberi limitasi untuk tipe yang
dapat digunakan. Penelitian selanjutnya juga dapat merujuk ke generasi tipe
commit (baru maupun yang sudah ada) tergantung kebutuhan perubahan repository.
Lingkup dari penelitian ini juga tidak mempertimbangkan deskripsi rinci dari
sebuah pesan commit. Deskripsi rinci tersebut dapat digunakan sebagai parameter
atau fitur klasifikasi; walaupun, pengembang harus menulis rincian tersebut
terlebih dahulu. Untuk menanggulangi sifat ini, proses generasi deskripsi rinci
juga dapat dilakukan menggunakan transformer CodeT5+ atau model-model LLM
lainnya. Sedangkan untuk mempermudah dan meningkatkan sifat intuitif dari
penggunaan model pada penelitian ini, sebuah _wrapper_ antarmuka pengguna (UI)
dapat dikembangkan. Antarmuka yang dikembangkan sebaiknya berbentuk setara
dengan bentuk utama antarmuka Git, yaitu bentuk Command Line Interface (CLI).

// TODO: penelitian selanjutnya
// - categorical wrapper (pos-processing)
// - correlation between the likeliness of breaking changes and feat types
// - bias neovim

#bibliography("refs.bib")

// TODO: catatan uas li
// - hasil merupakan hipotesa
// - metode penulisan (citation, typst, etc)
