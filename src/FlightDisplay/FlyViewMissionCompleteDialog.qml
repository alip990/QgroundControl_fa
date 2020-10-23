/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.12

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0

/// Dialog which shows up when a flight completes. Prompts the user for things like whether they should remove the plan from the vehicle.
Item {
    visible: false

    property var missionController
    property var geoFenceController
    property var rallyPointController
    property var guidedController

    // The following code is used to track vehicle states for showing the mission complete dialog
    property var  _activeVehicle:                   QGroundControl.multiVehicleManager.activeVehicle
    property bool _vehicleArmed:                    _activeVehicle ? _activeVehicle.armed : true // true here prevents pop up from showing during shutdown
    property bool _vehicleWasArmed:                 false
    property bool _vehicleInMissionFlightMode:      _activeVehicle ? (_activeVehicle.flightMode === _activeVehicle.missionFlightMode) : false
    property bool _vehicleWasInMissionFlightMode:   false
    property bool _showMissionCompleteDialog:       _vehicleWasArmed && _vehicleWasInMissionFlightMode &&
                                                        (missionController.containsItems || geoFenceController.containsItems || rallyPointController.containsItems ||
                                                        (_activeVehicle ? _activeVehicle.cameraTriggerPoints.count !== 0 : false))

    on_VehicleArmedChanged: {
        if (_vehicleArmed) {
            _vehicleWasArmed = true
            _vehicleWasInMissionFlightMode = _vehicleInMissionFlightMode
        } else {
            if (_showMissionCompleteDialog) {
                mainWindow.showComponentDialog(missionCompleteDialogComponent, qsTr("ماموریت تمام شد"), mainWindow.showDialogDefaultWidth, StandardButton.Close)
            }
            _vehicleWasArmed = false
            _vehicleWasInMissionFlightMode = false
        }
    }

    on_VehicleInMissionFlightModeChanged: {
        if (_vehicleInMissionFlightMode && _vehicleArmed) {
            _vehicleWasInMissionFlightMode = true
        }
    }

    Component {
        id: missionCompleteDialogComponent

        QGCViewDialog {
            property var activeVehicleCopy: _activeVehicle
            onActiveVehicleCopyChanged:
                if (!activeVehicleCopy) {
                    hideDialog()
                }

            QGCFlickable {
                anchors.fill:   parent
                contentHeight:  column.height

                ColumnLayout {
                    id:                 column
                    anchors.margins:    _margins
                    anchors.left:       parent.left
                    anchors.right:      parent.right
                    spacing:            ScreenTools.defaultFontPixelHeight

                    QGCLabel {
                        Layout.fillWidth:       true
                        text:                   qsTr("%1 Images Taken").arg(_activeVehicle.cameraTriggerPoints.count)
                        horizontalAlignment:    Text.AlignHCenter
                        visible:                _activeVehicle.cameraTriggerPoints.count !== 0
                    }

                    QGCButton {
                        Layout.fillWidth:   true
                        text:               qsTr("ماموریت را از حافظه پاک کنید")
                        visible:            !_activeVehicle.connectionLost// && !_activeVehicle.apmFirmware  // ArduPilot has a bug somewhere with mission clear
                        onClicked: {
                            _planController.removeAllFromVehicle()
                            hideDialog()
                        }
                    }

                    QGCButton {
                        Layout.fillWidth:   true
                        Layout.alignment:   Qt.AlignHCenter
                        text:               qsTr("ماموریت را روی حافظه باقی بگذارید")
                        onClicked:          hideDialog()
                    }

                    Rectangle {
                        Layout.fillWidth:   true
                        color:              qgcPal.text
                        height:             1
                    }

                    ColumnLayout {
                        Layout.fillWidth:   true
                        spacing:            ScreenTools.defaultFontPixelHeight
                        visible:            !_activeVehicle.connectionLost && guidedController.showResumeMission

                        QGCButton {
                            Layout.fillWidth:   true
                            Layout.alignment:   Qt.AlignHCenter
                            text:               qsTr("ادامه بده %1 ماموریت را از نقطه مسیر").arg(guidedController._resumeMissionIndex)

                            onClicked: {
                                guidedController.executeAction(guidedController.actionResumeMission, null, null)
                                hideDialog()
                            }
                        }

                        QGCLabel {
                            Layout.fillWidth:   true
                            wrapMode:           Text.WordWrap
                            text:               qsTr("ادامه ماموریت ،ماموریت فعلی را برای پرواز بعدی در پرنده ذخیره میکند")
                        }
                    }

                    QGCLabel {
                        Layout.fillWidth:   true
                        wrapMode:           Text.WordWrap
                        color:              qgcPal.warningText
                        text:               qsTr("اگر در حال تغییر باتری برای دامه ماموریت هستید ، ارتباط خود را با پرنده قطع نکنید.")
                        visible:            guidedController.showResumeMission
                    }
                }
            }
        }
    }
}
