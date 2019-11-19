![talefish logo](https://i.imgur.com/fx1rcDv.png "talefish")

# Talefish
[Talefish](https://www.github.com/jgibbon/talefish) is a directory based audio book player for SailfishOS.

One of the main goals of Talefish is to provide a place to listen to your audio books separated from the system media library. Of course you can use it for other audio files like podcasts you've already downloaded.

Be sure to check out the application options by using the main page pulley menu. 
Some of the current features are:

- Remember listening position – even if you've opened another directory since
- Custom Playback Speed (within the limits of qml Audio)
- Metadata support for most common file types
- Album Cover support for most common file types with fallback for image files in the currently opened directory
- Skip forward/back by predefined durations or swipe the album cover area to skip to track beginnings
- Slumber sleep timer integration: Rewind a bit if Talefish is paused by slumber
- Open files from other applications by using mimer
- Open files/directories from the command line (-e to enqueue to current Playlist)

Hint: Create a file called ".nomedia" in your main audio book directory to keep the SailfishOS media library (tracker) from indexing it if you don't want those files to show up in the default media player.

## Discuss:
https://talk.maemo.org/showthread.php?p=1521568
## Translate:
Translation help is always appreciated! You can join the awesome translation team here to help out: 

https://www.transifex.com/velocode/talefish (please use this instead of pull requests for translations if possible)

[![translation chart](https://www.transifex.com/projects/p/talefish/resource/talefishts/chart/image_png/)](https://www.transifex.com/velocode/talefish "Talefish on Transifex")

## Install:
Talefish is available on Openrepos: 
https://openrepos.net/content/velox/talefish

If you know what you're doing, you can also add the Open Build Service repository, 
which is sometimes updated with pre-release versions: https://build.sailfishos.org/package/show/home:velox/harbour-talefish

## Acknowledgements
Talefish uses and includes unmodified or modified versions of the following software components under the terms of the LGPL 2.1 license:
 - [Taglib](https://taglib.org)
 - [Qt Folderlistmodel](https://code.qt.io/cgit/qt/qtdeclarative.git/tree/src/imports/folderlistmodel?h=5.6)


## License

    Talefish Audiobook Player
    Copyright (C) 2016-2019  John Gibbon

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.