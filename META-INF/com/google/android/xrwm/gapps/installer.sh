#!/sbin/ash
#This file is part of The Open GApps script of @mfonville.
#
#    The Open GApps scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version, w/Open GApps installable zip exception.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    This Open GApps installer-runtime is because of the Open GApps installable
#    zip exception de-facto LGPLv3 licensed.
#
#    This script of the Open GApps Installer is contains work from the PA GApps of @TKruzze and @osm0sis,
#    PA GApps source is used with permission, under the license that it may be re-used to continue GApps packages.
#
# Last Updated: 20190420
# _____________________________________________________________________________________________________________________
#                                             Define Current Package Variables
# List of GApps packages that can be installed with this installer
pkg_names="pico nano micro mini full stock super";

# Installer Name (32 chars Total, excluding "")
installer_name="Open GApps super 9.0 - ";

req_android_arch="arm64";
req_android_sdk="28";
req_android_version="9.0";

keybd_lib_google="libjni_latinimegoogle.so"
keybd_dec_google="libjni_keyboarddecoder.so"
keybd_lib_aosp="libjni_latinime.so"
faceLock_lib_filename="libfacenet.so";
atvremote_lib_filename="libatv_uinputbridge.so"
WebView_lib_filename="libwebviewchromium.so"
markup_lib_filename="libsketchology_native.so"

# Buffer of extra system space to require for GApps install (9216=9MB)
# This will allow for some ROM size expansion when GApps are restored
buffer_size_kb=9216; small_buffer_size=2048;

# List of GApps files that should NOT be automatically removed as they are also included in (many) ROMs
removal_bypass_list="
";

# Define exit codes (returned upon exit due to an error)
E_ROMVER=20; # Wrong ROM version
E_NOBUILDPROP=25; #No build.prop or equivalent
E_RECCOMPR=30; # Recovery without transparent compression
E_NOSPACE=70; # Insufficient Space Available in System Partition
E_NONOPEN=40; # NON Open GApps Currently Installed
E_ARCH=64; # Wrong Architecture Detected
#_________________________________________________________________________________________________________________
#                                             GApps List (Applications user can Select/Deselect)
core_gapps_list="
defaultetc
defaultframework
googlebackuptransport
googlecontactssync
googlefeedback
googleonetimeinitializer
googlepartnersetup
gmscore
gsfcore
vending
setupwizarddefault
setupwizardtablet
configupdater
extservicesgoogle
extsharedgoogle
carriersetup
gmssetup
backuprestore
soundpicker
";

super_gapps_list="
dmagent
docs
earth
fitness
hangouts
indic
japanese
korean
pinyin
projectfi
sheets
slides
street
zhuyin
gcs
actionsservices
bettertogether
";

stock_gapps_list="
cameragoogle
duo
googlepay
keyboardgoogle
translate
vrservice
androidauto
contactsgoogle
webviewgoogle
dialergoogle
printservicegoogle
storagemanagergoogle
";

full_gapps_list="
books
chrome
cloudprint
drive
keep
movies
music
newsstand
playgames
talkback
";

mini_gapps_list="
clockgoogle
maps
messenger
photos
youtube
calculatorgoogle
taggoogle
carrierservices
";

micro_gapps_list="
calendargoogle
exchangegoogle
gmail
pixellauncher
wallpapers
";

nano_gapps_list="
facedetect
faceunlock
search
speech
batteryusage
platformservicespie
markup
wellbeing
";

pico_gapps_list="
calsync
dialerframework
googletts
packageinstallergoogle
";

tvcore_gapps_list="
configupdater
googlebackuptransport
googlecontactssync
gsfcore
notouch
tvetc
tvframework
tvgmscore
tvvending
extservicesgoogle
extsharedgoogle
";

tvstock_gapps_list="
backdrop
castreceiver
leanbacklauncher
livechannels
overscan
secondscreensetup
secondscreenauthbridge
talkback
tvkeyboardgoogle
tvmovies
tvmusic
tvpackageinstallergoogle
tvplaygames
tvremote
tvsearch
tvwidget
tvyoutube
tvwallpaper
webviewgoogle
packageinstallergoogle
leanbackrecommendations
setupwraith
tvlauncher
tvrecommendations
";

# _____________________________________________________________________________________________________________________
#                                             Default Stock/AOSP Removal List (Stock GApps Only)
default_stock_remove_list="
browser
camerastock
dialerstock
email
gallery
launcher
mms
picotts
webviewstock
";
# _____________________________________________________________________________________________________________________
#                                             Optional Stock/AOSP/ROM Removal List
optional_aosp_remove_list="
boxer
basicdreams
calculatorstock
calendarstock
clockstock
cmaudiofx
cmaccount
cmbugreport
cmfilemanager
cmmusic
cmscreencast
cmsetupwizard
cmupdater
cmwallpapers
cmweatherprovider
dashclock
exchangestock
extservicesstock
extsharedstock
fmradio
galaxy
hexo
holospiral
keyboardstock
lbr0zip
livewallpapers
lockclock
logcat
lrecorder
lsetupwizard
lupdater
mms
mzfilemanager
mzpay
mzsetupwizard
mzupdater
mzweather
noisefield
omniswitch
phasebeam
photophase
phototable
printservicestock
provision
simtoolkit
soundrecorder
storagemanagerstock
studio
sykopath
tagstock
terminal
themes
visualizationwallpapers
wallpapersstock
whisperpush
";
# _____________________________________________________________________________________________________________________
#                                             Stock/AOSP/ROM File Removal Lists
boxer_list="
vendor/bundled-app/Boxer"

browser_list="
app/Bolt
app/Browser
app/Browser2
app/BrowserIntl
app/BrowserProviderProxy
app/Chromium
app/Fluxion
app/Gello
app/Jelly
app/PA_Browser
app/PABrowser
app/YuBrowser
priv-app/BLUOpera
priv-app/BLUOperaPreinstall
priv-app/Browser
priv-app/BrowserIntl"

basicdreams_list="
app/BasicDreams"

# Must be used when GoogleCalculator is installed
calculatorstock_list="
app/Calculator
app/ExactCalculator
app/FineOSCalculator"

# Must be used when GoogleCalendar is installed
calendarstock_list="
app/Calendar
app/MonthCalendarWidget
priv-app/Calendar
app/FineOSCalendar"

# Must be used when GoogleCamera is installed
camerastock_list="
app/Camera
app/Camera2
priv-app/Camera
priv-app/Camera2
priv-app/CameraX
app/MotCamera
app/MtkCamera
app/MTKCamera
priv-app/MotCamera
priv-app/MiuiCamera
priv-app/MtkCamera
priv-app/MTKCamera
app/Snap
priv-app/Snap
app/SnapdragonCamera
priv-app/SnapdragonCamera
app/FineOSCamera"

clockstock_list="
app/DeskClock
app/DeskClock2
app/FineOSDeskClock
app/OmniClockOSS"

cmaccount_list="
priv-app/CMAccount"

cmaudiofx_list="
priv-app/AudioFX"

cmbugreport_list="
priv-app/CMBugReport"

cmfilemanager_list="
app/CMFileManager"

cmmusic_list="
app/Apollo
app/Eleven
priv-app/Eleven
app/Music
app/MusicX
app/Phonograph
app/SnapdragonMusic"

cmscreencast_list="
priv-app/Screencast"

cmsetupwizard_list="
app/CyanogenSetupWizard
priv-app/CyanogenSetupWizard"

cmupdater_list="
priv-app/CMUpdater"

cmwallpapers_list="
app/CMWallpapers"

cmweatherprovider_list="
priv-app/WeatherProvider"

# Must be used when Google Contacts is installed
contactsstock_list="
priv-app/Contacts
priv-app/FineOSContacts"

dashclock_list="
app/DashClock"

# Must be used when Google Dialer is installed
# For now, prevent stock AOSP Dialer (priv-app/Dialer) from being removed, no matter the configuration, on all ROMs
dialerstock_list="
priv-app/FineOSDialer
priv-app/OPInCallUI"

email_list="
app/Email
app/PrebuiltEmailGoogle
priv-app/Email"

exchangestock_list="
app/Exchange2
priv-app/Exchange2"

extservicesstock_list="
priv-app/ExtServices"

extsharedstock_list="
app/ExtShared"

fmradio_list="
app/FM
app/FM2
app/FMRecord
priv-app/FMRadio
priv-app/MiuiRadio"

galaxy_list="
app/Galaxy4"

gallery_list="
app/Gallery
priv-app/Gallery
priv-app/GalleryX
app/Gallery2
priv-app/Gallery2
app/MotGallery
priv-app/MotGallery
app/MediaShortcuts
priv-app/MediaShortcuts
priv-app/MiuiGallery
priv-app/FineOSGallery
priv-app/SnapdragonGallery"

hexo_list="
app/HexoLibre"

holospiral_list="
app/HoloSpiralWallpaper"

# Must be used when GoogleKeyboard is installed
keyboardstock_list="
app/LatinIME
app/MzInput
app/OpenWnn
priv-app/BLUTouchPal
priv-app/BLUTouchPalPortuguesebrPack
priv-app/BLUTouchPalSpanishLatinPack
priv-app/MzInput"

launcher_list="
app/CMHome
app/CustomLauncher3
app/EasyLauncher
app/Fluctuation
app/FlymeLauncher
app/FlymeLauncherIntl
app/Launcher2
app/Launcher3
app/LiquidLauncher
app/Paclauncher
app/SlimLauncher
app/Trebuchet
app/FineOSHome
priv-app/CMHome
priv-app/CustomLauncher3
priv-app/EasyLauncher
priv-app/Fluctuation
priv-app/FlymeLauncher
priv-app/FlymeLauncherIntl
priv-app/Launcher2
priv-app/Launcher3
priv-app/LiquidLauncher
priv-app/MiuiHome
priv-app/Paclauncher
priv-app/SlimLauncher
priv-app/Trebuchet
priv-app/Nox"

lbr0zip_list="
app/Br0Zip"

livewallpapers_list="
app/LiveWallpapers"

lockclock_list="
app/LockClock"

logcat_list="
priv-app/MatLog"

lrecorder_list="
priv-app/Recorder"

lsetupwizard_list="
app/LineageSetupWizard
priv-app/LineageSetupWizard"

lupdater_list="
priv-app/Updater"

mms_list="
app/messaging
priv-app/Mms
priv-app/FineOSMms"

mzfilemanager_list="
app/FileManager"

mzpay_list="
app/MzMPay
app/MzPay"

mzsetupwizard_list="
app/MzSetupWizard"

mzupdater_list="
app/MzUpdate
app/SystemUpdate
app/SystemUpdateAssistant"

mzweather_list="
app/Weather"

noisefield_list="
app/NoiseField"

omniswitch_list="
priv-app/OmniSwitch"

# Must be used when Google PackageInstaller is installed; non-capitalized spelling on Lenovo K3 Note
packageinstallerstock_list="
app/PackageInstaller
priv-app/PackageInstaller
priv-app/packageinstaller"

phasebeam_list="
app/PhaseBeam"

photophase_list="
app/PhotoPhase"

phototable_list="
app/PhotoTable"

picotts_list="
app/PicoTts
priv-app/PicoTts
lib/libttscompat.so
lib/libttspico.so
tts"

printservicestock_list="
app/BuiltInPrintService
app/PrintRecommendationService"

provision_list="
app/Provision
priv-app/Provision"

simtoolkit_list="
app/Stk"

soundrecorder_list="
app/SoundRecorder"

storagemanagerstock_list="
priv-app/StorageManager"

studio_list="
app/VideoEditor"

sykopath_list="
app/Layers"

tagstock_list="
priv-app/Tag"

terminal_list="
app/Terminal"

themes_list="
priv-app/CustomizeCenter
priv-app/ThemeChooser
priv-app/ThemesProvider"

visualizationwallpapers_list="
app/VisualizationWallpapers"

wallpapersstock_list="
app/WallpaperPicker"

webviewstock_list="
app/webview
app/WebView
lib/$WebView_lib_filename
lib64/$WebView_lib_filename
"

whisperpush_list="
app/WhisperPush"
# _____________________________________________________________________________________________________________________
#                                             Permanently Removed Folders
# Pieces that may be left over from AIO ROMs that can/will interfere with these GApps
other_list="
app/BooksStub
app/BookmarkProvider
app/CalendarGoogle
app/CloudPrint
app/DeskClockGoogle
app/EditorsDocsStub
app/EditorsSheetsStub
app/EditorsSlidesStub
app/Gmail
app/Gmail2
app/GoogleCalendar
app/GoogleCloudPrint
app/GoogleHangouts
app/GoogleKeep
app/GoogleLatinIme
app/Keep
app/NewsstandStub
app/PartnerBookmarksProvider
app/PrebuiltBugleStub
app/PrebuiltKeepStub
app/QuickSearchBox
app/Vending
priv-app/GmsCore
priv-app/GoogleNow
priv-app/GoogleSearch
priv-app/GoogleHangouts
priv-app/OneTimeInitializer
priv-app/QuickSearchBox
priv-app/Vending
priv-app/Velvet_update
priv-app/GmsCore_update
";

# Apps from app that need to be installed in priv-app
privapp_list="
app/CanvasPackageInstaller
app/ConfigUpdater
app/GoogleBackupTransport
app/GoogleFeedback
app/GoogleLoginService
app/GoogleOneTimeInitializer
app/GooglePartnerSetup
app/GoogleServicesFramework
app/OneTimeInitializer
app/Phonesky
app/PrebuiltGmsCore
app/SetupWizard
app/Velvet
";

# Stock/AOSP Keyboard lib (and symlink) that are always removed since they are always replaced
reqd_list="
/system/lib/libjni_latinimegoogle.so
/system/lib64/libjni_latinimegoogle.so
/system/app/LatinIME/lib/$arch/libjni_latinimegoogle.so
/system/lib/libjni_keyboarddecoder.so
/system/lib64/libjni_keyboarddecoder.so
/system/app/LatinIME/lib/$arch/libjni_keyboarddecoder.so
";

