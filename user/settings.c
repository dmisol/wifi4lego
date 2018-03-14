#include <esp8266.h>
#define SettingsSize    1024
#define USER_STORAGE_ADDR       0x17000
#define USER_SECTOR             0x17     // 0x1000 per sector?

char *settings;
char *sett[4];
char value[64];

void ICACHE_FLASH_ATTR addkey(char *k, char *v){
    sprintf(settings+strlen(settings),"%s %s\n",k,v);
}
char ICACHE_FLASH_ATTR *getkey(char *key){  
    strcpy(value,"");
    
    char *p = strstr(settings,key);
    if(p)
        strncpy(value,p+1+strlen(key),63);
    value[63] = 0;
    
    p = strstr(value,"\n");
    if(p) *p = 0;

    return value;
}
void ICACHE_FLASH_ATTR initSettings(){
    os_printf("reading conf\n");
    //strcpy(settings,defsettings);
    // ToDo: read block
    settings = (char*) os_malloc(4*SettingsSize);
    spi_flash_read(USER_STORAGE_ADDR, (uint32 *) settings, 4*SettingsSize);
    for(int i=0;i<4;i++)
	sett[i] = settings + i*SettingsSize;
}

void ICACHE_FLASH_ATTR activateSettings(int set){
    if((set <1) || (set >3)){
	printf("invalid source: %d\n",set);
	return;
    }
    if((strlen(sett[set])<1) || strlen(sett[set]>(SettingsSoze-1))){
	printf("invalid length: %d\n",sett[set]);
	return;
    }
    strcpy(settings,sett[set]);
    printf("settings %d copied to default\n\'%s\'\n",set);

    writeSettings();
}

void ICACHE_FLASH_ATTR saveSettings(char *params, int set){
    os_printf("preparing to update conf\n");
    strcpy(settings,"");
    char *p; 
    char *t; 
    char *v;
    p = params;
    while(strlen(p)){
        t = p;
        p = strchr(p,'=');
        *p = 0; p++;
        v = p;
        p = strchr(p,'&');
        if(p) { *p = 0; p++; }
        printf("\'%s\'->\'%s\'\n",t,v);
        addkey(t,v);
        if(!p) break;
    }
    // copy default (active) settings to the requested block
    if((set>0) && (set<4)) 
	strcpy(sett[i],settings);

    writeSettings();
}

ICACHE_FLASH_ATTR writeSettings(){
    os_printf("writing conf\n");
    spi_flash_erase_sector(USER_SECTOR);
    spi_flash_write(USER_STORAGE_ADDR, (uint32 *) settings, 4*SettingsSize);

}



