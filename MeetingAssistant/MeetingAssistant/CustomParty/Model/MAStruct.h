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

struct _net_tcp_package {
    int header;/* static value : NET_PACK_HEADER */
    int type;/* CMD_REGISTER_BROADCAST, RESP _REGISTER_BROADCAST etc. */
    unsigned int data_len;	/* data buf len */
    unsigned char data[MAX_TCP_DATA_LEN - 12];
};
typedef struct _net_tcp_package NET_TCP_PACKAGE;

struct _register_broadcast {
    unsigned int port;	/* 端口号 */
};
typedef struct _register_broadcast REGISTER_BROADCAST;

struct  _register_broadcast_resp{
    int ipaddr;		/* host ipaddr, 4 bytes for each position */
    unsigned int port;	/* 端口号 */
};
typedef struct _register_broadcast_resp REGISTER_BROADCAST_RESP;

struct  _register_result{
    Byte result;	/* 注册结果 0x00失败， 0x01成功 */
};
typedef struct _register_result REGISTER_RESULT;

struct  _operation_light{
    Byte result;	/* 点亮操作：0x00，关闭操作：0x01 */
};
typedef struct _operation_light OPERATION_LIGHT;

struct  _operation_light_resp{
    Byte result;	/* 成功：0x00，失败：0x01 */
};
typedef struct _operation_light_resp OPERATION_LIGHT_RESP;

struct  _file_begin{
    int type;	/* 下发文件类型，比如0x00名牌名称图片, 0x01会议纪要图片重新添加*/
    unsigned char pic_name[32];//固定长度32
    unsigned int total; /* 分包总数 */
};
typedef struct _file_begin FILE_BEGIN;

struct  _file_content{
    unsigned int seq;/* 分包序数 */
    unsigned int len;/*  */
    unsigned char buf[MAX_TCP_DATA_LEN - 20];
};
typedef struct _file_content FILE_CONTENT;


#pragma pack()

#endif /* MAStruct_h */
