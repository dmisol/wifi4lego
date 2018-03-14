/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Jeroen Domburg <jeroen@spritesmods.com> wrote this file. As long as you retain 
 * this notice you can do whatever you want with this stuff. If we meet some day, 
 * and you think this stuff is worth it, you can buy me a beer in return. 
 * ----------------------------------------------------------------------------
 */

/*
This is example code for the esphttpd library. It's a small-ish demo showing off 
the server, including WiFi connection management capabilities, some IO and
some pictures of cats.
*/

#include <esp8266.h>
#include "httpd.h"
#include "io.h"
#include "httpdespfs.h"
#include "cgi.h"
#include "cgiwifi.h"
#include "cgiflash.h"
#include "stdout.h"
#include "auth.h"
#include "espfs.h"
#include "captdns.h"
#include "webpages-espfs.h"
#include "cgiwebsocket.h"
#include "settings.h"
#include "legopwm.h"

//The example can print out the heap use every 3 seconds. You can use this to catch memory leaks.
//#define SHOW_HEAP_USE

//Function that tells the authentication system what users/passwords live on the system.
//This is disabled in the default build; if you want to try it, enable the authBasic line in
//the builtInUrls below.
int myPassFn(HttpdConnData *connData, int no, char *user, int userLen, char *pass, int passLen) {
	if (no==0) {
		os_strcpy(user, "admin");
		os_strcpy(pass, "s3cr3t");
		return 1;
//Add more users this way. Check against incrementing no for each user added.
//	} else if (no==1) {
//		os_strcpy(user, "user1");
//		os_strcpy(pass, "something");
//		return 1;
	}
	return 0;
}

//On reception of a message, send "You sent: " plus whatever the other side sent
void myWebsocketRecv(Websock *ws, char *data, int len, int flags) {
        char *p;
        unsigned val;
        char buff[128];
	
        strcpy(buff,"");
        os_printf("WS RECV:\t\t\t %s\n",data);
        p = strstr(data,"c0=");
        if(p) { val = atoi(p+3);
                legopwm_set_duty(val,0); }
        else os_printf("\'c0=\' not found\n"); 
        p = strstr(data,"c1=");
        if(p) { val = atoi(p+3);
                legopwm_set_duty(val,1); }
        else os_printf("\'c1=\' not found\n"); 
        p = strstr(data,"c2=");
        if(p) { val = atoi(p+3);
                legopwm_set_duty(val,2); }
        else os_printf("\'c2=\' not found\n"); 

        pwm_start();
         
        p = strstr(data,"cntr=");
        if(p) strcat(buff,p);
        
        buff[strlen(buff)] = 0;
	os_printf("SENDING BACK: %s\n",buff);
	cgiWebsocketSend(ws, buff, os_strlen(buff), WEBSOCK_FLAG_NONE);
}

//Websocket connected. Install reception handler and send welcome message.
void myWebsocketConnect(Websock *ws) {
	ws->recvCb=myWebsocketRecv;
	cgiWebsocketSend(ws, "Hi, LEGO!!", 14, WEBSOCK_FLAG_NONE);
}

#ifdef ESPFS_POS
CgiUploadFlashDef uploadParams={
	.type=CGIFLASH_TYPE_ESPFS,
	.fw1Pos=ESPFS_POS,
	.fw2Pos=0,
	.fwSize=ESPFS_SIZE,
};
#define INCLUDE_FLASH_FNS
#endif
#ifdef OTA_FLASH_SIZE_K
CgiUploadFlashDef uploadParams={
	.type=CGIFLASH_TYPE_FW,
	.fw1Pos=0x1000,
	.fw2Pos=((OTA_FLASH_SIZE_K*1024)/2)+0x1000,
	.fwSize=((OTA_FLASH_SIZE_K*1024)/2)-0x1000,
	.tagName=OTA_TAGNAME
};
#define INCLUDE_FLASH_FNS
#endif