# Remove from priv-app since it was moved to app and vice-versa or other path changes
obsolete_list="
app/CalculatorGoogle
priv-app/GoogleHome
priv-app/Hangouts
priv-app/PrebuiltExchange3Google
priv-app/talkback
priv-app/Wallet
";

# Old addon.d backup scripts as we will be replacing with updated version during install
oldscript_list="
etc/g.prop
addon.d/70-gapps.sh
";

remove_list="${other_list}${privapp_list}${reqd_list}${obsolete_list}${oldscript_list}";
# _____________________________________________________________________________________________________________________
#                                             Installer Error Messages
arch_compat_msg="INSTALLATION FAILURE: This Open GApps package cannot be installed on this\ndevice's architecture. Please download the correct version for your device.\n";
camera_sys_msg="WARNING: Google Camera has/will not be installed as requested. Google Camera\ncan only be installed during a Clean Install or as an update to an existing\nGApps Installation.\n";
camera_compat_msg="WARNING: Google Camera has/will not be installed as requested. Google Camera\nis NOT compatible with your device if installed on the system partition. Try\ninstalling from the Play Store instead.\n";
cmcompatibility_msg="WARNING: PackageInstallerGoogle is not installed. Cyanogenmod is NOT\ncompatible with some Google Applications and Open GApps\n will skip their installation.\n";
dialergoogle_msg="WARNING: Google Dialer has/will not be installed as requested. Dialer Framework\nmust be added to the GApps installation if you want to install the\nGoogle Dialer.\n";
faceunlock_msg="NOTE: FaceUnlock can only be installed on devices with a front facing camera.\n";
googlenow_msg="WARNING: Google Now Launcher has/will not be installed as requested. Google Search\nmust be added to the GApps installation if you want to install the\nGoogle Now Launcher.\n";
messenger_msg="WARNING: Google Messages has/will not be installed as requested. Carrier Services\nmust be added to the GApps installation on Android 6.0+ if you want to install\nGoogle Messages.\n";
pixellauncher_msg="WARNING: Pixel Launcher has/will not be installed as requested. Wallpapers and\nGoogle Search must be added to the GApps installation if you want to install\nthe Pixel Launcher.\n";
projectfi_msg="WARNING: Project Fi has/will not be installed as requested. GCS must be\nadded to the GApps installation if you want to install the Project Fi app.\n";
nobuildprop="INSTALLATION FAILURE: The installed ROM has no build.prop or equivalent\n";
nokeyboard_msg="NOTE: The Stock/AOSP keyboard was NOT removed as requested to ensure your device\nwas not accidentally left with no keyboard installed. If this was intentional,\nyou can add 'Override' to your gapps-config to override this protection.\n";
nolauncher_msg="NOTE: The Stock/AOSP Launcher was NOT removed as requested to ensure your device\nwas not accidentally left with no Launcher. If this was your intention, you can\nadd 'Override' to your gapps-config to override this protection.\n";
nomms_msg="NOTE: The Stock/AOSP MMS app was NOT removed as requested to ensure your device\nwas not accidentally left with no way to receive text messages. If this WAS\nintentional, add 'Override' to your gapps-config to override this protection.\n";
nowebview_msg="NOTE: The Stock/AOSP WebView was NOT removed as requested to ensure your device\nwas not accidentally left with no WebViewProvider installed. If this was intentional,\nyou can add 'Override' to your gapps-config to override this protection.\n";
non_open_gapps_msg="INSTALLATION FAILURE: Open GApps can only be installed on top of an existing\nOpen GApps installation. Since you are currently using another GApps package, you\nwill need to wipe (format) your system partition before installing Open GApps.\n";
fornexus_open_gapps_msg="NOTE: The installer detected that you already have Stock ROM GApps installed.\nThe installer will now continue, but please be aware that there could be problems.\n";
recovery_compression_msg="INSTALLATION FAILURE: Your ROM uses transparent compression, but your recovery\ndoes not support this feature, resulting in corrupt files.\nPlease update your recovery before flashing ANY package to prevent corruption.\n";
rom_android_version_msg="INSTALLATION FAILURE: This GApps package can only be installed on a $req_android_version.x ROM.\n";
simulation_msg="TEST INSTALL: This was only a simulated install. NO CHANGES WERE MADE TO YOUR\nDEVICE. To complete the installation remove 'Test' from your gapps-config.\n";
stubwebview_msg="NOTE: Stub WebView was installed instead of Google WebView because your device\nhas already Chrome installed as WebViewProvider. If you still want Google WebView,\nyou can add 'Override' to your gapps-config to override this redundancy protection.\n";
system_space_msg="INSTALLATION FAILURE: Your device does not have sufficient space available in\nthe system partition to install this GApps package as currently configured.\nYou will need to switch to a smaller GApps package or use gapps-config to\nreduce the installed size.\n";
user_multiplefound_msg="NOTE: All User Application Removals included in gapps-config were unable to be\nprocessed as requested because multiple versions of the app were found on your\ndevice. See the log portion below for the name(s) of the application(s).\n";
user_notfound_msg="NOTE: All User Application Removals included in gapps-config were unable to be\nremoved as requested because the files were not found on your device. See the\nlog portion below for the name(s) of the application(s).\n";
vrservice_compat_msg="WARNING: Google VR Services has/will not be installed as requested.\nGoogle VR Services is NOT compatible with your device.\n";
del_conflict_msg="!!! WARNING !!! - Duplicate files were found between your ROM and this GApps\npackage. This is likely due to your ROM's dev including Google proprietary\nfiles in the ROM. The duplicate files are shown in the log portion below.\n";

nogooglecontacts_removal_msg="NOTE: The Stock/AOSP Contacts is not available on your\nROM (anymore), the Google equivalent will not be removed."
nogoogledialer_removal_msg="NOTE: The Stock/AOSP Dialer is not available on your\nROM (anymore), the Google equivalent will not be removed."
nogooglekeyboard_removal_msg="NOTE: The Stock/AOSP Keyboard is not available on your\nROM (anymore), the Google equivalent will not be removed."
nogooglepackageinstaller_removal_msg="NOTE: The Stock/AOSP Package Installer is not\navailable on your ROM (anymore), the Google equivalent will not be removed."
nogoogletag_removal_msg="NOTE: The Stock/AOSP NFC Tag is not available on your\nROM (anymore), the Google equivalent will not be removed."
nogooglewebview_removal_msg="NOTE: The Stock/AOSP WebView is not available on your\nROM (anymore), not all Google WebViewProviders will be removed."

# _____________________________________________________________________________________________________________________
#                      Detect A/B partition layout https://source.android.com/devices/tech/ota/ab_updates
#                      and system-as-root https://source.android.com/devices/bootloader/system-as-root
if [ -n "$(cat /proc/cmdline | grep slot_suffix)" ];
then
  device_abpartition=true
  SYSTEM=/system/system
  VENDOR=/vendor/vendor
elif [ -n "$(cat /proc/mounts | grep /system_root)" ];
then
  device_abpartition=true
  SYSTEM=/system_root/system
  VENDOR=/vendor
else
  device_abpartition=false
  SYSTEM=/system
  VENDOR=/vendor
fi

# _____________________________________________________________________________________________________________________
#                                                  Declare Variables
zip_folder="$(dirname "$OPENGAZIP")";
g_prop=$SYSTEM/etc/g.prop
PROPFILES="$g_prop $SYSTEM/default.prop $SYSTEM/build.prop $VENDOR/build.prop /data/local.prop /default.prop /build.prop"
bkup_tail=$TMP/bkup_tail.sh;
gapps_removal_list=$TMP/gapps-remove.txt;
g_log=$TMP/g.log;
calc_log=$TMP/calc.log;
conflicts_log=$TMP/conflicts.log;
rec_cache_log=/cache/recovery/log;
rec_tmp_log=$TMP/recovery.log;
user_remove_notfound_log=$TMP/user_remove_notfound.log;
user_remove_multiplefound_log=$TMP/user_remove_multiplefound.log;

log_close="# End Open GApps Install Log\n";

reclaimed_gapps_space_kb=0;
reclaimed_removal_space_kb=0;
reclaimed_aosp_space_kb=0;
total_install_size_kb=0;
# _____________________________________________________________________________________________________________________
#                                                  Define Functions
abort() {
  quit;
  ui_print "- NO changes were made to your device";
  ui_print " ";
  ui_print "Installer will now exit...";
  ui_print " ";
  ui_print "Error Code: $1";
  sleep 5;
  exxit "$1";
}

ch_con() {
  chcon -h u:object_r:system_file:s0 "$1";
}

checkmanifest() {
  if [ -f "$1" ] && ("$TMP/unzip-$BINARCH" -ql "$1" | grep -q "META-INF/MANIFEST.MF"); then  # strict, only files
    "$TMP/unzip-$BINARCH" -p "$1" "META-INF/MANIFEST.MF" | grep -q "$2"
    return "$?"
  else
    return 0
  fi
}

complete_gapps_list() {
  cat <<EOF
$full_removal_list
EOF
}

contains() {
  case "$1" in
    *"$2"*) return 0;;
    *)      return 1;;
  esac;
}

clean_inst() {
  if [ -f /data/system/packages.xml ] && [ "$forceclean" != "true" ]; then
    return 1;
  fi;
  return 0;
}

exists_in_zip(){
  "$TMP/unzip-$BINARCH" -l "$OPENGAZIP" "$1" | grep -q "$1"
  return $?
}

extract_app() {
  tarpath="$TMP/$1.tar" # NB no suffix specified here
  if "$TMP/unzip-$BINARCH" -o "$OPENGAZIP" "$1.tar*" -d "$TMP"; then # wildcard for suffix
    app_name="$(basename "$1")"
    which_dpi "$app_name"
    echo "Found $1 DPI path: $dpiapkpath"
    folder_extract "$tarpath" "$dpiapkpath" "$app_name/common"
  else
    echo "Failed to extract $1.tar* from $OPENGAZIP"
  fi
}

