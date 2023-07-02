import 'package:flex_color_scheme/flex_color_scheme.dart';

var blumineBlueLight = FlexThemeData.light(
  scheme: FlexScheme.blumineBlue,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 9,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

var blumineBlueDark = FlexThemeData.dark(
  scheme: FlexScheme.blumineBlue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

var bigStoneLight = FlexThemeData.light(
  scheme: FlexScheme.bigStone,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 9,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);
var bigStoneDark = FlexThemeData.dark(
  scheme: FlexScheme.bigStone,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);

var bahamaBlueLight = FlexThemeData.light(
  scheme: FlexScheme.bahamaBlue,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 9,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);
var bahamaBlueDark = FlexThemeData.dark(
  scheme: FlexScheme.bahamaBlue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

var materialBaselineLight = FlexThemeData.light(
  scheme: FlexScheme.materialBaseline,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 9,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);
var materialBaselineDark = FlexThemeData.dark(
  scheme: FlexScheme.materialBaseline,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);

var greenLight = FlexThemeData.light(
  scheme: FlexScheme.green,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 9,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);
var greenDark = FlexThemeData.dark(
  scheme: FlexScheme.green,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
);

const String darkModeLight = "light";
const String darkModeDark = "dark";
const String darkModeSystem = "system";

const String blumineBlue = "blumineBlue";
const String bigStone = "bigStone";
const String bahamaBlue = "bahamaBlue";
const String materialBaseline = "materialBaseline";
const String green = "green";

var themesMap = {
  blumineBlue: {darkModeLight: blumineBlueLight, darkModeDark: blumineBlueDark},
  bigStone: {darkModeLight: bigStoneLight, darkModeDark: bigStoneDark},
  bahamaBlue: {darkModeLight: bahamaBlueLight, darkModeDark: bahamaBlueDark},
  materialBaseline: {
    darkModeLight: materialBaselineLight,
    darkModeDark: materialBaselineDark
  },
  green: {darkModeLight: greenLight, darkModeDark: greenDark},
};

const defaultTheme = blumineBlue;

enum DarkModes { darkModeLight, darkModeDark, darkModeSystem }

const defaultDarkMode = darkModeSystem;

final Map<DarkModes, String> darkModesMap = {
  DarkModes.darkModeLight: darkModeLight,
  DarkModes.darkModeDark: darkModeDark,
  DarkModes.darkModeSystem: darkModeSystem,
};
