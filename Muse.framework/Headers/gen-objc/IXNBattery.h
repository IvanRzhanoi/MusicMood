// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from packets.djinni

#import <Foundation/Foundation.h>

/**
 * \if IOS_ONLY
 * \file
 * \endif
 * Represents the data mapping in a Battery packet.
 * \if ANDROID_ONLY
 * \sa com.choosemuse.libmuse.MuseDataPacketType.BATTERY
 * \sa com.choosemuse.libmuse.MuseDataPacket.getBatteryValue()
 * \endif
 * \if IOS_ONLY
 //sa \link IXNMuseDataPacketType::IXNMuseDataPacketTypeBattery IXNMuseDataPacketTypeBattery\endlink
 * \sa IXNMuseDataPacket::getBatteryValue:
 * \endif
 */
typedef NS_ENUM(NSInteger, IXNBattery)
{
    /** Charge percentage remaining of battery. */
    IXNBatteryChargePercentageRemaining,
    /** Millivolts of battery from the view of the fuel gauge. */
    IXNBatteryMillivolts,
    /** Temperature in degrees Celsius. */
    IXNBatteryTemperatureCelsius,
};
