# awan

Projek untuk mendapatkan segala info berkaitan pengangkutan awam di kawasan Lembah Klang

## Memulakan

1. dapatkan projek di https://github.com/zaiehilmi/awan.git
2. pastikan buat step dalam ni untuk setup token. kalau tak buat tak boleh run
   projek [Mapbox SDK for Flutter](https://docs.mapbox.com/flutter/maps/guides/install/)
2. dapatkan pakej
    ```shell
   flutter pub get
    ```
3. jalankan
    ```shell
   dart run build_runner build
    ```
   atau untuk pembangunan
   ```shell
    dart run build_runner watch 
   ```
4. sedia untuk jalankan projek
    ```shell
    flutter run
    ```


## Nota Untuk Pembangun

### Susunan kod
Letakkan penanda (mark) pada kod berdasarkan hierarki keutamaan berikut:

| Penanda                | Tujuan                                                                                       |
|------------------------|----------------------------------------------------------------------------------------------|
| Komponen UI 🖼         | komponen Widget UI di dalam Widget umum                                                      |
| Interaksi 🫵           | sebarang interaksi/input yang diberikan oleh pengguna                                        |
| Logik 🎨               | sebarang logik untuk widget berfungsi                                                        |
| Kitar hayat luaran ⭕️  | untuk kitar hayat di umum seperti yang terdapat pada `StatelessWidget` atau `StatefulWidget` |
| Kitar hayat dalaman 🔴 | untuk kitar hayat di dalam build. biasanya untuk hooks seperti `useEffect()`                 |
| Mula membina 📦        | letakkan sebelum return pada `build()`                                                       |

#### Semua Penanda
salin dan tampal jika baru memulakan penciptaan widget baharu.
```dart
// MARK: Komponen UI 🖼
// MARK: Interaksi 🫵
// MARK: Logik 🎨  
// MARK: Kitar hayat luaran ⭕
// MARK: Kitar hayat dalaman 🔴
// MARK: Mula membina 📦  
```

> #### Cara meletakkan penanda
> ```dart
> final lala = "Sila pastikan ia dipisahkan dengan sekurang-kurangnya 1 baris kosong";
>
> // MARK: Kitar hayat dalaman 🔴
> 
> useEffect();
> ```


