/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import '../lib'

Page {
    id: page

    function formatMSeconds (duration, debug) { //todo: just use once globally instead of copying it all over the place
        var dur = duration / 1000,
                hours =  Math.floor(dur /3600),
                minutes =  Math.floor((dur - hours * 3600) / 60),
                seconds = Math.floor(dur - (hours * 3600) - minutes * 60);
        if(debug) {
            console.log('formatting duration', duration);
            console.log(dur);
            console.log(hours + 'h');
            console.log(minutes, ' -> ', ("0"+minutes).slice(-2));
            console.log(seconds, ' -> ', ("0"+seconds).slice(-2));
        }
        return (hours?(hours+':'):'')+ ("0"+minutes).slice(-2) + ':' + ("0"+seconds).slice(-2);
    }
    Column {
        id: header
        height: pageHeader.height + subHeader.height
        width: parent.width
        PageHeader {
            id: pageHeader
            width: parent.width
            title: qsTr("%L1 file(s) opened", '', appstate.playlist.count).arg(appstate.playlist.count)
        }

        SectionHeader {
            id: subHeader
            text:  qsTr('%1 of %2 played (track %3)').arg(formatMSeconds((appstate.playlistActive ? appstate.playlistActive.playlistOffset:0) + appstate.currentPosition)).arg(formatMSeconds(appstate.playlist.duration)).arg(appstate.playlistIndex + 1)
        }
    }
    PlaylistView {
        id: listView
        clip: true
        model: appstate.playlist
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom


        VerticalScrollDecorator{

        }

    }

}





