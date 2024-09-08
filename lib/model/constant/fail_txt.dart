enum FailTxt {
  agensi('agency'),
  kalendar('calendar'),
  // tarikhKalendar('calendar_dates'),
  frekuensi('frequencies'),
  laluan('routes'),
  bentuk('shapes'),
  waktuBerhenti('stop_times'),
  hentian('stops'),
  perjalanan('trips');

  final String nama;

  const FailTxt(this.nama);
}
