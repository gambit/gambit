/* File: "c_intf.c" */

/* Copyright (c) 1994-2017 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the conversion functions for the C
 * interface.
 */

#define ___INCLUDED_FROM_C_INTF
#define ___VERSION 409001
#include "gambit.h"

#include "os_base.h"
#include "os_dyn.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"


/*---------------------------------------------------------------------------*/

/* Utilities for 64 bit arithmetic. */


#ifdef ___BUILTIN_64BIT_INT_TYPE


/*
 * If the symbol ___BUILTIN_64BIT_INT_TYPE is defined then the data
 * types ___S64 and ___U64 are builtin integer types.
 */


___EXP_FUNC(___S64,___S64_from_SM32_fn)
   ___P((___SM32 val),
        (val)
___SM32 val;)
{
  return ___S64_from_SM32 (val);
}


___EXP_FUNC(___S64,___S64_from_SM32_UM32_fn)
   ___P((___SM32 hi32,
         ___UM32 lo32),
        (hi32,
         lo32)
___SM32 hi32;
___UM32 lo32;)
{
  return ___S64_from_SM32_UM32 (hi32, lo32);
}


___EXP_FUNC(___S64,___S64_from_LONGLONG_fn)
   ___P((___LONGLONG val),
        (val)
___LONGLONG val;)
{
  return ___S64_from_LONGLONG (val);
}


___EXP_FUNC(___LONGLONG,___S64_to_LONGLONG_fn)
   ___P((___S64 val),
        (val)
___S64 val;)
{
  return ___S64_to_LONGLONG (val);
}


___EXP_FUNC(___BOOL,___S64_fits_in_width_fn)
   ___P((___S64 val,
         int width),
        (val,
         width)
___S64 val;
int width;)
{
  return ___S64_fits_in_width (val, width);
}


___EXP_FUNC(___U64,___U64_from_UM32_fn)
   ___P((___UM32 val),
        (val)
___UM32 val;)
{
  return ___U64_from_UM32 (val);
}


___EXP_FUNC(___U64,___U64_from_UM32_UM32_fn)
   ___P((___UM32 hi32,
         ___UM32 lo32),
        (hi32,
         lo32)
___UM32 hi32;
___UM32 lo32;)
{
  return ___U64_from_UM32_UM32 (hi32, lo32);
}


___EXP_FUNC(___U64,___U64_from_ULONGLONG_fn)
   ___P((___ULONGLONG val),
        (val)
___ULONGLONG val;)
{
  return ___U64_from_ULONGLONG (val);
}


___EXP_FUNC(___ULONGLONG,___U64_to_ULONGLONG_fn)
   ___P((___U64 val),
        (val)
___U64 val;)
{
  return ___U64_to_ULONGLONG (val);
}


___EXP_FUNC(___BOOL,___U64_fits_in_width_fn)
   ___P((___U64 val,
         int width),
        (val,
         width)
___U64 val;
int width;)
{
  return ___U64_fits_in_width (val, width);
}


___EXP_FUNC(___U64,___U64_mul_UM32_UM32_fn)
   ___P((___UM32 x,
         ___UM32 y),
        (x,
         y)
___UM32 x;
___UM32 y;)
{
  return ___U64_mul_UM32_UM32 (x, y);
}


___EXP_FUNC(___U64,___U64_add_U64_U64_fn)
   ___P((___U64 x,
         ___U64 y),
        (x,
         y)
___U64 x;
___U64 y;)
{
  return ___U64_add_U64_U64 (x, y);
}


#else

/*
 * If the symbol ___BUILTIN_64BIT_INT_TYPE is not defined then the
 * data types ___S64 and ___U64 are structures.
 */


___EXP_FUNC(___S64,___S64_from_SM32_fn)
   ___P((___SM32 val),
        (val)
___SM32 val;)
{
  ___S64 r;
  r.lo32 = ___CAST_U32(val);
  r.hi32 = (val < 0) ? -1 : 0;
  return r;
}


___EXP_FUNC(___S64,___S64_from_SM32_UM32_fn)
   ___P((___SM32 hi32,
         ___UM32 lo32),
        (hi32,
         lo32)
___SM32 hi32;
___UM32 lo32;)
{
  ___S64 r;
  r.lo32 = lo32;
  r.hi32 = hi32;
  return r;
}


___EXP_FUNC(___S64,___S64_from_LONGLONG_fn)
   ___P((___LONGLONG val),
        (val)
___LONGLONG val;)
{
#if ___LONGLONG_WIDTH <= 32
  return ___S64_from_SM32 (val);
#else
  return ___S64_from_SM32_UM32 (___CAST_S32(val >> 32), ___CAST_U32(val));
#endif
}


___EXP_FUNC(___LONGLONG,___S64_to_LONGLONG_fn)
   ___P((___S64 val),
        (val)
___S64 val;)
{
#if ___LONGLONG_WIDTH <= 32
  return ___CAST_S32 (val.lo32);
#else
  return (___CAST(___LONGLONG,val.hi32) << 32) + val.lo32;
#endif
}


___EXP_FUNC(___BOOL,___S64_fits_in_width_fn)
   ___P((___S64 val,
         int width),
        (val,
         width)
___S64 val;
int width;)
{
  if (val.hi32 < 0)
    {
      if (width > 32)
        return (val.hi32 >> (width-32-1)) == -1;
      return val.hi32 == -1 && (___CAST_S32(val.lo32) >> (width-1)) == -1;
    }
  else
    {
      if (width > 32)
        return (val.hi32 >> (width-32-1)) == 0;
      return val.hi32 == 0 && (___CAST_S32(val.lo32) >> (width-1)) == 0;
    }
}


___EXP_FUNC(___U64,___U64_from_UM32_fn)
   ___P((___UM32 val),
        (val)
___UM32 val;)
{
  ___U64 r;
  r.lo32 = val;
  r.hi32 = 0;
  return r;
}


___EXP_FUNC(___U64,___U64_from_UM32_UM32_fn)
   ___P((___UM32 hi32,
         ___UM32 lo32),
        (hi32,
         lo32)
___UM32 hi32;
___UM32 lo32;)
{
  ___U64 r;
  r.lo32 = lo32;
  r.hi32 = hi32;
  return r;
}


___EXP_FUNC(___U64,___U64_from_ULONGLONG_fn)
   ___P((___ULONGLONG val),
        (val)
___ULONGLONG val;)
{
#if ___LONGLONG_WIDTH <= 32
  return ___U64_from_UM32 (val);
#else
  return ___U64_from_UM32_UM32 (___CAST_U32(val >> 32), ___CAST_U32(val));
#endif
}


___EXP_FUNC(___ULONGLONG,___U64_to_ULONGLONG_fn)
   ___P((___U64 val),
        (val)
___U64 val;)
{
#if ___LONGLONG_WIDTH <= 32
  return val.lo32;
#else
  return (___CAST(___ULONGLONG,val.hi32) << 32) + val.lo32;
#endif
}


___EXP_FUNC(___BOOL,___U64_fits_in_width_fn)
   ___P((___U64 val,
         int width),
        (val,
         width)
___U64 val;
int width;)
{
  if (width >= 64)
    return 1;
  if (width >= 32)
    return (val.hi32 >> (width-32)) == 0;
  return val.hi32 == 0 && (val.lo32 >> width) == 0;
}


___EXP_FUNC(___U64,___U64_mul_UM32_UM32_fn)
   ___P((___UM32 x,
         ___UM32 y),
        (x,
         y)
___UM32 x;
___UM32 y;)
{
  ___U64 r;
  ___UM32 xlo = x & 0xffff;
  ___UM32 xhi = x >> 16;
  ___UM32 ylo = y & 0xffff;
  ___UM32 yhi = y >> 16;
  ___UM32 lo = xlo * ylo; /* 0 .. 0xfffe0001 */
  ___UM32 m1 = xlo * yhi + (lo >> 16); /* 0 .. 0xfffeffff */
  ___UM32 m2 = xhi * ylo; /* 0 .. 0xfffe0001 */
  ___UM32 m3 = (m1 & 0xffff) + (m2 & 0xffff); /* 0 .. 0x1fffe */
  ___UM32 hi = xhi * yhi + (m1 >> 16) + (m2 >> 16) + (m3 >> 16); /* 0 .. 0xfffffffe */
  r.lo32 = ((m3 & 0xffff) << 16) + (lo & 0xffff);
  r.hi32 = hi;
  return r;
}


___EXP_FUNC(___U64,___U64_add_U64_U64_fn)
   ___P((___U64 x,
         ___U64 y),
        (x,
         y)
___U64 x;
___U64 y;)
{
  ___U64 r;
  r.lo32 = x.lo32 + y.lo32;
  r.hi32 = x.hi32 + y.hi32 + (r.lo32 < x.lo32);
  return r;
}


#endif


/*---------------------------------------------------------------------------*/

/* Utilities for UTF-8 encoding of characters. */


/*
 * '___UTF_8_bytes (c)' returns the number of bytes that are needed to
 * encode the character 'c' using the UTF-8 variable-length encoding.
 * If the character is not legal, 0 is returned.
 */

int ___UTF_8_bytes
   ___P((___UCS_4 c),
        (c)
___UCS_4 c;)
{
  if (c <= 0x7f) return 1;
  if (c <= 0x7ff) return 2;
  if (c <= 0xffff)
    {
#ifdef ___REJECT_ILLEGAL_UCS_4
      if (c > 0xd7ff && (c <= 0xdfff || c > 0xfffd)) return 0;
#endif
      return 3;
    }
  if (c <= 0x1fffff) return 4;
  if (c <= 0x3ffffff) return 5;
#ifdef ___REJECT_ILLEGAL_UCS_4
  if (c > 0x7fffffff) return 0;
#endif
  return 6;
}


/*
 * '___UTF_8_put (ptr, c)' converts the character 'c' into its UTF-8
 * variable-length encoding.  'ptr' is a pointer to a byte pointer
 * designating the start of the UTF-8 encoding.  On return the byte
 * pointer points to the first byte following the UTF-8 encoding.  If
 * the character is not legal, the pointer is not updated.
 */

void ___UTF_8_put
   ___P((___UTF_8STRING *ptr,
         ___UCS_4 c),
        (ptr,
         c)
___UTF_8STRING *ptr;
___UCS_4 c;)
{
  ___UTF_8STRING p = *ptr;
  if (c <= 0x7f)
    {
      *p++ = c;
      *ptr = p;
    }
  else
    {
      int bytes;
      if (c <= 0x7ff) bytes = 2;
      else if (c <= 0xffff)
        {
#ifdef ___REJECT_ILLEGAL_UCS_4
          if (c > 0xd7ff && (c <= 0xdfff || c > 0xfffd)) return;
#endif
          bytes = 3;
        }
      else if (c <= 0x1fffff) bytes = 4;
      else if (c <= 0x3ffffff) bytes = 5;
#ifdef ___REJECT_ILLEGAL_UCS_4
      else if (c > 0x7fffffff) return;
#endif
      else bytes = 6;
      p += bytes;
      *ptr = p;
      switch (bytes)
        {
          case 6:  *--p = 0x80+(c&0x3f); c >>= 6;
          case 5:  *--p = 0x80+(c&0x3f); c >>= 6;
          case 4:  *--p = 0x80+(c&0x3f); c >>= 6;
          case 3:  *--p = 0x80+(c&0x3f); c >>= 6;
          default: *--p = 0x80+(c&0x3f); c >>= 6;
        }
      *--p = 0xff - (0xff>>bytes) + c;
    }
}


/*
 * '___UTF_8_get (ptr)' converts a UTF-8 variable-length encoding to
 * the character it encodes.  'ptr' is a pointer to a byte pointer
 * designating the start of the UTF-8 encoding.  If the encoding is
 * legal, the byte pointer will point to the first byte following the
 * UTF-8 encoding and the character is returned.  If the encoding is
 * illegal, the byte pointer is not updated and 0 is returned.
 */

___UCS_4 ___UTF_8_get
   ___P((___UTF_8STRING *ptr),
        (ptr)
___UTF_8STRING *ptr;)
{
  ___UTF_8STRING p = *ptr;
  unsigned char byte = *p++;
  ___UCS_4 c;
  int bits;
  if (byte <= 0x7f)
    {
      *ptr = p;
      return byte;
    }
  if (byte <= 0xbf || byte > 0xfd)
    return 0; /* illegal first byte */
  c = byte; /* upper bits are removed later */
  bits = 6;
  while (byte & 0x40)
    {
      unsigned char next = *p++;
      if (next <= 0x7f || next > 0xbf)
        return 0; /* faulty byte found after the first byte */
      c = (c << 6) + (next & 0x3f);
      byte <<= 1;
      bits += 5;
    }
  c &= ___CAST(___U32,1<<bits)-1;
#ifdef ___REJECT_ILLEGAL_UCS_4
  if ((c > 0xd7ff && c <= 0xdfff) ||
      (c > 0xfffd && c <= 0xffff))
    return 0; /* it is not a legal UCS-4 character */
  if (c < 0x80 ||
      c < ((___UCS_4)1<<(bits-5)))
    return 0; /* character was not encoded with the shortest sequence */
#endif
  *ptr = p;
  return c;
}


/*---------------------------------------------------------------------------*/

/*
 * Decoding/encoding of a buffer of characters (of type ___C) to a
 * buffer of bytes (of type ___U8) in a certain encoding.
 */


#define bytes_per_ISO_8859_1 1
#define max_ISO_8859_1       0xff

#define bytes_per_UTF_8  1 /* optimization for 1 byte case */
#define max_UTF_8        0x7f

#define bytes_per_UTF_16 2 /* optimization for 2 byte case */
#define max_UTF_16       0x10ffff

#define bytes_per_UCS_2  2
#define max_UCS_2        0xffff

#define bytes_per_UCS_4  4
#define max_UCS_4        0x7fffffff


#define DECODE_EOL(loop_label) \
if (c != ___UNICODE_LINEFEED) \
  { \
    if (c != ___UNICODE_RETURN) \
      { \
        state = ___DECODE_STATE_MASK(state)+___DECODE_STATE_NONE; \
        *clo++ = c; \
        if (clo < chi) \
          goto loop_label; \
      } \
    else \
      { \
        int eol = ___EOL_ENCODING(state); \
        if (eol != ___EOL_ENCODING_LF) \
          { \
            if (eol != ___EOL_ENCODING_CR) \
              { \
                int rs = ___DECODE_STATE(state); \
                if (rs == ___DECODE_STATE_LF) \
                  { \
                    state += ___DECODE_STATE_NONE-___DECODE_STATE_LF; \
                    goto loop_label; \
                  } \
                state += ___DECODE_STATE_CR-rs; \
              } \
            c = char_EOL; \
          } \
        *clo++ = c; \
        if (clo < chi) \
          goto loop_label; \
      } \
  } \
else \
  { \
    int eol = ___EOL_ENCODING(state); \
    if (eol != ___EOL_ENCODING_CR) \
      { \
        if (eol != ___EOL_ENCODING_LF) \
          { \
            int rs = ___DECODE_STATE(state); \
            if (rs == ___DECODE_STATE_CR) \
              { \
                state += ___DECODE_STATE_NONE-___DECODE_STATE_CR; \
                goto loop_label; \
              } \
            state += ___DECODE_STATE_LF-rs; \
          } \
        c = char_EOL; \
      } \
    *clo++ = c; \
    if (clo < chi) \
      goto loop_label; \
  }


#define DECODE_CHARS_LOOP(loop_label,bytes_per_char,max_char,get_char) \
loop_label: \
blo += bytes_per_char; \
if (blo <= bhi) \
  { \
    c = get_char(-1); \
    if (max_char <= ___MAX_CHR || \
        c <= ___MAX_CHR) \
      { \
        DECODE_EOL(loop_label) \
      } \
    else if (blo - bytes_per_char == byte_buf) \
      result = ___ILLEGAL_CHAR; \
    else \
      blo -= bytes_per_char; \
  } \
