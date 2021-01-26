.pragma library

function lib() {
    return {
        test: 'bla',
        isBetweenTimes: function(start, end) {
            var current = new Date();
            current.setFullYear(1970);
            current.setMonth(0,1);

            start.setFullYear(1970);
            start.setMonth(0,1);
            end.setFullYear(1970);
            end.setMonth(0,1);
            var timeIsRight;
            if(end < start) {
                //assume 'before' is next day
                timeIsRight = current > start || current < end
            } else {
                timeIsRight = current > start && current < end
            }
            return timeIsRight;
        },
        formatMSeconds: function (duration) {
            var dur = duration / 1000,
                    hours =  Math.floor(dur /3600),
                    hourSeconds = hours * 3600,
                    minutes =  Math.floor((dur - hourSeconds) / 60),
                    seconds = Math.floor(dur - (hourSeconds) - minutes * 60);

            return (hours?(hours+':'):'')+ ("0"+minutes).slice(-2) + ':' + ("0"+seconds).slice(-2);
        },
        fileName: function(path, getBaseName) {
            if(path && path !== '') {
                var re = /([^\/]+)[\/]*$/,
                        match = re.exec(path);
                if(match && match.length > 0) {
                    var fileName = match[1]||'';
                    if(getBaseName) {
                        var re2 = /(.*)\.[^.]+$/;
                        var baseMatch = re2.exec(fileName)
                        if(baseMatch && baseMatch.length > 0) {
                            fileName = baseMatch[1];
                        }
                    }
                    return fileName
                }
            }
            return ''
        },
        filePath: function(path) {
            var pathString = String(path);
            if(pathString && pathString !== '') {
                return pathString.slice(0, pathString.lastIndexOf('/'));
            }
            return '';
        }

    };
}
