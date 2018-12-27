# amiga-realtime3d

The 3D engine from the book "Amiga Real-Time 3D Graphics".

![Screenshot](/screenshots/asmone.png "AsmOne")

## Prerequisites

To build and run the Amiga demos, you must first install the following tools:

- [FS-UAE Amiga Emulator](https://fs-uae.net/)
- [Amiga Kickstart ROM file](http://www.amigakickstart.com/) - support [Amiga Forever](https://www.amigaforever.com/)
- [AsmOne](http://www.theflamearrows.info/documents/ftp.html)
- [Wine](https://www.winehq.org/) (for installing Amiga Forever)

For cross-compiling the Amiga demos, you can install the following tools:

- [vasm](http://sun.hasenbraten.de/vasm/index.php?view=main)
- [Ninja 1.5](https://ninja-build.org/) (or later)

### Install FS-UAE

#### openSUSE

Follow the instructions [here](https://fs-uae.net/download#opensuse), alternatively download a generic package [here](https://fs-uae.net/download-devel#linux)

#### Ubuntu

Follow the instructions [here](https://fs-uae.net/download#ubuntu), alternatively download a generic package [here](https://fs-uae.net/download-devel#linux)

#### Configuration

1. Create FS-UAE run-configuration directory
   ```
   $ mkdir -p ~/FS-UAE/Configurations
   ```

1. Create default Amiga run-configuration files

   Create a file called `~/FS-UAE/Configurations/A1200.fs-uae` with the following contents:
   ```
   [fs-uae]
   amiga_model = A1200/020
   floppy_drive_volume_empty = 0
   hard_drive_0 = $HOME/FS-UAE/AmigaForever/Amiga Files/Shared/hdf/workbench-311.hdf
   hard_drive_1 = $HOME/FS-UAE/AmigaForever/Amiga Files/Shared/dir/Work
   hard_drive_2 = $HOME/git/github/amiga-realtime3d
   hard_drive_2_label = Sources
   joystick_port_1_mode = nothing
   ```

   Create a file called `~/FS-UAE/Configurations/A500+.fs-uae` with the following contents:
   ```
   [fs-uae]
   amiga_model = A500+
   chip_memory = 1024
   floppy_drive_volume_empty = 0
   hard_drive_0 = $HOME/FS-UAE/AmigaForever/Amiga Files/Shared/hdf/workbench-211.hdf
   hard_drive_1 = $HOME/FS-UAE/AmigaForever/Amiga Files/Shared/dir/Work
   hard_drive_2 = $HOME/git/github/amiga-realtime3d
   hard_drive_2_label = Sources
   joystick_port_1_mode = nothing
   ```

   Create a file called `~/FS-UAE/Configurations/A500.fs-uae` with the following contents:
   ```
   [fs-uae]
   chip_memory = 1024
   floppy_drive_volume_empty = 0
   hard_drive_0 = $HOME/FS-UAE/AmigaForever/Amiga Files/Shared/hdf/workbench-135.hdf
   hard_drive_1 = $HOME/FS-UAE/AmigaForever/Amiga Files/Shared/dir/Work
   hard_drive_2 = $HOME/git/github/amiga-realtime3d
   hard_drive_2_label = Sources
   joystick_port_1_mode = nothing
   ```

### Install Wine

#### openSUSE

`$ sudo zypper install wine`

#### Ubuntu

`$ sudo apt install wine`

### Install Amiga Forever

1. Execute the Amiga Forever installation program
   ```
   $ env WINEPREFIX="$HOME/.wine-amigaforever" wine start AmigaForever7Plus.msi
   ```

1. Copy the installed Amiga Forever files to the FS-UAE working directory
   ```
   $ mkdir -p ~/FS-UAE/AmigaForever
   $ cp -a ~/.wine-amigaforever/drive_c/users/Public/Documents/"Amiga Files" ~/FS-UAE/AmigaForever/
   ```

## Native compilation

### Install AsmOne

1. Download [AsmOne](http://www.theflamearrows.info/documents/ftp.html)
   ```
   $ curl -O http://www.theflamearrows.info/ftp/asmonev149-RC2.lha
   ```

1. Unpack the AsmOne archive into the FS-UAE working directory
   ```
   $ lha xw=~/FS-UAE/AmigaForever/"Amiga Files"/Shared/dir/Work/AsmOne/ asmonev149-RC2.lha
   ```

### Build demos with AsmOne

1. Start FS-UAE with the A1200 run-configuration
   ```
   $ fs-uae ~/FS-UAE/Configurations/A1200.fs-uae
   ```

1. Start AsmOne

   Open the `Work` disk and execute `AsmOne`

   Enter `Chip` and `200` to allocate 200 KB of chip memory

1. Open demo source file

   Enter `r` to open file

   Enter `sources:src/Program_01.s` to open demo source file

1. Build demo source file

   Enter `a` to assemble demo

   Enter `wo sources:build/Program_01` to write demo to disk

## Cross-compilation

### Install vasm

1. Download [vasm](http://sun.hasenbraten.de/vasm/index.php?view=relsrc)
   ```
   $ curl -O http://sun.hasenbraten.de/vasm/release/vasm.tar.gz
   ```

1. Build [vasm](http://sun.hasenbraten.de/vasm/index.php?view=compile)
   ```
   $ make CPU=m68k SYNTAX=mot
   ```
   The build will generate a binary `vasmm68k_mot`. Put this binary in a user-reachable location (for example `~/bin/`).

### Build demos with vasm

To build the Amiga demo programs, run:
```
$ ninja
```
A `build` directory will be created, containing the demo programs.

## License

Licensed under Creative Commons Attribution Share Alike 4.0 International. See [LICENSE](LICENSE) for more information.

## Authors

* Johan Gardhage
* General ideas and code from Andrew Tyler's book [Amiga Real-Time 3D Graphics](https://www.amazon.co.uk/Amiga-Real-time-3D-Graphics-Virtual/dp/1850582750)
* Original source code and a scanned pdf of the book can be found [here](https://gitlab.com/amigasourcecodepreservation/amiga-real-time-3d-graphics)

## Screenshots

![Screenshot](/screenshots/Program_01.png "Triangle demo")
![Screenshot](/screenshots/Program_02.png "Clipping demo")
![Screenshot](/screenshots/Program_03.png "Texturemap demo")
![Screenshot](/screenshots/Program_04.png "Texturemap demo")
![Screenshot](/screenshots/Program_06.png "Texturemap demo")
![Screenshot](/screenshots/Program_08.png "Multi-object demo")
