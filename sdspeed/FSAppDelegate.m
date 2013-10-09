//
//  FSAppDelegate.m
//  sdspeed
//
//  Created by M on 16.03.13.
//  Copyright (c) 2013 Flagsoft. All rights reserved.
//

#import "FSAppDelegate.h"


#include "utils.h"
#include "f3write.h"





@implementation FSAppDelegate

@synthesize UI_start;
@synthesize UI_progress;
@synthesize UI_progressValue;

@synthesize UI_volumesName;
@synthesize UI_volumesCapacityGB;
@synthesize UI_volumesReadOnly;

@synthesize UI_writeSpeed;
@synthesize UI_writeUnit;

@synthesize UI_readSpeed;
@synthesize UI_readUnit;

@synthesize UI_errorMessage;


NSOperationQueue *opQueue=nil;

NSThread *otherThread = nil;
NSTimer *myTimer = nil;
NSTimer *myTimer_checkForVolume = nil;
NSTimer *myTimerStopThread = nil;
NSString *g_VOLUMES_DRIVE_NAME = nil;       // "/Volumes/Fotos" UNIX path notation
NSString *g_VOLUMES_NAME_UI = nil;          // "Fotos" just the volume name

NSNumber *g_VOLUMES_DRIVE_CAPACITY_BYTE = 0;        // volume capacity in bytes
NSString *g_VOLUMES_DRIVE_CAPACITY_BYTE_UI = nil;   // "--"

double g_VOLUMES_DRIVE_CAPACITY_GB = 0.0;            // 3.680294 Volume capacity in GB (giga byte)
NSString *g_VOLUMES_DRIVE_CAPACITY_GB_STRING = nil;  // "3.7"


NSString *g_VOLUMES_DRIVE_IS_READ_ONLY_UI = nil;


NSString *g_ERROR_MESSAGE = nil;            // "No volume inserted. Please insert a volume."

int g_FLAG_shouldTerminate = 0;
int g_FLAG_volumeThere = 0;         // 0:no volume inserted / 1:volmue inserted


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    
    g_ERROR_MESSAGE = @"";
    
    [UI_start setEnabled:NO];


    // -- start checking for a volume to be inserted (your SD card)
    myTimer_checkForVolume = [NSTimer scheduledTimerWithTimeInterval:2.0
                                               target:self
                                             selector:@selector(updateUI_checkForVolume:)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [myTimer_checkForVolume invalidate];
    [myTimer invalidate];
}

- (void)updateUI:(NSTimer*)timer
{

    [UI_writeSpeed setStringValue:[NSString stringWithFormat:@"%.2f", f3write_getCurrentSpeed()]];
    [UI_writeUnit setStringValue:[NSString stringWithFormat:@"%s", f3write_getCurrentUnit()]];
    
    
    [UI_progress setDoubleValue:f3write_getCurrentPercent()];
    [UI_progressValue setStringValue:[NSString stringWithFormat:@"%.1f %%", f3write_getCurrentPercent()]];
    
    
}


