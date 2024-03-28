بسم الله الرحمن الرحيم

قَدْ أَفْلَحَ الْمُؤْمِنُونَ ۝ الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ۝ 
صدق الله العظيم 

من هنا نحاول ان نسهل على المصليين تحويل الهواتف الى وضع الصامت او وضع عدم الازعاج عند تواجدهم داخل المساجد واعادة الوضع كما كان بمجرد الخروج من المسجد

  ## How it works
  - Track user location in the time frame of the Salah, 15 minutes before and after salah time, so if prayer in the range of the mosque, the mobile will auto change the mode, 
  
  ### Prerequisites

at the current state you have to install the pre requisites manually at more advanced state can setup the 
* Swiftlint
  ```sh
  brew install swiftlint
  ```
* SwiftFormat
  ```sh
  $ brew install swiftformat
  ```

### Installation
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app



<!-- Architecture -->
## Architecture

Using a modular architecture where you have couple of modules contains the functionality could be used later on by SPM or on other choice according to the business logic and tech team needs. 

Used basic MVVVM architecture to apply the use case needs, for more advanced usage could be there better alternative like RIBs, Viper, Clean Architecture, ...etc

Used both [SwiftLint](https://github.com/realm/SwiftLint), [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) by Homebrew. 



## Folders Structure
* Modules: Include separate modules, components, extensions, ...etc.
* Scenes: Group of app UI screens.



## TODOs: 
1. add Setting page, to enable users to add new mosque [BE] is required, @phase3
2.  
3.  
