# Work Breakdown Structure (WBS)

1. Added dependencies
   - flutter pub add just_audio on_audio_query marquee audio_video_progress_bar lottie permission_handler
2. Added permissions
   - Added android permissions in file android/app/src/main/AndroidManifest.xml
3. Created Project Folder structure
   - Created structure lib directory (structure includes folders like assets, constants, model, etc)
4. Added fonts and animations resources and configured them in **pubspec.yaml**
   - Assets like Exo-Regular.tff, music.json (free animations taken from lottie website)
5. Added Colors and custom TextStyles
   - added file custom_text_style.dart under utils dir.
   - added file app_color.dart under constants dir.
6. Create Local_Song model under lib/model.
   - will contain the required fields for the local song to use in UI.
7. Create Audio Controller class 
   - will be responsible to control actions for the music like play, pause, next, previous, etc.



## Add in next commit - Added Colors and custom TextStyles