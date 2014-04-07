/*
  This code is based on Digilent DeppDemo from digilent.adept.sdk_2.3.1/samples/depp
 */
#include <stdio.h>
#include <stdlib.h>
#include "dpcdecl.h"
#include "depp.h"
#include "dmgr.h"

HIF hif = hifInvalid;
FILE * fhin = 0;
FILE * fhout = 0;


void ErrorExit()
{
    if(hif != hifInvalid )
    {
        DeppDisable(hif);
        DmgrClose(hif);
    }

    if(fhin)
        fclose(fhin);

    if(fhout)
        fclose(fhout);

    exit(1);
}


void set_addr(unsigned int addr)
{
    BYTE    rgbLd[10];
    *rgbLd = addr & 0xff; // low

    if(!DeppPutRegRepeat(hif, 1, rgbLd, 1, fFalse))
    {
        printf("DeppPutRegRepeat failed.\n");
        ErrorExit();
    }

    *rgbLd = (addr >> 8) & 0xff; // high
    if(!DeppPutRegRepeat(hif, 2, rgbLd, 1, fFalse))
    {
        printf("DeppPutRegRepeat failed.\n");
        ErrorExit();
    }
}

void send_word18(unsigned int data18)
{
    BYTE    rgbLd[10];

    *rgbLd = (data18 >> 8) & 0xff;
    if(!DeppPutRegRepeat(hif, 4, rgbLd, 1, fFalse))
    {
        printf("DeppPutRegRepeat failed.\n");
        ErrorExit();
    }

    *rgbLd = (data18 >> 16) & 0x3;
    if(!DeppPutRegRepeat(hif, 5, rgbLd, 1, fFalse))
    {
        printf("DeppPutRegRepeat failed.\n");
        ErrorExit();
    }

    *rgbLd = data18 & 0xff;
    if(!DeppPutRegRepeat(hif, 0, rgbLd, 1, fFalse))
    {
        printf("DeppPutRegRepeat failed.\n");
        ErrorExit();
    }
}

void write_word18(unsigned int addr, unsigned int data18)
{
    set_addr(addr);
    send_word18(data18);
}

int main()
{
    const char * b = "Basys2";
    if(!DmgrOpen(&hif, (char*)b))
    {
        printf("DmgrOpen failed (check the device name you provided)\n");
        return 1;
    }

    if(!DeppEnable(hif)) {
        printf("DeppEnable failed\n");
        return 1;
    }

    FILE *                  fhin = NULL;

    fhin = fopen("stub_hex_file.hex", "r+");
    if (fhin == NULL)
    {
        printf("Cannot open file\n");
        ErrorExit();
    }

    char buf[100];

    set_addr(0);

    for (;;)
    {
        if (!fgets(buf,sizeof(buf), fhin))
            break;
        unsigned int tmp;
        sscanf(buf, "%x", &tmp);
        send_word18(tmp);
    }

    fclose(fhin);

    if( hif != hifInvalid )
    {
        DeppDisable(hif);
        DmgrClose(hif);
    }
}
