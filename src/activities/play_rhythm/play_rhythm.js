/* GCompris - play_rhythm.js
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
.pragma library
.import QtQuick 2.0 as Quick

var currentLevel = 1
var numberOfLevel = 12
var items
var backgroundNumber = 1
var isRestarted = false
var noteCount = 3
var highlighter = ["note-highlight", "passed", "failed"]
var listenMsg = qsTr("Listen to the rhythm and follow the moving line.")
var instructionMsg = qsTr("Click the drum to the tempo.\n Watch the vertical lien when you start");
var rhythmURL= "qrc:/gcompris/src/activities/play_rhythm/resource/";
var pianoURL= "qrc:/gcompris/src/activities/playpiano/resource/";

function start(items_) {
    items = items_
    currentLevel = 1
    initLevel()
}

function stop() {
}

function initLevel() {
    items.animateBar.stop();
    items.bar.level = currentLevel
    items.drumCount = 0;
    items.isCorrect = true;
    items.wasPlayPressed = false;
    if (!isRestarted) {
        backgroundNumber = (Math.floor(Math.random() * 6) + 1)
        items.background.source = rhythmURL + 'background/' + backgroundNumber + ".jpg"
    } else {
        isRestarted = false;
    }
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 1
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 1) {
        currentLevel = numberOfLevel
    }
    initLevel();
}

function resetLevel() {
    isRestarted = true
    initLevel();
}