- (void)updateUI_checkForVolume:(NSTimer*)timer
{
    
    NSArray *keys = [NSArray arrayWithObjects:NSURLVolumeNameKey, NSURLVolumeIsRemovableKey, nil];
    NSArray *urls = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:keys options:0];
    NSString *volumeName = nil;
    NSString *volumeLocalizedName = nil;
    NSNumber *volumeIsReadOnly = false;
    NSNumber *volumeCapacity = 0;
    
    for (NSURL *url in urls) {
        NSError *error;
        NSNumber *isRemovable;
        
        [url getResourceValue:&isRemovable forKey:NSURLVolumeIsRemovableKey error:&error];
        
        if ([isRemovable boolValue]) {
            
            [url getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:&error];
            [url getResourceValue:&volumeCapacity forKey:NSURLVolumeTotalCapacityKey error:&error];
            [url getResourceValue:&volumeLocalizedName forKey:NSURLVolumeLocalizedNameKey error:&error];

            [url getResourceValue:&volumeIsReadOnly forKey:NSURLVolumeIsReadOnlyKey error:&error];

            
            [url getResourceValue:&volumeIsReadOnly forKey:NSURLVolumeIdentifierKey error:&error];



            g_VOLUMES_DRIVE_CAPACITY_BYTE = volumeCapacity;
            g_VOLUMES_DRIVE_CAPACITY_BYTE_UI = [NSString stringWithFormat:@"%@", volumeCapacity];
            g_VOLUMES_DRIVE_CAPACITY_GB = [volumeCapacity doubleValue] / (1024*1024*1024);
            g_VOLUMES_DRIVE_CAPACITY_GB_STRING = [NSString stringWithFormat:@"%.1f", g_VOLUMES_DRIVE_CAPACITY_GB];
            
            g_VOLUMES_DRIVE_IS_READ_ONLY_UI = [NSString stringWithFormat:@"%d", [volumeIsReadOnly intValue] ];


            NSLog(@"DEBUG:");
            NSLog(@" - Name         = %@\n", volumeName);
            NSLog(@" - Name (local) = %@\n", volumeLocalizedName);
            NSLog(@" - Capacity = %@ (GB)\n", g_VOLUMES_DRIVE_CAPACITY_GB_STRING);
            NSLog(@" - Capacity = %@ (Bytes)\n", g_VOLUMES_DRIVE_CAPACITY_BYTE);
            NSLog(@" - Capacity = %@ (Bytes UI)\n", g_VOLUMES_DRIVE_CAPACITY_BYTE_UI);
            NSLog(@" - Read only = %@", g_VOLUMES_DRIVE_IS_READ_ONLY_UI);

        }
    }
    

    g_VOLUMES_NAME_UI = [NSString stringWithFormat:@"%@", volumeLocalizedName];

    g_VOLUMES_DRIVE_NAME = [NSString stringWithFormat:@"/Volumes/%@", volumeName];

    
    // TODO: Add a better solution! (Check if a volume is inserted or not.)
    //
    // possible names (NSString) ar:
    //   "/Volume/Fotos"   --> The volume name is Fotos
    //   "/Volume/NO NAME" --> The volume name is NO NAME
    //   "/Volume/(null)"  --> We assume here that there is no volume inserted.
    //
    // Note: For the following, we assume here that a drive name "(null)" as string means no volume inserted, don't know what happen here if the volume name is acutally "(null)".

    if ( [g_VOLUMES_NAME_UI isEqualToString:@"(null)"] ) {

        //
        // -- no SD card volume there
        //

        g_FLAG_volumeThere = 0;
        g_ERROR_MESSAGE = @"Please insert a SD card.";
        
        g_VOLUMES_DRIVE_NAME = @"-";
        g_VOLUMES_NAME_UI = @"-";
        g_VOLUMES_DRIVE_CAPACITY_GB_STRING = @"-";
        g_VOLUMES_DRIVE_CAPACITY_BYTE = 0;
        g_VOLUMES_DRIVE_CAPACITY_BYTE_UI = @"-";
        
        g_VOLUMES_DRIVE_IS_READ_ONLY_UI = @"-";

        
        [UI_volumesCapacityGB setStringValue:@"-"];
        

        [UI_volumesReadOnly setStringValue:@"-"];

        [UI_start setEnabled:NO];

        
    } else {
        
        //
        // -- SD card volume there
        //
        
        g_FLAG_volumeThere = 1;

        
        [UI_volumesCapacityGB setStringValue:[NSString stringWithFormat:@"%@ GB (%@ Bytes)", g_VOLUMES_DRIVE_CAPACITY_GB_STRING, g_VOLUMES_DRIVE_CAPACITY_BYTE_UI]];
        
        if ( [g_VOLUMES_DRIVE_IS_READ_ONLY_UI isEqualToString:@"1"] ) {
            // read only media
            [UI_volumesReadOnly setStringValue:@"read only"];
            g_ERROR_MESSAGE = @"Please make card writeable.";
            [UI_start setEnabled:NO];
        } else {
            [UI_volumesReadOnly setStringValue:@"read write"];
            [UI_start setEnabled:YES];
        }
        
   
        
    }

    // -- UI update
    [UI_volumesName setStringValue:g_VOLUMES_NAME_UI];
    [UI_errorMessage setStringValue:g_ERROR_MESSAGE];
}

