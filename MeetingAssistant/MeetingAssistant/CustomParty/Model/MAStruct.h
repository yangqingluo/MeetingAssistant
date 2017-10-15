//
//  MAStruct.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#ifndef MAStruct_h
#define MAStruct_h

#import "MACommand.h"

#pragma pack(1)

struct _net_udp_package {
    int header;/* static value : NET_PACK_HEADER */
    int type;/* CMD_REGISTER_BROADCAST, RESP _REGISTER_BROADCAST etc. */
    unsigned int data_len;	/* data buf len */
    unsigned char data[MAX_UDP_DATA_LEN - 12];
};
typedef struct _net_udp_package NET_UDP_PACKAGE;

struct _register_broadcast {
    unsigned int port;	/* 端口号 */
};
typedef struct _register_broadcast REGISTER_BROADCAST;

struct  _register_broadcast_resp{
    int ipaddr;		/* host ipaddr, 4 bytes for each position */
    unsigned int port;	/* 端口号 */
};
typedef struct _register_broadcast_resp REGISTER_BROADCAST_RESP;

struct  _file_begin{
    int type;	/* 下发文件类型，比如0x00名牌名称图片, 0x01会议纪要图片重新添加*/
    unsigned char pic_name[32];//固定长度32
    unsigned int total; /* 分包总数 */
};
typedef struct _file_begin FILE_BEGIN;

#pragma pack()

#endif /* MAStruct_h */