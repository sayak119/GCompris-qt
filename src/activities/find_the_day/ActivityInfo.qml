/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2018 Amit Sagtani <asagtani06@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import GCompris 1.0

ActivityInfo {
  name: "find_the_day/FindTheDay.qml"
  difficulty: 6
  icon: "find_the_day/find_the_day.svg"
  author: "Amit Sagtani &lt;asagtani06@gmail.com&gt;"
  demo: true
  //: Activity title
  title: qsTr("Find the day")
  //: Help title
  description: qsTr("Read the task and find the correct date by doing mathematical calculations.")
  //intro: "Select the asked date on the calendar"
  //: Help goal
  goal: qsTr("Learn to find date on the calendar by duration calculations.")
  //: Help prerequisite
  prerequisite: qsTr("Basics of calendar")
  //: Help manual
  manual: qsTr("Review the instructions and select the correct date on calendar.")
  credit: ""
  section: "discovery"
  createdInVersion: 9000
}
