// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from sdk_bridge.djinni

#import <Foundation/Foundation.h>

/**
 * Statistics about the advertising packets that LibMuse sees from %Muse 2016 (
 * \if ANDROID_ONLY
 * \link com.choosemuse.libmuse.MuseModel.MU_02 MU_02\endlink
 * \elseif IOS_ONLY
 * \link ::IXNMuseModel::IXNMuseModelMu02 MU_02\endlink
 * \endif
 * ) headbands.
 * \if IOS_ONLY
 * \warning This is only available on Android devices.
 * \endif
 */
@interface IXNAdvertisingStats : NSObject
- (nonnull id)initWithNumAdvertisingPackets:(int32_t)numAdvertisingPackets
                     avgAdvertisingInterval:(double)avgAdvertisingInterval
                   sigmaAdvertisingInterval:(double)sigmaAdvertisingInterval
                     maxAdvertisingInterval:(double)maxAdvertisingInterval
                                     isLost:(BOOL)isLost
                                  hasBadMac:(BOOL)hasBadMac;

/**
 * Returns the number of advertising packets seen.
 * \return the number of advertising packets seen.
 */
@property (nonatomic, readonly) int32_t numAdvertisingPackets;

/**
 * Returns the average interval in seconds between advertising packets.
 * This is a running average since the time the statistics were created
 * or reset.
 * \return the average interval between advertising packets.
 */
@property (nonatomic, readonly) double avgAdvertisingInterval;

/**
 * Returns the standard deviation of the average advertising interval.
 * \return the standard deviation of the average advertising interval.
 */
@property (nonatomic, readonly) double sigmaAdvertisingInterval;

/**
 * Returns the maximum interval in seconds between receiving 2 advertising packets.
 * \return the maximum interval between advertising packets.
 */
@property (nonatomic, readonly) double maxAdvertisingInterval;

/**
 * Indicates if the phone has lost contact with the Muse headband.
 * This is a subjective measurement.  Even if this is true, the phone
 * may still be able to connect with the headband if a connection is
 * requested.
 * \return \c true if the phone has lost contact with the headband.
 * \c false otherwise.
 */
@property (nonatomic, readonly) BOOL isLost;

/**
 * Indicates an issue with the MAC address of the headband.
 *\return \c true if for some reason the MAC address of a headband has changed
 * since initial detection.  \c false under normal circumstances.
 */
@property (nonatomic, readonly) BOOL hasBadMac;

@end
