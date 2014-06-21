UDropCabin
==========

Try UDropBox:
1. install ubuntu touch emulator at https://wiki.ubuntu.com/Touch/Emulator
2. download package at https://github.com/bobo1993324/UDropCabin/releases/tag/0.1
3. install com.ubuntu.developer.bobo1993324.udropcabin_0.1_armhf.click:
      - start Ubuntu Touch emulator
      - $ adb push com.ubuntu.developer.bobo1993324.udropcabin_0.1_armhf.click /home/phablet
      - $ adb shell
      - $ sudo su phablet
      - $ cd
      - $ pkcon install-local com.ubuntu.developer.bobo1993324.udropcabin_0.1_armhf.click
      You should see app UDropCabin after restarting the emulator.
4. Open Dropbox file in other application
      - in Ubuntu Touch emulator start browser, go to http://mozilla.github.io/pdf.js/web/viewer.html
      - click "Open" button on the toolbar
      - Select UDropCabin for source of file
      
UDropbox app for Ubuntu
This is an UNOFFICIAL Dropbox app. You can list files, download them locally, and later open them in other applications.
Thanks to QtDropbox(http://lycis.github.io/QtDropbox/) which provides api the app calls.

BUILD:
    ./build.sh
    ./package.sh
    
INSTALL
    pkcon install-local com.ubuntu.developer.bobo1993324.udropcabin_0.1_armhf.click
