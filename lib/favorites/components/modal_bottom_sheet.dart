import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_note/favorites/components/alert_dialog.dart';
import 'package:fish_note/favorites/components/snack_bar.dart';
import 'package:fish_note/favorites/view/favorites_information.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../signUp/model/location.dart';

void showFavoriteBottomSheet(BuildContext context) {
  showModalBottomSheet(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.6,
    ),
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    builder: (BuildContext context) {
      final UserInformationProvider provider = Provider.of<UserInformationProvider>(context);

      List<Widget> favoriteList =
          provider.favorites.map((favorite) => _buildFavoriteItem(favorite, context)).toList();

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '즐겨찾기',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.separated(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) => favoriteList[index],
                separatorBuilder: (context, index) => const Divider(color: gray2),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildFavoriteItem(Location location, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(location.name, style: body1()),
          const SizedBox(width: 15),
          Text('${location.latlon.latitude}, ${location.latlon.longitude}', style: body1(gray4)),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          // 즐겨찾기 항목 제거 로직 추가
          showDialog(
              context: context, builder: (context) => buildRemoveFavoriteDialog(context, location));
        },
      ),
    ],
  );
}

void showLocationBottomSheet(
    BuildContext context, GeoPoint latlon, TextEditingController controller) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => buildLocationDialog(context, controller, latlon)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: gray2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                '주요 조업 위치 지정',
                style: header4(),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoritesInformation(latlon: latlon))),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: gray2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                '해상 정보 보기',
                style: header4(),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => showLocationModal(context, controller, true, latlon),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: gray2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                '즐겨찾기 추가',
                style: header4(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showLocationModal(
    BuildContext context, TextEditingController controller, bool isFavorite, GeoPoint latlon) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    backgroundColor: backgroundWhite,
    builder: (BuildContext context) {
      final UserInformationProvider provider = Provider.of<UserInformationProvider>(context);

      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          showDialog(
              context: context, builder: (context) => buildCancelDialog(context, isFavorite));
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  isFavorite ? '즐겨찾기에 등록할 별명을 입력해주세요' : '주요 조업 위치의 별명을 입력해주세요',
                  style: header3B(),
                ),
                const SizedBox(height: 18),
                TextField(
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                  controller: controller,
                  cursorColor: primaryBlue500,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: backgroundWhite,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: primaryBlue500,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: primaryBlue500,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: primaryBlue500,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    hintText: '지역 별명을 입력해주세요',
                    hintStyle: body1(gray3),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.text.isEmpty
                      ? () => {}
                      : () {
                          // 별명 등록 로직 추가
                          if (isFavorite) {
                            if (provider.favorites
                                .any((favorite) => favorite.name == controller.text)) {
                              showSnackBar(context, '이미 존재하는 별명입니다');
                              return;
                            } else if (provider.favorites.any((favorite) =>
                                favorite.latlon.latitude == latlon.latitude &&
                                favorite.latlon.longitude == latlon.longitude)) {
                              showSnackBar(context, '이미 존재하는 위치입니다');
                              return;
                            } else if (provider.favorites.length == 10) {
                              showSnackBar(context, '즐겨찾기는 최대 10개까지 등록 가능합니다');
                              return;
                            } else {
                              provider.addFavorite(latlon, controller.text);
                            }
                          } else {
                            provider.setLocation(latlon, controller.text);
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showSnackBar(
                            context,
                            isFavorite ? '해당 위치가 즐겨찾기에 추가되었습니다' : '해당 위치가 주요 조업 위치로 변경되었습니다',
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    backgroundColor: primaryBlue500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('등록하기', style: header4(backgroundWhite)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
