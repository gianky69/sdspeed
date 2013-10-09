//
//  FSAppDelegate.h
//  sdspeed
//
//  Created by Michael Mustun on 16.03.13.
//  Copyright (c) 2013 Flagsoft. All rights reserved.
//

/*
 * sdspeed - sdspeed - SD Memeory Card - Fight Flash Fraud
 *
 * Copyright (C) 2013 Michael Mustun
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#import <Cocoa/Cocoa.h>


@interface FSAppDelegate : NSObject <NSApplicationDelegate> {
    __weak NSButton *UI_start;
    __weak NSTextField *UI_speedWrite;
}




@property (assign) IBOutlet NSWindow *window;


- (IBAction)UI_start_pressed:(id)sender;
@property (weak) IBOutlet NSButton *UI_start;


@property (weak) IBOutlet NSTextField *UI_writeSpeed;
@property (weak) IBOutlet NSTextField *UI_volumesName;
@property (weak) IBOutlet NSTextField *UI_writeUnit;
@property (weak) IBOutlet NSProgressIndicator *UI_progress;
@property (weak) IBOutlet NSTextField *UI_progressValue;


@property (weak) IBOutlet NSTextField *UI_readSpeed;
@property (weak) IBOutlet NSTextField *UI_readUnit;

@property (weak) IBOutlet NSTextField *UI_readProgressPercentage;
@end
