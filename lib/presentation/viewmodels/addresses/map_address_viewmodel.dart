import 'package:flutter/foundation.dart';

class MapAddressViewModel extends ChangeNotifier {
  final List<String> streets = [
    '2nd Ave','3rd Ave','4th Ave','5th Ave','6th Ave','7th St','8th St','9th St','10th St','11th St','12th St','13th St','14th St','15th St','16th Ave','17th Ave','18th Ave','19th St','20th St','21st St','22nd St','23rd St','24th St','25th St','26th St','27th St','28th St','29th St','30th St','31st St','32nd St','33rd St','34th St','35th St','36th St','37th St','38th St','39th St','40th St','41st St','42nd St','43rd St','44th St','45th St','46th St','47th St','48th St','49th St','50th St','51st St','52nd St','53rd St','54th St','55th St','56th St','57th St','58th St','59th St','60th St','61st St','62nd St','63rd St','64th St','65th St','66th St','67th St','68th St','69th St','70th St','71st St','72nd St','73rd St','74th St','75th St','76th St','77th St','78th St','79th St','80th St','81st St','82nd St','83rd St','84th St','85th St','86th St','87th St','88th St','89th St','90th St','91st St','92nd St','93rd St','94th St','95th St','96th St','97th St','98th St','99th St','100th St','101st St','102nd St','103rd St','104th St','105th St','106th St','107th St','108th St','109th St','110th St','111th St','112th St','113th St','114th St','115th St','116th St','117th St','118th St','119th St','120th St','121st St','122nd St','123rd St','124th St','125th St','126th St','127th St','128th St','129th St','130th St','131st St','132nd St','133rd St','134th St','135th St','136th St','137th St','138th St','139th St','140th St','141st St','142nd St','143rd St','144th St','145th St','146th St','147th St','148th St','149th St','150th St','151st St','152nd St','153rd St','154th St','155th St','156th St','157th St','158th St','159th St','160th St','161st St','162nd St','163rd St','164th St','165th St','166th St','167th St','168th St','169th St','170th St','171st St','172nd St','173rd St','174th St','175th St','176th St','177th St','178th St','179th St','180th St','181st St','182nd St','183rd St','184th St','185th St','186th St','187th St','188th St','189th St','190th St','191st St','192nd St','193rd St','194th St','195th St','196th St','197th St','198th St','199th St','200th St'
  ];

  List<String> filtered = [];
  String selected = '';

  MapAddressViewModel() {
    filtered = List.from(streets);
  }

  void filter(String query) {
    if (query.trim().isEmpty) {
      filtered = List.from(streets);
    } else {
      final q = query.toLowerCase();
      filtered = streets.where((s) => s.toLowerCase().contains(q)).toList();
    }
    notifyListeners();
  }

  void select(String street) {
    selected = street;
    notifyListeners();
  }
}
