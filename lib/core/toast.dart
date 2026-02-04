
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class Toaster {
  Toaster._();

  static showLoading() {
    BotToast.showCustomLoading(
      toastBuilder: (_) {
        return const LoadingWidget();
      },
      backButtonBehavior: BackButtonBehavior.ignore,

    );
  }

  static closeAllLoading() {
    BotToast.closeAllLoading();
  }

  static showText({required String text}) {
    BotToast.showText(text: text);
  }

  static showNotification({ required String title}) {
    BotToast.showText(text: title);
  }

}


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 225,
        child: Stack(
          alignment: Alignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