else \
  { \
    blo -= bytes_per_char; \
    if (bytes_per_char > 1 && \
        blo == byte_buf) \
      result = ___INCOMPLETE_CHAR; \
  } \
break;


#define ENCODE_EOL(loop_label,bytes_per_char,put_char) \
switch (___EOL_ENCODING(state)) \
  { \
  case ___EOL_ENCODING_CR: \
    put_char(-1,___UNICODE_RETURN); \
    break; \
  case ___EOL_ENCODING_CRLF: \
    blo += bytes_per_char; \
    if (blo > bhi) \
      { \
        blo -= 2*bytes_per_char; \
        clo--; \
        goto encode_chars_end; \
      } \
    put_char(-2,___UNICODE_RETURN); \
  default: \
    put_char(-1,___UNICODE_LINEFEED); \
    break; \
  } \
if (!___FULLY_BUFFERED(state)) \
  goto encode_chars_end; /* must empty byte buffer */ \
else if (clo < chi) \
  goto loop_label;


#define ENCODE_CHARS_LOOP(loop_label,bytes_per_char,max_char,put_char) \
loop_label: \
c = *clo++; \
if (___MAX_CHR <= max_char || \
    c <= max_char) \
  { \
    blo += bytes_per_char; \
    if (blo <= bhi) \
      { \
        if (c != char_EOL) \
          { \
            put_char(-1,c); \
            if (clo < chi) \
              goto loop_label; \
          } \
        else \
          { \
            ENCODE_EOL(loop_label,bytes_per_char,put_char); \
          } \
      } \
    else \
      { \
        blo -= bytes_per_char; \
        clo--; \
        goto encode_chars_end; \
      } \
  } \
else \
  { \
    clo--; \
    if (clo == char_buf) \
      result = ___ILLEGAL_CHAR; \
    goto encode_chars_end; \
  } \
break;


#define get_ISO_8859_1(i) \
blo[(i)*bytes_per_ISO_8859_1]

#define get_UTF_8(i) \
blo[(i)*bytes_per_UTF_8]

#define get_UTF_16BE(i) \
(___CAST(___UTF_16,blo[(i)*bytes_per_UTF_16+0]) << 8) + \
___CAST(___UTF_16,blo[(i)*bytes_per_UTF_16+1])

#define get_UTF_16LE(i) \
(___CAST(___UTF_16,blo[(i)*bytes_per_UTF_16+1]) << 8) + \
___CAST(___UTF_16,blo[(i)*bytes_per_UTF_16+0])

#define get_UCS_2BE(i) \
(___CAST(___UCS_2,blo[(i)*bytes_per_UCS_2+0]) << 8) + \
___CAST(___UCS_2,blo[(i)*bytes_per_UCS_2+1])

#define get_UCS_2LE(i) \
(___CAST(___UCS_2,blo[(i)*bytes_per_UCS_2+1]) << 8) + \
___CAST(___UCS_2,blo[(i)*bytes_per_UCS_2+0])

#define get_UCS_4BE(i) \
(((((___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+0]) << 8) + \
    ___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+1])) << 8) + \
  ___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+2])) << 8) + \
___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+3])

#define get_UCS_4LE(i) \
(((((___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+3]) << 8) + \
    ___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+2])) << 8) + \
  ___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+1])) << 8) + \
___CAST(___UCS_4,blo[(i)*bytes_per_UCS_4+0])

#define put_ISO_8859_1(i,c) \
blo[(i)*bytes_per_ISO_8859_1] = (c);

#define put_UTF_8(i,c) \
blo[(i)*bytes_per_UTF_8] = (c);

#define put_UTF_16BE(i,c) \
blo[(i)*bytes_per_UTF_16+1] = (c) & 0xff; \
blo[(i)*bytes_per_UTF_16+0] = ((c)>>8) & 0xff;

#define put_UTF_16LE(i,c) \
blo[(i)*bytes_per_UTF_16+0] = (c) & 0xff; \
blo[(i)*bytes_per_UTF_16+1] = ((c)>>8) & 0xff;

#define put_UCS_2BE(i,c) \
blo[(i)*bytes_per_UCS_2+1] = (c) & 0xff; \
blo[(i)*bytes_per_UCS_2+0] = ((c)>>8) & 0xff;

#define put_UCS_2LE(i,c) \
blo[(i)*bytes_per_UCS_2+0] = (c) & 0xff; \
blo[(i)*bytes_per_UCS_2+1] = ((c)>>8) & 0xff;

#define put_UCS_4BE(i,c) \
blo[(i)*bytes_per_UCS_4+3] = (c) & 0xff; \
blo[(i)*bytes_per_UCS_4+2] = ((c)>>8) & 0xff; \
blo[(i)*bytes_per_UCS_4+1] = ((c)>>16) & 0xff; \
blo[(i)*bytes_per_UCS_4+0] = ((c)>>24) & 0xff;

#define put_UCS_4LE(i,c) \
blo[(i)*bytes_per_UCS_4+0] = (c) & 0xff; \
blo[(i)*bytes_per_UCS_4+1] = ((c)>>8) & 0xff; \
blo[(i)*bytes_per_UCS_4+2] = ((c)>>16) & 0xff; \
blo[(i)*bytes_per_UCS_4+3] = ((c)>>24) & 0xff;


