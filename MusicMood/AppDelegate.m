//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "AppDelegate.h"
#import "SimpleController.h"

@interface AppDelegate ()
@property (nonatomic, readonly) SimpleController* simpleController;
@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    _simpleController = [[SimpleController alloc]
                         initWithNibName:@"SimpleController"
                         bundle:nil];
    self.window.rootViewController = _simpleController;
}

/*
 * Simple example of getting data from the "*.muse" file
 */
- (void)playMuseFile {
    NSLog(@"start play muse");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =
        [documentsDirectory stringByAppendingPathComponent:@"testfile.muse"];
    IXNMuseFileReader *fileReader =
            [IXNMuseFileFactory museFileReaderWithPathString:filePath];
    while ([fileReader gotoNextMessage]) {
        IXNMessageType type = [fileReader getMessageType];
        int id_number = [fileReader getMessageId];
        int64_t timestamp = [fileReader getMessageTimestamp];
        NSLog(@"type: %d, id: %d, timestamp: %lld",
             (int)type, id_number, timestamp);
        switch(type) {
            case IXNMessageTypeEeg:
            case IXNMessageTypeQuantization:
            case IXNMessageTypeAccelerometer:
            case IXNMessageTypeBattery:
            {
                IXNMuseDataPacket* packet = [fileReader getDataPacket];
                NSLog(@"data packet = %d", (int)packet.packetType);
                break;
            }
            case IXNMessageTypeVersion:
            {
                IXNMuseVersion* version = [fileReader getVersion];
                NSLog(@"version = %@", version.getFirmwareVersion);
                break;
            }
            case IXNMessageTypeConfiguration:
            {
                IXNMuseConfiguration* config = [fileReader getConfiguration];
                NSLog(@"configuration = %@", config.getBluetoothMac);
                break;
            }
            case IXNMessageTypeAnnotation:
            {
                IXNAnnotationData* annotation = [fileReader getAnnotation];
                NSLog(@"annotation = %@", annotation.data);
                break;
            }
            default:
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.simpleController applicationWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
