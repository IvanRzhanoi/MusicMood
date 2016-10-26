// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from packets.djinni

#import "Muse/gen-objc/IXNAccelerometer.h"
#import "Muse/gen-objc/IXNBattery.h"
#import "Muse/gen-objc/IXNDrlRef.h"
#import "Muse/gen-objc/IXNEeg.h"
#import "Muse/gen-objc/IXNGyro.h"
#import "Muse/gen-objc/IXNMuseDataPacketType.h"
#import <Foundation/Foundation.h>
@class IXNMuseDataPacket;

/**
 * Contains information received from the headband.
 * Each packet can represent different data: eeg,
 * accelerometer, quantization, etc.
 * \if ANDROID_ONLY
 * Take a look at MuseDataPacketType enum for all possible types.
 * \endif
 * \if IOS_ONLY
 * Take a look at IXNMuseDataPacketType enum for all possible types.
 * \endif
 */

@interface IXNMuseDataPacket : NSObject

/**
 * Create a new packet with reserved capacity but unspecified contents.
 * \param capacity the number of data entries to reserve.
 */
+ (nullable IXNMuseDataPacket *)makeUninitializedPacket:(int64_t)capacity;

/**
 * Create a new packet with the given contents.
 * \param type the type of packet to create
 * \param timestamp the timestamp of the packet
 * \param values the data the packet contains.
 */
+ (nullable IXNMuseDataPacket *)makePacket:(IXNMuseDataPacketType)type
                                 timestamp:(int64_t)timestamp
                                    values:(nonnull NSArray *)values;

/**
 * Specifies what kind of values are stored in the packet.
 * \return the type of packet.
 */
- (IXNMuseDataPacketType)packetType;

/**
 * Microseconds since epoch (usually Jan 1, 1970).
 * \return the timestamp of the packet expressed in microseconds since epoch.
 */
- (int64_t)timestamp;

/**
 * Raw packet data as an array. The size of this array and the meaning of
 * its elements depend on the packet type. See the documentation for
 * \if ANDROID_ONLY
 * MuseDataPacketType
 * \endif
 * \if IOS_ONLY
 * IXNMuseDataPacketType
 * \endif
 * for details.
 *
 * Note that this method causes new memory to be allocated for an array of
 * boxed double values. If this impacts your application's performance, you
 * should use get_xxx_value() methods instead.
 *
 * \if ANDROID_ONLY
 * \deprecated Use
 * \link MuseDataPacket.getAccelerometerValue() MuseDataPacket.getAccelerometerValue()\endlink,
 * \link MuseDataPacket.getBatteryValue() MuseDataPacket.getBatteryValue()\endlink,
 * \link MuseDataPacket.getDrlRefValue() MuseDataPacket.getDrlRefValue()\endlink,
 * \link MuseDataPacket.getEegChannelValue() MuseDataPacket.getEegChannelValue()\endlink and
 * \link MuseDataPacket.getGyroValue() MuseDataPacket.getGyroValue()\endlink
 * instead.
 * \elseif IOS_ONLY
 * \deprecated Use
 * \link ::IXNMuseDataPacket::getAccelerometerValue:\endlink,
 * \link ::IXNMuseDataPacket::getBatteryValue:\endlink,
 * \link ::IXNMuseDataPacket::getDrlRefValue:\endlink,
 * \link ::IXNMuseDataPacket::getEegChannelValue:\endlink and
 * \link ::IXNMuseDataPacket::getGyroValue:\endlink
 * instead.
 * \endif
 */
- (nonnull NSArray *)values;

/**
 * Get the number of values in this packet.
 * \return the number of data values in this packet.
 */
- (int64_t)valuesSize;

/**
 * Get the raw EEG or EEG derived value from the packet.
 * EEG derived value are data that is calculated based on the raw EEG values.
 * \if IOS_ONLY
 * Take a look at enum in IXNMuseDataPacketType for values derived from Eeg channel.
 * \endif
 * \if ANDROID_ONLY
 * Take a look at enum in MuseDataPacketType for values derived from EEG channel.
 * \endif
 * Please refer to documentation to see what EEGx represents for head location.
 * Calling this function does not perform additional allocations and is preferable to using
 * values().
 * \if ANDROID_ONLY
 * \param channelNum the EEG channel to retrieve. (ie. Eeg.EEG1)
 * \elseif IOS_ONLY
 * \param channelNum the ::IXNEeg channel to retrieve (ie. \link IXNEeg IxnEegEEG1 \endlink)
 * \endif
 * \return the value requested.
 * \exception SIGABRT
 * If this function is called on a packet type that is not type
 * \if ANDROID_ONLY
 * MuseDataPacketType.EEG
 * \elseif IOS_ONLY
 * \link ::IXNMuseDataPacketType::IXNMuseDataPacketTypeEeg IXNMuseDataPacketTypeEeg \endlink
 * \endif
 * , LibMuse will throw an exception. Use packetType() to check the type before calling this
 * function.
 */
