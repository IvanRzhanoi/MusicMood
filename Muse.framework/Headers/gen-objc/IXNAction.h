// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from async.djinni

#import <Foundation/Foundation.h>

/**
 * A wrapper that represents a block or runnable action.
 * \if ANDROID_ONLY
 * \sa com.choosemuse.libmuse.EventLoop
 * \elseif IOS_ONLY
 * \sa IXNEventLoop
 * \endif
 */

@protocol IXNAction

/** Performs the action. */
- (void)run;

@end