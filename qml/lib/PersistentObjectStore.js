.pragma library // jshint ignore:line
var locstorage;
var db;
var settings = ['SettingsDB','1.0','Settings'];
function getDatabase() {
    if(!db) db = locstorage.openDatabaseSync(settings[0],settings[1],settings[2], 5000);
    return db;
}

function initialize(sttngs, ls) {
    if(sttngs && sttngs.length) {
        settings = sttngs;
    }
    if(ls){
        locstorage = ls;
    }
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    // Create the settings table if it doesn't already exist
                    // If the table exists, this is skipped
                    tx.executeSql('CREATE TABLE IF NOT EXISTS settings(settingsName TEXT, keyName TEXT, value TEXT)');
                    tx.executeSql('CREATE INDEX IF NOT EXISTS settingsName ON settings (settingsName);');
                    tx.executeSql('CREATE UNIQUE INDEX IF NOT EXISTS fullKeyName ON settings (settingsName, keyName);');
                }
                );
    console.log('DB initialized', settings[3]);
}
function reset() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    // Create the settings table if it doesn't already exist
                    // If the table exists, this is skipped
                    tx.executeSql('DROP TABLE IF EXISTS settings');
                }
                );
}

function save(obj, keys) {
    var db = getDatabase();
    db.transaction(
                function (tx) {
                    // Save all fields
                    var skippedAttributes = ['objectName', 'doPersist', 'storeSettings', '_loaded', 'reset'];
                    var haskeys = !!keys;
                    if(!haskeys) {
                        // Clean all fields of this settings object first, so the DB is always clean from unused fields
                        tx.executeSql('DELETE FROM settings WHERE settingsName=?;', [obj.objectName]);
                        keys = Object.keys(obj);
                    }
                    keys.forEach(function(fieldName) {
                        var value = JSON.stringify(obj[fieldName]);
                        if(haskeys) {
                            tx.executeSql('DELETE FROM settings WHERE settingsName=? AND keyName=?;', [obj.objectName, fieldName]);
                        }

                        //values starting with 'on' should be blatantly ignored.
                        if (typeof value === 'undefined' || skippedAttributes.indexOf(fieldName) > -1 || fieldName.lastIndexOf('on', 0) === 0) {
                            //                    console.log("NOT Saved: " + obj.objectName + "." + fieldName + " => " + value + "("+typeof obj[fieldName]+")");
                            return;
                        }

                        tx.executeSql('INSERT INTO settings (settingsName, keyName, value) VALUES (?, ?, ?);', [obj.objectName, fieldName, value]);
//                                        console.log("Saved: " + obj.objectName + "." + fieldName + " => " + value + "("+typeof obj[fieldName]+")");
                    })
                }
                );
}

function load(obj) {
    var db = getDatabase();
    db.transaction(
                function (tx) {

                    // Load fields
                    for (var fieldName in obj) {
                        //values starting with 'on' should be blatantly ignored
                        if ( true || fieldName.lastIndexOf('on', 0) !== 0) {

                            var rs = tx.executeSql('SELECT value FROM settings WHERE settingsName=? AND keyName=?;', [obj.objectName, fieldName]);

                            if (rs.rows.length > 0 && fieldName !== 'doPersist') {
                                obj[fieldName] = JSON.parse(rs.rows.item(0).value);
                                //                        console.log("Loaded: " + obj.objectName + "." + fieldName + ". New value: " + JSON.stringify(obj[fieldName]));
                            }// else { console.log("Not loaded: " + obj.objectName + "." + fieldName + ". Current value:" + obj[fieldName] + "("+typeof obj[fieldName]+")"); }

                        }
                    }
                    obj._loaded = true
                }
                );
}
