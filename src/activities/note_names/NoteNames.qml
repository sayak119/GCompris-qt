/* GCompris - NoteNames.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Controls 1.0
import GCompris 1.0

import "../../core"
import "../playpiano"
import "note_names.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"

        property bool keyboardMode: false
        property bool horizontalLayout: background.width > background.height ? true : false

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCAudio audioEffects: activity.audioEffects
            property alias staff: staff
            property alias bar: bar
            property alias bonus: bonus
            property alias gridRepeater: gridRepeater
            property alias score: score
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rectangle {
            id: instructionBox
            radius: 10
            width: background.width / 1.9
            height: horizontalLayout ? background.height / 5 : background.height / 4
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.8
            border.width: 6
            color: "white"
            border.color: "#87A6DD"

            GCText {
                id: instructionText
                visible: !staffText.visible
                color: "black"
                z: 3
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                text: [2, 3, 4, 12, 13, 14].indexOf(bar.level) !== -1 ?
                    qsTr("Click on the note name to match the pitch. Then click OK to check.") :
                    [5, 6, 7, 15, 16, 17].indexOf(bar.level) !== -1 ?
                        qsTr("Now there are sharp notes. These pitches are raised a half step.") :
                        // [8, 9, 10, 18, 19, 20]
                        qsTr("Now there are flat notes. These pitches are lowered a half step.")
            }

            GCText {
                id: staffText
                visible: bar.level == 1 || bar.level == 11
                height: background.height / 5
                width: background.width / 1.5
                z: 3
                color: "black"
                anchors.horizontalCenter: parent.horizontalCenter
                fontSizeMode: Text.Fit
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: bar.level == 1 ? qsTr("These are the eight basic notes in treble clef. They form the C Major Scale.") :
                                       qsTr("These are the eight basic notes in bass clef. They also form the C Major Scale. Notice that the note positions are different than in treble clef.")
            }
        }

        Rectangle {
            id: playScaleButton
            width: horizontalLayout ? parent.width * 0.3 : parent.width * 0.45
            height: 30 * ApplicationInfo.ratio
            color: "#d8ffffff"
            border.color: "#2a2a2a"
            border.width: 3
            radius: 8
            z: 5
            anchors.top: instructionBox.bottom
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            visible: bar.level == 1 || bar.level == 11

            GCText {
                id: playScaleButtonText
                anchors.centerIn: parent
                text: qsTr("Play scale")
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
            }

            MouseArea {
                id: playScaleButtonArea
                anchors.fill: parent
                onClicked: {
                    staff.play()
                }
            }
            states: [
                State {
                    name: "notclicked"
                    PropertyChanges {
                        target: playScaleButton
                        scale: 1.0
                    }
                },
                State {
                    name: "clicked"
                    when: playScaleButtonArea.pressed
                    PropertyChanges {
                        target: playScaleButton
                        scale: 0.9
                    }
                },
                State {
                    name: "hover"
                    when: playScaleButtonArea.containsMouse
                    PropertyChanges {
                        target: playScaleButton
                        scale: 1.1
                    }
                }
            ]
            Behavior on scale { NumberAnimation { duration: 70 } }
        }

        Rectangle {
            id: playButton
            width: horizontalLayout ? parent.width * 0.3 : parent.width * 0.45
            height: 30 * ApplicationInfo.ratio
            color: "#d8ffffff"
            border.color: "#2a2a2a"
            border.width: 3
            radius: 8
            z: 5
            anchors.top: staff.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            visible: bar.level == 1 || bar.level == 11

            GCText {
                id: playButtonText
                anchors.centerIn: parent
                text: bar.level == 1 ? qsTr("Play Treble Clef") : qsTr("Play Bass Style")
                fontSizeMode: Text.Fit
                wrapMode: Text.Wrap
            }

            MouseArea {
                id: playButtonArea
                anchors.fill: parent
                onClicked: {
                    Activity.nextLevel()
                }
            }
            states: [
                State {
                    name: "notclicked"
                    PropertyChanges {
                        target: playButton
                        scale: 1.0
                    }
                },
                State {
                    name: "clicked"
                    when: playButtonArea.pressed
                    PropertyChanges {
                        target: playButton
                        scale: 0.9
                    }
                },
                State {
                    name: "hover"
                    when: playButtonArea.containsMouse
                    PropertyChanges {
                        target: playScaleButton
                        scale: 1.1
                    }
                }
            ]
            Behavior on scale { NumberAnimation { duration: 70 } }
        }

        MultipleStaff {
            id: staff
            nbStaves: 1
            clef: bar.level <= 10 ? "treble" : "bass"
            height: background.height / 4
            width: bar.level == 1 || bar.level == 11 ? background.width * 0.8 : background.width / 2
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height / 1.5
            anchors.horizontalCenter: bar.level == 1 || bar.level == 11 ? parent.horizontalCenter : undefined
            nbMaxNotesPerStaff: bar.level == 1 || bar.level == 11 ? 8 : 1
            firstNoteX: bar.level == 1 || bar.level == 11 ? width / 5 : width / 2
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Space) {
                grid.currentItem.select()
            }
        }
        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onEnterPressed: grid.currentItem.select();
        Keys.onReturnPressed: grid.currentItem.select();
        Keys.onRightPressed: grid.moveCurrentIndexRight();
        Keys.onLeftPressed: grid.moveCurrentIndexLeft();
        Keys.onDownPressed: grid.moveCurrentIndexDown();
        Keys.onUpPressed: grid.moveCurrentIndexUp();

        ListModel {
            id: gridRepeater
        }

        GridView {
            id: grid
            visible: instructionText.visible
            anchors {
                left: staff.right
                right: background.right
                leftMargin: 15 * ApplicationInfo.ratio
                rightMargin: 50 * ApplicationInfo.ratio
                top: playScaleButton.bottom
            }
            keyNavigationWraps: true
            interactive: false
            model: gridRepeater
            cellWidth: itemWidth + 10
            cellHeight: itemHeight + 10
            height: staff.height

            property int itemWidth: 60
            property int itemHeight: itemWidth

            delegate: Rectangle {
                id: noteRectangle
                color: staff.noteIsColored ? dummyNote.noteColorMap[note] : "white"
                width: grid.itemWidth
                height: grid.itemHeight
                radius: width / 5
                border.color: "black"

                GCText {
                    id: noteText
                    text: parseInt(note) > 0 ? dummyNote.whiteNoteName[note] : dummyNote.blackNoteName[note]
                    anchors.centerIn: parent
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                }
                MouseArea {
                    id: buttonClick
                    anchors.fill: parent
                    onClicked: select()
                }

                function select() {
                    grid.currentIndex = index
                    var noteToPlay = 'qrc:/gcompris/src/activities/playpiano/resource/' + 'bass' + '_pitches/' + '1' + '/' + note + '.wav';
                    items.audioEffects.play(noteToPlay);
                    okButton.currentAnswer = note
                }
            }

            highlight: Rectangle {
                id: noteHighlight
                color: "red"
                opacity: 0.6
                border.width: 1.1
                border.color: "white"
            }
        }

        // Never visible, only used to access the note names, colors
        Note {
            id: dummyNote
            visible: false
            value: "1"
            blackType: [8, 9, 10, 18, 19, 20].indexOf(bar.level) === -1 ? "sharp" : "flat"
        }

        Image {
            id: okButton
            visible: instructionText.visible
            source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: parent.width * 0.1
            height: parent.width * 0.1
            anchors {
                right: background.right
                bottom: score.top
                bottomMargin: 20
                rightMargin: 20
            }
            property string currentAnswer: ""
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(okButton.currentAnswer !== "")
                        Activity.checkAnswer(okButton.currentAnswer);
                    okButton.currentAnswer = ""
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            anchors.bottom: background.bottom
            anchors.right: background.right
            visible: bar.level !== 1 && bar.level !== 11
        }
    }
}
