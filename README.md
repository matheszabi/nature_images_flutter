# nature_images_flutter.

This example:
- has a working splash screen, not just a 1x1 pixel image stretched to full screen, but a full size image.
- has application icons ( generated with a library, which is removed, because it is a one-time use tool).
- has a loading screen (with 3 color gradients) and a status message about what is doing right now.
- the loading screen when it finishes and it will go to home screen, it will remove the possibility to come back to this screen (Android press the Back button) 
- It will do an HTTP GET and it will receive a JSON and it will parse it to "model" objects. Plain Old Dart Objects (podo).
- It will load the thumbnails (smaller images) and it will build a list.
- with Prev and Next it implemented the infinite scrolling list.
- clicking on the list it shows the detail of the element (another info wich is a bigger, scrollable image).


iOS: - list with with thumbnails
![ios screenshot1](/screenshots_iOS/flutter_01.png?raw=true "Optional Title")

iOS: - details screen (tap on list view element)
![ios screenshot2](/screenshots_iOS/flutter_02.png?raw=true "Optional Title")

iOS: - loading screen 
![ios screenshot5](/screenshots_iOS/flutter_05.png?raw=true "Optional Title")


Android: loading screen connection checking 
![android screenshot1](/screenshots_Android/flutter_01.png?raw=true "Optional Title")


Android: thumbnails loaded
![android screenshot2](/screenshots_Android/flutter_02.png?raw=true "Optional Title")

Android: list with 3rd page 
![android screenshot3](/screenshots_Android/flutter_03.png?raw=true "Optional Title")