exxit() {
  set_progress 0.98
  if [ "$skipvendorlibs" = "true" ]; then
    umount $SYSTEM/vendor  # unmount tmpfs
  fi
  if ( ! grep -qiE '^ *nodebug *($|#)+' "$g_conf" ); then
    if [ "$g_conf" ]; then # copy gapps-config files to debug logs folder
      cp -f "$g_conf_orig" "$TMP/logs/gapps-config_original.txt"
      cp -f "$g_conf" "$TMP/logs/gapps-config_processed.txt"
    fi
    ls -alZR $SYSTEM > "$TMP/logs/System_Files_After.txt"
    df -k > "$TMP/logs/Device_Space_After.txt"
    cp -f "$log_folder/open_gapps_log.txt" "$TMP/logs"
    for f in $PROPFILES; do
      cp -f "$f" "$TMP/logs"
    done
    cp -f "$SYSTEM/addon.d/70-gapps.sh" "$TMP/logs"
    cp -f "$gapps_removal_list" "$TMP/logs/gapps-remove_revised.txt"
    cp -f "$rec_cache_log" "$TMP/logs/Recovery_cache.log"
    cp -f "$rec_tmp_log" "$TMP/logs/Recovery_tmp.log"
    curLD="$LD_LIBRARY_PATH"
    unset LD_LIBRARY_PATH
    logcat -d -f "$TMP/logs/logcat"
    export LD_LIBRARY_PATH="$curLD"
    cd "$TMP"
    tar -cz -f "$log_folder/open_gapps_debug_logs.tar.gz" logs/*
    cd /
  fi
  find $TMP/* -maxdepth 0 ! -path "$rec_tmp_log" -exec rm -rf {} +
  set_progress 1.0
  ui_print "- Unmounting $mounts"
  ui_print " "
  for m in $mounts; do
    case $m in
      /system)
        if [ "$device_abpartition" = "true" ]; then
          mount -o ro /system
        else
          umount /system
        fi;;
      *) umount "$m";;
    esac
  done
  exit "$1"
}

folder_extract() {
  archive="$1"
  shift
  if [ -e "$archive.xz" ]; then
    for f in "$@"; do
      if [ "$f" != "unknown" ]; then
        "$TMP/xzdec-$BINARCH" "$archive.xz" | "$TMP/tar-$BINARCH" -x -C "$TMP" -f - "$f" && install_extracted "$f"
      fi
    done
    rm -f "$archive.xz"
  elif [ -e "$archive.lz" ]; then
    for f in "$@"; do
      if [ "$f" != "unknown" ]; then
        "$TMP/tar-$BINARCH" -xf "$archive.lz" -C "$TMP" "$f" && install_extracted "$f"
      fi
    done
    rm -f "$archive.lz"
  elif [ -e "$archive" ]; then
    for f in "$@"; do
      if [ "$f" != "unknown" ]; then
        "$TMP/tar-$BINARCH" -xf "$archive" -C "$TMP" "$f" && install_extracted "$f"
      fi
    done
    rm -f "$archive"
  fi
}

get_apparch() {
  if [ -z "$2" ]; then  # no arch given
    apparch="$arch"
  else
    apparch="$2"
  fi
  if exists_in_zip "$1-$apparch.*"; then  # add the . to make sure it is not a substring being matched
    return 0
  else
    get_fallback_arch "$apparch"
    if [ "$apparch" != "$fallback_arch" ]; then
      get_apparch "$1" "$fallback_arch"
      return $?
    else
      apparch=""  # No arch-specific package
      return 1
    fi
  fi
}

get_apparchives(){
  apparchives=""
  if get_apparch "$1"; then
    apparchives="$1-$apparch"
  fi
  if exists_in_zip "$1-common.*"; then
    apparchives="$1-common $apparchives"
  fi
  if exists_in_zip "$1-lib-$arch.*"; then
    apparchives="$1-lib-$arch $apparchives"
  fi
  if [ -n "$fbarch" ] && exists_in_zip "$1-lib-$fbarch.*"; then
    apparchives="$1-lib-$fbarch $apparchives"
  fi
}

get_appsize() {
  app_name="$(basename "$1")"
  which_dpi "$app_name"
  app_density="$(basename "$dpiapkpath")"
  case $preodex in
    true*) odexsize="|odex";;
    *) odexsize="";;
  esac
  appsize="$(cat $TMP/app_sizes.txt | grep -E "$app_name.*[[:blank:]]($app_density|common$odexsize)[[:blank:]]" | awk 'BEGIN { app_size=0; } { folder_size=$3; app_size=app_size+folder_size; } END { printf app_size; }')"
}

get_fallback_arch(){
  case "$1" in
    arm)    fallback_arch="all";;
    arm64)  fallback_arch="arm";;
    x86)    fallback_arch="arm";; #by using libhoudini
    x86_64) fallback_arch="x86";; #e.g. chain: x86_64->x86->arm->all
    *)      fallback_arch="$1";; #return original arch if no fallback available
  esac
}

get_file_prop() {
  grep -m1 "^$2=" "$1" | cut -d= -f2
}

get_prop() {
  #check known .prop files using get_file_prop
  for f in $PROPFILES; do
    if [ -e "$f" ]; then
      prop="$(get_file_prop "$f" "$1")"
      if [ -n "$prop" ]; then
        break #if an entry has been found, break out of the loop
      fi
    fi
  done
  #if prop is still empty; try to use recovery's built-in getprop method; otherwise output current result
  if [ -z "$prop" ]; then
    getprop "$1" | cut -c1-
  else
    printf "$prop"
  fi
}

install_extracted() {
  file_list="$(find "$TMP/$1/" -mindepth 1 -type f | cut -d/ -f5-)"
  dir_list="$(find "$TMP/$1/" -mindepth 1 -type d | cut -d/ -f5-)"
  for file in $file_list; do
      install -D "$TMP/$1/${file}" "$SYSTEM/${file}"
      ch_con "$SYSTEM/${file}"
      set_perm 0 0 644 "$SYSTEM/${file}";
  done
  for dir in $dir_list; do
    ch_con "$SYSTEM/${dir}"
    set_perm 0 0 755 "$SYSTEM/${dir}";
  done
  case $preodex in
    true*)
      installedapkpaths="$(find "$TMP/$1/" -name "*.apk" -type f | cut -d/ -f5-)"
      for installedapkpath in $installedapkpaths; do  # TODO fix spaces-handling
        if ! checkmanifest "$SYSTEM/$installedapkpath" "classes.dex"; then
          ui_print "- pre-ODEX-ing $gapp_name";
          log "pre-ODEX-ing" "$gapp_name";
          odexapk "$SYSTEM/$installedapkpath"
        fi
      done
    ;;
  esac
  bkup_list=$'\n'"${file_list}${bkup_list}"
  rm -rf "$TMP/$1"
}

log() {
  printf "%31s | %s\n" "$1" "$2" >> $g_log;
}

log_add() {
  printf "%7s | %26s | + %7d | %7d\n" "$1" "$2" "$3" "$4">> $calc_log;
}

log_sub() {
  printf "%7s | %26s | - %7d | %7d\n" "$1" "$2" "$3" "$4">> $calc_log;
}

obsolete_gapps_list() {
  cat <<EOF
$remove_list
EOF
}

odexapk() {
  if [ -f "$1" ]; then  # strict, only files
    apkdir="$(dirname "$1")"
    apkname="$(basename "$1" ".apk")"  # Take note not to use -s, it is not supported in busybox
    install -d "$TMP/classesdex"
    "$TMP/unzip-$BINARCH" -q -o "$1" "classes*.dex" -d "$TMP/classesdex/"  # extract to temporary location first, to avoid potential disk space shortage
    eval '$TMP/zip-$BINARCH -d "$1" "classes*.dex"'
    cp "$TMP/classesdex/"* "$apkdir"
    rm -rf "$TMP/classesdex/"
    dexfiles="$(find "$apkdir" -name "classes*.dex")"
    if [ -n "$dexfiles" ]; then
      dex="LD_LIBRARY_PATH='$SYSTEM/lib:$SYSTEM/lib64' $SYSTEM/bin/dex2oat"
      for d in $dexfiles; do
        dex="$dex --dex-file=\"$d\""
        bkup_list=$'\n'"${d#\$SYSTEM\/}${bkup_list}"  # Backup the dex for re-generating oat in the future
      done
      dex="install -d \"$apkdir/oat/$req_android_arch\" && $dex --instruction-set=\"$req_android_arch\" --oat-file=\"$apkdir/oat/$req_android_arch/$apkname.odex\""
      eval "$dex"
      # Add the dex2oat command to addon.d for re-running during a restore
      sed -i "\:# Re-pre-ODEX APKs (from GApps Installer):a \    $dex" $bkup_tail
    fi
  fi
}

quit() {
  set_progress 0.94;
  install_note=$(echo "${install_note}" | sort -r | sed '/^$/d'); # sort Installation Notes & remove empty lines
  echo ------------------------------------------------------------------ >> $g_log;
  echo -e "$log_close" >> $g_log;

  # Add Installation Notes to log to help user better understand conflicts/errors
  for note in $install_note; do
    eval "error_msg=\$${note}";
    echo -e "$error_msg" >> $g_log;
  done;

  # Add User App Removals NotFound Log if it exists
  if [ -r $user_remove_notfound_log ]; then
    echo -e "$user_notfound_msg" >> $g_log;
    echo "# Begin User App Removals NOT Found (from gapps-config)" >> $g_log;
    cat $user_remove_notfound_log >> $g_log;
    rm -f $user_remove_notfound_log;
    echo -e "# End User App Removals NOT Found (from gapps-config)\n" >> $g_log;
  fi;
  # Add User App Removals MultipleFound Log if it exists
  if [ -r $user_remove_multiplefound_log ]; then
    echo -e "$user_multiplefound_msg" >> $g_log;
    echo "# Begin User App Removals MULTIPLE Found (from gapps-config)" >> $g_log;
    cat $user_remove_multiplefound_log >> $g_log;
    rm -f $user_remove_multiplefound_log;
    echo -e "# End User App Removals MULTIPLE Found (from gapps-config)\n" >> $g_log;
  fi;

  # Add Duplicate Files Log if it exists
  if [ -r $conflicts_log ]; then
    echo -e "$del_conflict_msg" >> $g_log;
    echo "# Begin GApps <> ROM Duplicate File List" >> $g_log;
    cat $conflicts_log >> $g_log;
    rm -f $conflicts_log;
    echo -e "# End GApps <> ROM Duplicate File List\n" >> $g_log;
  fi;

  # Add Installation Calculations to the log if they were performed
  if [ -r $calc_log ]; then
    echo "# Begin GApps Size Calculations" >> $g_log;
    cat $calc_log >> $g_log;
    rm -f $calc_log;
    echo -e "\n# End GApps Size Calculations" >> $g_log;
  fi;

  # Add list of Raw User Application Removals back to end of processed gapps-config for display in gapps log
  if [ -n "$user_remove_list" ]; then
    for user_remove_app_raw in $user_remove_list; do
      echo "(${user_remove_app_raw})" >> "$g_conf";
    done;
  fi;

  set_progress 0.96;
  # Add gapps-config information to the log
  echo -e "\n# Begin User's gapps-config" >> $g_log;
  if [ "$g_conf" ]; then
    cat "$g_conf" >> $g_log;
  else
    echo -n "   *** NOT USED ***" >> $g_log;
  fi;
  echo -e "\n# End User's gapps-config" >> $g_log;

  # Copy logs to proper folder (Same as gapps-config or same as Zip)
  ui_print "- Copying Log to $log_folder";
  ui_print " ";
  cp -f $g_log "$log_folder/open_gapps_log.txt";
  rm -f $g_log;
  set_progress 0.97;
}

set_perm() {
  chown "$1:$2" "$4";
  chmod "$3" "$4";
}

set_progress() { echo "set_progress $1" > "$OUTFD"; }

sys_app() {
  if ( grep -q "codePath=\"$SYSTEM/app/$1" /data/system/packages.xml ); then
    return 0;
  fi;
  return 1;
}

ui_print() {
  echo "ui_print $1" > "$OUTFD";
  echo "ui_print" > "$OUTFD";
}

which_dpi() {
  # Calculate available densities
  app_densities="";
  app_densities="$(cat $TMP/app_densities.txt | grep -E "$1/([0-9-]+|nodpi)/" | sed -r 's#.*/([0-9-]+|nodpi)/.*#\1#' | sort)";
  dpiapkpath="unknown"
  # Check if in the package there is a version for our density, or a universal one.
  for densities in $app_densities; do
    case "$densities" in
      *"$density"*) dpiapkpath="$1/$densities"; break;;
      *nodpi*)      dpiapkpath="$1/nodpi"; break;;
    esac;
  done;
  # Check if density is unknown or set to nopdi and there is not a universal package and select the package with higher density.
  if { [ "$density" = "unknown" ] || [ "$density" = "nopdi" ]; } && [ "$dpiapkpath" = "unknown" ] && [ -n "$app_densities" ]; then
    app_densities="$(echo "$app_densities" | sort -r)"
    for densities in $app_densities; do
      dpiapkpath="$1/$densities";
      break;
    done;
  fi;
  # If there is no package for our density nor a universal one, we will look for the one with closer, but higher density.
  if [ "$dpiapkpath" = "unknown" ] && [ -n "$app_densities" ]; then
    app_densities="$(echo "$app_densities" | sort)"
    for densities in $app_densities; do
      all_densities="$(echo "$densities" | sed 's/-/ /g' | tr ' ' '\n' | sort | tr '\n' ' ')";
      for d in $all_densities; do
        if [ "$d" -ge "$density" ]; then
          dpiapkpath="$1/$densities";
          break 2;
        fi;
      done;
    done;
  fi;
  # If there is no package for our density nor a universal one or one for higher density, we will use the one with closer, but lower density.
  if [ "$dpiapkpath" = "unknown" ] && [ -n "$app_densities" ]; then
    app_densities="$(echo "$app_densities" | sort -r)"
    for densities in $app_densities; do
      all_densities="$(echo "$densities" | sed 's/-/ /g' | tr ' ' '\n' | sort -r | tr '\n' ' ')";
      for d in $all_densities; do
        if [ "$d" -le "$density" ]; then
          dpiapkpath="$1/$densities";
          break 2;
        fi;
      done;
    done;
  fi;
}
# _____________________________________________________________________________________________________________________
#                                                  Gather Pre-Install Info
# Are we on an Android device is or is a really stupid person running this script on their computer?
if [ -e "/etc/lsb-release" ] || [ -n "$OSTYPE" ]; then
  echo "Don't run this on your computer! You need to flash the Open GApps zip on an Android Recovery!"
  exit 1
fi
# Get GApps Version and GApps Type from g.prop extracted at top of script
gapps_version=$(get_file_prop "$TMP/g.prop" "ro.addon.open_version")
gapps_type=$(get_file_prop "$TMP/g.prop" "ro.addon.open_type")
# _____________________________________________________________________________________________________________________
#                                                  Begin GApps Installation
ui_print " ";
ui_print '##############################';
ui_print '  _____   _____   ___   ____  ';
ui_print ' /  _  \ |  __ \ / _ \ |  _ \ ';
ui_print '|  / \  || |__) | |_| || | \ \';
ui_print '| |   | ||  ___/|  __/ | | | |';
ui_print '|  \ /  || |    \ |__  | | | |';
ui_print ' \_/ \_/ |_|     \___| |_| |_|';
ui_print '       ___   _   ___ ___  ___ ';
ui_print '      / __| /_\ | _ \ _ \/ __|';
ui_print '     | (_ |/ _ \|  _/  _/\__ \';
ui_print '      \___/_/ \_\_| |_|  |___/';
ui_print '##############################';
ui_print " ";
ui_print "$installer_name$gapps_version";
ui_print " ";
mounts=""
for p in "/cache" "/data" "/persist" "/system" "/vendor"; do
  if [ -d "$p" ] && grep -q "$p" "/etc/fstab" && ! mountpoint -q "$p"; then
    mounts="$mounts $p"
  fi
done
ui_print "- Mounting $mounts";
ui_print " ";
set_progress 0.01;
for m in $mounts; do
  mount "$m"
done
grep -q "/system.*\sro[\s,]" /proc/mounts && mount -o remount,rw /system  # remount /system, sometimes necessary if mounted read-only

# _____________________________________________________________________________________________________________________
#                                                  Gather Device & GApps Package Information
if [ -z "$(get_prop "ro.build.id")" ]; then
  ui_print "*** No ro.build.id ***"
  ui_print " "
  ui_print "Your ROM has no valid build.prop or equivalent"
  ui_print " "
  ui_print "******* GApps Installation failed *******"
  ui_print " "
  install_note="${install_note}nobuildprop"$'\n'
  abort "$E_NOBUILDPROP"
fi

testcomprfile="$(find $SYSTEM -maxdepth 1 -type f  | head -n 1)" #often this should return the build.prop, but it can be any file for this test
# Check if $testcomprfile if it is exists is not compressed and thus unprocessable
if [ -e "$testcomprfile" ] && [ "$(head -c 4 "$testcomprfile")" = "zzzz" ]; then
  ui_print "*** Recovery does not support transparent compression ***"
  ui_print " "
  ui_print "Your ROM uses transparent compression, but your recovery"
  ui_print "does not support this feature, resulting in corrupt files."
  ui_print " "
  ui_print "BEFORE INSTALLING ANYTHING ANYMORE YOU SHOULD UPDATE YOUR"
  ui_print "RECOVERY AS SOON AS POSSIBLE, TO PREVENT FILE CORRUPTION."
  ui_print " "
  ui_print "******* GApps Installation failed *******"
  ui_print " "
  install_note="${install_note}recovery_compression_msg"$'\n'
  abort "$E_RECCOMPR"
fi

