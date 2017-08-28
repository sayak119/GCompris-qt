/* GCompris - piano_composition.js
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
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris

var currentLevel = 0
var numberOfLevel = 7
var items
var userFile = "file://" + GCompris.ApplicationInfo.getSharedWritablePath() + "/" + "piano_composition"
var instructions = ["This is the treble cleff staff for high pitched notes", "This is the bass cleff staff for low pitched notes", "Click on the note symbols to write different length notes such as quarter notes, half notes and whole notes", "The black keys are sharp and flat keys, have a # sign.", "Each black key has two names: flat and sharp. Flat notes have b sign","Now you can load music", "Now you can compose your own music"]

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function saveMelody() {
    print(items.staff2.getAllNotes())
    if (!items.file.exists(userFile)) {
        if (!items.file.mkpath(userFile))
            console.error("Could not create directory " + userFile);
        else
            console.debug("Created directory " + userFile);
    }
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
}

function nextLevel() {
    items.staff2.eraseAllNotes()
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    items.staff2.eraseAllNotes()
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}
