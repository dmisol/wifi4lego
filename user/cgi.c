/*
Some random cgi routines. Used in the LED example and the page that returns the entire
flash as a binary. Also handles the hit counter on the main page.
*/

/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Jeroen Domburg <jeroen@spritesmods.com> wrote this file. As long as you retain 
 * this notice you can do whatever you want with this stuff. If we meet some day, 
 * and you think this stuff is worth it, you can buy me a beer in return. 
 * ----------------------------------------------------------------------------
 */


#include <esp8266.h>
#include "cgi.h"
#include "io.h"
#include "legopwm.h"
#include "captdns.h"
#include "httpd.h"
#include "settings.h"
int ICACHE_FLASH_ATTR cgiSetPwm(HttpdConnData *connData) {
	int len;
	char buff[1024];
	unsigned val;
        
	if (connData->conn==NULL) {
		//Connection aborted. Clean up.
		return HTTPD_CGI_DONE;
	}

        os_strcpy(buff,"REQUEST\t\t");//,connData->post->buff);
        
	len=httpdFindArg(connData->post->buff, "c0", buff, sizeof(buff));
	if (len!=0) {   val=atoi(buff); 
                        os_sprintf(buff+strlen(buff),"%d ",val);
                        legopwm_set_duty(val,0); }
	len=httpdFindArg(connData->post->buff, "c1", buff, sizeof(buff));
	if (len!=0) {   val=atoi(buff); 
                        os_sprintf(buff+strlen(buff),"%d ",val);
                        legopwm_set_duty(val,1);}
	len=httpdFindArg(connData->post->buff, "c2", buff, sizeof(buff));
	if (len!=0) {   val=atoi(buff); 
                        os_sprintf(buff+strlen(buff),"%d ",val);
                        legopwm_set_duty(val,2);}

//        for(len=0;len<3;len++) os_printf("verify ch%d: %d\n",len,legopwm_get_duty(len));
        pwm_start();
        
	//httpdRedirect(connData, "servotest.tpl");
        os_printf("%s\n",buff);  // some data - test
	httpdSend(connData, buff, -1);
        //return HTTPD_CGI_DONE;
        return HTTPD_CGI_MORE;
}

int ICACHE_FLASH_ATTR tplReadSettings(HttpdConnData *connData, char *token, void **arg) {
	char buff[128];
	if (token==NULL) return HTTPD_CGI_DONE;

	os_sprintf(buff, "%s",getkey(token));
        os_printf("%s -> \'%s\'\n",token,buff);
        
	httpdSend(connData, buff, -1);
	return HTTPD_CGI_DONE;
}



int ICACHE_FLASH_ATTR tplIndex(HttpdConnData *connData, char *token, void **arg) {
	char buff[128];
	if (token==NULL) return HTTPD_CGI_DONE;

        os_sprintf(buff, "%s",getkey(token));
        os_printf("%s -> \'%s\'\n",token,buff);
        
	if((os_strcmp(token, "play")==0) && (strlen(buff)==0)){
		os_sprintf(buff, "%s", "gyrows");
	}
        
	httpdSend(connData, buff, -1);
	return HTTPD_CGI_DONE;
}

int ICACHE_FLASH_ATTR cgiControl(HttpdConnData *connData) {
    if (connData->requestType==HTTPD_METHOD_GET){
        os_printf("GET: \'%s\'\n",connData->getArgs);
        saveSettings(connData->getArgs);
    }
    if (connData->requestType==HTTPD_METHOD_POST){
        os_printf("POST: \'%s\'\n",connData->post->buff);
        saveSettings(connData->post->buff);
    }
    httpdRedirect(connData,"/");
    return HTTPD_CGI_DONE;
}
/*
unsigned static ICACHE_FLASH_ATTR decodeHex(char *str){
    unsigned res = 0;
    char *p; p = str;

    while(isxdigit(*p)){
        os_printf("char = %c\n",*p);
        res <<= 4;
        if(isdigit(*p)) res += ((*p)-'0');
        else res += (10 + tolower(*p) - 'a');
        p++;

        os_printf("value is %X\n",res);
    }
    return res;
}
*/
