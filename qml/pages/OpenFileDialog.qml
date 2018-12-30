import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.talefish.folderlistmodel 1.0
import TaglibPlugin 1.0
import '../lib'

Dialog {

    id: filePicker
    property string currentFolder: "";
    property int lastSelected: -1;
    property bool enqueue: false
    canAccept: useableFiles.count > 0
    property alias useableFiles: useableFilesModel
    property alias selectedFile: selectedFileModel //for only one file
    property alias coverImages: coverImageFolderModel
    property var coverArray:[]
    property alias folderModel: folderModel
    property bool sortByNameAsc: true

    property string coverUrl: ''
    property var currentProgress: ({percent:0, index:0, position:0})
    function getFileSuffixesCaseInsensitive(inputarr){
        var i = inputarr.length,
                outputarr = [],
                tmp = '';
        while(i--){
            tmp = inputarr[i];
            outputarr.push('*.'+tmp.toUpperCase());
            outputarr.push('*.'+tmp.toLowerCase());
            //todo: variations like Mp3, mP3?
        }
        return outputarr;
    }

    property ListModel value
    function getHome() {
        var dirOnly = StandardPaths.documents.split('/'); dirOnly.pop(); dirOnly = dirOnly.join('/');
        return dirOnly || StandardPaths.documents;
    }
    //happens in OptionsPage, so it does not get called so often: onDirectory Changed should rescan for files, put path for audio component in there
    property string home: getHome()
    onCurrentFolderChanged: {
        selectedFile.clear();
        checkCurrentPosition();
    }
    function checkCurrentPosition(){
        var cf = currentFolder.replace('file://', '');
        currentProgress = appstate.savedDirectoryProgress[cf] || {percent:0, index:0, position:0};
        if(currentProgress){
            activeProgressIndicator.percent = currentProgress.percent
            progressSlider.value = currentProgress.percent;
        } else {

            activeProgressIndicator.percent = 0;
            progressSlider.value = 0;

        }


    }


    /*

      Make scanning step work:

    */
    acceptDestination: Qt.resolvedUrl("./OpenFileScanInfosDialog.qml")
    acceptDestinationAction: PageStackAction.Replace
    acceptDestinationProperties: ({
//        defaultCoverUrl: coverUrl,
//        coverArray: coverArray,
//        currentProgress: currentProgress,
        enqueue: enqueue
    })

    /*
      /scanning step
    */


    Component.onCompleted: {


        if(appstate.lastDirectory !== ''){
            folderModel.folder = appstate.lastDirectory;
            currentFolder = appstate.lastDirectory;
        } else {

            folderModel.folder = home;
            currentFolder = home;
        }

//        checkCurrentPosition();

    }

    onAccepted: {


        appstate.lastDirectory = folderModel.folder;
//        playlist gets garbage collected, so we need to populate the data:
        var playlist = selectedFileModel.count ? selectedFileModel : useableFilesModel

        if(sortByNameAsc && options.resortNaturally) {
            playlist.sortNaturally();
        }
        acceptDestinationInstance.playlist.fromJSON(playlist.toJSON())
        //these get killed, as well
        acceptDestinationInstance.defaultCoverUrl = coverUrl;
        acceptDestinationInstance.currentProgress = currentProgress;
        acceptDestinationInstance.coverArray = JSON.parse(JSON.stringify(coverArray));

        acceptDestinationInstance.scan();
    }
    SilicaFlickable {

        id: flickable
        anchors.fill: parent
        contentHeight: childrenRect.height

        PullDownMenu {
            id: menu

            MenuItem {
                text: qsTr("Sort by Name");
                onClicked: {
                    filePicker.sortByNameAsc = true
                    folderModel.sortField = FolderListModel.Name
                }
            }

            MenuItem {
                text: qsTr("Sort by Type");
                onClicked: {

                    filePicker.sortByNameAsc = false
                    folderModel.sortField = FolderListModel.Type
                }
            }

            MenuItem {
                text: qsTr("Sort by Last Modified");
                onClicked: {
                    filePicker.sortByNameAsc = false
                    folderModel.sortField = FolderListModel.Time
                }
            }
        }

        PageHeader {
            id: headertext
            title: filePicker.enqueue ?  qsTr("Enqueue Directory") :  qsTr("Open Directory")
        }


        Image {
            id: topImg
            opacity: 0.5
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            anchors.leftMargin: Theme.paddingLarge
            width: Theme.itemSizeLarge
            height: Theme.itemSizeLarge
            source: coverUrl
            visible: coverUrl !== '' && useableFiles.count > 0
        }
        Text {
            id: enqueueText
            width: parent.width
            anchors.top: headertext.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            //            height: Theme.itemSizeSmall
            wrapMode: Text.Wrap
            font.pixelSize: 25
            color: Theme.primaryColor
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: Theme.paddingSmall
            anchors.rightMargin: Theme.paddingSmall
            text: filePicker.enqueue ? qsTr("Progress will not be saved for reopening enqueued files."):''
            visible: filePicker.enqueue
        }

        BackgroundItem {

            id: parentFolder
            width: parent.width
            height: Theme.itemSizeSmall
            anchors.top: enqueueText.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Image {
                fillMode: Image.Pad
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                anchors.leftMargin: Theme.paddingLarge
                id: folderup
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                rotation: -90
                source: "image://theme/icon-m-page-up"
                visible: currentFolder != "/"
            }

            Text {
                width: parent.width - folderup.width - Theme.paddingLarge * 3
                anchors.top: parent.top
                anchors.left: folderup.right
                anchors.right: parent.right
                height: parent.height
                wrapMode: Text.Wrap
                font.pixelSize: 25
                color: Theme.primaryColor
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: Theme.paddingSmall
                anchors.rightMargin: Theme.paddingSmall
                text: currentFolder
            }



            onClicked: {
                var folder = String(folderModel.parentFolder).replace("file://", "");
                if(folder !== "") {

                    //                    folderModel.useableFiles = 0;
                    currentFolder = folder;
                    folderModel.folder = folderModel.parentFolder;
                }
            }
        }


        Slider {
            id: progressSlider
            value: 0
            visible: value > 0
            opacity: 0.5
            minimumValue: 0
            maximumValue: 100
            enabled: false
            width: parent.width - (topImg.source != '' ? topImg.width:0 )
            handleVisible: false
            anchors.verticalCenter: headertext.bottom
            anchors.right: parent.right
        }
        Label {
            id: selectLabel
            property bool active: !!useableFiles.count
            text: filePicker.enqueue
                  ? qsTr('Click file to enqueue or accept dialog to enqueue %1 file(s)', 'only shown when there are files', useableFiles.count).arg(useableFiles.count)
                  : qsTr('click file to open it or accept dialog to open %1 file(s)', 'only shown when there are files', useableFiles.count).arg(useableFiles.count)
            width: parent.width
            wrapMode: Text.Wrap
            height: useableFiles.count ? Theme.itemSizeSmall : 0
            opacity: useableFiles.count ? 1.0 : 0
            font.pixelSize: Theme.fontSizeSmall
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parentFolder.bottom
            anchors.topMargin: Theme.paddingLarge
            anchors.leftMargin: Theme.paddingLarge
            anchors.rightMargin: Theme.paddingLarge

            Behavior on opacity {
                FadeAnimation {}
            }
            Behavior on height {
                FadeAnimation {}
            }
        }
        Rectangle {
            id: activeProgressIndicator
            height: Theme.itemSizeSmall / 6
            anchors.bottom: selectLabel.bottom
            color: Theme.highlightBackgroundColor
            opacity: Theme.highlightBackgroundOpacity
            width: (percent/100)*parent.width
            property real percent:0.0
            property string cf: currentFolder.replace('file://', '')
        }
        SilicaListView {

            id: fileList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: selectLabel.bottom
            anchors.topMargin: Theme.paddingLarge
            model: folderModel
            height: filePicker.height - headertext.height - parentFolder.height - selectLabel.height - Theme.paddingLarge * 3
            clip: true

            Playlist {
                id: useableFilesModel
                durationScanActive: false
            }

            Playlist {
                id: selectedFileModel
                durationScanActive: false
            }
            FolderListModel {
                id: coverImageFolderModel
                folder: folderModel.folder

                showOnlyReadable: true
                nameFilters: getFileSuffixesCaseInsensitive(["jpg","jpeg", "png", "bmp"])
                onCountChanged: {
                    var ci = count
                    coverUrl = '';
                    var candidates = [];
                    var exportArr = [];
                    if(ci > 0){
                        //find something like cover.jpg
                        while(ci--){
                            var lowerBase = get(ci, 'fileBaseName').toLowerCase();
                            if(!isFolder(ci) && get(ci, 'fileSize') > 0){
                                var ex = {baseName: get(ci, 'fileBaseName'), path: get(ci, 'filePath')};
                                //                                app.log('covercandidate:', lowerBase,  get(ci, 'fileSize'))
                                if(lowerBase === 'cover' || (coverUrl === '' && lowerBase.indexOf('cover') > -1)){
                                    candidates[0] = get(ci, 'filePath');
                                } else {
                                    candidates.push(get(ci, 'filePath'));
                                }
                                exportArr.push(ex);
                            }

                        }
                        if(candidates.length){
//                            console.log('set coverUrl', candidates[0]);
                            coverUrl = candidates[0];
                        }
                        coverArray = exportArr;
                    }
                }
            }

            FolderListModel {
                id: folderModel
                showOnlyReadable: true
                nameFilters: getFileSuffixesCaseInsensitive(["mp3", "m4a", "m4b", "flac", "ogg", "wav", "opus", "aac", "mka"])
                property int useableFiles: 0
                property int lastCount: 0
                folder: appstate.lastDirectory
                property string folderName
                property var baseNameRegex: /(.*)\.[^.]+$/
                property var findDotRegex: /\./g
                function readFolderName(){
                    var re = /([^\/]+)[\/]*$/,
                            match = re.exec(String(folder));
                    folderName = match[1]||'';
                    return folderName;
                }

                onFolderChanged: {

                    readFolderName()
                }
                Component.onCompleted: {

                    readFolderName()
                }

                function getIndexInfo(i){
                    var fileinfo = {
                        name:get(i,'fileName'),
                        path:get(i,'filePath'),
                        url:get(i,'fileURL'),
                        baseName:get(i,'fileName').replace(baseNameRegex, '$1').replace(findDotRegex, ' '),
                        suffix:get(i,'fileSuffix'),
                        size:get(i,'fileSize'),
                        folder: folder+'',
                        folderName: folderName.replace(findDotRegex, ' '),
                        duration:0,
                        artist:'',
                        album:'',
                        track:-1,
                        playlistOffset:0,
                        title:'',
                        coverImage:''
                    }

                    return fileinfo
                }
                function updateUseableFiles() {

                    readFolderName()
                    var filesInfo = [];
                    useableFilesModel.clear();

                    if(count > lastCount){
                        var i = 0;
                        while(i < count) {
                            if(!folderModel.isFolder(i)){
                                useableFilesModel.append(getIndexInfo(i));
                            }
                            i++;
                        }
                    }
                    lastCount = 0;
                }

                onCountChanged: {
                    updateUseableFiles();
                }
            }

            delegate: BackgroundItem {
                TaglibPlugin {
                    id: taglibplugin
                    onTagInfos: {
                        //update useableFiles with tag info
                        var i = 0;
                        var foundIndex = -1;
                        while(i < useableFilesModel.count) {
                            if(useableFilesModel.get(i).path === filePath) {
                                foundIndex = i;
                                break;
                            }
                            i++;
                        }
                        if(foundIndex > -1) {
                            app.log('tag info found in useableFiles', path)
                            useableFilesModel.setProperty(i, 'duration', duration);
                            useableFilesModel.setProperty(i, 'artist', artist);
                            useableFilesModel.setProperty(i, 'album', album);
                            useableFilesModel.setProperty(i, 'track', track);
                        } else {
                            app.log('not found in useableFiles', path)
                        }
                    }
                    Component.onCompleted: {
                        if(!fileIsDir) {
                            taglibplugin.getFileTagInfos(filePath);
                        }


                    }
                }

                Rectangle {
                    visible: !!appstate.savedDirectoryProgress[String(filePath)]
                    height: Theme.itemSizeSmall / 6
                    anchors.bottom: parent.bottom
                    color: Theme.highlightBackgroundColor
                    property string cf: String(filePath)
                    opacity: Theme.highlightBackgroundOpacity
                    width: appstate.savedDirectoryProgress[cf]?appstate.savedDirectoryProgress[cf].percent * parent.width / 100 : 0
                }

                id: fileDelegate
                width: parent.width
                height: Theme.itemSizeSmall
                anchors.left: parent.left
                anchors.right: parent.right


                Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    id: foldericon
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: Theme.paddingLarge
                    source: "image://theme/icon-m-folder"
                    visible: fileIsDir

                }
                Label {
                    id: durationLabel
                    visible: taglibplugin.loaded && taglibplugin.duration > 0 && !fileIsDir
                    anchors {
                        right: parent.right
                        rightMargin: Theme.paddingLarge
                        topMargin: 15
                    }
                    text: app.formatMSeconds(taglibplugin.duration)
                }

                Label {
                    id: namelabel
                    anchors {
                        left: if(fileIsDir) {
                                  foldericon.right
                              } else {
                                  parent.left
                              }
                        right: if(durationLabel.visible) {
                                   durationLabel.left
                               } else {
                                   parent.right
                               }
                        leftMargin: Theme.paddingLarge
                        rightMargin: Theme.paddingLarge
                        topMargin: 15
                    }
                    truncationMode: TruncationMode.Fade
                    textFormat: Text.RichText
                    text:  fileName
                }

                Label {
                    id: sizelabel
                    anchors {
                        left: if(fileIsDir) {
                                  foldericon.right
                              } else {
                                  parent.left
                              }
                        right: parent.right
                        top: namelabel.bottom
                        leftMargin: Theme.paddingLarge
                        rightMargin: Theme.paddingLarge
                    }

                    font.pixelSize: 20
                    textFormat: Text.RichText
                    text: durationLabel.visible
                              ? taglibplugin.track + ' - ' + taglibplugin.artist + ' - ' + taglibplugin.title
                              : parseInt(fileSize) / 1000 + " kB, " + fileModified// + ' - ' + tagDuration
                    color: Theme.rgba(Theme.secondaryColor, 0.5)
                }

                onClicked: {
                    selectedFile.clear();
                    if(folderModel.isFolder(index)) {
                        lastSelected = -1;
                        folderModel.folder = filePath;
                        currentFolder = String(filePath).replace("file://", "");
                    } else {
                        canAccept = true;
                        var indexInfo = folderModel.getIndexInfo(index);
                        indexInfo.folder = indexInfo.path;
                        selectedFile.append(indexInfo);//fileURL;

                        currentProgress = appstate.savedDirectoryProgress[indexInfo.folder] || {percent:0, index:0, position:0};
                        filePicker.accept();
                    }
                }
            }

            VerticalScrollDecorator {
                flickable: fileList
            }
        }
    }
}
