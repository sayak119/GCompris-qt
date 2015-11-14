/* GCompris - tangram.js
 *
 * Copyright (C) 2015 YOUR NAME <xx@yy.org>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   "YOUR NAME" <YOUR EMAIL> (Qt Quick port)
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

var url = "qrc:/gcompris/src/activities/tangram/resource/"

var dataset = [
            [
                ['p3', 1, 1.555033, 3.667909, 225],
                ['p2', 0, 3.055033, 4.667909, 0],
                ['p4', 0, 2.221700, 4.501242, 270],
                ['p4', 0, 3.888367, 4.834575, 90],
                ['p0', 0, 3.083629, 2.753695, 45],
                ['p0', 0, 1.221700, 5.834575, 0],
                ['p1', 0, 5.221700, 5.167909, 45]
            ],
            [
                ['p2', 0, 3.450292, 1.017544, 45],
                ['p4', 0, 3.450292, 2.196055, 315],
                ['p1', 0, 3.450292, 3.098424, 315],
                ['p3', 0, 3.096739, 5.199524, 90],
                ['p4', 0, 4.157399, 5.081673, 135],
                ['p0', 0, 3.450292, 6.495887, 315],
                ['p0', 0, 3.450292, 4.374566, 315]
            ]
]

var currentLevel = 0
var numberOfLevel = dataset.length
var items

// We keep a globalZ across all items. It is increased on each
// item selection to put it on top
var globalZ = 0


function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    globalZ = 0
    items.bar.level = currentLevel + 1
    items.itemListModel = dataset[items.bar.level - 1]
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

// Determines the angle of a straight line drawn between point one and two.
// The number returned, which is a float in radian,
// tells us how much we have to rotate a horizontal line clockwise
// for it to match the line between the two points.
function getAngleOfLineBetweenTwoPoints(x1, y1, x2, y2) {
    var xDiff = x2 - x1;
    var yDiff = y2 - y1;
    return Math.atan2(yDiff, xDiff);
}
