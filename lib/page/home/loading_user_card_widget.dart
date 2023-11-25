import 'package:chat_ju/const/globalcolor.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../const/const.dart';
import '../../const/utilies.dart';

class LoadingUserCardWidget extends StatelessWidget {
  const LoadingUserCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context);
    mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mq.width * .02,
      ),
      child: Card(
          color: white,
          elevation: .5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Shimmer.fromColors(
            baseColor: utils.baseShimmerColor,
            highlightColor: utils.highlightShimmerColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                title: Container(
                  width: mq.width,
                  height: mq.height * .018,
                  color: utils.widgetShimmerColor,
                ),
                subtitle: Container(
                  height: mq.height * .018,
                  width: mq.width,
                  color: utils.widgetShimmerColor,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: mq.height * .075,
                    width: mq.height * .075,
                    color: utils.widgetShimmerColor,
                  ),
                ),
                trailing: Container(
                  height: mq.height * .018,
                  width: mq.width * .035,
                  decoration: BoxDecoration(
                      color: utils.widgetShimmerColor, shape: BoxShape.circle),
                ),
              ),
            ),
          )),
    );
  }
}