# Get device name any which way we can
for field in ro.product.device ro.build.product ro.product.name; do
  device_name="$(get_prop "$field")"
  if [ "${#device_name}" -ge "2" ]; then
    break
  fi
  device_name="Bad ROM/Recovery"
done

# Locate gapps-config (if used)
for i in "$TMP/aroma/.gapps-config"\
 "$zip_folder/.gapps-config"\
 "$zip_folder/.gapps-config-$device_name"\
 "$zip_folder/.gapps-config-$device_name.txt"\
 "$zip_folder/.gapps-config.txt"\
 "$zip_folder/gapps-config-$device_name.txt"\
 "$zip_folder/gapps-config.txt"\
 "/data/.gapps-config"\
 "/data/.gapps-config-$device_name"\
 "/data/.gapps-config-$device_name.txt"\
 "/data/.gapps-config.txt"\
 "/data/gapps-config-$device_name.txt"\
 "/data/gapps-config.txt"\
 "/persist/.gapps-config"\
 "/persist/.gapps-config-$device_name"\
 "/persist/.gapps-config-$device_name.txt"\
 "/persist/.gapps-config.txt"\
 "/persist/gapps-config-$device_name.txt"\
 "/persist/gapps-config.txt"\
 "/sdcard/.gapps-config"\
 "/sdcard/.gapps-config-$device_name"\
 "/sdcard/.gapps-config-$device_name.txt"\
 "/sdcard/.gapps-config.txt"\
 "/sdcard/gapps-config-$device_name.txt"\
 "/sdcard/gapps-config.txt"\
 "/sdcard/Open-GApps/.gapps-config"\
 "/sdcard/Open-GApps/.gapps-config-$device_name"\
 "/sdcard/Open-GApps/.gapps-config-$device_name.txt"\
 "/sdcard/Open-GApps/.gapps-config.txt"\
 "/sdcard/Open-GApps/gapps-config-$device_name.txt"\
 "/sdcard/Open-GApps/gapps-config.txt"\
 "/tmp/install/.gapps-config"\
 "/tmp/install/.gapps-config-$device_name"\
 "/tmp/install/.gapps-config-$device_name.txt"\
 "/tmp/install/.gapps-config.txt"\
 "/tmp/install/gapps-config-$device_name.txt"\
 "/tmp/install/gapps-config.txt"; do
  if [ -r "$i" ]; then
    g_conf="$i";
    break;
  fi;
done;

# We log in the same directory as the gapps-config file, unless it is aroma
if [ -n "$g_conf" ] && [ "$g_conf" != "$TMP/aroma/.gapps-config" ]; then
  log_folder="$(dirname "$g_conf")";
else
  log_folder="$zip_folder";
fi

if [ "$g_conf" ]; then
  config_file="$g_conf";
  g_conf_orig="$g_conf";
  g_conf="$TMP/proc_gconf";

  sed -r -e 's/\r//g' -e 's|#.*||g' -e 's/^[ \t ]*//g' -e 's/[ \t ]*$//g' -e '/^$/d' "$g_conf_orig" > "$g_conf"; # UNIX line-endings, strip comments+emptylines+spaces+tabs

  # include mentioned as a *whole word* (surrounded by space/tabs or start/end or directly followed by a comment) and is itself NOT a comment (should not be possible because of sed above)
  if ( grep -qiE '^([^#]*[[:blank:]]+)?include($|#|[[:blank:]])' "$g_conf" ); then
    config_type="include"
  else
    config_type="exclude"
  fi
  sed -i -r -e 's/\<(in|ex)clude\>//gI' "$g_conf" # drop in/exclude from the config

  user_remove_list=$(awk -F "[()]" '{ for (i=2; i<NF; i+=2) print $i }' "$g_conf"); # Get users list of apk's to remove from gapps-config
  sed -i -e s/'([^)]*)'/''/g -e '/^$/d' "$g_conf"; # Remove all instances of user app removals (stuff between parentheses) and empty lines we might have created
else
  config_file="Not Used";
  g_conf="$TMP/proc_gconf";
  touch "$g_conf";
fi;

# Unless this is a NoDebug install - create folder and take 'Before' snapshots
if ( ! grep -qiE '^nodebug$' "$g_conf" ); then
  install -d $TMP/logs;
  ls -alZR $SYSTEM > $TMP/logs/System_Files_Before.txt;
  df -k > $TMP/logs/Device_Space_Before.txt;
fi;

# Get ROM Android version
ui_print "- Gathering device & ROM information"
ui_print " "

# Get ROM SDK version
rom_build_sdk="$(get_prop "ro.build.version.sdk")"

# Get Device Type
if echo "$(get_prop "ro.build.characteristics")" | grep -qi "tablet"; then
  device_type=tablet
elif echo "$(get_prop "ro.build.characteristics")" | grep -qi "tv"; then
  device_type=tv
  core_gapps_list="$tvcore_gapps_list"  # use the TV core apps instead of the regular core apps
else
  device_type=phone
fi

echo "# Begin Open GApps Install Log" > $g_log;
echo ------------------------------------------------------------------ >> $g_log;

# Check to make certain user has proper version ROM Installed
if [ ! "$rom_build_sdk" = "$req_android_sdk" ]; then
  ui_print "*** Incompatible Android ROM detected ***";
  ui_print " ";
  ui_print "This GApps pkg is for Android $req_android_version.x ONLY";
  ui_print "Please download the correct version for"
  ui_print "your ROM: $(get_prop "ro.build.version.release") (SDK $rom_build_sdk)"
  ui_print " ";
  ui_print "******* GApps Installation failed *******";
  ui_print " ";
  install_note="${install_note}rom_android_version_msg"$'\n'; # make note that ROM Version is not compatible with these GApps
  abort "$E_ROMVER";
fi;

# Check to make certain that user device matches the architecture
device_architecture="$(get_prop "ro.product.cpu.abilist")"
# If the recommended field is empty, fall back to the deprecated one
if [ -z "$device_architecture" ]; then
  device_architecture="$(get_prop "ro.product.cpu.abi")"
fi

case "$device_architecture" in
  *x86_64*) arch="x86_64"; libfolder="lib64";;
  *x86*) arch="x86"; libfolder="lib";;
  *arm64*) arch="arm64"; libfolder="lib64";;
  *armeabi*) arch="arm"; libfolder="lib";;
  *) arch="unknown";;
esac

for targetarch in arm64 abort; do
  if [ "$arch" = "$targetarch" ]; then
    if [ "$libfolder" = "lib64" ]; then #on 64bit we also need to install 32 bit libs from the fbarch
      get_fallback_arch "$arch"
      fbarch="$fallback_arch"
    else
      fbarch=""
    fi
    break
  elif [ "abort" = "$targetarch" ]; then
    ui_print "***** Incompatible Device Detected *****"
    ui_print " "
    ui_print "This Open GApps package cannot be"
    ui_print "installed on this device's architecture."
    ui_print "Please download the correct version for"
    ui_print "your device: $arch"
    ui_print " "
    ui_print "******* GApps Installation failed *******"
    ui_print " "
    install_note="${install_note}arch_compat_msg"$'\n' # make note that Open GApps are not compatible with architecture
    abort "$E_ARCH"
  fi
done

# Determine Recovery Type and Version
for rec_log in $rec_tmp_log $rec_cache_log; do
  recovery=$(grep -m 2 -E " Recovery v|Starting TWRP|Welcome to|PhilZ|Starting recovery \(" $rec_log);
  case "$recovery" in
    *Welcome*)  recovery="$(grep -m 1 "Welcome to" $rec_log | awk '{ print substr($0, index($0,$3)) }')$(grep -m 1 "^ext.version" $rec_log | cut -d\" -f2)"; break;;
    *Recovery*) recovery=$(grep -m 1 "Recovery v" $rec_log); recovery=${recovery/Recovery v/Recovery }; break;;
    *PhilZ*)    recovery=$(grep -m 2 -E "PhilZ|ClockworkMod" $rec_log); recovery="${recovery/ClockworkMod v/(ClockworkMod })"; break;;
    *Starting\ recovery\ \(*) recovery=$(grep -m 1 "ro.cm.version=" $rec_log| sed -e 's/.*ro.cm.version=/CM Recovery /gI'); break;;
    Starting*) recovery=$(echo "$recovery" | awk -F"Starting " '{ print $2 }' | awk -F" on " '{ print $1 }'); break;;
  esac;
done;

# Get device model
device_model="$(get_prop "ro.product.model")"

# Get display density
density="$(get_prop "ro.sf.lcd_density")"

# Check for DPI Override in gapps-config
if ( grep -qiE '^forcedpi(120|160|213|240|260|280|300|320|340|360|400|420|480|560|640|nodpi)$' "$g_conf" ); then # user wants to override the DPI selection
  density=$( grep -iEo '^forcedpi(120|160|213|240|260|280|300|320|340|360|400|420|480|560|640|nodpi)$' "$g_conf" | tr '[:upper:]'  '[:lower:]' )
  density=${density#forcedpi}
fi

# Set density to unknown if it's still empty
test -z "$density" && density="unknown"

# Check for Camera API v2 availability
cameraapi="$(get_prop "camera2.portability.force_api")"
camerahal="$(get_prop "persist.camera.HAL3.enabled")"
if ( grep -qiE '^forcenewcamera$' "$g_conf" ); then  # takes precedence over any detection
  newcamera_compat="true[forcenewcamera]"
else
  if [ -n "$cameraapi" ]; then  # we check first for the existence of this key, it takes precedence if set to any value
    if [ "$cameraapi" -ge "2" ]; then
      newcamera_compat="true[force_api]"
    else
      newcamera_compat="false[force_api]"
    fi
  elif [ -n "$camerahal" ] && [ "$camerahal" -ge "1" ]; then
    newcamera_compat="true"
  else
    # If not explictly defined, check whitelist
    case $device_name in
      ryu|angler|bullhead|shamu|volantis*|flounder*|hammerhead*|sprout*) newcamera_compat="true[whitelist]";;
      *) newcamera_compat="false";;
    esac
  fi
fi

cmcompatibilityhacks="false"  # test for CM/Lineage since they do weird AOSP-breaking changes to their code, breaking some GApps
case "$(get_prop "ro.build.flavor")" in
  cm_*|lineage_*)
  if [ "$rom_build_sdk" -lt "27" ]; then
  	cmcompatibilityhacks="true";
  fi
  if [ "$rom_build_sdk" -ge "24" ]; then # CMSetupWizard is broken in LineageOS 14+ and can be safely removed on CM14+ as well
  	aosp_remove_list="${aosp_remove_list}cmsetupwizard"$'\n';
  fi;;
esac

# Check for Clean Override in gapps-config
if ( grep -qiE '^forceclean$' "$g_conf" ); then
  forceclean="true"
else
  forceclean="false"
fi

# Check for Pre-Odex support or NoPreODEX Override in gapps-config
if [ "$rom_build_sdk" -lt "23" ]; then
  preodex="false [Only 6.0+]"
elif [ "$(get_prop "persist.sys.dalvik.vm.lib.2")" != "libart.so" ] && [ "$(get_prop "persist.sys.dalvik.vm.lib.2")" != "libart" ]; then
  preodex="false [No ART]"
elif ! command -v "$TMP/zip-$BINARCH" >/dev/null 2>&1; then
  preodex="false [No Info-Zip]"
elif ! command -v "dex2oat" >/dev/null 2>&1; then
  preodex="false [No dex2oat]"
elif ( grep -qiE '^nopreodex$' "$g_conf" ); then
  preodex="false [nopreodex]"
elif ( grep -qiE '^preodex$' "$g_conf" ); then
  preodex="true [preodex]"
else
  preodex="false"  #temporarily changed to false by default until we sort the issues out
fi

# Check for skipswypelibs in gapps-config
if ( grep -qiE '^skipswypelibs$' $g_conf ); then
  skipswypelibs="true"
else
  skipswypelibs="false"
fi

# Check for substituteswypelibs in gapps-config
if ( grep -qiE '^substituteswypelibs$' $g_conf ); then
  substituteswypelibs="true"
else
  substituteswypelibs="false"
fi

# Check for skipvendorlibs in gapps-config
if ( grep -qiE '^skipvendorlibs$' $g_conf ); then
  skipvendorlibs="true"
  mount -t tmpfs tmpfs $SYSTEM/vendor  # by mounting a tmpfs on this location, we hide the existing files from any operations
else
  skipvendorlibs="false"
fi

# Remove any files from gapps-remove.txt that should not be processed for automatic removal
for bypass_file in $removal_bypass_list; do
  sed -i "\:${bypass_file}:d" $gapps_removal_list
done

# Is this a 'Clean' or 'Dirty' install
if ( clean_inst ); then
  install_type="Clean[Data Wiped]"
  cameragoogle_inst=Clean
else
  install_type="Dirty[Data NOT Wiped]"

  # Was Google Camera previously installed (in /system)
  if ( sys_app GoogleCamera ); then
    cameragoogle_inst=true
  else
    cameragoogle_inst=false
  fi
fi

# Is device FaceUnlock compatible
if ( ! grep -qE "Victory|herring|sun4i" /proc/cpuinfo ); then
  for xml in $SYSTEM/etc/permissions/android.hardware.camera.front.xml $SYSTEM/etc/permissions/android.hardware.camera.xml $SYSTEM/vendor/etc/permissions/android.hardware.camera.front.xml $SYSTEM/vendor/etc/permissions/android.hardware.camera.xml; do
    if ( awk -vRS='-->' '{ gsub(/<!--.*/,"")}1' $xml | grep -qr "feature name=\"android.hardware.camera.front" ); then
      faceunlock_compat=true
      break
    fi
    faceunlock_compat=false
  done
else
  faceunlock_compat=false
fi

# Is device VRMode compatible
vrmode_compat=false
for xml in $(grep -rl '<feature name="android.software.vr.mode" />' $SYSTEM/etc/ $SYSTEM/vendor/etc/); do
  if ( awk -vRS='-->' '{ gsub(/<!--.*/,"")}1' $xml | grep -qr '<feature name="android.software.vr.mode" />' $SYSTEM/etc/ $SYSTEM/vendor/etc/ ); then
    vrmode_compat=true
    break
  fi
