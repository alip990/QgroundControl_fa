/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQml.Models 2.12

import QGroundControl           1.0
import QGroundControl.Controls  1.0

ToolStripActionList {
    signal displayPreFlightChecklist

    model: [
        PreFlightCheckListShowAction {
            onTriggered: displayPreFlightChecklist()
        },
        GuidedActionTakeoff {
            guidedController: guidedActionsController
        },
        GuidedActionLand {
            guidedController: guidedActionsController
        },
        GuidedActionRTL {
            guidedController: guidedActionsController
        },
        GuidedActionPause {
            guidedController: guidedActionsController
        },
        GuidedActionActionList {
            guidedController: guidedActionsController
        }
//        ToolStripAction {
//            text:               qsTr("عملیات")
//            iconSource:         "/qmlimages/MapSync.svg"
//            enabled:            true
//            visible:            true
//            dropPanelComponent: centerMapDropPanel
//            onTriggered:{
//                console.log("trige mission ??????????????????????????")
//            }
//        }

    ]
}
