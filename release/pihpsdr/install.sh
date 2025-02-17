echo "installing fftw"
sudo apt-get -y install libfftw3-3
echo "installing librtlsdr0"
sudo apt-get -y install librtlsdr0
echo "removing old versions of pihpsdr"
sudo rm -rf /usr/local/bin/pihpsdr
echo "creating start script"
cat <<EOT > start_pihpsdr.sh
cd `pwd`
/usr/local/bin/pihpsdr >log 2>&1
EOT
chmod +x start_pihpsdr.sh
echo "creating desktop shortcut"
cat <<EOT > pihpsdr.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Name[eb_GB]=piHPSDR
Exec=`pwd`/start_pihpsdr.sh
Icon=`pwd`/hpsdr_icon.png
Name=piHPSDR
EOT
cp pihpsdr.desktop ~/Desktop
if [ ! -d ~/.local ]; then
  mkdir ~/.local
fi
if [ ! -d ~/.local/share ]; then
mkdir ~/.local/share
fi
if [ ! -d ~/.local/share/applications ]; then
mkdir ~/.local/share/applications
fi
cp pihpsdr.desktop ~/.local/share/applications
echo "removing old versions of shared libraries"
sudo rm -rf /usr/local/lib/libwdsp.so
sudo rm -rf /usr/local/lib/libLimeSuite*
sudo rm -rf /usr/local/lib/libSoapySDR*
sudo rm -rf /usr/local/lib/SoapySDR
echo "copying udev rules"
sudo cp 64-limesuite.rules /etc/udev/rules.d/
sudo cp 90-ozy.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
echo "installing pihpsdr"
sudo cp pihpsdr /usr/local/bin
echo "installing shared libraries"
sudo cp libwdsp.so /usr/local/lib
sudo cp libLimeSuite.so.19.04.1 /usr/local/lib
sudo cp libSoapySDR.so.0.8.0 /usr/local/lib
sudo cp -R SoapySDR /usr/local/lib
cd /usr/local/lib
sudo ln -s libLimeSuite.so.19.04.1 libLimeSuite.so.19.04-1
sudo ln -s libLimeSuite.so.19.04-1 libLimeSuite.so
sudo ln -s libSoapySDR.so.0.8.0 libSoapySDR.so.0.8
sudo ln -s libSoapySDR.so.0.8 libSoapySDR.so
sudo ldconfig