int chars_from_bytes
   ___P((___C *char_buf,
         int *char_buf_avail,
         ___U8 *byte_buf,
         int *byte_buf_avail,
         int *decoding_state),
        (char_buf,
         char_buf_avail,
         byte_buf,
         byte_buf_avail,
         decoding_state)
___C *char_buf;
int *char_buf_avail;
___U8 *byte_buf;
int *byte_buf_avail;
int *decoding_state;)
{
  int result;
  ___UCS_4 c;
  ___C *clo = char_buf;
  ___C *chi = char_buf + *char_buf_avail;
  ___U8 *blo = byte_buf;
  ___U8 *bhi = byte_buf + *byte_buf_avail;
  int state = *decoding_state;

  result = ___CONVERSION_DONE;

  /* fill character buffer as much as possible */

  if (clo < chi && blo < bhi)
    {
      /* there is still some space in the character buffer and byte buffer */

      dispatch_on_char_encoding:

      switch (___CHAR_ENCODING(state))
        {
        default:
        case ___CHAR_ENCODING_ASCII:
        case ___CHAR_ENCODING_ISO_8859_1:
          DECODE_CHARS_LOOP(decode_next_ISO_8859_1,
                            bytes_per_ISO_8859_1,
                            0xff,
                            get_ISO_8859_1);

        case ___CHAR_ENCODING_UTF_8:
          {
            decode_next_UTF_8:
            blo += bytes_per_UTF_8;
            if (blo <= bhi)
              {
                c = get_UTF_8(-1);
                if (c <= 0x7f)
                  {
                    DECODE_EOL(decode_next_UTF_8);
                  }
                else if (c <= 0xbf || c > 0xfd)
                  {
                    if (blo - bytes_per_UTF_8 == byte_buf)
                      result = ___ILLEGAL_CHAR;
                    else
                      blo -= bytes_per_UTF_8;
                  }
                else
                  {
                    ___U8* orig_blo = blo;
                    ___U8 b0 = c;
                    int bits = 6;
                    while (b0 & 0x40)
                      {
                        ___U8 next = *blo++;
                        if (blo > bhi)
                          {
                            blo = orig_blo-bytes_per_UTF_8;
                            if (blo == byte_buf)
                              result = ___INCOMPLETE_CHAR;
                            goto end_UTF_8;
                          }
                        if (next <= 0x7f || next > 0xbf)
                          {
                            if (orig_blo-bytes_per_UTF_8 == byte_buf)
                              result = ___ILLEGAL_CHAR;
                            else
                              blo = orig_blo-bytes_per_UTF_8;
                            goto end_UTF_8;
                          }
                        c = (c << 6) + (next & 0x3f);
                        b0 <<= 1;
                        bits += 5;
                      }
                    c &= (___CAST(___UCS_4,1)<<bits)-1;
                    if (c >= 0x80 &&
                        c >= (___CAST(___UCS_4,1)<<(bits-5)) &&
                        c <= ___MAX_CHR)
                      {
                        state =
                          ___DECODE_STATE_MASK(state)+___DECODE_STATE_NONE;
                        *clo++ = c;
                        if (clo < chi)
                          goto decode_next_UTF_8;
                      }
                    else
                      {
                        if (orig_blo-bytes_per_UTF_8 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = orig_blo-bytes_per_UTF_8;
                      }
                    end_UTF_8:;
                  }
              }
            else
              blo -= bytes_per_UTF_8;
            break;
          }

        case ___CHAR_ENCODING_UTF_16:
          {
            blo += bytes_per_UTF_16;
            if (blo <= bhi)
              {
                ___UCS_4 cle;
                c = get_UTF_16BE(-1);
                if (c == ___UNICODE_BOM)
                  {
                    state += ___CHAR_ENCODING_UTF_16BE-___CHAR_ENCODING_UTF_16;
                    goto decode_next_UTF_16BE;
                  }
                cle = ((c&0xff) << 8) +
                      ((c>>8)&0xff);
                if (cle == ___UNICODE_BOM)
                  {
                    state += ___CHAR_ENCODING_UTF_16LE-___CHAR_ENCODING_UTF_16;
                    goto decode_next_UTF_16LE;
                  }
                blo -= bytes_per_UTF_16;
#ifdef ___DEFAULT_CHAR_ENCODING_TO_BIG_ENDIAN
                state += ___CHAR_ENCODING_UTF_16BE-___CHAR_ENCODING_UTF_16;
                goto decode_next_UTF_16BE;
#else
                state += ___CHAR_ENCODING_UTF_16LE-___CHAR_ENCODING_UTF_16;
                goto decode_next_UTF_16LE;
#endif
              }
            else
              {
                blo -= bytes_per_UTF_16;
                if (bytes_per_UTF_16 > 1 &&
                    blo == byte_buf)
                  result = ___INCOMPLETE_CHAR;
              }
            break;
          }

        case ___CHAR_ENCODING_UTF_16BE:
          {
            decode_next_UTF_16BE:
            blo += bytes_per_UTF_16;
            if (blo <= bhi)
              {
                c = get_UTF_16BE(-1);
                if (c <= 0xd7ff)
                  {
                    if (c <= ___MAX_CHR)
                      {
                        DECODE_EOL(decode_next_UTF_16BE);
                      }
                    else
                      {
                        if (blo-bytes_per_UTF_16 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = blo-bytes_per_UTF_16;
                      }
                  }
                else if (c > 0xdfff)
                  {
                    if (c <= ___MAX_CHR)
                      {
                        state =
                          ___DECODE_STATE_MASK(state)+___DECODE_STATE_NONE;
                        *clo++ = c;
                        if (clo < chi)
                          goto decode_next_UTF_16BE;
                      }
                    else
                      {
                        if (blo-bytes_per_UTF_16 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = blo-bytes_per_UTF_16;
                      }
                  }
                else if (c > 0xdbff)
                  {
                    if (blo-bytes_per_UTF_16 == byte_buf)
                      result = ___ILLEGAL_CHAR;
                    else
                      blo = blo-bytes_per_UTF_16;
                  }
                else
                  {
                    blo += bytes_per_UTF_16;
                    if (blo <= bhi)
                      {
                        ___UCS_4 x = get_UTF_16BE(-1);
                        if (x > 0xdbff &&
                            x <= 0xdfff &&
                            (c = (c << 10) + x -
                                 ((0xd800 << 10) + 0xdc00 - 0x10000))
                            <= ___MAX_CHR)
                          {
                            state =
                              ___DECODE_STATE_MASK(state)+___DECODE_STATE_NONE;
                            *clo++ = c;
                            if (clo < chi)
                              goto decode_next_UTF_16BE;
                          }
                        else
                          {
                            if (blo-2*bytes_per_UTF_16 == byte_buf)
                              result = ___ILLEGAL_CHAR;
                            else
                              blo = blo-2*bytes_per_UTF_16;
                          }
                      }
                    else
                      {
                        if (blo-2*bytes_per_UTF_16 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = blo-2*bytes_per_UTF_16;
                      }
                  }
              }
            else
              blo -= bytes_per_UTF_16;
            break;
          }

        case ___CHAR_ENCODING_UTF_16LE:
          {
            decode_next_UTF_16LE:
            blo += bytes_per_UTF_16;
            if (blo <= bhi)
              {
                c = get_UTF_16LE(-1);
                if (c <= 0xd7ff)
                  {
                    if (c <= ___MAX_CHR)
                      {
                        DECODE_EOL(decode_next_UTF_16LE);
                      }
                    else
                      {
                        if (blo-bytes_per_UTF_16 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = blo-bytes_per_UTF_16;
                      }
                  }
                else if (c > 0xdfff)
                  {
                    if (c <= ___MAX_CHR)
                      {
                        state =
                          ___DECODE_STATE_MASK(state)+___DECODE_STATE_NONE;
                        *clo++ = c;
                        if (clo < chi)
                          goto decode_next_UTF_16LE;
                      }
                    else
                      {
                        if (blo-bytes_per_UTF_16 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = blo-bytes_per_UTF_16;
                      }
                  }
                else if (c > 0xdbff)
                  {
                    if (blo-bytes_per_UTF_16 == byte_buf)
                      result = ___ILLEGAL_CHAR;
                    else
                      blo = blo-bytes_per_UTF_16;
                  }
                else
                  {
                    blo += bytes_per_UTF_16;
                    if (blo <= bhi)
                      {
                        ___UCS_4 x = get_UTF_16LE(-1);
                        if (x > 0xdbff &&
                            x <= 0xdfff &&
                            (c = (c << 10) + x -
                                 ((0xd800 << 10) + 0xdc00 - 0x10000))
                            <= ___MAX_CHR)
                          {
                            state =
                              ___DECODE_STATE_MASK(state)+___DECODE_STATE_NONE;
                            *clo++ = c;
                            if (clo < chi)
                              goto decode_next_UTF_16LE;
                          }
                        else
                          {
                            if (blo-2*bytes_per_UTF_16 == byte_buf)
                              result = ___ILLEGAL_CHAR;
                            else
                              blo = blo-2*bytes_per_UTF_16;
                          }
                      }
                    else
                      {
                        if (blo-2*bytes_per_UTF_16 == byte_buf)
                          result = ___ILLEGAL_CHAR;
                        else
                          blo = blo-2*bytes_per_UTF_16;
                      }
                  }
              }
            else
              blo -= bytes_per_UTF_16;
            break;
          }

        case ___CHAR_ENCODING_UTF_FALLBACK_ASCII:
        case ___CHAR_ENCODING_UTF_FALLBACK_ISO_8859_1:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_8:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_16:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_16BE:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_16LE:
          {
            if (blo < bhi)
              {
                ___U8 b0 = blo[0];
                if (b0 >= 0xfe)
                  {
                    /* start of UTF-16BE or UTF-16LE BOM */
                    if (blo+1 < bhi)
                      {
                        if (blo[1] == (b0 ^ 1))
                          {
                            /* complete BOM */
                            blo += 2; /* skip BOM */
                            if (b0 == 0xfe)
                              {
                                state += ___CHAR_ENCODING_UTF_16BE -
                                         ___CHAR_ENCODING(state);
                                goto decode_next_UTF_16BE;
                              }
                            else
                              {
                                state += ___CHAR_ENCODING_UTF_16LE -
                                         ___CHAR_ENCODING(state);
                                goto decode_next_UTF_16LE;
                              }
                          }
                        else
                          {
                            /* not a UTF-16BE BOM, so use fallback encoding */
                            state += ___CHAR_ENCODING_ASCII -
                                     ___CHAR_ENCODING_UTF_FALLBACK_ASCII;
                            goto dispatch_on_char_encoding;
                          }
                      }
                  }
                else
                  {
                    /* check start of UTF-8 BOM */
                    if ((b0 != 0xef) ||
                        (blo+1 < bhi && blo[1] != 0xbb) ||
                        (blo+2 < bhi && blo[2] != 0xbf))
                      {
                        /* not a UTF-8 BOM, so use fallback encoding */
                        state += ___CHAR_ENCODING_ASCII -
                                 ___CHAR_ENCODING_UTF_FALLBACK_ASCII;
                        goto dispatch_on_char_encoding;
                      }
                    else if (blo+2 < bhi)
                      {
                        /* complete UTF-8 BOM */
                        blo += 3; /* skip BOM */
                        state += ___CHAR_ENCODING_UTF_8 -
                                 ___CHAR_ENCODING(state);
                        goto decode_next_UTF_8;
                      }
                  }
              }
            result = ___INCOMPLETE_CHAR;
            break;
          }

        case ___CHAR_ENCODING_UCS_2:
          {
            blo += bytes_per_UCS_2;
            if (blo <= bhi)
              {
                ___UCS_4 cle;
                c = get_UCS_2BE(-1);
                if (c == ___UNICODE_BOM)
                  {
                    state += ___CHAR_ENCODING_UCS_2BE-___CHAR_ENCODING_UCS_2;
                    goto decode_next_UCS_2BE;
                  }
                cle = ((c&0xff) << 8) +
                      ((c>>8)&0xff);
                if (cle == ___UNICODE_BOM)
                  {
                    state += ___CHAR_ENCODING_UCS_2LE-___CHAR_ENCODING_UCS_2;
                    goto decode_next_UCS_2LE;
                  }
                blo -= bytes_per_UCS_2;
#ifdef ___DEFAULT_CHAR_ENCODING_TO_BIG_ENDIAN
                state += ___CHAR_ENCODING_UCS_2BE-___CHAR_ENCODING_UCS_2;
                goto decode_next_UCS_2BE;
#else
                state += ___CHAR_ENCODING_UCS_2LE-___CHAR_ENCODING_UCS_2;
                goto decode_next_UCS_2LE;
#endif
              }
            else
              {
                blo -= bytes_per_UCS_2;
                if (bytes_per_UCS_2 > 1 &&
                    blo == byte_buf)
                  result = ___INCOMPLETE_CHAR;
              }
            break;
          }

        case ___CHAR_ENCODING_UCS_2BE:
          DECODE_CHARS_LOOP(decode_next_UCS_2BE,
                            bytes_per_UCS_2,
                            0xffff,
                            get_UCS_2BE);

        case ___CHAR_ENCODING_UCS_2LE:
          DECODE_CHARS_LOOP(decode_next_UCS_2LE,
                            bytes_per_UCS_2,
                            0xffff,
                            get_UCS_2LE);

        case ___CHAR_ENCODING_UCS_4:
          {
            blo += bytes_per_UCS_4;
            if (blo <= bhi)
              {
                ___UCS_4 cle;
                c = get_UCS_4BE(-1);
                if (c == ___UNICODE_BOM)
                  {
                    state += ___CHAR_ENCODING_UCS_4BE-___CHAR_ENCODING_UCS_4;
                    goto decode_next_UCS_4BE;
                  }
                cle = ((((((c&0xff) << 8) +
                          ((c>>8)&0xff)) << 8) +
                        ((c>>16)&0xff)) << 8) +
                      ((c>>24)&0xff);
                if (cle == ___UNICODE_BOM)
                  {
                    state += ___CHAR_ENCODING_UCS_4LE-___CHAR_ENCODING_UCS_4;
                    goto decode_next_UCS_4LE;
                  }
                blo -= bytes_per_UCS_4;
#ifdef ___DEFAULT_CHAR_ENCODING_TO_BIG_ENDIAN
                state += ___CHAR_ENCODING_UCS_4BE-___CHAR_ENCODING_UCS_4;
                goto decode_next_UCS_4BE;
#else
                state += ___CHAR_ENCODING_UCS_4LE-___CHAR_ENCODING_UCS_4;
                goto decode_next_UCS_4LE;
#endif
              }
            else
              {
                blo -= bytes_per_UCS_4;
                if (bytes_per_UCS_4 > 1 &&
                    blo == byte_buf)
                  result = ___INCOMPLETE_CHAR;
              }
            break;
          }

        case ___CHAR_ENCODING_UCS_4BE:
          DECODE_CHARS_LOOP(decode_next_UCS_4BE,
                            bytes_per_UCS_4,
                            0xffffffff,
                            get_UCS_4BE);

        case ___CHAR_ENCODING_UCS_4LE:
          DECODE_CHARS_LOOP(decode_next_UCS_4LE,
                            bytes_per_UCS_4,
                            0xffffffff,
                            get_UCS_4LE);
        }
    }

  /*
   * When the byte buffer is empty or there is at least one byte that
   * was converted into some characters (but possibly 0 in the case of
   * a BOM), result == ___CONVERSION_DONE.  The byte_buf_avail and
   * char_buf_avail are adjusted to indicate how many bytes were
   * processed and how many characters were added to the character
   * buffer.  The conversion ends when the character buffer is filled
   * or the byte buffer is emptied or at the first byte sequence that
   * cannot form a complete character or that forms an illegal
   * character.  Errors are only reported when they are at the head of
   * the byte buffer (i.e. not even one valid character or BOM can be
   * formed from the byte buffer).  When the bytes in the byte buffer
   * don't form a complete character, result == ___INCOMPLETE_CHAR and
   * byte_buf_avail will be updated to *not* skip these bytes.  When
   * the bytes in the byte buffer form an illegal character, result ==
   * ___ILLEGAL_CHAR and byte_buf_avail will be updated to skip these
   * bytes.
   */

  *char_buf_avail = chi - clo;
  *byte_buf_avail = bhi - blo;
  *decoding_state = state;

  return result;
}


int chars_to_bytes
   ___P((___C *char_buf,
         int *char_buf_avail,
         ___U8 *byte_buf,
         int *byte_buf_avail,
         int *encoding_state),
        (char_buf,
         char_buf_avail,
         byte_buf,
         byte_buf_avail,
         encoding_state)
___C *char_buf;
int *char_buf_avail;
___U8 *byte_buf;
int *byte_buf_avail;
int *encoding_state;)
{
  int result;
  ___UCS_4 c;
  ___C *clo = char_buf;
  ___C *chi = char_buf + *char_buf_avail;
  ___U8 *blo = byte_buf;
  ___U8 *bhi = byte_buf + *byte_buf_avail;
  int state = *encoding_state;

  result = ___CONVERSION_DONE;

  /* empty character buffer as much as possible */

  if (clo < chi)
    {
      /* the character buffer is not empty */

      switch (___CHAR_ENCODING(state))
        {
        default:
        case ___CHAR_ENCODING_ASCII:
        case ___CHAR_ENCODING_ISO_8859_1:
          ENCODE_CHARS_LOOP(encode_next_ISO_8859_1,
                            bytes_per_ISO_8859_1,
                            max_ISO_8859_1,
                            put_ISO_8859_1);

        case ___CHAR_ENCODING_UTF_8:
          {
            encode_next_UTF_8:
            c = *clo++;
            if (___MAX_CHR <= max_UTF_8 ||
                c <= max_UTF_8)
              {
                blo += bytes_per_UTF_8;
                if (blo <= bhi)
                  {
                    if (c != char_EOL)
                      {
                        put_UTF_8(-1,c);
                        if (clo < chi)
                          goto encode_next_UTF_8;
                      }
                    else
                      {
                        ENCODE_EOL(encode_next_UTF_8,bytes_per_UTF_8,put_UTF_8);
                      }
                  }
                else
                  {
                    blo -= bytes_per_UTF_8;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else
              {
                ___U8 *p;
                int bytes;
                if      (c <= 0x7ff)      bytes = 2;
                else if (c <= 0xffff)     bytes = 3;
                else if (c <= 0x1fffff)   bytes = 4;
                else if (c <= 0x3ffffff)  bytes = 5;
                else if (c <= 0x7fffffff) bytes = 6;
                else
                  {
                    clo--;
                    if (clo == char_buf)
                      result = ___ILLEGAL_CHAR;
                    goto encode_chars_end;
                  }
                p = blo + bytes;
                if (p <= bhi)
                  {
                    blo = p;
                    switch (bytes)
                      {
                      case 6:  *--p = 0x80+(c&0x3f); c >>= 6;
                      case 5:  *--p = 0x80+(c&0x3f); c >>= 6;
                      case 4:  *--p = 0x80+(c&0x3f); c >>= 6;
                      case 3:  *--p = 0x80+(c&0x3f); c >>= 6;
                      default: *--p = 0x80+(c&0x3f); c >>= 6;
                      }
                    *--p = 0xff - (0xff>>bytes) + c;
                    if (clo < chi)
                      goto encode_next_UTF_8;
                  }
                else
                  {
                    clo--;
                    goto encode_chars_end;
                  }
              }
            break;
          }

        case ___CHAR_ENCODING_UTF_16:
          blo += bytes_per_UTF_16;
          if (blo > bhi)
            {
              blo -= bytes_per_UTF_16;
              goto encode_chars_end;
            }
#ifdef ___DEFAULT_CHAR_ENCODING_TO_BIG_ENDIAN
          put_UTF_16BE(-1,___UNICODE_BOM);
          state += ___CHAR_ENCODING_UTF_16BE-___CHAR_ENCODING_UTF_16;
          goto encode_next_UTF_16BE;
#else
          put_UTF_16LE(-1,___UNICODE_BOM);
          state += ___CHAR_ENCODING_UTF_16LE-___CHAR_ENCODING_UTF_16;
          goto encode_next_UTF_16LE;
#endif

        case ___CHAR_ENCODING_UTF_16BE:
          {
            encode_next_UTF_16BE:
            c = *clo++;
            if (c <= 0xdbff)
              {
                blo += bytes_per_UTF_16;
                if (blo <= bhi)
                  {
                    if (c != char_EOL)
                      {
                        put_UTF_16BE(-1,c);
                        if (clo < chi)
                          goto encode_next_UTF_16BE;
                      }
                    else
                      {
                        ENCODE_EOL(encode_next_UTF_16BE,bytes_per_UTF_16,put_UTF_16BE);
                      }
                  }
                else
                  {
                    blo -= bytes_per_UTF_16;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else if (c > 0xffff)
              {
                blo += 2*bytes_per_UTF_16;
                if (blo <= bhi)
                  {
                    c -= 0x10000;
                    put_UTF_16BE(-2,0xd800+((c>>10)&0x3ff));
                    put_UTF_16BE(-1,0xdc00+(c&0x3ff));
                    if (clo < chi)
                      goto encode_next_UTF_16BE;
                  }
                else
                  {
                    blo -= 2*bytes_per_UTF_16;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else if (c > 0xdfff)
              {
                blo += bytes_per_UTF_16;
                if (blo <= bhi)
                  {
                    put_UTF_16BE(-1,c);
                    if (clo < chi)
                      goto encode_next_UTF_16BE;
                  }
                else
                  {
                    blo -= bytes_per_UTF_16;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else
              {
                clo--;
                if (clo == char_buf)
                  result = ___ILLEGAL_CHAR;
                goto encode_chars_end;
              }
            break;
          }

        case ___CHAR_ENCODING_UTF_16LE:
          {
            encode_next_UTF_16LE:
            c = *clo++;
            if (c <= 0xdbff)
              {
                blo += bytes_per_UTF_16;
                if (blo <= bhi)
                  {
                    if (c != char_EOL)
                      {
                        put_UTF_16LE(-1,c);
                        if (clo < chi)
                          goto encode_next_UTF_16LE;
                      }
                    else
                      {
                        ENCODE_EOL(encode_next_UTF_16LE,bytes_per_UTF_16,put_UTF_16LE);
                      }
                  }
                else
                  {
                    blo -= bytes_per_UTF_16;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else if (c > 0xffff)
              {
                blo += 2*bytes_per_UTF_16;
                if (blo <= bhi)
                  {
                    c -= 0x10000;
                    put_UTF_16LE(-2,0xd800+((c>>10)&0x3ff));
                    put_UTF_16LE(-1,0xdc00+(c&0x3ff));
                    if (clo < chi)
                      goto encode_next_UTF_16LE;
                  }
                else
                  {
                    blo -= 2*bytes_per_UTF_16;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else if (c > 0xdfff)
              {
                blo += bytes_per_UTF_16;
                if (blo <= bhi)
                  {
                    put_UTF_16LE(-1,c);
                    if (clo < chi)
                      goto encode_next_UTF_16LE;
                  }
                else
                  {
                    blo -= bytes_per_UTF_16;
                    clo--;
                    goto encode_chars_end;
                  }
              }
            else
              {
                clo--;
                if (clo == char_buf)
                  result = ___ILLEGAL_CHAR;
                goto encode_chars_end;
              }
            break;
          }

        case ___CHAR_ENCODING_UTF_FALLBACK_ASCII:
        case ___CHAR_ENCODING_UTF_FALLBACK_ISO_8859_1:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_8:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_16:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_16BE:
        case ___CHAR_ENCODING_UTF_FALLBACK_UTF_16LE:
          blo += 3;
          if (blo > bhi)
            {
              blo -= 3;
              goto encode_chars_end;
            }
          put_UTF_8(-3,0xef); /* UTF-8 BOM */
          put_UTF_8(-2,0xbb);
          put_UTF_8(-1,0xbf);
          state += ___CHAR_ENCODING_UTF_8 - ___CHAR_ENCODING(state);
          goto encode_next_UTF_8;

        case ___CHAR_ENCODING_UCS_2:
          blo += bytes_per_UCS_2;
          if (blo > bhi)
            {
              blo -= bytes_per_UCS_2;
              goto encode_chars_end;
            }
#ifdef ___DEFAULT_CHAR_ENCODING_TO_BIG_ENDIAN
          put_UCS_2BE(-1,___UNICODE_BOM);
          state += ___CHAR_ENCODING_UCS_2BE-___CHAR_ENCODING_UCS_2;
          goto encode_next_UCS_2BE;
#else
          put_UCS_2LE(-1,___UNICODE_BOM);
          state += ___CHAR_ENCODING_UCS_2LE-___CHAR_ENCODING_UCS_2;
          goto encode_next_UCS_2LE;
#endif

        case ___CHAR_ENCODING_UCS_2BE:
          ENCODE_CHARS_LOOP(encode_next_UCS_2BE,
                            bytes_per_UCS_2,
                            max_UCS_2,
                            put_UCS_2BE);

        case ___CHAR_ENCODING_UCS_2LE:
          ENCODE_CHARS_LOOP(encode_next_UCS_2LE,
                            bytes_per_UCS_2,
                            max_UCS_2,
                            put_UCS_2LE);

        case ___CHAR_ENCODING_UCS_4:
          blo += bytes_per_UCS_4;
          if (blo > bhi)
            {
              blo -= bytes_per_UCS_4;
              goto encode_chars_end;
            }
#ifdef ___DEFAULT_CHAR_ENCODING_TO_BIG_ENDIAN
          put_UCS_4BE(-1,___UNICODE_BOM);
          state += ___CHAR_ENCODING_UCS_4BE-___CHAR_ENCODING_UCS_4;
          goto encode_next_UCS_4BE;
#else
          put_UCS_4LE(-1,___UNICODE_BOM);
          state += ___CHAR_ENCODING_UCS_4LE-___CHAR_ENCODING_UCS_4;
          goto encode_next_UCS_4LE;
#endif

        case ___CHAR_ENCODING_UCS_4BE:
          ENCODE_CHARS_LOOP(encode_next_UCS_4BE,
                            bytes_per_UCS_4,
                            max_UCS_4,
                            put_UCS_4BE);

        case ___CHAR_ENCODING_UCS_4LE:
          ENCODE_CHARS_LOOP(encode_next_UCS_4LE,
                            bytes_per_UCS_4,
                            max_UCS_4,
                            put_UCS_4LE);
        }
    }

  encode_chars_end:

  /*
   * When the character buffer is empty or there is at least one
   * character that was converted into some bytes, result ==
   * ___CONVERSION_DONE.  The char_buf_avail and byte_buf_avail are
   * adjusted to indicate how many characters were processed and how
   * many bytes were added to the byte buffer.  The conversion ends
   * when the byte buffer is filled or the character buffer is emptied
   * or past the first character that is illegal.  Errors are only
   * reported when they are at the head of the character buffer.  When
   * the first character is an illegal character, result ==
   * ___ILLEGAL_CHAR and char_buf_avail and byte_buf_avail will not
   * change.
   */

  *char_buf_avail = chi - clo;
  *byte_buf_avail = bhi - blo;
  *encoding_state = state;

  return result;
}


/*---------------------------------------------------------------------------*/

/* Scheme to C conversion */

/*
 * The following Scheme to C conversion functions may allocate memory
 * in the C heap using the ___alloc_rc function:
 *
 *    ___SCMOBJ_to_FUNCTION
 *    ___SCMOBJ_to_NONNULLFUNCTION
 *    ___SCMOBJ_to_STRING
 *    ___SCMOBJ_to_NONNULLSTRING
 *    ___SCMOBJ_to_NONNULLSTRINGLIST
 *    ___SCMOBJ_to_CHARSTRING
 *    ___SCMOBJ_to_NONNULLCHARSTRING
 *    ___SCMOBJ_to_NONNULLCHARSTRINGLIST
 *    ___SCMOBJ_to_ISO_8859_1STRING
 *    ___SCMOBJ_to_NONNULLISO_8859_1STRING
 *    ___SCMOBJ_to_NONNULLISO_8859_1STRINGLIST
 *    ___SCMOBJ_to_UTF_8STRING
 *    ___SCMOBJ_to_NONNULLUTF_8STRING
 *    ___SCMOBJ_to_NONNULLUTF_8STRINGLIST
 *    ___SCMOBJ_to_UTF_16STRING
 *    ___SCMOBJ_to_NONNULLUTF_16STRING
 *    ___SCMOBJ_to_NONNULLUTF_16STRINGLIST
 *    ___SCMOBJ_to_UCS_2STRING
 *    ___SCMOBJ_to_NONNULLUCS_2STRING
 *    ___SCMOBJ_to_NONNULLUCS_2STRINGLIST
 *    ___SCMOBJ_to_UCS_4STRING
 *    ___SCMOBJ_to_NONNULLUCS_4STRING
 *    ___SCMOBJ_to_NONNULLUCS_4STRINGLIST
 *    ___SCMOBJ_to_WCHARSTRING
 *    ___SCMOBJ_to_NONNULLWCHARSTRING
 *    ___SCMOBJ_to_NONNULLWCHARSTRINGLIST
 *    ___SCMOBJ_to_VARIANT
 *
 * The allocated objects contain a reference count.  This reference
 * count is managed with the following functions:
 *
 *     OBJECT        DECREMENT COUNT            INCREMENT COUNT
 *    function:     ___release_function        ___addref_function
 *    string:       ___release_string          ___addref_string
 *    string list:  ___release_string_list     ___addref_string_list
 *    variant:      ___release_variant         ___addref_variant
 *
 * All these functions can be passed a null pointer.  The memory
 * allocated to the object is freed when the reference count reaches
 * 0.
 */


/*
 * Release a Scheme foreign object, calling the object's release
 * function if it hasn't been done yet.
 */

___EXP_FUNC(___SCMOBJ,___release_foreign)
   ___P((___SCMOBJ obj),
        (obj)
___SCMOBJ obj;)
{
  ___SCMOBJ e;
  ___SCMOBJ (*release_fn) ___P((void *ptr),());
  void *ptr;
  ___SCMOBJ ___temp;

  if (!___TESTSUBTYPE(obj,___sFOREIGN))
    return ___FIX(___UNKNOWN_ERR);

  release_fn = ___CAST(___SCMOBJ (*) ___P((void *ptr),()),
                       ___FIELD(obj,___FOREIGN_RELEASE_FN));

  if (release_fn != 0)
    {
      ptr = ___CAST(void*,___FIELD(obj,___FOREIGN_PTR));
      ___FIELD(obj,___FOREIGN_RELEASE_FN) =
        ___CAST(___SCMOBJ,___CAST(___SCMOBJ (*) ___P((void *ptr),()),0));
      ___FIELD(obj,___FOREIGN_PTR) =
        ___CAST(___SCMOBJ,___CAST(void*,0));
      if ((e = release_fn (ptr)) != ___FIX(___NO_ERR))
        return e;
    }

  return ___FIX(___NO_ERR);
}


/* Release a C pointer created by the C-interface. */

___EXP_FUNC(___SCMOBJ,___release_pointer)
   ___P((void *x),
        (x)
void *x;)
{
  /*
   * Nothing needs to be done because the data pointed to by the
   * pointer is under the control of the "C world".
   */
  return ___FIX(___NO_ERR);
}


/* Release a C function created by the C-interface. */

___EXP_FUNC(___SCMOBJ,___release_function)
   ___P((void *x),
        (x)
void *x;)
{
  if (___is_a_c_closure (x))
    ___release_rc (x);
  return ___FIX(___NO_ERR);
}


/* Add a reference to a C function created by the C-interface. */

___EXP_FUNC(void,___addref_function)
   ___P((void *x),
        (x)
void *x;)
{
  if (___is_a_c_closure (x))
    ___addref_rc (x);
}


/* Release a C string created by the C-interface. */

___EXP_FUNC(void,___release_string)
   ___P((void *x),
        (x)
void *x;)
{
  ___release_rc (x);
}


/* Add a reference to a C string created by the C-interface. */

___EXP_FUNC(void,___addref_string)
   ___P((void *x),
        (x)
void *x;)
{
  ___addref_rc (x);
}


/* Release a C string list created by the C-interface. */

___EXP_FUNC(void,___release_string_list)
   ___P((void *x),
        (x)
void *x;)
{
  if (x != 0)
    {
      void **string_list = ___CAST(void**,x);
      void *elem;
      int i = 0;

      while ((elem = string_list[i++]) != 0)
        ___release_string (elem);

      ___release_rc (string_list);
    }
}


/* Add a reference to a C string list created by the C-interface. */

___EXP_FUNC(void,___addref_string_list)
   ___P((void *x),
        (x)
void *x;)
{
  ___addref_rc (x);
}


/* Release a variant created by the C-interface. */

___EXP_FUNC(void,___release_variant)
   ___P((___VARIANT x),
        (x)
___VARIANT x;)
{
  /*
   * Not yet implemented.
   */
}


/* Add a reference to a variant created by the C-interface. */

___EXP_FUNC(void,___addref_variant)
   ___P((___VARIANT x),
        (x)
___VARIANT x;)
{
  /*
   * Not yet implemented.
   */
}


/* Convert a Scheme integer to a C '___S64'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_S64)
   ___P((___PSD
         ___SCMOBJ obj,
         ___S64 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___S64 *x;
int arg_num;)
{
  ___S64 val;
  ___SCMOBJ ___temp;

  if (___FIXNUMP(obj))
    {
#if ___SCMOBJ_WIDTH == 32
      val = ___S64_from_SM32 (___INT(obj));
#else
      val = ___INT(obj);
#endif
    }
  else
    {
      if (!___BIGNUMP(obj))
        return ___FIX(___STOC_S64_ERR+arg_num);
      if (___BIGALENGTH(obj) == ___FIX(1))
        {
          ___BIGADIGIT d0 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),0);
#if ___BIG_ABASE_WIDTH == 32
          val = ___S64_from_SM32 (___CAST(___BIGADIGITSIGNED,d0));
#else
          val = ___CAST(___BIGADIGITSIGNED,d0);
#endif
        }
#if ___BIG_ABASE_WIDTH == 32
      else if (___BIGALENGTH(obj) == ___FIX(2))
        {
          ___BIGADIGIT d0 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),0);
          ___BIGADIGIT d1 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),1);
          val = ___S64_from_SM32_UM32 (___CAST(___BIGADIGITSIGNED,d1), d0);
        }
#endif
      else
        return ___FIX(___STOC_S64_ERR+arg_num);
    }

  *x = val;
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___U64'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_U64)
   ___P((___PSD
         ___SCMOBJ obj,
         ___U64 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___U64 *x;
int arg_num;)
{
  ___U64 val;
  ___SCMOBJ ___temp;

  if (___FIXNUMP(obj))
    {
      if (___FIXNEGATIVEP(obj))
        return ___FIX(___STOC_U64_ERR+arg_num);
      val = ___U64_from_ULONGLONG (___CAST(___ULONGLONG,___INT(obj)));
    }
  else
    {
      if (!___BIGNUMP(obj))
        return ___FIX(___STOC_U64_ERR+arg_num);
      if (___BIGALENGTH(obj) == ___FIX(1))
        {
          ___BIGADIGIT d0 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),0);
          if (___CAST(___BIGADIGITSIGNED,d0) < 0)
            return ___FIX(___STOC_U64_ERR+arg_num);
#if ___BIG_ABASE_WIDTH == 32
          val = ___U64_from_UM32 (d0);
#else
          val = d0;
#endif
        }
      else if (___BIGALENGTH(obj) == ___FIX(2))
        {
          ___BIGADIGIT d0 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),0);
          ___BIGADIGIT d1 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),1);
#if ___BIG_ABASE_WIDTH == 32
          if (___CAST(___BIGADIGITSIGNED,d1) < 0)
            return ___FIX(___STOC_U64_ERR+arg_num);
          val = ___U64_from_UM32_UM32 (d1, d0);
#else
          if (d1 != 0)
            return ___FIX(___STOC_U64_ERR+arg_num);
          val = d0;
#endif
        }
#if ___BIG_ABASE_WIDTH == 32
      else if (___BIGALENGTH(obj) == ___FIX(3))
        {
          ___BIGADIGIT d0 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),0);
          ___BIGADIGIT d1 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),1);
          ___BIGADIGIT d2 = ___BIGAFETCH(___BODY_AS(obj,___tSUBTYPED),2);
          if (d2 != 0)
            return ___FIX(___STOC_U64_ERR+arg_num);
          val = ___U64_from_UM32_UM32 (d1, d0);
        }
#endif
      else
        return ___FIX(___STOC_U64_ERR+arg_num);
    }

  *x = val;
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___S8'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_S8)
   ___P((___PSD
         ___SCMOBJ obj,
         ___S8 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___S8 *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR) ||
      !___S64_fits_in_width (val, 8))
    return ___FIX(___STOC_S8_ERR+arg_num);

  *x = ___CAST(___S8,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___U8'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_U8)
   ___P((___PSD
         ___SCMOBJ obj,
         ___U8 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___U8 *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR) ||
      !___U64_fits_in_width (val, 8))
    return ___FIX(___STOC_U8_ERR+arg_num);

  *x = ___CAST(___U8,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___S16'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_S16)
   ___P((___PSD
         ___SCMOBJ obj,
         ___S16 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___S16 *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR) ||
      !___S64_fits_in_width (val, 16))
    return ___FIX(___STOC_S16_ERR+arg_num);

  *x = ___CAST(___S16,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___U16'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_U16)
   ___P((___PSD
         ___SCMOBJ obj,
         ___U16 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___U16 *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR) ||
      !___U64_fits_in_width (val, 16))
    return ___FIX(___STOC_U16_ERR+arg_num);

  *x = ___CAST(___U16,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___S32'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_S32)
   ___P((___PSD
         ___SCMOBJ obj,
         ___S32 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___S32 *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR) ||
      !___S64_fits_in_width (val, 32))
    return ___FIX(___STOC_S32_ERR+arg_num);

  *x = ___CAST(___S32,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___U32'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_U32)
   ___P((___PSD
         ___SCMOBJ obj,
         ___U32 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___U32 *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR) ||
      !___U64_fits_in_width (val, 32))
    return ___FIX(___STOC_U32_ERR+arg_num);

  *x = ___CAST(___U32,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___F32'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_F32)
   ___P((___PSD
         ___SCMOBJ obj,
         ___F32 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___F32 *x;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___FLONUMP(obj))
    return ___FIX(___STOC_F32_ERR+arg_num);

  *x = ___FLONUM_VAL(obj);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C '___F64'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_F64)
   ___P((___PSD
         ___SCMOBJ obj,
         ___F64 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___F64 *x;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___FLONUMP(obj))
    return ___FIX(___STOC_F64_ERR+arg_num);

  *x = ___FLONUM_VAL(obj);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C 'char'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_CHAR)
   ___P((___PSD
         ___SCMOBJ obj,
         char *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
char *x;
int arg_num;)
{
  ___UCS_4 c;
  ___SCMOBJ ___temp;

  if (!___CHARP(obj) ||
      (c=UCS_4_to_uchar(___INT(obj))) > (1<<___CHAR_WIDTH)-1)
    return ___FIX(___STOC_CHAR_ERR+arg_num);

  *x = ___CAST(char,c);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C 'signed char'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_SCHAR)
   ___P((___PSD
         ___SCMOBJ obj,
         ___SCHAR *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___SCHAR *x;
int arg_num;)
{
  ___UCS_4 c;
  ___SCMOBJ ___temp;

  if (!___CHARP(obj) ||
      (c=UCS_4_to_uchar(___INT(obj))) > (1<<___CHAR_WIDTH)-1)
    return ___FIX(___STOC_SCHAR_ERR+arg_num);

  *x = ___CAST(___SCHAR,c);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C 'unsigned char'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UCHAR)
   ___P((___PSD
         ___SCMOBJ obj,
         unsigned char *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
unsigned char *x;
int arg_num;)
{
  ___UCS_4 c;
  ___SCMOBJ ___temp;

  if (!___CHARP(obj) ||
      (c=UCS_4_to_uchar(___INT(obj))) > (1<<___CHAR_WIDTH)-1)
    return ___FIX(___STOC_UCHAR_ERR+arg_num);

  *x = ___CAST(unsigned char,c);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C ISO-8859-1 encoded character. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_ISO_8859_1)
   ___P((___PSD
         ___SCMOBJ obj,
         ___ISO_8859_1 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___ISO_8859_1 *x;
int arg_num;)
{
  ___UCS_4 c;
  ___SCMOBJ ___temp;

  if (!___CHARP(obj) ||
      (c=___INT(obj)) > 0xff) /* ISO-8859-1 is 8 bits */
    return ___FIX(___STOC_ISO_8859_1_ERR+arg_num);

  *x = ___CAST(___ISO_8859_1,c);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C UCS-2 encoded character. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UCS_2)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_2 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_2 *x;
int arg_num;)
{
  ___UCS_4 c;
  ___SCMOBJ ___temp;

  if (!___CHARP(obj) ||
      (c=___INT(obj)) > 0xffff) /* UCS-2 is 16 bits */
    return ___FIX(___STOC_UCS_2_ERR+arg_num);

  *x = ___CAST(___UCS_2,c);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C UCS-4 encoded character. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UCS_4)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_4 *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_4 *x;
int arg_num;)
{
  ___UCS_4 c;
  ___SCMOBJ ___temp;

  if (!___CHARP(obj) ||
      (c=___INT(obj)) > 0x7fffffff) /* UCS-4 is 31 bits */
    return ___FIX(___STOC_UCS_4_ERR+arg_num);

  *x = ___CAST(___UCS_4,c);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme character to a C ___WCHAR encoded character. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_WCHAR)
   ___P((___PSD
         ___SCMOBJ obj,
         ___WCHAR *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___WCHAR *x;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___CHARP(obj))
    return ___FIX(___STOC_WCHAR_ERR+arg_num);

  {
#if ___WCHAR_MIN < 0
    ___SM32 c = ___CAST(___SM32,___INT(obj));
#else
    ___UM32 c = ___CAST(___UM32,___INT(obj));
#endif

#if 0 < ___WCHAR_MIN || ___MAX_CHR > ___WCHAR_MAX
#if 0 < ___WCHAR_MIN
#if ___MAX_CHR > ___WCHAR_MAX
    if (c < ___WCHAR_MIN || c > ___WCHAR_MAX)
#else
    if (c < ___WCHAR_MIN)
#endif
#else
    if (c > ___WCHAR_MAX)
#endif
      return ___FIX(___STOC_WCHAR_ERR+arg_num);
#endif

    *x = ___CAST(___WCHAR,c);
  }

  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'size_t'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_SIZE_T)
   ___P((___PSD
         ___SCMOBJ obj,
         ___SIZE_T *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___SIZE_T *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_SIZE_T_ERR+arg_num);

#if ___WS == 4
  if (!___U64_fits_in_width (val, 32))
    return ___FIX(___STOC_SIZE_T_ERR+arg_num);
#endif

  *x = ___CAST(___SIZE_T,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'ssize_t'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_SSIZE_T)
   ___P((___PSD
         ___SCMOBJ obj,
         ___SSIZE_T *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___SSIZE_T *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_SSIZE_T_ERR+arg_num);

#if ___WS == 4
  if (!___S64_fits_in_width (val, 32))
    return ___FIX(___STOC_SSIZE_T_ERR+arg_num);
#endif

  *x = ___CAST(___SSIZE_T,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'ptrdiff_t'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_PTRDIFF_T)
   ___P((___PSD
         ___SCMOBJ obj,
         ___PTRDIFF_T *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___PTRDIFF_T *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_PTRDIFF_T_ERR+arg_num);

#if ___WS == 4
  if (!___S64_fits_in_width (val, 32))
    return ___FIX(___STOC_PTRDIFF_T_ERR+arg_num);
#endif

  *x = ___CAST(___PTRDIFF_T,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'short'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_SHORT)
   ___P((___PSD
         ___SCMOBJ obj,
         short *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
short *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_SHORT_ERR+arg_num);

#if ___SHORT_WIDTH < 64
  if (!___S64_fits_in_width (val, ___SHORT_WIDTH))
    return ___FIX(___STOC_SHORT_ERR+arg_num);
#endif

  *x = ___CAST(short,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'unsigned short'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_USHORT)
   ___P((___PSD
         ___SCMOBJ obj,
         unsigned short *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
unsigned short *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_USHORT_ERR+arg_num);

#if ___SHORT_WIDTH < 64
  if (!___U64_fits_in_width (val, ___SHORT_WIDTH))
    return ___FIX(___STOC_USHORT_ERR+arg_num);
#endif

  *x = ___CAST(unsigned short,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'int'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_INT)
   ___P((___PSD
         ___SCMOBJ obj,
         int *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
int *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_INT_ERR+arg_num);

#if ___INT_WIDTH < 64
  if (!___S64_fits_in_width (val, ___INT_WIDTH))
    return ___FIX(___STOC_INT_ERR+arg_num);
#endif

  *x = ___CAST(int,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'unsigned int'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UINT)
   ___P((___PSD
         ___SCMOBJ obj,
         unsigned int *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
unsigned int *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_UINT_ERR+arg_num);

#if ___INT_WIDTH < 64
  if (!___U64_fits_in_width (val, ___INT_WIDTH))
    return ___FIX(___STOC_UINT_ERR+arg_num);
#endif

  *x = ___CAST(unsigned int,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'long'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_LONG)
   ___P((___PSD
         ___SCMOBJ obj,
         long *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
long *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_LONG_ERR+arg_num);

#if ___LONG_WIDTH < 64
  if (!___S64_fits_in_width (val, ___LONG_WIDTH))
    return ___FIX(___STOC_LONG_ERR+arg_num);
#endif

  *x = ___CAST(long,___S64_to_LONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'unsigned long'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_ULONG)
   ___P((___PSD
         ___SCMOBJ obj,
         unsigned long *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
unsigned long *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_ULONG_ERR+arg_num);

#if ___LONG_WIDTH < 64
  if (!___U64_fits_in_width (val, ___LONG_WIDTH))
    return ___FIX(___STOC_ULONG_ERR+arg_num);
#endif

  *x = ___CAST(unsigned long,___U64_to_ULONGLONG (val));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'long long'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_LONGLONG)
   ___P((___PSD
         ___SCMOBJ obj,
         ___LONGLONG *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___LONGLONG *x;
int arg_num;)
{
  ___S64 val;

  if (___SCMOBJ_to_S64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_LONGLONG_ERR+arg_num);

#if ___LONGLONG_WIDTH < 64
  if (!___S64_fits_in_width (val, ___LONGLONG_WIDTH))
    return ___FIX(___STOC_LONGLONG_ERR+arg_num);
#endif

  *x = ___S64_to_LONGLONG (val);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme integer to a C 'unsigned long long'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_ULONGLONG)
   ___P((___PSD
         ___SCMOBJ obj,
         ___ULONGLONG *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___ULONGLONG *x;
int arg_num;)
{
  ___U64 val;

  if (___SCMOBJ_to_U64 (___PSP obj, &val, arg_num) != ___FIX(___NO_ERR))
    return ___FIX(___STOC_ULONGLONG_ERR+arg_num);

#if ___LONGLONG_WIDTH < 64
  if (!___U64_fits_in_width (val, ___LONGLONG_WIDTH))
    return ___FIX(___STOC_ULONGLONG_ERR+arg_num);
#endif

  *x = ___U64_to_ULONGLONG (val);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme flonum to a C 'float'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_FLOAT)
   ___P((___PSD
         ___SCMOBJ obj,
         float *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
float *x;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___FLONUMP(obj))
    return ___FIX(___STOC_FLOAT_ERR+arg_num);

  *x = ___FLONUM_VAL(obj);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme flonum to a C 'double'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_DOUBLE)
   ___P((___PSD
         ___SCMOBJ obj,
         double *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
double *x;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___FLONUMP(obj))
    return ___FIX(___STOC_DOUBLE_ERR+arg_num);

  *x = ___FLONUM_VAL(obj);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme foreign object to a C pointer. */

___HIDDEN int can_convert_foreign_type
   ___P((___SCMOBJ src_tags,
         ___SCMOBJ dest_tags),
        (src_tags,
         dest_tags)
___SCMOBJ src_tags;
___SCMOBJ dest_tags;)
{
  ___SCMOBJ tag;
  ___SCMOBJ probe;
  ___SCMOBJ ___temp;

  if (src_tags == ___FAL || /* source type == void* */
      dest_tags == ___FAL) /* destination type == void* */
    return 1;

  tag = ___CAR(src_tags);
  probe = dest_tags;

  while (probe != ___NUL)
    {
      if (___EQP(tag,___CAR(probe)))
        return 1;
      probe = ___CDR(probe);
    }

  return 0;
}

         
___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_POINTER)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         ___SCMOBJ tags,
         int arg_num),
        (___PSV
         obj,
         x,
         tags,
         arg_num)
___PSDKR
___SCMOBJ obj;
void **x;
___SCMOBJ tags;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (___FALSEP(obj)) /* #f counts as NULL */
    {
      *x = 0;
      return ___FIX(___NO_ERR);
    }

  if (!___TESTSUBTYPE(obj,___sFOREIGN) ||
      !can_convert_foreign_type (___FIELD(obj,___FOREIGN_TAGS), tags))
    return ___FIX(___STOC_POINTER_ERR+arg_num);

  *x = ___CAST(void*,___FIELD(obj,___FOREIGN_PTR));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme foreign object to a nonnull C pointer. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLPOINTER)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         ___SCMOBJ tags,
         int arg_num),
        (___PSV
         obj,
         x,
         tags,
         arg_num)
___PSDKR
___SCMOBJ obj;
void **x;
___SCMOBJ tags;
int arg_num;)
{
  if (___SCMOBJ_to_POINTER (___PSP obj, x, tags, arg_num) != ___FIX(___NO_ERR) ||
      *x == 0)
    return ___FIX(___STOC_NONNULLPOINTER_ERR+arg_num);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme procedure to a C function. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_FUNCTION)
   ___P((___PSD
         ___SCMOBJ obj,
         void *converter,
         void **x,
         int arg_num),
        (___PSV
         obj,
         converter,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
void *converter;
void **x;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (___FALSEP(obj)) /* #f counts as NULL */
    *x = 0;
  else if (!___PROCEDUREP(obj))
    return ___FIX(___STOC_FUNCTION_ERR+arg_num);
  else
    {
      ___WORD *body = ___SUBTYPED_TO_BODY(obj);

      /*
       * Check if the Scheme procedure was defined with a c-define
       * form (in this case a statically allocated C function can be
       * used).
       */

      if (body[___LABEL_ENTRY_OR_DESCR] != obj /* closure? */
          || !___TESTHEADERTAG(body[-___LABEL_SIZE-1],___sVECTOR)/* not INTRO label? */
          || (*x = ___CAST(void*,body[-___LABEL_SIZE+___LABEL_HOST]))
             == 0) /* not "c-define"d? */
        {
          /*
           * The Scheme procedure was not defined with a c-define
           * form.  To convert the Scheme procedure to a C function we
           * have to dynamically allocate a "C closure" (this dynamic
           * code generation only works on some platforms).
           */

          if ((*x = ___make_c_closure (obj, converter)) == 0)
            return ___FIX(___STOC_FUNCTION_ERR+arg_num);
        }
    }

  return ___FIX(___NO_ERR);
}


/* Convert a Scheme procedure to a nonnull C function. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLFUNCTION)
   ___P((___PSD
         ___SCMOBJ obj,
         void *converter,
         void **x,
         int arg_num),
        (___PSV
         obj,
         converter,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
void *converter;
void **x;
int arg_num;)
{
  if (___SCMOBJ_to_FUNCTION (___PSP obj, converter, x, arg_num)
      != ___FIX(___NO_ERR) ||
      *x == 0)
    return ___FIX(___STOC_NONNULLFUNCTION_ERR+arg_num);
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme extended boolean to a C boolean. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_BOOL)
   ___P((___PSD
         ___SCMOBJ obj,
         ___BOOL *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___BOOL *x;
int arg_num;)
{
  *x = !___FALSEP(obj); /* #f is false, everything else counts as true */
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme foreign object to a C struct pointer. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_STRUCT)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         ___SCMOBJ tags,
         int arg_num),
        (___PSV
         obj,
         x,
         tags,
         arg_num)
___PSDKR
___SCMOBJ obj;
void **x;
___SCMOBJ tags;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___TESTSUBTYPE(obj,___sFOREIGN) ||
      !can_convert_foreign_type (___FIELD(obj,___FOREIGN_TAGS), tags))
    return ___FIX(___STOC_STRUCT_ERR+arg_num);

  *x = ___CAST(void*,___FIELD(obj,___FOREIGN_PTR));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme foreign object to a C union pointer. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UNION)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         ___SCMOBJ tags,
         int arg_num),
        (___PSV
         obj,
         x,
         tags,
         arg_num)
___PSDKR
___SCMOBJ obj;
void **x;
___SCMOBJ tags;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___TESTSUBTYPE(obj,___sFOREIGN) ||
      !can_convert_foreign_type (___FIELD(obj,___FOREIGN_TAGS), tags))
    return ___FIX(___STOC_UNION_ERR+arg_num);

  *x = ___CAST(void*,___FIELD(obj,___FOREIGN_PTR));
  return ___FIX(___NO_ERR);
}


/* Convert a Scheme foreign object to a C type pointer. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_TYPE)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         ___SCMOBJ tags,
         int arg_num),
        (___PSV
         obj,
         x,
         tags,
         arg_num)
___PSDKR
___SCMOBJ obj;
void **x;
___SCMOBJ tags;
int arg_num;)
{
  ___SCMOBJ ___temp;

  if (!___TESTSUBTYPE(obj,___sFOREIGN) ||
      !can_convert_foreign_type (___FIELD(obj,___FOREIGN_TAGS), tags))
    return ___FIX(___STOC_TYPE_ERR+arg_num);

  *x = ___CAST(void*,___FIELD(obj,___FOREIGN_PTR));
  return ___FIX(___NO_ERR);
}


/* Error code generation. */

___SCMOBJ err_code_from_char_encoding
   ___P((int char_encoding,
         ___BOOL ctos,
         int type,
         int arg_num),
        (char_encoding,
         ctos,
         type,
         arg_num)
int char_encoding;
___BOOL ctos;
int type;
int arg_num;)
{
  ___SCMOBJ *t;

  switch (char_encoding)
    {
    case ___CHAR_ENCODING_ISO_8859_1:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_ISO_8859_1STRING_ERR),
            ___FIX(___STOC_NONNULLISO_8859_1STRING_ERR),
            ___FIX(___STOC_NONNULLISO_8859_1STRINGLIST_ERR),
            ___FIX(___CTOS_ISO_8859_1STRING_ERR),
            ___FIX(___CTOS_NONNULLISO_8859_1STRING_ERR),
            ___FIX(___CTOS_NONNULLISO_8859_1STRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    case ___CHAR_ENCODING_UTF_8:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_UTF_8STRING_ERR),
            ___FIX(___STOC_NONNULLUTF_8STRING_ERR),
            ___FIX(___STOC_NONNULLUTF_8STRINGLIST_ERR),
            ___FIX(___CTOS_UTF_8STRING_ERR),
            ___FIX(___CTOS_NONNULLUTF_8STRING_ERR),
            ___FIX(___CTOS_NONNULLUTF_8STRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    case ___CHAR_ENCODING_UTF_16:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_UTF_16STRING_ERR),
            ___FIX(___STOC_NONNULLUTF_16STRING_ERR),
            ___FIX(___STOC_NONNULLUTF_16STRINGLIST_ERR),
            ___FIX(___CTOS_UTF_16STRING_ERR),
            ___FIX(___CTOS_NONNULLUTF_16STRING_ERR),
            ___FIX(___CTOS_NONNULLUTF_16STRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    case ___CHAR_ENCODING_UCS_2:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_UCS_2STRING_ERR),
            ___FIX(___STOC_NONNULLUCS_2STRING_ERR),
            ___FIX(___STOC_NONNULLUCS_2STRINGLIST_ERR),
            ___FIX(___CTOS_UCS_2STRING_ERR),
            ___FIX(___CTOS_NONNULLUCS_2STRING_ERR),
            ___FIX(___CTOS_NONNULLUCS_2STRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    case ___CHAR_ENCODING_UCS_4:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_UCS_4STRING_ERR),
            ___FIX(___STOC_NONNULLUCS_4STRING_ERR),
            ___FIX(___STOC_NONNULLUCS_4STRINGLIST_ERR),
            ___FIX(___CTOS_UCS_4STRING_ERR),
            ___FIX(___CTOS_NONNULLUCS_4STRING_ERR),
            ___FIX(___CTOS_NONNULLUCS_4STRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    case ___CHAR_ENCODING_WCHAR:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_WCHARSTRING_ERR),
            ___FIX(___STOC_NONNULLWCHARSTRING_ERR),
            ___FIX(___STOC_NONNULLWCHARSTRINGLIST_ERR),
            ___FIX(___CTOS_WCHARSTRING_ERR),
            ___FIX(___CTOS_NONNULLWCHARSTRING_ERR),
            ___FIX(___CTOS_NONNULLWCHARSTRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    case ___CHAR_ENCODING_NATIVE:
    default:
      {
        static ___SCMOBJ tbl[6] =
          { ___FIX(___STOC_CHARSTRING_ERR),
            ___FIX(___STOC_NONNULLCHARSTRING_ERR),
            ___FIX(___STOC_NONNULLCHARSTRINGLIST_ERR),
            ___FIX(___CTOS_CHARSTRING_ERR),
            ___FIX(___CTOS_NONNULLCHARSTRING_ERR),
            ___FIX(___CTOS_NONNULLCHARSTRINGLIST_ERR)
          };
        t = tbl;
        break;
      }
    }

  return ___FIXADD(t[ctos*3 + type], ___FIX(arg_num));
}


/* Convert a Scheme string to a nonnull C string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLSTRING)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         int arg_num,
         int char_encoding,
         int fudge),
        (___PSV
         obj,
         x,
         arg_num,
         char_encoding,
         fudge)
___PSDKR
___SCMOBJ obj;
void **x;
int arg_num;
int char_encoding;
int fudge;)
{
  ___SCMOBJ ___temp;

  if (!___STRINGP(obj))
    return err_code_from_char_encoding (char_encoding, 0, 1, arg_num);

  switch (char_encoding)
    {
    case ___CHAR_ENCODING_ISO_8859_1:
      {
        ___SIZE_T i, n;
        ___ISO_8859_1STRING r;

        n = ___INT(___STRINGLENGTH(obj));
        r = ___CAST(___ISO_8859_1STRING,
                    ___alloc_rc (___PSP
                                 n + 1 + fudge));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
            if (c == 0 || c > 0xff) /* ISO-8859-1 is 8 bits */
              {
                ___release_rc (r);
                return ___FIX(___STOC_ISO_8859_1STRING_ERR+arg_num);
              }
            r[i] = c;
          }

        r[n] = 0;

        *x = ___CAST(void*,r);

        break;
      }

    case ___CHAR_ENCODING_UTF_8:
      {
        ___SIZE_T i, bytes, n;
        ___UTF_8STRING r;
        ___UTF_8STRING p;

        bytes = 0;
        n = ___INT(___STRINGLENGTH(obj));

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
            int c_bytes = ___UTF_8_bytes (c);
            if (c == 0 || c_bytes == 0)
              return ___FIX(___STOC_UTF_8STRING_ERR+arg_num);
            bytes += c_bytes;
          }

        r = ___CAST(___UTF_8STRING,
                    ___alloc_rc (___PSP
                                 bytes + 1 + fudge));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        p = r;

        for (i=0; i<n; i++)
          ___UTF_8_put (&p, ___INT(___STRINGREF(obj,___FIX(i))));

        *p = 0;

        *x = ___CAST(void*,r);

        break;
      }

    case ___CHAR_ENCODING_UTF_16:
      {
        ___SIZE_T i, bytes, n;
        ___UTF_16STRING r;
        ___UTF_16STRING p;

        bytes = 0;
        n = ___INT(___STRINGLENGTH(obj));

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
            if (c > 0xffff)
              bytes += 4;
            else if ((c > 0 && c <= 0xd7ff) || c > 0xdbff)
              bytes += 2;
            else
              return ___FIX(___STOC_UTF_16STRING_ERR+arg_num);
          }

        r = ___CAST(___UTF_16STRING,
                    ___alloc_rc (___PSP
                                 bytes + 2 + fudge));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        p = r;

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
            if (c > 0xffff)
              {
                c -= 0x10000;
                *p++ = 0xd800 + ((c>>10)&0x3ff);
                *p++ = 0xdc00 + (c&0x3ff);
              }
            else
              *p++ = c;
          }

        *p = 0;

        *x = ___CAST(void*,r);

        break;
      }

    case ___CHAR_ENCODING_UCS_2:
      {
        ___SIZE_T i, n;
        ___UCS_2STRING r;

        n = ___INT(___STRINGLENGTH(obj));
        r = ___CAST(___UCS_2STRING,
                    ___alloc_rc (___PSP
                                 (n + 1 + fudge) * sizeof (___UCS_2)));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
            if (c == 0 || c > 0xffff) /* UCS-2 is 16 bits */
              {
                ___release_rc (r);
                return ___FIX(___STOC_UCS_2STRING_ERR+arg_num);
              }
            r[i] = c;
          }

        r[n] = 0;

        *x = ___CAST(void*,r);

        break;
      }

    case ___CHAR_ENCODING_UCS_4:
      {
        ___SIZE_T i, n;
        ___UCS_4STRING r;

        n = ___INT(___STRINGLENGTH(obj));
        r = ___CAST(___UCS_4STRING,
                    ___alloc_rc (___PSP
                                 (n + 1 + fudge) * sizeof (___UCS_4)));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = ___INT(___STRINGREF(obj,___FIX(i)));
            if (c == 0 || c > 0x7fffffff) /* UCS-4 is 31 bits */
              {
                ___release_rc (r);
                return ___FIX(___STOC_UCS_4STRING_ERR+arg_num);
              }
            r[i] = c;
          }

        r[n] = 0;

        *x = ___CAST(void*,r);

        break;
      }

    case ___CHAR_ENCODING_WCHAR:
      {
        ___SIZE_T i, n;
        ___WCHARSTRING r;

        n = ___INT(___STRINGLENGTH(obj));
        r = ___CAST(___WCHARSTRING,
                    ___alloc_rc (___PSP
                                 (n + 1 + fudge) * sizeof (___WCHAR)));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        for (i=0; i<n; i++)
          {
#if ___WCHAR_MIN < 0
            ___SM32 c = ___CAST(___SM32,___INT(___STRINGREF(obj,___FIX(i))));
#else
            ___UM32 c = ___CAST(___UM32,___INT(___STRINGREF(obj,___FIX(i))));
#endif

            if (c == 0
#if 0 < ___WCHAR_MIN
                || c < ___WCHAR_MIN
#endif
#if ___MAX_CHR > ___WCHAR_MAX
                || c > ___WCHAR_MAX
#endif
                )
              {
                ___release_rc (r);
                return ___FIX(___STOC_WCHARSTRING_ERR+arg_num);
              }

            r[i] = ___CAST(___WCHAR,c);
          }

        r[n] = 0;

        *x = ___CAST(void*,r);

        break;
      }

    case ___CHAR_ENCODING_NATIVE:
      {
        ___SIZE_T i, n;
        char *r;

        n = ___INT(___STRINGLENGTH(obj));
        r = ___CAST(char*,
                    ___alloc_rc (___PSP
                                 n + 1 + fudge));

        if (r == 0)
          return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

        for (i=0; i<n; i++)
          {
            ___UCS_4 c = UCS_4_to_uchar (___INT(___STRINGREF(obj,___FIX(i))));
            if (c == 0 || c > (1<<___CHAR_WIDTH)-1)
              {
                ___release_rc (r);
                return ___FIX(___STOC_CHARSTRING_ERR+arg_num);
              }
            r[i] = c;
          }

        r[n] = 0;

        *x = ___CAST(void*,r);

        break;
      }

    default:
      return ___FIX(___UNKNOWN_ERR);
    }

  return ___FIX(___NO_ERR);
}


/* Convert a Scheme string to a C string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         int arg_num,
         int char_encoding,
         int fudge),
        (___PSV
         obj,
         x,
         arg_num,
         char_encoding,
         fudge)
___PSDKR
___SCMOBJ obj;
void **x;
int arg_num;
int char_encoding;
int fudge;)
{
  ___SCMOBJ e;

  if (___FALSEP(obj)) /* #f counts as NULL */
    {
      *x = 0;
      return ___FIX(___NO_ERR);
    }

  if ((e = ___SCMOBJ_to_NONNULLSTRING (___PSP obj, x, arg_num, char_encoding, fudge))
      != ___FIX(___NO_ERR))
    if (e == err_code_from_char_encoding (char_encoding, 0, 1, arg_num))
      e = err_code_from_char_encoding (char_encoding, 0, 0, arg_num);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLSTRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         void **x,
         int arg_num,
         int char_encoding),
        (___PSV
         obj,
         x,
         arg_num,
         char_encoding)
___PSDKR
___SCMOBJ obj;
void **x;
int arg_num;
int char_encoding;)
{
  ___SCMOBJ ___temp;
  ___SCMOBJ e;
  void **string_list;
  ___SCMOBJ list1;
  ___SCMOBJ list2;
  int len;
  int i;

  list1 = obj;
  list2 = obj;
  len = 0;

  while (___PAIRP(list1)) /* compute length, checking for circular lists */
    {
      list1 = ___CDR(list1);
      len++;
      if (___EQP(list1,list2) || !___PAIRP(list1))
        break;
      list1 = ___CDR(list1);
      list2 = ___CDR(list2);
      len++;
    }

  if (!___NULLP(list1))
    return err_code_from_char_encoding (char_encoding, 0, 2, arg_num);

  string_list = ___CAST(void**,
                        ___alloc_rc (___PSP
                                     (len + 1) * sizeof (void*)));

  if (string_list == 0)
    return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

  e = ___FIX(___NO_ERR);
  list1 = obj;
  i = 0;

  while (i < len)
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSP
                  ___CAR(list1),
                  &string_list[i],
                  arg_num,
                  char_encoding,
                  0))
          != ___FIX(___NO_ERR))
        {
          if (e == err_code_from_char_encoding (char_encoding, 0, 1, arg_num))
            e = err_code_from_char_encoding (char_encoding, 0, 2, arg_num);
          break;
        }

      i++;
      list1 = ___CDR(list1);
    }

  string_list[i] = 0;

  if (e != ___FIX(___NO_ERR))
    {
      ___release_string_list (string_list);
      return e;
    }

  *x = string_list;

  return ___FIX(___NO_ERR);
}


