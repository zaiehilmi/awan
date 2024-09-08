# Jadual Objek

> ### Petunjuk
> 🔑 - Primary Key  
> 🗝️ - Foreign Key

## Agensi

|    | Jenis   | Nama       | contoh data                                                                                    | lain-lain |
|----|---------|------------|------------------------------------------------------------------------------------------------|-----------|
| 🔑 | String? | idAgensi   | rapidkl                                                                                        |           |
|    | String  | namaAgensi | MRT Feeder Bus                                                                                 |           |
|    | String  | url        | https://www.myrapid.com.my/traveling-with-us/how-to-travel-with-us/rapid-kl/mrt/mrt-feeder-bus |           |
|    | String  | zonWaktu   | Asia/Kuala_Lumpur                                                                              |           |
|    | String? | noTel      | 03-7885-2585                                                                                   |           |
|    | String? | bahasa     | en                                                                                             |           |


## Bentuk
|    | Jenis  | Nama     | contoh data | lain-lain |
|----|--------|----------|-------------|-----------|
| 🔑 | String | idBentuk | 1000000061  |           |
|    | double | lat      | 3.1498746   |           |
|    | double | lon      | 101.5922941 |           |
|    | int    | susunan  | 1           |           |

## Frekuensi
Hanya terdapat pada data bas KL

|    | Jenis      | Nama         | contoh data                   | lain-lain |
|----|------------|--------------|-------------------------------|-----------|
| 🗝 | String     | idPerjalanan | weekend_U8510_U851002_0       |           |
|    | DateTime   | masaMula     | 2024-01-01 06:30:00.000       |           |
|    | DateTime   | masaTamat    | 2024-01-01 18:25:00.000       |           |
|    | int        | headwaySecs  | 2100                          |           |
|    | TepatMasa? | exactTimes   | TepatMasa.berasaskanFrekuensi |           |

## Hentian
|    | Jenis   | Nama           | contoh data                | lain-lain |
|----|---------|----------------|----------------------------|-----------|
| 🔑 | String  | idHentian      | 1000577                    |           |
|    | String? | namaHentian    | KL2313 TAMAN TASIK KERAMAT |           |
|    | String? | huraianHentian | JLN KERAMAT DALAM          |           |
|    | double? | lat            | 3.1675551801753            |           |
|    | double? | lon            | 101.73405017986            |           |

## Kalendar
|    | Jenis        | Nama        | contoh data | lain-lain |
|----|--------------|-------------|-------------|-----------|
| 🔑 | String       | idKalendar  |             |           |
|    | Ketersediaan | isnin       |             |           |
|    | Ketersediaan | selasa      |             |           |
|    | Ketersediaan | rabu        |             |           |
|    | Ketersediaan | khamis      |             |           |
|    | Ketersediaan | jumaat      |             |           |
|    | Ketersediaan | sabtu       |             |           |
|    | Ketersediaan | ahad        |             |           |
|    | DateTime     | tarikhMula  |             |           |
|    | DateTime     | tarikhAkhir |             |           |

## Laluan
|    | Jenis          | Nama            | contoh data                               | lain-lain |
|----|----------------|-----------------|-------------------------------------------|-----------|
| 🔑 | String         | idLaluan        | 30000060                                  |           |
| 🗝 | String?        | idAgensi        | rapidkl                                   |           |
|    | String?        | namaPendek      | MS01                                      |           |
|    | String         | namaPenuh       | MRT Putrajaya Sentral ~ Dataran Putrajaya |           |
|    | JenisKenderaan | jenisLaluan     | JenisKenderaan.bas                        |           |
|    | String?        | warnaLaluan     | 21618C                                    |           |
|    | String?        | warnaTeksLaluan | FFFFFF                                    |           |

## Perjalanan
|    | Jenis           | Nama               | contoh data                        | lain-lain |
|----|-----------------|--------------------|------------------------------------|-----------|
| 🔑 | String          | idPerjalanan       | 231027010049S7                     |           |
| 🗝 | String          | idLaluan           | 30000009                           |           |
| 🗝 | String          | idPerkhidmatan     | 23102701                           |           |
| 🗝 | String?         | idBentuk           | 1000000061                         |           |
|    | String?         | petunjukPerjalanan | MRT SURIAN - SEK 11 KOTA DAMANSARA |           |
|    | ArahPerjalanan? | idArah             | ArahPerjalanan.satuArah            |           |

## WaktuBerhenti
|    | Jenis     | Nama            | contoh data                         | lain-lain |
|----|-----------|-----------------|-------------------------------------|-----------|
| 🗝 | String    | idPerjalanan    | 231027010001S10                     |           |
| 🗝 | String    | idHentian       | 12002086                            |           |
|    | DateTime? | ketibaan        | 2024-01-01 19:05:00.000             |           |
|    | DateTime? | pelepasan       | 2024-01-01 19:05:00.000             |           |
|    | int       | susunanBerhenti | 1                                   |           |
|    | String?   | petunjuk        | MRT TAMAN MIDAH PINTU B - SRI NILAM |           |
