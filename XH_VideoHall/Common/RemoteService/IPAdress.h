/*
 *  IPAdress.h
 *  Untitled
 *
 *  Created by yangdl on 11-7-27.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#define MAXADDRS    32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();