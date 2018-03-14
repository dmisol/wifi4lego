#ifndef CGI_H
#define CGI_H

#include "httpd.h"

int tplReadSettings(HttpdConnData *connData, char *token, void **arg);
int cgiSetPwm(HttpdConnData *connData);

int tplIndex(HttpdConnData *connData, char *token, void **arg);
int cgiControl(HttpdConnData *connData);

#endif