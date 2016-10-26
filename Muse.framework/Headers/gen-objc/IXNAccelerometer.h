// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from packets.djinni

#import <Foundation/Foundation.h>

/**
 * \if IOS_ONLY
 * \file
 * \endif
 * Represents the data mapping in an Accelerometer data packet.<br>
 *
 * The accelerometer data is measured on 3 axes as shown in the picture below:
 * \image html MuseAxesAcc.png
 *
 * The axes are oriented to a Right Hand Coordinate System.
 * Values indicate the total acceleration along each axis in g (9.81 m/s^2).<br>
 * Values along the X axis increase as the head accelerates forward.
 * Negative values indicate acceleration backwards.<br>
 * Values along the Y axis increase as the head accelerates to the right.
 * Negative values indicate acceleration to the left.<br>
 * Values along the Z axis increase as the head accelerates downward.
 * Negative values indicate acceleration upward.<br>
 * When worn still on the head, or held in the level position shown in the figure above,
 * the net acceleration of the device will only be caused from gravity. It will be in the
 * direction of the ground. This will give a_x =0, a_y = 0 and a_z = 1 g.<br>
 * \if ANDROID_ONLY
 * \sa com.choosemuse.libmuse.MuseDataPacketType.ACCELEROMETER
 * \sa com.choosemuse.libmuse.MuseDataPacket.getAccelerometerValue()
 * \endif
 * \if IOS_ONLY
 * \sa \link IXNMuseDataPacketType::IXNMuseDataPacketTypeAccelerometer IXNMuseDataPacketTypeAccelerometer\endlink
 * \sa IXNMuseDataPacket::getAccelerometerValue:
 * \endif
 */
typedef NS_ENUM(NSInteger, IXNAccelerometer)
{
    /**
     * Acceleration along the X axis value in g.
     * Values along the X axis increase as the head accelerates forward.
     * Negative values indicate acceleration backwards.<br>
     */
    IXNAccelerometerX,
    /**
     * Acceleration along the Y axis value in g.
     * Values along the Y axis increase as the head accelerates to the right.
     * Negative values indicate acceleration to the left.<br>
     */
    IXNAccelerometerY,
    /**
     * Acceleration along the Z axis value in g.
     * Values along the Z axis increase as the head accelerates downward.
     * Negative values indicate acceleration upward.<br>
     */
    IXNAccelerometerZ,
    /**
     * Acceleration along the Forward/Backward axis value in g.  Positive values indicate acceleration forward.
     * \deprecated Use
     * \if ANDROID_ONLY
     * Accelerometer.X
     * \elseif IOS_ONLY
     * \link ::IXNAccelerometer::IXNAccelerometerX IXNAccelerometerX \endlink
     * \endif
     * instead.
     */
    IXNAccelerometerForwardBackward,
    /**
     * Acceleration along the Up/Down axis value in g.  Positive values indicate acceleration up.
     * \deprecated Use
     * \if ANDROID_ONLY
     * Accelerometer.Z
     * \elseif IOS_ONLY
     * \link ::IXNAccelerometer::IXNAccelerometerZ IXNAccelerometerZ \endlink
     * \endif
     * instead.
     */
    IXNAccelerometerUpDown,
    /**
     * Acceleration along the Left/Right axis value in g.  Positive values indicate acceleration left.
     * \deprecated Use
     * \if ANDROID_ONLY
     * Accelerometer.Y
     * \elseif IOS_ONLY
     * \link ::IXNAccelerometer::IXNAccelerometerY IXNAccelerometerY \endlink
     * \endif
     * instead.
     */
    IXNAccelerometerLeftRight,
};