done

# Check device name for devices that are incompatible with Google Camera
case $device_name in
  *) cameragoogle_compat=true;;
esac;

# Check if Google Pixel
case $device_name in
  marlin|sailfish|walleye|taimen|crosshatch|blueline) googlepixel_compat="true";;
  *)                              googlepixel_compat="false";;
esac

log "ROM Android version" "$(get_prop "ro.build.version.release")"
log "ROM Build ID" "$(get_prop "ro.build.display.id")"
log "ROM Version increment" "$(get_prop "ro.build.version.incremental")"
log "ROM SDK version" "$rom_build_sdk"
log "ROM/Recovery modversion" "$(get_prop "ro.modversion")"
log "Device Recovery" "$recovery"
log "Device Name" "$device_name"
log "Device Model" "$device_model"
log "Device Type" "$device_type"
log "Device CPU" "$device_architecture"
log "Device A/B-partitions" "$device_abpartition"
log "Installer Platform" "$BINARCH"
log "ROM Platform" "$arch"
log "Display Density Used" "$density"
log "Install Type" "$install_type"
log "Smart ART Pre-ODEX" "$preodex"
log "Google Camera already installed" "$cameragoogle_inst"
log "FaceUnlock Compatible" "$faceunlock_compat"
log "VRMode Compatible" "$vrmode_compat"
log "Google Camera Compatible" "$cameragoogle_compat"
log "New Camera API Compatible" "$newcamera_compat"
log "Google Pixel Features" "$googlepixel_compat"

# Determine if a GApps package is installed and
# the version, type, and whether it's an Open GApps package
if [ -e "$SYSTEM/priv-app/GoogleServicesFramework/GoogleServicesFramework.apk" ] || [ -e "$SYSTEM/priv-app/GoogleServicesFramework.apk" ]; then
  openversion="$(get_prop "ro.addon.open_version")"
  if [ -n "$openversion" ]; then
    log "Current GApps Version" "$openversion"
    opentype="$(get_prop "ro.addon.open_type")"
    if [ -z "$opentype" ]; then
      opentype="unknown"
    fi
    log "Current Open GApps Package" "$opentype"
  elif [ -e "$SYSTEM/etc/g.prop" ]; then
    log "Current GApps Version" "NON Open GApps Package Currently Installed (FAILURE)"
    ui_print "* Incompatible GApps Currently Installed *"
    ui_print " "
    ui_print "This Open GApps package can ONLY be installed"
    ui_print "on top of an existing installation of Open GApps"
    ui_print "or a clean AOSP/CyanogenMod ROM installation,"
    ui_print "or a Stock ROM that conforms to Nexus standards."
    ui_print "You must wipe (format) your system partition"
    ui_print "and flash your ROM BEFORE installing Open GApps."
    ui_print " "
    ui_print "******* GApps Installation failed *******"
    ui_print " "
    install_note="${install_note}non_open_gapps_msg"$'\n'
    abort "$E_NONOPEN"
  else
    log "Current GApps Version" "Stock ROM GApps Currently Installed (NOTICE)"
    ui_print "* Stock ROM GApps Currently Installed *"
    ui_print " "
    ui_print "The installer detected that Stock ROM GApps are"
    ui_print "already installed. If you are flashing over a"
    ui_print "Nexus-compatible ROM there is no problem, but if"
    ui_print "you are flashing over a custom ROM, you may want"
    ui_print "to contact the developer to request the removal of"
    ui_print "the included GApps. The installation will now"
    ui_print "continue, but please be aware that any problems"
    ui_print "that may occur depend on your ROM."
    ui_print " "
    install_note="${install_note}fornexus_open_gapps_msg"$'\n'
  fi
else
  # User does NOT have a GApps package installed on their device
  log "Current GApps Version" "No GApps Installed"

  # Did this 6.0+ system already boot and generated runtime permissions
  if [ -e /data/system/users/0/runtime-permissions.xml ]; then
    # Check if permissions were granted to Google Setupwizard, this permissions should always be set in the file if GApps were installed before
    if ! grep -q "com.google.android.setupwizard" /data/system/users/*/runtime-permissions.xml; then
      # Purge the runtime permissions to prevent issues if flashing GApps for the first time on a dirty install
      rm -f /data/system/users/*/runtime-permissions.xml
      log "Runtime Permissions" "Reset"
    fi
  fi

  # Use the opportunity of No GApps installed to check for potential ROM conflicts when deleting existing GApps files
  while read gapps_file; do
    if [ -e "$gapps_file" ] && [ "$gapps_file" != "$SYSTEM/lib/$WebView_lib_filename" ] && [ "$gapps_file" != "$SYSTEM/lib64/$WebView_lib_filename" ]; then
      echo "$gapps_file" >> $conflicts_log
    fi
  done < $gapps_removal_list
fi
# _____________________________________________________________________________________________________________________
#                                                  Prepare the list of GApps being installed and AOSP/Stock apps being removed
# Build list of available GApps that can be installed (and check for a user package preset)
for pkg in $pkg_names; do
  eval "addto=\$${pkg}_gapps_list"; # Look for method to combine this with line below
  all_gapps_list=${all_gapps_list}${addto}; # Look for method to combine this with line above
  if ( grep -qiE "^${pkg}gapps\$" "$g_conf" ); then # user has selected a 'preset' install
    gapps_type=$pkg;
    sed -i "/ro.addon.open_type/c\ro.addon.open_type=$pkg" "$TMP/g.prop"; # modify g.prop to new package type
    break;
  fi;
done;

# Prepare list of User specified GApps that will be installed
if [ "$g_conf" ]; then
  if [ "$config_type" = "include" ]; then # User is indicating the apps they WANT installed
    for gapp_name in $all_gapps_list; do
      if ( grep -qiE "^$gapp_name\$" "$g_conf" ); then
        gapps_list="$gapps_list$gapp_name"$'\n';
      fi;
    done;
  else # User is indicating the apps they DO NOT WANT installed
    for gapp_name in $all_gapps_list; do
      if ( ! grep -qiE "^$gapp_name\$" "$g_conf" ); then
        gapps_list="$gapps_list$gapp_name"$'\n';
      fi;
    done;
  fi;
else # User is not using a gapps-config and we're doing the 'full monty'
  config_type="[Default]";
  gapps_list=$all_gapps_list;
fi;

# Configure default removal of Stock/AOSP apps - if we're installing Stock GApps or larger
if [ "$gapps_type" = "super" ] || [ "$gapps_type" = "stock" ] || [ "$gapps_type" = "aroma" ]; then
  for default_name in $default_stock_remove_list; do
    eval "remove_${default_name}=true[default]";
  done;
else
  # Do not perform any default removals - but make them optional
  for default_name in $default_stock_remove_list; do
    eval "remove_${default_name}=false[default]";
  done;
fi;

# Prepare list of AOSP/ROM files that will be deleted using gapps-config
# We will look for +Browser, +CameraStock, +DialerStock, +Email, +Gallery, +Launcher, +MMS, +PicoTTS and more to prevent their removal
set_progress 0.03;
if [ "$g_conf" ]; then
  for default_name in $default_stock_remove_list; do
    if ( grep -qiE "^\+$default_name\$" "$g_conf" ); then
      eval "remove_${default_name}=false[gapps-config]";
    elif [ "$gapps_type" = "super" ] || [ "$gapps_type" = "stock" ] || [ "$gapps_type" = "aroma" ]; then
      aosp_remove_list="$aosp_remove_list$default_name"$'\n';
      if ( grep -qiE "^$default_name\$" "$g_conf" ); then
        eval "remove_${default_name}=true[gapps-config]";
      fi;
    else
      if ( grep -qiE "^$default_name\$" "$g_conf" ); then
        eval "remove_${default_name}=true[gapps-config]";
        aosp_remove_list="$aosp_remove_list$default_name"$'\n';
      fi;
    fi;
  done;
  # Check gapps-config for other optional AOSP/ROM files that will be deleted
  for opt_name in $optional_aosp_remove_list; do
    if ( grep -qiE "^$opt_name\$" "$g_conf" ); then
      aosp_remove_list="$aosp_remove_list$opt_name"$'\n';
    fi;
  done;
else
  if [ "$gapps_type" = "super" ] || [ "$gapps_type" = "stock" ] || [ "$gapps_type" = "aroma" ]; then
      aosp_remove_list=$default_stock_remove_list;
  fi;
fi;

# Provision folder always has to be removed (it conflicts with SetupWizard)
aosp_remove_list="${aosp_remove_list}provision"$'\n';
# Remove AOSP Android Shared Services in favour of our Google versions of it
aosp_remove_list="${aosp_remove_list}extsharedstock"$'\n'"extservicesstock"$'\n';