- (double)getEegChannelValue:(IXNEeg)channelNum;

/**
 * \if ANDROID_ONLY
 * Get the Battery value from the packet.
 * \elseif IOS_ONLY
 * Get the ::IXNBattery value from the packet.
 * \endif
 * Calling this function does not perform additional allocations and is preferable to using
 * values().
 * \if ANDROID_ONLY
 * \param b the Battery value to retrieve (ie. Battery.MILLIVOLTS)
 * \elseif IOS_ONLY
 * \param b the ::IXNBattery value to retrieve (ie. \link IXNBattery IXNBatteryMillivolts \endlink)
 * \endif
 * \return the value requested.
 * \exception SIGABRT
 * If this function is called on a packet type that is not type
 * \if ANDROID_ONLY
 * MuseDataPacketType.BATTERY
 * \elseif IOS_ONLY
 * \link ::IXNMuseDataPacketType::IXNMuseDataPacketTypeBattery IXNMuseDataPacketTypeBattery \endlink
 * \endif
 * , LibMuse will throw an exception. Use packetType() to check the type before calling this
 * function.
 */
- (double)getBatteryValue:(IXNBattery)b;

/**
 * \if ANDROID_ONLY
 * Get the Accelerometer value from the packet.
 * \elseif IOS_ONLY
 * Get the ::IXNAccelerometer value from the packet.
 * \endif
 *
 * Calling this function does not perform additional allocations and is preferable to using
 * values().
 * \if ANDROID_ONLY
 * \param a the Accelerometer value to retrieve (ie. Accelerometer.UP_DOWN)
 * \elseif IOS_ONLY
 * \param a the ::IXNAccelerometer value to retrieve (ie. \link IXNAccelerometer IxnAccelerometerUpDown \endlink)
 * \endif
 * \return the value requested.
 * \exception SIGABRT
 * If this function is called on a packet type that is not type
 * \if ANDROID_ONLY
 * MuseDataPacketType.ACCELEROMETER
 * \elseif IOS_ONLY
 * \link ::IXNMuseDataPacketType::IXNMuseDataPacketTypeAccelerometer IXNMuseDataPacketTypeAccelerometer \endlink
 * \endif
 * , LibMuse will throw an exception. Use packetType() to check the type before calling this
 * function.
 */
- (double)getAccelerometerValue:(IXNAccelerometer)a;

/**
 * \if ANDROID_ONLY
 * Get the Gyro value from the packet.
 * \elseif IOS_ONLY
 * Get the ::IXNGyro value from the packet.
 * \endif
 *
 * Calling this function does not perform additional allocations and is preferable to using
 * values().
 * \if ANDROID_ONLY
 * \param g the Gyro value to retrieve (ie. Gyro.UP_DOWN)
 * \elseif IOS_ONLY
 * \param g the ::IXNGyro value to retrieve (ie. \link IXNGyro IXNGyroUpDown \endlink)
 * \endif
 * \return the value requested.
 * \exception SIGABRT
 * If this function is called on a packet type that is not type
 * \if ANDROID_ONLY
 * MuseDataPacketType.GYRO
 * \elseif IOS_ONLY
 * \link ::IXNMuseDataPacketType::IXNMuseDataPacketTypeGyro IXNMuseDataPacketTypeGyro \endlink
 * \endif
 * , LibMuse will throw an exception. Use packetType() to check the type before calling this
 * function.
 */
- (double)getGyroValue:(IXNGyro)g;

/**
 * \if ANDROID_ONLY
 * Get the DrlRef value from the packet.
 * \elseif IOS_ONLY
 * Get the ::IXNDrlRef value from the packet.
 * \endif
 *
 * Calling this function does not perform additional allocations and is preferable to using
 * values().
 * \if ANDROID_ONLY
 * \param drl the DrlRef value to retrieve (ie. DrlRef.DRL)
 * \elseif IOS_ONLY
 * \param drl the ::IXNDrlRef value to retrieve (ie. \link IXNDrlRef IXNDrlRefDrl \endlink)
 * \endif
 * \return the value requested.
 * \exception SIGABRT
 * If this function is called on a packet type that is not type
 * \if ANDROID_ONLY
 * MuseDataPacketType.DRL_REF
 * \elseif IOS_ONLY
 * \link ::IXNMuseDataPacketType::IXNMuseDataPacketTypeDrlRef IXNMuseDataPacketTypeDrlRef \endlink
 * \endif
 * , LibMuse will throw an exception. Use packetType() to check the type before calling this
 * function.
 */
- (double)getDrlRefValue:(IXNDrlRef)drl;

@end
