#ifndef MOUSEDRIVER_H
#define MOUSEDRIVER_H

struct mousedriver
{
	int dx,dy,dz,buttons;
	int changed;
	void *private;
};

void mousedriver_ps2_init(struct mousedriver *driver);
void mousedriver_ps2_handle(struct mousedriver *driver);
void mousedriver_reset(struct mousedriver *driver);
int mousedriver_get_event(struct mousedriver *driver);
int mousedriver_get_buttons(struct mousedriver *driver);
int mousedriver_get_dx(struct mousedriver *driver);
int mousedriver_get_dy(struct mousedriver *driver);
int mousedriver_get_dz(struct mousedriver *driver);

#endif