# If we're installing chrome and webviewgoogle, replace it with webviewstub unless override removal protection
if ( contains "$gapps_list" "chrome" ) && ( contains "$gapps_list" "webviewgoogle" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
  gapps_list=${gapps_list/webviewgoogle/webviewstub}
  install_note="${install_note}stubwebview_msg"$'\n' # make note that Stub Webview unless user Overrides
fi

# If we're installing webviewgoogle we MUST ADD webviewstub to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "webviewgoogle" ) && ( ! contains "$aosp_remove_list" "webviewstub" ); then
  aosp_remove_list="${aosp_remove_list}webviewstub"$'\n'
fi;

# If we're installing webviewstub we MUST ADD webviewgoogle to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "webviewstub" ) && ( ! contains "$aosp_remove_list" "webviewgoogle" ); then
  aosp_remove_list="${aosp_remove_list}webviewgoogle"$'\n'
fi;

# If we're installing webviewgoogle OR webviewstub we PREFER TO ADD webviewstock to $aosp_remove_list (if it's not already there)
# TODO in the future we could consider this behaviour even if installing just Chrome
if ( ( contains "$gapps_list" "webviewgoogle" ) || ( contains "$gapps_list" "webviewstub" ) ) && ( ! contains "$aosp_remove_list" "webviewstock" ); then
  aosp_remove_list="${aosp_remove_list}webviewstock"$'\n'
fi

# If we're NOT installing webviewgoogle OR webviewstub OR chrome and webviewstock is in $aosp_remove_list then user must override removal protection
if ( ! contains "$gapps_list" "webviewgoogle" ) && ( ! contains "$gapps_list" "webviewstub" ) && ( ! contains "$gapps_list" "chrome" ) && ( contains "$aosp_remove_list" "webviewstock" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/webviewstock} # we'll prevent webviewstock from being removed so user isn't left with no WebView
  install_note="${install_note}nowebview_msg"$'\n' # make note that Stock Webview can't be removed unless user Overrides
fi
# Cyanogenmod breaks Google's PackageInstaller don't install it on CM
if ( contains "$gapps_list" "packageinstallergoogle" ) && [ $cmcompatibilityhacks = "true" ]; then
  gapps_list=${gapps_list/packageinstallergoogle};
  install_note="${install_note}cmcompatibility_msg"$'\n'; # make note that CM compatibility hacks are applied
fi;

# Verify device is FaceUnlock compatible BEFORE we allow it in $gapps_list
if ( contains "$gapps_list" "faceunlock" ) && [ $faceunlock_compat = "false" ]; then
  gapps_list=${gapps_list/faceunlock};
  install_note="${install_note}faceunlock_msg"$'\n'; # make note that FaceUnlock will NOT be installed as user requested
fi;

# Add Google Pixel config if this is a Pixel device (and remove if it is not)
if ( ! contains "$gapps_list" "googlepixelconfig" ) && [ $googlepixel_compat = "true" ]; then
  gapps_list="${gapps_list}googlepixelconfig"$'\n'
fi;
if ( contains "$gapps_list" "googlepixelconfig" ) && [ $googlepixel_compat = "false" ]; then
  gapps_list=${gapps_list/googlepixelconfig};
fi;

# If we're NOT installing chrome make certain 'browser' is NOT in $aosp_remove_list UNLESS 'browser' is in $g_conf
if ( ! contains "$gapps_list" "chrome" ) && ( ! grep -qiE '^browser$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/browser};
  remove_browser="false[NO_Chrome]";
fi;

# If we're NOT installing gmail make certain 'email' is NOT in $aosp_remove_list UNLESS 'email' is in $g_conf
if ( ! contains "$gapps_list" "gmail" ) && ( ! grep -qiE '^email$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/email};
  remove_email="false[NO_Gmail]";
fi;

# If we're NOT installing photos make certain 'gallery' is NOT in $aosp_remove_list UNLESS 'gallery' is in $g_conf
if ( ! contains "$gapps_list" "photos" ) && ( ! grep -qiE '^gallery$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/gallery};
  remove_gallery="false[NO_Photos]";
fi;

# If $device_type is not a 'phone' make certain we're not installing messenger
if ( contains "$gapps_list" "messenger" ) && [ $device_type != "phone" ]; then
  gapps_list=${gapps_list/messenger}; # we'll prevent messenger from being installed since this isn't a phone
fi;

# If $device_type is not a 'phone' make certain we're not installing carrierservices (this is essential for messenger)
if ( contains "$gapps_list" "carrierservices" ) && [ $device_type != "phone" ]; then
  gapps_list=${gapps_list/carrierservices}; # we'll prevent carrierservices from being installed since this isn't a phone
fi;

# If $device_type is not a 'phone' make certain we're not installing dialerframework (implies no dialergoogle)
if ( contains "$gapps_list" "dialerframework" ) && [ $device_type != "phone" ]; then
  gapps_list=${gapps_list/dialerframework}; # we'll prevent dialerframework from being installed since this isn't a phone
fi;

# If we're NOT installing dialerframework then we MUST REMOVE dialergoogle from  $gapps_list (if it's currently there)
if ( ! contains "$gapps_list" "dialerframework" ) && ( contains "$gapps_list" "dialergoogle" ); then
  gapps_list=${gapps_list/dialergoogle};
  install_note="${install_note}dialergoogle_msg"$'\n'; # make note that Google Dialer will NOT be installed as user requested
fi;

# If we're NOT installing dialergoogle make certain 'dialerstock' is NOT in $aosp_remove_list UNLESS 'dialerstock' is in $g_conf
if ( ! contains "$gapps_list" "dialergoogle" ) && ( ! grep -qiE '^dialerstock$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/dialerstock};
  remove_dialerstock="false[NO_DialerGoogle]";
fi;

# If we're NOT installing carrier services then we MUST REMOVE messenger from $gapps_list (if it's currently there)
if [ "$API" -ge "23" ] && ( ! contains "$gapps_list" "carrierservices" ) && ( contains "$gapps_list" "messenger" ); then
  gapps_list=${gapps_list/messenger};
  install_note="${install_note}messenger_msg"$'\n'; # make note that Google Messages will NOT be installed as user requested
fi;

# If we're NOT installing messenger make certain 'mms' is NOT in $aosp_remove_list UNLESS 'mms' is in $g_conf
if ( ! contains "$gapps_list" "messenger" ) && ( ! grep -qiE '^mms$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/mms};
  remove_mms="false[NO_Messenger]";
fi;

# If we're NOT installing messenger and mms is in $aosp_remove_list then user must override removal protection
if ( ! contains "$gapps_list" "messenger" ) && ( contains "$aosp_remove_list" "mms" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/mms}; # we'll prevent mms from being removed so user isn't left with no way to receive text messages
  remove_mms="false[NO_Override]";
  install_note="${install_note}nomms_msg"$'\n'; # make note that MMS can't be removed unless user Overrides
fi;

# If we're NOT installing googletts make certain 'picotts' is NOT in $aosp_remove_list UNLESS 'picotts' is in $g_conf
if ( ! contains "$gapps_list" "googletts" ) && ( ! grep -qiE '^picotts$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/picotts};
  remove_picotts="false[NO_GoogleTTS]";
fi;

# If we're NOT installing wallpapers then we MUST REMOVE pixellauncher from  $gapps_list (if it's currently there)
if ( ! contains "$gapps_list" "wallpapers" ) && ( contains "$gapps_list" "pixellauncher" ); then
  gapps_list=${gapps_list/pixellauncher};
  install_note="${install_note}pixellauncher_msg"$'\n'; # make note that Google Now Launcher will NOT be installed as user requested
fi;

# If we're NOT installing search then we MUST REMOVE pixellauncher from  $gapps_list (if it's currently there)
if ( ! contains "$gapps_list" "search" ) && ( contains "$gapps_list" "pixellauncher" ); then
  gapps_list=${gapps_list/pixellauncher};
  install_note="${install_note}pixellauncher_msg"$'\n'; # make note that Pixel Launcher will NOT be installed as user requested
fi;

# If we're NOT installing search then we MUST REMOVE googlenow from  $gapps_list (if it's currently there)
if ( ! contains "$gapps_list" "search" ) && ( contains "$gapps_list" "googlenow" ); then
  gapps_list=${gapps_list/googlenow};
  install_note="${install_note}googlenow_msg"$'\n'; # make note that Google Now Launcher will NOT be installed as user requested
fi;

# If we're NOT installing googlenow or pixellauncher make certain 'launcher' is NOT in $aosp_remove_list UNLESS 'launcher' is in $g_conf
if ( ! contains "$gapps_list" "googlenow" ) && ( ! contains "$gapps_list" "pixellauncher" ) && ( ! grep -qiE '^launcher$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/launcher};
  remove_launcher="false[NO_GoogleNow/PixelLauncher]";
fi;

# If we're NOT installing googlenow or pixellauncher and launcher is in $aosp_remove_list then user must override removal protection
if ( ! contains "$gapps_list" "googlenow" ) && ( ! contains "$gapps_list" "pixellauncher" ) && ( contains "$aosp_remove_list" "launcher" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/launcher}; # we'll prevent launcher from being removed so user isn't left with no Launcher
  remove_launcher="false[NO_Override]";
  install_note="${install_note}nolauncher_msg"$'\n'; # make note that Launcher can't be removed unless user Overrides
fi;

# If we're installing calendargoogle we must ADD calendarstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "calendargoogle" ) && ( ! contains "$aosp_remove_list" "calendarstock" ); then
  aosp_remove_list="${aosp_remove_list}calendarstock"$'\n';
fi;

# If we're installing calendargoogle we must NOT install calsync
if ( contains "$gapps_list" "calendargoogle" ); then
  gapps_list=${gapps_list/calsync};
fi;

# If we're installing keyboardgoogle we must ADD keyboardstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "keyboardgoogle" ) && ( ! contains "$aosp_remove_list" "keyboardstock" ); then
  aosp_remove_list="${aosp_remove_list}keyboardstock"$'\n';
fi;

# If we're NOT installing keyboardgoogle and keyboardstock is in $aosp_remove_list then user must override removal protection
if ( ! contains "$gapps_list" "keyboardgoogle" ) && ( contains "$aosp_remove_list" "keyboardstock" ) && ( ! grep -qi "override" "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/keyboardstock}; # we'll prevent keyboardstock from being removed so user isn't left with no keyboard
  install_note="${install_note}nokeyboard_msg"$'\n'; # make note that Stock Keyboard can't be removed unless user Overrides
fi;

# Verify device is Google Camera compatible BEFORE we allow it in $gapps_list
if ( contains "$gapps_list" "cameragoogle" ) && [ $cameragoogle_compat = "false" ]; then
  gapps_list=${gapps_list/cameragoogle}; # we must DISALLOW cameragoogle from being installed
  install_note="${install_note}camera_compat_msg"$'\n'; # make note that Google Camera will NOT be installed as user requested
fi;

# If user wants to install cameragoogle then it MUST be a Clean Install OR cameragoogle was previously installed in system partition
if ( contains "$gapps_list" "cameragoogle" ) && ( ! clean_inst ) && [ $cameragoogle_inst = "false" ]; then
  gapps_list=${gapps_list/cameragoogle}; # we must DISALLOW cameragoogle from being installed
  aosp_remove_list=${aosp_remove_list/camerastock}; # and we'll prevent camerastock from being removed so user isn't left with no camera
  install_note="${install_note}camera_sys_msg"$'\n'; # make note that Google Camera will NOT be installed as user requested
fi;

# If we're NOT installing cameragoogle make certain 'camerastock' is NOT in $aosp_remove_list UNLESS 'camerastock' is in $g_conf
if ( ! contains "$gapps_list" "cameragoogle" ) && ( ! grep -qiE '^camerastock$' "$g_conf" ); then
  aosp_remove_list=${aosp_remove_list/camerastock};
  remove_camerastock="false[NO_CameraGoogle]";
fi;

# Verify device is VRMode compatible, BEFORE we allow vrservice in $gapps_list
if ( contains "$gapps_list" "vrservice" ) && [ "$vrmode_compat" = "false" ]; then
  gapps_list=${gapps_list/vrservice}; # we must DISALLOW vrservice from being installed
  install_note="${install_note}vrservice_compat_msg"$'\n'; # make note that VRService will NOT be installed as user requested
fi

# If we're installing clockgoogle we must ADD clockstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "clockgoogle" ) && ( ! contains "$aosp_remove_list" "clockstock" ); then
  aosp_remove_list="${aosp_remove_list}clockstock"$'\n';
fi;

# If we're installing exchangegoogle we must ADD exchangestock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "exchangegoogle" ) && ( ! contains "$aosp_remove_list" "exchangestock" ); then
  aosp_remove_list="${aosp_remove_list}exchangestock"$'\n';
fi;

# If we're installing printservicegoogle we must ADD printservicestock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "printservicegoogle" ) && ( ! contains "$aosp_remove_list" "printservicestock" ); then
  aosp_remove_list="${aosp_remove_list}printservicestock"$'\n';
fi;

# If we're installing storagemanagergoogle we must ADD storagemanagerstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "storagemanagergoogle" ) && ( ! contains "$aosp_remove_list" "storagemanagerstock" ); then
  aosp_remove_list="${aosp_remove_list}storagemanagerstock"$'\n';
fi;

# If we're installing taggoogle we must ADD tagstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "taggoogle" ) && ( ! contains "$aosp_remove_list" "tagstock" ); then
  aosp_remove_list="${aosp_remove_list}tagstock"$'\n';
fi;

# If we're installing calculatorgoogle we MUST ADD calculatorstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "calculatorgoogle" ) && ( ! contains "$aosp_remove_list" "calculatorstock" ); then
  aosp_remove_list="${aosp_remove_list}calculatorstock"$'\n';
fi;

# If we're installing contactsgoogle we MUST ADD contactsstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "contactsgoogle" ) && ( ! contains "$aosp_remove_list" "contactsstock" ); then
  aosp_remove_list="${aosp_remove_list}contactsstock"$'\n';
fi;

# If we're installing packageinstallergoogle we MUST ADD packageinstallerstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "packageinstallergoogle" ) && ( ! contains "$aosp_remove_list" "packageinstallerstock" ); then
  aosp_remove_list="${aosp_remove_list}packageinstallerstock"$'\n';
fi;

# If we're NOT installing gcs then we MUST REMOVE projectfi from  $gapps_list (if it's currently there)
if ( ! contains "$gapps_list" "gcs" ) && ( contains "$gapps_list" "projectfi" ); then
  gapps_list=${gapps_list/projectfi};
  install_note="${install_note}projectfi_msg"$'\n'; # make note that Project Fi will NOT be installed as user requested
fi;

# If we're installing wallpapers we must ADD wallpapersstock to $aosp_remove_list (if it's not already there)
if ( contains "$gapps_list" "wallpapers" ) && ( ! contains "$aosp_remove_list" "wallpapersstock" ); then
  aosp_remove_list="${aosp_remove_list}wallpapersstock"$'\n';
fi;

# Some ROMs bundle Google Apps or the user might have installed a Google replacement app during an earlier install
# Some of these apps are crucial to a functioning system and should NOT be removed if no AOSP/Stock equivalent is available
# Unless override keyword is used, make sure they are not removed
# NOTICE: Only for Google Keyboard we need to take KitKat support into account, others are only Lollipop+
ignoregooglecontacts="true"
for f in $contactsstock_list; do
  if [ -e "$SYSTEM/$f" ]; then
    ignoregooglecontacts="false"
    break; #at least 1 aosp stock file is present
  fi
done;
if [ "$ignoregooglecontacts" = "true" ]; then
  if ( ! contains "$gapps_list" "contactsgoogle" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
    sed -i "\:$SYSTEM/priv-app/GoogleContacts:d" $gapps_removal_list;
    ignoregooglecontacts="true[NoRemove]"
    install_note="${install_note}nogooglecontacts_removal"$'\n'; # make note that Google Contacts will not be removed
  else
    ignoregooglecontacts="false[ContactsGoogle]"
  fi
fi

ignoregoogledialer="true"
for f in $dialerstock_list; do
  if [ -e "$SYSTEM/$f" ]; then
    ignoregoogledialer="false"
    break; #at least 1 aosp stock file is present
  fi
done;
if [ "$ignoregoogledialer" = "true" ]; then
  if ( ! contains "$gapps_list" "dialergoogle" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
    sed -i "\:$SYSTEM/priv-app/GoogleDialer:d" $gapps_removal_list;
    ignoregoogledialer="true[NoRemove]"
    install_note="${install_note}nogoogledialer_removal"$'\n'; # make note that Google Dialer will not be removed
  else
    ignoregoogledialer="false[DialerGoogle]"
  fi
fi

ignoregooglekeyboard="true"
for f in $keyboardstock_list; do
  if [ -e "$SYSTEM/$f" ]; then
    ignoregooglekeyboard="false"
    break; #at least 1 aosp stock file is present
  fi
done;
if [ "$ignoregooglekeyboard" = "true" ]; then
  if ( ! contains "$gapps_list" "keyboardgoogle" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
  sed -i "\:/system/app/LatinImeGoogle:d" $gapps_removal_list;
    ignoregooglekeyboard="true[NoRemove]"
    install_note="${install_note}nogooglekeyboard_removal"$'\n'; # make note that Google Keyboard will not be removed
  else
    ignoregooglekeyboard="false[KeyboardGoogle]"
  fi
fi

ignoregooglepackageinstaller="true"
for f in $packageinstallerstock_list; do
  if [ -e "$SYSTEM/$f" ]; then
    ignoregooglepackageinstaller="false"
    break; #at least 1 aosp stock file is present
  fi
done;
if [ "$ignoregooglepackageinstaller" = "true" ]; then
  if ( ! contains "$gapps_list" "packageinstallergoogle" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
    sed -i "\:$SYSTEM/priv-app/GooglePackageInstaller:d" $gapps_removal_list;
    ignoregooglepackageinstaller="true[NoRemove]"
    install_note="${install_note}nogooglepackageinstaller_removal"$'\n'; # make note that Google Package Installer will not be removed
  else
    ignoregooglepackageinstaller="false[PackageInstallerGoogle]"
  fi
fi

ignoregoogletag="true"
for f in $tagstock_list; do
  if [ -e "$SYSTEM/$f" ]; then
    ignoregoogletag="false"
    break; #at least 1 aosp stock file is present
  fi
done;
if [ "$ignoregoogletag" = "true" ]; then
  if ( ! contains "$gapps_list" "taggoogle" ) && ( ! grep -qiE '^override$' "$g_conf" ); then
    sed -i "\:$SYSTEM/priv-app/TagGoogle:d" $gapps_removal_list;
    ignoregoogletag="true[NoRemove]"
    install_note="${install_note}nogoogletag_removal"$'\n'; # make note that Google Tag will not be removed
  else
    ignoregoogletag="false[TagGoogle]"
  fi
fi

ignoregooglewebview="true"
for f in $webviewstock_list; do
  if [ -e "$SYSTEM/$f" ]; then
    ignoregooglewebview="false"
    break; #at least 1 aosp stock file is present
  fi
done;
if [ "$ignoregooglewebview" = "true" ]; then  # No AOSP WebView
  if ( ! contains "$gapps_list" "webviewgoogle" ) && ( ! contains "$gapps_list" "webviewstub" ) && ( ! contains "$gapps_list" "chrome" ) && ( ! grep -qiE '^override$' "$g_conf" ); then  # Don't remove components if no other WebViewProvider installed
    if [ -d "/system/app/Chrome" ]; then
      sed -i "\:/system/app/Chrome:d" $gapps_removal_list;
      ignoregooglewebview="true[NoRemoveChrome]"
    elif [ -d "/system/app/WebviewGoogle" ]; then
      sed -i "\:/system/app/WebViewGoogle:d" $gapps_removal_list;
      ignoregooglewebview="true[NoRemoveGoogle]"
    elif [ -d "/system/app/WebviewStub" ]; then
      sed -i "\:/system/app/WebViewStub:d" $gapps_removal_list;
      ignoregooglewebview="true[NoRemoveStub]"
    fi
    install_note="${install_note}nogooglewebview_removal"$'\n'; # make note that Google WebView will not be removed
  elif ( contains "$gapps_list" "webviewgoogle" ); then  # No AOSP WebView, but Google WebView is being installed, no reason to protect the current components
    ignoregooglewebview="false[WebViewGoogle]"
  elif ( contains "$gapps_list" "webviewstub" ); then  # No AOSP WebView, but WebView Stub is being installed, no reason to protect the current components
    ignoregooglewebview="false[WebViewStub]"
  elif ( contains "$gapps_list" "chrome" ); then  # No AOSP WebView, but Chrome is being installed, no reason to protect the current components
    ignoregooglewebview="false[Chrome]"
  fi
fi

# Google Camera fallback to Legacy if incompatible with new Camera API
case $newcamera_compat in
  false*) gapps_list=${gapps_list/cameragoogle/cameragooglelegacy}; log "Google Camera version" "Legacy";;
esac

# Process User Application Removals for calculations and subsequent removal
if [ -n "$user_remove_list" ]; then
  for remove_apk in $user_remove_list; do
    testapk=$( echo "$remove_apk" | tr '[:upper:]'  '[:lower:]' );
    # Add apk extension if user didn't include it
    case $testapk in
      *".apk" ) ;;
      * )       testapk="${testapk}.apk" ;;
    esac;
    # Create user_remove_folder_list if this is a system/ROM application
    for folder in $SYSTEM/app $SYSTEM/priv-app; do # Check all subfolders in /system/app /system/priv-app for the apk
      file_count=0; # Reset Counter
      file_count=$(find $folder -iname "$testapk" | wc -l);
      case $file_count in
        0)  continue;;
                    1)  user_remove_folder_list="${user_remove_folder_list}$(dirname "$(find "$folder" -type f -iname "$testapk")")"$'\n'; # Add found folder to list
            break;;
        *)  echo "$remove_apk" >> $user_remove_multiplefound_log; # Add app to user_remove_multiplefound_log since we found more than 1 instance
            break;;
      esac;
    done;
    if [ "$file_count" -eq 0 ]; then
      echo "$remove_apk" >> $user_remove_notfound_log;
    fi; # Add 'not found' app to user_remove_notfound_log
  done;
fi;

# Removing old Chrome libraries
obsolete_libs_list="";
for f in $(find $SYSTEM/lib $SYSTEM/lib64 -name 'libchrome.*.so' 2>/dev/null); do
  obsolete_libs_list="${obsolete_libs_list}$f"$'\n';
done;

# Read in gapps removal list from file and append old Chrome libs
full_removal_list="$(cat $gapps_removal_list)"$'\n'"${obsolete_libs_list}";

# Read in old user removal list from addon.d to allow for persistence
addond_remove_folder_list=$(sed -e "1,/# Remove 'user requested' apps (from gapps-config)/d" -e '/;;/,$d' -e 's/    rm -rf //' $SYSTEM/addon.d/70-gapps.sh)

# Clean up and sort our lists for space calculations and installation
set_progress 0.04;
gapps_list=$(echo "${gapps_list}" | sort | sed '/^$/d'); # sort GApps list & remove empty lines
aosp_remove_list=$(echo "${aosp_remove_list}" | sort | sed '/^$/d'); # sort AOSP Remove list & remove empty lines
full_removal_list=$(echo "${full_removal_list}" | sed '/^$/d'); # Remove empty lines from FINAL GApps Removal list
remove_list=$(echo "${remove_list}" | sed '/^$/d'); # Remove empty lines from remove_list
user_remove_folder_list=$(echo "${user_remove_folder_list}" | sed '/^$/d'); # Remove empty lines from User Application Removal list

log "Installing GApps Zipfile" "$OPENGAZIP"
log "Installing GApps Version" "$gapps_version";
log "Installing GApps Type" "$gapps_type";
log "Config Type" "$config_type";
log "Using gapps-config" "$config_file";
log "Remove Stock/AOSP Browser" "$remove_browser";
log "Remove Stock/AOSP Camera" "$remove_camerastock";
log "Remove Stock/AOSP Dialer" "$remove_dialerstock";
log "Remove Stock/AOSP Email" "$remove_email";
log "Remove Stock/AOSP Gallery" "$remove_gallery";
log "Remove Stock/AOSP Launcher" "$remove_launcher";
log "Remove Stock/AOSP MMS App" "$remove_mms";
log "Remove Stock/AOSP Pico TTS" "$remove_picotts";
log "Ignore Google Contacts" "$ignoregooglecontacts";
log "Ignore Google Dialer" "$ignoregoogledialer";
log "Ignore Google Keyboard" "$ignoregooglekeyboard";
log "Ignore Google Package Installer" "$ignoregooglepackageinstaller";
log "Ignore Google NFC Tag" "$ignoregoogletag";
log "Ignore Google WebView" "$ignoregooglewebview";
# _____________________________________________________________________________________________________________________
#                                                  Perform space calculations
ui_print "- Performing system space calculations";
ui_print " ";

# Perform calculations of core applications
core_size=0;
for gapp_name in $core_gapps_list; do
  get_apparchives "Core/$gapp_name"
  for archive in $apparchives; do
    case $gapp_name in
      setupwizarddefault) if [ "$device_type" != "tablet" ]; then get_appsize "$archive"; fi;;
      setupwizardtablet)  if [ "$device_type"  = "tablet" ]; then get_appsize "$archive"; fi;;
      *) get_appsize "$archive";;
    esac
    core_size=$((core_size + appsize))
  done
done;

# Add swypelibs size to core, if it will be installed
if ( ! contains "$gapps_list" "keyboardgoogle" ) || [ "$skipswypelibs" = "false" ]; then
  get_appsize "Optional/swypelibs-lib-$arch"  # Keep it simple, swypelibs is only lib-$arch
  core_size=$((core_size + keybd_lib_size))  # Add Keyboard Lib size to core, if it exists
fi

# Read and save system partition size details
df=$(df -k $SYSTEM | tail -n 1);
case $df in
  /dev/block/*) df=$(echo "$df" | awk '{ print substr($0, index($0,$2)) }');;
esac;
total_system_size_kb=$(echo "$df" | awk '{ print $1 }');
used_system_size_kb=$(echo "$df" | awk '{ print $2 }');
free_system_size_kb=$(echo "$df" | awk '{ print $3 }');
log "Total System Size (KB)" "$total_system_size_kb";
log "Used System Space (KB)" "$used_system_size_kb";
log "Current Free Space (KB)" "$free_system_size_kb";

# Perform storage space calculations of existing GApps that will be deleted/replaced
reclaimed_gapps_space_kb=$(du -ck $(complete_gapps_list) | tail -n 1 | awk '{ print $1 }');

# Perform storage space calculations of other Removals that need to be deleted (Obsolete and Conflicting Apps)
set_progress 0.05;
reclaimed_removal_space_kb=$(du -ck $(obsolete_gapps_list) | tail -n 1 | awk '{ print $1 }');

# Add information to calc.log that will later be added to open_gapps.log to assist user with app removals
post_install_size_kb=$((free_system_size_kb + reclaimed_gapps_space_kb)); # Add opening calculations
echo ------------------------------------------------------------------ > $calc_log;
printf "%7s | %26s |   %7s | %7s\n" "TYPE " "DESCRIPTION       " "SIZE" "  TOTAL" >> $calc_log;
printf "%7s | %26s |   %7d | %7d\n" "" "Current Free Space" "$free_system_size_kb" "$free_system_size_kb" >> $calc_log;
printf "%7s | %26s | + %7d | %7d\n" "Remove" "Existing GApps" "$reclaimed_gapps_space_kb" $post_install_size_kb >> $calc_log;
post_install_size_kb=$((post_install_size_kb + reclaimed_removal_space_kb)); # Add reclaimed_removal_space_kb
printf "%7s | %26s | + %7d | %7d\n" "Remove" "Obsolete Files" "$reclaimed_removal_space_kb" $post_install_size_kb >> $calc_log;

# Perform calculations of AOSP/ROM files that will be deleted
set_progress 0.07;
for aosp_name in $aosp_remove_list; do
  eval "list_name=\$${aosp_name}_list";
  aosp_size_kb=0; # Reset counter
  for file_name in $list_name; do
    if [ -e "$SYSTEM/$file_name" ]; then
      file_size_kb=$(du -ck "$SYSTEM/$file_name" | tail -n 1 | awk '{ print $1 }');
      aosp_size_kb=$((file_size_kb + aosp_size_kb));
      post_install_size_kb=$((post_install_size_kb + file_size_kb));
    fi;
  done;
  log_add "Remove" "$aosp_name" $aosp_size_kb $post_install_size_kb;
done;

# Perform calculations of User App Removals that will be deleted
for remove_folder in $user_remove_folder_list; do
  if [ -e "$remove_folder" ]; then
    folder_size_kb=$(du -ck "$remove_folder" | tail -n 1 | awk '{ print $1 }');
    post_install_size_kb=$((post_install_size_kb + folder_size_kb));
    log_add "Remove" "$(basename "$remove_folder")*" "$folder_size_kb" $post_install_size_kb;
  fi;
done;

# Perform calculations of GApps files that will be installed
set_progress 0.09
post_install_size_kb=$((post_install_size_kb - core_size)) # Add Core GApps
log_sub "Install" "Core" $core_size $post_install_size_kb

for gapp_name in $gapps_list; do
  case $gapp_name in
    photos)  if [ "$vrmode_compat" = "true" ] && [ "$arch" = "arm64" ] && [ "$rom_build_sdk" -ge "24" ]; then gapp_name="photosvrmode"; fi;;  # for now only available on Nougat arm64
    movies)  if [ "$vrmode_compat" = "true" ] && ( [ "$arch" = "arm" ] || [ "$arch" = "arm64" ] ) && [ "$rom_build_sdk" -ge "24" ]; then gapp_name="moviesvrmode"; fi;;  # for now only available on Nougat arm & arm64
    *)  ;;
  esac
  get_apparchives "GApps/$gapp_name"
  total_appsize=0
  for archive in $apparchives; do
    get_appsize "$archive"
    total_appsize=$((total_appsize + $appsize))
  done

  post_install_size_kb=$((post_install_size_kb - total_appsize))
  log_sub "Install" "$gapp_name" "$total_appsize" "$post_install_size_kb"
done;

# Perform calculations of required Buffer Size
set_progress 0.11
if ( grep -qiE '^smallbuffer$' "$g_conf" ); then
  buffer_size_kb=$small_buffer_size
fi

post_install_size_kb=$((post_install_size_kb - buffer_size_kb));
log_sub "" "Buffer Space" "$buffer_size_kb" $post_install_size_kb;
echo ------------------------------------------------------------------ >> $calc_log;

if [ "$post_install_size_kb" -ge 0 ]; then
  printf "%47s | %7d\n" "  Post Install Free Space" $post_install_size_kb >> $calc_log;
  log "Post Install Free Space (KB)" "$post_install_size_kb   << See Calculations Below";
else
  additional_size_kb=$((post_install_size_kb * -1));
  printf "%47s | %7d\n" "Additional Space Required" $additional_size_kb >> $calc_log;
  log "Additional Space Required (KB)" "$additional_size_kb   << See Calculations Below";
fi;

# Finish up Calculation Log
echo ------------------------------------------------------------------ >> $calc_log;
if [ -n "$user_remove_folder_list" ]; then
  echo "              * User Requested Removal" >> $calc_log;
fi;

# Check whether there's enough free space to complete this installation
if [ "$post_install_size_kb" -lt 0 ]; then
  # We don't have enough system space to install everything user requested
  ui_print "Insufficient storage space available in";
  ui_print "System partition. You may want to use a";
  ui_print "smaller Open GApps package or consider";
  ui_print "removing some apps using gapps-config.";
  ui_print "See:'$log_folder/open_gapps_log.txt'";
  ui_print "for complete details and information.";
  ui_print " ";
  install_note="${install_note}system_space_msg"$'\n'; # make note that there is insufficient space in system to install
  abort "$E_NOSPACE";
fi;

# Check to see if this is the 'real thing' or only a test
if ( grep -qiE '^test$' "$g_conf" ); then # user has selected a 'test' install ONLY
  ui_print "- Exiting Simulated Install";
  ui_print " ";
  install_note="${install_note}simulation_msg"$'\n'; # make note that this is only a test installation
  quit;
  exxit 0;
fi;
# _____________________________________________________________________________________________________________________
#                                                  Perform Removals
# Remove ALL Existing GApps files
set_progress 0.13;
ui_print "- Removing existing/obsolete Apps";
ui_print " ";
rm -rf $(complete_gapps_list);

# Remove Obsolete and Conflicting Apps
rm -rf $(obsolete_gapps_list);

# Remove Stock/AOSP Apps and add Removals to addon.d script
aosp_remove_list=$(echo "${aosp_remove_list}" | sort -r); # reverse sort list for more readable output
for aosp_name in $aosp_remove_list; do
  eval "list_name=\$${aosp_name}_list";
  list_name=$(echo "${list_name}" | sort -r); # reverse sort list for more readable output
  for file_name in $list_name; do
    rm -rf "$SYSTEM/$file_name";
    sed -i "\:# Remove Stock/AOSP apps (from GApps Installer):a \    rm -rf \$SYS/$file_name" $bkup_tail;
  done;
done;

# Add saved addon.d User App Removals to make them persistent through repeat dirty GApps installs though the app may have already been removed
user_remove_folder_list=$(echo -e "${user_remove_folder_list}\n${addond_remove_folder_list}" | sort -u | sed '/^$/d')  # remove duplicates and empty lines

# Perform User App Removals and add Removals to addon.d script
user_remove_folder_list=$(echo "${user_remove_folder_list}" | sort -r); # reverse sort list for more readable output
for user_app in $user_remove_folder_list; do
  rm -rf "$user_app";
  sed -i "\:# Remove 'user requested' apps (from gapps-config):a \    rm -rf $user_app" $bkup_tail;
done;

# Remove any empty folders we may have created during the removal process
for i in $SYSTEM/app $SYSTEM/priv-app $SYSTEM/vendor/pittpatt $SYSTEM/usr/srec $SYSTEM/etc/preferred-apps; do
  find "$i" -type d | xargs -r rmdir -p --ignore-fail-on-non-empty;
done;
# _____________________________________________________________________________________________________________________
#                                                  Perform Installs
ui_print "- Installing core GApps";
set_progress 0.15;
for gapp_name in $core_gapps_list; do
  get_apparchives "Core/$gapp_name"
  for archive in $apparchives; do
    case $gapp_name in
      setupwizarddefault) if [ "$device_type" != "tablet" ]; then extract_app "$archive"; fi;;
      setupwizardtablet)  if [ "$device_type"  = "tablet" ]; then extract_app "$archive"; fi;;
      *)  extract_app "$archive";;
    esac
  done
done;
ui_print " ";
set_progress 0.25;

# Install/Remove SwypeLibs
if ( ! contains "$gapps_list" "keyboardgoogle" ); then
  if [ "$skipswypelibs" = "false" ]; then
    if [ "$substituteswypelibs" = "true" ]; then
      keybd_lib_target="$keybd_lib_aosp"
      rm -f "/system/app/LatinIME/$libfolder/$arch/$keybd_lib_google" # remove swypelibs and symlink if any
      rm -f "/system/app/LatinIME/$libfolder/$arch/$keybd_dec_google" # remove swypelibs and symlink if any
    else
      keybd_lib_target="$keybd_lib_google"
      ln -sfn "/system/$libfolder/$keybd_lib_aosp" "/system/app/LatinIME/$libfolder/$arch/$keybd_lib_aosp" # relink aosp as the normal link
    fi
    ui_print "- Installing swypelibs"
    extract_app "Optional/swypelibs-lib-$arch"  # Keep it simple, swypelibs is only lib-$arch
    install -d "/system/app/LatinIME/$libfolder/$arch"
    ln -sfn "/system/$libfolder/$keybd_lib_google" "/system/app/LatinIME/$libfolder/$arch/$keybd_lib_target" # create required symlink
    ln -sfn "/system/$libfolder/$keybd_dec_google" "/system/app/LatinIME/$libfolder/$arch/$keybd_dec_google" # create required symlink

    # Add same code to backup script to ensure symlinks are recreated on addon.d restore
    sed -i "\:# Recreate required symlinks (from GApps Installer):a \    ln -sfn \"\$SYS/$libfolder/$keybd_dec_google\" \"\$SYS/app/LatinIME/$libfolder/$arch/$keybd_dec_google\"" $bkup_tail
    sed -i "\:# Recreate required symlinks (from GApps Installer):a \    ln -sfn \"\$SYS/$libfolder/$keybd_lib_google\" \"\$SYS/app/LatinIME/$libfolder/$arch/$keybd_lib_target\"" $bkup_tail
    sed -i "\:# Recreate required symlinks (from GApps Installer):a \    install -d \"\$SYS/app/LatinIME/$libfolder/$arch\"" $bkup_tail
  else
    ui_print "- Removing swypelibs"
    rm -f "/system/$libfolder/$keybd_lib_google" "/system/app/LatinIME/$libfolder/$arch/$keybd_lib_google" # remove swypelibs and symlink if any
    rm -f "/system/$libfolder/$keybd_dec_google" "/system/app/LatinIME/$libfolder/$arch/$keybd_dec_google" # remove swypelibs and symlink if any
    ln -sfn "/system/$libfolder/$keybd_lib_aosp" "/system/app/LatinIME/$libfolder/$arch/$keybd_lib_aosp" # restore non-swypelibs symlink
  fi
fi

# Progress Bar increment calculations for GApps Install process
set_progress 0.30;
gapps_count=$(echo "${gapps_list}" | wc -w); # Count number of GApps left to be installed
if [ "$gapps_count" -lt 1 ]; then gapps_count=1; fi; # Prevent division by zero
incr_amt=$(( 5000 / gapps_count )); # Determine increment factor of progress bar during GApps installation
prog_bar=3000; # Set Progress Bar start point (0.3000) for below

# Install the rest of GApps still in $gapps_list
for gapp_name in $gapps_list; do
  case $gapp_name in
    photos)  if [ "$vrmode_compat" = "true" ] && [ "$arch" = "arm64" ] && [ "$rom_build_sdk" -ge "24" ]; then gapp_name="photosvrmode"; fi;;  # for now only available on Nougat arm64
    movies)  if [ "$vrmode_compat" = "true" ] && ( [ "$arch" = "arm" ] || [ "$arch" = "arm64" ] ) && [ "$rom_build_sdk" -ge "24" ]; then gapp_name="moviesvrmode"; fi;;  # for now only available on Nougat arm & arm64
    *)  ;;
  esac
  ui_print "- Installing $gapp_name"
  get_apparchives "GApps/$gapp_name"
  for archive in $apparchives; do
    extract_app "$archive" # Installing User Selected GApps
  done
  prog_bar=$((prog_bar + incr_amt))
  set_progress 0.$prog_bar
done;

ui_print " ";
ui_print "- Miscellaneous tasks";
ui_print " ";

# Use Gms (Google Play services) for feedback/bug reporting (instead of org.cyanogenmod.bugreport or others)
sed -i "s/ro.error.receiver.system.apps=.*/ro.error.receiver.system.apps=com.google.android.gms/g" $SYSTEM/build.prop
sed -i "\:# Apply build.prop changes (from GApps Installer):a \    sed -i \"s/ro.error.receiver.system.apps=.*/ro.error.receiver.system.apps=com.google.android.gms/g\" \$SYS/build.prop" $bkup_tail

# Enable Google Assistant
if ( grep -qiE '^googleassistant$' "$g_conf" ); then  #TODO this is not enabled by default atm; because Assistant still has various regressions compared to Google Now
  if ! grep -q "ro.opa.eligible_device=" $SYSTEM/build.prop; then
    echo "ro.opa.eligible_device=true" >> $SYSTEM/build.prop
  fi
  sed -i "\:# Apply build.prop changes (from GApps Installer):a \    if ! grep -q \"ro.opa.eligible_device=\" $SYSTEM/build.prop; then echo \"ro.opa.eligible_device=true\" >> \$SYS/build.prop; fi" $bkup_tail
fi

# Create FaceLock lib symlink if installed
if ( contains "$gapps_list" "faceunlock" ); then
  install -d "$SYSTEM/app/FaceLock/lib/$arch"
  ln -sfn "$SYSTEM/$libfolder/$faceLock_lib_filename" "$SYSTEM/app/FaceLock/lib/$arch/$faceLock_lib_filename"
  # Add same code to backup script to ensure symlinks are recreated on addon.d restore
  sed -i "\:# Recreate required symlinks (from GApps Installer):a \    ln -sfn \"\$SYS/$libfolder/$faceLock_lib_filename\" \"\$SYS/app/FaceLock/lib/$arch/$faceLock_lib_filename\"" $bkup_tail
  sed -i "\:# Recreate required symlinks (from GApps Installer):a \    install -d \"\$SYS/app/FaceLock/lib/$arch\"" $bkup_tail
fi

# Create Markup lib symlink if installed
if ( contains "$gapps_list" "markup" ); then
  install -d "$SYSTEM/app/MarkupGoogle/lib/$arch"
  ln -sfn "$SYSTEM/$libfolder/$markup_lib_filename" "$SYSTEM/app/MarkupGoogle/lib/$arch/$markup_lib_filename"
  # Add same code to backup script to ensure symlinks are recreated on addon.d restore
  sed -i "\:# Recreate required symlinks (from GApps Installer):a \    ln -sfn \"$SYSTEM/$libfolder/$markup_lib_filename\" \"$SYSTEM/app/MarkupGoogle/lib/$arch/$markup_lib_filename\"" $bkup_tail
  sed -i "\:# Recreate required symlinks (from GApps Installer):a \    install -d \"$SYSTEM/app/MarkupGoogle/lib/$arch\"" $bkup_tail
fi


# Copy g.prop over to /system/etc
cp -f "$TMP/g.prop" "$g_prop"
# _____________________________________________________________________________________________________________________
#                                                  Build and Install Addon.d Backup Script
# Add 'other' Removals to addon.d script
set_progress 0.80;
other_list=$(echo "${other_list}" | sort -r); # reverse sort list for more readable output
for other_name in $other_list; do
  sed -i "\:# Remove 'other' apps (per installer.data):a \    rm -rf \$SYS/$other_name" $bkup_tail;
done;

# Add 'priv-app' Removals to addon.d script
privapp_list=$(echo "${privapp_list}" | sort -r); # reverse sort list for more readable output
for privapp_name in $privapp_list; do
  sed -i "\:# Remove 'priv-app' apps from 'app' (per installer.data):a \    rm -rf \$SYS/$privapp_name" $bkup_tail;
done;

# Add 'required' Removals to addon.d script
reqd_list=$(echo "${reqd_list}" | sort -r); # reverse sort list for more readable output
for reqdapp_name in $reqd_list; do
  reqdapp_name=$(echo ${reqdapp_name/\/system/\$SYS})
  sed -i "\:# Remove 'required' apps (per installer.data):a \    rm -rf $reqdapp_name" $bkup_tail;
done;

# Create final addon.d script in system
bkup_header="#!/sbin/sh\n# \n# ADDOND_VERSION=2\n# \n# $SYSTEM/addon.d/70-gapps.sh\n#\n. /tmp/backuptool.functions\n\nif [ -z \$backuptool_ab ]; then\n  SYS=\$S\n  TMP="/tmp"\nelse\n  SYS="/postinstall/system"\n  TMP="/postinstall/tmp"\nfi\n\nlist_files() {\ncat <<EOF"
bkup_list="$bkup_list"$'\n'"etc/g.prop"; # add g.prop to backup list
bkup_list=$(echo "${bkup_list}" | sort -u| sed '/^$/d'); # sort list & remove duplicates and empty lines
install -d $SYSTEM/addon.d;
echo -e "$bkup_header" > $SYSTEM/addon.d/70-gapps.sh;
echo -e "$bkup_list" >> $SYSTEM/addon.d/70-gapps.sh;
cat $bkup_tail >> $SYSTEM/addon.d/70-gapps.sh;
# _____________________________________________________________________________________________________________________
#                                                  Fix Permissions

set_progress 0.85
find $SYSTEM/vendor/pittpatt -type d -exec chown 0:2000 '{}' \; # Change pittpatt folders to root:shell per Google Factory Settings

set_perm 0 0 755 "$SYSTEM/addon.d/70-gapps.sh"
ch_con "$SYSTEM/addon.d/70-gapps.sh"

set_perm 0 0 644 "$g_prop"
ch_con "$g_prop"

set_progress 0.92
quit

ui_print "- Installation complete!"
ui_print " "

if ( contains "$gapps_list" "dialergoogle" ); then
  ui_print "You installed Google Dialer."
  ui_print "Please set it as default Phone"
  ui_print "application to prevent calls"
  ui_print "from rebooting your device."
  ui_print "See https://goo.gl/LTIJ0o"

  # set Google Dialer as default; based on the work of osm0sis @ xda-developers
  setver="122"  # lowest version in MM, tagged at 6.0.0
  setsec="/data/system/users/0/settings_secure.xml"
  if [ -f "$setsec" ]; then
    if grep -q 'dialer_default_application' "$setsec"; then
      if ! grep -q 'dialer_default_application" value="com.google.android.dialer' "$setsec"; then
        curentry="$(grep -o 'dialer_default_application" value=.*$' "$setsec")"
        newentry='dialer_default_application" value="com.google.android.dialer" package="android" />\r'
        sed -i "s;${curentry};${newentry};" "$setsec"
      fi
    else
      max="0"
      for i in $(grep -o 'id=.*$' "$setsec" | cut -d '"' -f 2); do
        test "$i" -gt "$max" && max="$i"
      done
      entry='<setting id="'"$((max + 1))"'" name="dialer_default_application" value="com.google.android.dialer" package="android" />\r'
      sed -i "/<settings version=\"/a\ \ ${entry}" "$setsec"
    fi
  else
    if [ ! -d "/data/system/users/0" ]; then
      install -d "/data/system/users/0"
      chown -R 1000:1000 "/data/system"
      chmod -R 775 "/data/system"
      chmod 700 "/data/system/users/0"
    fi
    { echo -e "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>\r";
    echo -e '<settings version="'$setver'">\r';
    echo -e '  <setting id="1" name="dialer_default_application" value="com.google.android.dialer" package="android" />\r';
    echo -e '</settings>'; } > "$setsec"
  fi
  chown 1000:1000 "$setsec"
  chmod 600 "$setsec"
fi

exxit 0