/*
This is the main url->function dispatching data struct.
In short, it's a struct with various URLs plus their handlers. The handlers can
be 'standard' CGI functions you wrote, or 'special' CGIs requiring an argument.
They can also be auth-functions. An asterisk will match any url starting with
everything before the asterisks; "*" matches everything. The list will be
handled top-down, so make sure to put more specific rules above the more
general ones. Authorization things (like authBasic) act as a 'barrier' and
should be placed above the URLs they protect.
*/
HttpdBuiltInUrl builtInUrls[]={
	{"*", cgiRedirectApClientToHostname, "192.168.4.1/index.tpl"},
	{"/", cgiRedirect, "/index.tpl"},
	{"/index.html", cgiRedirect, "/index.tpl"},
	
        {"/index.tpl", cgiEspFsTemplate, tplIndex},
        {"/play/gyrows.html", cgiEspFsTemplate, tplReadSettings},
        {"/play/touchws.html", cgiEspFsTemplate, tplReadSettings},
        
	{"/legows", cgiWebsocket, myWebsocketConnect},
	{"/play/legows", cgiWebsocket, myWebsocketConnect},
 	{"/ctrl/control", cgiControl, NULL},
        
	{"/flash/next", cgiGetFirmwareNext, &uploadParams},
	{"/flash/upload", cgiUploadFirmware, &uploadParams},
	{"/flash/reboot", cgiRebootFirmware, NULL},

	{"*", cgiEspFsHook, NULL}, //Catch-all cgi function for the filesystem
	{NULL, NULL, NULL}
};


#ifdef SHOW_HEAP_USE
static ETSTimer prHeapTimer;

static void ICACHE_FLASH_ATTR prHeapTimerCb(void *arg) {
	os_printf("Heap: %ld\n", (unsigned long)system_get_free_heap_size());
}
#endif

//Main routine. Initialize stdout, the I/O, filesystem and the webserver and we're done.
void user_init(void) {
	stdoutInit();
	ioInit();
	captdnsInit();
        
        initSettings();
	// 0x40200000 is the base address for spi flash memory mapping, ESPFS_POS is the position
	// where image is written in flash that is defined in Makefile.
#ifdef ESPFS_POS
	os_printf("ESPFS_POS is %X\n", ESPFS_POS);
	espFsInit((void*)(0x40200000 + ESPFS_POS));
#else
	os_printf("ESPFS_POS is UNDEF\n");
	espFsInit((void*)(webpages_espfs_start));
#endif
	httpdInit(builtInUrls, 80);
#ifdef SHOW_HEAP_USE
	os_timer_disarm(&prHeapTimer);
	os_timer_setfn(&prHeapTimer, prHeapTimerCb, NULL);
	os_timer_arm(&prHeapTimer, 3000, 1);
#endif
	legopwm_init();
	os_printf("\npwm started\n");

       
        os_printf("\n pwm ver: %d\n",get_pwm_version());
        os_printf("\n pwm period: %d\n",pwm_get_period());
        os_printf("\n pwm duty[0]: %d\n",pwm_get_duty(0));
        os_printf("\n pwm duty[1]: %d\n",pwm_get_duty(1));
        os_printf("\n pwm duty[2]: %d\n",pwm_get_duty(2));

}

void user_rf_pre_init() {
	//Not needed, but some SDK versions want this defined.
}
uint32 ICACHE_FLASH_ATTR
user_rf_cal_sector_set(void)
{
    enum flash_size_map size_map = system_get_flash_size_map();
    uint32 rf_cal_sec = 0;

    switch (size_map) {
        case FLASH_SIZE_4M_MAP_256_256:
            rf_cal_sec = 128 - 5;
            break;

        case FLASH_SIZE_8M_MAP_512_512:
            rf_cal_sec = 256 - 5;
            break;

        case FLASH_SIZE_16M_MAP_512_512:
        case FLASH_SIZE_16M_MAP_1024_1024:
            rf_cal_sec = 512 - 5;
            break;

        case FLASH_SIZE_32M_MAP_512_512:
        case FLASH_SIZE_32M_MAP_1024_1024:
            rf_cal_sec = 1024 - 5;
            break;

        default:
            rf_cal_sec = 0;
            break;
    }

    return rf_cal_sec;
}
