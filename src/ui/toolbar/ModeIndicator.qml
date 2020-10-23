/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                              2.11
import QtQuick.Controls                     2.4

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Mode Indicator
QGCComboBox {
    anchors.verticalCenter: parent.verticalCenter
    alternateText:          _activeVehicle ? modedict[_activeVehicle.flightMode] : ""
    model:                  flightModes_persain
    font.pointSize:         ScreenTools.mediumFontPointSize
    currentIndex:           -1
    sizeToContents:         true
    property bool showIndicator: true

    property var _activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle
    property var _flightModes:      _activeVehicle ? _activeVehicle.flightModes : [ ]
    property var flightModes_persain : get_flightmode_persian(modedict,_flightModes)
    property var modedict: {
            "Manual" : "رادیو",
            "Acro":"Acro ",
            "Rattitude" :" Rattitude ",
            "Altitude":"Altitude ",
            "Offboard":"Offboard ",
            "Ready":"Ready ",
            "Takeoff":"برخاستن",
            "Hold":"حفظ موقعیت",
            "Mission":"ماموریت",
            "Return":"بازگشت",
            "Land":"فرود",
            "Precision Land":"Precision Land ",
            "Return to Groundstation":"Return to Groundstation ",
            "Follow Me":"Follow Me ",
            "Simple":"Simple "
            };
    function get_flightmode_persian(_modedict,flightModes){
        var _fligthModesTr=[];
        function getKeyByValue(object, value) {
              return Object.keys(object).find(key => object[key] === value);
        }

        var i;
        for (i = 0; i < _flightModes.length; i++) {
              _fligthModesTr.push(_modedict [flightModes[i]]);
        }
        return _fligthModesTr
    }


    onActivated: {
        _activeVehicle.flightMode =         Object.keys(modedict).find(key => modedict[key] === flightModes_persain[index]);

        currentIndex = -1
    }

}
