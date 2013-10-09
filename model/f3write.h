//
//  f3write.h
//  sdspeed
//
//  Created by M on 16.03.13.
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

#ifndef sdspeed_f3write_h
#define sdspeed_f3write_h


extern int g_FLAG_shouldTerminate;


// -- write
void        f3write_unlink_old_files(const char *path, int start_at);
double      f3write_fill_fs(const char *path, int start_at, int progress);
double      f3write_getCurrentSpeed(void);
double      f3write_getCurrentPercent(void);
const char* f3write_getCurrentUnit(void);


// -- read
void        f3read_iterate_files(const char *path, const int *files, int start_at, int progress);
double      f3read_getReadSpeedAverage(void);
const char* f3read_getCurrentUnit(void);

double f3read_getCurrentPercent(void);


#endif
