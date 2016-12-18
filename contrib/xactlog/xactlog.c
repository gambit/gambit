/* File: "xactlog.c"   (c) 1997-2016, Marc Feeley */

/* Tool to examine activity logs on an X11 display */

/*
 * To compile:
 *
 *    gcc -I /usr/X11/include -O -o xactlog xactlog.c -L /usr/X11/lib -lX11
 *
 * To run:
 *
 *    ./xactlog gambit.actlog
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int debug_level = 1; /* show warnings only */

/*---------------------------------------------------------------------------*/

/* Various builtin integer types */


/* U8 corresponds to a builtin unsigned 8 bit integer type */

typedef unsigned char U8;


/* U16 corresponds to a builtin unsigned 16 bit integer type */

typedef unsigned short U16;


/* U32 corresponds to a builtin unsigned 32 bit integer type */

typedef unsigned int U32;


/*---------------------------------------------------------------------------*/

#define USE_ULONGLONG

#ifdef USE_ULONGLONG

/* U64 represents an unsigned 64 bit integer type */

typedef unsigned long long U64;

#define U64_to_double(n) ((double)(n))
#define U64_to_U32(n) ((U32)(n))
#define U64_init(hi32,lo32) (((U64)(U32)(hi32)<<32)+(U64)(U32)(lo32))
#define U64_less_than_U64(n,m) ((U64)(n)<(U64)(m))
#define U64_less_than_U32(n,m) ((U64)(n)<(U32)(m))
#define U64_add_U64(n,m) ((U64)(n)+(U64)(m))
#define U64_add_U32(n,m) ((U64)(n)+(U32)(m))
#define U64_sub_U64(n,m) ((U64)(n)-(U64)(m))
#define U64_sub_U32(n,m) ((U64)(n)-(U32)(m))
#define U64_mul_U64(n,m) ((U64)(n)*(U64)(m))
#define U64_mul_U32(n,m) ((U64)(n)*(U32)(m))
#define U64_div_U64(n,m) ((U64)(n)/(U64)(m))
#define U64_div_U32(n,m) ((U64)(n)/(U32)(m))
#define U64_mod_U32(n,m) ((U32)((U64)(n)%(U32)(m)))

static U32 U64_shift_right (dest, count)
U64 *dest;
int count;
{
  U32 result = (*dest) & ~(~0ULL<<count);
  *dest >>= count;
  return result;
}

#else

/* U64 represents an unsigned 64 bit integer type */

typedef struct { U32 lo32, hi32; } U64;


static double U64_to_double (n)
U64 n;
{
  return n.hi32*4294967296.0 + n.lo32;
}


static U32 U64_to_U32 (n)
U64 n;
{
  return n.lo32;
}


static U64 U64_init (hi32, lo32)
U32 hi32;
U32 lo32;
{
  U64 result;
  result.lo32 = lo32;
  result.hi32 = hi32;
  return result;
}


static int U64_less_than_U64 (n, m)
U64 n;
U64 m;
{
  U32 x = n.hi32;
  U32 y = m.hi32;
  return (x < y) || ((x == y) && (n.lo32 < m.lo32));
}


static int U64_less_than_U32 (n, m)
U64 n;
U32 m;
{
  return (n.hi32 == 0) && (n.lo32 < m);
}


static U64 U64_add_U64 (n, m)
U64 n;
U64 m;
{
  U32 x = n.lo32;
  U32 y = n.hi32;
  U32 a = x + m.lo32;
  U32 b = y + m.hi32;
  if (a < x)
    b++;
  n.lo32 = a;
  n.hi32 = b;
  return n;
}


static U64 U64_add_U32 (n, m)
U64 n;
U32 m;
{
  U32 x = n.lo32;
  U32 a = x + m;
  if (a < x)
    n.hi32++;
  n.lo32 = a;
  return n;
}


static U64 U64_sub_U64 (n, m)
U64 n;
U64 m;
{
  U32 x = n.lo32;
  U32 y = n.hi32;
  U32 a = x - m.lo32;
  U32 b = y - m.hi32;
  if (a > x)
    b--;
  n.lo32 = a;
  n.hi32 = b;
  return n;
}


static U64 U64_sub_U32 (n, m)
U64 n;
U32 m;
{
  U32 x = n.lo32;
  U32 a = x - m;
  if (a > x)
    n.hi32--;
  n.lo32 = a;
  return n;
}


static U64 U64_mul_U32 (n, m)
U64 n;
U32 m;
{
  U16 xlo16 = n.lo32;
  U16 xhi16 = n.lo32>>16;
  U16 ylo16 = n.hi32;
  U16 yhi16 = n.hi32>>16;
  U16 m16 = m;
  U32 a = m16 * xlo16;
  U32 b = m16 * xhi16 + (a>>16);
  U32 c = m16 * ylo16 + (b>>16);
  U32 d = m16 * yhi16 + (c>>16);
  m16 = m>>16;
  if (m16 > 0)
    {
      U32 e = m16 * xlo16;
      U32 f = m16 * xhi16 + (e>>16);
      U32 g = m16 * ylo16 + (f>>16);
      b = (b & ~(~0<<16)) + (e & ~(~0<<16));
      c = (c & ~(~0<<16)) + (f & ~(~0<<16)) + (b>>16);
      d = (d & ~(~0<<16)) + (g & ~(~0<<16)) + (c>>16);
    }
  n.lo32 = (a & ~(~0<<16)) + (b<<16);
  n.hi32 = (c & ~(~0<<16)) + (d<<16);
  return n;
}


static U64 U64_mul_U64 (n, m)
U64 n;
U64 m;
{
  U64 result = U64_mul_U32 (n, m.lo32);
  result.hi32 += n.lo32 * m.hi32;
  return result;
}


static U64 U64_div_U64 (n, m)
U64 n;
U64 m;
{
  double r = U64_to_double (n) / U64_to_double (m);
  U32 b = r / 4294967296.0;
  U32 a = r - b*4294967296.0;
  n.lo32 = a;
  n.hi32 = b;
  return n;
}


static U64 U64_div_U32 (n, m)
U64 n;
U32 m;
{
  U32 x = n.lo32;
  U32 y = n.hi32;
  n.lo32 = x/m + (U32)((y%m)*4294967296.0/m);
  n.hi32 = y/m;
  return n;
}


static U32 U64_mod_U32 (n, m)
U64 n;
U32 m;
{
  U64 result = U64_sub_U64 (n, U64_mul_U32 (U64_div_U32 (n, m), m));
  return result.lo32;
}


static U32 U64_shift_right (dest, count)
U64 *dest;
int count;
{
  U32 x = dest->lo32;
  U32 y = dest->hi32;
  if (count < 32)
    {
      dest->lo32 = (x>>count) + (y<<(32-count));
      dest->hi32 = y>>count;
      return x & ~(~0UL<<count);
    }
  else
    {
      dest->lo32 = y;
      dest->hi32 = 0;
      return x;
    }
}

#endif

/*---------------------------------------------------------------------------*/

/* RGB colors are represented by a 32 bit unsigned integer */

typedef U32 RGB;

#define RGBCOLOR(r,g,b)(((((U32)(r)<<8)+(U32)(g))<<8)+(U32)(b))
#define RED(c)((c)>>16)
#define GREEN(c)(((c)>>8)&0xff)
#define BLUE(c)((c)&0xff)

/*---------------------------------------------------------------------------*/

/* Reading of log files. */


static int read_U8 (f, n)
FILE *f;
U8 *n;
{
  int c = getc (f);
  if (c != EOF)
    {
      *n = c;
      return 1;
    }
  else
    return 0;
}


static int read_U16 (f, n)
FILE *f;
U16 *n;
{
  U8 n1, n2;
  if (read_U8 (f, &n1) &&
      read_U8 (f, &n2))
    {
      *n = (n1<<8) + n2;
      return 1;
    }
  else
    return 0;
}


static int read_U32 (f, n)
FILE *f;
U32 *n;
{
  U16 n1, n2;
  if (read_U16 (f, &n1) &&
      read_U16 (f, &n2))
    {
      *n = (n1<<16) + n2;
      return 1;
    }
  else
    return 0;
}


static int read_U64 (f, n)
FILE *f;
U64 *n;
{
  U32 n1, n2;
  if (read_U32 (f, &n1) &&
      read_U32 (f, &n2))
    {
      *n = U64_init (n1, n2);
      return 1;
    }
  else
    return 0;
}


static int read_string (f, str)
FILE *f;
char **str;
{
  char buf[1025];
  int c;
  int i = 0;
  c = getc (f);
  while ((c != '\n') && (c != EOF))
    {
      if (i < sizeof(buf)-1)
        buf[i++] = c;
      c = getc (f);
    }
  if (c != EOF)
    {
      buf[i++] = '\0';
      *str = malloc (i);
      while (--i >= 0)
        (*str)[i] = buf[i];
      return 1;
    }
  else
    return 0;
}


/*---------------------------------------------------------------------------*/


#ifdef THINK_C
#define MAC
#else
#define X11
#endif


/*--------------------------------------------------------------------------*/

#ifdef X11
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#endif

#define WHITE 0
#define BLACK 1
#define GRAY  2
#define OTHER 3

#define CENTER 0
#define LEFT   1
#define RIGHT  2

#define MAX_NB_COLORS (256+4)
#define INVERT (MAX_NB_COLORS-1)

typedef struct {
  char *name;
  int w, h;
  FILE *ps_file;
#ifdef X11
  Window win;
  XFontStruct *font;
  GC col[MAX_NB_COLORS];
#endif
#ifdef MAC
  WindowPtr win;
#endif
  RGB *colors;
  int nbcolors;
  void (*redraw)();
  void (*point)();
  void (*click)();
  int (*key)();
  void (*resize)();
  } *window;

int graph_display = 1;

int graph_black_and_white = 0;

int graph_screen_width = 1280, graph_screen_height = 1024;

RGB rgb_white = RGBCOLOR(255,255,255);  /* white */
RGB rgb_black = RGBCOLOR(  0,  0,  0);  /* black */
RGB rgb_gray  = RGBCOLOR(191,191,191);  /* light gray */

RGB win_get_color (win, col)
window win;
int col;
{
  if (col == WHITE)
    return rgb_white;
  else if (col == BLACK)
    return rgb_black;
  else if (col == GRAY)
    return rgb_gray;
  else
    return win->colors[col-OTHER];
}

