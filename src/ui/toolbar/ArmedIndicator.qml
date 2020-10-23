/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Layouts  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QtQuick.Controls 2.3
//-------------------------------------------------------------------------
//-- Armed Indicator
RoundButton {
    anchors.verticalCenter: parent.verticalCenter
    text:          _armed ? qsTr("آماده به کار") : qsTr("غیر فعال")
    highlighted: ture
    flat : true
    radius: 2
    background: Rectangle {
                border.color: "#14191D"
                color: _armed ?"#238a6b":"#800000"
                // I want to change text color next
            }
    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool   _armed:         _activeVehicle ? _activeVehicle.armed : false
    onClicked:{
         if (!_armed) {
            mainWindow.armVehicleRequest()
        } else {
            mainWindow.disarmVehicleRequest()
        }
    }

}
