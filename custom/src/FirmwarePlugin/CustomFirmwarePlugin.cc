/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @brief Custom Firmware Plugin (PX4)
 *   @author Gus Grubba <gus@auterion.com>
 *
 */

#include "CustomFirmwarePlugin.h"
#include "CustomAutoPilotPlugin.h"

//-----------------------------------------------------------------------------
CustomFirmwarePlugin::CustomFirmwarePlugin()
{
    for (int i = 0; i < _flightModeInfoList.count(); i++) {
        FlightModeInfo_t& info = _flightModeInfoList[i];
        //-- Narrow the flight mode options to only these
        if (info.name != _holdFlightMode && info.name != _rtlFlightMode && info.name != _missionFlightMode &&info.name != _manualFlightMode) {
            // No other flight modes can be set
            info.canBeSet = false;
        }
    }
}

//-----------------------------------------------------------------------------
AutoPilotPlugin* CustomFirmwarePlugin::autopilotPlugin(Vehicle* vehicle)
{
    return new CustomAutoPilotPlugin(vehicle, vehicle);
}

const QVariantList& CustomFirmwarePlugin::toolIndicators(const Vehicle* vehicle)
{
    if (_toolIndicatorList.size() == 0) {
        // First call the base class to get the standard QGC list. This way we are guaranteed to always get
        // any new toolbar indicators which are added upstream in our custom build.
        _toolIndicatorList = FirmwarePlugin::toolIndicators(vehicle);
        // Then specifically remove the RC RSSI indicator.
        _toolIndicatorList.removeOne(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/RCRSSIIndicator.qml")));
        _toolIndicatorList.removeOne(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/GPSIndicator.qml")));
    }
    return _toolIndicatorList;
}

const QVariantList &CustomFirmwarePlugin::modeIndicators(const Vehicle *vehicle)
{
    if(_modeIndicatorList.size()==0){
        _modeIndicatorList = FirmwarePlugin::modeIndicators(vehicle);
        _modeIndicatorList.removeOne(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/ROIIndicator.qml")));
    }
    return _modeIndicatorList;
}

// Tells QGC that your vehicle has a gimbal on it. This will in turn cause thing like gimbal commands to point
// the camera straight down for surveys to be automatically added to Plans.
bool CustomFirmwarePlugin::hasGimbal(Vehicle* /*vehicle*/, bool& rollSupported, bool& pitchSupported, bool& yawSupported)
{
    rollSupported = false;
    pitchSupported = false;
    yawSupported = false;

    return true;
}
