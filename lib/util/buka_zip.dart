import 'package:archive/archive_io.dart';

import '../model/constant/jenis_perkhidmatan.dart';
import '../service/tetapan.dart';

List<ArchiveFile> bukaZip(JenisPerkhidmatan perkhidmatan) {
  final kedudukanFail = (Tetapan.filePath == null)
      ? 'out/${perkhidmatan.nama}.zip'
      : '${Tetapan.filePath}/out/${perkhidmatan.nama}.zip';

  final inputStream = InputFileStream(kedudukanFail);
  final arkib = ZipDecoder().decodeBuffer(inputStream);

  return arkib.files;
}
