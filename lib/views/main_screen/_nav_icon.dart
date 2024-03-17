part of '../main_screen/main_screen.dart';

class NavIcon extends StatelessWidget {
  final String path;
  final bool? active;
  
  final bool? isProfile;
  const NavIcon(
      {Key? key,
      required this.path,
      this.active = false,
      this.isProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: SizedBox(
        // height: 50.fh,
        // width: 40.fw,
        child: SvgPicture.asset(
          path,
          fit: BoxFit.contain,
          color: active == false
              ? inDarkMode(context) ? greyColor : Colors.white
              // isZotv == true
              //     ? AppTheme.slateGrayColor
              //     : Colors.white70
              : primaryColor,
        ),
      ),
    );
  }
}
