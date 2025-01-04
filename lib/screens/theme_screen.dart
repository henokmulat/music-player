// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  Future<void> _updateThemeFromImage(
      BuildContext context, String imagePath) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(imagePath),
      maximumColorCount: 10,
    );
    final primaryColor = paletteGenerator.dominantColor?.color ?? Colors.yellow;
    final accentColor = paletteGenerator.paletteColors.length > 1
        ? paletteGenerator.paletteColors[1].color
        : primaryColor;
    if (mounted) {
      Provider.of<ThemeProvider>(this.context, listen: false)
          .updateThemeFromColors(primaryColor, accentColor);
      Provider.of<ThemeProvider>(this.context, listen: false)
          .updateBackgroundImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Themes"),
      ),
      body: SafeArea(
          child: SizedBox.expand(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.5,
          ),
          children: [
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/cross.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/cross.jpg"),
                        fit: BoxFit.cover)),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/batman.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/batman.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/one.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/one.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/two.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/two.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/three.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/three.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/four.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/four.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/ten.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/ten.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/moon.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/moon.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/catwoman.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/catwoman.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/monk.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/monk.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/ethiopia.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/ethiopia.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/nature.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/nature.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/road.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/road.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/spiderman.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/spiderman.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(
                    context, "assets/images/spidermanjump.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/spidermanjump.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/ronaldo.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/ronaldo.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/lionelmessi.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/lionelmessi.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/five.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/five.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/sigma.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/sigma.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/first.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/first.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/eleven.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/eleven.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/twelve.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/twelve.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/phone.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/phone.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/second.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/second.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/seven.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/seven.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/six.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/six.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/ice.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/ice.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/eight.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/eight.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/nine.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/nine.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                _updateThemeFromImage(context, "assets/images/seventh.jpg");
              },
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/seventh.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