/* Convert a Scheme string to a C 'char *'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_CHARSTRING)
   ___P((___PSD
         ___SCMOBJ obj,
         char **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
char **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_NATIVE,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(char*,result);

  return e;
}


/* Convert a Scheme string to a nonnull C 'char *'. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLCHARSTRING)
   ___P((___PSD
         ___SCMOBJ obj,
         char **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
char **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_NATIVE,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(char*,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C 'char *' list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLCHARSTRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         char ***x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
char ***x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_NATIVE))
      == ___FIX(___NO_ERR))
    *x = ___CAST(char**,result);

  return e;
}


/* Convert a Scheme string to a C ISO-8859-1 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_ISO_8859_1STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___ISO_8859_1STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___ISO_8859_1STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_ISO_8859_1,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___ISO_8859_1STRING,result);

  return e;
}


/* Convert a Scheme string to a nonnull C ISO-8859-1 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLISO_8859_1STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___ISO_8859_1STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___ISO_8859_1STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_ISO_8859_1,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___ISO_8859_1STRING,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C ISO-8859-1 encoded character string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLISO_8859_1STRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         ___ISO_8859_1STRING **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___ISO_8859_1STRING **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_ISO_8859_1))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___ISO_8859_1STRING*,result);

  return e;
}


/* Convert a Scheme string to a C UTF-8 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UTF_8STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UTF_8STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UTF_8STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UTF_8,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UTF_8STRING,result);

  return e;
}


/* Convert a Scheme string to a nonnull C UTF-8 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUTF_8STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UTF_8STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UTF_8STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UTF_8,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UTF_8STRING,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C UTF-8 encoded character string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUTF_8STRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UTF_8STRING **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UTF_8STRING **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UTF_8))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UTF_8STRING*,result);

  return e;
}


/* Convert a Scheme string to a C UTF-16 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UTF_16STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UTF_16STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UTF_16STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UTF_16,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UTF_16STRING,result);

  return e;
}


/* Convert a Scheme string to a nonnull C UTF-16 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUTF_16STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UTF_16STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UTF_16STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UTF_16,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UTF_16STRING,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C UTF-16 encoded character string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUTF_16STRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UTF_16STRING **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UTF_16STRING **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UTF_16))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UTF_16STRING*,result);

  return e;
}


/* Convert a Scheme string to a C UCS-2 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UCS_2STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_2STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_2STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UCS_2,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UCS_2STRING,result);

  return e;
}


/* Convert a Scheme string to a nonnull C UCS-2 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUCS_2STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_2STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_2STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UCS_2,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UCS_2STRING,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C UCS-2 encoded character string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUCS_2STRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_2STRING **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_2STRING **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UCS_2))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UCS_2STRING*,result);

  return e;
}


/* Convert a Scheme string to a C UCS-4 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_UCS_4STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_4STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_4STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UCS_4,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UCS_4STRING,result);

  return e;
}


/* Convert a Scheme string to a nonnull C UCS-4 encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUCS_4STRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_4STRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_4STRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UCS_4,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UCS_4STRING,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C UCS-4 encoded character string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLUCS_4STRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         ___UCS_4STRING **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___UCS_4STRING **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_UCS_4))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___UCS_4STRING*,result);

  return e;
}


/* Convert a Scheme string to a C ___WCHAR encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_WCHARSTRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___WCHARSTRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___WCHARSTRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_STRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_WCHAR,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___WCHARSTRING,result);

  return e;
}


/* Convert a Scheme string to a nonnull C ___WCHAR encoded character string. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLWCHARSTRING)
   ___P((___PSD
         ___SCMOBJ obj,
         ___WCHARSTRING *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___WCHARSTRING *x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_WCHAR,
              0))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___WCHARSTRING,result);

  return e;
}


/* Convert a Scheme list of strings to a nonnull C ___WCHAR encoded character string list. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_NONNULLWCHARSTRINGLIST)
   ___P((___PSD
         ___SCMOBJ obj,
         ___WCHARSTRING **x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___WCHARSTRING **x;
int arg_num;)
{
  void *result;
  ___SCMOBJ e;

  if ((e = ___SCMOBJ_to_NONNULLSTRINGLIST
             (___PSP
              obj,
              &result,
              arg_num,
              ___CHAR_ENCODING_WCHAR))
      == ___FIX(___NO_ERR))
    *x = ___CAST(___WCHARSTRING*,result);

  return e;
}


/* Convert a Scheme object to a variant. */

