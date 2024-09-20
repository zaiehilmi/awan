import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../database/dao/berkaitan_pemetaanPeta.dart';
import '../../service/state/vm_lokal.dart';

@Deprecated('Sila gunakan pakej dari mapbox untuk mengurangkan kadar bayaran')
class Peta extends HookWidget {
  final String kodLaluan;

  const Peta({super.key, required this.kodLaluan});

  @override
  Widget build(BuildContext context) {
    final lukis = useState<List<LatLng>>([]);

    useEffect(() {
      Future<void> runAsync() async {
        final daoPeta = DaoBerkaitanPemetaanPeta(lokalState.db);

        lukis.value =
            await daoPeta.lukisLaluanBerdasarkan(kodLaluan: kodLaluan) ?? [];
      }

      runAsync();

      return null;
    }, []);

    return Flexible(
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(2.98264014924525, 101.66798127599606),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/zaiehilmi/cm16iq11801wl01pi1hvx0o0x/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiemFpZWhpbG1pIiwiYSI6ImNsazNkdTFreDAweHYzY3BlcHU2OXBlanAifQ.qSrZJUinzQt07T0zpEK_Pw',
            userAgentPackageName: 'io.zaie.awan',
            maxNativeZoom: 19,
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: lukis.value,
                strokeWidth: 5,
              ),
            ],
          )
        ],
      ),
    );
  }
}
