/* GCompris - PlayRhytm.qml
 *
 * Copyright (C) 2017 Utkarsh Tiwari <iamutkarshtiwari@gmail.com>
 *
 * Authors:
 *   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
 *   Utkarsh Tiwari <iamutkarshtiwari@gmail.com> (Qt Quick port)
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
import QtGraphicalEffects 1.0
import QtMultimedia 5.0
import GCompris 1.0

import "../../core"
import "play_rhythm.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.rhythmURL + "background/" + Activity.backgroundNumber +".jpg"
        width: activity.width
        height: activity.height

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
            property alias bar: bar
            property alias bonus: bonus
            property alias drumArea: drumArea
            property alias animateBar: animateBar
            property GCAudio audioEffects: activity.audioEffects
            property bool wasPlayPressed: false
            property int drumCount: 0
            property bool isCorrect: true
            property bool hasGameStarted: true
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Image {
            id: metronome
            source: Activity.rhythmURL + "metronome.svg"
            width: trebleClef.width * 1.2
            height: trebleClef.height
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: width / 2
            }
            MouseArea {
                id: metronomeArea
                enabled: true
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    if (metronomeSound.playbackState == Audio.PlayingState) {
                        metronomeSound.stop()
                    } else {
                        metronomeSound.play()
                    }
                }
            }
            states: State {
                name: "metronomeHover"
                when: metronomeArea.containsMouse
                PropertyChanges {
                    target: metronome
                    scale: 1.1
                }
            }
            Audio {
                id: metronomeSound
                source: Activity.rhythmURL +"sound/click.wav"
                loops: Audio.Infinite
            }
        }

        // Drum at the top
        Image {
            id: drum
            anchors.horizontalCenter: background.horizontalCenter
            y: background.height / 16
            source: Activity.rhythmURL + 'drumhead.svg'
            width: background.width / 5
            height: background.height / 8
            visible: (!animateBar.running || !items.wasPlayPressed) && !items.hasGameStarted && !clear.visible

            MouseArea {
                id: drumArea
                anchors.fill: drum
                enabled: parent.visible
                hoverEnabled: true
                onClicked: {
                    items.wasPlayPressed = false;
                    if (!animateBar.running) {
                        items.drumCount = 0;
                        items.isCorrect = true;
                        animateBar.start();
                    }
                    if (items.drumCount < Activity.noteCount) {
                        items.drumCount++;
                        drumSound.stop();
                        drumSound.play(Activity.pianoURL + "treble_pitches/4/1.wav");
                    }
                }
            }
            states: State {
                name: "drumHover"
                when: drumArea.containsMouse
                PropertyChanges {
                    target: drum
                    scale: 1.1
                }
            }
            Audio {
                id: drumSound
                source: Activity.pianoURL + "treble_pitches/4/1.wav"
            }
        }

        // Label above the notes
        Rectangle {
            id: label
            color: 'white'
            anchors {
                top: drum.bottom
                horizontalCenter: background.horizontalCenter
                topMargin: background.height * 0.05
            }
            height: background.height / 14
            width: background.width / 2
            border {
                width : background.height * 0.01
                color: 'black'
            }
            radius: height * 0.1

            GCText {
                text: qsTr("Beat Count: ")
                color: 'black'
                fontSize: tinySize
                font.weight: Font.DemiBold
                anchors {
                    left: parent.left
                    leftMargin: parent.width * 0.02
                    verticalCenter: parent.verticalCenter
                }
            }

            Repeater {
                model: Activity.noteCount
                GCText {
                    text: qsTr("1")
                    color: 'black'
                    fontSize: tinySize
                    font.weight: Font.DemiBold
                    anchors.verticalCenter: parent.verticalCenter
                    x: (parent.width * 0.38) + ((parent.width / 6) * index)
                }
            }
        }


        Item {
            id: notesArea
            anchors.horizontalCenter: background.horizontalCenter
            width: background.width / 2
            height: background.height * 0.28
            y: background.height / 3

            // Horizontal lines
            Repeater {
                model: 5
                Rectangle {
                    id: lines
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: index * (background.height / 18)
                    visible: true
                    color: 'black'
                    width: background.width / 2
                    height: background.height * 0.01
                }
            }
            Image {
                id: trebleClef
                source: Activity.rhythmURL + 'trebleClef.svg'
                height: background.height * 0.28
                width: background.width * 0.08
                x: 0
                anchors {
                    top: parent.top
                }
            }
            // Vertical bars at the right end
            Repeater {
                id: verticalBars
                model: 2
                Rectangle {
                    width: background.width * (0.01 - (index * 0.004))
                    height: background.height * 0.23
                    x: parent.width - width - ((background.width / 2) * 0.05 * index)
                    anchors.top: parent.top
                    color: 'black'
                    visible: true
                }
            }
            // The moving bar
            Rectangle {
                id: movingBar
                anchors.top: parent.top
                x: (parent.width * (1 / 3)) * 0.95
                width: background.width * 0.006
                height: background.height * 0.23
                color: 'black'
                visible: animateBar.running

                onXChanged: {
                    if (movingBar.x >= verticalBars.itemAt(1).x) {
                        animateBar.stop();
                    }
                }
                PropertyAnimation {
                    id: animateBar
                    target: movingBar
                    properties: "x"
                    from: (notesArea.width * (1 / 3)) * ((items.wasPlayPressed) ? 0.95 : 1)
                    to: notesArea.width * 0.8
                    duration: 4000
                    easing.type: Easing.Linear
                    loops: 1
                    alwaysRunToEnd: true
                    onStopped: {
                        // Drum was used to start animation
                        if (!items.wasPlayPressed) {
                            if (items.isCorrect) {
                                items.bonus.good("flower");
                            } else {
                                items.bonus.bad("flower");
                                clear.visible = true;
                            }
                        }
                    }
                }

            }

            // Notes setup
            Repeater {
                id: notes
                model: Activity.noteCount
                Image {
                    id: note
                    height: background.height * 0.17
                    width: background.width * 0.04
                    y: parent.height / 2.5
                    x: (parent.width * (1 / 3)) + ((parent.width / 6) * index)
                    source: Activity.rhythmURL + "halfNote.svg"
                    ColorOverlay {
                        anchors.fill: note
                        source: note
                        color: "#22ff00"
                    }

                    // Highlight Image
                    Image {
                        id: highlight
                        z: +1
                        source: Activity.rhythmURL + Activity.highlighter[0] + ".svg"
                        width: note.width
                        height: note.height * 0.4
                        anchors.bottom: note.bottom
                        visible: (items.drumCount >= (index + 1)) || (items.wasPlayPressed && movingBar.x >= note.x && movingBar.x <= (note.x + note.width)) ? true : false

                        onVisibleChanged: {
                            if (!items.wasPlayPressed) {
                                if (movingBar.x >= note.x && movingBar.x <= (note.x + note.width)) {
                                    // On pass
                                    source = Activity.rhythmURL + Activity.highlighter[1] + ".svg";
                                } else {
                                    // On fail
                                    source = Activity.rhythmURL + Activity.highlighter[2] + ".svg";
                                    items.isCorrect = false;
                                }
                            } else {
                                // On demo
                                source = Activity.rhythmURL + Activity.highlighter[0] + ".svg";
                            }

                            if (visible == true) {
                                notesSound.stop();
                                notesSound.play(Activity.pianoURL + "treble_pitches/4/1.wav")
                            }
                        }
                    }
                }
            }
            Audio {
                id: notesSound
                source: Activity.pianoURL + "treble_pitches/4/1.wav"
            }
        }

        // Instruction message at the bottom of notes area
        Rectangle {
            id: bottomMessages
            height: childrenRect.height
            width: childrenRect.width * 1.08
            color: "#80808070"
            radius: height * 0.1
            anchors {
                top: notesArea.bottom
                topMargin: notesArea.height * 0.1
                horizontalCenter: background.horizontalCenter
            }
            border {
                color: "black"
                width: background.height * 0.005
            }
            GCText {
                id: message
                text: clear.visible ? qsTr("Click erase to try again.") : (animateBar.running || Activity.isRestarted) ? Activity.listenMsg : Activity.instructionMsg
                color: 'black'
                fontSize: tinySize
                font.weight: Font.DemiBold
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        // Green play button at the game start
        Rectangle {
            id: startPlay
            height: childrenRect.height
            width: childrenRect.width * 1.08
            color: "green"
            visible: items.hasGameStarted
            radius: height * 0.1
            anchors {
                top: bottomMessages.bottom
                topMargin: notesArea.height * 0.1
                horizontalCenter: background.horizontalCenter
            }
            border {
                color: "black"
                width: background.height * 0.005
            }
            MouseArea {
                id: startPlayArea
                enabled: true
                hoverEnabled: true
                anchors.fill: parent
                onClicked: {
                    items.hasGameStarted = false;
                    items.wasPlayPressed = true;
                    animateBar.start();
                }
            }
            states: State {
                name: "startPlayHover"
                when: startPlayArea.containsMouse
                PropertyChanges {
                    target: startPlay
                    scale: 1.1
                }
            }
            GCText {
                text: qsTr("I am Ready")
                color: 'white'
                fontSize: smallSize
                font.weight: Font.DemiBold
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            id: rightButtons
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: width / 6
            }
            width: parent.width / 6.5
            height: parent.width / 10
            color: "#80808070"
            border {
                color: 'black'
                width: background.height * 0.01
            }
            radius: height * 0.1

            Image {
                id: play
                source: Activity.rhythmURL + "play.svg"
                width: parent.width * 0.4
                height: parent.height * 0.7
                opacity: 1
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: width * 0.1
                }
                visible: drum.visible

                MouseArea {
                    id: playArea
                    enabled: true
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        items.wasPlayPressed = true;
                        items.drumCount = 0;
                        items.isCorrect = true;
                        if (!animateBar.running) {
                            animateBar.start();
                        }
                    }
                }
                states: State {
                    name: "playHover"
                    when: playArea.containsMouse
                    PropertyChanges {
                        target: play
                        scale: 1.1
                    }
                }
            }
            Image {
                id: clear
                source: Activity.rhythmURL + "edit-clear.svg"
                width: parent.width * 0.4
                height: parent.height * 0.7
                opacity: 1
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: width * 0.1
                }
                visible: false

                MouseArea {
                    id: clearArea
                    enabled: true
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        clear.visible = false;
                        Activity.resetLevel();
                    }
                }
                states: State {
                    name: "clearHover"
                    when: clearArea.containsMouse
                    PropertyChanges {
                        target: clear
                        scale: 1.1
                    }
                }
            }
        }


        DialogHelp {
            id: dialogHelp
            onClose: home()
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
            Component.onCompleted: {
                win.connect(Activity.nextLevel)
            }
        }
    }

}