___EXP_FUNC(___SCMOBJ,___SCMOBJ_to_VARIANT)
   ___P((___PSD
         ___SCMOBJ obj,
         ___VARIANT *x,
         int arg_num),
        (___PSV
         obj,
         x,
         arg_num)
___PSDKR
___SCMOBJ obj;
___VARIANT *x;
int arg_num;)
{
  /*
   * Not yet implemented.
   */
  return ___FIX(___STOC_VARIANT_ERR+arg_num);
}


/*---------------------------------------------------------------------------*/

/* C to Scheme conversion */

/*
 * The C to Scheme conversion functions may allocate memory in the
 * Scheme heap.  When the first parameter '___ps' is NULL, the object
 * is permanently allocated.  When '___ps' is not NULL, the object is
 * a still object with a reference count of 1 allocated in that
 * processor's heap.  The only special processing that must be
 * performed by the caller of a C to Scheme conversion function is a
 * call to '___release_scmobj' when the caller no longer needs a
 * reference to the object.  This call is generated automatically by
 * the C-interface.
 */


/* Convert a C '___S64' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___S64_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___S64 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___S64 x;
___SCMOBJ *obj;
int arg_num;)
{
  ___SCMOBJ r;

  if (___S64_fits_in_width (x, ___SCMOBJ_WIDTH-___TB))
    r = ___FIX(___S64_to_LONGLONG (x));
  else
    {
#if ___BIG_ABASE_WIDTH == 32
      int n;
      ___BIGADIGIT d0 = ___S64_lo32 (x);
      ___BIGADIGIT d1 = ___CAST_U32(___S64_hi32 (x));

      if (___CAST(___BIGADIGITSIGNED,d0) < 0)
        n = 1 + (d1 != ___BIG_ABASE_MIN_1);
      else
        n = 1 + (d1 != 0);

      r = ___alloc_scmobj (___ps, ___sBIGNUM, n<<2);

      if (___FIXNUMP(r))
        {
          *obj = ___FAL;
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
        }

      ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),0,d0);
      if (n == 2)
        ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),1,d1);
#else
      int n = 1;
      ___BIGADIGIT d0 = x;

      r = ___alloc_scmobj (___ps, ___sBIGNUM, n<<3);

      if (___FIXNUMP(r))
        {
          *obj = ___FAL;
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
        }

      ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),0,d0);
#endif
    }

  *obj = r;
  return ___FIX(___NO_ERR);
}


/* Convert a C '___U64' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___U64_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___U64 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___U64 x;
___SCMOBJ *obj;
int arg_num;)
{
  ___SCMOBJ r;

  if (___U64_fits_in_width (x, ___SCMOBJ_WIDTH-___TB-1))
    r = ___FIX(___U64_to_ULONGLONG (x));
  else
    {
#if ___BIG_ABASE_WIDTH == 32
      int n;
      ___BIGADIGIT d0 = ___U64_lo32 (x);
      ___BIGADIGIT d1 = ___U64_hi32 (x);

      if (d1 == 0)
        n = 1 + (___CAST(___BIGADIGITSIGNED,d0) < 0);
      else
        n = 2 + (___CAST(___BIGADIGITSIGNED,d1) < 0);

      r = ___alloc_scmobj (___ps, ___sBIGNUM, n<<2);

      if (___FIXNUMP(r))
        {
          *obj = ___FAL;
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
        }

      ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),0,d0);
      if (n >= 2)
        {
          ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),1,d1);
          if (n >= 3)
            ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),2,0);
        }
#else
      int n;
      ___BIGADIGIT d0 = x;

      n = 1 + (___CAST(___BIGADIGITSIGNED,d0) < 0);

      r = ___alloc_scmobj (___ps, ___sBIGNUM, n<<3);

      if (___FIXNUMP(r))
        {
          *obj = ___FAL;
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
        }

      ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),0,d0);
      if (n == 2)
        ___BIGASTORE(___BODY_AS(r,___tSUBTYPED),1,0);
#endif
    }

  *obj = r;
  return ___FIX(___NO_ERR);
}


/* Convert a C '___S8' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___S8_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___S8 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___S8 x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a '___S8' always fits in a Scheme
   * fixnum.
   */
  *obj = ___FIX(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C '___U8' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___U8_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___U8 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___U8 x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a '___U8' always fits in a Scheme
   * fixnum.
   */
  *obj = ___FIX(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C '___S16' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___S16_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___S16 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___S16 x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a '___S16' always fits in a Scheme
   * fixnum.
   */
  *obj = ___FIX(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C '___U16' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___U16_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___U16 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___U16 x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a '___U16' always fits in a Scheme
   * fixnum.
   */
  *obj = ___FIX(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C '___S32' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___S32_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___S32 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___S32 x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_SM32 (x), obj, arg_num);
}


/* Convert a C '___U32' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___U32_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___U32 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___U32 x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___U64_to_SCMOBJ (___ps, ___U64_from_UM32 (x), obj, arg_num);
}


/* Convert a C '___F64' to a Scheme flonum. */

___EXP_FUNC(___SCMOBJ,___F64_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___F64 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___F64 x;
___SCMOBJ *obj;
int arg_num;)
{
  ___SCMOBJ r = ___alloc_scmobj (___ps, ___sFLONUM, ___FLONUM_SIZE<<___LWS);

  if (___FIXNUMP(r))
    {
      *obj = ___FAL;
      return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
    }

  ___FLONUM_VAL(r) = x;

  *obj = r;
  return ___FIX(___NO_ERR);
}


/* Convert a C '___F32' to a Scheme flonum. */

___EXP_FUNC(___SCMOBJ,___F32_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___F32 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___F32 x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___F64_to_SCMOBJ (___ps, ___CAST(___F64,x), obj, arg_num);
}


/* Convert a C 'char' to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___CHAR_to_SCMOBJ)
   ___P((___processor_state ___ps,
         char x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
char x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a 'char' always fits in
   * a Scheme character.
   */
  *obj = ___CHR(uchar_to_UCS_4 (___CAST(unsigned char,x)));
  return ___FIX(___NO_ERR);
}


/* Convert a C 'signed char' to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___SCHAR_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___SCHAR x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___SCHAR x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a 'signed char' always fits in
   * a Scheme character.
   */
  *obj = ___CHR(uchar_to_UCS_4 (___CAST(unsigned char,x)));
  return ___FIX(___NO_ERR);
}