- (IBAction)UI_start_pressed:(id)sender {

    //[UI_start state] == NSOnState

    if (!g_FLAG_volumeThere) {
        // -- no volume there so display a message and exit
        [UI_errorMessage setStringValue:@"Please insert a SD card first and make sure it is not locked."];
        return;
    }
    
    
    
    // -- stop checking for volumes
    [myTimer_checkForVolume invalidate];

    
    [UI_start setTitle:@"Please wait..."];
    
    
    if ( [otherThread isExecuting] ) {

        NSLog(@"Thread is working...");

    } else {

        [UI_start setEnabled:NO];
        
        otherThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTheBackgroundJob:) object:nil];
        [otherThread start];
        

        // -- start UI update timer
        
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(updateUI:)
                                                 userInfo:nil
                                                  repeats:YES];
        
    }

    
    
    /*
    myTimerStopThread = [NSTimer scheduledTimerWithTimeInterval:12.0
                                               target:self
                                             selector:@selector(threadStop:)
                                             userInfo:nil
                                              repeats:NO];
     */

    
}


/*- (void)threadStop:(id)arg
{
    NSLog(@"STOP");
    g_FLAG_shouldTerminate = 1;
    //[otherThread cancel];
}*/



- (void)startTheBackgroundJob:(id)arg
{
    int start_at;
    int progress;
    
    start_at = 0;
    double speed_write = 0.0;

    
    //[NSThread sleepForTimeInterval:3];
    

    
    
    // -- reset UI values
    [UI_readSpeed setStringValue:[NSString stringWithFormat:@"%.2f", 0.0]];
    [UI_readUnit setStringValue:[NSString stringWithFormat:@"%s", "NA"]];

    

    
    
    //
    // -- write test
    //
    
    
    f3write_unlink_old_files([g_VOLUMES_DRIVE_NAME UTF8String], start_at);
    
    
    /* If stdout isn't a terminal, supress progress. */
	//progress = isatty(STDOUT_FILENO);
    progress=1;
    speed_write = f3write_fill_fs([g_VOLUMES_DRIVE_NAME UTF8String] , start_at, progress);
    NSLog(@"AV SPEED: %f", speed_write);

    //
    // -- write test done
    //
    
    
    [UI_writeSpeed setStringValue:[NSString stringWithFormat:@"%.2f", speed_write]];
    

    [UI_progress setDoubleValue:100.0];
    [UI_progressValue setStringValue:[NSString stringWithFormat:@"%.1f %%", 100.0]];

    
    
    
    
    
    
    //
    // -- read test
    //

    
    [UI_start setTitle:@"Do read test please wait..."];
    
    int read_start_at;
	const char *read_path;
	const int *read_files;
	int read_progress;
    
    
    read_start_at = 0;
    read_path = [g_VOLUMES_DRIVE_NAME UTF8String];
    
    read_files = ls_my_files(read_path, read_start_at);
	//If stdout isn't a terminal, supress progress.
	//read_progress = isatty(STDOUT_FILENO);
    read_progress = 1;
	f3read_iterate_files(read_path, read_files, read_start_at, read_progress);
	free((void *)read_files);



    //
    // -- all done (write and read test)
    //
    
    [myTimer invalidate];

    [UI_start setEnabled:YES];
    [UI_start setTitle:@"Start"];

    
    [UI_readSpeed setStringValue:[NSString stringWithFormat:@"%.2f", f3read_getReadSpeedAverage()]];
    [UI_readUnit setStringValue:[NSString stringWithFormat:@"%s", f3read_getCurrentUnit()]];

    
    // -- clean up files
    f3write_unlink_old_files([g_VOLUMES_DRIVE_NAME UTF8String], 0);

    
    
    // -- start checking for volume again
    myTimer_checkForVolume = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                              target:self
                                                            selector:@selector(updateUI_checkForVolume:)
                                                            userInfo:nil
                                                             repeats:YES];

    
    
}


- (IBAction)UI_refresh:(id)sender {
    
    [self updateUI_checkForVolume:myTimer_checkForVolume];
    
}
@end
