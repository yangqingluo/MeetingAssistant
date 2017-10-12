//
//  MACommand.h
//  MeetingAssistant
//
//  Created by 7kers on 2017/10/12.
//  Copyright © 2017年 yangqingluo. All rights reserved.
//

#ifndef MACommand_h
#define MACommand_h

#define NET_PACK_HEADER                   0xe39ff93e /* 报文头 */
#define MAX_UDP_DATA_LEN                  128 /* UDP报文最大长度*/
#define MAX_TCP_DATA_LEN                  1024 * 100 /* TCP报文最大长度 */

#define CMD_REGISTER_BROADCAST		   	  0x9101	/* 广播注册*/
#define RESP_REGISTER_BROADCAST           0x9102	/* 回复广播注册*/
#define CMD_REGISTER_RESULT			      0x9103	/* 注册结果*/

#define CMD_OPERATION_LIGHT_OPEN		  0x9201/* 操作-点亮*/
#define RESP_OPERATION_LIGHT_OPEN         0x9202/* 回复点亮*/
#define CMD_OPERATION_LIGHT_CLOSE		  0x9203/* 操作-关闭 */
#define RESP_OPERATION_LIGHT_CLOSE        0x9204/* 回复关闭 */
#define CMD_OPERATION_CLEAR			      0x9205/* 操作-清除名牌上的内容*/
#define RESP_OPERATION_CLEAR			  0x9206/* 回复-清除名牌上的内容*/

#define CMD_FILE_BEGIN                    0x9301
#define CMD_FILE_CONTENT                  0x9302
#define CMD_FILE_FINISH                   0x9303

#endif /* MACommand_h */
