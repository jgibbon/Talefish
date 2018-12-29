import QtQuick 2.0

ListModel {
    id: playlist
    property bool getDurationOnChange: true
    property bool durationScanActive: true //to totally deactivate scanning
    property bool getActiveOnChange: true
    property real duration: getDuration()

    function getDuration(){
        if(!durationScanActive) { return 0; }
        var i = 0, d = 0.0, tmp;
//        console.log('GET DURATION');
        while(i < playlist.count){
            tmp = playlist.get(i);
            playlist.setProperty(i, 'playlistOffset', d);
            if(tmp.duration > 0){
                d = d + tmp.duration;
            }
//            console.log('+', tmp.duration)
            i++;
        }
//        console.log('concrete duration', d);
        duration = d;
    }
    onCountChanged: {
        if(getDurationOnChange){//set this to false initially
            getDuration();
        }
    }

    function sortNaturally(){
        var out = [], i = 0, aMatch, bMatch, a1, b1, rda, rdb, regexall=/(\d+)|(\D+)/g, regexnum=/\d+/;
        while(i < playlist.count){
            out.push(playlist.get(i));
            i++;
        }
        out.sort(function(a, b){
                    aMatch = String(a.name).toLowerCase().match(regexall);
                    bMatch = String(b.name).toLowerCase().match(regexall);
                    while(aMatch.length && bMatch.length){
                        a1 = aMatch.shift();
                        rda = regexnum.test(a1);
                        b1 = bMatch.shift();
                        rdb = regexnum.test(b1);
                        if(rda || rdb){
                            if(!rda) {
                                return 1;
                            }
                            if(!rdb) {
                                return -1;
                            }
                            if(a1 !== b1) {
                                return a1 - b1;
                            }
                        }
                        else if(a1 !== b1) {
                            return a1 > b1 ? 1 : -1;
                        }
                    }
                    return aMatch.length - bMatch.length;
                });

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

