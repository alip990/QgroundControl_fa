import QtQuick          2.3
import QtQuick.Controls 1.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0

// Statistics section for TransectStyleComplexItems
Grid {
    // The following properties must be available up the hierarchy chain
    //property var    missionItem       ///< Mission Item for editor

    columns:        2
    columnSpacing:  ScreenTools.defaultFontPixelWidth

    QGCLabel { text: qsTr("مساحت") }
    QGCLabel { text: QGroundControl.unitsConversion.squareMetersToAppSettingsAreaUnits(missionItem.coveredArea).toFixed(2) + " " + QGroundControl.unitsConversion.appSettingsAreaUnitsString }

    QGCLabel { text: qsTr("تعداد عکس") }
    QGCLabel { text: missionItem.cameraShots }

    QGCLabel { text: qsTr("فاصله عکس") }
    QGCLabel { text: missionItem.timeBetweenShots.toFixed(1) + " " + qsTr("ثانیه") }

//    QGCLabel { text: qsTr("فاصله") }
//    QGCLabel { text: missionItem.cameraCalc.adjustedFootprintFrontal.valueString + " " + missionItem.cameraCalc.adjustedFootprintFrontal.units }
}
