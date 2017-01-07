import QtQuick 2.0

ListModel {
    id: playlist
    property bool getDurationOnChange: true
    property bool getActiveOnChange: true
    property real duration: getDuration()

    function getDuration(){
        var i = 0, d = 0.0, tmp;
        while(i < playlist.count){
            tmp = playlist.get(i);
            playlist.setProperty(i, 'playlistOffset', d);
            if(tmp.duration > 0){
                d = d + tmp.duration;
            }
            i++;
        }
        duration = d;
    }
    onCountChanged: {
        if(getDurationOnChange){//set this to false initially
            getDuration();
        }
    }

    function sortNaturally(){
        function alphanum(a, b) {
            function chunkify(t) {
                var tz = new Array();
                var x = 0, y = -1, n = 0, i, j;

                while (i = (j = t.charAt(x++)).charCodeAt(0)) {
                    var m = (i == 46 || (i >=48 && i <= 57));
                    if (m !== n) {
                        tz[++y] = "";
                        n = m;
                    }
                    tz[y] += j;
                }
                return tz;
            }

            var aa = chunkify(a.name);
            var bb = chunkify(b.name);

            for (x = 0; aa[x] && bb[x]; x++) {
                if (aa[x] !== bb[x]) {
                    var c = Number(aa[x]), d = Number(bb[x]);
                    if (c == aa[x] && d == bb[x]) {
                        return c - d;
                    } else return (aa[x] > bb[x]) ? 1 : -1;
                }
            }
            return aa.length - bb.length;
        }
        var out = [], i = 0;
        while(i < playlist.count){
            out.push(playlist.get(i));
            i++;
        }
        out.sort(alphanum);

        fromJSON(JSON.stringify(out));

    }
    function toJSON(){
        var out = [], i = 0;
        while(i < playlist.count){
            out.push(playlist.get(i));
            i++;
        }
        return JSON.stringify(out);
    }
    function fromJSON(json, append){
        getDurationOnChange = false;
        getActiveOnChange = false;
        var out = typeof json === 'string'
                ? JSON.parse(json)
                : json,
                  i = 0;
        if(!append) {
            playlist.clear();
        }
        while(out && i < out.length){
            playlist.append(out[i]);
            i++;
        }
        getDurationOnChange = true;
        getActiveOnChange = true;
        getDuration();
        if(typeof updatePlaylistActive !== 'undefined') updatePlaylistActive();
    }

}