/* Convert a C 'unsigned char' to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___UCHAR_to_SCMOBJ)
   ___P((___processor_state ___ps,
         unsigned char x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
unsigned char x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because an 'unsigned char' always fits in
   * a Scheme character.
   */
  *obj = ___CHR(uchar_to_UCS_4 (x));
  return ___FIX(___NO_ERR);
}


/* Convert a C ISO-8859-1 encoded character to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___ISO_8859_1_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___ISO_8859_1 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___ISO_8859_1 x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * No error possible because a ISO-8859-1 character always fits in
   * a Scheme character.
   */
  *obj = ___CHR(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C UCS-2 encoded character to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___UCS_2_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_2 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_2 x;
___SCMOBJ *obj;
int arg_num;)
{
#if ___MAX_CHR < 0xffff
  if (x > ___MAX_CHR) /* check that we are not truncating the character */
    {
      *obj = ___FAL;
      return ___FIX(___CTOS_UCS_2_ERR+arg_num);
    }
#endif

  *obj = ___CHR(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C UCS-4 encoded character to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___UCS_4_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_4 x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_4 x;
___SCMOBJ *obj;
int arg_num;)
{
  if (x > ___MAX_CHR) /* check that we are not truncating the character */
    {
      *obj = ___FAL;
      return ___FIX(___CTOS_UCS_4_ERR+arg_num);
    }

  *obj = ___CHR(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C ___WCHAR encoded character to a Scheme character. */

___EXP_FUNC(___SCMOBJ,___WCHAR_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___WCHAR x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___WCHAR x;
___SCMOBJ *obj;
int arg_num;)
{
#if ___WCHAR_MIN < 0 || ___WCHAR_MAX > ___MAX_CHR
#if ___WCHAR_MIN < 0
#if ___WCHAR_MAX > ___MAX_CHR
  if (x < 0 || x > ___MAX_CHR)
#else
  if (x < 0)
#endif
#else
  if (x > ___MAX_CHR)
#endif
    {
      *obj = ___FAL;
      return ___FIX(___CTOS_WCHAR_ERR+arg_num);
    }
#endif

  *obj = ___CHR(x);
  return ___FIX(___NO_ERR);
}


/* Convert a C 'size_t' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___SIZE_T_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___SIZE_T x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___SIZE_T x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___U64_to_SCMOBJ (___ps, ___U64_from_ULONGLONG (___CAST(___ULONGLONG,x)), obj, arg_num);
}


/* Convert a C 'ssize_t' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___SSIZE_T_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___SSIZE_T x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___SSIZE_T x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_LONGLONG (___CAST(___LONGLONG,x)), obj, arg_num);
}


/* Convert a C 'ptrdiff_t' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___PTRDIFF_T_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___PTRDIFF_T x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___PTRDIFF_T x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_LONGLONG (___CAST(___LONGLONG,x)), obj, arg_num);
}


/* Convert a C 'short' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___SHORT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         short x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
short x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_LONGLONG (___CAST(___LONGLONG,x)), obj, arg_num);
}


/* Convert a C 'unsigned short' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___USHORT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         unsigned short x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
unsigned short x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___U64_to_SCMOBJ (___ps, ___U64_from_ULONGLONG (___CAST(___ULONGLONG,x)), obj, arg_num);
}


/* Convert a C 'int' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___INT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         int x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
int x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_LONGLONG (___CAST(___LONGLONG,x)), obj, arg_num);
}


/* Convert a C 'unsigned int' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___UINT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         unsigned int x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
unsigned int x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___U64_to_SCMOBJ (___ps, ___U64_from_ULONGLONG (___CAST(___ULONGLONG,x)), obj, arg_num);
}


/* Convert a C 'long' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___LONG_to_SCMOBJ)
   ___P((___processor_state ___ps,
         long x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
long x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_LONGLONG (___CAST(___LONGLONG,x)), obj, arg_num);
}


/* Convert a C 'unsigned long' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___ULONG_to_SCMOBJ)
   ___P((___processor_state ___ps,
         unsigned long x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
unsigned long x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___U64_to_SCMOBJ (___ps, ___U64_from_ULONGLONG (___CAST(___ULONGLONG,x)), obj, arg_num);
}


/* Convert a C 'long long' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___LONGLONG_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___LONGLONG x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___LONGLONG x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___S64_to_SCMOBJ (___ps, ___S64_from_LONGLONG (x), obj, arg_num);
}


/* Convert a C 'unsigned long long' to a Scheme integer. */

___EXP_FUNC(___SCMOBJ,___ULONGLONG_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___ULONGLONG x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___ULONGLONG x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___U64_to_SCMOBJ (___ps, ___U64_from_ULONGLONG (x), obj, arg_num);
}


/* Convert a C 'float' to a Scheme flonum. */

___EXP_FUNC(___SCMOBJ,___FLOAT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         float x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
float x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___F64_to_SCMOBJ (___ps, ___CAST(___F64,x), obj, arg_num);
}


/* Convert a C 'double' to a Scheme flonum. */

___EXP_FUNC(___SCMOBJ,___DOUBLE_to_SCMOBJ)
   ___P((___processor_state ___ps,
         double x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
double x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___F64_to_SCMOBJ (___ps, ___CAST(___F64,x), obj, arg_num);
}


/* Convert a C pointer to a Scheme foreign object. */

___EXP_FUNC(___SCMOBJ,___POINTER_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ tags,
         ___SCMOBJ (*release_fn) ___P((void *ptr),()),
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         tags,
         release_fn,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ tags;
___SCMOBJ (*release_fn) ___P((void *ptr),());
___SCMOBJ *obj;
int arg_num;)
{
  if (x == 0)
    *obj = ___FAL; /* #f counts as NULL */
  else
    {
      ___SCMOBJ r = ___alloc_scmobj (___ps, ___sFOREIGN, ___FOREIGN_SIZE<<___LWS);
      if (___FIXNUMP(r))
        {
          *obj = ___FAL;
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
        }
      ___FIELD(r,___FOREIGN_TAGS) = tags;
      ___FIELD(r,___FOREIGN_RELEASE_FN) = ___CAST(___SCMOBJ,release_fn);
      ___FIELD(r,___FOREIGN_PTR) = ___CAST(___SCMOBJ,x);
      *obj = r;
    }
  return ___FIX(___NO_ERR);
}


/* Convert a nonnull C pointer to a Scheme foreign object. */

___EXP_FUNC(___SCMOBJ,___NONNULLPOINTER_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ tags,
         ___SCMOBJ (*release_fn) ___P((void *ptr),()),
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         tags,
         release_fn,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ tags;
___SCMOBJ (*release_fn) ___P((void *ptr),());
___SCMOBJ *obj;
int arg_num;)
{
  if (x == 0)
    {
      *obj = ___FAL;
      return ___FIX(___CTOS_NONNULLPOINTER_ERR+arg_num);
    }
  return ___POINTER_to_SCMOBJ (___ps, x, tags, release_fn, obj, arg_num);
}


/* Convert a C function to a Scheme procedure. */

___EXP_FUNC(___SCMOBJ,___FUNCTION_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ *obj;
int arg_num;)
{
  if (x == 0)
    {
      *obj = ___FAL; /* #f counts as NULL */
      return ___FIX(___NO_ERR);
    }
  /*
   * At present, arbitrary C functions cannot be converted to Scheme
   * functions.
   */
  *obj = ___FAL;
  return ___FIX(___CTOS_FUNCTION_ERR+arg_num);
}


/* Convert a nonnull C function to a Scheme procedure. */

___EXP_FUNC(___SCMOBJ,___NONNULLFUNCTION_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ *obj;
int arg_num;)
{
  if (x == 0)
    {
      *obj = ___FAL;
      return ___FIX(___CTOS_NONNULLFUNCTION_ERR+arg_num);
    }
  return ___FUNCTION_to_SCMOBJ (___ps, x, obj, arg_num);
}


/* Convert a C struct pointer to a Scheme foreign object. */

___EXP_FUNC(___SCMOBJ,___STRUCT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ tags,
         ___SCMOBJ (*release_fn) ___P((void *ptr),()),
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         tags,
         release_fn,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ tags;
___SCMOBJ (*release_fn) ___P((void *ptr),());
___SCMOBJ *obj;
int arg_num;)
{
  ___SCMOBJ e;
  if (x == 0)
    {
      *obj = ___FAL;
      e = ___FIX(___CTOS_STRUCT_ERR+arg_num);
    }
  else if ((e = ___POINTER_to_SCMOBJ (___ps, x, tags, release_fn, obj, arg_num))
           != ___FIX(___NO_ERR))
    release_fn (x);
  return e;
}


/* Convert a C union pointer to a Scheme foreign object. */

___EXP_FUNC(___SCMOBJ,___UNION_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ tags,
         ___SCMOBJ (*release_fn) ___P((void *ptr),()),
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         tags,
         release_fn,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ tags;
___SCMOBJ (*release_fn) ___P((void *ptr),());
___SCMOBJ *obj;
int arg_num;)
{
  ___SCMOBJ e;
  if (x == 0)
    {
      *obj = ___FAL;
      e = ___FIX(___CTOS_UNION_ERR+arg_num);
    }
  else if ((e = ___POINTER_to_SCMOBJ (___ps, x, tags, release_fn, obj, arg_num))
           != ___FIX(___NO_ERR))
    release_fn (x);
  return e;
}


/* Convert a C type pointer to a Scheme foreign object. */

___EXP_FUNC(___SCMOBJ,___TYPE_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ tags,
         ___SCMOBJ (*release_fn) ___P((void *ptr),()),
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         tags,
         release_fn,
         obj,
         arg_num)
___processor_state ___ps;
void *x;
___SCMOBJ tags;
___SCMOBJ (*release_fn) ___P((void *ptr),());
___SCMOBJ *obj;
int arg_num;)
{
  ___SCMOBJ e;
  if (x == 0)
    {
      *obj = ___FAL;
      e = ___FIX(___CTOS_TYPE_ERR+arg_num);
    }
  else if ((e = ___POINTER_to_SCMOBJ (___ps, x, tags, release_fn, obj, arg_num))
           != ___FIX(___NO_ERR))
    release_fn (x);
  return e;
}


/* Convert a C extended boolean to a Scheme boolean. */

___EXP_FUNC(___SCMOBJ,___BOOL_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___BOOL x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___BOOL x;
___SCMOBJ *obj;
int arg_num;)
{
  *obj = x ? ___TRU : ___FAL;
  return ___FIX(___NO_ERR);
}


/* Convert a nonnull C string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLSTRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ *obj,
         int arg_num,
         int char_encoding),
        (___ps,
         x,
         obj,
         arg_num,
         char_encoding)
___processor_state ___ps;
void *x;
___SCMOBJ *obj;
int arg_num;
int char_encoding;)
{
  ___SCMOBJ result = ___FAL;
  ___SIZE_T i, n = 0;

  if (x == 0)
    return err_code_from_char_encoding (char_encoding, 1, 1, arg_num);

  switch (char_encoding)
    {
    case ___CHAR_ENCODING_ISO_8859_1:
      {
        ___ISO_8859_1STRING str = ___CAST(___ISO_8859_1STRING,x);

        while (str[n] != 0)
          n++;

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            for (i=0; i<n; i++)
              {
                /*
                 * No error possible because a ISO-8859-1 character
                 * always fits in a Scheme character.
                 */
                ___UCS_4 c = str[i];
                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    case ___CHAR_ENCODING_UTF_8:
      {
        ___UTF_8STRING str = ___CAST(___UTF_8STRING,x);
        ___UTF_8STRING p = str;

        while (___UTF_8_get (&p) != 0) /* advance until end or error */
          n++;

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            p = str;

            for (i=0; i<n; i++)
              {
                ___UTF_8STRING start = p;
                ___UCS_4 c = ___UTF_8_get (&p);
                if (p == start || c > ___MAX_CHR)
                  {
                    ___release_scmobj (result);
                    *obj = ___FAL;
                    return ___FIX(___CTOS_NONNULLUTF_8STRING_ERR+arg_num);
                  }
                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    case ___CHAR_ENCODING_UTF_16:
      {
        ___UTF_16STRING str = ___CAST(___UTF_16STRING,x);
        ___UTF_16STRING p = str;

        for (;;)
          {
            ___UCS_4 c = *p++;
            if (c == 0)
              break;
            if (c > 0xd7ff && c <= 0xdfff)
              {
                if (c > 0xdbff)
                  return ___FIX(___CTOS_NONNULLUTF_16STRING_ERR+arg_num);
                c = *p++;
                if (c <= 0xdbff || c > 0xdfff)
                  return ___FIX(___CTOS_NONNULLUTF_16STRING_ERR+arg_num);
              }
            n++;
          }

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            p = str;

            for (i=0; i<n; i++)
              {
                ___UCS_4 c = *p++;
                if (c > 0xd7ff && c <= 0xdfff)
                  c = (c << 10) + *p++ -
                      ((0xd800 << 10) + 0xdc00 - 0x10000);
                if (c > ___MAX_CHR)
                  {
                    ___release_scmobj (result);
                    *obj = ___FAL;
                    return ___FIX(___CTOS_NONNULLUTF_16STRING_ERR+arg_num);
                  }
                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    case ___CHAR_ENCODING_UCS_2:
      {
        ___UCS_2STRING str = ___CAST(___UCS_2STRING,x);

        while (str[n] != 0)
          n++;

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            for (i=0; i<n; i++)
              {
                ___UCS_4 c = str[i];
                if (c > ___MAX_CHR)
                  {
                    ___release_scmobj (result);
                    *obj = ___FAL;
                    return ___FIX(___CTOS_NONNULLUCS_2STRING_ERR+arg_num);
                  }
                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    case ___CHAR_ENCODING_UCS_4:
      {
        ___UCS_4STRING str = ___CAST(___UCS_4STRING,x);

        while (str[n] != 0)
          n++;

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            for (i=0; i<n; i++)
              {
                ___UCS_4 c = str[i];
                if (c > ___MAX_CHR)
                  {
                    ___release_scmobj (result);
                    *obj = ___FAL;
                    return ___FIX(___CTOS_NONNULLUCS_4STRING_ERR+arg_num);
                  }
                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    case ___CHAR_ENCODING_WCHAR:
      {
        ___WCHARSTRING str = ___CAST(___WCHARSTRING,x);

        while (str[n] != 0)
          n++;

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            for (i=0; i<n; i++)
              {
#if ___WCHAR_MIN < 0
                ___SM32 c = ___CAST(___SM32,str[i]);
#else
                ___UM32 c = ___CAST(___UM32,str[i]);
#endif

#if ___WCHAR_MIN < 0 || ___WCHAR_MAX > ___MAX_CHR
#if ___WCHAR_MIN < 0
#if ___WCHAR_MAX > ___MAX_CHR
                if (c < 0 || c > ___MAX_CHR)
#else
                if (c < 0)
#endif
#else
                if (c > ___MAX_CHR)
#endif
                  {
                    ___release_scmobj (result);
                    *obj = ___FAL;
                    return ___FIX(___CTOS_NONNULLWCHARSTRING_ERR+arg_num);
                  }
#endif

                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    case ___CHAR_ENCODING_NATIVE:
      {
        char *str = ___CAST(char*,x);

        while (str[n] != 0)
          n++;

        result = ___alloc_scmobj (___ps, ___sSTRING, n<<___LCS);

        if (___FIXNUMP(result))
          result = ___FAL;
        else
          {
            for (i=0; i<n; i++)
              {
                ___UCS_4 c = uchar_to_UCS_4 (___CAST(unsigned char,str[i]));
                if (c > ___MAX_CHR)
                  {
                    ___release_scmobj (result);
                    *obj = ___FAL;
                    return ___FIX(___CTOS_NONNULLCHARSTRING_ERR+arg_num);
                  }
                ___STRINGSET(result,___FIX(i),___CHR(c))
              }
          }

        break;
      }

    default:
      return ___FIX(___UNKNOWN_ERR);
    }

  *obj = result;

  if (result == ___FAL)
    return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

  return ___FIX(___NO_ERR);
}


/* Convert a nonnull C string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ *obj,
         int arg_num,
         int char_encoding),
        (___ps,
         x,
         obj,
         arg_num,
         char_encoding)
___processor_state ___ps;
void *x;
___SCMOBJ *obj;
int arg_num;
int char_encoding;)
{
  ___SCMOBJ e;

  if (x == 0)
    {
      *obj = ___FAL; /* #f counts as NULL */
      e = ___FIX(___NO_ERR);
    }
  else if ((e = ___NONNULLSTRING_to_SCMOBJ
                  (___ps,
                   x,
                   obj,
                   arg_num,
                   char_encoding))
           != ___FIX(___NO_ERR))
    {
      *obj = ___FAL;
      if (e == err_code_from_char_encoding (char_encoding, 1, 1, arg_num))
        e = err_code_from_char_encoding (char_encoding, 1, 0, arg_num);
    }

  return e;
}


/* Convert a nonnull C string list to a Scheme string list. */

___EXP_FUNC(___SCMOBJ,___NONNULLSTRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         void *x,
         ___SCMOBJ *obj,
         int arg_num,
         int char_encoding),
        (___ps,
         x,
         obj,
         arg_num,
         char_encoding)
___processor_state ___ps;
void *x;
___SCMOBJ *obj;
int arg_num;
int char_encoding;)
{
  ___SCMOBJ lst;
  void **string_list = ___CAST(void**,x);
  int i;

  if (string_list == 0)
    return err_code_from_char_encoding (char_encoding, 1, 2, arg_num);

  i = 0;

  while (string_list[i] != 0)
    i++;

  lst = ___NUL;

  while (i-- > 0)
    {
      ___SCMOBJ e;
      ___SCMOBJ str;
      ___SCMOBJ pair;

      if ((e = ___NONNULLSTRING_to_SCMOBJ
                 (___ps,
                  string_list[i],
                  &str,
                  arg_num,
                  char_encoding))
          != ___FIX(___NO_ERR))
        {
          ___release_scmobj (lst);
          *obj = ___FAL;
          if (e == err_code_from_char_encoding (char_encoding, 1, 1, arg_num))
            e = err_code_from_char_encoding (char_encoding, 1, 2, arg_num);
          return e;
        }

      pair = ___make_pair (___ps, str, lst);

      ___release_scmobj (str);
      ___release_scmobj (lst);

      if (___FIXNUMP(pair))
        {
          *obj = ___FAL;
          return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);
        }

      lst = pair;
    }

  *obj = lst;

  return ___FIX(___NO_ERR);
}


/* Convert a C 'char *' to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___CHARSTRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         char *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
char *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_NATIVE);
}


/* Convert a nonnull C 'char *' to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLCHARSTRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         char *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
char *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_NATIVE);
}


/* Convert a nonnull C 'char *' list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLCHARSTRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         char **x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
char **x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_NATIVE);
}


/* Convert a C ISO-8859-1 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___ISO_8859_1STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___ISO_8859_1STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___ISO_8859_1STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_ISO_8859_1);
}


/* Convert a nonnull C ISO-8859-1 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLISO_8859_1STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___ISO_8859_1STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___ISO_8859_1STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_ISO_8859_1);
}


/* Convert a nonnull C ISO-8859-1 encoded character string list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLISO_8859_1STRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___ISO_8859_1STRING *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___ISO_8859_1STRING *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_ISO_8859_1);
}


/* Convert a C UTF-8 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___UTF_8STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UTF_8STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UTF_8STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UTF_8);
}


/* Convert a nonnull C UTF-8 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLUTF_8STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UTF_8STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UTF_8STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UTF_8);
}


/* Convert a nonnull C UTF-8 encoded character string list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLUTF_8STRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UTF_8STRING *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UTF_8STRING *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_UTF_8);
}


/* Convert a C UTF-16 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___UTF_16STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UTF_16STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UTF_16STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UTF_16);
}


/* Convert a nonnull C UTF-16 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLUTF_16STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UTF_16STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UTF_16STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UTF_16);
}


/* Convert a nonnull C UTF-16 encoded character string list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLUTF_16STRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UTF_16STRING *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UTF_16STRING *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_UTF_16);
}


/* Convert a C UCS-2 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___UCS_2STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_2STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_2STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UCS_2);
}


/* Convert a nonnull C UCS-2 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLUCS_2STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_2STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_2STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UCS_2);
}

/* Convert a nonnull C UCS-2 encoded character string list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLUCS_2STRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_2STRING *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_2STRING *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_UCS_2);
}


/* Convert a C UCS-4 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___UCS_4STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_4STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_4STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UCS_4);
}


/* Convert a nonnull C UCS-4 encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLUCS_4STRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_4STRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_4STRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_UCS_4);
}


/* Convert a nonnull C UCS-4 encoded character string list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLUCS_4STRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___UCS_4STRING *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___UCS_4STRING *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_UCS_4);
}


/* Convert a C ___WCHAR encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___WCHARSTRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___WCHARSTRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___WCHARSTRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___STRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_WCHAR);
}


/* Convert a nonnull C ___WCHAR encoded character string to a Scheme string. */

___EXP_FUNC(___SCMOBJ,___NONNULLWCHARSTRING_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___WCHARSTRING x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___WCHARSTRING x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRING_to_SCMOBJ
           (___ps,
            x,
            obj,
            arg_num,
            ___CHAR_ENCODING_WCHAR);
}


/* Convert a nonnull C ___WCHAR encoded character string list to a Scheme list of strings. */

___EXP_FUNC(___SCMOBJ,___NONNULLWCHARSTRINGLIST_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___WCHARSTRING *x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___WCHARSTRING *x;
___SCMOBJ *obj;
int arg_num;)
{
  return ___NONNULLSTRINGLIST_to_SCMOBJ
           (___ps,
            ___CAST(void*,x),
            obj,
            arg_num,
            ___CHAR_ENCODING_WCHAR);
}


/* Convert a variant to a Scheme object. */

___EXP_FUNC(___SCMOBJ,___VARIANT_to_SCMOBJ)
   ___P((___processor_state ___ps,
         ___VARIANT x,
         ___SCMOBJ *obj,
         int arg_num),
        (___ps,
         x,
         obj,
         arg_num)
___processor_state ___ps;
___VARIANT x;
___SCMOBJ *obj;
int arg_num;)
{
  /*
   * Not yet implemented.
   */
  return ___FIX(___CTOS_VARIANT_ERR+arg_num);
}


/* Convert a C 'char *' to a C UCS-2 encoded character string. */

___EXP_FUNC(void,___free_UCS_2STRING)
   ___P((___UCS_2STRING str_UCS_2),
        (str_UCS_2)
___UCS_2STRING str_UCS_2;)
{
  if (str_UCS_2 != 0)
    ___FREE_MEM(str_UCS_2);
}


___EXP_FUNC(___SCMOBJ,___STRING_to_UCS_2STRING)
   ___P((char *str_char,
         ___UCS_2STRING *str_UCS_2,
         int char_encoding),
        (str_char,
         str_UCS_2,
         char_encoding)
char *str_char;
___UCS_2STRING *str_UCS_2;
int char_encoding;)
{
  ___UCS_2STRING s;

  if (str_char == 0)
    s = 0;
  else
    {
      char *p = str_char;
      int len = 0;
      int i;
      ___UCS_2 c;

      switch (char_encoding)
        {
        case ___CHAR_ENCODING_UTF_8:
          while (___UTF_8_get (&p) != 0) /* advance until end or error */
            len++;
          break;

        case ___CHAR_ENCODING_ISO_8859_1:
        default:
          while (*p++ != '\0')
            len++;
          break;
        }

      s = ___CAST(___UCS_2STRING,
                  ___ALLOC_MEM((len + 1) * sizeof (___UCS_2)));

      if (s == 0)
        return ___FIX(___HEAP_OVERFLOW_ERR);

      p = str_char;
      i = 0;

      switch (char_encoding)
        {
        case ___CHAR_ENCODING_UTF_8:
          while ((c = ___UTF_8_get (&p)) != 0 && i<len) /* advance until end or error */
            s[i++] = c;
          break;

        case ___CHAR_ENCODING_ISO_8859_1:
        default:
          while ((c = ___CAST(___UCS_2,___CAST(unsigned char,*p++))) != '\0' && i<len)
            s[i++] = c;
          break;
        }

      s[i] = '\0';
    }

  *str_UCS_2 = s;

  return ___FIX(___NO_ERR);
}


/* Convert a nonnull C 'char *' list to a nonnull C UCS-2 encoded character string list. */

___EXP_FUNC(void,___free_NONNULLUCS_2STRINGLIST)
   ___P((___UCS_2STRING *str_list_UCS_2),
        (str_list_UCS_2)
___UCS_2STRING *str_list_UCS_2;)
{
  ___UCS_2STRING *probe = str_list_UCS_2;
  ___UCS_2STRING str;

  while ((str = *probe++) != 0)
    ___free_UCS_2STRING (str);

  ___FREE_MEM(str_list_UCS_2);
}


___EXP_FUNC(___SCMOBJ,___NONNULLSTRINGLIST_to_NONNULLUCS_2STRINGLIST)
   ___P((char **str_list_char,
         ___UCS_2STRING **str_list_UCS_2,
         int char_encoding),
        (str_list_char,
         str_list_UCS_2,
         char_encoding)
char **str_list_char;
___UCS_2STRING **str_list_UCS_2;
int char_encoding;)
{
  ___SCMOBJ e = ___FIX(___HEAP_OVERFLOW_ERR);
  ___UCS_2STRING *lst;
  int len = 0;

  while (str_list_char[len] != 0)
    len++;

  lst = ___CAST(___UCS_2STRING*,
                ___ALLOC_MEM((len + 1) * sizeof (___UCS_2STRING)));

  if (lst != 0)
    {
      char **probe = str_list_char;
      char *str;
      int i = 0;

      while ((str = *probe++) != 0 && i < len)
        {
          if ((e = ___STRING_to_UCS_2STRING (str, &lst[i], char_encoding))
              != ___FIX(___NO_ERR))
            {
              lst[i] = 0;
              ___free_NONNULLUCS_2STRINGLIST (lst);
              return e;
            }
          i++;
        }

      lst[i] = 0;

      *str_list_UCS_2 = lst;
    }

  return e;
}


/* Create a stack marker for a C to Scheme function call. */

___EXP_FUNC(___SCMOBJ,___make_sfun_stack_marker)
   ___P((___processor_state ___ps,
         ___SCMOBJ *marker,
         ___SCMOBJ proc_or_false),
        (___ps,
         marker,
         proc_or_false)
___processor_state ___ps;
___SCMOBJ *marker;
___SCMOBJ proc_or_false;)
{
  ___SCMOBJ stack_marker;

#ifdef ___SINGLE_THREADED_VMS
  stack_marker = ___make_vector (___ps, 1, ___FAL);
#else
  stack_marker = ___make_vector (___ps, 2, ___FAL);
#endif

  /*TODO: proc_or_false may have been GC'd at this point! protect it some way*/

  if (___FIXNUMP(stack_marker))
    return ___FIX(___SFUN_HEAP_OVERFLOW_ERR);

  if (proc_or_false == ___FAL)
    ___FIELD(stack_marker,0) = ___data_rc (___c_closure_self ());
  else
    ___FIELD(stack_marker,0) = proc_or_false;

#ifndef ___SINGLE_THREADED_VMS
  ___FIELD(stack_marker,1) = ___FIX(___PROCESSOR_ID(___ps,___VMSTATE_FROM_PSTATE(___ps)));
#endif

  *marker = stack_marker;

  return ___FIX(___NO_ERR);
}


/*
 * Invalidate a stack marker.  This happens when a C to Scheme
 * function call returns.
 */

___EXP_FUNC(void,___kill_sfun_stack_marker)
   ___P((___SCMOBJ marker),
        (marker)
___SCMOBJ marker;)
{
  ___FIELD(marker,0) = ___FAL; /* invalidate the C stack frame */
  ___still_obj_refcount_dec (marker); /* allow GC of stack marker */
}


/*---------------------------------------------------------------------------*/
