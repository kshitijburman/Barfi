#ifndef __CONSOLE_H__
#define __CONSOLE_H_

void update_cursor();
void setxy(u8int new_x,u8int new_y);
void clrscr();
void scroll();
void putchar(u8int ch);
void puts(u8int *msg);

#endif