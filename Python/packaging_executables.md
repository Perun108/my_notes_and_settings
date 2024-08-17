# Linux

## Ubuntu/Debian (.deb)

1. Create a main function in your app or script

You can do as follows for the multi module app (you should have a main module/script that you use to run your app with `python -m <name_of_your_script>`)

```python
def main():
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = SansConverter()  # noqa
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
```

2. Install all prerequisites (in venv!)

Something like the following:

```bash
sudo apt-get update
sudo apt-get install dpkg-dev python3-pip ruby-dev build-essential
sudo gem install --no-document fpm # Not needed, it didn't work out.

pip install pyinstaller
```

3. Create a `setup.py` file in the root directory of your app

```python
from setuptools import find_packages, setup

setup(
    name="my_app",
    version="2.0",
    description="Add your description"
    author="Your Name",
    author_email="your.email@gmail.com",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=[
        "PyQt6==6.7.0",
        "pyqt6-qt6==6.7.0",
    ],
    extras_require={
        "dev": [
            "flake8==5.0.4",
            "black==22.6.0",
            "pre-commit==2.20.0",
            "pylint==2.14.5",
            "ipython==8.4.0",
            "pytest==8.2.2",
        ]
    },
    entry_points={
        "gui_scripts": [
            "MyAppClass=my_main_file:main",
        ]
    },
    include_package_data=True,
)
```

4. Build a binary file with pyinstaller

Let's say you have the main script in `src` directory inside your `my_app` directory.

```bash
pyinstaller --onefile --windowed src/main.py --icon "media/my-app-icon.png"
```

`--icon` is ignored in Linux, keeping it here for consistency.

5. Create a `.deb` file from the build  
NOTE: `dist` directory will be created by pyinstaller.

Initially I tried `fpm`:

```bash
cd dist
fpm -s dir -t deb -n <my_app> -v 2.0 --prefix /usr/local/bin my_app
```

but had little success with it.

a) Create package structure for `dpkg`:

```bash
mkdir my_app && cd my_app
mkdir -p DEBIAN && mkdir -p usr/local/bin && mkdir -p usr/share/applications && mkdir -p usr/share/icons/hicolor/96x96/apps
```

Replace `96x96` with your icon size.

b) Copy or move the binary created by pyinstaller to our new directory

```bash
cp ~/path/to/my-app/dist/my_app usr/local/bin
```

c) Copy the icon to the new directory:

```bash
cp ~/path/to/my-app/media/icon.png usr/share/icons/hicolor/96x96/apps
```

d) Create a .desktop file:

```bash
touch usr/share/applications/my_app.desktop
```

with the following contents:

```desktop
[Desktop Entry]
Name=MyApp
Comment=My beautiful app
Exec=/usr/local/bin/my_app
Icon=/usr/share/icons/hicolor/96x96/apps/icon.png
Terminal=false
Type=Application
Categories=Utility;
```

The paths specified in this desktop file will be the path for the executable file and the icon and will be populated by `dpkg` when installing our `.deb` file.

e) Create a `control` file in `DEBIAN` directory with the following contents:

```
Package: my_app
Version: 2.0
Section: base
Priority: optional
Architecture: amd64
Maintainer: My Name <my.email@email.com>
Description: My wonderful app
```

f) Go one level up to the parent directory and build the `.deb` file

```bash
dpkg-deb --build <name_of_my_app_directory_where_DEBIAN_and_usr_are> my_app_2.0_amd64.deb
```

This should build a `.deb` package in the parent directory. Install it with `sudo dpkg -i my_app_2.0_amd64.deb` and test that the app is indeed present in the Apps and the icon is present as well.

g) Test and debug if needed

To list where it was installed: `dpkg -L sansconverter`  
By default the executable can be run from `/usr/local/bin/my_app`  
To remove the installed `.deb`: `sudo apt purge my_app`  

Distribute!
