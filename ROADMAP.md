# Work Breakdown Structure (WBS)

1. Added dependencies
   - flutter pub add just_audio on_audio_query marquee audio_video_progress_bar Lottie permission_handler
2. Added permissions
   - Added android permissions in file android/app/src/main/AndroidManifest.xml
3. Created Project Folder structure
   - Created structure lib directory (structure includes folders like assets, constants, model, etc)
4. Added fonts and animations resources and configured them in **pubspec.yaml**
   - Assets like Exo-Regular.tff, music.json (free animations taken from Lottie website)
5. Added Colors and custom TextStyles
   - added file custom_text_style.dart under utils dir.
   - added file app_color.dart under constants dir.
6. Create Local_Song model under lib/model.
   - will contain the required fields for the local song to use in UI.
7. Create Audio Controller class 
   - will be responsible to control actions for the music like play, pause, next, previous, etc.
8. Creating custom widgets
   - button
   - container
   - bottom_bar
9. Create Home Screen and take audio permission inside home screen.
10. Create Player Screen.
11. feat(audio): integrate local on_audio_query and fix playback
    - Integrate on_audio_query+android-1.3.0 as a local dependency
    - Update permissions to request audio access only
    - Fix play/pause toggle functionality in the Home Music List
12. feat(ui): add animated vinyl player and tone arm
    - Add vinyl record UI component with rotating animation
    - Sync vinyl rotation with song play/pause state
    - Add animated tone arm to simulate a realistic vinyl player experience