#define STIPPLE_W 8
#define STIPPLE_H 8

char stipple[][STIPPLE_H] = {
{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
{ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 },
{ 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa },
{ 0x00, 0x80, 0x00, 0x08, 0x00, 0x80, 0x00, 0x08 },
{ 0x11, 0x22, 0x44, 0x88, 0x11, 0x22, 0x44, 0x88 },
{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
{ 0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22 },
{ 0x00, 0xaa, 0x00, 0xaa, 0x00, 0xaa, 0x00, 0xaa },
{ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 },
{ 0xee, 0xdd, 0xbb, 0x77, 0xee, 0xdd, 0xbb, 0x77 },
{ 0xdd, 0x77, 0xdd, 0x77, 0xdd, 0x77, 0xdd, 0x77 },
{ 0xdd, 0xff, 0x77, 0xff, 0xdd, 0xff, 0x77, 0xff },
{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
{ 0x80, 0x10, 0x02, 0x20, 0x01, 0x08, 0x40, 0x04 },
{ 0x88, 0xff, 0x88, 0x88, 0x88, 0xff, 0x88, 0x88 },
{ 0xb1, 0x30, 0x03, 0x1b, 0xd8, 0xc0, 0x0c, 0x8d },
{ 0x00, 0x80, 0x40, 0x20, 0x00, 0x02, 0x04, 0x08 }
};

char *win_get_stipple (win, col)
window win;
int col;
{
  if (col < OTHER)
    return stipple[col];
  else
    return stipple[OTHER+(col-OTHER)%(sizeof(stipple)/STIPPLE_H-OTHER)];
}

/*--------------------------------------------------------------------------*/

#ifdef X11

Display *display;
int screen;


void g_init ()
{
  /* connect to X server */

  if ( (display=XOpenDisplay(NULL)) == NULL )
    {
      fprintf( stderr, "can't connect to X server\n");
      exit (1);
    }

  /* get screen size */

  screen = DefaultScreen( display );

  graph_screen_width  = DisplayWidth( display, screen );
  graph_screen_height = DisplayHeight( display, screen );
}


void g_clear( win )
window win;
{ XClearWindow( display, win->win );
}


void g_box( win, color, x, y, w, h )
window win;
int color;
int x, y, w, h;
{ XFillRectangle( display, win->win, win->col[color], x, win->h - (y+h), w, h );
}


void g_text( win, color, where, x, y, str )
window win;
int color;
int where;
int x, y;
char *str;
{ int len, str_width, y_pos, x_pos;

  len = strlen( str );
  str_width = XTextWidth( win->font, str, len );
  y_pos = win->h - (y - win->font->max_bounds.ascent/2);

  switch (where)
  { case CENTER: x_pos = x - str_width/2; break;
    case LEFT:   x_pos = x;               break;
    case RIGHT:  x_pos = x - str_width;   break;
  }

  XDrawString( display, win->win, win->col[color], x_pos, y_pos, str, len );
}


window g_window( name, width, height, colors, nbcolors,redraw, point, click, key, resize )
char *name;
int width, height;
RGB *colors;
int nbcolors;
void (*redraw)();
void (*point)();
void (*click)();
int (*key)();
void (*resize)();
{ int         i;
  XGCValues   values;
  Colormap    cmap;
  int         win_x, win_y, win_w, win_h, win_b;
  window      win;
  XEvent      report;

  win = (window)malloc( sizeof(*win) );
  if (win == NULL)
  { fprintf( stderr, "can't allocate window\n" );
    exit (1);
  }

  win->name    = name;
  win->w       = width;
  win->h       = height;
  win->ps_file = NULL;
  win->colors  = colors;
  win->nbcolors= nbcolors;
  win->redraw  = redraw;
  win->point   = point;
  win->click   = click;
  win->key     = key;
  win->resize  = resize;

  /* get color map */

  cmap = DefaultColormap( display, screen );

  /* create a window */

  win_x = 0;      win_y = 0;       /* position */
  win_w = win->w; win_h = win->h;  /* size     */
  win_b = 2;                       /* border   */

  win->win = XCreateSimpleWindow( display,
                                  RootWindow( display, screen ),
                                  win_x, win_y,
                                  win_w, win_h,
                                  win_b, BlackPixel( display, screen ),
                                  WhitePixel( display, screen ) );

  /* set graphic context */

  if ((win->font=XLoadQueryFont(display,"6x10")) == NULL)
    if ((win->font=XLoadQueryFont(display,"fixed")) == NULL)
    { fprintf( stderr, "can't open 6x10 or fixed font\n");
      exit (1);
    }

  for (i=0; i<nbcolors+OTHER; i++)
  { if (graph_black_and_white || (DisplayPlanes( display, screen ) == 1))
    { values.stipple = XCreateBitmapFromData( display,
                                              RootWindow( display, screen ),
                                              win_get_stipple(win, i), STIPPLE_W, STIPPLE_H);
      values.fill_style = FillOpaqueStippled;
      values.foreground = BlackPixel( display, screen );
      values.background = WhitePixel( display, screen );
    }
    else
    { XColor def;
      static char colorname[] = "#XXXXXX";
      static char hex[] = "0123456789abcdef";
      RGB rgb = win_get_color(win, i);
      int j, c = RED(rgb)*65536+GREEN(rgb)*256+BLUE(rgb);

      for (j=6; j>0; j--) { colorname[j] = hex[c%16]; c /= 16; }

      if (!XParseColor( display, cmap, colorname, &def ))
      { fprintf( stderr, "color name %s not in database\n", colorname );
        exit (1);
      }

      if (!XAllocColor( display, cmap, &def ))
      { fprintf( stderr, "can't allocate color\n" );
        exit (1);
      }

      values.stipple = XCreateBitmapFromData( display,
                                              RootWindow( display, screen ),
                                              stipple[0], STIPPLE_W, STIPPLE_H);
      values.fill_style = FillSolid;
      values.foreground = def.pixel;
      values.background = WhitePixel( display, screen );
    }

    win->col[i] = XCreateGC( display,
                             RootWindow( display, screen ),
                             (GCForeground | GCBackground | GCStipple | GCFillStyle),
                             &values );

    XSetFont( display, win->col[i], win->font->fid );
  }

  values.function   = GXxor;
  values.plane_mask = 1;
  values.foreground = 1;
  values.background = 0;
  win->col[INVERT]  = XCreateGC( display,
                                 RootWindow( display, screen ),
                                 (GCForeground | GCBackground | GCFunction | GCPlaneMask),
                                 &values );

  /* display window */

  XMapWindow( display, win->win );

  /* wait until window appears */

  XSelectInput( display, win->win, ExposureMask );
  XWindowEvent( display, win->win, ExposureMask, &report );

  return win;
}


void g_resize( win )
window win;
{ XResizeWindow( display, win->win, win->w, win->h );
}


void g_idle( win )
window win;
{ XEvent report;
  int but_x, but_y, but = 0;

  /* enable events */

  XSelectInput( display, win->win, ExposureMask | KeyPressMask |
                                   PointerMotionMask |
                                   ButtonPressMask | ButtonReleaseMask |
                                   StructureNotifyMask );

  /* handle events */

  again:

  XNextEvent( display, &report );
  switch (report.type)
  { case Expose:
      while (XCheckTypedEvent( display, Expose, &report ));
      (*win->redraw)( win );
      break;

    case ButtonPress:
      but_x = report.xbutton.x;
      but_y = win->h - report.xbutton.y;
      but = report.xbutton.button;
      break;

    case ButtonRelease:
      if (report.xbutton.button == but)
        (*win->click)( win, but_x, but_y, report.xbutton.x, win->h - report.xbutton.y, but );
      break;

    case KeyPress:
    { KeySym sym; XComposeStatus comp; char buf[1];
      buf[0] = '\0';
      XLookupString( (XKeyEvent*)&report, buf, 1, &sym, &comp );
      if ((*win->key)( win, buf[0] )) goto done;
      break;
    }

    case MotionNotify:
    { int x, y;
      x = report.xmotion.x;
      y = report.xmotion.y;
      (*win->point)( win, x, win->h - y );
      break;
    }

    case ConfigureNotify:
      win->w = report.xconfigure.width;
      win->h = report.xconfigure.height;
      (*win->resize)( win );
      break;

    default: ;
  }

  goto again;

  done:

  /* finalize X */

  XCloseDisplay( display );
}

#endif


/*--------------------------------------------------------------------------*/

#ifdef MAC

#define OFFS_H 0
#define OFFS_V 0

char pattern[][8] = {
{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
{ 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa },
{ 0x00, 0x80, 0x00, 0x08, 0x00, 0x80, 0x00, 0x08 },
{ 0x11, 0x22, 0x44, 0x88, 0x11, 0x22, 0x44, 0x88 },
{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff },
{ 0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22 },
{ 0x00, 0xaa, 0x00, 0xaa, 0x00, 0xaa, 0x00, 0xaa },
{ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 },
{ 0xee, 0xdd, 0xbb, 0x77, 0xee, 0xdd, 0xbb, 0x77 },
{ 0xdd, 0x77, 0xdd, 0x77, 0xdd, 0x77, 0xdd, 0x77 },
{ 0xdd, 0xff, 0x77, 0xff, 0xdd, 0xff, 0x77, 0xff },
{ 0x00, 0xff, 0x00, 0xff, 0x00, 0xff, 0x00, 0xff },
{ 0x80, 0x10, 0x02, 0x20, 0x01, 0x08, 0x40, 0x04 },
{ 0x88, 0xff, 0x88, 0x88, 0x88, 0xff, 0x88, 0x88 },
{ 0xb1, 0x30, 0x03, 0x1b, 0xd8, 0xc0, 0x0c, 0x8d },
{ 0x00, 0x80, 0x40, 0x20, 0x00, 0x02, 0x04, 0x08 }
};


void g_init()
{ /* get screen size */

  graph_screen_width  = screenBits.bounds.right;
  graph_screen_height = screenBits.bounds.bottom;
}


void g_clear( win )
window win;
{ Rect r;

  r.left   = 0;
  r.right  = win->w;
  r.top    = 0;
  r.bottom = win->h;

  SetPort( win->win );
  FillRect( &r, &pattern[WHITE] );
}


void g_box( win, color, x, y, w, h )
window win;
int color;
int x, y, w, h;
{ Rect r;

  r.left   = x+OFFS_H;
  r.right  = x+OFFS_H + w;
  r.top    = win->h - (y+OFFS_H+h);
  r.bottom = win->h - (y+OFFS_H);

  SetPort( win->win );
  if (color == INVERT)
    InvertRect( &r );
  else
    FillRect( &r, &pattern[color] );
}


void g_text( win, color, where, x, y, str )
window win;
int color;
int where;
int x, y;
char *str;
{ int len = strlen(str);
  int str_width = TextWidth( str, 0, len );
  int y_pos = win->h - (y - 4);
  int x_pos;

  switch (where)
  { case CENTER: x_pos = x - str_width/2 + 1; break;
    case LEFT:   x_pos = x;                   break;
    case RIGHT:  x_pos = x - str_width;       break;
  }

  MoveTo( x_pos+OFFS_H, y_pos+OFFS_V );
  DrawText( str, 0, len );
}



void setup_window( win )
window win;
{ Rect r;

  r.left   = 0;
  r.right  = r.left + win->w;
  r.top    = 40;
  r.bottom = r.top + win->h;

  if (r.bottom > screenBits.bounds.bottom)
  { r.bottom = screenBits.bounds.bottom; r.top = r.bottom - win->h; }

  if (r.top < 0)
  { r.top = 0; r.bottom = r.top + win->h; }

  win->win = NewWindow(NULL, &r, "\pxactlog", 1, noGrowDocProc, -1L, 1, 0);
  if (win->win == NULL)
  { fprintf( stderr, "can't allocate window\n" );
    exit (1);
  }

  SetPort( win->win );
  TextFont( monaco );
  TextSize( 9 );
}


window g_window( name, width, height, colors, nbcolors,redraw, point, click, key, resize )
char *name;
int width, height;
RGB *colors;
int nbcolors;
void (*redraw)();
void (*point)();
void (*click)();
int (*key)();
void (*resize)();
{ window win;

  win = (window)malloc( sizeof(*win) );
  if (win == NULL)
  { fprintf( stderr, "can't allocate window\n" );
    exit (1);
  }

  win->name    = name;
  win->w       = width;
  win->h       = height;
  win->ps_file = NULL;
  win->colors  = colors;
  win->nbcolors= nbcolors;
  win->redraw  = redraw;
  win->point   = point;
  win->click   = click;
  win->key     = key;
  win->resize  = resize;

  setup_window( win );

  return win;
}


void g_resize( win )
window win;
{ DisposeWindow( win->win );
  setup_window( win );
  (*win->resize)( win );
  (*win->redraw)( win );
}


void g_idle( win )
window win;
{ int ok;
  int x1 = 0, y1 = 0;
  EventRecord event;
  Point last_pt, pt;

  GetMouse( &last_pt );

  again:

  SystemTask ();  /* Handle desk accessories */

  ok = GetNextEvent(everyEvent, &event);
  if (ok)
  { switch (event.what)
    { case mouseDown:
      case mouseUp:
      { WindowPtr w;
        if ((FindWindow( event.where, &w ) == inContent) && (w == win->win))
        { SetPort( win->win );
          GlobalToLocal( &event.where );
          { int x = event.where.h;
            int y = win->h - event.where.v;
            if (event.what == mouseDown)
            { x1 = x; y1 = y; }
            else
              (*win->click)( win, x1, y1, x, y, 0 );
          }
        }
        break;
      }
      case keyDown: 
      case autoKey:
        if ((event.modifiers & cmdKey) == 0)
          if ((*win->key)( win, (char)(event.message & charCodeMask) )) goto done;
        break;
    }
    GetMouse( &pt );
    if ((pt.h != last_pt.h) || (pt.v != last_pt.v))
    { last_pt = pt;
      (*win->point)( win, pt.h, win->h - pt.v );
    }
  }

  goto again;

  done:

  DisposeWindow( win->win );
}

#endif


/*--------------------------------------------------------------------------*/

int last_point_x = -1, last_point_y = -1;


void graph_postscript_begin( win, name, for_printing, zoom )
window win;
char *name;
int for_printing;
double zoom;
{ if (win->ps_file == NULL)
  { win->ps_file = fopen( name, "w" );
    if (win->ps_file == NULL)
      fprintf( stderr, "couldn't create postscript file\n" );
    else
    { int i;

      if (for_printing)
        fprintf( win->ps_file, "%%!PS-Adobe-2.0\n" );
      else
        fprintf( win->ps_file, "%%!PS-Adobe-2.0 EPSF-2.0\n" );
      fprintf( win->ps_file, "%%%%Title: %s\n", name );
      fprintf( win->ps_file, "%%%%Creator: xactlog\n" );
      if (for_printing)
        fprintf( win->ps_file, "%%%%Orientation: Landscape\n" );
      fprintf( win->ps_file, "%%%%BoundingBox: 0 0 %1.6f %1.6f\n", zoom*win->w, zoom*win->h );
      fprintf( win->ps_file, "%%%%EndComments\n" );
      fprintf( win->ps_file, "/$XACTLOGDict 32 dict def $XACTLOGDict begin\n" );
      if (!for_printing) fprintf( win->ps_file, "%%" );
      fprintf( win->ps_file, "/$XACTLOGEnd {showpage end} def %%%% [ 0 -1 1 0 0 0 ] concat -750 17 translate 0.72 0.72 scale\n" );
      fprintf( win->ps_file, "100 45 currenthalftone\n" );
      fprintf( win->ps_file, "%1.6f %1.6f scale\n", zoom, zoom );
      if (for_printing) fprintf( win->ps_file, "%%" );
      fprintf( win->ps_file, "/$XACTLOGEnd {$XACTLOGState restore end} def /$XACTLOGState save def\n" );
      fprintf( win->ps_file, "/$XACTLOGColorR [ " );
      for (i=0; i<win->nbcolors+OTHER; i++)
        fprintf( win->ps_file, "%1.2f ", RED(win_get_color(win, i))/255.0 );
      fprintf( win->ps_file, "] def\n" );
      fprintf( win->ps_file, "/$XACTLOGColorG [ " );
      for (i=0; i<win->nbcolors+OTHER; i++)
        fprintf( win->ps_file, "%1.2f ", GREEN(win_get_color(win, i))/255.0 );
      fprintf( win->ps_file, "] def\n" );
      fprintf( win->ps_file, "/$XACTLOGColorB [ " );
      for (i=0; i<win->nbcolors+OTHER; i++)
        fprintf( win->ps_file, "%1.2f ", BLUE(win_get_color(win, i))/255.0 );
      fprintf( win->ps_file, "] def\n" );
      fprintf( win->ps_file, "/$XACTLOGColorK [ " );
      for (i=0; i<win->nbcolors+OTHER; i++)
        {
          RGB rgb = win_get_color(win, i);
          fprintf( win->ps_file, "%1.2f ", (RED(rgb)+GREEN(rgb)+BLUE(rgb))/(3*255.0) );
        }
      fprintf( win->ps_file, "] def\n" );
      if (graph_black_and_white) fprintf( win->ps_file, "%%" );
      fprintf( win->ps_file, "/$XACTLOGSetcolor {" );
      fprintf( win->ps_file, "dup $XACTLOGColorR exch get exch " );
      fprintf( win->ps_file, "dup $XACTLOGColorG exch get exch " );
      fprintf( win->ps_file, "    $XACTLOGColorB exch get      setrgbcolor} def\n" );
      if (!graph_black_and_white) fprintf( win->ps_file, "%%" );
      fprintf( win->ps_file, "/$XACTLOGSetcolor {$XACTLOGColorK exch get setgray} def\n" );
      fprintf( win->ps_file, "/$XACTLOGBox {$XACTLOGSetcolor 0.75 add moveto dup 0 exch rlineto exch 0 rlineto neg 0 exch rlineto closepath fill} def\n" );
      fprintf( win->ps_file, "/$XACTLOGLeft {$XACTLOGSetcolor 2.25 sub moveto show} def\n" );
      fprintf( win->ps_file, "/$XACTLOGRight {$XACTLOGSetcolor 2.25 sub moveto dup stringwidth pop neg 0 rmoveto show} def\n" );
      fprintf( win->ps_file, "/$XACTLOGCenter {$XACTLOGSetcolor 2.25 sub moveto dup stringwidth pop 2 div neg 0 rmoveto show} def\n" );
      fprintf( win->ps_file, "/Courier findfont 9 scalefont setfont\n" );
      fprintf( win->ps_file, "%%%%EndProlog\n" );
    }
  }
}


void graph_postscript_end( win )
window win;
{ if (win->ps_file != NULL)
  { fprintf( win->ps_file, "$XACTLOGEnd\n" );
    fclose( win->ps_file );
    win->ps_file = NULL;
  }
}


void graph_init()
{ if (graph_display) g_init();
}


void graph_box( win, color, x, y, w, h )
window win;
int color;
int x, y, w, h;
{ if ((w > 0) && (h > 0)) {
    if (win->ps_file == NULL) {
      if (graph_display) g_box( win, color, x, y, w, h );
    } else if (color != INVERT) {
      fprintf( win->ps_file, "%d %d %d %d %d $XACTLOGBox\n", w, h, x, y, color );
    }
  }
}


void graph_text( win, color, where, x, y, str )
window win;
int color;
int where;
int x, y;
char *str;
{ if (win->ps_file == NULL)
  { if (graph_display) g_text( win, color, where, x, y, str ); }
  else
  { fprintf( win->ps_file, "(%s) %d %d %d ", str, x, y, color );
    switch (where)
    { case CENTER: fprintf( win->ps_file, "$XACTLOGCenter\n" ); break;
      case LEFT:   fprintf( win->ps_file, "$XACTLOGLeft\n" );   break;
      case RIGHT:  fprintf( win->ps_file, "$XACTLOGRight\n" );  break;
    }
  }
}


void graph_clear( win )
window win;
{ if ((win->ps_file == NULL) && (graph_display)) g_clear( win );
}


window graph_window( name, width, height, colors, nbcolors, redraw, point, click, key, resize )
char *name;
int width, height;
RGB *colors;
int nbcolors;
void (*redraw)();
void (*point)();
void (*click)();
int (*key)();
void (*resize)();
{
  if (graph_display)
    return g_window( name, width, height, colors, nbcolors, redraw, point, click, key, resize );
  else
  { window win;
    win = (window)malloc( sizeof(*win) );
    if (win == NULL)
    { fprintf( stderr, "can't allocate window\n" );
      exit (1);
    }
    win->name    = name;
    win->w       = width;
    win->h       = height;
    win->ps_file = NULL;
    win->colors  = colors;
    win->nbcolors= nbcolors;
    win->redraw  = redraw;
    win->point   = point;
    win->click   = click;
    win->key     = key;
    win->resize  = resize;
    return win;
  }
}


void graph_resize( win, w, h )
window win;
int w, h;
{ win->w = w;
  win->h = h;
  if (graph_display) g_resize( win );
}


void graph_idle( win )
window win;
{ if (graph_display) g_idle( win );
}


/*--------------------------------------------------------------------------*/

/* event log stuff */

#define INT32 int
#define ULONG unsigned long
#define MAX_NB_TRACES 128
#define MAX_NB_EVENT_TYPES 256

struct transition { U16 state; U64 time; };


int two_states_only = 0;
int time_unit = 0;
char *time_unit_name;
int time_unit_scale;
long compression_scale = 0;

char *log_filename;

char *log_event_name[MAX_NB_EVENT_TYPES];
RGB log_event_color[MAX_NB_EVENT_TYPES];

struct {
  unsigned int len;
  struct transition *event;
  } log_trace[MAX_NB_TRACES];

struct {
  unsigned int len;
  U64 *dur;
  } events_of_type[MAX_NB_EVENT_TYPES];

int log_nb_events;
U32 log_nb_traces;
int total_nb_events;

U64 log_min_time;
U64 log_max_time;

U64 log_frequency;

void read_log_file (filename, f)
char *filename;
FILE *f;
{
  int i, j, t;
  U32 nb_states;
  U32 nb_transitions;
  RGB color;
  struct transition *p;
  U16 last_state;
  U64 last_tim;

  total_nb_events = 0;
  log_min_time = U64_init (~0, ~0);
  log_max_time = U64_init (0, 0);

  if (!read_U64 (f, &log_frequency))
    goto err;

  if (!read_U32 (f, &nb_states))
    goto err;

  for (i=0; i<nb_states; i++)
    {
      if (!read_U32 (f, &log_event_color[i]) ||
          !read_string (f, &log_event_name[i]))
        goto err;
    }

  if (nb_states > 1 && two_states_only)
    nb_states = 2;

  log_nb_events = nb_states;

  if (!read_U32 (f, &log_nb_traces))
    goto err;

  if (debug_level > 1)
    fprintf (stderr, "Activity log has %d traces\n", log_nb_traces);

  for (t=0; t<log_nb_traces; t++)
    {
      if (!read_U32 (f, &nb_transitions))
        goto err;

      if (debug_level > 1)
        fprintf (stderr, "Trace %d activity (%d transitions)\n", t, nb_transitions);

      p = malloc (nb_transitions * sizeof(struct transition));
      if (p == NULL)
        {
          fprintf (stderr, "memory overflow\n");
          exit (1);
        }

      if (debug_level > 1)
        fprintf (stderr, "State transitions in \"%s\"\n", filename);

      last_state = 0xffff;
      last_tim = U64_init (0, 0);
      j = 0;
      for (i=0; i<nb_transitions; i++)
        {
          U16 state;
          U64 tim;
          if (!read_U16 (f, &state))
            goto err;
          if (!read_U64 (f, &tim))
            goto err;
          if (debug_level > 1)
#ifdef USE_ULONGLONG
            fprintf (stderr, " %4d: time = %llu state = %u\n", i, tim, state);
#else
            fprintf (stderr, " %4d: time = %u state = %u\n", i, U64_to_U32(tim), state);
#endif
          if (U64_less_than_U64 (tim, log_min_time))
            log_min_time = tim;
          if (U64_less_than_U64 (log_max_time, tim))
            log_max_time = tim;
          if (U64_less_than_U64 (tim, last_tim))
            {
              fprintf (stderr, "inconsistent log (time regression)\n");
              exit (1);
            }
          /*
            else if (!U64_less_than_U64 (last_tim, tim))
            fprintf (stderr, "warning: null duration state\n");
          */
          if (state != 0xffff)
            {
              if (state > 0 && two_states_only)
                state = 1;
              if (state == last_state)
                {
                  if (debug_level > 0)
                    fprintf (stderr, "warning: ignoring repeated state\n");
                }
              else
                {
                  p[j].state = state;
                  p[j].time = tim;
                  last_state = state;
                  last_tim = tim;
                  j++;
                }
            }
        }

      if (debug_level > 1)
        fprintf (stderr,
                 " min time = %d  max time = %d\n",
                 U64_to_U32(log_min_time),
                 U64_to_U32(log_max_time));

      log_trace[t].len = j;
      log_trace[t].event = p;

      total_nb_events += log_trace[t].len;
    }

  return;

err:

  fprintf (stderr, "premature end of file while reading log file\n");
  exit (1);
}


void read_log(name)
char *name;
{
  FILE *f = fopen (name, "rb");

  if (f == NULL)
    {
      fprintf (stderr, "can't open file \"%s\"\n", name);
      exit (1);
    }

  read_log_file (name, f);

  fclose (f);

  {
    int i;
    for (i=0; i<log_nb_events; i++)
    {
      U64 *p1;
      p1 = malloc (total_nb_events * sizeof(U64));
      if (p1 == NULL)
        {
          fprintf( stderr, "memory overflow\n" );
          exit (1);
        }
      events_of_type[i].dur = p1;
    }
  }

  if (!U64_less_than_U64 (log_min_time, log_max_time))
    {
      fprintf( stderr, "log is empty\n" );
      exit (1);
    }

  time_unit_name = "sec";

  if (time_unit == 3)
    time_unit_name = "ms";
  else if (time_unit == 6)
    time_unit_name = "us";
  else if (time_unit == 9)
    time_unit_name = "ns";

  time_unit_scale = (9-time_unit)-compression_scale;

  { int i, j;
    U32 mult = 1;
    U64 div = log_frequency;
    for (i=compression_scale; i<9; i++) /* 1e9 nanoseconds per second */
    {
      if (U64_less_than_U32 (div, 1000000))
        mult = mult * 10;
      else
        div = U64_div_U32(div, 10);
    }
    for (i=0; i<log_nb_traces; i++)
      for (j=log_trace[i].len-1; j>=0; j--)
      {
        log_trace[i].event[j].time =
          U64_div_U64 (U64_mul_U32 (U64_sub_U64 (log_trace[i].event[j].time,
                                                 log_min_time),
                                    mult),
                       div);
      }
    log_max_time = U64_div_U64 (U64_mul_U32 (U64_sub_U64 (log_max_time,
                                                          log_min_time),
                                             mult),
                                div);
  }
}


/*--------------------------------------------------------------------------*/

/* plot stuff */

#ifdef MAC
#define DEFAULT_PLOT_HEIGHT 128
#else
#define DEFAULT_PLOT_HEIGHT 320
#endif
#define MAX_PLOT_WIDTH      1200
#define MIN_PLOT_WIDTH      50
#define BORDER_LEFT         30
#define BORDER_RIGHT        30
#define DEFAULT_HIST_HEIGHT 64

#define LABEL_BORDER   5
#define LABEL_HEIGHT   17
#define HIST_BORDER    40
#define HIST_CENTER    5
#define HIST_LEFT      BORDER_LEFT
#define HIST_RIGHT     BORDER_RIGHT
#define PERC_BORDER    25
#define PERC_HEIGHT    11
#define PLOT_BORDER    25
#define BAR_BORDER     9
#define BAR_HEIGHT     bar_height
#define BAR_SPACING    bar_spacing
#define TITLE_HEIGHT   10
#define TITLE_BORDER   10

#define LABEL_THEIGHT  ((show_labels) ? LABEL_BORDER+LABEL_HEIGHT : 0)
#define HIST_THEIGHT   ((show_hist) ? HIST_BORDER+hist_height : 0)
#define HIST_WIDTH     ((full_plot_width+HIST_LEFT+HIST_RIGHT)/nb_labels() - (HIST_LEFT+HIST_RIGHT))
#define PERC_THEIGHT   ((show_perc) ? PERC_BORDER+PERC_HEIGHT : 0)
#define PLOT_THEIGHT   ((show_activ) ? PLOT_BORDER+plot_height : 0)
#define TRACES_THEIGHT ((show_states) ? BAR_BORDER+log_nb_traces*(BAR_HEIGHT+BAR_SPACING) : 0)
#define TITLE_THEIGHT  ((show_title) ? (TITLE_BORDER+TITLE_HEIGHT) : 0)
#define THEIGHT LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT+PLOT_THEIGHT+TRACES_THEIGHT+TITLE_THEIGHT

#define TICK_TEXT_OFFS 13
#define TICK_SHORT     2
#define TICK_MEDIUM    5
#define TICK_LONG      8


ULONG full_plot_width, plot_width, plot_height;
ULONG hist_height, hist_span_at_width;
int show_title = 1;
int show_states = 1;
int show_activ = 1;
int show_perc = 1;
int show_hist = 1;
int show_labels = 1;
int first_state_only = 0;
int print_statistics = 0;
int smooth_passes;
int bar_height, bar_spacing;
double postscript_zoom = 1.0;

U64 min_time, max_time, duration;
U64 *count[MAX_NB_EVENT_TYPES];
ULONG perc_width[MAX_NB_EVENT_TYPES];
ULONG *hist[MAX_NB_EVENT_TYPES];
ULONG hist_nb_bars[MAX_NB_EVENT_TYPES];
U64 hist_span[MAX_NB_EVENT_TYPES];
U64 hist_sum[MAX_NB_EVENT_TYPES];
ULONG hist_max_bar[MAX_NB_EVENT_TYPES];
int xlate[MAX_NB_EVENT_TYPES];


void num_to_str (str, val, scale, precision)
char *str;
U64 val;
int scale;
int precision;
{
  char buf[100];
  int i;
  int n = 0;

  do
    {
      buf[n++] = '0' + U64_mod_U32 (val, 10);
      if (n == scale)
        buf[n++] = '.';
      val = U64_div_U32 (val, 10);
    } while (n < scale || !U64_less_than_U32 (val, 1));

  if (precision < 0)
    {
      i = 0;
      while (buf[i] == '0')
        i++;
    }
  else
    i = scale-precision;

  if (i == scale)
    i = scale+1;

  if (n == i)
    *str++ = '0';
  else
    while (n > i)
      *str++ = buf[--n];
  *str++ = '\0';
}


void for_each_event_of_trace( i, proc )
int i;
void (*proc)();
{ int j;
  int last_event_num = log_trace[i].event[0].state;
  U64 last_event_time = U64_init (0, 0);
  for (j=0; j<log_trace[i].len; j++)
  { int event_num = log_trace[i].event[j].state;
    U64 event_time = log_trace[i].event[j].time;
    (*proc)( last_event_num, last_event_time, event_time );
    last_event_num = event_num;
    last_event_time = event_time;
  }
  (*proc)( last_event_num, last_event_time, log_max_time );
}


int nb_labels()
{ int i, n = 0;
  for (i=0; i<log_nb_events; i++)
  { int event_num = xlate[i];
    if (events_of_type[event_num].len != 0) n++;
  }
  if (first_state_only && (n>1))
    n = 1;
  return n;
}


void for_each_event( proc )
void (*proc)();
{ int i;
  for (i=0; i<log_nb_traces; i++)
    for_each_event_of_trace( i, proc );
}


void qs( a, n )
U64 a[];
int n;
{
  U64 *lpos, *rpos;
  U64 pivot;
  if (n <= 2)
    {
      if ((n == 2) && U64_less_than_U64 (a[1], a[0]))
        { U64 tmp = a[0]; a[0] = a[1]; a[1] = tmp; }
      return;
    }
  pivot = a[n/2];
  lpos = a;
  rpos = a+(n-1);
  while (1)
    {
      while (U64_less_than_U64 (*lpos, pivot)) lpos++;
      while (U64_less_than_U64 (pivot, *rpos)) rpos--;
      if (lpos >= rpos) break;
      { U64 tmp = *lpos; *lpos = *rpos; *rpos = tmp; }
      lpos++;
      rpos--;
    }
  qs (a, lpos-a);
  qs (lpos, n-(lpos-a));
}


void smooth (p, n, passes)
U64 *p;
int n;
int passes;
{
  while (passes-- > 0)
    {
      int i;
      U64 prev;
      U64 *q = p;
      U64 temp = *q;
      *q = U64_add_U32 (U64_add_U64 (U64_mul_U32 (*q, 3),
                                     q[1]),
                        2);
      U64_shift_right (q, 2);
      q++;
      for (i=1; i<n-1; i++)
        {
          prev = temp;
          temp = *q;
          *q = U64_add_U32 (U64_add_U64 (U64_add_U64 (U64_mul_U32 (*q, 2),
                                                      prev),
                                         q[1]),
                            2);
          U64_shift_right (q, 2);
          q++;
        }
      *q = U64_add_U32 (U64_add_U64 (U64_mul_U32 (*q, 3),
                                     prev),
                        2);
      U64_shift_right (q, 2);
    }
}


void histogram( a, n, b, m, range_top, peak, max_bar )
U64 a[];
int n;
ULONG b[];
int m;
U64 range_top;
ULONG peak;
ULONG *max_bar;
{ int i;
  ULONG last, max_val;
  last = 0;
  for (i=0; i<m; i++)
  { int cur = last;
    while ((cur < n) &&
           U64_less_than_U64 (U64_mul_U32 (a[cur], m),
                              U64_mul_U32 (range_top, i+1)))
      cur++;
    b[i] = cur-last;
    last = cur;
  }
  max_val = 0;
  for (i=0; i<m; i++)
    if (b[i] > max_val) max_val = b[i];
  if (max_val > 0)
    for (i=0; i<m; i++) b[i] = b[i]*peak/max_val;
  *max_bar = max_val;
}


int prev_event_num;


void add_event1( event_num, start, end )
int event_num;
U64 start, end;
{
  int i;
  U64 tim;

  if (!U64_less_than_U64 (start, max_time) ||
      !U64_less_than_U64 (min_time, end))
    return;

  if (U64_less_than_U64 (start, min_time))
    start = min_time;

  if (U64_less_than_U64 (max_time, end))
    end = max_time;

  tim = U64_sub_U64 (end, start);

  if (event_num == prev_event_num)
    {
      U64 *p = &events_of_type[event_num].dur[events_of_type[event_num].len-1];
      *p = U64_add_U64 (*p, tim);
    }
  else
    events_of_type[event_num].dur[events_of_type[event_num].len++] = tim;
}


void compute_hist()
{ int i, j;
  prev_event_num = -1;
  for (i=0; i<log_nb_events; i++)
    events_of_type[i].len = 0;
  for_each_event( add_event1 );
  for (i=0; i<log_nb_events; i++)
  { int nb_bars;
    U64 span;
    U64 sum = U64_init (0, 0);
    ULONG max_bar = 0;
    ULONG hw;
    if (events_of_type[i].len > 0)
    {
      for (j=0; j<events_of_type[i].len; j++)
        sum = U64_add_U64 (sum, events_of_type[i].dur[j]);
      qs (events_of_type[i].dur, events_of_type[i].len);
      span = U64_add_U32 (events_of_type[i].dur[events_of_type[i].len-1], 1);
      hw = (hist_span_at_width > 0)
           ? U64_to_U32 (U64_div_U32 (U64_mul_U32 (span, HIST_WIDTH), hist_span_at_width))
           : HIST_WIDTH;
      if (MAX_PLOT_WIDTH < hw) hw = MAX_PLOT_WIDTH;
      nb_bars = hw;
      if (U64_less_than_U32 (span, nb_bars)) nb_bars = U64_to_U32 (span);
      histogram (events_of_type[i].dur, events_of_type[i].len,
                 hist[i], nb_bars, span, hist_height, &max_bar);
      hist_nb_bars[i] = nb_bars;
      hist_span[i] = span;
      hist_sum[i] = sum;
      hist_max_bar[i] = max_bar;
    }
  }
}


void add_event2( event_num, start, end )
int event_num;
U64 start, end;
{
  U64 ss, ee;
  U32 s, e;
  int i;
  U64 *p;
  if (!U64_less_than_U64 (start, max_time) ||
      !U64_less_than_U64 (min_time, end))
    return;

  if (U64_less_than_U64 (start, min_time))
    start = min_time;

  if (U64_less_than_U64 (max_time, end))
    end = max_time;

  ss = U64_mul_U32 (U64_sub_U64 (start, min_time), plot_width);
  ee = U64_mul_U32 (U64_sub_U64 (end, min_time), plot_width);
  s = U64_to_U32 (U64_div_U64 (ss, duration));
  e = U64_to_U32 (U64_div_U64 (ee, duration));

  p = &count[event_num][s];
  *p = U64_sub_U64 (*p, U64_sub_U64 (ss, U64_mul_U32 (duration, s)));
  for (i=s; i<e; i++)
    {
      *p = U64_add_U64 (*p, duration);
      p++;
    }
  *p = U64_add_U64 (*p, U64_sub_U64 (ee, U64_mul_U32 (duration, e)));
}


void compute_plot (min_t, max_t)
U64 min_t, max_t;
{ int i, j;

  if (U64_less_than_U64 (log_max_time, min_t))
    min_t = log_max_time;

  if (U64_less_than_U64 (log_max_time, max_t))
    max_t = log_max_time;

  min_time = min_t;
  max_time = max_t;

  duration = U64_sub_U64 (max_time, min_time);

  if (debug_level > 1)
#ifdef USE_ULONGLONG
    fprintf (stderr, "duration = %llu\n", duration);
#else
    fprintf (stderr, "duration = %llu\n", U64_to_U32(duration));
#endif

  for (i=0; i<full_plot_width; i++)
    for (j=0; j<log_nb_events; j++)
      count[j][i] = U64_init (0, 0);

  for_each_event( add_event2 );

  if (debug_level > 1)
    for (i=0; i<full_plot_width; i++)
      {
        fprintf (stderr, "i=%d ", i);
        for (j=0; j<log_nb_events; j++)
          fprintf (stderr, "%d ", U64_to_U32(count[j][i]));
        fprintf (stderr, "\n");
      }

  for (j=0; j<log_nb_events; j++)
    smooth (count[j], plot_width, smooth_passes);

  for (i=0; i<plot_width; i++)
    {
      U64 h1 = U64_init (0, 0);
      U64 h2 = U64_init (0, 0);
      U64 tot_dur = U64_init (0, 0);
      U64 k;
      for (j=0; j<log_nb_events; j++)
        tot_dur = U64_add_U64 (tot_dur, count[j][i]);
      for (j=0; j<log_nb_events-1; j++)
        {
          h1 = U64_add_U64 (h1, count[j][i]);
          k = U64_div_U64 (U64_mul_U32 (h1, plot_height), tot_dur);
          count[j][i] = U64_sub_U64 (k, h2);
          h2 = k;
        }
      count[j][i] = U64_sub_U64 (U64_init (0, plot_height), h2);
    }

  { U32 tot = 0;
    for (j=0; j<log_nb_events-1; j++)
    { U32 sum = 0;
      for (i=0; i<plot_width; i++)
        sum += U64_to_U32 (count[j][i]);
      sum = sum*full_plot_width/((long)plot_width*plot_height);
      perc_width[j] = sum;
      tot += sum;
    }
    perc_width[j] = full_plot_width-tot;
  }
}


void flip_cross_hair( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT;
  int t = b+PLOT_THEIGHT+TRACES_THEIGHT;
  if ((last_point_x >= BORDER_LEFT) && (last_point_x <= BORDER_LEFT+plot_width+10) &&
      (last_point_y >= b) && (last_point_y <= t))
  { graph_box( win, INVERT, last_point_x, b, 1, t-b+1 );
    graph_box( win, INVERT, BORDER_LEFT-1, last_point_y, plot_width+10, 1 );
  }
}


void draw_scale (win, x, y, lo, hi, width, height)
window win;
int x, y;
U64 lo, hi;
int width, height;
{
  int j, k, n;
  long ticks_per_label;
  U64 ilo, ihi;
  U64 span = U64_sub_U64 (hi, lo);
  U64 incr;
  U64 tick_val;
  int precision;
  int max_ticks = width/2;
  int int_digits = -time_unit_scale;
  U64 temp = hi;

  while (!U64_less_than_U32 (temp, 1))
    {
      temp = U64_div_U32 (temp, 10);
      int_digits++;
    }

  if (int_digits < 0)
    int_digits = 0;

  precision = time_unit_scale;

  incr = U64_init (0, 1);
  temp = span;
  while (!U64_less_than_U32 (temp, max_ticks))
    {
      incr = U64_mul_U32 (incr, 10);
      temp = U64_div_U32 (temp, 10);
      if (precision > 0)
        precision--;
    }

  ilo = U64_div_U64 (U64_add_U64 (lo, U64_sub_U32(incr, 1)), incr);
  ihi = U64_div_U64 (U64_add_U64 (hi, U64_sub_U32(incr, 1)), incr);
  n = U64_to_U32 (U64_sub_U64 (ihi, ilo));

  j = 0;
  ticks_per_label = 1;
  while (width*ticks_per_label < 6*(int_digits+precision+(precision>0)+1)*n)
    {
      if (j % 3 == 1)
        ticks_per_label = ticks_per_label / 2 * 5;
      else
        ticks_per_label = ticks_per_label * 2;
      if (j % 3 == 2)
        if (precision > 0)
          precision--;
      j++;
    }

  tick_val = U64_mul_U64 (incr, ilo);
  while (!U64_less_than_U64 (hi, tick_val))
    {
      U32 o = U64_to_U32 (U64_div_U64 (U64_mul_U32 (U64_sub_U64 (tick_val, lo), width),
                                       span));
      int k = x + o;
      if (U64_mod_U32 (ilo, ticks_per_label) == 0) /* label the tick? */
        {
          char str[100];
          num_to_str (str,
                      tick_val,
                      time_unit_scale,
                      precision);
          graph_text( win, BLACK, CENTER, k, y-TICK_TEXT_OFFS, str );
        }
      if (U64_mod_U32 (ilo, 5) == 0)
        {
          int offs = (U64_mod_U32 (ilo, 2) == 0) ? 3 : 4;
          int len  = (U64_mod_U32 (ilo, 2) == 0) ? 3 : 1;
          if (U64_mod_U32 (ilo, 2) == 0)
            graph_box( win, BLACK, k, y-TICK_LONG-1, 1, TICK_LONG );
          else
            graph_box( win, BLACK, k, y-TICK_MEDIUM-1, 1, TICK_MEDIUM );
          for (j=0; j<height; j+=8)
            graph_box( win, BLACK, k, y+j+offs, 1, len );
        }
      else
        graph_box( win, BLACK, k, y-TICK_SHORT-1, 1, TICK_SHORT );
      tick_val = U64_add_U32 (tick_val, incr);
      ilo = U64_add_U32 (ilo, 1);
    }
}


void draw_title( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT+PLOT_THEIGHT+TRACES_THEIGHT;
  char title[256];
  if (!show_title) return;
  sprintf( title, "%s  p = %d", log_filename, log_nb_traces );
  graph_text( win, BLACK, LEFT, BORDER_LEFT, b+TITLE_BORDER, title );
}


void draw_cross_hair_info( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT;
  int t = b+PLOT_THEIGHT+TRACES_THEIGHT;
  graph_box( win, WHITE, BORDER_LEFT, t, plot_width, TITLE_THEIGHT );
  draw_title( win );
  if ((last_point_x >= BORDER_LEFT) && (last_point_x <= BORDER_LEFT+plot_width) &&
      (last_point_y >= b) && (last_point_y <= t))
  { char format[100];
    char info[100];
    U64 ticks = U64_add_U64 (min_time,
                             U64_div_U32 (U64_mul_U32 (duration,
                                                       last_point_x-BORDER_LEFT),
                                          plot_width));
    int trace_y = last_point_y - (b+PLOT_THEIGHT+BAR_BORDER);

    if ((trace_y >= 0) && (trace_y % (BAR_HEIGHT+BAR_SPACING) >= BAR_SPACING))
    { char str1[100];
      char str2[100];
      char str3[100];
      char str4[100];
      int i = trace_y / (BAR_HEIGHT+BAR_SPACING);
      int j, event_num;
      U64 event_time;
      int last_event_num = log_trace[i].event[0].state;
      U64 last_event_time = U64_init (0, 0);
      for (j=0; j<log_trace[i].len; j++)
      { event_num = log_trace[i].event[j].state;
        event_time = log_trace[i].event[j].time;
        if (U64_less_than_U64 (ticks, event_time)) goto found;
        last_event_num = event_num;
        last_event_time = event_time;
      }
      event_time = log_max_time;
      found:

      num_to_str (str1, U64_sub_U64 (event_time, last_event_time), time_unit_scale, time_unit_scale);
      num_to_str (str2, last_event_time, time_unit_scale, time_unit_scale);
      num_to_str (str3, event_time, time_unit_scale, time_unit_scale);
      num_to_str (str4, ticks, time_unit_scale, time_unit_scale);
      sprintf (info,
               "P%d: %s %s %s (%s .. %s)  [%s]",
               i,
               log_event_name[last_event_num],
               str1,
               time_unit_name,
               str2,
               str3,
               str4);
    }
    else
    {
      char str[100];
      num_to_str (str, ticks, time_unit_scale, time_unit_scale);
      sprintf (info, "[%s]", str);
    }
    graph_text( win, BLACK, RIGHT, BORDER_LEFT+plot_width, t+TITLE_BORDER, info );
  }
}


void draw_labels( win )
window win;
{ int b = 0;
  int i, j, n;

  n = nb_labels();

  j = 0;
  for (i=0; i<log_nb_events; i++)
  { int event_num = xlate[i];
    if (events_of_type[event_num].len != 0)
    { int x_pos = HIST_LEFT+((full_plot_width+HIST_LEFT+HIST_RIGHT)*j)/n;
      graph_box( win, OTHER+event_num, x_pos, b, LABEL_HEIGHT, LABEL_HEIGHT );
      graph_box( win, BLACK, x_pos, b, 1, LABEL_HEIGHT );
      graph_box( win, BLACK, x_pos, b, LABEL_HEIGHT, 1 );
      graph_box( win, BLACK, x_pos+LABEL_HEIGHT-1, b, 1, LABEL_HEIGHT );
      graph_box( win, BLACK, x_pos, LABEL_HEIGHT-1, b+LABEL_HEIGHT, 1 );
      graph_text( win, BLACK, LEFT, x_pos+LABEL_HEIGHT+4, b+LABEL_HEIGHT/2, log_event_name[event_num] );
      j++;
      if (j >= n) break;
    }
  }
}


void draw_hist( win )
window win;
{ int b = LABEL_THEIGHT+HIST_BORDER-HIST_CENTER;
  int i, j, k, n;

  n = nb_labels();

  j = 0;
  for (i=0; i<log_nb_events; i++)
  { int event_num = xlate[i];
    if (events_of_type[event_num].len != 0)
      {
        U64 span = hist_span[event_num];
        ULONG hw0 = (hist_span_at_width > 0)
                    ? U64_to_U32 (U64_div_U32 (U64_mul_U32 (span, HIST_WIDTH), hist_span_at_width))
                    : HIST_WIDTH;
        ULONG hw = (MAX_PLOT_WIDTH < hw0) ? MAX_PLOT_WIDTH : hw0;
        int x_pos = HIST_LEFT+((full_plot_width+HIST_LEFT+HIST_RIGHT)*j)/n;
        U64 avg100 = U64_div_U32 (U64_mul_U32 (hist_sum[event_num], 100),
                                  events_of_type[event_num].len);
        U32 w = U64_to_U32 (U64_div_U64 (U64_init (0, hw), span));
        U32 a = U64_to_U32 (U64_div_U64 (U64_mul_U32 (avg100, hw-w),
                                         U64_mul_U32 (U64_sub_U32 (span, 1),
                                                      100)));
        int peak = hist_max_bar[event_num] * 100 / events_of_type[event_num].len;
        int nb_bars = hist_nb_bars[event_num];
        int l;
        char avg_str[100];
        char str[100];

        draw_scale (win, x_pos+w/2, b, U64_init (0, 0), U64_sub_U32 (span, 1), hw-w, 0);
        for (k=0; k<nb_bars; k++)
          {
            int xs = x_pos+k*hw/nb_bars;
            int xe = x_pos+(k+1)*hw/nb_bars;
            graph_box( win, GRAY, xs, b, xe-xs, hist[event_num][k] );
          }
        for (l= -22; l<0; l += 3)
          graph_box( win, BLACK, x_pos+w/2+a, b+l, 1, 1 );
        num_to_str (avg_str, avg100, time_unit_scale+2, -1);
        graph_box( win, BLACK, x_pos-1, b-1, 1, hist_height+1 );
        graph_box( win, BLACK, x_pos, b-1, hw, 1 );
        graph_text( win, BLACK, CENTER, x_pos+w/2+a, b-15-TICK_TEXT_OFFS, avg_str );
        sprintf( str, "%d%%", peak );
        graph_box( win, BLACK, x_pos-3, b+hist_height, 3, 1 );
        graph_text( win, BLACK, RIGHT, x_pos-5, b+hist_height, str );
        if (print_statistics)
          {
            char max_str[100];
            num_to_str (max_str, U64_sub_U32 (span, 1), time_unit_scale, -1);
            printf ("state=%d average=%s maximum=%s\n",
                    event_num,
                    avg_str,
                    max_str);
          }
        j++;
        if (j >= n) break;
      }
  }

/*
  graph_text( win, BLACK, LEFT, BORDER_LEFT + plot_width + 36, b-TICK_TEXT_OFFS, time_unit_name );
*/
}


void draw_perc_plot_frame( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_BORDER-1;
  int i;

  graph_box( win, BLACK, BORDER_LEFT-1, b-1, full_plot_width+2, 1 );
  graph_box( win, BLACK, BORDER_LEFT-1, b-1, 1, PERC_HEIGHT+2 );
  graph_box( win, BLACK, BORDER_LEFT+full_plot_width, b-1, 1, PERC_HEIGHT+2 );
  graph_box( win, BLACK, BORDER_LEFT-1, b+PERC_HEIGHT, full_plot_width+2, 1 );

  for (i=0; i<=100; i++)
  { int k = BORDER_LEFT + ((long)full_plot_width)*i/100;
    if (i % 10 == 0) /* time stamp every 10 tick marks */
    { char num[10];
      sprintf( num, "%d", i );
      graph_text( win, BLACK, CENTER, k, b-TICK_TEXT_OFFS, num );
    }
    if (i % 10 == 0)
      graph_box( win, BLACK, k, b-TICK_LONG-1, 1, TICK_LONG );
    else if (i % 5 == 0)
      graph_box( win, BLACK, k, b-TICK_MEDIUM-1, 1, TICK_MEDIUM );
    else
      graph_box( win, BLACK, k, b-TICK_SHORT-1, 1, TICK_SHORT );
  }

  graph_text( win, BLACK, LEFT, BORDER_LEFT + full_plot_width + 20, b-TICK_TEXT_OFFS, "%" );
}


void draw_perc_plot_content( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_BORDER-1;
  int i, j = 0;
  for (i=0; i<log_nb_events; i++)
  { int event_num = xlate[i];
    int k = perc_width[event_num];
    graph_box( win, OTHER+event_num, BORDER_LEFT+j, b, k, PERC_HEIGHT );
    j += k;
    if (print_statistics)
      printf ("state=%d percent=%d\n", event_num, (int)(k*100/full_plot_width));
  }
}


void draw_perc_plot( win )
window win;
{ draw_perc_plot_content( win );
  draw_perc_plot_frame( win );
}


void draw_activ_plot_frame( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT+PLOT_BORDER-1;
  int i, j;

  graph_box( win, BLACK, BORDER_LEFT-1, b-1, plot_width+2, 1 );
  graph_box( win, BLACK, BORDER_LEFT-1, b-1, 1, plot_height+2 );
  graph_box( win, BLACK, BORDER_LEFT+plot_width, b-1, 1, plot_height+2 );
  graph_box( win, BLACK, BORDER_LEFT-1, b+plot_height, plot_width+2, 1 );

  for (i=0; i<=10; i++)
  { int k = b+plot_height*i/10;
    int offs = (i % 2 == 0) ? 3 : 4;
    int len  = (i % 2 == 0) ? 3 : 1;
    graph_box( win, BLACK, BORDER_LEFT+plot_width, k, 5, 1 );
    if (i % 2 == 0)
    { char num[10];
      sprintf( num, "%d", i*10 );
      graph_text( win, BLACK, LEFT, BORDER_LEFT+plot_width+8, k, num );
    }
    if ((i>0) && (i<10))
      for (j=0; j<plot_width; j+=8)
        graph_box( win, BLACK, BORDER_LEFT+j+offs, k, len, 1 );
  }
  graph_text( win, BLACK, LEFT, BORDER_LEFT+plot_width+20, b+plot_height/2, "%" );

  draw_scale (win, BORDER_LEFT, b, min_time, max_time, plot_width, plot_height);

/*
  graph_text( win, BLACK, LEFT, BORDER_LEFT + plot_width + 36, b-TICK_TEXT_OFFS, time_unit_name );
*/
}


void draw_activ_plot_between( win, start, end, level, bot )
window win;
int start, end, level, bot;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT+PLOT_BORDER-1;
  if (level < log_nb_events)
  { int event_num = xlate[level];
    int i = start;
    while (i <= end)
    { U32 h = U64_to_U32 (count[event_num][i]);
      int j = i+1;
      while ((j <= end) && (U64_to_U32 (count[event_num][j]) == h)) j++;
      graph_box( win, OTHER+event_num, BORDER_LEFT+i, b+bot, j-i, h );
      draw_activ_plot_between( win, i, j-1, level+1, bot+h );
      i = j;
    }
  }
}


void draw_activ_plot( win )
window win;
{ draw_activ_plot_between( win, 0, plot_width-1, 0, 0 );
  draw_activ_plot_frame( win );
}


void draw_event (win, trace_num, event_num, start, end)
window win;
int trace_num;
int event_num;
U64 start, end;
{
  int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT+PLOT_THEIGHT+BAR_BORDER-1;
  U64 ss, ee;
  U32 s, e;
  int i;

  if (!U64_less_than_U64 (start, max_time) ||
      !U64_less_than_U64 (min_time, end))
    return;

  if (U64_less_than_U64 (start, min_time))
    start = min_time;

  if (U64_less_than_U64 (max_time, end))
    end = max_time;

  ss = U64_mul_U32 (U64_sub_U64 (start, min_time), plot_width);
  ee = U64_mul_U32 (U64_sub_U64 (end, min_time), plot_width);
  s = U64_to_U32 (U64_div_U64 (ss, duration));
  e = U64_to_U32 (U64_div_U64 (ee, duration));

  if (e>s)
    graph_box( win, OTHER+event_num, BORDER_LEFT+s,b+trace_num*(BAR_HEIGHT+BAR_SPACING)+BAR_SPACING+1, e-s, BAR_HEIGHT );
}


void draw_traces( win )
window win;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT+PLOT_THEIGHT+BAR_BORDER-1;
  int i, j;

  for (i=0; i<log_nb_traces; i++)
  { int last_event_num = log_trace[i].event[0].state;
    U64 last_event_time = U64_init (0, 0);
    for (j=0; j<log_trace[i].len; j++)
    { int event_num = log_trace[i].event[j].state;
      U64 event_time = log_trace[i].event[j].time;
      draw_event (win, i, last_event_num, last_event_time, event_time);
      last_event_num = event_num;
      last_event_time = event_time;
    }
    draw_event (win, i, last_event_num, last_event_time, log_max_time);
    if (i % 5 == 0)
    { char num[10];
      sprintf( num, "P%d", i );
      graph_text( win, BLACK, LEFT, BORDER_LEFT+plot_width+8, b+i*(BAR_HEIGHT+BAR_SPACING)+BAR_SPACING+BAR_HEIGHT/2+1, num );
      graph_box( win, BLACK, BORDER_LEFT+plot_width, b+i*(BAR_HEIGHT+BAR_SPACING)+BAR_SPACING+BAR_HEIGHT/2+1, TICK_LONG, 1 );
    }
  }
}


void draw_all( win )
window win;
{ graph_clear( win );
  draw_title( win );
  if (show_labels) draw_labels( win );
  if (show_hist) draw_hist( win );
  if (show_perc) draw_perc_plot( win );
  if (show_activ) draw_activ_plot( win );
  if (show_states) draw_traces( win );
  flip_cross_hair( win );
  draw_cross_hair_info( win );
  if (print_statistics)
    {
      char str[100];
      num_to_str (str, log_max_time, time_unit_scale, -1);
      printf ("execution time=%s\n", str);
    }
}


void point( win, x, y )
window win;
int x, y;
{ flip_cross_hair( win );
  last_point_x = x;
  last_point_y = y;
  flip_cross_hair( win );
  draw_cross_hair_info( win );
}


void click( win, x1, y1, x2, y2, but )
window win;
int x1, y1, x2, y2;
int but;
{ int b = LABEL_THEIGHT+HIST_THEIGHT+PERC_THEIGHT;
  if (y1 > b)
  {
    int z1 = x1-BORDER_LEFT;
    int z2 = x2-BORDER_LEFT;
    if (z1<0) z1=0; else if (z1>plot_width) z1=plot_width;
    if (z2<0) z2=0; else if (z2>plot_width) z2=plot_width;
    if (z1>z2) { int temp = z1; z1 = z2; z2 = temp; }
    max_time = U64_add_U32 (min_time, 1);
    min_time = U64_add_U64 (min_time,
                            U64_div_U32 (U64_mul_U32 (duration, z1),
                                         plot_width));
    max_time = U64_add_U64 (max_time,
                            U64_div_U32 (U64_mul_U32 (duration, z2),
                                         plot_width));
    compute_plot (min_time, max_time);
    compute_hist();
    draw_all( win );
  }
  else
  { int z1 = x1-BORDER_LEFT;
    int z2 = x2-BORDER_LEFT;
    if ((z1>=0) && (z1<=(full_plot_width+HIST_LEFT+HIST_RIGHT)) &&
        (z2>=0) && (z2<=(full_plot_width+HIST_LEFT+HIST_RIGHT)))
    { int aa, aaa, bb, bbb, temp;
      int i, j, n;
      n = nb_labels();
      if (z1>z2) { temp = z1; z1 = z2; z2 = temp; }
      aa = (z1*n)/(full_plot_width+HIST_LEFT+HIST_RIGHT);
      bb = (z2*n)/(full_plot_width+HIST_LEFT+HIST_RIGHT);
      j = 0;
      for (i=0; i<log_nb_events; i++)
      { int event_num = xlate[i];
        if (events_of_type[event_num].len != 0)
        { if (aa == j) aaa = i;
          if (bb == j) bbb = i;
          j++;
        }
      }
      temp = xlate[aaa]; xlate[aaa] = xlate[bbb]; xlate[bbb] = temp;
      flip_cross_hair( win );
      graph_box( win, WHITE, 0, 0, BORDER_LEFT+BORDER_RIGHT+full_plot_width, b);
      draw_labels( win );
      if (show_hist) draw_hist( win );
      draw_perc_plot( win );
      flip_cross_hair( win );
      draw_cross_hair_info( win );
    }
  }
}


void print_plot( win, send_to_printer )
window win;
int send_to_printer;
{ char command[100];
  char postscript_file[100];
  char *p1, *p2;
  if (send_to_printer) p1 = "xactlog"; else p1 = log_filename;
  p2 = postscript_file;
  while (*p1 != '\0') *p2++ = *p1++;
  if (send_to_printer) p1 = ".ps"; else p1 = ".eps";
  while (*p1 != '\0') *p2++ = *p1++;
  *p2 = '\0';
  graph_postscript_begin( win, postscript_file, send_to_printer, postscript_zoom );
  draw_all( win );
  graph_postscript_end( win );
  if (send_to_printer)
  { sprintf( command, "lpr %s", postscript_file );
    if (system( command ) < 0)
      fprintf( stderr, "print failed\n" );
  }
}


int key( win, c )
window win;
char c;
{ if ((c == 'q') || (c == 'Q')) return 1;
  else if (c == '.') draw_all( win );
  else if ((c == 'e') || (c == 'E'))
    {
      draw_all( win );
      print_plot( win, 0 );
    }
#if 0
  else if ((c == 'w') || (c == 'W'))
    {
      draw_all( win );
      print_plot( win, 1 );
    }
#endif
  else if ((c == 't') || (c == 'T'))
  { show_title = !show_title;
    graph_resize( win, win->w, THEIGHT );
  }
  else if ((c == 's') || (c == 'S'))
  { show_states = !show_states;
    if (show_states) plot_height /= 2; else plot_height *= 2;
    graph_resize( win, win->w, THEIGHT );
  }
  else if ((c == 'a') || (c == 'A'))
  { show_activ = !show_activ;
    graph_resize( win, win->w, THEIGHT );
  }
  else if ((c == 'p') || (c == 'P'))
  { show_perc = !show_perc;
    graph_resize( win, win->w, THEIGHT );
  }
  else if ((c == 'h') || (c == 'H'))
  { show_hist = !show_hist;
    graph_resize( win, win->w, THEIGHT );
  }
  else if ((c == 'l') || (c == 'L'))
  { show_labels = !show_labels;
    graph_resize( win, win->w, THEIGHT );
  }
  else if ((c == 'f') || (c == 'F'))
  { first_state_only = !first_state_only;
    draw_all( win );
  }
  else if ((c >= '0') && (c <= '9'))
  { smooth_passes = c-'0';
    compute_plot (min_time, max_time);
    compute_hist();
    draw_all( win );
  }
  else if ((c == 'i') || (c == 'I'))
  {
    plot_width = full_plot_width;
    smooth_passes = 0;
    compute_plot (U64_init (0, 0), log_max_time);
    compute_hist();
    draw_all( win );
  }
  else if ((c == 'z') || (c == 'Z'))
  {
    U64 twice = U64_add_U64 (duration, duration);
    if (U64_less_than_U64 (min_time, twice))
      min_time = U64_init (0, 0);
    else
      min_time = U64_sub_U64 (min_time, twice);
    max_time = min_time;
    max_time = U64_add_U64 (max_time, U64_mul_U32 (duration, 5));
    compute_plot (min_time, max_time);
    compute_hist();
    draw_all( win );
  }
  return 0;
}


void resize( win )
window win;
{ int new_width = win->w - BORDER_RIGHT - BORDER_LEFT;
  if (new_width < MIN_PLOT_WIDTH) new_width = MIN_PLOT_WIDTH;
  else if (new_width > MAX_PLOT_WIDTH) new_width = MAX_PLOT_WIDTH;
  if (new_width != full_plot_width)
    plot_width = new_width * plot_width / full_plot_width;
  full_plot_width = new_width;
  compute_plot (min_time, max_time);
  compute_hist();
}


int main( argc, argv )
int argc;
char **argv;
{ int i;
  window win;
  int arg;
  char *exec = "";
  int print_stats = 0;

#ifdef MAC
  int ac = 2;
  char *av[] = { "xactlog", "gambit.actlog", NULL };
  char filename[256];
  SFReply reply;
  static Point where = { 90, 82 };
  MaxApplZone();
  InitGraf(&thePort);
  InitFonts();
  FlushEvents(everyEvent, 0);
  InitWindows();
  InitMenus();
  TEInit();
  InitDialogs(0L);
  InitCursor();
#else
  int ac = argc;
  char **av = argv;
#endif

  {
    int i;
    for (i=0; i<MAX_NB_EVENT_TYPES; i++)
      xlate[i] = i;
  }

  arg = 1;
  while ((arg < ac) && (av[arg][0] == '-'))
  { if (av[arg][1] == 's' && av[arg][2] == 'e' && av[arg][3] == 'c' && av[arg][4] == '\0')
      time_unit = 0;
    else if (av[arg][1] == 'm' && av[arg][2] == 's' && av[arg][3] == '\0')
      time_unit = 3;
    else if (av[arg][1] == 'u' && av[arg][2] == 's' && av[arg][3] == '\0')
      time_unit = 6;
    else if (av[arg][1] == 'n' && av[arg][2] == 's' && av[arg][3] == '\0')
      time_unit = 9;
    else if (av[arg][1] == 'e')
      exec = &av[arg][2];
    else if (av[arg][1] == 'd')
      {
        if (av[arg][2] == '\0')
          debug_level = 1;
        else
          debug_level = atoi(&av[arg][2]);
      }
    else if (av[arg][1] == 'w')
      ;
    else if (av[arg][1] == 'h')
      ;
    else if (av[arg][1] == 'c')
      compression_scale = atoi(&av[arg][2]);
    else if (av[arg][1] == 's')
      print_stats = 1;
    else if (av[arg][1] == '2')
      two_states_only = 1;
    else if (av[arg][1] == 'b')
      graph_black_and_white = 1;
    else if (av[arg][1] == 'p')
      graph_display = 0;
    else if (av[arg][1] == 'Z')
      postscript_zoom = atof(&av[arg][2]);
    else if (av[arg][1] == 'x')
      {
        char *p1, *p2, temp;
        int i = 0;
        p1 = &av[arg][2];
        if (*p1 != '\0')
          while (1)
            {
              p2 = p1;
              while (*p2 >= '0' && *p2 <= '9') p2++;
              temp = *p2;
              *p2 = '\0';
              xlate[i++] = atoi(p1);
              *p2++ = temp;
              if (temp == '\0') break;
              p1 = p2;
            }
      }
    else if (av[arg][1] == '?')
      {
        fprintf( stderr, "usage: xactlog [options] [file.actlog]\n\n" );
        fprintf( stderr, "OPTIONS: -b (b&w); -p (postscript only); -ZNNN (postscript zoom by NNN)\n" );
        fprintf( stderr, "         -sec -ms -us -ns (time unit)\n" );
        fprintf( stderr, "         -wNNN (width NNN); -hNNN (height NNN)\n" );
        fprintf( stderr, "         -SNNN (histogram span NNN); -HNNN (histogram height NNN)\n" );
        fprintf( stderr, "         -eXXX (exec keyboard commands XXX); -cN (time compression)\n" );
        fprintf( stderr, "         -s (statistics); -dNNN (debug level NNN)\n\n" );
        fprintf( stderr, "COMMANDS:\n\n" );
        fprintf( stderr, "keyboard: q -- quit\n" );
        fprintf( stderr, "          . -- redraw window\n" );
        fprintf( stderr, "          e -- generate EPS file <program_name>.eps\n" );
#if 0
        fprintf( stderr, "          w -- print window on postscript printer (with lpr)\n" );
#endif
        fprintf( stderr, "          0..9 -- pass through smoothing filter 'n' times\n" );
        fprintf( stderr, "          t -- toggle title on/off\n" );
        fprintf( stderr, "          s -- toggle state logs on/off\n" );
        fprintf( stderr, "          a -- toggle activity profile on/off\n" );
        fprintf( stderr, "          p -- toggle percent profile on/off\n" );
        fprintf( stderr, "          h -- toggle state duration histograms on/off\n" );
        fprintf( stderr, "          l -- toggle state labels on/off\n" );
        fprintf( stderr, "          f -- toggle first state only on/off\n" );
        fprintf( stderr, "          i -- revert to initial display\n" );
        fprintf( stderr, "          z -- zoom out by factor of 5\n\n" );
        fprintf( stderr, "mouse: to zoom in, use click&drag to select section of interest\n" );
        fprintf( stderr, "       to change state ordering, use click&drag on state names to swap states\n" );
        exit (1);
      }
    arg++;
  }

  graph_init();

  if (arg < ac)
    log_filename = av[arg];
  else
    log_filename = "gambit.actlog";

  full_plot_width = graph_screen_width - BORDER_RIGHT - BORDER_LEFT;
  plot_height = DEFAULT_PLOT_HEIGHT;
  hist_height = DEFAULT_HIST_HEIGHT;
  hist_span_at_width = 0;

  arg = 1;
  while ((arg < ac) && (av[arg][0] == '-'))
  { if (av[arg][1] == 'w')
      full_plot_width = atoi( &av[arg][2] );
    else if (av[arg][1] == 'h')
      plot_height = (atoi( &av[arg][2] )/16)*16;
    else if (av[arg][1] == 'S')
      hist_span_at_width = atoi( &av[arg][2] );
    else if (av[arg][1] == 'H')
      hist_height = atoi( &av[arg][2] );
    arg++;
  }

  if (show_states) plot_height /= 2;

  if (full_plot_width < MIN_PLOT_WIDTH) full_plot_width = MIN_PLOT_WIDTH;
  else if (full_plot_width > MAX_PLOT_WIDTH) full_plot_width = MAX_PLOT_WIDTH;

#ifdef MAC
  again:
  SFGetFile( where, "\pEvent log file", 0L, -1, 0L, 0L, &reply );
  if (reply.good)
  { int i, len;
    len = reply.fName[0];
    for (i=0; i<len; i++) filename[i] = reply.fName[i+1];
    filename[i] = '\0';
    av[arg] = filename;
  }
  else
    exit (0);
#endif

  plot_width = full_plot_width;
  smooth_passes = 0;

  read_log (log_filename);

  {
    int i;
    for (i=0; i<log_nb_events; i++)
    {
      U64 *p1;
      ULONG *p2;
      p1 = malloc ((MAX_PLOT_WIDTH+1) * sizeof(U64));
      if (p1 == NULL)
        {
          fprintf( stderr, "memory overflow\n" );
          exit (1);
        }
      count[i] = p1;
      p2 = malloc ((MAX_PLOT_WIDTH+1) * sizeof(ULONG));
      if (p2 == NULL)
        {
          fprintf( stderr, "memory overflow\n" );
          exit (1);
        }
      hist[i] = p2;
    }
  }

  if (log_nb_traces >= 96)
  { bar_height  = 3;
    bar_spacing = 1;
  }
  else if (log_nb_traces >= 64)
  { bar_height  = 4;
    bar_spacing = 1;
  }
  else if (log_nb_traces >= 32)
  { bar_height  = 6;
    bar_spacing = 2;
  }
  else
  { bar_height  = 9;
    bar_spacing = 3;
  }

  win = graph_window( log_filename,
                      full_plot_width+BORDER_RIGHT+BORDER_LEFT,
                      THEIGHT,
                      log_event_color,
                      log_nb_events,
                      draw_all,
                      point,
                      click,
                      key,
                      resize );

  compute_plot (U64_init (0, 0), log_max_time);
  compute_hist();

  print_statistics = print_stats;

  draw_all( win );

  print_statistics = 0;

  while (*exec != '\0') if (key( win, *exec++ )) exit (0);

  graph_idle( win );

#ifdef MAC
  goto again;
#endif

  return 0;
}
