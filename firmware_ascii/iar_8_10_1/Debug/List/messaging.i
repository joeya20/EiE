/*!**********************************************************************************************************************
@file messaging.c                                                                
@brief This file contains utilities to create and monitor outgoing messages.  It essentially provides a 
smart queue system for outgoing data.

Any message being transferred by a peripheral is kept here.  As the peripheral sends the message,
it talks to messaging.c to get data and update the message status.  

All interaction between the peripheral and this task is through unique message tokens that are assigned
to every message queued to messaging.c

The API is simplified and provides just a single function for high-level client tasks to check the
status of their message based on a provided unique token.  If the status of a message is such that
it will no longer change (i.e. COMPLETE, TIMOEOUT, ABANDONDED) then that message's status in the loop
will be cleared automatically.  There is ample room in the message status array to keep sufficient message 
status history given the processing time of the firmware.  However, the status array is circular so 
message statuses can be lost eventually.  If a task waits too long and received a "NOT FOUND" status 
because they have waited too long, the task should increase the frequency at which it queries the 
message status.

------------------------------------------------------------------------------------------------------------------------
GLOBALS
- NONE

CONSTANTS
- NONE

TYPES
- MessageStateType {EMPTY, WAITING, SENDING, COMPLETE, 
                    TIMEOUT, ABANDONED, NOT_FOUND}

PUBLIC FUNCTIONS
- MessageStateType QueryMessageStatus(u32 u32Token_)

PROTECTED FUNCTIONS
- void MessagingInitialize(void)
- u32 QueueMessage(MessageType** ppsTargetTxBuffer_, u32 u32MessageSize_, u8* pu8MessageData_)
- void DeQueueMessage(MessageType** pTargetQueue_)
- void UpdateMessageStatus(u32 u32Token_, MessageStateType eNewState_)


**********************************************************************************************************************/

/*!*********************************************************************************************************************
@file configuration.h      
@brief Main configuration header file for project.  

This file bridges many of the generic features of the firmware to the 
specific features of the design. The definitions should be updated
to match the target hardware.  
 
Bookmarks:
!!!!! External module peripheral assignments
##### UART peripheral board-specific parameters
$$$$$ SPI peripheral board-specific parameters
%%%%% SSP peripheral board-specific parameters
^^^^^ I²C peripheral board-specific parameters


***********************************************************************************************************************/


/**********************************************************************************************************************
Runtime switches
***********************************************************************************************************************/
//#define STARTUP_SOUND               /*!< Define to include buzzer sound on startup */

//#define EIE_DOTMATRIX_R01           /*!< Use with MPGL2-EHDW-01 revision board */


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@enum PeripheralType
@brief Short names used to identify peripherals in their configuration structs.

This provides self-documentation when indexing peripherals and when assigning
better names for devices that make use of the peripherals.
*/
typedef enum {SPI0, UART, USART0, USART1, USART2, USART3} PeripheralType;


/**********************************************************************************************************************
Includes
***********************************************************************************************************************/
/* Common header files */
/* stdlib.h standard header */
/* Copyright 2005-2017 IAR Systems AB. */


  #pragma system_include

/* ycheck.h internal checking header file. */
/* Copyright 2005-2017 IAR Systems AB. */

/* Note that there is no include guard for this header. This is intentional. */

  #pragma system_include

/* __AEABI_PORTABILITY_INTERNAL_LEVEL
 *
 * Note: Redefined each time ycheck.h is included, i.e. for each
 * system header, to ensure that ABI support could be turned off/on
 * individually for each file.
 *
 * Possible values for this preprocessor symbol:
 *
 * 0 - ABI portability mode is disabled.
 *
 * 1 - ABI portability mode (version 1) is enabled.
 *
 * All other values are reserved for future use.
 */


/* yvals.h internal configuration header file. */
/* Copyright 2001-2017 IAR Systems AB. */


  #pragma system_include

/* Convenience macros */



/* Used to refer to '__aeabi' symbols in the library. */ 

/* Dinkum version */

/* DLib version */

/* Module consistency. */
#pragma rtmodel = "__dlib_version", "6"

/* IAR compiler version check */


/* Read configuration */
/***************************************************
 *
 * DLib_Defaults.h is the library configuration manager.
 *
 * Copyright 2003-2017 IAR Systems AB.  
 *
 * This configuration header file performs the following tasks:
 *
 * 1. Includes the configuration header file, defined by _DLIB_CONFIG_FILE,
 *    that sets up a particular runtime environment.
 *
 * 2. Includes the product configuration header file, DLib_Product.h, that
 *    specifies default values for the product and makes sure that the
 *    configuration is valid.
 *
 * 3. Sets up default values for all remaining configuration symbols.
 *
 * This configuration header file, the one defined by _DLIB_CONFIG_FILE, and
 * DLib_Product.h configures how the runtime environment should behave. This
 * includes all system headers and the library itself, i.e. all system headers
 * includes this configuration header file, and the library has been built
 * using this configuration header file.
 *
 ***************************************************
 *
 * DO NOT MODIFY THIS FILE!
 *
 ***************************************************/


  #pragma system_include

/* Include the main configuration header file. */
/* DLib configuration. */
/* Copyright 2003-2017 IAR Systems AB.  */


  #pragma system_include

/* No changes to the defaults. */

  /* _DLIB_CONFIG_FILE_STRING is the quoted variant of above */

/* Include the product specific header file. */
/* Copyright 2017 IAR Systems AB. */


   #pragma system_include


/*********************************************************************
*
*       Configuration
*
*********************************************************************/

/* Wide character and multi byte character support in library.
 * This is not allowed to vary over configurations, since math-library
 * is built with wide character support.
 */

/* This ensures that the standard header file "string.h" includes
 * the Arm-specific file "DLib_Product_string.h". */

/* This ensures that the standard header file "fenv.h" includes
 * the Arm-specific file "DLib_Product_fenv.h". */

/* Max buffer used for swap in qsort */


/* Enable AEABI support */

/* Enable rtmodel for setjump buffer size */

/* Enable parsing of hex floats */

/* Special placement for locale structures when building ropi libraries */

/* Use atomic if possible */

/* CPP-library uses software floatingpoint interface */

/* functions for setting errno should be __no_scratch */

/* Use speedy implementation of floats (simple quad). */

/* Configure generic ELF init routines. */







/*
 * The remainder of the file sets up defaults for a number of
 * configuration symbols, each corresponds to a feature in the
 * libary.
 *
 * The value of the symbols should either be 1, if the feature should
 * be supported, or 0 if it shouldn't. (Except where otherwise
 * noted.)
 */


/*
 * File handling
 *
 * Determines whether FILE descriptors and related functions exists or not.
 * When this feature is selected, i.e. set to 1, then FILE descriptors and
 * related functions (e.g. fprintf, fopen) exist. All files, even stdin,
 * stdout, and stderr will then be handled with a file system mechanism that
 * buffers files before accessing the lowlevel I/O interface (__open, __read,
 * __write, etc).
 *
 * If not selected, i.e. set to 0, then FILE descriptors and related functions
 * (e.g. fprintf, fopen) does not exist. All functions that normally uses
 * stderr will use stdout instead. Functions that uses stdout and stdin (like
 * printf and scanf) will access the lowlevel I/O interface directly (__open,
 * __read, __write, etc), i.e. there will not be any buffering.
 *
 * The default is not to have support for FILE descriptors.
 */



/*
 * Use static buffers for stdout
 *
 * This setting controls whether the stream stdout uses a static 80 bytes
 * buffer or uses a one byte buffer allocated in the file descriptor. This
 * setting is only applicable if the FILE descriptors are enabled above.
 *
 * Default is to use a static 80 byte buffer.
 */



/*
 * Support of locale interface
 *
 * "Locale" is the system in C that support language- and
 * contry-specific settings for a number of areas, including currency
 * symbols, date and time, and multibyte encodings.
 *
 * This setting determines whether the locale interface exist or not.
 * When this feature is selected, i.e. set to 1, the locale interface exist
 * (setlocale, etc). A number of preselected locales can be activated during
 * runtime. The preselected locales and encodings are choosen at linkage. The
 * application will start with the "C" locale choosen. (Single byte encoding is
 * always supported in this mode.)
 *
 *
 * If not selected, i.e. set to 0, the locale interface (setlocale, etc) does
 * not exist. The C locale is then preset and cannot be changed.
 *
 * The default is not to have support for the locale interface with the "C"
 * locale and the single byte encoding.
 */


/*
 * Define what memory to place the locale table segment (.iar.locale_table)
 * in.
 */

/*
 * Wide character and multi byte character support in library.
 */


/*
 * Support of multibytes in printf- and scanf-like functions
 *
 * This is the default value for _DLIB_PRINTF_MULTIBYTE and
 * _DLIB_SCANF_MULTIBYTE. See them for a description.
 *
 * Default is to not have support for multibytes in printf- and scanf-like
 * functions.
 */


/*
 * Hexadecimal floating-point numbers in strtod
 *
 * If selected, i.e. set to 1, strtod supports C99 hexadecimal floating-point
 * numbers. This also enables hexadecimal floating-points in internal functions
 * used for converting strings and wide strings to float, double, and long
 * double.
 *
 * If not selected, i.e. set to 0, C99 hexadecimal floating-point numbers
 * aren't supported.
 *
 * Default is not to support hexadecimal floating-point numbers.
 */



/*
 * Printf configuration symbols.
 *
 * All the configuration symbols described further on controls the behaviour
 * of printf, sprintf, and the other printf variants.
 *
 * The library proves four formatters for printf: 'tiny', 'small',
 * 'large', and 'default'.  The setup in this file controls all except
 * 'tiny'.  Note that both small' and 'large' explicitly removes
 * some features.
 */

/*
 * Handle multibytes in printf
 *
 * This setting controls whether multibytes and wchar_ts are supported in
 * printf. Set to 1 to support them, otherwise set to 0.
 *
 * See _DLIB_FORMATTED_MULTIBYTE for the default setting.
 */

/*
 * Support of formatting anything larger than int in printf
 *
 * This setting controls if 'int' should be used internally in printf, rather
 * than the largest existing integer type. If 'int' is used, any integer or
 * pointer type formatting use 'int' as internal type even though the
 * formatted type is larger. Set to 1 to use 'int' as internal type, otherwise
 * set to 0.
 *
 * See also next configuration.
 *
 * Default is to internally use largest existing internally type.
 */

/*
 * Support of formatting anything larger than long in printf
 *
 * This setting controls if 'long' should be used internally in printf, rather
 * than the largest existing integer type. If 'long' is used, any integer or
 * pointer type formatting use 'long' as internal type even though the
 * formatted type is larger. Set to 1 to use 'long' as internal type,
 * otherwise set to 0.
 *
 * See also previous configuration.
 *
 * Default is to internally use largest existing internally type.
 */


/*
 * Emit a char a time in printf
 *
 * This setting controls internal output handling. If selected, i.e. set to 1,
 * then printf emits one character at a time, which requires less code but
 * can be slightly slower for some types of output.
 *
 * If not selected, i.e. set to 0, then printf buffers some outputs.
 *
 * Note that it is recommended to either use full file support (see
 * _DLIB_FILE_DESCRIPTOR) or -- for debug output -- use the linker
 * option "-e__write_buffered=__write" to enable buffered I/O rather
 * than deselecting this feature.
 */


/*
 * Scanf configuration symbols.
 *
 * All the configuration symbols described here controls the
 * behaviour of scanf, sscanf, and the other scanf variants.
 *
 * The library proves three formatters for scanf: 'small', 'large',
 * and 'default'.  The setup in this file controls all, however both
 * 'small' and 'large' explicitly removes some features.
 */

/*
 * Handle multibytes in scanf
 *
 * This setting controls whether multibytes and wchar_t:s are supported in
 * scanf. Set to 1 to support them, otherwise set to 0.
 *
 * See _DLIB_FORMATTED_MULTIBYTE for the default.
 */

/*
 * Handle multibytes in asctime and strftime.
 *
 * This setting controls whether multibytes and wchar_ts are
 * supported.Set to 1 to support them, otherwise set to 0.
 *
 * See _DLIB_FORMATTED_MULTIBYTE for the default setting.
 */

/*
 * Implement "qsort" using a bubble sort algorithm.
 *
 * Bubble sort is less efficient than quick sort but requires less RAM
 * and ROM resources.
 */



/*
 * Set Buffert size used in qsort
 */



/*
 * Use a simple rand implementation to reduce memory footprint.
 *
 * The default "rand" function uses an array of 32 long:s of memory to
 * store the current state.
 *
 * The simple "rand" function uses only a single long. However, the
 * quality of the generated psuedo-random numbers are not as good as
 * the default implementation.
 */



/*
 * Set attributes for the function used by the C-SPY debug interface to stop at.
 */


/*
 * Used by products where one runtime library can be used by applications
 * with different data models, in order to reduce the total number of
 * libraries required. Typically, this is used when the pointer types does
 * not change over the data models used, but the placement of data variables
 * or/and constant variables do.
 *
 * If defined, this symbol is typically defined to the memory attribute that
 * is used by the runtime library. The actual define must use a
 * _Pragma("type_attribute = xxx") construct. In the header files, it is used
 * on all statically linked data objects seen by the application.
 */



/*
 * Turn on support for the Target-specific ABI. The ABI is based on the
 * ARM AEABI. A target, except ARM, may deviate from it.
 */


  /* Possible AEABI deviations */


  /*
   * The "difunc" table contains information about C++ objects that
   * should be dynamically initialized, where each entry in the table
   * represents an initialization function that should be called. When
   * the symbol _DLIB_AEABI_DIFUNC_CONTAINS_OFFSETS is true, each
   * entry in the table is encoded as an offset from the entry
   * location. When false, the entries contain the actual addresses to
   * call.
   */


/*
 * Turn on usage of a pragma to tell the linker the number of elements used
 * in a setjmp jmp_buf.
 */



/*
 * If true, the product supplies a "DLib_Product_string.h" file that
 * is included from "string.h".
 */


/*
 * Determine whether the math fma routines are fast or not.
 */


/*
 * Favor speed versus some size enlargements in floating point functions.
 */


/*
 * Include dlmalloc as an alternative heap manager in the product.
 *
 * Typically, an application will use a "malloc" heap manager that is
 * relatively small but not that efficient. An application can
 * optionally use the "dlmalloc" package, which provides a more
 * effective "malloc" heap manager, if it is included in the product
 * and supported by the settings.
 *
 * See the product documentation on how to use it, and whether or not
 * it is included in the product.
 */

  /* size_t/ptrdiff_t must be a 4 bytes unsigned integer. */


/*
 * Make sure certain C++ functions use the soft floating point variant.
 */



/*
 * Allow the 64-bit time_t interface?
 *
 * Default is yes if long long is 64 bits.
 */



/*
 * Is time_t 64 or 32 bits?
 *
 * Default is 32 bits.
 */



/*
 * Do we include math functions that demands lots of constant bytes?
 * (like erf, erfc, expm1, fma, lgamma, tgamma, and *_accurate)
 *
 */



/*
 * Support of weak.
 *
 * Set this to __weak, if supported. Support of weak means that the call to
 * a weak declared function that isn't part of the application will be
 * executed as a nop instruction.
 *
 */


/*
 * Deleted options
 */







/* A definiton for a function of what effects it has.
   NS  = no_state, errno, i.e. it uses no internal or external state. It may
         write to errno though
   NE  = no_state, i.e. it uses no internal or external state, not even
         writing to errno. 
   NRx = no_read(x), i.e. it doesn't read through pointer parameter x.
   NWx = no_write(x), i.e. it doesn't write through pointer parameter x.
   Rx  = returns x, i.e. the function will return parameter x.
   
   All the functions with effects also has "always_returns", 
   i.e. the function will always return.
*/


/* Common function attribute macros */



/* namespace and extern "C" handling */



/*
 * Support for C99/C11 functionality, C99 secure C functionality, and some
 * other functionality.
 *
 * This setting makes available some macros, functions, etc that are
 * either mandatory in C99/C11 or beneficial.
 *
 * Default is to include them.
 *
 * Disabling this in C++ mode will not compile (some C++ functions uses C99
 * functionality).
 */

  /* Default turned on only when compiling C89 (not C++, C99, or C11). */


/* Secure C */



/* C++ language setup */



/* MB_LEN_MAX (max for utf-8 is 4) */

/* for parsing numerics */

/* wchar_t setup */
  typedef unsigned long int _Wchart;
    typedef unsigned long int _Wintt;

/* POINTER PROPERTIES */

/* size_t setup */
typedef unsigned int     _Sizet;

/* mbstatet setup */
typedef struct _Mbstatet
{ /* state of a multibyte translation */
    unsigned int _Wchar;  /* Used as an intermediary value (up to 32-bits) */
    unsigned int _State;  /* Used as a state value (only some bits used) */

} _Mbstatet;

/* printf setup */

/* stdarg PROPERTIES */

  typedef struct __va_list
  {
    char  *_Ap;
  } __va_list;
  typedef __va_list __Va_list;



/* File position */
typedef struct
{       
    long long _Off;    /* can be system dependent */
  _Mbstatet _Wstate;
} _Fpost;


/* THREAD AND LOCALE CONTROL */

/* MULTITHREAD PROPERTIES */
  
  /* The lock interface for DLib to use. */ 
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Locksyslock_Malloc(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Locksyslock_Stream(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Locksyslock_Debug(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Locksyslock_StaticGuard(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Unlocksyslock_Malloc(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Unlocksyslock_Stream(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Unlocksyslock_Debug(void);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Unlocksyslock_StaticGuard(void);


  typedef void *__iar_Rmtx;

  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Initdynamiclock(__iar_Rmtx *);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Dstdynamiclock(__iar_Rmtx *);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Lockdynamiclock(__iar_Rmtx *);
  _Pragma("object_attribute = __weak") __intrinsic __nounwind void __iar_Unlockdynamiclock(__iar_Rmtx *);

  



/*
 * Copyright (c) by P.J. Plauger. All rights reserved.
 * Consult your license regarding permissions and restrictions.
V6.50:0576 */
/* ysizet.h internal header file. */
/* Copyright 2003-2017 IAR Systems AB.  */


  #pragma system_include

/* ycheck.h internal checking header file. */
/* Copyright 2005-2017 IAR Systems AB. */

/* Note that there is no include guard for this header. This is intentional. */

  #pragma system_include

/* __AEABI_PORTABILITY_INTERNAL_LEVEL
 *
 * Note: Redefined each time ycheck.h is included, i.e. for each
 * system header, to ensure that ABI support could be turned off/on
 * individually for each file.
 *
 * Possible values for this preprocessor symbol:
 *
 * 0 - ABI portability mode is disabled.
 *
 * 1 - ABI portability mode (version 1) is enabled.
 *
 * All other values are reserved for future use.
 */



/* type definitions */
  typedef _Sizet size_t;

typedef unsigned int __data_size_t;



/* Module consistency. */
#pragma rtmodel="__dlib_full_locale_support",   "0"

  
    __intrinsic __nounwind size_t __iar_Mbcurmax(void);
  


/* MACROS */



/* TYPE DEFINITIONS */
  typedef _Wchart wchar_t;

typedef struct
{ /* result of int divide */
  int quot;
  int rem;
} div_t;

typedef struct
{ /* result of long divide */
  long quot;
  long rem;
} ldiv_t;

  typedef struct
  { /* result of long long divide */
    long long quot;
    long long rem;
  } lldiv_t;


/* DECLARATIONS */
 /* low-level functions */
  __intrinsic __nounwind int             atexit(void (*)(void));
    __intrinsic __nounwind          int  at_quick_exit(void (*)(void)) ;
    __intrinsic __noreturn __nounwind void _Exit(int) ;
    __intrinsic __noreturn __nounwind void quick_exit(int) ;
  __intrinsic __noreturn __nounwind void   exit(int);
   __intrinsic __nounwind        char * getenv(const char *);
  __intrinsic __nounwind          int    system(const char *);



               __intrinsic __nounwind void *    aligned_alloc(size_t, size_t);
          __intrinsic __noreturn __nounwind void  abort(void) ;
  _Pragma("function_effects = no_state, always_returns")     __intrinsic __nounwind int       abs(int);
               __intrinsic __nounwind void *    calloc(size_t, size_t);
  _Pragma("function_effects = no_state, always_returns")     __intrinsic __nounwind div_t     div(int, int);
               __intrinsic __nounwind void      free(void *);
  _Pragma("function_effects = no_state, always_returns")     __intrinsic __nounwind long      labs(long);
  _Pragma("function_effects = no_state, always_returns")     __intrinsic __nounwind ldiv_t    ldiv(long, long);
    _Pragma("function_effects = no_state, always_returns")   __intrinsic __nounwind long long llabs(long long);
    _Pragma("function_effects = no_state, always_returns")   __intrinsic __nounwind lldiv_t   lldiv(long long, long long);
               __intrinsic __nounwind void *    malloc(size_t);
  _Pragma("function_effects = no_write(1), always_returns")    __intrinsic __nounwind int       mblen(const char *, size_t);
    _Pragma("function_effects = no_read(1), no_write(2), always_returns")  __intrinsic __nounwind size_t mbstowcs(wchar_t *restrict, 
                                                const char *restrict, size_t);
    _Pragma("function_effects = no_read(1), no_write(2), always_returns") __intrinsic __nounwind   int    mbtowc(wchar_t *restrict,
                                              const char *restrict, size_t);
               __intrinsic __nounwind int    rand(void);
               __intrinsic __nounwind void   srand(unsigned int);
               __intrinsic __nounwind void * realloc(void *, size_t);
               __intrinsic __nounwind void * __iar_realloc_in_place(void *, size_t);
  _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind long          strtol(const char *restrict, 
                                                 char **restrict, int);
  _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind unsigned long strtoul(const char *, char **, int);
    _Pragma("function_effects = no_read(1), no_write(2), always_returns")  __intrinsic __nounwind size_t wcstombs(char *restrict, 
                                               const wchar_t *restrict,
                                               size_t);
    _Pragma("function_effects = no_read(1), always_returns")     __intrinsic __nounwind int    wctomb(char *, wchar_t);
    _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind long long strtoll(const char *, char **, int);
    _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind unsigned long long strtoull(const char *, 
                                                          char **, int);



  typedef int _Cmpfun(const void *, const void *);
  _Pragma("function_effects = no_write(1,2), always_returns")  __intrinsic void * bsearch(const void *, 
                                                       const void *, size_t,
                                                       size_t, _Cmpfun *);
                __intrinsic void   qsort(void *, size_t, size_t, 
                                                     _Cmpfun *);
               __intrinsic void     __qsortbbl(void *, size_t,
                                                          size_t, _Cmpfun *);
  _Pragma("function_effects = no_write(1), always_returns")    __intrinsic __nounwind double             atof(const char *);
  _Pragma("function_effects = no_write(1), always_returns")    __intrinsic __nounwind int                atoi(const char *);
  _Pragma("function_effects = no_write(1), always_returns")    __intrinsic __nounwind long               atol(const char *);
     _Pragma("function_effects = no_write(1), always_returns") __intrinsic __nounwind long long        atoll(const char *);
     _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind float         strtof(const char *restrict, 
                                                    char **restrict);
     _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind long double   strtold(const char *, char **);
  _Pragma("function_effects = no_write(1), no_read(2), always_returns") __intrinsic __nounwind double           strtod(const char *restrict, 
                                                    char **restrict);
    _Pragma("function_effects = no_state, always_returns")   __intrinsic __nounwind int              __iar_DLib_library_version(void);


  
  #pragma inline=no_body
  int abs(int i)
  {      /* compute absolute value of int argument */
    return i < 0 ? -i : i;
  }

  #pragma inline=no_body
  long labs(long i)
  { /* compute absolute value of long argument */
    return i < 0 ? -i : i;
  }

    #pragma inline=no_body
    long long llabs(long long i)
    { /* compute absolute value of long long argument */
      return i < 0 ? -i : i;
    }
  




/*
 * Copyright (c) by P.J. Plauger. All rights reserved.
 * Consult your license regarding permissions and restrictions.
V6.50:0576 */
/* string.h standard header */
/* Copyright 2009-2017 IAR Systems AB. */

  #pragma system_include

/* ycheck.h internal checking header file. */
/* Copyright 2005-2017 IAR Systems AB. */

/* Note that there is no include guard for this header. This is intentional. */

  #pragma system_include

/* __AEABI_PORTABILITY_INTERNAL_LEVEL
 *
 * Note: Redefined each time ycheck.h is included, i.e. for each
 * system header, to ensure that ABI support could be turned off/on
 * individually for each file.
 *
 * Possible values for this preprocessor symbol:
 *
 * 0 - ABI portability mode is disabled.
 *
 * 1 - ABI portability mode (version 1) is enabled.
 *
 * All other values are reserved for future use.
 */



/**************************************************
 *
 * ARM-specific configuration for string.h in DLib.
 *
 * Copyright 2006-2017 IAR Systems AB.
 *
 * $Id: DLib_Product_string.h 112610 2017-02-09 08:49:48Z danielfl $
 *
 **************************************************/


  #pragma system_include


  /*
   * The following is pre-declared by the compiler.
   *
   * __INTRINSIC void __aeabi_memset (void *, size_t, int);
   * __INTRINSIC void __aeabi_memcpy (void *, const void *, size_t);
   * __INTRINSIC void __aeabi_memmove(void *, const void *, size_t);
   */


  /*
   * Inhibit inline definitions for routines with an effective
   * ARM-specific implementation.
   *
   * Not in Cortex-M1 and Cortex-MS1
   */




  /*
   * Redirect calls to standard functions to the corresponding
   * __aeabi_X function.
   */


  #pragma inline=forced_no_body
  _Pragma("function_effects = no_state, no_read(1), no_write(2), returns 1, always_returns") __intrinsic __nounwind void * memcpy(void * _D, const void * _S, size_t _N)
  {
    __aeabi_memcpy(_D, _S, _N);
    return _D;
  }

  #pragma inline=forced_no_body
  _Pragma("function_effects = no_state, no_read(1), no_write(2), returns 1, always_returns") __intrinsic __nounwind void * memmove(void * _D, const void * _S, size_t _N)
  {
    __aeabi_memmove(_D, _S, _N);
    return _D;
  }

  #pragma inline=forced_no_body
  _Pragma("function_effects = no_state, no_read(1), returns 1, always_returns") __intrinsic __nounwind void * memset(void * _D, int _C, size_t _N)
  {
    __aeabi_memset(_D, _N, _C);
    return _D;
  }




/* macros */

/* type definitions */

/* declarations */

  _Pragma("function_effects = no_state, no_write(1,2), always_returns")   __intrinsic __nounwind   int       memcmp(const void *, const void *,
                                                   size_t);
  _Pragma("function_effects = no_state, no_read(1), no_write(2), returns 1, always_returns")  __intrinsic __nounwind void *    memcpy(void *restrict, 
                                                   const void *restrict,
                                                   size_t);
  _Pragma("function_effects = no_state, no_read(1), no_write(2), returns 1, always_returns")  __intrinsic __nounwind void *    memmove(void *, const void *,
                                                    size_t);
  _Pragma("function_effects = no_state, no_read(1), returns 1, always_returns")     __intrinsic __nounwind void *    memset(void *, int, size_t);
  _Pragma("function_effects = no_state, no_write(2), returns 1, always_returns")     __intrinsic __nounwind char *    strcat(char *restrict, 
                                                   const char *restrict);
  _Pragma("function_effects = no_state, no_write(1,2), always_returns")   __intrinsic __nounwind   int       strcmp(const char *, const char *);
  _Pragma("function_effects = no_write(1,2), always_returns")     __intrinsic __nounwind   int       strcoll(const char *, const char *);
  _Pragma("function_effects = no_state, no_read(1), no_write(2), returns 1, always_returns")  __intrinsic __nounwind char *    strcpy(char *restrict, 
                                                   const char *restrict);
  _Pragma("function_effects = no_state, no_write(1,2), always_returns")   __intrinsic __nounwind   size_t    strcspn(const char *, const char *);
                    __intrinsic __nounwind char *    strerror(int);
  _Pragma("function_effects = no_state, no_write(1), always_returns")      __intrinsic __nounwind   size_t    strlen(const char *);
  _Pragma("function_effects = no_state, no_write(2), returns 1, always_returns")     __intrinsic __nounwind char *    strncat(char *restrict, 
                                                    const char *restrict,
                                                    size_t);
  _Pragma("function_effects = no_state, no_write(1,2), always_returns")   __intrinsic __nounwind   int       strncmp(const char *, const char *, 
                                                    size_t);
  _Pragma("function_effects = no_state, no_read(1), no_write(2), returns 1, always_returns")  __intrinsic __nounwind char *    strncpy(char *restrict, 
                                                    const char *restrict,
                                                    size_t);
  _Pragma("function_effects = no_state, no_write(1,2), always_returns")   __intrinsic __nounwind   size_t    strspn(const char *, const char *);
  _Pragma("function_effects = no_write(2), always_returns")         __intrinsic __nounwind char *    strtok(char *restrict, 
                                                   const char *restrict);
  _Pragma("function_effects = no_write(2), always_returns")        __intrinsic __nounwind   size_t    strxfrm(char *restrict, 
                                                    const char *restrict,
                                                    size_t);
    _Pragma("function_effects = no_write(1), always_returns")      __intrinsic __nounwind   char *    strdup(const char *);
    _Pragma("function_effects = no_write(1,2), always_returns")   __intrinsic __nounwind   int       strcasecmp(const char *,
                                                       const char *);
    _Pragma("function_effects = no_write(1,2), always_returns")   __intrinsic __nounwind   int       strncasecmp(const char *,
                                                        const char *, size_t);
    _Pragma("function_effects = no_state, no_write(2), always_returns")    __intrinsic __nounwind   char *    strtok_r(char *, const char *,
                                                     char **);
    _Pragma("function_effects = no_state, no_write(1), always_returns")     __intrinsic __nounwind size_t    strnlen(char const *, size_t);


  _Pragma("function_effects = no_state, no_write(1), always_returns")    __intrinsic __nounwind void *memchr(const void *_S, int _C, size_t _N);
  _Pragma("function_effects = no_state, no_write(1), always_returns")    __intrinsic __nounwind char *strchr(const char *_S, int _C);
  _Pragma("function_effects = no_state, no_write(1,2), always_returns") __intrinsic __nounwind char *strpbrk(const char *_S, const char *_P);
  _Pragma("function_effects = no_state, no_write(1), always_returns")    __intrinsic __nounwind char *strrchr(const char *_S, int _C);
  _Pragma("function_effects = no_state, no_write(1,2), always_returns") __intrinsic __nounwind char *strstr(const char *_S, const char *_P);



/*
 * Copyright (c) by P.J. Plauger. All rights reserved.
 * Consult your license regarding permissions and restrictions.
V6.50:0576 */
//  ----------------------------------------------------------------------------
//          ATMEL Microcontroller Software Support  -  ROUSSET  -
//  ----------------------------------------------------------------------------
//  Copyright (c) 2009, Atmel Corporation
// 
//  All rights reserved.
// 
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
// 
//  - Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the disclaimer below.
// 
//  Atmel's name may not be used to endorse or promote products derived from
//  this software without specific prior written permission. 
//  
//  DISCLAIMER:  THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
//  DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
//  OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  ----------------------------------------------------------------------------
// File Name           : AT91SAM3U4.h
// Object              : AT91SAM3U4 definitions
// Generated           : AT91 SW Application Group  11/17/2009 (13:04:57)

//  ----------------------------------------------------------------------------


typedef volatile unsigned int AT91_REG;// Hardware register definition

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR System Peripherals
// *****************************************************************************
typedef struct _AT91S_SYS {
	AT91_REG	 HSMC4_CFG; 	// Configuration Register
	AT91_REG	 HSMC4_CTRL; 	// Control Register
	AT91_REG	 HSMC4_SR; 	// Status Register
	AT91_REG	 HSMC4_IER; 	// Interrupt Enable Register
	AT91_REG	 HSMC4_IDR; 	// Interrupt Disable Register
	AT91_REG	 HSMC4_IMR; 	// Interrupt Mask Register
	AT91_REG	 HSMC4_ADDR; 	// Address Cycle Zero Register
	AT91_REG	 HSMC4_BANK; 	// Bank Register
	AT91_REG	 HSMC4_ECCCR; 	// ECC reset register
	AT91_REG	 HSMC4_ECCCMD; 	// ECC Page size register
	AT91_REG	 HSMC4_ECCSR1; 	// ECC Status register 1
	AT91_REG	 HSMC4_ECCPR0; 	// ECC Parity register 0
	AT91_REG	 HSMC4_ECCPR1; 	// ECC Parity register 1
	AT91_REG	 HSMC4_ECCSR2; 	// ECC Status register 2
	AT91_REG	 HSMC4_ECCPR2; 	// ECC Parity register 2
	AT91_REG	 HSMC4_ECCPR3; 	// ECC Parity register 3
	AT91_REG	 HSMC4_ECCPR4; 	// ECC Parity register 4
	AT91_REG	 HSMC4_ECCPR5; 	// ECC Parity register 5
	AT91_REG	 HSMC4_ECCPR6; 	// ECC Parity register 6
	AT91_REG	 HSMC4_ECCPR7; 	// ECC Parity register 7
	AT91_REG	 HSMC4_ECCPR8; 	// ECC Parity register 8
	AT91_REG	 HSMC4_ECCPR9; 	// ECC Parity register 9
	AT91_REG	 HSMC4_ECCPR10; 	// ECC Parity register 10
	AT91_REG	 HSMC4_ECCPR11; 	// ECC Parity register 11
	AT91_REG	 HSMC4_ECCPR12; 	// ECC Parity register 12
	AT91_REG	 HSMC4_ECCPR13; 	// ECC Parity register 13
	AT91_REG	 HSMC4_ECCPR14; 	// ECC Parity register 14
	AT91_REG	 HSMC4_Eccpr15; 	// ECC Parity register 15
	AT91_REG	 Reserved0[40]; 	// 
	AT91_REG	 HSMC4_OCMS; 	// OCMS MODE register
	AT91_REG	 HSMC4_KEY1; 	// KEY1 Register
	AT91_REG	 HSMC4_KEY2; 	// KEY2 Register
	AT91_REG	 Reserved1[50]; 	// 
	AT91_REG	 HSMC4_WPCR; 	// Write Protection Control register
	AT91_REG	 HSMC4_WPSR; 	// Write Protection Status Register
	AT91_REG	 HSMC4_ADDRSIZE; 	// Write Protection Status Register
	AT91_REG	 HSMC4_IPNAME1; 	// Write Protection Status Register
	AT91_REG	 HSMC4_IPNAME2; 	// Write Protection Status Register
	AT91_REG	 HSMC4_FEATURES; 	// Write Protection Status Register
	AT91_REG	 HSMC4_VER; 	// HSMC4 Version Register
	AT91_REG	 HMATRIX_MCFG0; 	//  Master Configuration Register 0 : ARM I and D
	AT91_REG	 HMATRIX_MCFG1; 	//  Master Configuration Register 1 : ARM S
	AT91_REG	 HMATRIX_MCFG2; 	//  Master Configuration Register 2
	AT91_REG	 HMATRIX_MCFG3; 	//  Master Configuration Register 3
	AT91_REG	 HMATRIX_MCFG4; 	//  Master Configuration Register 4
	AT91_REG	 HMATRIX_MCFG5; 	//  Master Configuration Register 5
	AT91_REG	 HMATRIX_MCFG6; 	//  Master Configuration Register 6
	AT91_REG	 HMATRIX_MCFG7; 	//  Master Configuration Register 7
	AT91_REG	 Reserved2[8]; 	// 
	AT91_REG	 HMATRIX_SCFG0; 	//  Slave Configuration Register 0
	AT91_REG	 HMATRIX_SCFG1; 	//  Slave Configuration Register 1
	AT91_REG	 HMATRIX_SCFG2; 	//  Slave Configuration Register 2
	AT91_REG	 HMATRIX_SCFG3; 	//  Slave Configuration Register 3
	AT91_REG	 HMATRIX_SCFG4; 	//  Slave Configuration Register 4
	AT91_REG	 HMATRIX_SCFG5; 	//  Slave Configuration Register 5
	AT91_REG	 HMATRIX_SCFG6; 	//  Slave Configuration Register 6
	AT91_REG	 HMATRIX_SCFG7; 	//  Slave Configuration Register 5
	AT91_REG	 HMATRIX_SCFG8; 	//  Slave Configuration Register 8
	AT91_REG	 HMATRIX_SCFG9; 	//  Slave Configuration Register 9
	AT91_REG	 Reserved3[42]; 	// 
	AT91_REG	 HMATRIX_SFR0 ; 	//  Special Function Register 0
	AT91_REG	 HMATRIX_SFR1 ; 	//  Special Function Register 1
	AT91_REG	 HMATRIX_SFR2 ; 	//  Special Function Register 2
	AT91_REG	 HMATRIX_SFR3 ; 	//  Special Function Register 3
	AT91_REG	 HMATRIX_SFR4 ; 	//  Special Function Register 4
	AT91_REG	 HMATRIX_SFR5 ; 	//  Special Function Register 5
	AT91_REG	 HMATRIX_SFR6 ; 	//  Special Function Register 6
	AT91_REG	 HMATRIX_SFR7 ; 	//  Special Function Register 7
	AT91_REG	 HMATRIX_SFR8 ; 	//  Special Function Register 8
	AT91_REG	 HMATRIX_SFR9 ; 	//  Special Function Register 9
	AT91_REG	 HMATRIX_SFR10; 	//  Special Function Register 10
	AT91_REG	 HMATRIX_SFR11; 	//  Special Function Register 11
	AT91_REG	 HMATRIX_SFR12; 	//  Special Function Register 12
	AT91_REG	 HMATRIX_SFR13; 	//  Special Function Register 13
	AT91_REG	 HMATRIX_SFR14; 	//  Special Function Register 14
	AT91_REG	 HMATRIX_SFR15; 	//  Special Function Register 15
	AT91_REG	 Reserved4[39]; 	// 
	AT91_REG	 HMATRIX_ADDRSIZE; 	// HMATRIX2 ADDRSIZE REGISTER 
	AT91_REG	 HMATRIX_IPNAME1; 	// HMATRIX2 IPNAME1 REGISTER 
	AT91_REG	 HMATRIX_IPNAME2; 	// HMATRIX2 IPNAME2 REGISTER 
	AT91_REG	 HMATRIX_FEATURES; 	// HMATRIX2 FEATURES REGISTER 
	AT91_REG	 HMATRIX_VER; 	// HMATRIX2 VERSION REGISTER 
	AT91_REG	 PMC_SCER; 	// System Clock Enable Register
	AT91_REG	 PMC_SCDR; 	// System Clock Disable Register
	AT91_REG	 PMC_SCSR; 	// System Clock Status Register
	AT91_REG	 Reserved5[1]; 	// 
	AT91_REG	 PMC_PCER; 	// Peripheral Clock Enable Register
	AT91_REG	 PMC_PCDR; 	// Peripheral Clock Disable Register
	AT91_REG	 PMC_PCSR; 	// Peripheral Clock Status Register
	AT91_REG	 PMC_UCKR; 	// UTMI Clock Configuration Register
	AT91_REG	 PMC_MOR; 	// Main Oscillator Register
	AT91_REG	 PMC_MCFR; 	// Main Clock  Frequency Register
	AT91_REG	 PMC_PLLAR; 	// PLL Register
	AT91_REG	 Reserved6[1]; 	// 
	AT91_REG	 PMC_MCKR; 	// Master Clock Register
	AT91_REG	 Reserved7[3]; 	// 
	AT91_REG	 PMC_PCKR[8]; 	// Programmable Clock Register
	AT91_REG	 PMC_IER; 	// Interrupt Enable Register
	AT91_REG	 PMC_IDR; 	// Interrupt Disable Register
	AT91_REG	 PMC_SR; 	// Status Register
	AT91_REG	 PMC_IMR; 	// Interrupt Mask Register
	AT91_REG	 PMC_FSMR; 	// Fast Startup Mode Register
	AT91_REG	 PMC_FSPR; 	// Fast Startup Polarity Register
	AT91_REG	 PMC_FOCR; 	// Fault Output Clear Register
	AT91_REG	 Reserved8[28]; 	// 
	AT91_REG	 PMC_ADDRSIZE; 	// PMC ADDRSIZE REGISTER 
	AT91_REG	 PMC_IPNAME1; 	// PMC IPNAME1 REGISTER 
	AT91_REG	 PMC_IPNAME2; 	// PMC IPNAME2 REGISTER 
	AT91_REG	 PMC_FEATURES; 	// PMC FEATURES REGISTER 
	AT91_REG	 PMC_VER; 	// APMC VERSION REGISTER
	AT91_REG	 Reserved9[64]; 	// 
	AT91_REG	 DBGU_CR; 	// Control Register
	AT91_REG	 DBGU_MR; 	// Mode Register
	AT91_REG	 DBGU_IER; 	// Interrupt Enable Register
	AT91_REG	 DBGU_IDR; 	// Interrupt Disable Register
	AT91_REG	 DBGU_IMR; 	// Interrupt Mask Register
	AT91_REG	 DBGU_CSR; 	// Channel Status Register
	AT91_REG	 DBGU_RHR; 	// Receiver Holding Register
	AT91_REG	 DBGU_THR; 	// Transmitter Holding Register
	AT91_REG	 DBGU_BRGR; 	// Baud Rate Generator Register
	AT91_REG	 Reserved10[9]; 	// 
	AT91_REG	 DBGU_FNTR; 	// Force NTRST Register
	AT91_REG	 Reserved11[40]; 	// 
	AT91_REG	 DBGU_ADDRSIZE; 	// DBGU ADDRSIZE REGISTER 
	AT91_REG	 DBGU_IPNAME1; 	// DBGU IPNAME1 REGISTER 
	AT91_REG	 DBGU_IPNAME2; 	// DBGU IPNAME2 REGISTER 
	AT91_REG	 DBGU_FEATURES; 	// DBGU FEATURES REGISTER 
	AT91_REG	 DBGU_VER; 	// DBGU VERSION REGISTER 
	AT91_REG	 DBGU_RPR; 	// Receive Pointer Register
	AT91_REG	 DBGU_RCR; 	// Receive Counter Register
	AT91_REG	 DBGU_TPR; 	// Transmit Pointer Register
	AT91_REG	 DBGU_TCR; 	// Transmit Counter Register
	AT91_REG	 DBGU_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 DBGU_RNCR; 	// Receive Next Counter Register
	AT91_REG	 DBGU_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 DBGU_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 DBGU_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 DBGU_PTSR; 	// PDC Transfer Status Register
	AT91_REG	 Reserved12[6]; 	// 
	AT91_REG	 DBGU_CIDR; 	// Chip ID Register
	AT91_REG	 DBGU_EXID; 	// Chip ID Extension Register
	AT91_REG	 Reserved13[46]; 	// 
	AT91_REG	 EFC0_FMR; 	// EFC Flash Mode Register
	AT91_REG	 EFC0_FCR; 	// EFC Flash Command Register
	AT91_REG	 EFC0_FSR; 	// EFC Flash Status Register
	AT91_REG	 EFC0_FRR; 	// EFC Flash Result Register
	AT91_REG	 Reserved14[1]; 	// 
	AT91_REG	 EFC0_FVR; 	// EFC Flash Version Register
	AT91_REG	 Reserved15[122]; 	// 
	AT91_REG	 EFC1_FMR; 	// EFC Flash Mode Register
	AT91_REG	 EFC1_FCR; 	// EFC Flash Command Register
	AT91_REG	 EFC1_FSR; 	// EFC Flash Status Register
	AT91_REG	 EFC1_FRR; 	// EFC Flash Result Register
	AT91_REG	 Reserved16[1]; 	// 
	AT91_REG	 EFC1_FVR; 	// EFC Flash Version Register
	AT91_REG	 Reserved17[122]; 	// 
	AT91_REG	 PIOA_PER; 	// PIO Enable Register
	AT91_REG	 PIOA_PDR; 	// PIO Disable Register
	AT91_REG	 PIOA_PSR; 	// PIO Status Register
	AT91_REG	 Reserved18[1]; 	// 
	AT91_REG	 PIOA_OER; 	// Output Enable Register
	AT91_REG	 PIOA_ODR; 	// Output Disable Registerr
	AT91_REG	 PIOA_OSR; 	// Output Status Register
	AT91_REG	 Reserved19[1]; 	// 
	AT91_REG	 PIOA_IFER; 	// Input Filter Enable Register
	AT91_REG	 PIOA_IFDR; 	// Input Filter Disable Register
	AT91_REG	 PIOA_IFSR; 	// Input Filter Status Register
	AT91_REG	 Reserved20[1]; 	// 
	AT91_REG	 PIOA_SODR; 	// Set Output Data Register
	AT91_REG	 PIOA_CODR; 	// Clear Output Data Register
	AT91_REG	 PIOA_ODSR; 	// Output Data Status Register
	AT91_REG	 PIOA_PDSR; 	// Pin Data Status Register
	AT91_REG	 PIOA_IER; 	// Interrupt Enable Register
	AT91_REG	 PIOA_IDR; 	// Interrupt Disable Register
	AT91_REG	 PIOA_IMR; 	// Interrupt Mask Register
	AT91_REG	 PIOA_ISR; 	// Interrupt Status Register
	AT91_REG	 PIOA_MDER; 	// Multi-driver Enable Register
	AT91_REG	 PIOA_MDDR; 	// Multi-driver Disable Register
	AT91_REG	 PIOA_MDSR; 	// Multi-driver Status Register
	AT91_REG	 Reserved21[1]; 	// 
	AT91_REG	 PIOA_PPUDR; 	// Pull-up Disable Register
	AT91_REG	 PIOA_PPUER; 	// Pull-up Enable Register
	AT91_REG	 PIOA_PPUSR; 	// Pull-up Status Register
	AT91_REG	 Reserved22[1]; 	// 
	AT91_REG	 PIOA_ABSR; 	// Peripheral AB Select Register
	AT91_REG	 Reserved23[3]; 	// 
	AT91_REG	 PIOA_SCIFSR; 	// System Clock Glitch Input Filter Select Register
	AT91_REG	 PIOA_DIFSR; 	// Debouncing Input Filter Select Register
	AT91_REG	 PIOA_IFDGSR; 	// Glitch or Debouncing Input Filter Clock Selection Status Register
	AT91_REG	 PIOA_SCDR; 	// Slow Clock Divider Debouncing Register
	AT91_REG	 Reserved24[4]; 	// 
	AT91_REG	 PIOA_OWER; 	// Output Write Enable Register
	AT91_REG	 PIOA_OWDR; 	// Output Write Disable Register
	AT91_REG	 PIOA_OWSR; 	// Output Write Status Register
	AT91_REG	 Reserved25[1]; 	// 
	AT91_REG	 PIOA_AIMER; 	// Additional Interrupt Modes Enable Register
	AT91_REG	 PIOA_AIMDR; 	// Additional Interrupt Modes Disables Register
	AT91_REG	 PIOA_AIMMR; 	// Additional Interrupt Modes Mask Register
	AT91_REG	 Reserved26[1]; 	// 
	AT91_REG	 PIOA_ESR; 	// Edge Select Register
	AT91_REG	 PIOA_LSR; 	// Level Select Register
	AT91_REG	 PIOA_ELSR; 	// Edge/Level Status Register
	AT91_REG	 Reserved27[1]; 	// 
	AT91_REG	 PIOA_FELLSR; 	// Falling Edge/Low Level Select Register
	AT91_REG	 PIOA_REHLSR; 	// Rising Edge/ High Level Select Register
	AT91_REG	 PIOA_FRLHSR; 	// Fall/Rise - Low/High Status Register
	AT91_REG	 Reserved28[1]; 	// 
	AT91_REG	 PIOA_LOCKSR; 	// Lock Status Register
	AT91_REG	 Reserved29[6]; 	// 
	AT91_REG	 PIOA_VER; 	// PIO VERSION REGISTER 
	AT91_REG	 Reserved30[8]; 	// 
	AT91_REG	 PIOA_KER; 	// Keypad Controller Enable Register
	AT91_REG	 PIOA_KRCR; 	// Keypad Controller Row Column Register
	AT91_REG	 PIOA_KDR; 	// Keypad Controller Debouncing Register
	AT91_REG	 Reserved31[1]; 	// 
	AT91_REG	 PIOA_KIER; 	// Keypad Controller Interrupt Enable Register
	AT91_REG	 PIOA_KIDR; 	// Keypad Controller Interrupt Disable Register
	AT91_REG	 PIOA_KIMR; 	// Keypad Controller Interrupt Mask Register
	AT91_REG	 PIOA_KSR; 	// Keypad Controller Status Register
	AT91_REG	 PIOA_KKPR; 	// Keypad Controller Key Press Register
	AT91_REG	 PIOA_KKRR; 	// Keypad Controller Key Release Register
	AT91_REG	 Reserved32[46]; 	// 
	AT91_REG	 PIOB_PER; 	// PIO Enable Register
	AT91_REG	 PIOB_PDR; 	// PIO Disable Register
	AT91_REG	 PIOB_PSR; 	// PIO Status Register
	AT91_REG	 Reserved33[1]; 	// 
	AT91_REG	 PIOB_OER; 	// Output Enable Register
	AT91_REG	 PIOB_ODR; 	// Output Disable Registerr
	AT91_REG	 PIOB_OSR; 	// Output Status Register
	AT91_REG	 Reserved34[1]; 	// 
	AT91_REG	 PIOB_IFER; 	// Input Filter Enable Register
	AT91_REG	 PIOB_IFDR; 	// Input Filter Disable Register
	AT91_REG	 PIOB_IFSR; 	// Input Filter Status Register
	AT91_REG	 Reserved35[1]; 	// 
	AT91_REG	 PIOB_SODR; 	// Set Output Data Register
	AT91_REG	 PIOB_CODR; 	// Clear Output Data Register
	AT91_REG	 PIOB_ODSR; 	// Output Data Status Register
	AT91_REG	 PIOB_PDSR; 	// Pin Data Status Register
	AT91_REG	 PIOB_IER; 	// Interrupt Enable Register
	AT91_REG	 PIOB_IDR; 	// Interrupt Disable Register
	AT91_REG	 PIOB_IMR; 	// Interrupt Mask Register
	AT91_REG	 PIOB_ISR; 	// Interrupt Status Register
	AT91_REG	 PIOB_MDER; 	// Multi-driver Enable Register
	AT91_REG	 PIOB_MDDR; 	// Multi-driver Disable Register
	AT91_REG	 PIOB_MDSR; 	// Multi-driver Status Register
	AT91_REG	 Reserved36[1]; 	// 
	AT91_REG	 PIOB_PPUDR; 	// Pull-up Disable Register
	AT91_REG	 PIOB_PPUER; 	// Pull-up Enable Register
	AT91_REG	 PIOB_PPUSR; 	// Pull-up Status Register
	AT91_REG	 Reserved37[1]; 	// 
	AT91_REG	 PIOB_ABSR; 	// Peripheral AB Select Register
	AT91_REG	 Reserved38[3]; 	// 
	AT91_REG	 PIOB_SCIFSR; 	// System Clock Glitch Input Filter Select Register
	AT91_REG	 PIOB_DIFSR; 	// Debouncing Input Filter Select Register
	AT91_REG	 PIOB_IFDGSR; 	// Glitch or Debouncing Input Filter Clock Selection Status Register
	AT91_REG	 PIOB_SCDR; 	// Slow Clock Divider Debouncing Register
	AT91_REG	 Reserved39[4]; 	// 
	AT91_REG	 PIOB_OWER; 	// Output Write Enable Register
	AT91_REG	 PIOB_OWDR; 	// Output Write Disable Register
	AT91_REG	 PIOB_OWSR; 	// Output Write Status Register
	AT91_REG	 Reserved40[1]; 	// 
	AT91_REG	 PIOB_AIMER; 	// Additional Interrupt Modes Enable Register
	AT91_REG	 PIOB_AIMDR; 	// Additional Interrupt Modes Disables Register
	AT91_REG	 PIOB_AIMMR; 	// Additional Interrupt Modes Mask Register
	AT91_REG	 Reserved41[1]; 	// 
	AT91_REG	 PIOB_ESR; 	// Edge Select Register
	AT91_REG	 PIOB_LSR; 	// Level Select Register
	AT91_REG	 PIOB_ELSR; 	// Edge/Level Status Register
	AT91_REG	 Reserved42[1]; 	// 
	AT91_REG	 PIOB_FELLSR; 	// Falling Edge/Low Level Select Register
	AT91_REG	 PIOB_REHLSR; 	// Rising Edge/ High Level Select Register
	AT91_REG	 PIOB_FRLHSR; 	// Fall/Rise - Low/High Status Register
	AT91_REG	 Reserved43[1]; 	// 
	AT91_REG	 PIOB_LOCKSR; 	// Lock Status Register
	AT91_REG	 Reserved44[6]; 	// 
	AT91_REG	 PIOB_VER; 	// PIO VERSION REGISTER 
	AT91_REG	 Reserved45[8]; 	// 
	AT91_REG	 PIOB_KER; 	// Keypad Controller Enable Register
	AT91_REG	 PIOB_KRCR; 	// Keypad Controller Row Column Register
	AT91_REG	 PIOB_KDR; 	// Keypad Controller Debouncing Register
	AT91_REG	 Reserved46[1]; 	// 
	AT91_REG	 PIOB_KIER; 	// Keypad Controller Interrupt Enable Register
	AT91_REG	 PIOB_KIDR; 	// Keypad Controller Interrupt Disable Register
	AT91_REG	 PIOB_KIMR; 	// Keypad Controller Interrupt Mask Register
	AT91_REG	 PIOB_KSR; 	// Keypad Controller Status Register
	AT91_REG	 PIOB_KKPR; 	// Keypad Controller Key Press Register
	AT91_REG	 PIOB_KKRR; 	// Keypad Controller Key Release Register
	AT91_REG	 Reserved47[46]; 	// 
	AT91_REG	 PIOC_PER; 	// PIO Enable Register
	AT91_REG	 PIOC_PDR; 	// PIO Disable Register
	AT91_REG	 PIOC_PSR; 	// PIO Status Register
	AT91_REG	 Reserved48[1]; 	// 
	AT91_REG	 PIOC_OER; 	// Output Enable Register
	AT91_REG	 PIOC_ODR; 	// Output Disable Registerr
	AT91_REG	 PIOC_OSR; 	// Output Status Register
	AT91_REG	 Reserved49[1]; 	// 
	AT91_REG	 PIOC_IFER; 	// Input Filter Enable Register
	AT91_REG	 PIOC_IFDR; 	// Input Filter Disable Register
	AT91_REG	 PIOC_IFSR; 	// Input Filter Status Register
	AT91_REG	 Reserved50[1]; 	// 
	AT91_REG	 PIOC_SODR; 	// Set Output Data Register
	AT91_REG	 PIOC_CODR; 	// Clear Output Data Register
	AT91_REG	 PIOC_ODSR; 	// Output Data Status Register
	AT91_REG	 PIOC_PDSR; 	// Pin Data Status Register
	AT91_REG	 PIOC_IER; 	// Interrupt Enable Register
	AT91_REG	 PIOC_IDR; 	// Interrupt Disable Register
	AT91_REG	 PIOC_IMR; 	// Interrupt Mask Register
	AT91_REG	 PIOC_ISR; 	// Interrupt Status Register
	AT91_REG	 PIOC_MDER; 	// Multi-driver Enable Register
	AT91_REG	 PIOC_MDDR; 	// Multi-driver Disable Register
	AT91_REG	 PIOC_MDSR; 	// Multi-driver Status Register
	AT91_REG	 Reserved51[1]; 	// 
	AT91_REG	 PIOC_PPUDR; 	// Pull-up Disable Register
	AT91_REG	 PIOC_PPUER; 	// Pull-up Enable Register
	AT91_REG	 PIOC_PPUSR; 	// Pull-up Status Register
	AT91_REG	 Reserved52[1]; 	// 
	AT91_REG	 PIOC_ABSR; 	// Peripheral AB Select Register
	AT91_REG	 Reserved53[3]; 	// 
	AT91_REG	 PIOC_SCIFSR; 	// System Clock Glitch Input Filter Select Register
	AT91_REG	 PIOC_DIFSR; 	// Debouncing Input Filter Select Register
	AT91_REG	 PIOC_IFDGSR; 	// Glitch or Debouncing Input Filter Clock Selection Status Register
	AT91_REG	 PIOC_SCDR; 	// Slow Clock Divider Debouncing Register
	AT91_REG	 Reserved54[4]; 	// 
	AT91_REG	 PIOC_OWER; 	// Output Write Enable Register
	AT91_REG	 PIOC_OWDR; 	// Output Write Disable Register
	AT91_REG	 PIOC_OWSR; 	// Output Write Status Register
	AT91_REG	 Reserved55[1]; 	// 
	AT91_REG	 PIOC_AIMER; 	// Additional Interrupt Modes Enable Register
	AT91_REG	 PIOC_AIMDR; 	// Additional Interrupt Modes Disables Register
	AT91_REG	 PIOC_AIMMR; 	// Additional Interrupt Modes Mask Register
	AT91_REG	 Reserved56[1]; 	// 
	AT91_REG	 PIOC_ESR; 	// Edge Select Register
	AT91_REG	 PIOC_LSR; 	// Level Select Register
	AT91_REG	 PIOC_ELSR; 	// Edge/Level Status Register
	AT91_REG	 Reserved57[1]; 	// 
	AT91_REG	 PIOC_FELLSR; 	// Falling Edge/Low Level Select Register
	AT91_REG	 PIOC_REHLSR; 	// Rising Edge/ High Level Select Register
	AT91_REG	 PIOC_FRLHSR; 	// Fall/Rise - Low/High Status Register
	AT91_REG	 Reserved58[1]; 	// 
	AT91_REG	 PIOC_LOCKSR; 	// Lock Status Register
	AT91_REG	 Reserved59[6]; 	// 
	AT91_REG	 PIOC_VER; 	// PIO VERSION REGISTER 
	AT91_REG	 Reserved60[8]; 	// 
	AT91_REG	 PIOC_KER; 	// Keypad Controller Enable Register
	AT91_REG	 PIOC_KRCR; 	// Keypad Controller Row Column Register
	AT91_REG	 PIOC_KDR; 	// Keypad Controller Debouncing Register
	AT91_REG	 Reserved61[1]; 	// 
	AT91_REG	 PIOC_KIER; 	// Keypad Controller Interrupt Enable Register
	AT91_REG	 PIOC_KIDR; 	// Keypad Controller Interrupt Disable Register
	AT91_REG	 PIOC_KIMR; 	// Keypad Controller Interrupt Mask Register
	AT91_REG	 PIOC_KSR; 	// Keypad Controller Status Register
	AT91_REG	 PIOC_KKPR; 	// Keypad Controller Key Press Register
	AT91_REG	 PIOC_KKRR; 	// Keypad Controller Key Release Register
	AT91_REG	 Reserved62[46]; 	// 
	AT91_REG	 RSTC_RCR; 	// Reset Control Register
	AT91_REG	 RSTC_RSR; 	// Reset Status Register
	AT91_REG	 RSTC_RMR; 	// Reset Mode Register
	AT91_REG	 Reserved63[1]; 	// 
    AT91_REG SUPC_CR;   // Supply Controller Control Register
    AT91_REG SUPC_SMMR; // Supply Controller Supply Monitor Mode Register
    AT91_REG SUPC_MR;   // Supply Controller Mode Register
    AT91_REG SUPC_WUMR; // Supply Controller Wake Up Mode Register
    AT91_REG SUPC_WUIR; // Supply Controller Wake Up Inputs Register
    AT91_REG SUPC_SR;   // Supply Controller Status Register
	AT91_REG	 Reserved64[2]; 	// 

	AT91_REG	 RTTC_RTMR; 	// Real-time Mode Register
	AT91_REG	 RTTC_RTAR; 	// Real-time Alarm Register
	AT91_REG	 RTTC_RTVR; 	// Real-time Value Register
	AT91_REG	 RTTC_RTSR; 	// Real-time Status Register
	AT91_REG	 Reserved65[4]; 	// 
	AT91_REG	 WDTC_WDCR; 	// Watchdog Control Register
	AT91_REG	 WDTC_WDMR; 	// Watchdog Mode Register
	AT91_REG	 WDTC_WDSR; 	// Watchdog Status Register
	AT91_REG	 Reserved66[1]; 	// 
	AT91_REG	 RTC_CR; 	// Control Register
	AT91_REG	 RTC_MR; 	// Mode Register
	AT91_REG	 RTC_TIMR; 	// Time Register
	AT91_REG	 RTC_CALR; 	// Calendar Register
	AT91_REG	 RTC_TIMALR; 	// Time Alarm Register
	AT91_REG	 RTC_CALALR; 	// Calendar Alarm Register
	AT91_REG	 RTC_SR; 	// Status Register
	AT91_REG	 RTC_SCCR; 	// Status Clear Command Register
	AT91_REG	 RTC_IER; 	// Interrupt Enable Register
	AT91_REG	 RTC_IDR; 	// Interrupt Disable Register
	AT91_REG	 RTC_IMR; 	// Interrupt Mask Register
	AT91_REG	 RTC_VER; 	// Valid Entry Register
	AT91_REG	 SYS_GPBR[8]; 	// General Purpose Register
	AT91_REG	 Reserved67[19]; 	// 
	AT91_REG	 RSTC_VER; 	// Version Register
} AT91S_SYS, *AT91PS_SYS;
// -------- GPBR : (SYS Offset: 0x1290) GPBR General Purpose Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR HSMC4 Chip Select interface
// *****************************************************************************
typedef struct _AT91S_HSMC4_CS {
	AT91_REG	 HSMC4_SETUP; 	// Setup Register
	AT91_REG	 HSMC4_PULSE; 	// Pulse Register
	AT91_REG	 HSMC4_CYCLE; 	// Cycle Register
	AT91_REG	 HSMC4_TIMINGS; 	// Timmings Register
	AT91_REG	 HSMC4_MODE; 	// Mode Register
} AT91S_HSMC4_CS, *AT91PS_HSMC4_CS;
// -------- HSMC4_SETUP : (HSMC4_CS Offset: 0x0) HSMC4 SETUP -------- 
// -------- HSMC4_PULSE : (HSMC4_CS Offset: 0x4) HSMC4 PULSE -------- 
// -------- HSMC4_CYCLE : (HSMC4_CS Offset: 0x8) HSMC4 CYCLE -------- 
// -------- HSMC4_TIMINGS : (HSMC4_CS Offset: 0xc) HSMC4 TIMINGS -------- 
// -------- HSMC4_MODE : (HSMC4_CS Offset: 0x10) HSMC4 MODE -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR AHB Static Memory Controller 4 Interface
// *****************************************************************************
typedef struct _AT91S_HSMC4 {
	AT91_REG	 HSMC4_CFG; 	// Configuration Register
	AT91_REG	 HSMC4_CTRL; 	// Control Register
	AT91_REG	 HSMC4_SR; 	// Status Register
	AT91_REG	 HSMC4_IER; 	// Interrupt Enable Register
	AT91_REG	 HSMC4_IDR; 	// Interrupt Disable Register
	AT91_REG	 HSMC4_IMR; 	// Interrupt Mask Register
	AT91_REG	 HSMC4_ADDR; 	// Address Cycle Zero Register
	AT91_REG	 HSMC4_BANK; 	// Bank Register
	AT91_REG	 HSMC4_ECCCR; 	// ECC reset register
	AT91_REG	 HSMC4_ECCCMD; 	// ECC Page size register
	AT91_REG	 HSMC4_ECCSR1; 	// ECC Status register 1
	AT91_REG	 HSMC4_ECCPR0; 	// ECC Parity register 0
	AT91_REG	 HSMC4_ECCPR1; 	// ECC Parity register 1
	AT91_REG	 HSMC4_ECCSR2; 	// ECC Status register 2
	AT91_REG	 HSMC4_ECCPR2; 	// ECC Parity register 2
	AT91_REG	 HSMC4_ECCPR3; 	// ECC Parity register 3
	AT91_REG	 HSMC4_ECCPR4; 	// ECC Parity register 4
	AT91_REG	 HSMC4_ECCPR5; 	// ECC Parity register 5
	AT91_REG	 HSMC4_ECCPR6; 	// ECC Parity register 6
	AT91_REG	 HSMC4_ECCPR7; 	// ECC Parity register 7
	AT91_REG	 HSMC4_ECCPR8; 	// ECC Parity register 8
	AT91_REG	 HSMC4_ECCPR9; 	// ECC Parity register 9
	AT91_REG	 HSMC4_ECCPR10; 	// ECC Parity register 10
	AT91_REG	 HSMC4_ECCPR11; 	// ECC Parity register 11
	AT91_REG	 HSMC4_ECCPR12; 	// ECC Parity register 12
	AT91_REG	 HSMC4_ECCPR13; 	// ECC Parity register 13
	AT91_REG	 HSMC4_ECCPR14; 	// ECC Parity register 14
	AT91_REG	 HSMC4_Eccpr15; 	// ECC Parity register 15
	AT91_REG	 Reserved0[40]; 	// 
	AT91_REG	 HSMC4_OCMS; 	// OCMS MODE register
	AT91_REG	 HSMC4_KEY1; 	// KEY1 Register
	AT91_REG	 HSMC4_KEY2; 	// KEY2 Register
	AT91_REG	 Reserved1[50]; 	// 
	AT91_REG	 HSMC4_WPCR; 	// Write Protection Control register
	AT91_REG	 HSMC4_WPSR; 	// Write Protection Status Register
	AT91_REG	 HSMC4_ADDRSIZE; 	// Write Protection Status Register
	AT91_REG	 HSMC4_IPNAME1; 	// Write Protection Status Register
	AT91_REG	 HSMC4_IPNAME2; 	// Write Protection Status Register
	AT91_REG	 HSMC4_FEATURES; 	// Write Protection Status Register
	AT91_REG	 HSMC4_VER; 	// HSMC4 Version Register
	AT91_REG	 HSMC4_DUMMY; 	// This rtegister was created only ti have AHB constants
} AT91S_HSMC4, *AT91PS_HSMC4;
// -------- HSMC4_CFG : (HSMC4 Offset: 0x0) Configuration Register -------- 
// -------- HSMC4_CTRL : (HSMC4 Offset: 0x4) Control Register -------- 
// -------- HSMC4_SR : (HSMC4 Offset: 0x8) HSMC4 Status Register -------- 
// -------- HSMC4_IER : (HSMC4 Offset: 0xc) HSMC4 Interrupt Enable Register -------- 
// -------- HSMC4_IDR : (HSMC4 Offset: 0x10) HSMC4 Interrupt Disable Register -------- 
// -------- HSMC4_IMR : (HSMC4 Offset: 0x14) HSMC4 Interrupt Mask Register -------- 
// -------- HSMC4_ADDR : (HSMC4 Offset: 0x18) Address Cycle Zero Register -------- 
// -------- HSMC4_BANK : (HSMC4 Offset: 0x1c) Bank Register -------- 
// -------- HSMC4_ECCCR : (HSMC4 Offset: 0x20) ECC Control Register -------- 
// -------- HSMC4_ECCCMD : (HSMC4 Offset: 0x24) ECC mode register -------- 
// -------- HSMC4_ECCSR1 : (HSMC4 Offset: 0x28) ECC Status Register 1 -------- 
// -------- HSMC4_ECCPR0 : (HSMC4 Offset: 0x2c) HSMC4 ECC parity Register 0 -------- 
// -------- HSMC4_ECCPR1 : (HSMC4 Offset: 0x30) HSMC4 ECC parity Register 1 -------- 
// -------- HSMC4_ECCSR2 : (HSMC4 Offset: 0x34) ECC Status Register 2 -------- 
// -------- HSMC4_ECCPR2 : (HSMC4 Offset: 0x38) HSMC4 ECC parity Register 2 -------- 
// -------- HSMC4_ECCPR3 : (HSMC4 Offset: 0x3c) HSMC4 ECC parity Register 3 -------- 
// -------- HSMC4_ECCPR4 : (HSMC4 Offset: 0x40) HSMC4 ECC parity Register 4 -------- 
// -------- HSMC4_ECCPR5 : (HSMC4 Offset: 0x44) HSMC4 ECC parity Register 5 -------- 
// -------- HSMC4_ECCPR6 : (HSMC4 Offset: 0x48) HSMC4 ECC parity Register 6 -------- 
// -------- HSMC4_ECCPR7 : (HSMC4 Offset: 0x4c) HSMC4 ECC parity Register 7 -------- 
// -------- HSMC4_ECCPR8 : (HSMC4 Offset: 0x50) HSMC4 ECC parity Register 8 -------- 
// -------- HSMC4_ECCPR9 : (HSMC4 Offset: 0x54) HSMC4 ECC parity Register 9 -------- 
// -------- HSMC4_ECCPR10 : (HSMC4 Offset: 0x58) HSMC4 ECC parity Register 10 -------- 
// -------- HSMC4_ECCPR11 : (HSMC4 Offset: 0x5c) HSMC4 ECC parity Register 11 -------- 
// -------- HSMC4_ECCPR12 : (HSMC4 Offset: 0x60) HSMC4 ECC parity Register 12 -------- 
// -------- HSMC4_ECCPR13 : (HSMC4 Offset: 0x64) HSMC4 ECC parity Register 13 -------- 
// -------- HSMC4_ECCPR14 : (HSMC4 Offset: 0x68) HSMC4 ECC parity Register 14 -------- 
// -------- HSMC4_ECCPR15 : (HSMC4 Offset: 0x6c) HSMC4 ECC parity Register 15 -------- 
// -------- HSMC4_OCMS : (HSMC4 Offset: 0x110) HSMC4 OCMS Register -------- 
// -------- HSMC4_KEY1 : (HSMC4 Offset: 0x114) HSMC4 OCMS KEY1 Register -------- 
// -------- HSMC4_OCMS_KEY2 : (HSMC4 Offset: 0x118) HSMC4 OCMS KEY2 Register -------- 
// -------- HSMC4_WPCR : (HSMC4 Offset: 0x1e4) HSMC4 Witre Protection Control Register -------- 
// -------- HSMC4_WPSR : (HSMC4 Offset: 0x1e8) HSMC4 WPSR Register -------- 
// -------- HSMC4_VER : (HSMC4 Offset: 0x1fc) HSMC4 VERSION Register -------- 
// -------- HSMC4_DUMMY : (HSMC4 Offset: 0x200) HSMC4 DUMMY REGISTER -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR AHB Matrix2 Interface
// *****************************************************************************
typedef struct _AT91S_HMATRIX2 {
	AT91_REG	 HMATRIX2_MCFG0; 	//  Master Configuration Register 0 : ARM I and D
	AT91_REG	 HMATRIX2_MCFG1; 	//  Master Configuration Register 1 : ARM S
	AT91_REG	 HMATRIX2_MCFG2; 	//  Master Configuration Register 2
	AT91_REG	 HMATRIX2_MCFG3; 	//  Master Configuration Register 3
	AT91_REG	 HMATRIX2_MCFG4; 	//  Master Configuration Register 4
	AT91_REG	 HMATRIX2_MCFG5; 	//  Master Configuration Register 5
	AT91_REG	 HMATRIX2_MCFG6; 	//  Master Configuration Register 6
	AT91_REG	 HMATRIX2_MCFG7; 	//  Master Configuration Register 7
	AT91_REG	 Reserved0[8]; 	// 
	AT91_REG	 HMATRIX2_SCFG0; 	//  Slave Configuration Register 0
	AT91_REG	 HMATRIX2_SCFG1; 	//  Slave Configuration Register 1
	AT91_REG	 HMATRIX2_SCFG2; 	//  Slave Configuration Register 2
	AT91_REG	 HMATRIX2_SCFG3; 	//  Slave Configuration Register 3
	AT91_REG	 HMATRIX2_SCFG4; 	//  Slave Configuration Register 4
	AT91_REG	 HMATRIX2_SCFG5; 	//  Slave Configuration Register 5
	AT91_REG	 HMATRIX2_SCFG6; 	//  Slave Configuration Register 6
	AT91_REG	 HMATRIX2_SCFG7; 	//  Slave Configuration Register 5
	AT91_REG	 HMATRIX2_SCFG8; 	//  Slave Configuration Register 8
	AT91_REG	 HMATRIX2_SCFG9; 	//  Slave Configuration Register 9
	AT91_REG	 Reserved1[42]; 	// 
	AT91_REG	 HMATRIX2_SFR0 ; 	//  Special Function Register 0
	AT91_REG	 HMATRIX2_SFR1 ; 	//  Special Function Register 1
	AT91_REG	 HMATRIX2_SFR2 ; 	//  Special Function Register 2
	AT91_REG	 HMATRIX2_SFR3 ; 	//  Special Function Register 3
	AT91_REG	 HMATRIX2_SFR4 ; 	//  Special Function Register 4
	AT91_REG	 HMATRIX2_SFR5 ; 	//  Special Function Register 5
	AT91_REG	 HMATRIX2_SFR6 ; 	//  Special Function Register 6
	AT91_REG	 HMATRIX2_SFR7 ; 	//  Special Function Register 7
	AT91_REG	 HMATRIX2_SFR8 ; 	//  Special Function Register 8
	AT91_REG	 HMATRIX2_SFR9 ; 	//  Special Function Register 9
	AT91_REG	 HMATRIX2_SFR10; 	//  Special Function Register 10
	AT91_REG	 HMATRIX2_SFR11; 	//  Special Function Register 11
	AT91_REG	 HMATRIX2_SFR12; 	//  Special Function Register 12
	AT91_REG	 HMATRIX2_SFR13; 	//  Special Function Register 13
	AT91_REG	 HMATRIX2_SFR14; 	//  Special Function Register 14
	AT91_REG	 HMATRIX2_SFR15; 	//  Special Function Register 15
	AT91_REG	 Reserved2[39]; 	// 
	AT91_REG	 HMATRIX2_ADDRSIZE; 	// HMATRIX2 ADDRSIZE REGISTER 
	AT91_REG	 HMATRIX2_IPNAME1; 	// HMATRIX2 IPNAME1 REGISTER 
	AT91_REG	 HMATRIX2_IPNAME2; 	// HMATRIX2 IPNAME2 REGISTER 
	AT91_REG	 HMATRIX2_FEATURES; 	// HMATRIX2 FEATURES REGISTER 
	AT91_REG	 HMATRIX2_VER; 	// HMATRIX2 VERSION REGISTER 
} AT91S_HMATRIX2, *AT91PS_HMATRIX2;
// -------- MATRIX_MCFG0 : (HMATRIX2 Offset: 0x0) Master Configuration Register ARM bus I and D -------- 
// -------- MATRIX_MCFG1 : (HMATRIX2 Offset: 0x4) Master Configuration Register ARM bus S -------- 
// -------- MATRIX_MCFG2 : (HMATRIX2 Offset: 0x8) Master Configuration Register -------- 
// -------- MATRIX_MCFG3 : (HMATRIX2 Offset: 0xc) Master Configuration Register -------- 
// -------- MATRIX_MCFG4 : (HMATRIX2 Offset: 0x10) Master Configuration Register -------- 
// -------- MATRIX_MCFG5 : (HMATRIX2 Offset: 0x14) Master Configuration Register -------- 
// -------- MATRIX_MCFG6 : (HMATRIX2 Offset: 0x18) Master Configuration Register -------- 
// -------- MATRIX_MCFG7 : (HMATRIX2 Offset: 0x1c) Master Configuration Register -------- 
// -------- MATRIX_SCFG0 : (HMATRIX2 Offset: 0x40) Slave Configuration Register 0 -------- 
// -------- MATRIX_SCFG1 : (HMATRIX2 Offset: 0x44) Slave Configuration Register 1 -------- 
// -------- MATRIX_SCFG2 : (HMATRIX2 Offset: 0x48) Slave Configuration Register 2 -------- 
// -------- MATRIX_SCFG3 : (HMATRIX2 Offset: 0x4c) Slave Configuration Register 3 -------- 
// -------- MATRIX_SCFG4 : (HMATRIX2 Offset: 0x50) Slave Configuration Register 4 -------- 
// -------- MATRIX_SCFG5 : (HMATRIX2 Offset: 0x54) Slave Configuration Register 5 -------- 
// -------- MATRIX_SCFG6 : (HMATRIX2 Offset: 0x58) Slave Configuration Register 6 -------- 
// -------- MATRIX_SCFG7 : (HMATRIX2 Offset: 0x5c) Slave Configuration Register 7 -------- 
// -------- MATRIX_SCFG8 : (HMATRIX2 Offset: 0x60) Slave Configuration Register 8 -------- 
// -------- MATRIX_SCFG9 : (HMATRIX2 Offset: 0x64) Slave Configuration Register 9 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x110) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x114) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x118) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x11c) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x120) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x124) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x128) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x12c) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x130) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x134) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x138) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x13c) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x140) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x144) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x148) Special Function Register 0 -------- 
// -------- MATRIX_SFR0 : (HMATRIX2 Offset: 0x14c) Special Function Register 0 -------- 
// -------- HMATRIX2_VER : (HMATRIX2 Offset: 0x1fc)  VERSION  Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR NESTED vector Interrupt Controller
// *****************************************************************************
typedef struct _AT91S_NVIC {
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 NVIC_ICTR; 	// Interrupt Control Type Register
	AT91_REG	 Reserved1[2]; 	// 
	AT91_REG	 NVIC_STICKCSR; 	// SysTick Control and Status Register
	AT91_REG	 NVIC_STICKRVR; 	// SysTick Reload Value Register
	AT91_REG	 NVIC_STICKCVR; 	// SysTick Current Value Register
	AT91_REG	 NVIC_STICKCALVR; 	// SysTick Calibration Value Register
	AT91_REG	 Reserved2[56]; 	// 
	AT91_REG	 NVIC_ISER[8]; 	// Set Enable Register
	AT91_REG	 Reserved3[24]; 	// 
	AT91_REG	 NVIC_ICER[8]; 	// Clear enable Register
	AT91_REG	 Reserved4[24]; 	// 
	AT91_REG	 NVIC_ISPR[8]; 	// Set Pending Register
	AT91_REG	 Reserved5[24]; 	// 
	AT91_REG	 NVIC_ICPR[8]; 	// Clear Pending Register
	AT91_REG	 Reserved6[24]; 	// 
	AT91_REG	 NVIC_ABR[8]; 	// Active Bit Register
	AT91_REG	 Reserved7[56]; 	// 
	AT91_REG	 NVIC_IPR[60]; 	// Interrupt Mask Register
	AT91_REG	 Reserved8[516]; 	// 
	AT91_REG	 NVIC_CPUID; 	// CPUID Base Register
	AT91_REG	 NVIC_ICSR; 	// Interrupt Control State Register
	AT91_REG	 NVIC_VTOFFR; 	// Vector Table Offset Register
	AT91_REG	 NVIC_AIRCR; 	// Application Interrupt/Reset Control Reg
	AT91_REG	 NVIC_SCR; 	// System Control Register
	AT91_REG	 NVIC_CCR; 	// Configuration Control Register
	AT91_REG	 NVIC_HAND4PR; 	// System Handlers 4-7 Priority Register
	AT91_REG	 NVIC_HAND8PR; 	// System Handlers 8-11 Priority Register
	AT91_REG	 NVIC_HAND12PR; 	// System Handlers 12-15 Priority Register
	AT91_REG	 NVIC_HANDCSR; 	// System Handler Control and State Register
	AT91_REG	 NVIC_CFSR; 	// Configurable Fault Status Register
	AT91_REG	 NVIC_HFSR; 	// Hard Fault Status Register
	AT91_REG	 NVIC_DFSR; 	// Debug Fault Status Register
	AT91_REG	 NVIC_MMAR; 	// Mem Manage Address Register
	AT91_REG	 NVIC_BFAR; 	// Bus Fault Address Register
	AT91_REG	 NVIC_AFSR; 	// Auxiliary Fault Status Register
	AT91_REG	 NVIC_PFR0; 	// Processor Feature register0
	AT91_REG	 NVIC_PFR1; 	// Processor Feature register1
	AT91_REG	 NVIC_DFR0; 	// Debug Feature register0
	AT91_REG	 NVIC_AFR0; 	// Auxiliary Feature register0
	AT91_REG	 NVIC_MMFR0; 	// Memory Model Feature register0
	AT91_REG	 NVIC_MMFR1; 	// Memory Model Feature register1
	AT91_REG	 NVIC_MMFR2; 	// Memory Model Feature register2
	AT91_REG	 NVIC_MMFR3; 	// Memory Model Feature register3
	AT91_REG	 NVIC_ISAR0; 	// ISA Feature register0
	AT91_REG	 NVIC_ISAR1; 	// ISA Feature register1
	AT91_REG	 NVIC_ISAR2; 	// ISA Feature register2
	AT91_REG	 NVIC_ISAR3; 	// ISA Feature register3
	AT91_REG	 NVIC_ISAR4; 	// ISA Feature register4
	AT91_REG	 Reserved9[99]; 	// 
	AT91_REG	 NVIC_STIR; 	// Software Trigger Interrupt Register
	AT91_REG	 Reserved10[51]; 	// 
	AT91_REG	 NVIC_PID4; 	// Peripheral identification register
	AT91_REG	 NVIC_PID5; 	// Peripheral identification register
	AT91_REG	 NVIC_PID6; 	// Peripheral identification register
	AT91_REG	 NVIC_PID7; 	// Peripheral identification register
	AT91_REG	 NVIC_PID0; 	// Peripheral identification register b7:0
	AT91_REG	 NVIC_PID1; 	// Peripheral identification register b15:8
	AT91_REG	 NVIC_PID2; 	// Peripheral identification register b23:16
	AT91_REG	 NVIC_PID3; 	// Peripheral identification register b31:24
	AT91_REG	 NVIC_CID0; 	// Component identification register b7:0
	AT91_REG	 NVIC_CID1; 	// Component identification register b15:8
	AT91_REG	 NVIC_CID2; 	// Component identification register b23:16
	AT91_REG	 NVIC_CID3; 	// Component identification register b31:24
} AT91S_NVIC, *AT91PS_NVIC;
// -------- NVIC_ICTR : (NVIC Offset: 0x4) Interrupt Controller Type Register -------- 
// -------- NVIC_STICKCSR : (NVIC Offset: 0x10) SysTick Control and Status Register -------- 
// -------- NVIC_STICKRVR : (NVIC Offset: 0x14) SysTick Reload Value Register -------- 
// -------- NVIC_STICKCVR : (NVIC Offset: 0x18) SysTick Current Value Register -------- 
// -------- NVIC_STICKCALVR : (NVIC Offset: 0x1c) SysTick Calibration Value Register -------- 
// -------- NVIC_IPR : (NVIC Offset: 0x400) Interrupt Priority Registers -------- 
// -------- NVIC_CPUID : (NVIC Offset: 0xd00) CPU ID Base Register -------- 
// -------- NVIC_ICSR : (NVIC Offset: 0xd04) Interrupt Control State Register -------- 
// -------- NVIC_VTOFFR : (NVIC Offset: 0xd08) Vector Table Offset Register -------- 
// -------- NVIC_AIRCR : (NVIC Offset: 0xd0c) Application Interrupt and Reset Control Register -------- 
// -------- NVIC_SCR : (NVIC Offset: 0xd10) System Control Register -------- 
// -------- NVIC_CCR : (NVIC Offset: 0xd14) Configuration Control Register -------- 
// -------- NVIC_HAND4PR : (NVIC Offset: 0xd18) System Handlers 4-7 Priority Register -------- 
// -------- NVIC_HAND8PR : (NVIC Offset: 0xd1c) System Handlers 8-11 Priority Register -------- 
// -------- NVIC_HAND12PR : (NVIC Offset: 0xd20) System Handlers 12-15 Priority Register -------- 
// -------- NVIC_HANDCSR : (NVIC Offset: 0xd24) System Handler Control and State Register -------- 
// -------- NVIC_CFSR : (NVIC Offset: 0xd28) Configurable Fault Status Registers -------- 
// -------- NVIC_BFAR : (NVIC Offset: 0xd38) Bus Fault Address Register -------- 
// -------- NVIC_PFR0 : (NVIC Offset: 0xd40) Processor Feature register0 (ID_PFR0) -------- 
// -------- NVIC_PFR1 : (NVIC Offset: 0xd44) Processor Feature register1 (ID_PFR1) -------- 
// -------- NVIC_DFR0 : (NVIC Offset: 0xd48) Debug Feature register0 (ID_DFR0) -------- 
// -------- NVIC_MMFR0 : (NVIC Offset: 0xd50) Memory Model Feature register0 (ID_MMFR0) -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR NESTED vector Interrupt Controller
// *****************************************************************************
typedef struct _AT91S_MPU {
	AT91_REG	 MPU_TYPE; 	// MPU Type Register
	AT91_REG	 MPU_CTRL; 	// MPU Control Register
	AT91_REG	 MPU_REG_NB; 	// MPU Region Number Register
	AT91_REG	 MPU_REG_BASE_ADDR; 	// MPU Region Base Address Register
	AT91_REG	 MPU_ATTR_SIZE; 	// MPU  Attribute and Size Register
	AT91_REG	 MPU_REG_BASE_ADDR1; 	// MPU Region Base Address Register alias 1
	AT91_REG	 MPU_ATTR_SIZE1; 	// MPU  Attribute and Size Register alias 1
	AT91_REG	 MPU_REG_BASE_ADDR2; 	// MPU Region Base Address Register alias 2
	AT91_REG	 MPU_ATTR_SIZE2; 	// MPU  Attribute and Size Register alias 2
	AT91_REG	 MPU_REG_BASE_ADDR3; 	// MPU Region Base Address Register alias 3
	AT91_REG	 MPU_ATTR_SIZE3; 	// MPU  Attribute and Size Register alias 3
} AT91S_MPU, *AT91PS_MPU;
// -------- MPU_TYPE : (MPU Offset: 0x0)  -------- 
// -------- MPU_CTRL : (MPU Offset: 0x4)  -------- 
// -------- MPU_REG_NB : (MPU Offset: 0x8)  -------- 
// -------- MPU_REG_BASE_ADDR : (MPU Offset: 0xc)  -------- 
// -------- MPU_ATTR_SIZE : (MPU Offset: 0x10)  -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR CORTEX_M3 Registers
// *****************************************************************************
typedef struct _AT91S_CM3 {
	AT91_REG	 CM3_CPUID; 	// CPU ID Base Register
	AT91_REG	 CM3_ICSR; 	// Interrupt Control State Register
	AT91_REG	 CM3_VTOR; 	// Vector Table Offset Register
	AT91_REG	 CM3_AIRCR; 	// Application Interrupt and Reset Control Register
	AT91_REG	 CM3_SCR; 	// System Controller Register
	AT91_REG	 CM3_CCR; 	// Configuration Control Register
	AT91_REG	 CM3_SHPR[3]; 	// System Handler Priority Register
	AT91_REG	 CM3_SHCSR; 	// System Handler Control and State Register
} AT91S_CM3, *AT91PS_CM3;
// -------- CM3_CPUID : (CM3 Offset: 0x0)  -------- 
// -------- CM3_AIRCR : (CM3 Offset: 0xc)  -------- 
// -------- CM3_SCR : (CM3 Offset: 0x10)  -------- 
// -------- CM3_SHCSR : (CM3 Offset: 0x24)  -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Peripheral DMA Controller
// *****************************************************************************
typedef struct _AT91S_PDC {
	AT91_REG	 PDC_RPR; 	// Receive Pointer Register
	AT91_REG	 PDC_RCR; 	// Receive Counter Register
	AT91_REG	 PDC_TPR; 	// Transmit Pointer Register
	AT91_REG	 PDC_TCR; 	// Transmit Counter Register
	AT91_REG	 PDC_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 PDC_RNCR; 	// Receive Next Counter Register
	AT91_REG	 PDC_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 PDC_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 PDC_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 PDC_PTSR; 	// PDC Transfer Status Register
} AT91S_PDC, *AT91PS_PDC;
// -------- PDC_PTCR : (PDC Offset: 0x20) PDC Transfer Control Register -------- 
// -------- PDC_PTSR : (PDC Offset: 0x24) PDC Transfer Status Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Debug Unit
// *****************************************************************************
typedef struct _AT91S_DBGU {
	AT91_REG	 DBGU_CR; 	// Control Register
	AT91_REG	 DBGU_MR; 	// Mode Register
	AT91_REG	 DBGU_IER; 	// Interrupt Enable Register
	AT91_REG	 DBGU_IDR; 	// Interrupt Disable Register
	AT91_REG	 DBGU_IMR; 	// Interrupt Mask Register
	AT91_REG	 DBGU_CSR; 	// Channel Status Register
	AT91_REG	 DBGU_RHR; 	// Receiver Holding Register
	AT91_REG	 DBGU_THR; 	// Transmitter Holding Register
	AT91_REG	 DBGU_BRGR; 	// Baud Rate Generator Register
	AT91_REG	 Reserved0[9]; 	// 
	AT91_REG	 DBGU_FNTR; 	// Force NTRST Register
	AT91_REG	 Reserved1[40]; 	// 
	AT91_REG	 DBGU_ADDRSIZE; 	// DBGU ADDRSIZE REGISTER 
	AT91_REG	 DBGU_IPNAME1; 	// DBGU IPNAME1 REGISTER 
	AT91_REG	 DBGU_IPNAME2; 	// DBGU IPNAME2 REGISTER 
	AT91_REG	 DBGU_FEATURES; 	// DBGU FEATURES REGISTER 
	AT91_REG	 DBGU_VER; 	// DBGU VERSION REGISTER 
	AT91_REG	 DBGU_RPR; 	// Receive Pointer Register
	AT91_REG	 DBGU_RCR; 	// Receive Counter Register
	AT91_REG	 DBGU_TPR; 	// Transmit Pointer Register
	AT91_REG	 DBGU_TCR; 	// Transmit Counter Register
	AT91_REG	 DBGU_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 DBGU_RNCR; 	// Receive Next Counter Register
	AT91_REG	 DBGU_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 DBGU_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 DBGU_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 DBGU_PTSR; 	// PDC Transfer Status Register
	AT91_REG	 Reserved2[6]; 	// 
	AT91_REG	 DBGU_CIDR; 	// Chip ID Register
	AT91_REG	 DBGU_EXID; 	// Chip ID Extension Register
} AT91S_DBGU, *AT91PS_DBGU;
// -------- DBGU_CR : (DBGU Offset: 0x0) Debug Unit Control Register -------- 
// -------- DBGU_MR : (DBGU Offset: 0x4) Debug Unit Mode Register -------- 
// -------- DBGU_IER : (DBGU Offset: 0x8) Debug Unit Interrupt Enable Register -------- 
// -------- DBGU_IDR : (DBGU Offset: 0xc) Debug Unit Interrupt Disable Register -------- 
// -------- DBGU_IMR : (DBGU Offset: 0x10) Debug Unit Interrupt Mask Register -------- 
// -------- DBGU_CSR : (DBGU Offset: 0x14) Debug Unit Channel Status Register -------- 
// -------- DBGU_FNTR : (DBGU Offset: 0x48) Debug Unit FORCE_NTRST Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Parallel Input Output Controler
// *****************************************************************************
typedef struct _AT91S_PIO {
	AT91_REG	 PIO_PER; 	// PIO Enable Register
	AT91_REG	 PIO_PDR; 	// PIO Disable Register
	AT91_REG	 PIO_PSR; 	// PIO Status Register
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 PIO_OER; 	// Output Enable Register
	AT91_REG	 PIO_ODR; 	// Output Disable Registerr
	AT91_REG	 PIO_OSR; 	// Output Status Register
	AT91_REG	 Reserved1[1]; 	// 
	AT91_REG	 PIO_IFER; 	// Input Filter Enable Register
	AT91_REG	 PIO_IFDR; 	// Input Filter Disable Register
	AT91_REG	 PIO_IFSR; 	// Input Filter Status Register
	AT91_REG	 Reserved2[1]; 	// 
	AT91_REG	 PIO_SODR; 	// Set Output Data Register
	AT91_REG	 PIO_CODR; 	// Clear Output Data Register
	AT91_REG	 PIO_ODSR; 	// Output Data Status Register
	AT91_REG	 PIO_PDSR; 	// Pin Data Status Register
	AT91_REG	 PIO_IER; 	// Interrupt Enable Register
	AT91_REG	 PIO_IDR; 	// Interrupt Disable Register
	AT91_REG	 PIO_IMR; 	// Interrupt Mask Register
	AT91_REG	 PIO_ISR; 	// Interrupt Status Register
	AT91_REG	 PIO_MDER; 	// Multi-driver Enable Register
	AT91_REG	 PIO_MDDR; 	// Multi-driver Disable Register
	AT91_REG	 PIO_MDSR; 	// Multi-driver Status Register
	AT91_REG	 Reserved3[1]; 	// 
	AT91_REG	 PIO_PPUDR; 	// Pull-up Disable Register
	AT91_REG	 PIO_PPUER; 	// Pull-up Enable Register
	AT91_REG	 PIO_PPUSR; 	// Pull-up Status Register
	AT91_REG	 Reserved4[1]; 	// 
	AT91_REG	 PIO_ABSR; 	// Peripheral AB Select Register
	AT91_REG	 Reserved5[3]; 	// 
	AT91_REG	 PIO_SCIFSR; 	// System Clock Glitch Input Filter Select Register
	AT91_REG	 PIO_DIFSR; 	// Debouncing Input Filter Select Register
	AT91_REG	 PIO_IFDGSR; 	// Glitch or Debouncing Input Filter Clock Selection Status Register
	AT91_REG	 PIO_SCDR; 	// Slow Clock Divider Debouncing Register
	AT91_REG	 Reserved6[4]; 	// 
	AT91_REG	 PIO_OWER; 	// Output Write Enable Register
	AT91_REG	 PIO_OWDR; 	// Output Write Disable Register
	AT91_REG	 PIO_OWSR; 	// Output Write Status Register
	AT91_REG	 Reserved7[1]; 	// 
	AT91_REG	 PIO_AIMER; 	// Additional Interrupt Modes Enable Register
	AT91_REG	 PIO_AIMDR; 	// Additional Interrupt Modes Disables Register
	AT91_REG	 PIO_AIMMR; 	// Additional Interrupt Modes Mask Register
	AT91_REG	 Reserved8[1]; 	// 
	AT91_REG	 PIO_ESR; 	// Edge Select Register
	AT91_REG	 PIO_LSR; 	// Level Select Register
	AT91_REG	 PIO_ELSR; 	// Edge/Level Status Register
	AT91_REG	 Reserved9[1]; 	// 
	AT91_REG	 PIO_FELLSR; 	// Falling Edge/Low Level Select Register
	AT91_REG	 PIO_REHLSR; 	// Rising Edge/ High Level Select Register
	AT91_REG	 PIO_FRLHSR; 	// Fall/Rise - Low/High Status Register
	AT91_REG	 Reserved10[1]; 	// 
	AT91_REG	 PIO_LOCKSR; 	// Lock Status Register
	AT91_REG	 Reserved11[6]; 	// 
	AT91_REG	 PIO_VER; 	// PIO VERSION REGISTER 
	AT91_REG	 Reserved12[8]; 	// 
	AT91_REG	 PIO_KER; 	// Keypad Controller Enable Register
	AT91_REG	 PIO_KRCR; 	// Keypad Controller Row Column Register
	AT91_REG	 PIO_KDR; 	// Keypad Controller Debouncing Register
	AT91_REG	 Reserved13[1]; 	// 
	AT91_REG	 PIO_KIER; 	// Keypad Controller Interrupt Enable Register
	AT91_REG	 PIO_KIDR; 	// Keypad Controller Interrupt Disable Register
	AT91_REG	 PIO_KIMR; 	// Keypad Controller Interrupt Mask Register
	AT91_REG	 PIO_KSR; 	// Keypad Controller Status Register
	AT91_REG	 PIO_KKPR; 	// Keypad Controller Key Press Register
	AT91_REG	 PIO_KKRR; 	// Keypad Controller Key Release Register
} AT91S_PIO, *AT91PS_PIO;
// -------- PIO_KER : (PIO Offset: 0x120) Keypad Controller Enable Register -------- 
// -------- PIO_KRCR : (PIO Offset: 0x124) Keypad Controller Row Column Register -------- 
// -------- PIO_KDR : (PIO Offset: 0x128) Keypad Controller Debouncing Register -------- 
// -------- PIO_KIER : (PIO Offset: 0x130) Keypad Controller Interrupt Enable Register -------- 
// -------- PIO_KIDR : (PIO Offset: 0x134) Keypad Controller Interrupt Disable Register -------- 
// -------- PIO_KIMR : (PIO Offset: 0x138) Keypad Controller Interrupt Mask Register -------- 
// -------- PIO_KSR : (PIO Offset: 0x13c) Keypad Controller Status Register -------- 
// -------- PIO_KKPR : (PIO Offset: 0x140) Keypad Controller Key Press Register -------- 
// -------- PIO_KKRR : (PIO Offset: 0x144) Keypad Controller Key Release Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Power Management Controler
// *****************************************************************************
typedef struct _AT91S_PMC {
	AT91_REG	 PMC_SCER; 	// System Clock Enable Register
	AT91_REG	 PMC_SCDR; 	// System Clock Disable Register
	AT91_REG	 PMC_SCSR; 	// System Clock Status Register
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 PMC_PCER; 	// Peripheral Clock Enable Register
	AT91_REG	 PMC_PCDR; 	// Peripheral Clock Disable Register
	AT91_REG	 PMC_PCSR; 	// Peripheral Clock Status Register
	AT91_REG	 PMC_UCKR; 	// UTMI Clock Configuration Register
	AT91_REG	 PMC_MOR; 	// Main Oscillator Register
	AT91_REG	 PMC_MCFR; 	// Main Clock  Frequency Register
	AT91_REG	 PMC_PLLAR; 	// PLL Register
	AT91_REG	 Reserved1[1]; 	// 
	AT91_REG	 PMC_MCKR; 	// Master Clock Register
	AT91_REG	 Reserved2[3]; 	// 
	AT91_REG	 PMC_PCKR[8]; 	// Programmable Clock Register
	AT91_REG	 PMC_IER; 	// Interrupt Enable Register
	AT91_REG	 PMC_IDR; 	// Interrupt Disable Register
	AT91_REG	 PMC_SR; 	// Status Register
	AT91_REG	 PMC_IMR; 	// Interrupt Mask Register
	AT91_REG	 PMC_FSMR; 	// Fast Startup Mode Register
	AT91_REG	 PMC_FSPR; 	// Fast Startup Polarity Register
	AT91_REG	 PMC_FOCR; 	// Fault Output Clear Register
	AT91_REG	 Reserved3[28]; 	// 
	AT91_REG	 PMC_ADDRSIZE; 	// PMC ADDRSIZE REGISTER 
	AT91_REG	 PMC_IPNAME1; 	// PMC IPNAME1 REGISTER 
	AT91_REG	 PMC_IPNAME2; 	// PMC IPNAME2 REGISTER 
	AT91_REG	 PMC_FEATURES; 	// PMC FEATURES REGISTER 
	AT91_REG	 PMC_VER; 	// APMC VERSION REGISTER
} AT91S_PMC, *AT91PS_PMC;
// -------- PMC_SCER : (PMC Offset: 0x0) System Clock Enable Register -------- 
// -------- PMC_SCDR : (PMC Offset: 0x4) System Clock Disable Register -------- 
// -------- PMC_SCSR : (PMC Offset: 0x8) System Clock Status Register -------- 
// -------- CKGR_UCKR : (PMC Offset: 0x1c) UTMI Clock Configuration Register -------- 
// -------- CKGR_MOR : (PMC Offset: 0x20) Main Oscillator Register -------- 
// -------- CKGR_MCFR : (PMC Offset: 0x24) Main Clock Frequency Register -------- 
// -------- CKGR_PLLAR : (PMC Offset: 0x28) PLL A Register -------- 
// -------- PMC_MCKR : (PMC Offset: 0x30) Master Clock Register -------- 
// -------- PMC_PCKR : (PMC Offset: 0x40) Programmable Clock Register -------- 
// -------- PMC_IER : (PMC Offset: 0x60) PMC Interrupt Enable Register -------- 
// -------- PMC_IDR : (PMC Offset: 0x64) PMC Interrupt Disable Register -------- 
// -------- PMC_SR : (PMC Offset: 0x68) PMC Status Register -------- 
// -------- PMC_IMR : (PMC Offset: 0x6c) PMC Interrupt Mask Register -------- 
// -------- PMC_FSMR : (PMC Offset: 0x70) Fast Startup Mode Register -------- 
// -------- PMC_FSPR : (PMC Offset: 0x74) Fast Startup Polarity Register -------- 
// -------- PMC_FOCR : (PMC Offset: 0x78) Fault Output Clear Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Clock Generator Controler
// *****************************************************************************
typedef struct _AT91S_CKGR {
	AT91_REG	 CKGR_UCKR; 	// UTMI Clock Configuration Register
	AT91_REG	 CKGR_MOR; 	// Main Oscillator Register
	AT91_REG	 CKGR_MCFR; 	// Main Clock  Frequency Register
	AT91_REG	 CKGR_PLLAR; 	// PLL Register
} AT91S_CKGR, *AT91PS_CKGR;
// -------- CKGR_UCKR : (CKGR Offset: 0x0) UTMI Clock Configuration Register -------- 
// -------- CKGR_MOR : (CKGR Offset: 0x4) Main Oscillator Register -------- 
// -------- CKGR_MCFR : (CKGR Offset: 0x8) Main Clock Frequency Register -------- 
// -------- CKGR_PLLAR : (CKGR Offset: 0xc) PLL A Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Reset Controller Interface
// *****************************************************************************
typedef struct _AT91S_RSTC {
	AT91_REG	 RSTC_RCR; 	// Reset Control Register
	AT91_REG	 RSTC_RSR; 	// Reset Status Register
	AT91_REG	 RSTC_RMR; 	// Reset Mode Register
	AT91_REG	 Reserved0[60]; 	// 
	AT91_REG	 RSTC_VER; 	// Version Register
} AT91S_RSTC, *AT91PS_RSTC;
// -------- RSTC_RCR : (RSTC Offset: 0x0) Reset Control Register -------- 
// -------- RSTC_RSR : (RSTC Offset: 0x4) Reset Status Register -------- 
// -------- RSTC_RMR : (RSTC Offset: 0x8) Reset Mode Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Supply Controller Interface
// *****************************************************************************
typedef struct _AT91S_SUPC {
  AT91_REG SUPC_CR;   // Supply Controller Control Register
  AT91_REG SUPC_SMMR; // Supply Controller Supply Monitor Mode Register
  AT91_REG SUPC_MR;   // Supply Controller Mode Register
  AT91_REG SUPC_WUMR; // Supply Controller Wake Up Mode Register
  AT91_REG SUPC_WUIR; // Supply Controller Wake Up Inputs Register
  AT91_REG SUPC_SR;   // Supply Controller Status Register
} AT91S_SUPC, *AT91PS_SUPC;
// -------- SUPC_CR : (SUPC Offset: 0x00) Supply Controller Control Register --------
// -------- SUPC_SMMR : (SUPC Offset: 0x04) Supply Controller Supply Monitor Mode Register --------
// -------- SUPC_MR : (SUPC Offset: 0x08) Supply Controller Mode Register --------
// -------- SUPC_WUMR : (SUPC Offset: 0x0C) Supply Controller Wake Up Mode Register --------
// -------- SUPC_WUIR : (SUPC Offset: 0x10) Supply Controller Wake Up Inputs Register --------
// -------- SUPC_SR : (SUPC Offset: 0x14) Supply Controller Status Register --------

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Real Time Timer Controller Interface
// *****************************************************************************
typedef struct _AT91S_RTTC {
	AT91_REG	 RTTC_RTMR; 	// Real-time Mode Register
	AT91_REG	 RTTC_RTAR; 	// Real-time Alarm Register
	AT91_REG	 RTTC_RTVR; 	// Real-time Value Register
	AT91_REG	 RTTC_RTSR; 	// Real-time Status Register
} AT91S_RTTC, *AT91PS_RTTC;
// -------- RTTC_RTMR : (RTTC Offset: 0x0) Real-time Mode Register -------- 
// -------- RTTC_RTAR : (RTTC Offset: 0x4) Real-time Alarm Register -------- 
// -------- RTTC_RTVR : (RTTC Offset: 0x8) Current Real-time Value Register -------- 
// -------- RTTC_RTSR : (RTTC Offset: 0xc) Real-time Status Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Watchdog Timer Controller Interface
// *****************************************************************************
typedef struct _AT91S_WDTC {
	AT91_REG	 WDTC_WDCR; 	// Watchdog Control Register
	AT91_REG	 WDTC_WDMR; 	// Watchdog Mode Register
	AT91_REG	 WDTC_WDSR; 	// Watchdog Status Register
} AT91S_WDTC, *AT91PS_WDTC;
// -------- WDTC_WDCR : (WDTC Offset: 0x0) Periodic Interval Image Register -------- 
// -------- WDTC_WDMR : (WDTC Offset: 0x4) Watchdog Mode Register -------- 
// -------- WDTC_WDSR : (WDTC Offset: 0x8) Watchdog Status Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Real-time Clock Alarm and Parallel Load Interface
// *****************************************************************************
typedef struct _AT91S_RTC {
	AT91_REG	 RTC_CR; 	// Control Register
	AT91_REG	 RTC_MR; 	// Mode Register
	AT91_REG	 RTC_TIMR; 	// Time Register
	AT91_REG	 RTC_CALR; 	// Calendar Register
	AT91_REG	 RTC_TIMALR; 	// Time Alarm Register
	AT91_REG	 RTC_CALALR; 	// Calendar Alarm Register
	AT91_REG	 RTC_SR; 	// Status Register
	AT91_REG	 RTC_SCCR; 	// Status Clear Command Register
	AT91_REG	 RTC_IER; 	// Interrupt Enable Register
	AT91_REG	 RTC_IDR; 	// Interrupt Disable Register
	AT91_REG	 RTC_IMR; 	// Interrupt Mask Register
	AT91_REG	 RTC_VER; 	// Valid Entry Register
} AT91S_RTC, *AT91PS_RTC;
// -------- RTC_CR : (RTC Offset: 0x0) RTC Control Register -------- 
// -------- RTC_MR : (RTC Offset: 0x4) RTC Mode Register -------- 
// -------- RTC_TIMR : (RTC Offset: 0x8) RTC Time Register -------- 
// -------- RTC_CALR : (RTC Offset: 0xc) RTC Calendar Register -------- 
// -------- RTC_TIMALR : (RTC Offset: 0x10) RTC Time Alarm Register -------- 
// -------- RTC_CALALR : (RTC Offset: 0x14) RTC Calendar Alarm Register -------- 
// -------- RTC_SR : (RTC Offset: 0x18) RTC Status Register -------- 
// -------- RTC_SCCR : (RTC Offset: 0x1c) RTC Status Clear Command Register -------- 
// -------- RTC_IER : (RTC Offset: 0x20) RTC Interrupt Enable Register -------- 
// -------- RTC_IDR : (RTC Offset: 0x24) RTC Interrupt Disable Register -------- 
// -------- RTC_IMR : (RTC Offset: 0x28) RTC Interrupt Mask Register -------- 
// -------- RTC_VER : (RTC Offset: 0x2c) RTC Valid Entry Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Analog to Digital Convertor
// *****************************************************************************
typedef struct _AT91S_ADC {
	AT91_REG	 ADC_CR; 	// ADC Control Register
	AT91_REG	 ADC_MR; 	// ADC Mode Register
	AT91_REG	 Reserved0[2]; 	// 
	AT91_REG	 ADC_CHER; 	// ADC Channel Enable Register
	AT91_REG	 ADC_CHDR; 	// ADC Channel Disable Register
	AT91_REG	 ADC_CHSR; 	// ADC Channel Status Register
	AT91_REG	 ADC_SR; 	// ADC Status Register
	AT91_REG	 ADC_LCDR; 	// ADC Last Converted Data Register
	AT91_REG	 ADC_IER; 	// ADC Interrupt Enable Register
	AT91_REG	 ADC_IDR; 	// ADC Interrupt Disable Register
	AT91_REG	 ADC_IMR; 	// ADC Interrupt Mask Register
	AT91_REG	 ADC_CDR0; 	// ADC Channel Data Register 0
	AT91_REG	 ADC_CDR1; 	// ADC Channel Data Register 1
	AT91_REG	 ADC_CDR2; 	// ADC Channel Data Register 2
	AT91_REG	 ADC_CDR3; 	// ADC Channel Data Register 3
	AT91_REG	 ADC_CDR4; 	// ADC Channel Data Register 4
	AT91_REG	 ADC_CDR5; 	// ADC Channel Data Register 5
	AT91_REG	 ADC_CDR6; 	// ADC Channel Data Register 6
	AT91_REG	 ADC_CDR7; 	// ADC Channel Data Register 7
	AT91_REG	 Reserved1[5]; 	// 
	AT91_REG	 ADC_ACR; 	// Analog Control Register
	AT91_REG	 ADC_EMR; 	// Extended Mode Register
	AT91_REG	 Reserved2[32]; 	// 
	AT91_REG	 ADC_ADDRSIZE; 	// ADC ADDRSIZE REGISTER 
	AT91_REG	 ADC_IPNAME1; 	// ADC IPNAME1 REGISTER 
	AT91_REG	 ADC_IPNAME2; 	// ADC IPNAME2 REGISTER 
	AT91_REG	 ADC_FEATURES; 	// ADC FEATURES REGISTER 
	AT91_REG	 ADC_VER; 	// ADC VERSION REGISTER
	AT91_REG	 ADC_RPR; 	// Receive Pointer Register
	AT91_REG	 ADC_RCR; 	// Receive Counter Register
	AT91_REG	 ADC_TPR; 	// Transmit Pointer Register
	AT91_REG	 ADC_TCR; 	// Transmit Counter Register
	AT91_REG	 ADC_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 ADC_RNCR; 	// Receive Next Counter Register
	AT91_REG	 ADC_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 ADC_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 ADC_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 ADC_PTSR; 	// PDC Transfer Status Register
} AT91S_ADC, *AT91PS_ADC;
// -------- ADC_CR : (ADC Offset: 0x0) ADC Control Register -------- 
// -------- ADC_MR : (ADC Offset: 0x4) ADC Mode Register -------- 
// -------- 	ADC_CHER : (ADC Offset: 0x10) ADC Channel Enable Register -------- 
// -------- 	ADC_CHDR : (ADC Offset: 0x14) ADC Channel Disable Register -------- 
// -------- 	ADC_CHSR : (ADC Offset: 0x18) ADC Channel Status Register -------- 
// -------- ADC_SR : (ADC Offset: 0x1c) ADC Status Register -------- 
// -------- ADC_LCDR : (ADC Offset: 0x20) ADC Last Converted Data Register -------- 
// -------- ADC_IER : (ADC Offset: 0x24) ADC Interrupt Enable Register -------- 
// -------- ADC_IDR : (ADC Offset: 0x28) ADC Interrupt Disable Register -------- 
// -------- ADC_IMR : (ADC Offset: 0x2c) ADC Interrupt Mask Register -------- 
// -------- ADC_CDR0 : (ADC Offset: 0x30) ADC Channel Data Register 0 -------- 
// -------- ADC_CDR1 : (ADC Offset: 0x34) ADC Channel Data Register 1 -------- 
// -------- ADC_CDR2 : (ADC Offset: 0x38) ADC Channel Data Register 2 -------- 
// -------- ADC_CDR3 : (ADC Offset: 0x3c) ADC Channel Data Register 3 -------- 
// -------- ADC_CDR4 : (ADC Offset: 0x40) ADC Channel Data Register 4 -------- 
// -------- ADC_CDR5 : (ADC Offset: 0x44) ADC Channel Data Register 5 -------- 
// -------- ADC_CDR6 : (ADC Offset: 0x48) ADC Channel Data Register 6 -------- 
// -------- ADC_CDR7 : (ADC Offset: 0x4c) ADC Channel Data Register 7 -------- 
// -------- ADC_ACR : (ADC Offset: 0x64) ADC Analog Controler Register -------- 
// -------- ADC_EMR : (ADC Offset: 0x68) ADC Extended Mode Register -------- 
// -------- ADC_VER : (ADC Offset: 0xfc) ADC VER -------- 

// *****************************************************************************
//   SOFTWARE API DEFINITION FOR Analog-to Digital Converter
// *****************************************************************************

typedef struct _AT91S_ADC12B {
  AT91_REG ADC12B_CR;     // Control Register
  AT91_REG ADC12B_MR;     // Mode Register
  AT91_REG Reserved1[2]; 
  AT91_REG ADC12B_CHER;   // Channel Enable Register
  AT91_REG ADC12B_CHDR;   // Channel Disable Register
  AT91_REG ADC12B_CHSR;   // Channel Status Register
  AT91_REG ADC12B_SR;     // Status Register
  AT91_REG ADC12B_LCDR;   // Last Converted Data Register
  AT91_REG ADC12B_IER;    // Interrupt Enable Register
  AT91_REG ADC12B_IDR;    // Interrupt Disable Register
  AT91_REG ADC12B_IMR;    // Interrupt Mask Register
  AT91_REG ADC12B_CDR[8]; // Channel Data Register
  AT91_REG Reserved2[5]; 
  AT91_REG ADC12B_ACR;    // Analog Control Register
  AT91_REG ADC12B_EMR;    // Extended Mode Register
} AT91S_ADC12B, *AT91PS_ADC12B;
// -------- ADC12B_CR : (ADC12B Offset: 0x00) Control Register --------
// -------- ADC12B_MR : (ADC12B Offset: 0x04) Mode Register --------
// -------- ADC12B_CHER : (ADC12B Offset: 0x10) Channel Enable Register --------
// -------- ADC12B_CHDR : (ADC12B Offset: 0x14) Channel Disable Register --------
// -------- ADC12B_CHSR : (ADC12B Offset: 0x18) Channel Status Register --------
// -------- ADC12B_SR : (ADC12B Offset: 0x1C) Status Register --------
// -------- ADC12B_LCDR : (ADC12B Offset: 0x20) Last Converted Data Register --------
// -------- ADC12B_IER : (ADC12B Offset: 0x24) Interrupt Enable Register --------
// -------- ADC12B_IDR : (ADC12B Offset: 0x28) Interrupt Disable Register --------
// -------- ADC12B_IMR : (ADC12B Offset: 0x2C) Interrupt Mask Register --------
// -------- ADC12B_CDR[8] : (ADC12B Offset: 0x30) Channel Data Register --------
// -------- ADC12B_ACR : (ADC12B Offset: 0x64) Analog Control Register --------
// -------- ADC12B_EMR : (ADC12B Offset: 0x68) Extended Mode Register --------

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Timer Counter Channel Interface
// *****************************************************************************
typedef struct _AT91S_TC {
	AT91_REG	 TC_CCR; 	// Channel Control Register
	AT91_REG	 TC_CMR; 	// Channel Mode Register (Capture Mode / Waveform Mode)
	AT91_REG	 Reserved0[2]; 	// 
	AT91_REG	 TC_CV; 	// Counter Value
	AT91_REG	 TC_RA; 	// Register A
	AT91_REG	 TC_RB; 	// Register B
	AT91_REG	 TC_RC; 	// Register C
	AT91_REG	 TC_SR; 	// Status Register
	AT91_REG	 TC_IER; 	// Interrupt Enable Register
	AT91_REG	 TC_IDR; 	// Interrupt Disable Register
	AT91_REG	 TC_IMR; 	// Interrupt Mask Register
} AT91S_TC, *AT91PS_TC;
// -------- TC_CCR : (TC Offset: 0x0) TC Channel Control Register -------- 
// -------- TC_CMR : (TC Offset: 0x4) TC Channel Mode Register: Capture Mode / Waveform Mode -------- 
// -------- TC_SR : (TC Offset: 0x20) TC Channel Status Register -------- 
// -------- TC_IER : (TC Offset: 0x24) TC Channel Interrupt Enable Register -------- 
// -------- TC_IDR : (TC Offset: 0x28) TC Channel Interrupt Disable Register -------- 
// -------- TC_IMR : (TC Offset: 0x2c) TC Channel Interrupt Mask Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Timer Counter Interface
// *****************************************************************************
typedef struct _AT91S_TCB {
	AT91S_TC	 TCB_TC0; 	// TC Channel 0
	AT91_REG	 Reserved0[4]; 	// 
	AT91S_TC	 TCB_TC1; 	// TC Channel 1
	AT91_REG	 Reserved1[4]; 	// 
	AT91S_TC	 TCB_TC2; 	// TC Channel 2
	AT91_REG	 Reserved2[4]; 	// 
	AT91_REG	 TCB_BCR; 	// TC Block Control Register
	AT91_REG	 TCB_BMR; 	// TC Block Mode Register
	AT91_REG	 Reserved3[9]; 	// 
	AT91_REG	 TCB_ADDRSIZE; 	// TC ADDRSIZE REGISTER 
	AT91_REG	 TCB_IPNAME1; 	// TC IPNAME1 REGISTER 
	AT91_REG	 TCB_IPNAME2; 	// TC IPNAME2 REGISTER 
	AT91_REG	 TCB_FEATURES; 	// TC FEATURES REGISTER 
	AT91_REG	 TCB_VER; 	//  Version Register
} AT91S_TCB, *AT91PS_TCB;
// -------- TCB_BCR : (TCB Offset: 0xc0) TC Block Control Register -------- 
// -------- TCB_BMR : (TCB Offset: 0xc4) TC Block Mode Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Embedded Flash Controller 2.0
// *****************************************************************************
typedef struct _AT91S_EFC {
	AT91_REG	 EFC_FMR; 	// EFC Flash Mode Register
	AT91_REG	 EFC_FCR; 	// EFC Flash Command Register
	AT91_REG	 EFC_FSR; 	// EFC Flash Status Register
	AT91_REG	 EFC_FRR; 	// EFC Flash Result Register
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 EFC_FVR; 	// EFC Flash Version Register
} AT91S_EFC, *AT91PS_EFC;
// -------- EFC_FMR : (EFC Offset: 0x0) EFC Flash Mode Register -------- 
// -------- EFC_FCR : (EFC Offset: 0x4) EFC Flash Command Register -------- 
// -------- EFC_FSR : (EFC Offset: 0x8) EFC Flash Status Register -------- 
// -------- EFC_FRR : (EFC Offset: 0xc) EFC Flash Result Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Multimedia Card Interface
// *****************************************************************************
typedef struct _AT91S_MCI {
	AT91_REG	 MCI_CR; 	// MCI Control Register
	AT91_REG	 MCI_MR; 	// MCI Mode Register
	AT91_REG	 MCI_DTOR; 	// MCI Data Timeout Register
	AT91_REG	 MCI_SDCR; 	// MCI SD/SDIO Card Register
	AT91_REG	 MCI_ARGR; 	// MCI Argument Register
	AT91_REG	 MCI_CMDR; 	// MCI Command Register
	AT91_REG	 MCI_BLKR; 	// MCI Block Register
	AT91_REG	 MCI_CSTOR; 	// MCI Completion Signal Timeout Register
	AT91_REG	 MCI_RSPR[4]; 	// MCI Response Register
	AT91_REG	 MCI_RDR; 	// MCI Receive Data Register
	AT91_REG	 MCI_TDR; 	// MCI Transmit Data Register
	AT91_REG	 Reserved0[2]; 	// 
	AT91_REG	 MCI_SR; 	// MCI Status Register
	AT91_REG	 MCI_IER; 	// MCI Interrupt Enable Register
	AT91_REG	 MCI_IDR; 	// MCI Interrupt Disable Register
	AT91_REG	 MCI_IMR; 	// MCI Interrupt Mask Register
	AT91_REG	 MCI_DMA; 	// MCI DMA Configuration Register
	AT91_REG	 MCI_CFG; 	// MCI Configuration Register
	AT91_REG	 Reserved1[35]; 	// 
	AT91_REG	 MCI_WPCR; 	// MCI Write Protection Control Register
	AT91_REG	 MCI_WPSR; 	// MCI Write Protection Status Register
	AT91_REG	 MCI_ADDRSIZE; 	// MCI ADDRSIZE REGISTER 
	AT91_REG	 MCI_IPNAME1; 	// MCI IPNAME1 REGISTER 
	AT91_REG	 MCI_IPNAME2; 	// MCI IPNAME2 REGISTER 
	AT91_REG	 MCI_FEATURES; 	// MCI FEATURES REGISTER 
	AT91_REG	 MCI_VER; 	// MCI VERSION REGISTER 
	AT91_REG	 MCI_RPR; 	// Receive Pointer Register
	AT91_REG	 MCI_RCR; 	// Receive Counter Register
	AT91_REG	 MCI_TPR; 	// Transmit Pointer Register
	AT91_REG	 MCI_TCR; 	// Transmit Counter Register
	AT91_REG	 MCI_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 MCI_RNCR; 	// Receive Next Counter Register
	AT91_REG	 MCI_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 MCI_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 MCI_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 MCI_PTSR; 	// PDC Transfer Status Register
	AT91_REG	 Reserved2[54]; 	// 
	AT91_REG	 MCI_FIFO; 	// MCI FIFO Aperture Register
} AT91S_MCI, *AT91PS_MCI;
// -------- MCI_CR : (MCI Offset: 0x0) MCI Control Register -------- 
// -------- MCI_MR : (MCI Offset: 0x4) MCI Mode Register -------- 
// -------- MCI_DTOR : (MCI Offset: 0x8) MCI Data Timeout Register -------- 
// -------- MCI_SDCR : (MCI Offset: 0xc) MCI SD Card Register -------- 
// -------- MCI_CMDR : (MCI Offset: 0x14) MCI Command Register -------- 
// -------- MCI_BLKR : (MCI Offset: 0x18) MCI Block Register -------- 
// -------- MCI_CSTOR : (MCI Offset: 0x1c) MCI Completion Signal Timeout Register -------- 
// -------- MCI_SR : (MCI Offset: 0x40) MCI Status Register -------- 
// -------- MCI_IER : (MCI Offset: 0x44) MCI Interrupt Enable Register -------- 
// -------- MCI_IDR : (MCI Offset: 0x48) MCI Interrupt Disable Register -------- 
// -------- MCI_IMR : (MCI Offset: 0x4c) MCI Interrupt Mask Register -------- 
// -------- MCI_DMA : (MCI Offset: 0x50) MCI DMA Configuration Register -------- 
// -------- MCI_CFG : (MCI Offset: 0x54) MCI Configuration Register -------- 
// -------- MCI_WPCR : (MCI Offset: 0xe4) Write Protection Control Register -------- 
// -------- MCI_WPSR : (MCI Offset: 0xe8) Write Protection Status Register -------- 
// -------- MCI_VER : (MCI Offset: 0xfc)  VERSION  Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Two-wire Interface
// *****************************************************************************
typedef struct _AT91S_TWI {
	AT91_REG	 TWI_CR; 	// Control Register
	AT91_REG	 TWI_MMR; 	// Master Mode Register
	AT91_REG	 TWI_SMR; 	// Slave Mode Register
	AT91_REG	 TWI_IADR; 	// Internal Address Register
	AT91_REG	 TWI_CWGR; 	// Clock Waveform Generator Register
	AT91_REG	 Reserved0[3]; 	// 
	AT91_REG	 TWI_SR; 	// Status Register
	AT91_REG	 TWI_IER; 	// Interrupt Enable Register
	AT91_REG	 TWI_IDR; 	// Interrupt Disable Register
	AT91_REG	 TWI_IMR; 	// Interrupt Mask Register
	AT91_REG	 TWI_RHR; 	// Receive Holding Register
	AT91_REG	 TWI_THR; 	// Transmit Holding Register
	AT91_REG	 Reserved1[45]; 	// 
	AT91_REG	 TWI_ADDRSIZE; 	// TWI ADDRSIZE REGISTER 
	AT91_REG	 TWI_IPNAME1; 	// TWI IPNAME1 REGISTER 
	AT91_REG	 TWI_IPNAME2; 	// TWI IPNAME2 REGISTER 
	AT91_REG	 TWI_FEATURES; 	// TWI FEATURES REGISTER 
	AT91_REG	 TWI_VER; 	// Version Register
	AT91_REG	 TWI_RPR; 	// Receive Pointer Register
	AT91_REG	 TWI_RCR; 	// Receive Counter Register
	AT91_REG	 TWI_TPR; 	// Transmit Pointer Register
	AT91_REG	 TWI_TCR; 	// Transmit Counter Register
	AT91_REG	 TWI_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 TWI_RNCR; 	// Receive Next Counter Register
	AT91_REG	 TWI_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 TWI_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 TWI_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 TWI_PTSR; 	// PDC Transfer Status Register
} AT91S_TWI, *AT91PS_TWI;
// -------- TWI_CR : (TWI Offset: 0x0) TWI Control Register -------- 
// -------- TWI_MMR : (TWI Offset: 0x4) TWI Master Mode Register -------- 
// -------- TWI_SMR : (TWI Offset: 0x8) TWI Slave Mode Register -------- 
// -------- TWI_CWGR : (TWI Offset: 0x10) TWI Clock Waveform Generator Register -------- 
// -------- TWI_SR : (TWI Offset: 0x20) TWI Status Register -------- 
// -------- TWI_IER : (TWI Offset: 0x24) TWI Interrupt Enable Register -------- 
// -------- TWI_IDR : (TWI Offset: 0x28) TWI Interrupt Disable Register -------- 
// -------- TWI_IMR : (TWI Offset: 0x2c) TWI Interrupt Mask Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Usart
// *****************************************************************************


typedef struct _AT91S_USART {
	AT91_REG	 US_CR; 	// Control Register
	AT91_REG	 US_MR; 	// Mode Register
	AT91_REG	 US_IER; 	// Interrupt Enable Register
	AT91_REG	 US_IDR; 	// Interrupt Disable Register
	AT91_REG	 US_IMR; 	// Interrupt Mask Register
	AT91_REG	 US_CSR; 	// Channel Status Register
	AT91_REG	 US_RHR; 	// Receiver Holding Register
	AT91_REG	 US_THR; 	// Transmitter Holding Register
	AT91_REG	 US_BRGR; 	// Baud Rate Generator Register
	AT91_REG	 US_RTOR; 	// Receiver Time-out Register
	AT91_REG	 US_TTGR; 	// Transmitter Time-guard Register
	AT91_REG	 Reserved0[5]; 	// 
	AT91_REG	 US_FIDI; 	// FI_DI_Ratio Register
	AT91_REG	 US_NER; 	// Nb Errors Register
	AT91_REG	 Reserved1[1]; 	// 
	AT91_REG	 US_IF; 	// IRDA_FILTER Register
	AT91_REG	 US_MAN; 	// Manchester Encoder Decoder Register
	AT91_REG	 Reserved2[38]; 	// 
	AT91_REG	 US_ADDRSIZE; 	// US ADDRSIZE REGISTER 
	AT91_REG	 US_IPNAME1; 	// US IPNAME1 REGISTER 
	AT91_REG	 US_IPNAME2; 	// US IPNAME2 REGISTER 
	AT91_REG	 US_FEATURES; 	// US FEATURES REGISTER 
	AT91_REG	 US_VER; 	// VERSION Register
	AT91_REG	 US_RPR; 	// Receive Pointer Register
	AT91_REG	 US_RCR; 	// Receive Counter Register
	AT91_REG	 US_TPR; 	// Transmit Pointer Register
	AT91_REG	 US_TCR; 	// Transmit Counter Register
	AT91_REG	 US_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 US_RNCR; 	// Receive Next Counter Register
	AT91_REG	 US_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 US_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 US_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 US_PTSR; 	// PDC Transfer Status Register
} AT91S_USART, *AT91PS_USART;
// -------- US_CR : (USART Offset: 0x0)  Control Register -------- 
// -------- US_MR : (USART Offset: 0x4)  Mode Register -------- 
// -------- US_IER : (USART Offset: 0x8)  Interrupt Enable Register -------- 
// -------- US_IDR : (USART Offset: 0xc)  Interrupt Disable Register -------- 
// -------- US_IMR : (USART Offset: 0x10)  Interrupt Mask Register -------- 
// -------- US_CSR : (USART Offset: 0x14)  Channel Status Register -------- 
// -------- US_MAN : (USART Offset: 0x50) Manchester Encoder Decoder Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Synchronous Serial Controller Interface
// *****************************************************************************
typedef struct _AT91S_SSC {
	AT91_REG	 SSC_CR; 	// Control Register
	AT91_REG	 SSC_CMR; 	// Clock Mode Register
	AT91_REG	 Reserved0[2]; 	// 
	AT91_REG	 SSC_RCMR; 	// Receive Clock ModeRegister
	AT91_REG	 SSC_RFMR; 	// Receive Frame Mode Register
	AT91_REG	 SSC_TCMR; 	// Transmit Clock Mode Register
	AT91_REG	 SSC_TFMR; 	// Transmit Frame Mode Register
	AT91_REG	 SSC_RHR; 	// Receive Holding Register
	AT91_REG	 SSC_THR; 	// Transmit Holding Register
	AT91_REG	 Reserved1[2]; 	// 
	AT91_REG	 SSC_RSHR; 	// Receive Sync Holding Register
	AT91_REG	 SSC_TSHR; 	// Transmit Sync Holding Register
	AT91_REG	 SSC_RC0R; 	// Receive Compare 0 Register
	AT91_REG	 SSC_RC1R; 	// Receive Compare 1 Register
	AT91_REG	 SSC_SR; 	// Status Register
	AT91_REG	 SSC_IER; 	// Interrupt Enable Register
	AT91_REG	 SSC_IDR; 	// Interrupt Disable Register
	AT91_REG	 SSC_IMR; 	// Interrupt Mask Register
} AT91S_SSC, *AT91PS_SSC;
// -------- SSC_CR : (SSC Offset: 0x0) SSC Control Register -------- 
// -------- SSC_RCMR : (SSC Offset: 0x10) SSC Receive Clock Mode Register -------- 
// -------- SSC_RFMR : (SSC Offset: 0x14) SSC Receive Frame Mode Register -------- 
// -------- SSC_TCMR : (SSC Offset: 0x18) SSC Transmit Clock Mode Register -------- 
// -------- SSC_TFMR : (SSC Offset: 0x1c) SSC Transmit Frame Mode Register -------- 
// -------- SSC_SR : (SSC Offset: 0x40) SSC Status Register -------- 
// -------- SSC_IER : (SSC Offset: 0x44) SSC Interrupt Enable Register -------- 
// -------- SSC_IDR : (SSC Offset: 0x48) SSC Interrupt Disable Register -------- 
// -------- SSC_IMR : (SSC Offset: 0x4c) SSC Interrupt Mask Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR PWMC Channel Interface
// *****************************************************************************
typedef struct _AT91S_PWMC_CH {
	AT91_REG	 PWMC_CMR; 	// Channel Mode Register
	AT91_REG	 PWMC_CDTYR; 	// Channel Duty Cycle Register
	AT91_REG	 PWMC_CDTYUPDR; 	// Channel Duty Cycle Update Register
	AT91_REG	 PWMC_CPRDR; 	// Channel Period Register
	AT91_REG	 PWMC_CPRDUPDR; 	// Channel Period Update Register
	AT91_REG	 PWMC_CCNTR; 	// Channel Counter Register
	AT91_REG	 PWMC_DTR; 	// Channel Dead Time Value Register
	AT91_REG	 PWMC_DTUPDR; 	// Channel Dead Time Update Value Register
} AT91S_PWMC_CH, *AT91PS_PWMC_CH;
// -------- PWMC_CMR : (PWMC_CH Offset: 0x0) PWMC Channel Mode Register -------- 
// -------- PWMC_CDTYR : (PWMC_CH Offset: 0x4) PWMC Channel Duty Cycle Register -------- 
// -------- PWMC_CDTYUPDR : (PWMC_CH Offset: 0x8) PWMC Channel Duty Cycle Update Register -------- 
// -------- PWMC_CPRDR : (PWMC_CH Offset: 0xc) PWMC Channel Period Register -------- 
// -------- PWMC_CPRDUPDR : (PWMC_CH Offset: 0x10) PWMC Channel Period Update Register -------- 
// -------- PWMC_CCNTR : (PWMC_CH Offset: 0x14) PWMC Channel Counter Register -------- 
// -------- PWMC_DTR : (PWMC_CH Offset: 0x18) Channel Dead Time Value Register -------- 
// -------- PWMC_DTUPDR : (PWMC_CH Offset: 0x1c) Channel Dead Time Value Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Pulse Width Modulation Controller Interface
// *****************************************************************************
typedef struct _AT91S_PWMC {
	AT91_REG	 PWMC_CLK; 	// PWMC Mode Register
	AT91_REG	 PWMC_ENA; 	// PWMC Enable Register
	AT91_REG	 PWMC_DIS; 	// PWMC Disable Register
	AT91_REG	 PWMC_SR; 	// PWMC Status Register
	AT91_REG	 PWMC_IER1; 	// PWMC Interrupt Enable Register 1
	AT91_REG	 PWMC_IDR1; 	// PWMC Interrupt Disable Register 1
	AT91_REG	 PWMC_IMR1; 	// PWMC Interrupt Mask Register 1
	AT91_REG	 PWMC_ISR1; 	// PWMC Interrupt Status Register 1
	AT91_REG	 PWMC_SCM;  	// PWM Synchronized Channels Register
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 PWMC_UPCR; 	// PWM Update Control Register
	AT91_REG	 PWMC_SCUP; 	// PWM Update Period Register
	AT91_REG	 PWMC_SCUPUPD; 	// PWM Update Period Update Register
	AT91_REG	 PWMC_IER2; 	// PWMC Interrupt Enable Register 2
	AT91_REG	 PWMC_IDR2; 	// PWMC Interrupt Disable Register 2
	AT91_REG	 PWMC_IMR2; 	// PWMC Interrupt Mask Register 2
	AT91_REG	 PWMC_ISR2; 	// PWMC Interrupt Status Register 2
	AT91_REG	 PWMC_OOV; 	// PWM Output Override Value Register
	AT91_REG	 PWMC_OS; 	// PWM Output Selection Register
	AT91_REG	 PWMC_OSS; 	// PWM Output Selection Set Register
	AT91_REG	 PWMC_OSC; 	// PWM Output Selection Clear Register
	AT91_REG	 PWMC_OSSUPD; 	// PWM Output Selection Set Update Register
	AT91_REG	 PWMC_OSCUPD; 	// PWM Output Selection Clear Update Register
	AT91_REG	 PWMC_FMR; 	// PWM Fault Mode Register
	AT91_REG	 PWMC_FSR; 	// PWM Fault Mode Status Register
	AT91_REG	 PWMC_FCR; 	// PWM Fault Mode Clear Register
	AT91_REG	 PWMC_FPV; 	// PWM Fault Protection Value Register
	AT91_REG	 PWMC_FPER1; 	// PWM Fault Protection Enable Register 1
	AT91_REG	 PWMC_FPER2; 	// PWM Fault Protection Enable Register 2
	AT91_REG	 PWMC_FPER3; 	// PWM Fault Protection Enable Register 3
	AT91_REG	 PWMC_FPER4; 	// PWM Fault Protection Enable Register 4
	AT91_REG	 PWMC_EL0MR; 	// PWM Event Line 0 Mode Register
	AT91_REG	 PWMC_EL1MR; 	// PWM Event Line 1 Mode Register
	AT91_REG	 PWMC_EL2MR; 	// PWM Event Line 2 Mode Register
	AT91_REG	 PWMC_EL3MR; 	// PWM Event Line 3 Mode Register
	AT91_REG	 PWMC_EL4MR; 	// PWM Event Line 4 Mode Register
	AT91_REG	 PWMC_EL5MR; 	// PWM Event Line 5 Mode Register
	AT91_REG	 PWMC_EL6MR; 	// PWM Event Line 6 Mode Register
	AT91_REG	 PWMC_EL7MR; 	// PWM Event Line 7 Mode Register
	AT91_REG	 Reserved1[18]; 	// 
	AT91_REG	 PWMC_WPCR; 	// PWM Write Protection Enable Register
	AT91_REG	 PWMC_WPSR; 	// PWM Write Protection Status Register
	AT91_REG	 PWMC_ADDRSIZE; 	// PWMC ADDRSIZE REGISTER 
	AT91_REG	 PWMC_IPNAME1; 	// PWMC IPNAME1 REGISTER 
	AT91_REG	 PWMC_IPNAME2; 	// PWMC IPNAME2 REGISTER 
	AT91_REG	 PWMC_FEATURES; 	// PWMC FEATURES REGISTER 
	AT91_REG	 PWMC_VER; 	// PWMC Version Register
	AT91_REG	 PWMC_RPR; 	// Receive Pointer Register
	AT91_REG	 PWMC_RCR; 	// Receive Counter Register
	AT91_REG	 PWMC_TPR; 	// Transmit Pointer Register
	AT91_REG	 PWMC_TCR; 	// Transmit Counter Register
	AT91_REG	 PWMC_RNPR; 	// Receive Next Pointer Register
	AT91_REG	 PWMC_RNCR; 	// Receive Next Counter Register
	AT91_REG	 PWMC_TNPR; 	// Transmit Next Pointer Register
	AT91_REG	 PWMC_TNCR; 	// Transmit Next Counter Register
	AT91_REG	 PWMC_PTCR; 	// PDC Transfer Control Register
	AT91_REG	 PWMC_PTSR; 	// PDC Transfer Status Register
	AT91_REG	 Reserved2[2]; 	// 
	AT91_REG	 PWMC_CMP0V; 	// PWM Comparison Value 0 Register
	AT91_REG	 PWMC_CMP0VUPD; 	// PWM Comparison Value 0 Update Register
	AT91_REG	 PWMC_CMP0M; 	// PWM Comparison Mode 0 Register
	AT91_REG	 PWMC_CMP0MUPD; 	// PWM Comparison Mode 0 Update Register
	AT91_REG	 PWMC_CMP1V; 	// PWM Comparison Value 1 Register
	AT91_REG	 PWMC_CMP1VUPD; 	// PWM Comparison Value 1 Update Register
	AT91_REG	 PWMC_CMP1M; 	// PWM Comparison Mode 1 Register
	AT91_REG	 PWMC_CMP1MUPD; 	// PWM Comparison Mode 1 Update Register
	AT91_REG	 PWMC_CMP2V; 	// PWM Comparison Value 2 Register
	AT91_REG	 PWMC_CMP2VUPD; 	// PWM Comparison Value 2 Update Register
	AT91_REG	 PWMC_CMP2M; 	// PWM Comparison Mode 2 Register
	AT91_REG	 PWMC_CMP2MUPD; 	// PWM Comparison Mode 2 Update Register
	AT91_REG	 PWMC_CMP3V; 	// PWM Comparison Value 3 Register
	AT91_REG	 PWMC_CMP3VUPD; 	// PWM Comparison Value 3 Update Register
	AT91_REG	 PWMC_CMP3M; 	// PWM Comparison Mode 3 Register
	AT91_REG	 PWMC_CMP3MUPD; 	// PWM Comparison Mode 3 Update Register
	AT91_REG	 PWMC_CMP4V; 	// PWM Comparison Value 4 Register
	AT91_REG	 PWMC_CMP4VUPD; 	// PWM Comparison Value 4 Update Register
	AT91_REG	 PWMC_CMP4M; 	// PWM Comparison Mode 4 Register
	AT91_REG	 PWMC_CMP4MUPD; 	// PWM Comparison Mode 4 Update Register
	AT91_REG	 PWMC_CMP5V; 	// PWM Comparison Value 5 Register
	AT91_REG	 PWMC_CMP5VUPD; 	// PWM Comparison Value 5 Update Register
	AT91_REG	 PWMC_CMP5M; 	// PWM Comparison Mode 5 Register
	AT91_REG	 PWMC_CMP5MUPD; 	// PWM Comparison Mode 5 Update Register
	AT91_REG	 PWMC_CMP6V; 	// PWM Comparison Value 6 Register
	AT91_REG	 PWMC_CMP6VUPD; 	// PWM Comparison Value 6 Update Register
	AT91_REG	 PWMC_CMP6M; 	// PWM Comparison Mode 6 Register
	AT91_REG	 PWMC_CMP6MUPD; 	// PWM Comparison Mode 6 Update Register
	AT91_REG	 PWMC_CMP7V; 	// PWM Comparison Value 7 Register
	AT91_REG	 PWMC_CMP7VUPD; 	// PWM Comparison Value 7 Update Register
	AT91_REG	 PWMC_CMP7M; 	// PWM Comparison Mode 7 Register
	AT91_REG	 PWMC_CMP7MUPD; 	// PWM Comparison Mode 7 Update Register
	AT91_REG	 Reserved3[20]; 	// 
	AT91S_PWMC_CH	 PWMC_CH[8]; 	// PWMC Channel 0
} AT91S_PWMC, *AT91PS_PWMC;
// -------- PWMC_MR : (PWMC Offset: 0x0) PWMC Mode Register -------- 
// -------- PWMC_ENA : (PWMC Offset: 0x4) PWMC Enable Register -------- 
// -------- PWMC_DIS : (PWMC Offset: 0x8) PWMC Disable Register -------- 
// -------- PWMC_SR : (PWMC Offset: 0xc) PWMC Status Register -------- 
// -------- PWMC_IER1 : (PWMC Offset: 0x10) PWMC Interrupt Enable Register -------- 
// -------- PWMC_IDR1 : (PWMC Offset: 0x14) PWMC Interrupt Disable Register -------- 
// -------- PWMC_IMR1 : (PWMC Offset: 0x18) PWMC Interrupt Mask Register -------- 
// -------- PWMC_ISR1 : (PWMC Offset: 0x1c) PWMC Interrupt Status Register -------- 
// -------- PWMC_SYNC : (PWMC Offset: 0x20) PWMC Synchronous Channels Register -------- 
// -------- PWMC_UPCR : (PWMC Offset: 0x28) PWMC Update Control Register -------- 
// -------- PWMC_SCUP : (PWMC Offset: 0x2c) PWM Update Period Register -------- 
// -------- PWMC_SCUPUPD : (PWMC Offset: 0x30) PWM Update Period Update Register -------- 
// -------- PWMC_IER2 : (PWMC Offset: 0x34) PWMC Interrupt Enable Register -------- 
// -------- PWMC_IDR2 : (PWMC Offset: 0x38) PWMC Interrupt Disable Register -------- 
// -------- PWMC_IMR2 : (PWMC Offset: 0x3c) PWMC Interrupt Mask Register -------- 
// -------- PWMC_ISR2 : (PWMC Offset: 0x40) PWMC Interrupt Status Register -------- 
// -------- PWMC_OOV : (PWMC Offset: 0x44) PWM Output Override Value Register -------- 
// -------- PWMC_OS : (PWMC Offset: 0x48) PWM Output Selection Register -------- 
// -------- PWMC_OSS : (PWMC Offset: 0x4c) PWM Output Selection Set Register -------- 
// -------- PWMC_OSC : (PWMC Offset: 0x50) PWM Output Selection Clear Register -------- 
// -------- PWMC_OSSUPD : (PWMC Offset: 0x54) Output Selection Set for PWMH / PWML output of the channel x -------- 
// -------- PWMC_OSCUPD : (PWMC Offset: 0x58) Output Selection Clear for PWMH / PWML output of the channel x -------- 
// -------- PWMC_FMR : (PWMC Offset: 0x5c) PWM Fault Mode Register -------- 
// -------- PWMC_FSR : (PWMC Offset: 0x60) Fault Input x Value -------- 
// -------- PWMC_FCR : (PWMC Offset: 0x64) Fault y Clear -------- 
// -------- PWMC_FPV : (PWMC Offset: 0x68) PWM Fault Protection Value -------- 
// -------- PWMC_FPER1 : (PWMC Offset: 0x6c) PWM Fault Protection Enable Register 1 -------- 
// -------- PWMC_FPER2 : (PWMC Offset: 0x70) PWM Fault Protection Enable Register 2 -------- 
// -------- PWMC_FPER3 : (PWMC Offset: 0x74) PWM Fault Protection Enable Register 3 -------- 
// -------- PWMC_FPER4 : (PWMC Offset: 0x78) PWM Fault Protection Enable Register 4 -------- 
// -------- PWMC_EL0MR : (PWMC Offset: 0x7c) PWM Event Line 0 Mode Register -------- 
// -------- PWMC_EL1MR : (PWMC Offset: 0x80) PWM Event Line 1 Mode Register -------- 
// -------- PWMC_EL2MR : (PWMC Offset: 0x84) PWM Event line 2 Mode Register -------- 
// -------- PWMC_EL3MR : (PWMC Offset: 0x88) PWM Event line 3 Mode Register -------- 
// -------- PWMC_EL4MR : (PWMC Offset: 0x8c) PWM Event line 4 Mode Register -------- 
// -------- PWMC_EL5MR : (PWMC Offset: 0x90) PWM Event line 5 Mode Register -------- 
// -------- PWMC_EL6MR : (PWMC Offset: 0x94) PWM Event line 6 Mode Register -------- 
// -------- PWMC_EL7MR : (PWMC Offset: 0x98) PWM Event line 7 Mode Register -------- 
// -------- PWMC_WPCR : (PWMC Offset: 0xe4) PWM Write Protection Control Register -------- 
// -------- PWMC_WPVS : (PWMC Offset: 0xe8) Write Protection Status Register -------- 
// -------- PWMC_CMP0V : (PWMC Offset: 0x130) PWM Comparison Value 0 Register -------- 
// -------- PWMC_CMP0VUPD : (PWMC Offset: 0x134) PWM Comparison Value 0 Update Register -------- 
// -------- PWMC_CMP0M : (PWMC Offset: 0x138) PWM Comparison 0 Mode Register -------- 
// -------- PWMC_CMP0MUPD : (PWMC Offset: 0x13c) PWM Comparison 0 Mode Update Register -------- 
// -------- PWMC_CMP1V : (PWMC Offset: 0x140) PWM Comparison Value 1 Register -------- 
// -------- PWMC_CMP1VUPD : (PWMC Offset: 0x144) PWM Comparison Value 1 Update Register -------- 
// -------- PWMC_CMP1M : (PWMC Offset: 0x148) PWM Comparison 1 Mode Register -------- 
// -------- PWMC_CMP1MUPD : (PWMC Offset: 0x14c) PWM Comparison 1 Mode Update Register -------- 
// -------- PWMC_CMP2V : (PWMC Offset: 0x150) PWM Comparison Value 2 Register -------- 
// -------- PWMC_CMP2VUPD : (PWMC Offset: 0x154) PWM Comparison Value 2 Update Register -------- 
// -------- PWMC_CMP2M : (PWMC Offset: 0x158) PWM Comparison 2 Mode Register -------- 
// -------- PWMC_CMP2MUPD : (PWMC Offset: 0x15c) PWM Comparison 2 Mode Update Register -------- 
// -------- PWMC_CMP3V : (PWMC Offset: 0x160) PWM Comparison Value 3 Register -------- 
// -------- PWMC_CMP3VUPD : (PWMC Offset: 0x164) PWM Comparison Value 3 Update Register -------- 
// -------- PWMC_CMP3M : (PWMC Offset: 0x168) PWM Comparison 3 Mode Register -------- 
// -------- PWMC_CMP3MUPD : (PWMC Offset: 0x16c) PWM Comparison 3 Mode Update Register -------- 
// -------- PWMC_CMP4V : (PWMC Offset: 0x170) PWM Comparison Value 4 Register -------- 
// -------- PWMC_CMP4VUPD : (PWMC Offset: 0x174) PWM Comparison Value 4 Update Register -------- 
// -------- PWMC_CMP4M : (PWMC Offset: 0x178) PWM Comparison 4 Mode Register -------- 
// -------- PWMC_CMP4MUPD : (PWMC Offset: 0x17c) PWM Comparison 4 Mode Update Register -------- 
// -------- PWMC_CMP5V : (PWMC Offset: 0x180) PWM Comparison Value 5 Register -------- 
// -------- PWMC_CMP5VUPD : (PWMC Offset: 0x184) PWM Comparison Value 5 Update Register -------- 
// -------- PWMC_CMP5M : (PWMC Offset: 0x188) PWM Comparison 5 Mode Register -------- 
// -------- PWMC_CMP5MUPD : (PWMC Offset: 0x18c) PWM Comparison 5 Mode Update Register -------- 
// -------- PWMC_CMP6V : (PWMC Offset: 0x190) PWM Comparison Value 6 Register -------- 
// -------- PWMC_CMP6VUPD : (PWMC Offset: 0x194) PWM Comparison Value 6 Update Register -------- 
// -------- PWMC_CMP6M : (PWMC Offset: 0x198) PWM Comparison 6 Mode Register -------- 
// -------- PWMC_CMP6MUPD : (PWMC Offset: 0x19c) PWM Comparison 6 Mode Update Register -------- 
// -------- PWMC_CMP7V : (PWMC Offset: 0x1a0) PWM Comparison Value 7 Register -------- 
// -------- PWMC_CMP7VUPD : (PWMC Offset: 0x1a4) PWM Comparison Value 7 Update Register -------- 
// -------- PWMC_CMP7M : (PWMC Offset: 0x1a8) PWM Comparison 7 Mode Register -------- 
// -------- PWMC_CMP7MUPD : (PWMC Offset: 0x1ac) PWM Comparison 7 Mode Update Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR Serial Parallel Interface
// *****************************************************************************
typedef struct _AT91S_SPI {
	AT91_REG	 SPI_CR; 	// Control Register
	AT91_REG	 SPI_MR; 	// Mode Register
	AT91_REG	 SPI_RDR; 	// Receive Data Register
	AT91_REG	 SPI_TDR; 	// Transmit Data Register
	AT91_REG	 SPI_SR; 	// Status Register
	AT91_REG	 SPI_IER; 	// Interrupt Enable Register
	AT91_REG	 SPI_IDR; 	// Interrupt Disable Register
	AT91_REG	 SPI_IMR; 	// Interrupt Mask Register
	AT91_REG	 Reserved0[4]; 	// 
	AT91_REG	 SPI_CSR[4]; 	// Chip Select Register
	AT91_REG	 Reserved1[43]; 	// 
	AT91_REG	 SPI_ADDRSIZE; 	// SPI ADDRSIZE REGISTER 
	AT91_REG	 SPI_IPNAME1; 	// SPI IPNAME1 REGISTER 
	AT91_REG	 SPI_IPNAME2; 	// SPI IPNAME2 REGISTER 
	AT91_REG	 SPI_FEATURES; 	// SPI FEATURES REGISTER 
	AT91_REG	 SPI_VER; 	// Version Register
} AT91S_SPI, *AT91PS_SPI;
// -------- SPI_CR : (SPI Offset: 0x0) SPI Control Register -------- 
// -------- SPI_MR : (SPI Offset: 0x4) SPI Mode Register -------- 
// -------- SPI_RDR : (SPI Offset: 0x8) Receive Data Register -------- 
// -------- SPI_TDR : (SPI Offset: 0xc) Transmit Data Register -------- 
// -------- SPI_SR : (SPI Offset: 0x10) Status Register -------- 
// -------- SPI_IER : (SPI Offset: 0x14) Interrupt Enable Register -------- 
// -------- SPI_IDR : (SPI Offset: 0x18) Interrupt Disable Register -------- 
// -------- SPI_IMR : (SPI Offset: 0x1c) Interrupt Mask Register -------- 
// -------- SPI_CSR : (SPI Offset: 0x30) Chip Select Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR UDPHS Enpoint FIFO data register
// *****************************************************************************
typedef struct _AT91S_UDPHS_EPTFIFO {
	AT91_REG	 UDPHS_READEPT0[16384]; 	// FIFO Endpoint Data Register 0
	AT91_REG	 UDPHS_READEPT1[16384]; 	// FIFO Endpoint Data Register 1
	AT91_REG	 UDPHS_READEPT2[16384]; 	// FIFO Endpoint Data Register 2
	AT91_REG	 UDPHS_READEPT3[16384]; 	// FIFO Endpoint Data Register 3
	AT91_REG	 UDPHS_READEPT4[16384]; 	// FIFO Endpoint Data Register 4
	AT91_REG	 UDPHS_READEPT5[16384]; 	// FIFO Endpoint Data Register 5
	AT91_REG	 UDPHS_READEPT6[16384]; 	// FIFO Endpoint Data Register 6
} AT91S_UDPHS_EPTFIFO, *AT91PS_UDPHS_EPTFIFO;

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR UDPHS Endpoint struct
// *****************************************************************************
typedef struct _AT91S_UDPHS_EPT {
	AT91_REG	 UDPHS_EPTCFG; 	// UDPHS Endpoint Config Register
	AT91_REG	 UDPHS_EPTCTLENB; 	// UDPHS Endpoint Control Enable Register
	AT91_REG	 UDPHS_EPTCTLDIS; 	// UDPHS Endpoint Control Disable Register
	AT91_REG	 UDPHS_EPTCTL; 	// UDPHS Endpoint Control Register
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 UDPHS_EPTSETSTA; 	// UDPHS Endpoint Set Status Register
	AT91_REG	 UDPHS_EPTCLRSTA; 	// UDPHS Endpoint Clear Status Register
	AT91_REG	 UDPHS_EPTSTA; 	// UDPHS Endpoint Status Register
} AT91S_UDPHS_EPT, *AT91PS_UDPHS_EPT;
// -------- UDPHS_EPTCFG : (UDPHS_EPT Offset: 0x0) UDPHS Endpoint Config Register -------- 
// -------- UDPHS_EPTCTLENB : (UDPHS_EPT Offset: 0x4) UDPHS Endpoint Control Enable Register -------- 
// -------- UDPHS_EPTCTLDIS : (UDPHS_EPT Offset: 0x8) UDPHS Endpoint Control Disable Register -------- 
// -------- UDPHS_EPTCTL : (UDPHS_EPT Offset: 0xc) UDPHS Endpoint Control Register -------- 
// -------- UDPHS_EPTSETSTA : (UDPHS_EPT Offset: 0x14) UDPHS Endpoint Set Status Register -------- 
// -------- UDPHS_EPTCLRSTA : (UDPHS_EPT Offset: 0x18) UDPHS Endpoint Clear Status Register -------- 
// -------- UDPHS_EPTSTA : (UDPHS_EPT Offset: 0x1c) UDPHS Endpoint Status Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR UDPHS DMA struct
// *****************************************************************************
typedef struct _AT91S_UDPHS_DMA {
	AT91_REG	 UDPHS_DMANXTDSC; 	// UDPHS DMA Channel Next Descriptor Address
	AT91_REG	 UDPHS_DMAADDRESS; 	// UDPHS DMA Channel Address Register
	AT91_REG	 UDPHS_DMACONTROL; 	// UDPHS DMA Channel Control Register
	AT91_REG	 UDPHS_DMASTATUS; 	// UDPHS DMA Channel Status Register
} AT91S_UDPHS_DMA, *AT91PS_UDPHS_DMA;
// -------- UDPHS_DMANXTDSC : (UDPHS_DMA Offset: 0x0) UDPHS DMA Next Descriptor Address Register -------- 
// -------- UDPHS_DMAADDRESS : (UDPHS_DMA Offset: 0x4) UDPHS DMA Channel Address Register -------- 
// -------- UDPHS_DMACONTROL : (UDPHS_DMA Offset: 0x8) UDPHS DMA Channel Control Register -------- 
// -------- UDPHS_DMASTATUS : (UDPHS_DMA Offset: 0xc) UDPHS DMA Channelx Status Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR UDPHS High Speed Device Interface
// *****************************************************************************
typedef struct _AT91S_UDPHS {
	AT91_REG	 UDPHS_CTRL; 	// UDPHS Control Register
	AT91_REG	 UDPHS_FNUM; 	// UDPHS Frame Number Register
	AT91_REG	 Reserved0[2]; 	// 
	AT91_REG	 UDPHS_IEN; 	// UDPHS Interrupt Enable Register
	AT91_REG	 UDPHS_INTSTA; 	// UDPHS Interrupt Status Register
	AT91_REG	 UDPHS_CLRINT; 	// UDPHS Clear Interrupt Register
	AT91_REG	 UDPHS_EPTRST; 	// UDPHS Endpoints Reset Register
	AT91_REG	 Reserved1[44]; 	// 
	AT91_REG	 UDPHS_TSTSOFCNT; 	// UDPHS Test SOF Counter Register
	AT91_REG	 UDPHS_TSTCNTA; 	// UDPHS Test A Counter Register
	AT91_REG	 UDPHS_TSTCNTB; 	// UDPHS Test B Counter Register
	AT91_REG	 UDPHS_TSTMODREG; 	// UDPHS Test Mode Register
	AT91_REG	 UDPHS_TST; 	// UDPHS Test Register
	AT91_REG	 Reserved2[2]; 	// 
	AT91_REG	 UDPHS_RIPPADDRSIZE; 	// UDPHS PADDRSIZE Register
	AT91_REG	 UDPHS_RIPNAME1; 	// UDPHS Name1 Register
	AT91_REG	 UDPHS_RIPNAME2; 	// UDPHS Name2 Register
	AT91_REG	 UDPHS_IPFEATURES; 	// UDPHS Features Register
	AT91_REG	 UDPHS_IPVERSION; 	// UDPHS Version Register
	AT91S_UDPHS_EPT	 UDPHS_EPT[7]; 	// UDPHS Endpoint struct
	AT91_REG	 Reserved3[72]; 	// 
	AT91S_UDPHS_DMA	 UDPHS_DMA[6]; 	// UDPHS DMA channel struct (not use [0])
} AT91S_UDPHS, *AT91PS_UDPHS;
// -------- UDPHS_CTRL : (UDPHS Offset: 0x0) UDPHS Control Register -------- 
// -------- UDPHS_FNUM : (UDPHS Offset: 0x4) UDPHS Frame Number Register -------- 
// -------- UDPHS_IEN : (UDPHS Offset: 0x10) UDPHS Interrupt Enable Register -------- 
// -------- UDPHS_INTSTA : (UDPHS Offset: 0x14) UDPHS Interrupt Status Register -------- 
// -------- UDPHS_CLRINT : (UDPHS Offset: 0x18) UDPHS Clear Interrupt Register -------- 
// -------- UDPHS_EPTRST : (UDPHS Offset: 0x1c) UDPHS Endpoints Reset Register -------- 
// -------- UDPHS_TSTSOFCNT : (UDPHS Offset: 0xd0) UDPHS Test SOF Counter Register -------- 
// -------- UDPHS_TSTCNTA : (UDPHS Offset: 0xd4) UDPHS Test A Counter Register -------- 
// -------- UDPHS_TSTCNTB : (UDPHS Offset: 0xd8) UDPHS Test B Counter Register -------- 
// -------- UDPHS_TSTMODREG : (UDPHS Offset: 0xdc) UDPHS Test Mode Register -------- 
// -------- UDPHS_TST : (UDPHS Offset: 0xe0) UDPHS Test Register -------- 
// -------- UDPHS_RIPPADDRSIZE : (UDPHS Offset: 0xec) UDPHS PADDRSIZE Register -------- 
// -------- UDPHS_RIPNAME1 : (UDPHS Offset: 0xf0) UDPHS Name Register -------- 
// -------- UDPHS_RIPNAME2 : (UDPHS Offset: 0xf4) UDPHS Name Register -------- 
// -------- UDPHS_IPFEATURES : (UDPHS Offset: 0xf8) UDPHS Features Register -------- 
// -------- UDPHS_IPVERSION : (UDPHS Offset: 0xfc) UDPHS Version Register -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR HDMA Channel structure
// *****************************************************************************
typedef struct _AT91S_HDMA_CH {
	AT91_REG	 HDMA_SADDR; 	// HDMA Channel Source Address Register
	AT91_REG	 HDMA_DADDR; 	// HDMA Channel Destination Address Register
	AT91_REG	 HDMA_DSCR; 	// HDMA Channel Descriptor Address Register
	AT91_REG	 HDMA_CTRLA; 	// HDMA Channel Control A Register
	AT91_REG	 HDMA_CTRLB; 	// HDMA Channel Control B Register
	AT91_REG	 HDMA_CFG; 	// HDMA Channel Configuration Register
} AT91S_HDMA_CH, *AT91PS_HDMA_CH;
// -------- HDMA_SADDR : (HDMA_CH Offset: 0x0)  -------- 
// -------- HDMA_DADDR : (HDMA_CH Offset: 0x4)  -------- 
// -------- HDMA_DSCR : (HDMA_CH Offset: 0x8)  -------- 
// -------- HDMA_CTRLA : (HDMA_CH Offset: 0xc)  -------- 
// -------- HDMA_CTRLB : (HDMA_CH Offset: 0x10)  -------- 
// -------- HDMA_CFG : (HDMA_CH Offset: 0x14)  -------- 

// *****************************************************************************
//              SOFTWARE API DEFINITION  FOR HDMA controller
// *****************************************************************************
typedef struct _AT91S_HDMA {
	AT91_REG	 HDMA_GCFG; 	// HDMA Global Configuration Register
	AT91_REG	 HDMA_EN; 	// HDMA Controller Enable Register
	AT91_REG	 HDMA_SREQ; 	// HDMA Software Single Request Register
	AT91_REG	 HDMA_CREQ; 	// HDMA Software Chunk Transfer Request Register
	AT91_REG	 HDMA_LAST; 	// HDMA Software Last Transfer Flag Register
	AT91_REG	 Reserved0[1]; 	// 
	AT91_REG	 HDMA_EBCIER; 	// HDMA Error, Chained Buffer transfer completed and Buffer transfer completed Interrupt Enable register
	AT91_REG	 HDMA_EBCIDR; 	// HDMA Error, Chained Buffer transfer completed and Buffer transfer completed Interrupt Disable register
	AT91_REG	 HDMA_EBCIMR; 	// HDMA Error, Chained Buffer transfer completed and Buffer transfer completed Mask Register
	AT91_REG	 HDMA_EBCISR; 	// HDMA Error, Chained Buffer transfer completed and Buffer transfer completed Status Register
	AT91_REG	 HDMA_CHER; 	// HDMA Channel Handler Enable Register
	AT91_REG	 HDMA_CHDR; 	// HDMA Channel Handler Disable Register
	AT91_REG	 HDMA_CHSR; 	// HDMA Channel Handler Status Register
	AT91_REG	 Reserved1[2]; 	// 
	AT91S_HDMA_CH	 HDMA_CH[4]; 	// HDMA Channel structure
	AT91_REG	 Reserved2[84]; 	// 
	AT91_REG	 HDMA_ADDRSIZE; 	// HDMA ADDRSIZE REGISTER 
	AT91_REG	 HDMA_IPNAME1; 	// HDMA IPNAME1 REGISTER 
	AT91_REG	 HDMA_IPNAME2; 	// HDMA IPNAME2 REGISTER 
	AT91_REG	 HDMA_FEATURES; 	// HDMA FEATURES REGISTER 
	AT91_REG	 HDMA_VER; 	// HDMA VERSION REGISTER 
} AT91S_HDMA, *AT91PS_HDMA;
// -------- HDMA_GCFG : (HDMA Offset: 0x0)  -------- 
// -------- HDMA_EN : (HDMA Offset: 0x4)  -------- 
// -------- HDMA_SREQ : (HDMA Offset: 0x8)  -------- 
// -------- HDMA_CREQ : (HDMA Offset: 0xc)  -------- 
// -------- HDMA_LAST : (HDMA Offset: 0x10)  -------- 
// -------- HDMA_EBCIER : (HDMA Offset: 0x18) Buffer Transfer Completed/Chained Buffer Transfer Completed/Access Error Interrupt Enable Register -------- 
// -------- HDMA_EBCIDR : (HDMA Offset: 0x1c)  -------- 
// -------- HDMA_EBCIMR : (HDMA Offset: 0x20)  -------- 
// -------- HDMA_EBCISR : (HDMA Offset: 0x24)  -------- 
// -------- HDMA_CHER : (HDMA Offset: 0x28)  -------- 
// -------- HDMA_CHDR : (HDMA Offset: 0x2c)  -------- 
// -------- HDMA_CHSR : (HDMA Offset: 0x30)  -------- 
// -------- HDMA_VER : (HDMA Offset: 0x1fc)  -------- 

// *****************************************************************************
//               REGISTER ADDRESS DEFINITION FOR AT91SAM3U4
// *****************************************************************************
// ========== Register definition for SYS peripheral ========== 
// ========== Register definition for HSMC4_CS0 peripheral ========== 
// ========== Register definition for HSMC4_CS1 peripheral ========== 
// ========== Register definition for HSMC4_CS2 peripheral ========== 
// ========== Register definition for HSMC4_CS3 peripheral ========== 
// ========== Register definition for HSMC4_NFC peripheral ========== 
// ========== Register definition for HSMC4 peripheral ========== 
// ========== Register definition for MATRIX peripheral ========== 
// ========== Register definition for NVIC peripheral ========== 
// ========== Register definition for MPU peripheral ========== 
// ========== Register definition for CM3 peripheral ========== 
// ========== Register definition for PDC_DBGU peripheral ========== 
// ========== Register definition for DBGU peripheral ========== 
// ========== Register definition for PIOA peripheral ========== 
// ========== Register definition for PIOB peripheral ========== 
// ========== Register definition for PIOC peripheral ========== 
// ========== Register definition for PMC peripheral ========== 
// ========== Register definition for CKGR peripheral ========== 
// ========== Register definition for RSTC peripheral ========== 
// ========== Register definition for SUPC peripheral ========== 
// ========== Register definition for RTTC peripheral ========== 
// ========== Register definition for WDTC peripheral ========== 
// ========== Register definition for RTC peripheral ========== 
// ========== Register definition for ADC0 peripheral ========== 
// ========== Register definition for ADC12B peripheral ==========
// ========== Register definition for TC0 peripheral ========== 
// ========== Register definition for TC1 peripheral ========== 
// ========== Register definition for TC2 peripheral ========== 
// ========== Register definition for TCB0 peripheral ========== 
// ========== Register definition for TCB1 peripheral ========== 
// ========== Register definition for TCB2 peripheral ========== 
// ========== Register definition for EFC0 peripheral ========== 
// ========== Register definition for EFC1 peripheral ========== 
// ========== Register definition for MCI0 peripheral ========== 
// ========== Register definition for PDC_TWI0 peripheral ========== 
// ========== Register definition for PDC_TWI1 peripheral ========== 
// ========== Register definition for TWI0 peripheral ========== 
// ========== Register definition for TWI1 peripheral ========== 
// ========== Register definition for PDC_US0 peripheral ========== 
// ========== Register definition for US0 peripheral ========== 
// ========== Register definition for PDC_US1 peripheral ========== 
// ========== Register definition for US1 peripheral ========== 
// ========== Register definition for PDC_US2 peripheral ========== 
// ========== Register definition for US2 peripheral ========== 
// ========== Register definition for PDC_US3 peripheral ========== 
// ========== Register definition for US3 peripheral ========== 
// ========== Register definition for PDC_SSC0 peripheral ========== 
// ========== Register definition for SSC0 peripheral ========== 
// ========== Register definition for PDC_PWMC peripheral ========== 
// ========== Register definition for PWMC_CH0 peripheral ========== 
// ========== Register definition for PWMC_CH1 peripheral ========== 
// ========== Register definition for PWMC_CH2 peripheral ========== 
// ========== Register definition for PWMC_CH3 peripheral ========== 
// ========== Register definition for PWMC peripheral ========== 
// ========== Register definition for SPI0 peripheral ========== 
// ========== Register definition for UDPHS_EPTFIFO peripheral ========== 
// ========== Register definition for UDPHS_EPT_0 peripheral ========== 
// ========== Register definition for UDPHS_EPT_1 peripheral ========== 
// ========== Register definition for UDPHS_EPT_2 peripheral ========== 
// ========== Register definition for UDPHS_EPT_3 peripheral ========== 
// ========== Register definition for UDPHS_EPT_4 peripheral ========== 
// ========== Register definition for UDPHS_EPT_5 peripheral ========== 
// ========== Register definition for UDPHS_EPT_6 peripheral ========== 
// ========== Register definition for UDPHS_DMA_1 peripheral ========== 
// ========== Register definition for UDPHS_DMA_2 peripheral ========== 
// ========== Register definition for UDPHS_DMA_3 peripheral ========== 
// ========== Register definition for UDPHS_DMA_4 peripheral ========== 
// ========== Register definition for UDPHS_DMA_5 peripheral ========== 
// ========== Register definition for UDPHS_DMA_6 peripheral ========== 
// ========== Register definition for UDPHS peripheral ========== 
// ========== Register definition for HDMA_CH_0 peripheral ========== 
// ========== Register definition for HDMA_CH_1 peripheral ========== 
// ========== Register definition for HDMA_CH_2 peripheral ========== 
// ========== Register definition for HDMA_CH_3 peripheral ========== 
// ========== Register definition for HDMA peripheral ========== 

// *****************************************************************************
//               PIO DEFINITIONS FOR AT91SAM3U4
// *****************************************************************************

// *****************************************************************************
//               PERIPHERAL ID DEFINITIONS FOR AT91SAM3U4
// *****************************************************************************

// *****************************************************************************
//               BASE ADDRESS DEFINITIONS FOR AT91SAM3U4
// How do these casts work?
// AT91_CAST does nothing for C code, so essentially the type cast is just the generic peripheral struct AT91PS_x
// So AT91C_BASE_X should just be an address to the starting peripheral register address 
// *****************************************************************************

// *****************************************************************************
//               MEMORY MAPPING DEFINITIONS FOR AT91SAM3U4
// *****************************************************************************
// ITCM
// DTCM
// IRAM
// IRAM_MIN
// IROM
// IFLASH0
// IFLASH1
// EBI_CS0
// EBI_CS1
// EBI_SDRAM
// EBI_SDRAM_16BIT
// EBI_SDRAM_32BIT
// EBI_CS2
// EBI_CS3
// EBI_SM
// EBI_CS4
// EBI_CF0
// EBI_CS5
// EBI_CF1

/*!
@file exceptions.h 
@brief Atmel-supplied header file for exceptions.c
*/

/* ----------------------------------------------------------------------------
 *         ATMEL Microcontroller Software Support 
 * ----------------------------------------------------------------------------
 * Copyright (c) 2008, Atmel Corporation
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the disclaimer below.
 *
 * Atmel's name may not be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * DISCLAIMER: THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
 * DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ----------------------------------------------------------------------------
 */

/*
** This file contains the default exception handlers
** and exception table.
*/

//------------------------------------------------------------------------------
//         Types
//------------------------------------------------------------------------------

/*! 
@enum IntFunc
@brief Function pointer defintion for interrupt handler functions.
*/
typedef void( *IntFunc )( void );

/// Weak attribute

//------------------------------------------------------------------------------
//         Global functions
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//         Exception Handlers
//------------------------------------------------------------------------------

extern __weak void NMI_Handler( void );
extern __weak void HardFault_Handler( void );
extern __weak void MemManage_Handler( void );
extern __weak void BusFault_Handler( void );
extern __weak void UsageFault_Handler( void );
extern __weak void SVC_Handler( void );
extern __weak void DebugMon_Handler( void );
extern __weak void PendSV_Handler( void );
extern __weak void SysTick_Handler( void );
void IrqHandlerNotUsed(void);


// System Controller
extern void SYS_IrqHandler(void);
// SUPPLY CONTROLLER
extern __weak void SUPC_IrqHandler(void);
// RESET CONTROLLER
extern __weak void RSTC_IrqHandler(void);
// REAL TIME CLOCK
extern __weak void RTC_IrqHandler(void);
// REAL TIME TIMER
extern __weak void RTT_IrqHandler(void);
// WATCHDOG TIMER
extern __weak void WDT_IrqHandler(void);
// PMC
extern __weak void PMC_IrqHandler(void);
// EFC0
extern __weak void EFC0_IrqHandler(void);
// EFC1
extern __weak void EFC1_IrqHandler(void);
// DBGU
extern __weak void DBGU_IrqHandler(void);
// HSMC4
extern __weak void HSMC4_IrqHandler(void);
// Parallel IO Controller A
extern __weak void PIOA_IrqHandler(void);
// Parallel IO Controller B
extern __weak void PIOB_IrqHandler(void);
// Parallel IO Controller C
extern __weak void PIOC_IrqHandler(void);
// USART 0
extern __weak void USART0_IrqHandler(void);
// USART 1
extern __weak void USART1_IrqHandler(void);
// USART 2
extern __weak void USART2_IrqHandler(void);
// USART 3
extern __weak void USART3_IrqHandler(void);
// Multimedia Card Interface
extern __weak void MCI0_IrqHandler(void);
// TWI 0
extern __weak void TWI0_IrqHandler(void);
// TWI 1
extern __weak void TWI1_IrqHandler(void);
// Serial Peripheral Interface 0
extern __weak void SPI0_IrqHandler(void);
// Serial Synchronous Controller 0
extern __weak void SSC0_IrqHandler(void);
// Timer Counter 0
extern __weak void TC0_IrqHandler(void);
// Timer Counter 1
extern __weak void TC1_IrqHandler(void);
// Timer Counter 2
extern __weak void TC2_IrqHandler(void);
// PWM Controller
extern __weak void PWM_IrqHandler(void);
// ADC controller0
extern __weak void ADCC0_IrqHandler(void);
// ADC controller1
extern __weak void ADCC1_IrqHandler(void);
// HDMA
extern __weak void HDMA_IrqHandler(void);
// USB Device High Speed UDP_HS
extern __weak void UDPD_IrqHandler(void);

/*!*********************************************************************************************************************
@file interrupts.h                                                               
@brief Interrupt declarations for use with EIE development board firmware.
***********************************************************************************************************************/


/***********************************************************************************************************************
Type Definitions
***********************************************************************************************************************/

/*! 
@enum IRQn
@brief Exception table items to map ATMEL defined symbols to CMSIS values.
*/
typedef enum IRQn
{
/******  Cortex-M3 Processor Exceptions Numbers ***************************************************/
  NonMaskableInt_IRQn     = -14,             /*!< @brief 2 Non Maskable Interrupt                             */
  MemoryManagement_IRQn   = -12,             /*!< @brief 4 Cortex-M3 Memory Management Interrupt              */
  BusFault_IRQn           = -11,             /*!< @brief 5 Cortex-M3 Bus Fault Interrupt                      */
  UsageFault_IRQn         = -10,             /*!< @brief 6 Cortex-M3 Usage Fault Interrupt                    */
  SVCall_IRQn             = -5,              /*!< @brief 11 Cortex-M3 SV Call Interrupt                       */
  DebugMonitor_IRQn       = -4,              /*!< @brief 12 Cortex-M3 Debug Monitor Interrupt                 */
  PendSV_IRQn             = -2,              /*!< @brief 14 Cortex-M3 Pend SV Interrupt                       */
  SysTick_IRQn            = -1,              /*!< @brief 15 Cortex-M3 System Tick Interrupt                   */

/******  AT91SAM3U4 specific Interrupt Numbers ****************************************************/
 IRQn_SUPC                = ( 0) ,  /*!< @brief SUPPLY CONTROLLER */
 IRQn_RSTC                = ( 1) ,  /*!< @brief RESET CONTROLLER */
 IRQn_RTC                 = ( 2)  ,  /*!< @brief REAL TIME CLOCK */
 IRQn_RTT                 = ( 3)  ,  /*!< @brief REAL TIME TIMER */
 IRQn_WDG                 = ( 4)  ,  /*!< @brief WATCHDOG TIMER */
 IRQn_PMC                 = ( 5)  ,  /*!< @brief PMC */
 IRQn_EFC0                = ( 6) ,  /*!< @brief EFC0 */
 IRQn_EFC1                = ( 7) ,  /*!< @brief @brief EFC1 */
 IRQn_DBGU                = ( 8) ,  /*!< @brief DBGU (dedicated UART) */
 IRQn_HSMC4               = ( 9),  /*!< @brief HSMC4 */
 IRQn_PIOA                = (10) ,  /*!< @brief Parallel IO Controller A */
 IRQn_PIOB                = (11) ,  /*!< @brief Parallel IO Controller B */
 IRQn_PIOC                = (12) ,  /*!< @brief Parallel IO Controller C */
 IRQn_US0                 = (13)  ,  /*!< @brief USART 0 */
 IRQn_US1                 = (14)  ,  /*!< @brief USART 1 */
 IRQn_US2                 = (15)  ,  /*!< @brief USART 2 */
 IRQn_US3                 = (16)  ,  /*!< @brief USART 3 */
 IRQn_MCI0                = (17) ,  /*!< @brief Multimedia Card Interface */
 IRQn_TWI0                = (18) ,  /*!< @brief TWI 0 */
 IRQn_TWI1                = (19) ,  /*!< @brief TWI 1 */
 IRQn_SPI0                = (20) ,  /*!< @brief Serial Peripheral Interface */
 IRQn_SSC0                = (21) ,  /*!< @brief Serial Synchronous Controller 0 */
 IRQn_TC0                 = (22)  ,  /*!< @brief @brief Timer Counter 0 */
 IRQn_TC1                 = (23)  ,  /*!< @brief Timer Counter 1 */
 IRQn_TC2                 = (24)  ,  /*!< @brief Timer Counter 2 */
 IRQn_PWMC                = (25) ,  /*!< @brief Pulse Width Modulation Controller */
 IRQn_ADCC0               = (26), /*!< @brief ADC controller0 */
 IRQn_ADCC1               = (27)  ,  /*!< @brief ADC controller1 */
 IRQn_HDMA                = (28) ,  /*!< @brief HDMA */
 IRQn_UDPHS               = (29)   /*!< @brief USB Device High Speed */
} IRQn_Type;


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void InterruptSetup(void);
void PIOA_IrqHandler(void);
void PIOB_IrqHandler(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
Constants / Definitions
***********************************************************************************************************************/


/*!*********************************************************************************************************************
@brief Priority registers allocate all interrupts to the available
priority levels.

Interrupt Priorities (Highest -> Lowest)

Interrupt priorities start at 0 (highest priority) and go to
15 (lowest priority).  However, these correspond to Exception priorities 16 
through 31 since there are Core exceptions that are always of higher priority.
The interrupt number is processor specific and can be found around line 6650 in 
the AT91SAM3U4 header file and as "Peripheral Identifiers" on page 42 of the 10-Feb-12 datasheet.
Interrupt number / peripheral identifier has nothing to do with the corresponding interrupt priority.
Interrupt priorities are set by loading a priority slot with an interrupt number.

All unused interrupt sources will be set to priority 31.
*/

/*!< Bit Set Description
    31 [1] ( 3) // REAL TIME TIMER priority 15
    30 [1] "
    29 [1] "
    28 [1] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [1] ( 2) // REAL TIME CLOCK priority 15
    22 [1] "
    21 [1] "
    20 [1] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [0] ( 1) // RESET CONTROLLER priority 0
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [1] ( 0) // SUPPLY CONTROLLER priority 15
    06 [1] "
    05 [1] "
    04 [1] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 [1] ( 7) // EFC1 priority 15
    30 [1] "
    29 [1] "
    28 [1] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [1] ( 6) // EFC0 priority 15
    22 [1] "
    21 [1] "
    20 [1] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [1] ( 5) // PMC priority 15
    14 [1] "
    13 [1] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] ( 4) // WATCHDOG TIMER priority 0
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 [0] (11) // Parallel IO Controller B priority 5
    30 [1] "
    29 [0] "
    28 [1] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] (10) // Parallel IO Controller A priority 5
    22 [1] "
    21 [0] "
    20 [1] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [1] ( 9) // HSMC4 priority 15
    14 [1] "
    13 [1] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [1] ( 8) // DBGU priority 15
    06 [1] "
    05 [1] "
    04 [1] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 [1] (15) // USART 2 priority 15
    30 [1] "
    29 [1] "
    28 [1] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] (14) // USART 1 priority 3
    22 [0] "
    21 [1] "
    20 [1] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [0] (13) // USART 0 priority 3
    14 [0] "
    13 [1] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] (12) // Parallel IO Controller C priority 5
    06 [1] "
    05 [0] "
    04 [1] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 [1] (19) // TWI 1 priority 15
    30 [1] "
    29 [1] "
    28 [1] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] (18) // TWI 0 priority 2
    22 [0] "
    21 [1] "
    20 [0] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [1] (17) // Multimedia Card Interface priority 15
    14 [1] "
    13 [1] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [1] (16) // USART 3 priority 15
    06 [1] "
    05 [1] "
    04 [1] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 [0] (23) // Timer Counter 1 priority 4
    30 [1] "
    29 [0] "
    28 [0] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] (22) // Timer Counter 0 priority 0
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [1] (21) // Serial Synchronous Controller 0 priority 15
    14 [1] "
    13 [1] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] (20) // Serial Peripheral Interface priority 2
    06 [0] "
    05 [1] "
    04 [0] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 [1] (27) // 10-bit ADC Controller (ADC) priority 15
    30 [1] "
    29 [1] "
    28 [1] "

    27 [0] Unimplemented
    26 [0] "
    25 [0] "
    24 [0] "

    23 [1] (26) // 12-bit ADC Controller (ADC12B) priority 15
    22 [1] "
    21 [1] "
    20 [1] "

    19 [0] Unimplemented
    18 [0] "
    17 [0] "
    16 [0] "

    15 [1] (25) // Pulse Width Modulation Controller priority 15
    14 [1] "
    13 [1] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] (24) // Timer Counter 2 priority 4
    06 [1] "
    05 [0] "
    04 [0] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*!< Bit Set Description
    31 - 16 [0] Unimplemented

    15 [0] (29) // USB Device High Speed priority 1
    14 [0] "
    13 [0] "
    12 [1] "

    11 [0] Unimplemented
    10 [0] "
    09 [0] "
    08 [0] "

    07 [1] (28) // HDMA priority 15
    06 [1] "
    05 [1] "
    04 [1] "

    03 [0] Unimplemented
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*! @endcond */


/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!*****************************************************************************
 * @file: core_cm3.h
 * @purpose CMSIS Cortex-M3 Core Peripheral Access Layer Header File
 * @version V1.10
 * @date    24. Feb. 2009
 *----------------------------------------------------------------------------
 *
 * Copyright (C) 2009 ARM Limited. All rights reserved.
 *
 * ARM Limited (ARM) is supplying this software for use with Cortex-Mx 
 * processor based microcontrollers.  This file can be freely distributed 
 * within development tools that are supporting such ARM based processors. 
 *
 * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
 * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 *
 *
 *  Lint configuration \n
 *  ----------------------- \n
 *
 *  The following Lint messages will be suppressed and not shown: \n
 *  \n
 *    --- Error 10: --- \n
 *    register uint32_t __regBasePri         __asm("basepri"); \n
 *    Error 10: Expecting ';' \n
 *     \n
 *    --- Error 530: --- \n
 *    return(__regBasePri); \n
 *    Warning 530: Symbol '__regBasePri' (line 264) not initialized \n
 *     \n
 *    --- Error 550: --- \n
 *      __regBasePri = (basePri & 0x1ff); \n
 *    } \n
 *    Warning 550: Symbol '__regBasePri' (line 271) not accessed \n
 *     \n
 *    --- Error 754: --- \n
 *    uint32_t RESERVED0[24]; \n
 *    Info 754: local structure member '<some, not used in the HAL>' (line 109, file ./cm3_core.h) not referenced \n
 *     \n
 *    --- Error 750: --- \n
 *    #define __CM3_CORE_H__ \n
 *    Info 750: local macro '__CM3_CORE_H__' (line 43, file./cm3_core.h) not referenced \n
 *     \n
 *    --- Error 528: --- \n
 *    static __INLINE void NVIC_DisableIRQ(uint32_t IRQn) \n
 *    Warning 528: Symbol 'NVIC_DisableIRQ(unsigned int)' (line 419, file ./cm3_core.h) not referenced \n
 *     \n
 *    --- Error 751: --- \n
 *    } InterruptType_Type; \n
 *    Info 751: local typedef 'InterruptType_Type' (line 170, file ./cm3_core.h) not referenced \n
 * \n
 * \n
 *    Note:  To re-enable a Message, insert a space before 'lint' * \n
 *
 */

/*lint -save */
/*lint -e10  */
/*lint -e530 */
/*lint -e550 */
/*lint -e754 */
/*lint -e750 */
/*lint -e528 */
/*lint -e751 */







/* stdint.h standard header */
/* Copyright 2003-2017 IAR Systems AB.  */

  #pragma system_include

/* ycheck.h internal checking header file. */
/* Copyright 2005-2017 IAR Systems AB. */

/* Note that there is no include guard for this header. This is intentional. */

  #pragma system_include

/* __AEABI_PORTABILITY_INTERNAL_LEVEL
 *
 * Note: Redefined each time ycheck.h is included, i.e. for each
 * system header, to ensure that ABI support could be turned off/on
 * individually for each file.
 *
 * Possible values for this preprocessor symbol:
 *
 * 0 - ABI portability mode is disabled.
 *
 * 1 - ABI portability mode (version 1) is enabled.
 *
 * All other values are reserved for future use.
 */




/* Fixed size types. These are all optional. */
  typedef signed char          int8_t;
  typedef unsigned char        uint8_t;

  typedef signed short int         int16_t;
  typedef unsigned short int       uint16_t;

  typedef signed int         int32_t;
  typedef unsigned int       uint32_t;

  typedef signed long long int         int64_t;
  typedef unsigned long long int       uint64_t;

/* Types capable of holding at least a certain number of bits.
   These are not optional for the sizes 8, 16, 32, 64. */
typedef signed char      int_least8_t;
typedef unsigned char    uint_least8_t;

typedef signed short int     int_least16_t;
typedef unsigned short int   uint_least16_t;

typedef signed int     int_least32_t;
typedef unsigned int   uint_least32_t;

/* This isn't really optional, but make it so for now. */
  typedef signed long long int   int_least64_t;
  typedef unsigned long long int uint_least64_t;

/* The fastest type holding at least a certain number of bits.
   These are not optional for the size 8, 16, 32, 64.
   For now, the 64 bit size is optional in IAR compilers. */
typedef signed int       int_fast8_t;
typedef unsigned int     uint_fast8_t;

typedef signed int      int_fast16_t;
typedef unsigned int    uint_fast16_t;

typedef signed int      int_fast32_t;
typedef unsigned int    uint_fast32_t;

  typedef signed long long int    int_fast64_t;
  typedef unsigned long long int  uint_fast64_t;

/* The integer type capable of holding the largest number of bits. */
typedef signed long long int          intmax_t;
typedef unsigned long long int        uintmax_t;

/* An integer type large enough to be able to hold a pointer.
   This is optional, but always supported in IAR compilers. */
typedef signed int          intptr_t;
typedef unsigned int        uintptr_t;

/* An integer capable of holding a pointer to a specific memory type. */
typedef int __data_intptr_t; typedef unsigned int __data_uintptr_t;

/* Minimum and maximum limits. */






















/* Macros expanding to integer constants. */








/*
 * Copyright (c) by P.J. Plauger. All rights reserved.
 * Consult your license regarding permissions and restrictions.
V6.50:0576 */

/**************************************************
 *
 * This file declares the ARM intrinsic inline functions.
 *
 * Copyright 1999-2006 IAR Systems. All rights reserved.
 *
 * $Revision: 112221 $
 *
 **************************************************/



  #pragma system_include

/*
 * Check that the correct C compiler is used.
 */


/* Define function effects for intrinsics */


#pragma language=save
#pragma language=extended

__intrinsic __nounwind void    __no_operation(void);

__intrinsic __nounwind void    __disable_interrupt(void);
__intrinsic __nounwind void    __enable_interrupt(void);

typedef unsigned long __istate_t;

__intrinsic __nounwind __istate_t __get_interrupt_state(void);
__intrinsic __nounwind void __set_interrupt_state(__istate_t);


/* System control access for Cortex-M cores */
__intrinsic __nounwind unsigned long __get_PSR( void );
__intrinsic __nounwind unsigned long __get_IPSR( void );
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __get_MSP( void );
__intrinsic __nounwind void          __set_MSP( unsigned long );
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __get_PSP( void );
__intrinsic __nounwind void          __set_PSP( unsigned long );
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __get_PRIMASK( void );
__intrinsic __nounwind void          __set_PRIMASK( unsigned long );
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __get_CONTROL( void );
__intrinsic __nounwind void          __set_CONTROL( unsigned long );


/* These are only available for v7M */
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __get_FAULTMASK( void );
__intrinsic __nounwind void          __set_FAULTMASK(unsigned long);
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __get_BASEPRI( void );
__intrinsic __nounwind void          __set_BASEPRI( unsigned long );


__intrinsic __nounwind void __disable_fiq(void);
__intrinsic __nounwind void __enable_fiq(void);


/* ARM-mode intrinsics */

_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind unsigned long __SWP( unsigned long, volatile unsigned long * );
_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind unsigned char __SWPB( unsigned char, volatile unsigned char * );

typedef unsigned long __ul;


/*  Co-processor operations */

_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind void __CDP (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) opc1, unsigned __constrange(0,15) CRd, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind void __CDP2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) opc1, unsigned __constrange(0,15) CRd, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;

/*  Co-processor access */
__intrinsic __nounwind void          __MCR( unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opcode_1, __ul src,
                                 unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opcode_2 )  ;
__intrinsic __nounwind unsigned long __MRC( unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opcode_1,
                                 unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opcode_2 )  ;
__intrinsic __nounwind void          __MCR2( unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opcode_1, __ul src,
                                  unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opcode_2 ) ;
__intrinsic __nounwind unsigned long __MRC2( unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opcode_1,
                                  unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opcode_2 ) ;

__intrinsic __nounwind void __MCRR (unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned long long src, unsigned __constrange(0,15) CRm) ;
__intrinsic __nounwind void __MCRR2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned long long src, unsigned __constrange(0,15) CRm) ;

__intrinsic __nounwind unsigned long long __MRRC (unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned __constrange(0,15) CRm) ;
__intrinsic __nounwind unsigned long long __MRRC2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned __constrange(0,15) CRm) ;

/* Load coprocessor register. */
__intrinsic __nounwind void __LDC  ( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src) ;
__intrinsic __nounwind void __LDCL ( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src) ;
__intrinsic __nounwind void __LDC2 ( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src) ;
__intrinsic __nounwind void __LDC2L( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src) ;

/* Store coprocessor register. */
__intrinsic __nounwind void __STC  ( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst) ;
__intrinsic __nounwind void __STCL ( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst) ;
__intrinsic __nounwind void __STC2 ( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst) ;
__intrinsic __nounwind void __STC2L( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst) ;

/* Load coprocessor register (noindexed version with coprocessor option). */
__intrinsic __nounwind void __LDC_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src,
                              unsigned __constrange(0,255) option);

__intrinsic __nounwind void __LDCL_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src,
                               unsigned __constrange(0,255) option);

__intrinsic __nounwind void __LDC2_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src,
                               unsigned __constrange(0,255) option);

__intrinsic __nounwind void __LDC2L_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul const *src,
                                unsigned __constrange(0,255) option);

/* Store coprocessor register (version with coprocessor option). */
__intrinsic __nounwind void __STC_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst,
                              unsigned __constrange(0,255) option);

__intrinsic __nounwind void __STCL_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst,
                               unsigned __constrange(0,255) option);

__intrinsic __nounwind void __STC2_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst,
                               unsigned __constrange(0,255) option);

__intrinsic __nounwind void __STC2L_noidx( unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRn, volatile __ul *dst,
                                unsigned __constrange(0,255) option);


/* Reads a system register */
__intrinsic __nounwind unsigned long      __arm_rsr(__spec_string const char * special_register)   ;
__intrinsic __nounwind unsigned long long __arm_rsr64(__spec_string const char * special_register) ;
__intrinsic __nounwind void*              __arm_rsrp(__spec_string const char * special_register)  ;

/* Writes a system register */
__intrinsic __nounwind void __arm_wsr(__spec_string const char * special_register, unsigned long value)        ;
__intrinsic __nounwind void __arm_wsr64(__spec_string const char * special_register, unsigned long long value) ;
__intrinsic __nounwind void __arm_wsrp(__spec_string const char * special_register, const void *value)         ;

/* Co-processor intrinsics, ACLE-style */
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind void __arm_cdp (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) opc1, unsigned __constrange(0,15) CRd, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind void __arm_cdp2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) opc1, unsigned __constrange(0,15) CRd, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;

__intrinsic __nounwind void __arm_ldc  (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;
__intrinsic __nounwind void __arm_ldcl (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;
__intrinsic __nounwind void __arm_ldc2 (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;
__intrinsic __nounwind void __arm_ldc2l(unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;

__intrinsic __nounwind void __arm_stc  (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;
__intrinsic __nounwind void __arm_stcl (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;
__intrinsic __nounwind void __arm_stc2 (unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;
__intrinsic __nounwind void __arm_stc2l(unsigned __constrange(0,15) coproc, unsigned __constrange(0,15) CRd, const void* p) ;

__intrinsic __nounwind void __arm_mcr (unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, __ul src, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;
__intrinsic __nounwind void __arm_mcr2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, __ul src, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;

__intrinsic __nounwind unsigned long __arm_mrc (unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;
__intrinsic __nounwind unsigned long __arm_mrc2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned __constrange(0,15) CRn, unsigned __constrange(0,15) CRm, unsigned __constrange(0,8) opc2) ;

__intrinsic __nounwind void __arm_mcrr (unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned long long src, unsigned __constrange(0,15) CRm) ;
__intrinsic __nounwind void __arm_mcrr2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned long long src, unsigned __constrange(0,15) CRm) ;

__intrinsic __nounwind unsigned long long __arm_mrrc (unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned __constrange(0,15) CRm) ;
__intrinsic __nounwind unsigned long long __arm_mrrc2(unsigned __constrange(0,15) coproc, unsigned __constrange(0,8) opc1, unsigned __constrange(0,15) CRm) ;

/* Status register access, v7M: */
__intrinsic __nounwind unsigned long __get_APSR( void );
__intrinsic __nounwind void          __set_APSR( unsigned long );

/* Floating-point status and control register access */
__intrinsic __nounwind unsigned long __get_FPSCR( void );
__intrinsic __nounwind void __set_FPSCR( unsigned long );

/* Architecture v5T, CLZ is also available in Thumb mode for Thumb2 cores */
_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind unsigned char __CLZ( unsigned long );

/* Architecture v5TE */

_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind int         __QCFlag( void );
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind void __reset_QC_flag( void );

_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind signed long __SMUL( signed short, signed short );

/* Architecture v6, REV and REVSH are also available in thumb mode */
_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind unsigned long __REV( unsigned long );
_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind signed long __REVSH( short );

_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind unsigned long __REV16( unsigned long );
_Pragma("function_effects = no_state, always_returns") __intrinsic __nounwind unsigned long __RBIT( unsigned long );

_Pragma("function_effects = no_state, no_write(1), always_returns") __intrinsic __nounwind unsigned char  __LDREXB( volatile unsigned char const * );
_Pragma("function_effects = no_state, no_write(1), always_returns") __intrinsic __nounwind unsigned short __LDREXH( volatile unsigned short const * );
_Pragma("function_effects = no_state, no_write(1), always_returns") __intrinsic __nounwind unsigned long  __LDREX ( volatile unsigned long const * );
_Pragma("function_effects = no_state, no_write(1), always_returns") __intrinsic __nounwind unsigned long long __LDREXD( volatile unsigned long long const * );

_Pragma("function_effects = no_state, no_read(2), always_returns") __intrinsic __nounwind unsigned long  __STREXB( unsigned char, volatile unsigned char * );
_Pragma("function_effects = no_state, no_read(2), always_returns") __intrinsic __nounwind unsigned long  __STREXH( unsigned short, volatile unsigned short * );
_Pragma("function_effects = no_state, no_read(2), always_returns") __intrinsic __nounwind unsigned long  __STREX ( unsigned long, volatile unsigned long * );
_Pragma("function_effects = no_state, no_read(2), always_returns") __intrinsic __nounwind unsigned long  __STREXD( unsigned long long, volatile unsigned long long * );

__intrinsic __nounwind void __CLREX( void );

__intrinsic __nounwind void __SEV( void );
__intrinsic __nounwind void __WFE( void );
__intrinsic __nounwind void __WFI( void );
__intrinsic __nounwind void __YIELD( void );

__intrinsic __nounwind void __PLI( volatile void const * );
__intrinsic __nounwind void __PLD( volatile void const * );
__intrinsic __nounwind void __PLDW( volatile void const * );

_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind   signed long __SSAT     (unsigned long val,
                                      unsigned int __constrange( 1, 32 ) sat );
_Pragma("function_effects = hidden_state, always_returns") __intrinsic __nounwind unsigned long __USAT     (unsigned long val,
                                      unsigned int __constrange( 0, 31 ) sat );



/* Architecture v7 instructions */
__intrinsic __nounwind void __DMB(void);
__intrinsic __nounwind void __DSB(void);
__intrinsic __nounwind void __ISB(void);

/* Architecture v8-M instructions */
__intrinsic __nounwind unsigned long __TT(unsigned long);
__intrinsic __nounwind unsigned long __TTT(unsigned long);
__intrinsic __nounwind unsigned long __TTA(unsigned long);
__intrinsic __nounwind unsigned long __TTAT(unsigned long);


__intrinsic __nounwind unsigned long __get_LR(void);
__intrinsic __nounwind void __set_LR(unsigned long);

__intrinsic __nounwind unsigned long __get_SP(void);
__intrinsic __nounwind void __set_SP(unsigned long);

#pragma language=restore









/**
 * IO definitions
 *
 * define access restrictions to peripheral registers
 */




/*******************************************************************************
 *                 Register Abstraction
 ******************************************************************************/


/* System Reset */

/* Core Debug */




/* memory mapping struct for Nested Vectored Interrupt Controller (NVIC) */
typedef struct
{
  volatile uint32_t ISER[8];                      /*!< Interrupt Set Enable Register            */
       uint32_t RESERVED0[24];
  volatile uint32_t ICER[8];                      /*!< Interrupt Clear Enable Register          */
       uint32_t RSERVED1[24];
  volatile uint32_t ISPR[8];                      /*!< Interrupt Set Pending Register           */
       uint32_t RESERVED2[24];
  volatile uint32_t ICPR[8];                      /*!< Interrupt Clear Pending Register         */
       uint32_t RESERVED3[24];
  volatile uint32_t IABR[8];                      /*!< Interrupt Active bit Register            */
       uint32_t RESERVED4[56];
  volatile uint8_t  IP[240];                      /*!< Interrupt Priority Register, 8Bit wide   */
       uint32_t RESERVED5[644];
  volatile  uint32_t STIR;                         /*!< Software Trigger Interrupt Register      */
}  NVIC_Type;


/* memory mapping struct for System Control Block */
typedef struct
{
  volatile const  uint32_t CPUID;                        /*!< CPU ID Base Register                                     */
  volatile uint32_t ICSR;                         /*!< Interrupt Control State Register                         */
  volatile uint32_t VTOR;                         /*!< Vector Table Offset Register                             */
  volatile uint32_t AIRCR;                        /*!< Application Interrupt / Reset Control Register           */
  volatile uint32_t SCR;                          /*!< System Control Register                                  */
  volatile uint32_t CCR;                          /*!< Configuration Control Register                           */
  volatile uint8_t  SHP[12];                      /*!< System Handlers Priority Registers (4-7, 8-11, 12-15)    */
  volatile uint32_t SHCSR;                        /*!< System Handler Control and State Register                */
  volatile uint32_t CFSR;                         /*!< Configurable Fault Status Register                       */
  volatile uint32_t HFSR;                         /*!< Hard Fault Status Register                               */
  volatile uint32_t DFSR;                         /*!< Debug Fault Status Register                              */
  volatile uint32_t MMFAR;                        /*!< Mem Manage Address Register                              */
  volatile uint32_t BFAR;                         /*!< Bus Fault Address Register                               */
  volatile uint32_t AFSR;                         /*!< Auxiliary Fault Status Register                          */
  volatile const  uint32_t PFR[2];                       /*!< Processor Feature Register                               */
  volatile const  uint32_t DFR;                          /*!< Debug Feature Register                                   */
  volatile const  uint32_t ADR;                          /*!< Auxiliary Feature Register                               */
  volatile const  uint32_t MMFR[4];                      /*!< Memory Model Feature Register                            */
  volatile const  uint32_t ISAR[5];                      /*!< ISA Feature Register                                     */
} SCB_Type;


/* memory mapping struct for SysTick */
typedef struct
{
  volatile uint32_t CTRL;                         /*!< SysTick Control and Status Register */
  volatile uint32_t LOAD;                         /*!< SysTick Reload Value Register       */
  volatile uint32_t VAL;                          /*!< SysTick Current Value Register      */
  volatile const  uint32_t CALIB;                        /*!< SysTick Calibration Register        */
} SysTick_Type;


/* memory mapping structur for ITM */
typedef struct
{
  volatile  union  
  {
    volatile  uint8_t    u8;                       /*!< ITM Stimulus Port 8-bit               */
    volatile  uint16_t   u16;                      /*!< ITM Stimulus Port 16-bit              */
    volatile  uint32_t   u32;                      /*!< ITM Stimulus Port 32-bit              */
  }  PORT [32];                               /*!< ITM Stimulus Port Registers           */
       uint32_t RESERVED0[864];
  volatile uint32_t TER;                          /*!< ITM Trace Enable Register             */
       uint32_t RESERVED1[15];
  volatile uint32_t TPR;                          /*!< ITM Trace Privilege Register          */
       uint32_t RESERVED2[15];
  volatile uint32_t TCR;                          /*!< ITM Trace Control Register            */
       uint32_t RESERVED3[29];
  volatile uint32_t IWR;                          /*!< ITM Integration Write Register        */
  volatile uint32_t IRR;                          /*!< ITM Integration Read Register         */
  volatile uint32_t IMCR;                         /*!< ITM Integration Mode Control Register */
       uint32_t RESERVED4[43];
  volatile uint32_t LAR;                          /*!< ITM Lock Access Register              */
  volatile uint32_t LSR;                          /*!< ITM Lock Status Register              */
       uint32_t RESERVED5[6];
  volatile const  uint32_t PID4;                         /*!< ITM Product ID Registers              */
  volatile const  uint32_t PID5;
  volatile const  uint32_t PID6;
  volatile const  uint32_t PID7;
  volatile const  uint32_t PID0;
  volatile const  uint32_t PID1;
  volatile const  uint32_t PID2;
  volatile const  uint32_t PID3;
  volatile const  uint32_t CID0;
  volatile const  uint32_t CID1;
  volatile const  uint32_t CID2;
  volatile const  uint32_t CID3;
} ITM_Type;


/* memory mapped struct for Interrupt Type */
typedef struct
{
       uint32_t RESERVED0;
  volatile const  uint32_t ICTR;                         /*!< Interrupt Control Type Register  */
       uint32_t RESERVED1;
} InterruptType_Type;


/* Memory Protection Unit */


/* Core Debug Register */
typedef struct
{
  volatile uint32_t DHCSR;                        /*!< Debug Halting Control and Status Register       */
  volatile  uint32_t DCRSR;                        /*!< Debug Core Register Selector Register           */
  volatile uint32_t DCRDR;                        /*!< Debug Core Register Data Register               */
  volatile uint32_t DEMCR;                        /*!< Debug Exception and Monitor Control Register    */
} CoreDebug_Type;


/* Memory mapping of Cortex-M3 Hardware */





/*******************************************************************************
 *                Hardware Abstraction Layer
 ******************************************************************************/





/* ###################  Compiler specific Intrinsics  ########################### */

/* IAR iccarm specific functions */


/**************************************************
 *
 * This file shall be included in appropriate CMSIS header
 * files, to provide required functions and intrinsics when
 * building with the IAR C/C++ Compiler for ARM (iccarm).
 *
 * Copyright 2011 IAR Systems. All rights reserved.
 *
 * $Revision: 112776 $
 *
 **************************************************/



#pragma system_include


/* Define compiler macros for CPU architecture, used in CMSIS 5.
 */

/* __NO_RETURN
 * Override for compiler macro used in CMSIS 5.
 */

/* __USED
 * Override for compiler macro used in CMSIS 5,
 * inform that a variable shall be retained in executable image. Code Example:
 *
 * __USED uint32_t const CMSIS_RTOS_API_Version = osCMSIS;
 */

/* __WEAK
 * Override for compiler macro used in CMSIS 5,
 * export a function or variable weakly to allow overwrites. Code Example:
 *
 * __WEAK void SystemInit(void)
 * {
 *   SystemCoreSetup();
 *   SystemCoreClockSetup();
 * }
 */

/* __ALIGNED
 * Override for compiler macro used in CMSIS 5,
 * minimum alignment for a variable. Code example:
 *
 *  uint32_t stack_space[0x100] __ALIGNED(8);
 */

/* __PACKED
 * Override for compiler macro used in CMSIS 5,
 * request smallest possible alignment. Code Example:
 *
 * struct __PACKED {
 *   uint8_t  len;
 *   uint8_t  type;
 *   uint16_t langid;
 * } desc_langid;
 */


#pragma diag_suppress=Pe940
#pragma diag_suppress=Pe177






static uint32_t __get_xPSR(void)
{
  return __get_PSR();   /* __get_PSR() intrinsic introduced in iccarm 6.20 */
}










static inline uint32_t __RRX(uint32_t value)
{
  uint32_t result;
  __asm("RRX %0, %1" : "=r"(result) : "r" (value) );
  return(result);
}

static inline uint8_t __LDRBT(volatile uint8_t *addr)
{
  uint32_t result;
  __asm("LDRBT %0, [%1]" : "=r" (result) : "r" (addr) : "memory" );
  return ((uint8_t) result);
}

static inline uint16_t __LDRHT(volatile uint16_t *addr)
{
  uint32_t result;
  __asm("LDRHT %0, [%1]" : "=r" (result) : "r" (addr) : "memory" );
  return ((uint16_t) result);
}

static inline uint32_t __LDRT(volatile uint32_t *addr)
{
  uint32_t result;
  __asm("LDRT %0, [%1]" : "=r" (result) : "r" (addr) : "memory" );
  return(result);
}

static inline void __STRBT(uint8_t value, volatile uint8_t *addr)
{
  __asm("STRBT %1, [%0]" : : "r" (addr), "r" ((uint32_t)value) : "memory" );
}

static inline void __STRHT(uint16_t value, volatile uint16_t *addr)
{
  __asm("STRHT %1, [%0]" : : "r" (addr), "r" ((uint32_t)value) : "memory" );
}

static inline void __STRT(uint32_t value, volatile uint32_t *addr)
{
  __asm("STRT %1, [%0]" : : "r" (addr), "r" (value) : "memory" );
}



static inline uint32_t __ROR(uint32_t op1, uint32_t op2)
{
  return (op1 >> op2) | (op1 << ((sizeof(op1)*8)-op2));
}

#pragma diag_default=Pe940
#pragma diag_default=Pe177






/* ##########################   NVIC functions  #################################### */

/**
 * @brief  Set the Priority Grouping in NVIC Interrupt Controller
 *
 * @param  uint32_t priority_grouping is priority grouping field
 * @return  
 *
 * Set the priority grouping field using the required unlock sequence.
 * The parameter priority_grouping is assigned to the field 
 * SCB->AIRCR [10:8] PRIGROUP field.
 */
static inline void NVIC_SetPriorityGrouping(uint32_t priority_grouping)
{
  uint32_t reg_value=0;
  
  reg_value  = ((SCB_Type *) ((0xE000E000) + 0x0D00))->AIRCR;                                                                            /* read old register configuration    */
  reg_value &= ~((0xFFFFU << 16) | (0x0F << 8));                                                      /* clear bits to change               */
  reg_value  = ((reg_value | (0x5FA << 16) | (priority_grouping << 8)));                         /* Insert write key and priorty group */
  ((SCB_Type *) ((0xE000E000) + 0x0D00))->AIRCR = reg_value;
}

/**
 * @brief  Enable Interrupt in NVIC Interrupt Controller
 *
 * @param  IRQn_Type IRQn specifies the interrupt number
 * @return none 
 *
 * Enable a device specific interupt in the NVIC interrupt controller.
 * The interrupt number cannot be a negative value.
 */
static inline void NVIC_EnableIRQ(IRQn_Type IRQn)
{
  ((NVIC_Type *) ((0xE000E000) + 0x0100))->ISER[((uint32_t)(IRQn) >> 5)] = (1 << ((uint32_t)(IRQn) & 0x1F));                             /* enable interrupt */
}

/**
 * @brief  Disable the interrupt line for external interrupt specified
 * 
 * @param  IRQn_Type IRQn is the positive number of the external interrupt
 * @return  none
 * 
 * Disable a device specific interupt in the NVIC interrupt controller.
 * The interrupt number cannot be a negative value.
 */
static inline void NVIC_DisableIRQ(IRQn_Type IRQn)
{
  ((NVIC_Type *) ((0xE000E000) + 0x0100))->ICER[((uint32_t)(IRQn) >> 5)] = (1 << ((uint32_t)(IRQn) & 0x1F));                             /* disable interrupt */
}

/**
 * @brief  Read the interrupt pending bit for a device specific interrupt source
 * 
 * @param  IRQn_Type IRQn is the number of the device specifc interrupt
 * @return IRQn_Type Number of pending interrupt or zero
 *
 * Read the pending register in NVIC and return the number of the
 * specified interrupt if its status is pending, otherwise it returns 
 * zero. The interrupt number cannot be a negative value.
 */
static inline IRQn_Type NVIC_GetPendingIRQ(IRQn_Type IRQn)
{
  return((IRQn_Type) (((NVIC_Type *) ((0xE000E000) + 0x0100))->ISPR[(uint32_t)(IRQn) >> 5] & (1 << ((uint32_t)(IRQn) & 0x1F))));         /* Return Interrupt bit or 'zero' */
}

/**
 * @brief  Set the pending bit for an external interrupt
 * 
 * @param  IRQn_Type IRQn is the Number of the interrupt
 * @return  none
 *
 * Set the pending bit for the specified interrupt.
 * The interrupt number cannot be a negative value.
 */
static inline void NVIC_SetPendingIRQ(IRQn_Type IRQn)
{
  ((NVIC_Type *) ((0xE000E000) + 0x0100))->ISPR[((uint32_t)(IRQn) >> 5)] = (1 << ((uint32_t)(IRQn) & 0x1F));                             /* set interrupt pending */
}

/*!
 * @brief  Clear the pending bit for an external interrupt
 *
 * @param  IRQn_Type IRQn is the Number of the interrupt
 * @return  none
 *
 * Clear the pending bit for the specified interrupt. 
 * The interrupt number cannot be a negative value.
 */
static inline void NVIC_ClearPendingIRQ(IRQn_Type IRQn)
{
  ((NVIC_Type *) ((0xE000E000) + 0x0100))->ICPR[((uint32_t)(IRQn) >> 5)] = (1 << ((uint32_t)(IRQn) & 0x1F));                             /* Clear pending interrupt */
}

/**
 * @brief  Read the active bit for an external interrupt
 *
 * @param  IRQn_Type IRQn is the Number of the interrupt
 * @return IRQn_Type Number of pending interrupt or zero
 *
 * Read the active register in NVIC and returns the number of the
 * specified interrupt if its status is active, otherwise it 
 * returns zero. The interrupt number cannot be a negative value.
 */
static inline IRQn_Type NVIC_GetActive(IRQn_Type IRQn)
{
  return((IRQn_Type)(((NVIC_Type *) ((0xE000E000) + 0x0100))->IABR[(uint32_t)(IRQn) >> 5] & (1 << ((uint32_t)(IRQn) & 0x1F))));                        /* Return Interruptnumber or 'zero' */
}

/**
 * @brief  Set the priority for an interrupt
 *
 * @param  IRQn_Type IRQn is the Number of the interrupt
 * @param  priority is the priority for the interrupt
 * @return  none
 *
 * Set the priority for the specified interrupt. The interrupt 
 * number can be positive to specify an external (device specific) 
 * interrupt, or negative to specify an internal (core) interrupt. \n
 *
 * Note: The priority cannot be set for every core interrupt.
 */
static inline void NVIC_SetPriority(IRQn_Type IRQn, int32_t priority)
{
  if(IRQn < 0) {
    ((SCB_Type *) ((0xE000E000) + 0x0D00))->SHP[((uint32_t)(IRQn) & 0xF)-4] = ((priority << (8 - 4)) & 0xff); }  /* set Priority for Cortex-M3 System Interrupts */
  else {
    //NVIC->IP[(uint32_t)(IRQn)] = ((priority << (8 - __NVIC_PRIO_BITS)) & 0xff);    }         /* set Priority for device specific Interrupts      */
    ((NVIC_Type *) ((0xE000E000) + 0x0100))->IP[(uint32_t)(IRQn)] = (priority & 0xff);    }         /* set Priority for device specific Interrupts      */
}

/**
 * @brief  Read the priority for an interrupt
 *
 * @param  IRQn_Type IRQn is the Number of the interrupt
 * @return priority is the priority for the interrupt
 *
 * Read the priority for the specified interrupt. The interrupt 
 * number can be positive to specify an external (device specific) 
 * interrupt, or negative to specify an internal (core) interrupt.
 *
 * The returned priority value is automatically aligned to the implemented
 * priority bits of the microcontroller.
 *
 * Note: The priority cannot be set for every core interrupt.
 */
static inline uint32_t NVIC_GetPriority(IRQn_Type IRQn)
{

  if(IRQn < 0) {
    return((uint32_t)(((SCB_Type *) ((0xE000E000) + 0x0D00))->SHP[((uint32_t)(IRQn) & 0xF)-4] >> (8 - 4)));  }              /* get priority for Cortex-M3 system interrupts   */
  else {
    return((uint32_t)(((NVIC_Type *) ((0xE000E000) + 0x0100))->IP[(uint32_t)(IRQn)]           >> (8 - 4)));  }              /* get priority for device specific interrupts    */
}



/* ##################################    SysTick function  ############################################ */


/* SysTick constants */

/**
 * @brief  Initialize and start the SysTick counter and its interrupt.
 *
 * @param  uint32_t ticks is the number of ticks between two interrupts
 * @return  none
 *
 * Initialise the system tick timer and its interrupt and start the
 * system tick timer / counter in free running mode to generate 
 * periodical interrupts.
 */
static inline uint32_t SysTick_Config(uint32_t ticks)
{ 
  if (ticks > ((1<<24) -1))  return (1);                                                /* Reload value impossible */

  ((SysTick_Type *) ((0xE000E000) + 0x0010))->LOAD  =  (ticks & ((1<<24) -1)) - 1;                                         /* set reload register */
  NVIC_SetPriority (SysTick_IRQn, (1<<4) - 1);                               /* set Priority for Cortex-M0 System Interrupts */
  ((SysTick_Type *) ((0xE000E000) + 0x0010))->VAL   =  (0x00);                                                                 /* Load the SysTick Counter Value */
  ((SysTick_Type *) ((0xE000E000) + 0x0010))->CTRL = (1 << 2) | (1<<0) | (1<<1);    /* Enable SysTick IRQ and SysTick Timer */
  return (0);                                                                               /* Function successful */
}






/* ##################################    Reset function  ############################################ */

/**
 * @brief  Initiate a system reset request.
 *
 * @param   none
 * @return  none
 *
 * Initialize a system reset request to reset the MCU
 */
static inline void NVIC_SystemReset(void)
{
  ((SCB_Type *) ((0xE000E000) + 0x0D00))->AIRCR  = ((0x5FA << 16) | (((SCB_Type *) ((0xE000E000) + 0x0D00))->AIRCR & (0x700)) | (1<<2));      /* Keep priority group unchanged */
}


/* ##################################    Debug Output  function  ############################################ */


/**
 * @brief  Outputs a character via the ITM channel 0
 *
 * @param   uint32_t character to output
 * @return  uint32_t input character
 *
 * The function outputs a character via the ITM channel 0. 
 * The function returns when no debugger is connected that has booked the output.  
 * It is blocking when a debugger is connected, but the previous character send is not transmitted. 
 */
static inline uint32_t ITM_SendChar (uint32_t ch)
{
  if(ch == '\n') ITM_SendChar('\r');
  
  if ((((CoreDebug_Type *) (0xE000EDF0))->DEMCR & (1 << 24))  &&
      (((ITM_Type *) (0xE0000000))->TCR & 1)                  &&
      (((ITM_Type *) (0xE0000000))->TER & (1UL << 0))  ) 
  {
    while (((ITM_Type *) (0xE0000000))->PORT[0].u32 == 0);
    ((ITM_Type *) (0xE0000000))->PORT[0].u8 = (uint8_t) ch;
  }  
  return (ch);
}


/*lint -restore */
/*!**********************************************************************************************************************
@file main.h
@brief Header file for main.c.
***********************************************************************************************************************/


/*!**********************************************************************************************************************
Firmware Version - Printed FIRMWARE_MAIN_REV.FIRMWARE_SUB_REV1 FIRMWARE_SUB_REV2

FIRMWARE_MAIN_REV: should be updated only with RELEASES to Github.
FIRMWARE_SUB_REV1: should be updated when a pull request is made to the MASTER branch.
***********************************************************************************************************************/



/***********************************************************************************************************************
* Constant Definitions
***********************************************************************************************************************/

/* G_u32ApplicationFlags */
/* The order of these flags corresponds to the order of applications in SystemStatusReport() (debug.c) */
//#define _APPLICATION_FLAGS_USBCDC       0x00000080        /*!< @brief G_u32ApplicationFlags USBCDC StateMachine */

//#define _APPLICATION_FLAGS_SDCARD       0x00000100        /*!< @brief G_u32ApplicationFlags SdCardStateMachine */
/* end G_u32ApplicationFlags */





/* G_u32SystemFlags */


/* end G_u32SystemFlags */


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file typedefs.h                                                                
@brief Type definitions for use with the system.

The EiE system tries to simplify the most common variable types and remove ambiguity 
over type size or signed/unsigned.  
**********************************************************************************************************************/



/**********************************************************************************************************************
Type Definitions

The following are equivalent in this system:

Legacy C        Historical       stdint.h       EiE
unsigned char   UCHAR            uint8_t        u8
unsigned short  USHORT           uint16_t       u16
unsigned long   ULONG            uint32_t       u32
signed char     CHAR             int8_t         s8
signed short    SHORT            int16_t        s16
signed long     LONG             int32_t        s32

Custom types should be defined with "Type" as the last word in the typedef.
**********************************************************************************************************************/

/* CHAR/SHORT/LONG types here for legacy code compatibility */
/*! @cond DOXYGEN_EXCLUDE */
typedef char CHAR;              /* Signed 8-bits */
typedef unsigned char UCHAR;    /* Unsigned 8-bits */
typedef short SHORT;            /* Signed 16-bits */
typedef unsigned short USHORT;  /* Unsigned 16-bits */
typedef long LONG;              /* Signed 32-bits */
typedef unsigned long ULONG;    /* Unsigned 32-bits */
typedef unsigned char BOOL;     /* Boolean */
/*! @endcond */


/* Standard Peripheral Library old types (maintained for legacy purpose) */
typedef long s32;           /*!< @brief EiE standard variable type name for signed 32-bit variables */ 
typedef short s16;          /*!< @brief EiE standard variable type name for signed 16-bit variables */
typedef signed char  s8;    /*!< @brief EiE standard variable type name for signed  8-bit variables */

typedef const long sc32;    /*!< @brief EiE standard variable type name for read-only signed 32-bit variables */
typedef const short sc16;   /*!< @brief EiE standard variable type name for read-only signed 16-bit variables */
typedef const char sc8;     /*!< @brief EiE standard variable type name for read-only signed  8-bit variables */

typedef ULONG  u32;         /*!< @brief EiE standard variable type name for unsigned 32-bit variables */
typedef USHORT u16;         /*!< @brief EiE standard variable type name for unsigned 16-bit variables */
typedef UCHAR  u8;          /*!< @brief EiE standard variable type name for unsigned  8-bit variables */

typedef const ULONG uc32;   /*!< @brief EiE standard variable type name for read-only unsigned 32-bit variables */
typedef const USHORT uc16;  /*!< @brief EiE standard variable type name for read-only unsigned 32-bit variables */
typedef const USHORT uc8;   /*!< @brief EiE standard variable type name for read-only unsigned 32-bit variables */

typedef void(*fnCode_type)(void);      /*!< @brief EiE standard variable type name for function pointer with no arguments */
typedef void(*fnCode_u16_type)(u16 x); /*!< @brief EiE standard variable type name for function pointer with one u16 argument */

typedef enum {FALSE = 0, TRUE = !FALSE} bool;  /*!< @brief EiE standard variable type name for boolean */

/*! 
@enum PortOffsetType
@brief Processor-specific port address offsets.
*/
typedef enum {PORTA = 0, PORTB = 0x80} PortOffsetType;               

/*! 
@enum GpioActiveType
@brief Real names for active low vs. active high GPIO.
*/
typedef enum {ACTIVE_LOW = 0, ACTIVE_HIGH = 1} GpioActiveType;      

/*! 
@struct PinConfigurationType
@brief Parameters necessary to fully describe a GPIO line.
*/
typedef struct
{
  u32 u32BitPosition;             /*!< @brief Pin bit position within port */
  PortOffsetType ePort;           /*!< @brief Pin port */
  GpioActiveType eActiveState;    /*!< @brief Pin hardware active type */
}PinConfigurationType;

/*! 
@struct ErrorStatus
@brief Standarized, self-documenting error codes.
*/
typedef enum {ERROR = 0, SUCCESS = !ERROR} ErrorStatus;



/*!**********************************************************************************************************************
@file utilities.h    

@brief Header file for utilities.c.

***********************************************************************************************************************/


/***********************************************************************************************************************
Type Definitions
***********************************************************************************************************************/


/***********************************************************************************************************************
Constants / Definitions
***********************************************************************************************************************/


/* Terminal escape sequences 
("\033" converts to the single control character Esc (0x1B) 
*/











/***********************************************************************************************************************
* Function Declarations
***********************************************************************************************************************/

/*--------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/

bool IsTimeUp(u32 *pu32SavedTick_, u32 u32Period_);

u8 ASCIIHexCharToNum(u8);
u8 HexToASCIICharUpper(u8 u8Char_);
u8 HexToASCIICharLower(u8 u8Char_);
u8 NumberToAscii(u32 u32Number_, u8* pu8AsciiString_);
bool SearchString(u8* pu8TargetString_, u8* pu8MatchString_);


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/

/* EIEF1-PCB-01 specific header files */
/*!**********************************************************************************************************************
@file eief1-pcb-01.h                                                                
@brief This file provides header information for the eief1-pcb-01 board.
***********************************************************************************************************************/


/*! @cond DOXYGEN_EXCLUDE */
/***********************************************************************************************************************
Perihperal Setup Initializations

Bookmarks:
&&&&& Function Declarations
!!!!! GPIO pin names
@@@@@ Watchdog, Power Control, Clock, and Systick setup values
##### GPIO initial setup values
$$$$$ PWM setup values
%%%%% Template register settings

***********************************************************************************************************************/
/*! @endcond */


/***********************************************************************************************************************
Type Definitions
***********************************************************************************************************************/

/*----------------------------------------------------------------------------------------------------------------------
%LED% LED Configuration                                                                                                  
----------------------------------------------------------------------------------------------------------------------*/
/*! 
@enum LedNameType
@brief Logical names for LEDs in the system.

The order of the LEDs in LedNameType must match the order of the definition 
in G_asBspLedConfigurations Led_au32BitPositions from eief1-pcb-01.c 
*/
typedef enum {WHITE = 0, PURPLE, BLUE, CYAN, GREEN, YELLOW, ORANGE, RED, LCD_RED, LCD_GREEN, LCD_BLUE} LedNameType;



/*----------------------------------------------------------------------------------------------------------------------
%BUTTON% Button Configuration                                                                                                  
----------------------------------------------------------------------------------------------------------------------*/
/*! 
@enum ButtonNameType
@brief Logical names for buttons in the system.

The order of the buttons in ButtonNameType must match the order of the definition 
in G_asBspButtonConfigurations Buttons_au32BitPositions from eief1-pcb-01.c 
*/
typedef enum {BUTTON0 = 0, BUTTON1, BUTTON2, BUTTON3, NOBUTTON} ButtonNameType;


/*! All buttons on each port must be ORed together here: set to 0 if no buttons on the port */


/*----------------------------------------------------------------------------------------------------------------------
%BUZZER% Buzzer Configuration                                                                                                  
----------------------------------------------------------------------------------------------------------------------*/
/*! 
@enum BuzzerChannelType
@brief Logical names for buzzers in the system.

These definitions correspond to the Channel ID in the PWM peripheral 
*/
typedef enum {BUZZER1 = (0x1 << 0), BUZZER2=(0x1 << 1)} BuzzerChannelType;


/*----------------------------------------------------------------------------------------------------------------------
%ADC% Analog input channel Configuration                                                                                                  
----------------------------------------------------------------------------------------------------------------------*/



/*----------------------------------------------------------------------------------------------------------------------
%ANT% Interface Configuration                                                                                                  
----------------------------------------------------------------------------------------------------------------------*/







/***********************************************************************************************************************
* Constants
***********************************************************************************************************************/

/*!@brief To get 1 ms tick, need SYSTICK_COUNT to be 0.001 * SysTick Clock.  
Should be 6000 for 48MHz CCLK. */


/***********************************************************************************************************************
* Macros
***********************************************************************************************************************/


/***********************************************************************************************************************
&&&&& Function Declarations
***********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void PWMAudioSetFrequency(BuzzerChannelType eChannel_, u16 u16Frequency_);
void PWMAudioOn(BuzzerChannelType eBuzzerChannel_);
void PWMAudioOff(BuzzerChannelType eBuzzerChannel_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void WatchDogSetup(void);
void ClockSetup(void);
void GpioSetup(void);

void SysTickSetup(void);
void SystemTimeCheck(void);
void SystemSleep(void);

void PWMSetupAudio(void);


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
!!!!! GPIO pin names
***********************************************************************************************************************/
/* Hardware Definition for PCB EIEF1-PCB-01 */

/* Port A bit positions */


/* Port B bit positions */


/*! @cond DOXYGEN_EXCLUDE */

/***********************************************************************************************************************
@@@@@ Watchdog, Power Control, Clock, and Systick setup values
***********************************************************************************************************************/
/* Watch Dog Values
The watchdog oscillator is on the internal 32k RC with a 128 prescaler = 3.9ms / tick.  
For a minimum 5 second watchdog timeout, the watchdog
counter must be set at 1280. */

/*
    31 [0] Reserved
    30 [0] "
    29 [0] WDIDLEHLT Watchdog runs when system is idle
    28 [1] WDDBGHLT Watchdog stops in debug state

    27 [1] WDD Watchdog delta value (allow resets any time)
    26 [1] "
    25 [1] "
    24 [1] "

    23 [1] "
    22 [1] "
    21 [1] "
    20 [1] "

    19 [1] "
    18 [1] "
    17 [1] "
    16 [1] "

    15 [0] WDDIS Watchdog is not disabled
    14 [1] WDRPROC watchdog reset processor on
    13 [1] WDRSTEN Watchdog reset enable on
    12 [0] WDFIEN Watchdog fault interrupt enable off

    11 [0] WDV Watchdog counter value: 0x500 = 1280 x (128 x 1/32768) = 5 seconds
    10 [1] "
    09 [0] "
    08 [1] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] "
*/


/*
    31 [1] Key
    30 [0] " 
    29 [1] "
    28 [0] "

    27 [0] "
    26 [1] "
    25 [0] "
    24 [1] "

    23 - 04 [0] Reserved

    03 [0] Reserved
    02 [0] "
    01 [0] "
    00 [1] WDRSTT Restart watchdog
*/


/*
    31 [0] Reserved
    30 [0] "
    29 [1] AT91C_ID_UDPHS  USB Device High Speed clock enabled
    28 [0] AT91C_ID_HDMA   HDMA

    27 [0] AT91C_ID_ADC    10-bit ADC Controller (ADC) not enabled
    26 [1] AT91C_ID_ADC12B 12-bit ADC Controller (ADC12B) clock enabled
    25 [1] AT91C_ID_PWMC   Pulse Width Modulation Controller clock enabled
    24 [1] AT91C_ID_TC2    Timer Counter 2 clock enabled

    23 [1] AT91C_ID_TC1    Timer Counter 1 clock enabled
    22 [1] AT91C_ID_TC0    Timer Counter 0 clock enabled
    21 [1] AT91C_ID_SSC0   Serial Synchronous Controller 0 clock enabled
    20 [1] AT91C_ID_SPI0   Serial Peripheral Interface clock enabled

    19 [1] AT91C_ID_TWI1   TWI 1 clock enabled
    18 [1] AT91C_ID_TWI0   TWI 0 clock enabled
    17 [0] AT91C_ID_MCI0   Multimedia Card Interface not enabled
    16 [0] AT91C_ID_US3    USART 3 not enabled

    15 [1] AT91C_ID_US2    USART 2 clock enabled
    14 [1] AT91C_ID_US1    USART 1 clock enabled
    13 [1] AT91C_ID_US0    USART 0 clock enabled
    12 [0] AT91C_ID_PIOC   Parallel IO Controller C  not enabled

    11 [1] AT91C_ID_PIOB   Parallel IO Controller B clock enabled
    10 [1] AT91C_ID_PIOA   Parallel IO Controller A clock enabled
    09 [0] AT91C_ID_HSMC4  HSMC4 not enabled
    08 [1] AT91C_ID_DBGU   DBGU (standalone UART) clock enabled

    07 [0] AT91C_ID_EFC1   EFC1 not enabled
    06 [1] AT91C_ID_EFC0   EFC0 clock enabled
    05 [1] AT91C_ID_PMC    PMC clock enabled
    04 [1] AT91C_ID_WDG    WATCHDOG TIMER clock enabled

    03 [0] AT91C_ID_RTT    REAL TIME TIMER not enabled
    02 [0] AT91C_ID_RTC    REAL TIME CLOCK not enabled
    01 [1] AT91C_ID_RSTC   RESET CONTROLLER clock enabled
    00 [1] AT91C_ID_SUPC   SUPPLY CONTROLLER clock enabled
*/


/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] CFDEN clock failure detector disabled
    24 [0] MOSCSEL internal main oscillator selected for now

    23 [0] KEY 0x37
    22 [0] "
    21 [1] "
    20 [1] "

    19 [0] "
    18 [1] "
    17 [1] "
    16 [1] "

    15 [1] MOSCXTST main crystal start-up time (based on 8 x the slow clock frequency)
    14 [1] "
    13 [1] "
    12 [1] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] Reserved
    06 [0] MOSCRCF 8MHz
    05 [0] "
    04 [1] "

    03 [1] MOSCRCEN main on-chip RC osc is on for now
    02 [0] WAITMODE disabled
    01 [0] MOSCXTBY main crystal osc is not bypassed
    00 [1] MOSCXTEN main crystal osc is enabled
*/


/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] "
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] "
    18 [0] "
    17 [0] "
    16 [0] "

    15 [0] "
    14 [0] "
    13 [1] UPLLDIV UPLL divided by 2 
    12 [0] Reserved 

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] PRES processor clock prescaler selected clock divided by 2
    05 [0] 
    04 [1] 

    03 [0] 
    02 [0] 
    01 [0] CSS Master clock selection MAIN_CLK for now
    00 [1] 
*/



/* The PLL DIVA and MULA coefficients set the PLLA output frequency.
The PLLA input frequency must be between 8 and 16 MHz so with 12MHz clock, DIVA must be 1.
Since we want PLLACK at 96 MHz:
(96 MHZ * DIVA / 12 MHz) - 1 = MULA = 7
*/

/* Bit Set Description
    31 [0] Reserved
    30 [0] "
    29 [1] Always 1
    28 [0] "

    27 [0] "
    26 [0] MULA
    25 [0] "
    24 [0] "


    23 [0] "
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] "
    18 [1] "
    17 [1] "
    16 [1] "

    15 [0] Reserved
    14 [0] "
    13 [1] PLLACOUNT
    12 [1] "

    11 [1] "
    10 [1] "
    09 [1] "
    08 [1] "

    07 [0] DIVA
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [1] "
*/


/* Bit Set Description
    31:20 Reserved 

    19 [0] Reserved
    18 [0] "
    17 [0] "
    16 [0] Countflag (read only)

    15 [0] Reserved
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] Clock source is CPU clock / 8
    01 [1] System tick interrupt on 
    00 [1] System tick is enabled 
*/


/***********************************************************************************************************************
##### GPIO setup values
***********************************************************************************************************************/

/* PIO Enable Register: 
0: No effect
1: Pin is controlled by PIO
*/
/* 
    31 [1] PA_31_HEARTBEAT PIO control enabled
    30 [0] PA_30_AN_DEMO PIO control not enabled
    29 [0] PA_29_BUZZER2 PIO control not enabled
    28 [0] PA_28_BUZZER1 PIO control not enabled

    27 [0] PA_27_CLOCK_OUT PIO control not enabled
    26 [1] PA_26_ANT_PWR_EN PIO control enabled
    25 [0] PA_25_ANT_USPI2_SCK PIO control not enabled
    24 [0] PA_24_SD_USPI1_SCK PIO control not enabled

    23 [0] PA_23_ANT_USPI2_MOSI PIO control not enabled
    22 [0] PA_22_ANT_USPI2_MISO PIO control not enabled
    21 [0] PA_21_SD_USPI1_MISO PIO control not enabled
    20 [0] PA_20_SD_USPI1_MOSI PIO control not enabled

    19 [0] PA_19_DEBUG_U0_PIMO PIO control not enabled
    18 [0] PA_18_DEBUG_U0_POMI PIO control not enabled
    17 [1] PA_17_BUTTON0 PIO control enabled
    16 [1] PA_16_BLADE_CS PIO control enabled

    15 [0] PA_15_BLADE_SCK PIO control not enabled
    14 [0] PA_14_BLADE_MOSI PIO control not enabled
    13 [0] PA_13_BLADE_MISO PIO control not enabled
    12 [0] PA_12_BLADE_UPOMI PIO control not enabled

    11 [0] PA_11_BLADE_UPIMO PIO control not enabled
    10 [0] PA_10_I2C_SCL PIO control not enabled
    09 [0] PA_09_I2C_SDA PIO control not enabled
    08 [0] PA_08_SD_CS_MCDA3 PIO control not enabled

    07 [0] PA_07_HSMCI_MCDA2 PIO control not enabled
    06 [0] PA_06_HSMCI_MCDA1 PIO control not enabled
    05 [0] PA_05_HSMCI_MCDA0 PIO control not enabled
    04 [0] PA_04_HSMCI_MCCDA PIO control not enabled

    03 [0] PA_03_HSMCI_MCCK PIO control not enabled
    02 [1] PA_02_SD_DETECT PIO control enabled
    01 [1] PA_01_SD_WP PIO control enabled
    00 [1] PA_00_TP54 PIO control enabled
*/

/*
    31 [0] PB_31_ PIO control not enabled
    30 [0] PB_30_ PIO control not enabled
    29 [0] PB_29_ PIO control not enabled
    28 [0] PB_28_ PIO control not enabled

    27 [0] PB_27_ PIO control not enabled
    26 [0] PB_26_ PIO control not enabled
    25 [0] PB_25_ PIO control not enabled
    24 [1] PB_24_ANT_SRDY PIO control enabled

    23 [1] PB_23_ANT_MRDY PIO control enabled
    22 [0] PB_22_ANT_USPI2_CS PIO control not enabled
    21 [1] PB_21_ANT_RESET PIO control enabled
    20 [1] PB_20_LED_RED PIO control enabled

    19 [1] PB_19_LED_GRN PIO control enabled
    18 [1] PB_18_LED_BLU PIO control enabled
    17 [1] PB_17_LED_YLW PIO control enabled
    16 [1] PB_16_LED_CYN PIO control enabled

    15 [1] PB_15_LED_ORG PIO control enabled
    14 [1] PB_14_LED_PRP PIO control enabled
    13 [1] PB_13_LED_WHT PIO control enabled
    12 [1] PB_12_LCD_BL_BLU PIO control enabled

    11 [1] PB_11_LCD_BL_GRN PIO control enabled
    10 [1] PB_10_LCD_BL_RED PIO control enabled
    09 [1] PB_09_LCD_RST PIO control enabled
    08 [1] PB_08_TP62 PIO control enabled

    07 [1] PB_07_TP60 PIO control enabled
    06 [0] PB_06_TP58 PIO control not enabled
    05 [1] PB_05_TP56 PIO control enabled
    04 [0] PB_04_BLADE_AN1 PIO control not enabled

    03 [0] PB_03_BLADE_AN0 PIO control not enabled
    02 [1] PB_02_BUTTON3 PIO control enabled
    01 [1] PB_01_BUTTON2 PIO control enabled
    00 [1] PB_00_BUTTON1 PIO control enabled
*/

/* PIO Controller Output Enable Register
Configures the pin as an output or input.
0: No effect
1: Enables the output on the I/O line
*/
/* 
    31 [1] PA_31_HEARTBEAT output enabled
    30 [0] PA_30_AN_DEMO input
    29 [0] PA_29_BUZZER2 output peripheral
    28 [0] PA_28_BUZZER1 output peripheral

    27 [0] PA_27_CLOCK_OUT output peripheral
    26 [1] PA_26_ANT_PWR_EN output enabled
    25 [0] PA_25_ANT_USPI2_SCK output peripheral
    24 [0] PA_24_SD_USPI1_SCK output peripheral

    23 [0] PA_23_ANT_USPI2_MOSI input
    22 [0] PA_22_ANT_USPI2_MISO output peripheral
    21 [0] PA_21_SD_USPI1_MISO input input
    20 [0] PA_20_SD_USPI1_MOSI output peripheral

    19 [0] PA_19_DEBUG_U0_PIMO input
    18 [0] PA_18_DEBUG_U0_POMI output peripheral
    17 [0] PA_17_BUTTON0 input
    16 [1] PA_16_BLADE_CS output enabled

    15 [0] PA_15_BLADE_SCK output peripheral
    14 [0] PA_14_BLADE_MOSI output peripheral
    13 [0] PA_13_BLADE_MISO input
    12 [0] PA_12_BLADE_UPOMI output peripheral

    11 [0] PA_11_BLADE_UPIMO input
    10 [0] PA_10_I2C_SCL output peripheral
    09 [0] PA_09_I2C_SDA output peripheral
    08 [0] PA_08_SD_CS_MCDA3 output peripheral

    07 [0] PA_07_HSMCI_MCDA2 output peripheral
    06 [0] PA_06_HSMCI_MCDA1 output peripheral
    05 [0] PA_05_HSMCI_MCDA0 output peripheral
    04 [0] PA_04_HSMCI_MCCDA output peripheral

    03 [0] PA_03_HSMCI_MCCK output peripheral
    02 [0] PA_02_SD_DETECT input
    01 [0] PA_01_SD_WP input
    00 [1] PA_00_TP54 output enabled
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [1] PB_24_ANT_SRDY output enabled

    23 [1] PB_23_ANT_MRDY output enabled
    22 [0] PB_22_ANT_USPI2_CS
    21 [1] PB_21_ANT_RESET output enabled
    20 [1] PB_20_LED_RED output enabled

    19 [1] PB_19_LED_GRN output enabled
    18 [1] PB_18_LED_BLU output enabled
    17 [1] PB_17_LED_YLW output enabled
    16 [1] PB_16_LED_CYN output enabled

    15 [1] PB_15_LED_ORG output enabled
    14 [1] PB_14_LED_PRP output enabled
    13 [1] PB_13_LED_WHT output enabled
    12 [1] PB_12_LCD_BL_BLU output enabled

    11 [1] PB_11_LCD_BL_GRN output enabled
    10 [1] PB_10_LCD_BL_RED output enabled
    09 [1] PB_09_LCD_RST output enabled
    08 [1] PB_08_TP62 output enabled

    07 [1] PB_07_TP60 output enabled
    06 [1] PB_06_TP58 output enabled
    05 [1] PB_05_TP56 output enabled
    04 [0] PB_04_BLADE_AN1 input

    03 [0] PB_03_BLADE_AN0 input
    02 [0] PB_02_BUTTON3 input
    01 [0] PB_01_BUTTON2 input
    00 [0] PB_00_BUTTON1 input
*/

/* PIO Controller Input Filter Enable Register
0: No effect
1: Enables the input glitch filter on the I/O line.
*/
/* 
    31 [0] PA_31_HEARTBEAT no glitch filter
    30 [0] PA_30_AN_DEMO no glitch filter
    29 [0] PA_29_BUZZER2 no glitch filter
    28 [0] PA_28_BUZZER1 no glitch filter

    27 [0] PA_27_CLOCK_OUT no glitch filter
    26 [0] PA_26_ANT_PWR_EN no glitch filter
    25 [0] PA_25_ANT_USPI2_SCK no glitch filter
    24 [0] PA_24_SD_USPI1_SCK no glitch filter

    23 [0] PA_23_ANT_USPI2_MOSI no glitch filter
    22 [0] PA_22_ANT_USPI2_MISO no glitch filter
    21 [0] PA_21_SD_USPI1_MISO no glitch filter
    20 [0] PA_20_SD_USPI1_MOSI no glitch filter

    19 [0] PA_19_DEBUG_U0_PIMO no glitch filter
    18 [0] PA_18_DEBUG_U0_POMI no glitch filter
    17 [0] PA_17_BUTTON0 no glitch filter
    16 [0] PA_16_BLADE_CS no glitch filter

    15 [0] PA_15_BLADE_SCK no glitch filter
    14 [0] PA_14_BLADE_MOSI no glitch filter
    13 [0] PA_13_BLADE_MISO no glitch filter
    12 [0] PA_12_BLADE_UPOMI no glitch filter

    11 [0] PA_11_BLADE_UPIMO no glitch filter
    10 [0] PA_10_I2C_SCL no glitch filter
    09 [0] PA_09_I2C_SDA no glitch filter
    08 [0] PA_08_SD_CS_MCDA3 no glitch filter

    07 [0] PA_07_HSMCI_MCDA2 no glitch filter
    06 [0] PA_06_HSMCI_MCDA1 no glitch filter
    05 [0] PA_05_HSMCI_MCDA0 no glitch filter
    04 [0] PA_04_HSMCI_MCCDA no glitch filter

    03 [0] PA_03_HSMCI_MCCK no glitch filter
    02 [0] PA_02_SD_DETECT no glitch filter
    01 [0] PA_01_SD_WP no glitch filter
    00 [0] PA_00_TP54 no glitch filter
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY no glitch filter

    23 [0] PB_23_ANT_MRDY no glitch filter
    22 [0] PB_22_ANT_USPI2_CS no glitch filter
    21 [0] PB_21_ANT_RESET no glitch filter
    20 [0] PB_20_LED_RED no glitch filter

    19 [0] PB_19_LED_GRN no glitch filter
    18 [0] PB_18_LED_BLU no glitch filter
    17 [0] PB_17_LED_YLW no glitch filter
    16 [0] PB_16_LED_CYN no glitch filter

    15 [0] PB_15_LED_ORG no glitch filter
    14 [0] PB_14_LED_PRP no glitch filter
    13 [0] PB_13_LED_WHT no glitch filter
    12 [0] PB_12_LCD_BL_BLU no glitch filter

    11 [0] PB_11_LCD_BL_GRN no glitch filter
    10 [0] PB_10_LCD_BL_RED no glitch filter
    09 [0] PB_09_LCD_RST no glitch filter
    08 [0] PB_08_TP62 no glitch filter

    07 [0] PB_07_TP60 no glitch filter
    06 [0] PB_06_TP58 no glitch filter
    05 [0] PB_05_TP56 no glitch filter
    04 [0] PB_04_BLADE_AN1 no glitch filter

    03 [0] PB_03_BLADE_AN0 no glitch filter
    02 [0] PB_02_BUTTON3 no glitch filter
    01 [0] PB_01_BUTTON2 no glitch filter
    00 [0] PB_00_BUTTON1 no glitch filter
*/


/* PIO Controller Set Output Data Register
Default start-up IO values are held here.
0: No effect
1: Sets the data to be driven on the I/O line.
*/
/* 
    31 [1] PA_31_HEARTBEAT output high 
    30 [0] PA_30_AN_DEMO N/A
    29 [0] PA_29_BUZZER2 output low
    28 [0] PA_28_BUZZER1 output low

    27 [1] PA_27_CLOCK_OUT output high
    26 [0] PA_26_ANT_PWR_EN output high Z
    25 [0] PA_25_ANT_USPI2_SCK N/A
    24 [0] PA_24_SD_USPI1_SCK N/A

    23 [0] PA_23_ANT_USPI2_MOSI N/A
    22 [0] PA_22_ANT_USPI2_MISO N/A
    21 [0] PA_21_SD_USPI1_MISO N/A
    20 [0] PA_20_SD_USPI1_MOSI N/A

    19 [0] PA_19_DEBUG_U0_PIMO N/A
    18 [0] PA_18_DEBUG_U0_POMI N/A
    17 [0] PA_17_BUTTON0 N/A
    16 [1] PA_16_BLADE_CS output high

    15 [0] PA_15_BLADE_SCK N/A
    14 [0] PA_14_BLADE_MOSI N/A
    13 [0] PA_13_BLADE_MISO N/A
    12 [0] PA_12_BLADE_UPOMI N/A

    11 [0] PA_11_BLADE_UPIMO N/A
    10 [0] PA_10_I2C_SCL N/A
    09 [0] PA_09_I2C_SDA N/A
    08 [0] PA_08_SD_CS_MCDA3 N/A

    07 [0] PA_07_HSMCI_MCDA2 N/A
    06 [0] PA_06_HSMCI_MCDA1 N/A
    05 [0] PA_05_HSMCI_MCDA0 N/A
    04 [0] PA_04_HSMCI_MCCDA N/A

    03 [0] PA_03_HSMCI_MCCK N/A
    02 [0] PA_02_SD_DETECT N/A
    01 [0] PA_01_SD_WP N/A
    00 [0] PA_00_TP54 N/A
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [1] PB_24_ANT_SRDY output high

    23 [1] PB_23_ANT_MRDY output high
    22 [0] PB_22_ANT_USPI2_CS N/A
    21 [1] PB_21_ANT_RESET output high
    20 [0] PB_20_LED_RED output low (off)

    19 [0] PB_19_LED_GRN output low (off)
    18 [0] PB_18_LED_BLU output low (off)
    17 [0] PB_17_LED_YLW output low (off)
    16 [0] PB_16_LED_CYN output low (off)

    15 [0] PB_15_LED_ORG output low (off)
    14 [0] PB_14_LED_PRP output low (off)
    13 [0] PB_13_LED_WHT output low (off)
    12 [0] PB_12_LCD_BL_BLU output low (off)

    11 [0] PB_11_LCD_BL_GRN output low (off)
    10 [0] PB_10_LCD_BL_RED output low (off)
    09 [1] PB_09_LCD_RST output high
    08 [0] PB_08_TP62 N/A

    07 [0] PB_07_TP60 N/A
    06 [0] PB_06_TP58 N/A
    05 [0] PB_05_TP56 N/A
    04 [0] PB_04_BLADE_AN1 N/A

    03 [0] PB_03_BLADE_AN0 N/A
    02 [0] PB_02_BUTTON3 N/A
    01 [0] PB_01_BUTTON2 N/A
    00 [0] PB_00_BUTTON1 N/A
*/

/* PIO Controller Clear Output Data Register
Initial output values are stored here.
0: No effect
1: Clears the data to be driven on the I/O line.
*/
/* 
    31 [0] PA_31_HEARTBEAT output high 
    30 [0] PA_30_AN_DEMO N/A
    29 [1] PA_29_BUZZER2 output low
    28 [1] PA_28_BUZZER1 output low

    27 [0] PA_27_CLOCK_OUT output high
    26 [0] PA_26_ANT_PWR_EN output high Z
    25 [0] PA_25_ANT_USPI2_SCK N/A
    24 [0] PA_24_SD_USPI1_SCK N/A

    23 [0] PA_23_ANT_USPI2_MOSI N/A
    22 [0] PA_22_ANT_USPI2_MISO N/A
    21 [0] PA_21_SD_USPI1_MISO N/A
    20 [0] PA_20_SD_USPI1_MOSI N/A

    19 [0] PA_19_DEBUG_U0_PIMO N/A
    18 [0] PA_18_DEBUG_U0_POMI N/A
    17 [0] PA_17_BUTTON0 N/A
    16 [0] PA_16_BLADE_CS output high

    15 [0] PA_15_BLADE_SCK N/A
    14 [0] PA_14_BLADE_MOSI N/A
    13 [0] PA_13_BLADE_MISO N/A
    12 [0] PA_12_BLADE_UPOMI N/A

    11 [0] PA_11_BLADE_UPIMO N/A
    10 [0] PA_10_I2C_SCL N/A
    09 [0] PA_09_I2C_SDA N/A
    08 [0] PA_08_SD_CS_MCDA3 N/A

    07 [0] PA_07_HSMCI_MCDA2 N/A
    06 [0] PA_06_HSMCI_MCDA1 N/A
    05 [0] PA_05_HSMCI_MCDA0 N/A
    04 [0] PA_04_HSMCI_MCCDA N/A

    03 [0] PA_03_HSMCI_MCCK N/A
    02 [0] PA_02_SD_DETECT N/A
    01 [0] PA_01_SD_WP N/A
    00 [0] PA_00_TP54 N/A
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY output high

    23 [0] PB_23_ANT_MRDY output high
    22 [0] PB_22_ANT_USPI2_CS N/A
    21 [0] PB_21_ANT_RESET output high
    20 [0] PB_20_LED_RED output high

    19 [0] PB_19_LED_GRN output high
    18 [0] PB_18_LED_BLU output high
    17 [0] PB_17_LED_YLW output high
    16 [0] PB_16_LED_CYN output high

    15 [0] PB_15_LED_ORG output high
    14 [0] PB_14_LED_PRP output high
    13 [0] PB_13_LED_WHT output high
    12 [0] PB_12_LCD_BL_BLU output high

    11 [0] PB_11_LCD_BL_GRN output high
    10 [0] PB_10_LCD_BL_RED output high
    09 [0] PB_09_LCD_RST output high
    08 [0] PB_08_TP62 N/A

    07 [0] PB_07_TP60 N/A
    06 [0] PB_06_TP58 N/A
    05 [0] PB_05_TP56 N/A
    04 [0] PB_04_BLADE_AN1 N/A

    03 [0] PB_03_BLADE_AN0 N/A
    02 [0] PB_02_BUTTON3 N/A
    01 [0] PB_01_BUTTON2 N/A
    00 [0] PB_00_BUTTON1 N/A
*/

/* PIO Multi-driver (open drain) Enable Register
0: No effect
1: Enables Multi Drive on the I/O line.
*/
/* 
    31 [0] PA_31_HEARTBEAT
    30 [0] PA_30_AN_DEMO
    29 [0] PA_29_BUZZER2
    28 [0] PA_28_BUZZER1

    27 [0] PA_27_CLOCK_OUT
    26 [1] PA_26_ANT_PWR_EN open drain
    25 [0] PA_25_ANT_USPI2_SCK
    24 [0] PA_24_SD_USPI1_SCK

    23 [0] PA_23_ANT_USPI2_MOSI
    22 [0] PA_22_ANT_USPI2_MISO
    21 [0] PA_21_SD_USPI1_MISO
    20 [0] PA_20_SD_USPI1_MOSI

    19 [0] PA_19_DEBUG_U0_PIMO
    18 [0] PA_18_DEBUG_U0_POMI
    17 [0] PA_17_BUTTON0
    16 [0] PA_16_BLADE_CS

    15 [0] PA_15_BLADE_SCK
    14 [0] PA_14_BLADE_MOSI
    13 [0] PA_13_BLADE_MISO
    12 [0] PA_12_BLADE_UPOMI

    11 [0] PA_11_BLADE_UPIMO
    10 [1] PA_10_I2C_SCL open drain
    09 [1] PA_09_I2C_SDA open drain
    08 [0] PA_08_SD_CS_MCDA3

    07 [0] PA_07_HSMCI_MCDA2
    06 [0] PA_06_HSMCI_MCDA1
    05 [0] PA_05_HSMCI_MCDA0
    04 [0] PA_04_HSMCI_MCCDA

    03 [0] PA_03_HSMCI_MCCK
    02 [0] PA_02_SD_DETECT
    01 [0] PA_01_SD_WP
    00 [0] PA_00_TP54
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY

    23 [0] PB_23_ANT_MRDY
    22 [0] PB_22_ANT_USPI2_CS
    21 [0] PB_21_ANT_RESET
    20 [0] PB_20_LED_RED

    19 [0] PB_19_LED_GRN
    18 [0] PB_18_LED_BLU
    17 [0] PB_17_LED_YLW
    16 [0] PB_16_LED_CYN

    15 [0] PB_15_LED_ORG
    14 [0] PB_14_LED_PRP
    13 [0] PB_13_LED_WHT
    12 [0] PB_12_LCD_BL_BLU

    11 [0] PB_11_LCD_BL_GRN
    10 [0] PB_10_LCD_BL_RED
    09 [0] PB_09_LCD_RST
    08 [0] PB_08_TP62

    07 [0] PB_07_TP60
    06 [0] PB_06_TP58
    05 [0] PB_05_TP56
    04 [0] PB_04_BLADE_AN1

    03 [0] PB_03_BLADE_AN0
    02 [0] PB_02_BUTTON3
    01 [0] PB_01_BUTTON2
    00 [0] PB_00_BUTTON1
*/

/* PIO Pull Up Enable Register
0: No effect
1: Enables the pull-up resistor on the selected pin
*/
/*
    31 [0] PA_31_HEARTBEAT no pull-up
    30 [0] PA_30_AN_DEMO no pull-up
    29 [0] PA_29_BUZZER2 no pull-up
    28 [0] PA_28_BUZZER1 no pull-up

    27 [0] PA_27_CLOCK_OUT no pull-up
    26 [0] PA_26_ANT_PWR_EN no pull-up
    25 [0] PA_25_ANT_USPI2_SCK no pull-up
    24 [0] PA_24_SD_USPI1_SCK no pull-up

    23 [0] PA_23_ANT_USPI2_MOSI no pull-up
    22 [0] PA_22_ANT_USPI2_MISO no pull-up
    21 [0] PA_21_SD_USPI1_MISO no pull-up
    20 [0] PA_20_SD_USPI1_MOSI no pull-up

    19 [0] PA_19_DEBUG_U0_PIMO no pull-up
    18 [0] PA_18_DEBUG_U0_POMI no pull-up
    17 [0] PA_17_BUTTON0 no pull-up
    16 [0] PA_16_BLADE_CS no pull-up

    15 [0] PA_15_BLADE_SCK no pull-up
    14 [0] PA_14_BLADE_MOSI no pull-up
    13 [0] PA_13_BLADE_MISO no pull-up
    12 [0] PA_12_BLADE_UPOMI no pull-up

    11 [0] PA_11_BLADE_UPIMO no pull-up
    10 [0] PA_10_I2C_SCL no pull-up
    09 [0] PA_09_I2C_SDA no pull-up
    08 [0] PA_08_SD_CS_MCDA3 no pull-up

    07 [0] PA_07_HSMCI_MCDA2 no pull-up
    06 [0] PA_06_HSMCI_MCDA1 no pull-up
    05 [0] PA_05_HSMCI_MCDA0 no pull-up
    04 [0] PA_04_HSMCI_MCCDA no pull-up

    03 [0] PA_03_HSMCI_MCCK no pull-up
    02 [0] PA_02_SD_DETECT no pull-up
    01 [0] PA_01_SD_WP no pull-up
    00 [1] PA_00_TP54 pull-up enabled
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY no pull-up

    23 [0] PB_23_ANT_MRDY no pull-up
    22 [0] PB_22_ANT_USPI2_CS no pull-up
    21 [0] PB_21_ANT_RESET no pull-up
    20 [0] PB_20_LED_RED no pull-up

    19 [0] PB_19_LED_GRN no pull-up
    18 [0] PB_18_LED_BLU no pull-up
    17 [0] PB_17_LED_YLW no pull-up
    16 [0] PB_16_LED_CYN no pull-up

    15 [0] PB_15_LED_ORG no pull-up
    14 [0] PB_14_LED_PRP no pull-up
    13 [0] PB_13_LED_WHT no pull-up
    12 [0] PB_12_LCD_BL_BLU no pull-up

    11 [0] PB_11_LCD_BL_GRN no pull-up
    10 [0] PB_10_LCD_BL_RED no pull-up
    09 [0] PB_09_LCD_RST no pull-up
    08 [1] PB_08_TP62 pull-up enabled

    07 [1] PB_07_TP60 pull-up enabled
    06 [0] PB_06_TP58 no pull-up enabled
    05 [1] PB_05_TP56 pull-up enabled
    04 [0] PB_04_BLADE_AN1 no pull-up

    03 [0] PB_03_BLADE_AN0 no pull-up
    02 [0] PB_02_BUTTON3 no pull-up
    01 [0] PB_01_BUTTON2 no pull-up
    00 [0] PB_00_BUTTON1 no pull-up
*/


/* PIO Peripheral AB Select Register
0: Assigns the I/O line to the Peripheral A function.
1: Assigns the I/O line to the Peripheral B function.
*/
/* 
    31 [0] PA_31_HEARTBEAT N/A
    30 [1] PA_30_AN_DEMO PERIPHERAL B
    29 [1] PA_29_BUZZER2 PERIPHERAL B
    28 [1] PA_28_BUZZER1 PERIPHERAL B

    27 [1] PA_27_CLOCK_OUT PERIPHERAL B
    26 [0] PA_26_ANT_PWR_EN N/A
    25 [1] PA_25_ANT_USPI2_SCK PERIPHERAL B
    24 [1] PA_24_SD_USPI1_SCK PERIPHERAL B

    23 [0] PA_23_ANT_USPI2_MOSI PERIPHERAL A
    22 [0] PA_22_ANT_USPI2_MISO PERIPHERAL A
    21 [0] PA_21_SD_USPI1_MISO PERIPHERAL A
    20 [0] PA_20_SD_USPI1_MOSI PERIPHERAL A

    19 [0] PA_19_DEBUG_U0_PIMO PERIPHERAL A
    18 [0] PA_18_DEBUG_U0_POMI PERIPHERAL A
    17 [0] PA_17_BUTTON0 N/A
    16 [0] PA_16_BLADE_CS PERIPHERAL A

    15 [0] PA_15_BLADE_SCK PERIPHERAL A
    14 [0] PA_14_BLADE_MOSI PERIPHERAL A
    13 [0] PA_13_BLADE_MISO PERIPHERAL A
    12 [0] PA_12_BLADE_UPOMI PERIPHERAL A

    11 [0] PA_11_BLADE_UPIMO PERIPHERAL A
    10 [0] PA_10_I2C_SCL PERIPHERAL A
    09 [0] PA_09_I2C_SDA PERIPHERAL A
    08 [0] PA_08_SD_CS_MCDA3 PERIPHERAL A

    07 [0] PA_07_HSMCI_MCDA2 PERIPHERAL A
    06 [0] PA_06_HSMCI_MCDA1 PERIPHERAL A
    05 [0] PA_05_HSMCI_MCDA0 PERIPHERAL A
    04 [0] PA_04_HSMCI_MCCDA PERIPHERAL A

    03 [0] PA_03_HSMCI_MCCK PERIPHERAL A
    02 [0] PA_02_SD_DETECT N/A
    01 [0] PA_01_SD_WP N/A
    00 [0] PA_00_TP54 N/A
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY N/A

    23 [0] PB_23_ANT_MRDY N/A
    22 [1] PB_22_ANT_USPI2_CS PERIPHERAL B
    21 [0] PB_21_ANT_RESET N/A
    20 [0] PB_20_LED_RED N/A

    19 [0] PB_19_LED_GRN N/A
    18 [0] PB_18_LED_BLU N/A
    17 [0] PB_17_LED_YLW N/A
    16 [0] PB_16_LED_CYN N/A

    15 [0] PB_15_LED_ORG N/A
    14 [0] PB_14_LED_PRP N/A
    13 [0] PB_13_LED_WHT N/A
    12 [0] PB_12_LCD_BL_BLU N/A

    11 [0] PB_11_LCD_BL_GRN N/A
    10 [0] PB_10_LCD_BL_RED N/A
    09 [0] PB_09_LCD_RST N/A
    08 [0] PB_08_TP62 N/A

    07 [0] PB_07_TP60 N/A
    06 [0] PB_06_TP58 N/A
    05 [0] PB_05_TP56 N/A
    04 [1] PB_04_BLADE_AN1 PERIPHERAL B

    03 [1] PB_03_BLADE_AN0 PERIPHERAL B
    02 [0] PB_02_BUTTON3 N/A
    01 [0] PB_01_BUTTON2 N/A
    00 [0] PB_00_BUTTON1 N/A
*/

/* PIO System Clock Glitch Input Filtering Select Register
0: No effect
1: The Glitch Filter is able to filter glitches with a duration < Tmck/2.
*/
/* 
    31 [0] PA_31_HEARTBEAT
    30 [0] PA_30_AN_DEMO
    29 [0] PA_29_BUZZER2
    28 [0] PA_28_BUZZER1

    27 [0] PA_27_CLOCK_OUT
    26 [0] PA_26_ANT_PWR_EN
    25 [0] PA_25_ANT_USPI2_SCK
    24 [0] PA_24_SD_USPI1_SCK

    23 [0] PA_23_ANT_USPI2_MOSI
    22 [0] PA_22_ANT_USPI2_MISO
    21 [0] PA_21_SD_USPI1_MISO
    20 [0] PA_20_SD_USPI1_MOSI

    19 [0] PA_19_DEBUG_U0_PIMO
    18 [0] PA_18_DEBUG_U0_POMI
    17 [0] PA_17_BUTTON0
    16 [0] PA_16_BLADE_CS

    15 [0] PA_15_BLADE_SCK
    14 [0] PA_14_BLADE_MOSI
    13 [0] PA_13_BLADE_MISO
    12 [0] PA_12_BLADE_UPOMI

    11 [0] PA_11_BLADE_UPIMO
    10 [0] PA_10_I2C_SCL
    09 [0] PA_09_I2C_SDA
    08 [0] PA_08_SD_CS_MCDA3

    07 [0] PA_07_HSMCI_MCDA2
    06 [0] PA_06_HSMCI_MCDA1
    05 [0] PA_05_HSMCI_MCDA0
    04 [0] PA_04_HSMCI_MCCDA

    03 [0] PA_03_HSMCI_MCCK
    02 [0] PA_02_SD_DETECT
    01 [0] PA_01_SD_WP
    00 [0] PA_00_TP54
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY

    23 [0] PB_23_ANT_MRDY
    22 [0] PB_22_ANT_USPI2_CS
    21 [0] PB_21_ANT_RESET
    20 [0] PB_20_LED_RED

    19 [0] PB_19_LED_GRN
    18 [0] PB_18_LED_BLU
    17 [0] PB_17_LED_YLW
    16 [0] PB_16_LED_CYN

    15 [0] PB_15_LED_ORG
    14 [0] PB_14_LED_PRP
    13 [0] PB_13_LED_WHT
    12 [0] PB_12_LCD_BL_BLU

    11 [0] PB_11_LCD_BL_GRN
    10 [0] PB_10_LCD_BL_RED
    09 [0] PB_09_LCD_RST
    08 [0] PB_08_TP62

    07 [0] PB_07_TP60
    06 [0] PB_06_TP58
    05 [0] PB_05_TP56
    04 [0] PB_04_BLADE_AN1

    03 [0] PB_03_BLADE_AN0
    02 [0] PB_02_BUTTON3
    01 [0] PB_01_BUTTON2
    00 [0] PB_00_BUTTON1
*/

/* PIO Debouncing Input Filtering Select Register
0: No effect
1: The Debouncing Filter is able to filter pulses with a duration < Tdiv_slclk/2.
*/
/* 
    31 [0] PA_31_HEARTBEAT
    30 [0] PA_30_AN_DEMO
    29 [0] PA_29_BUZZER2
    28 [0] PA_28_BUZZER1

    27 [0] PA_27_CLOCK_OUT
    26 [0] PA_26_ANT_PWR_EN
    25 [0] PA_25_ANT_USPI2_SCK
    24 [0] PA_24_SD_USPI1_SCK

    23 [0] PA_23_ANT_USPI2_MOSI
    22 [0] PA_22_ANT_USPI2_MISO
    21 [0] PA_21_SD_USPI1_MISO
    20 [0] PA_20_SD_USPI1_MOSI

    19 [0] PA_19_DEBUG_U0_PIMO
    18 [0] PA_18_DEBUG_U0_POMI
    17 [0] PA_17_BUTTON0
    16 [0] PA_16_BLADE_CS

    15 [0] PA_15_BLADE_SCK
    14 [0] PA_14_BLADE_MOSI
    13 [0] PA_13_BLADE_MISO
    12 [0] PA_12_BLADE_UPOMI

    11 [0] PA_11_BLADE_UPIMO
    10 [0] PA_10_I2C_SCL
    09 [0] PA_09_I2C_SDA
    08 [0] PA_08_SD_CS_MCDA3

    07 [0] PA_07_HSMCI_MCDA2
    06 [0] PA_06_HSMCI_MCDA1
    05 [0] PA_05_HSMCI_MCDA0
    04 [0] PA_04_HSMCI_MCCDA

    03 [0] PA_03_HSMCI_MCCK
    02 [0] PA_02_SD_DETECT
    01 [0] PA_01_SD_WP
    00 [0] PA_00_TP54
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY

    23 [0] PB_23_ANT_MRDY
    22 [0] PB_22_ANT_USPI2_CS
    21 [0] PB_21_ANT_RESET
    20 [0] PB_20_LED_RED

    19 [0] PB_19_LED_GRN
    18 [0] PB_18_LED_BLU
    17 [0] PB_17_LED_YLW
    16 [0] PB_16_LED_CYN

    15 [0] PB_15_LED_ORG
    14 [0] PB_14_LED_PRP
    13 [0] PB_13_LED_WHT
    12 [0] PB_12_LCD_BL_BLU

    11 [0] PB_11_LCD_BL_GRN
    10 [0] PB_10_LCD_BL_RED
    09 [0] PB_09_LCD_RST
    08 [0] PB_08_TP62

    07 [0] PB_07_TP60
    06 [0] PB_06_TP58
    05 [0] PB_05_TP56
    04 [0] PB_04_BLADE_AN1

    03 [0] PB_03_BLADE_AN0
    02 [0] PB_02_BUTTON3
    01 [0] PB_01_BUTTON2
    00 [0] PB_00_BUTTON1
*/

/* PIO Slow Clock Divider Debouncing Register
Tdiv_slclk = 2*(DIV+1)*Tslow_clock. 
*/
/*
    31 - 16 [0] Reserved

    15 [0] Reserved
    14 [0] "
    13 [0] DIV
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*
    31 - 16 [0] Reserved

    15 [0] Reserved
    14 [0] "
    13 [0] DIV
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] "
*/

/* PIO Output Write Enable Register
0: No effect
1: Enables writing PIO_ODSR directly for the I/O line.
*/
/* 
    31 [0] PA_31_HEARTBEAT write ODSR disabled
    30 [0] PA_30_AN_DEMO write ODSR disabled
    29 [0] PA_29_BUZZER2 write ODSR disabled
    28 [0] PA_28_BUZZER1 write ODSR disabled

    27 [0] PA_27_CLOCK_OUT write ODSR disabled
    26 [0] PA_26_ANT_PWR_EN write ODSR disabled
    25 [0] PA_25_ANT_USPI2_SCK write ODSR disabled
    24 [0] PA_24_SD_USPI1_SCK write ODSR disabled

    23 [0] PA_23_ANT_USPI2_MOSI write ODSR disabled
    22 [0] PA_22_ANT_USPI2_MISO write ODSR disabled
    21 [0] PA_21_SD_USPI1_MISO write ODSR disabled
    20 [0] PA_20_SD_USPI1_MOSI write ODSR disabled

    19 [0] PA_19_DEBUG_U0_PIMO write ODSR disabled
    18 [0] PA_18_DEBUG_U0_POMI write ODSR disabled
    17 [0] PA_17_BUTTON0 write ODSR disabled
    16 [0] PA_16_BLADE_CS write ODSR disabled

    15 [0] PA_15_BLADE_SCK write ODSR disabled
    14 [0] PA_14_BLADE_MOSI write ODSR disabled
    13 [0] PA_13_BLADE_MISO write ODSR disabled
    12 [0] PA_12_BLADE_UPOMI write ODSR disabled

    11 [0] PA_11_BLADE_UPIMO write ODSR disabled
    10 [0] PA_10_I2C_SCL write ODSR disabled
    09 [0] PA_09_I2C_SDA write ODSR disabled
    08 [0] PA_08_SD_CS_MCDA3 write ODSR disabled

    07 [0] PA_07_HSMCI_MCDA2 write ODSR disabled
    06 [0] PA_06_HSMCI_MCDA1 write ODSR disabled
    05 [0] PA_05_HSMCI_MCDA0 write ODSR disabled
    04 [0] PA_04_HSMCI_MCCDA write ODSR disabled

    03 [0] PA_03_HSMCI_MCCK write ODSR disabled
    02 [0] PA_02_SD_DETECT write ODSR disabled
    01 [0] PA_01_SD_WP write ODSR disabled
    00 [0] PA_00_TP54 write ODSR disabled
*/

/*
    31 [0] PB_31_
    30 [0] PB_30_
    29 [0] PB_29_
    28 [0] PB_28_

    27 [0] PB_27_
    26 [0] PB_26_
    25 [0] PB_25_
    24 [0] PB_24_ANT_SRDY write ODSR disabled

    23 [0] PB_23_ANT_MRDY write ODSR disabled
    22 [0] PB_22_ANT_USPI2_CS write ODSR disabled
    21 [0] PB_21_ANT_RESET write ODSR disabled
    20 [1] PB_20_LED_RED write ODSR enabled

    19 [1] PB_19_LED_GRN write ODSR enabled
    18 [1] PB_18_LED_BLU write ODSR enabled
    17 [1] PB_17_LED_YLW write ODSR enabled
    16 [1] PB_16_LED_CYN write ODSR enabled

    15 [1] PB_15_LED_ORG write ODSR enabled
    14 [1] PB_14_LED_PRP write ODSR enabled
    13 [1] PB_13_LED_WHT write ODSR enabled
    12 [1] PB_12_LCD_BL_BLU write ODSR enabled

    11 [1] PB_11_LCD_BL_GRN write ODSR enabled
    10 [1] PB_10_LCD_BL_RED write ODSR enabled
    09 [0] PB_09_LCD_RST write ODSR disabled
    08 [0] PB_08_TP62 write ODSR disabled

    07 [0] PB_07_TP60 write ODSR disabled
    06 [0] PB_06_TP58 write ODSR disabled
    05 [0] PB_05_TP56 write ODSR disabled
    04 [0] PB_04_BLADE_AN1 write ODSR disabled

    03 [0] PB_03_BLADE_AN0 write ODSR disabled
    02 [0] PB_02_BUTTON3 write ODSR disabled
    01 [0] PB_01_BUTTON2 write ODSR disabled
    00 [0] PB_00_BUTTON1 write ODSR disabled
*/

/* PIO Write Protect Mode Register PIO_WPMR
Enables the Write Protect if WPKEY corresponds to 0x50494F (“PIO” in ASCII).
Though this is defined in the user guide, there is no definition in the processor header file.
We don't want to lock access to the GPIO registers anyway, so we won't use this for now.
*/
/*
    31 -08 [0] WPKEY

    07 [0] Reserved
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] WPEN
*/


/***********************************************************************************************************************
$$$$$ PWM setup values
***********************************************************************************************************************/

/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] PREB MCK
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] DIVB = 0 => CLKB is off
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] "
    18 [0] "
    17 [0] "
    16 [0] "

    15 [0] Reserved
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] PREA MCK
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] DIVA = 0 => CLKB is off
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] "
*/

/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] PTRCS
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] Reserved
    18 [0] "
    17 [0] UPDM
    16 [0] "

    15 [0] Reserved
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] SYNC3 not synchronous
    02 [0] SYNC2 not synchronous
    01 [0] SYNC1 not synchronous
    00 [0] SYNC0 not synchronous
*/

/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] "
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] "
    18 [0] DTLI dead-time low channel output is not inverted
    17 [0] DTHI dead-time high channel output is not inverted
    16 [0] DTE dead-time generator disabled

    15 [0] Reserved
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] CES channel event at end of PWM period
    09 [0] CPOL channel starts low
    08 [0] CALG period is left aligned

    07 [0] Reserved
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] CPRE clock is MCK/8
    02 [0] "
    01 [1] "
    00 [1] "
*/

/* To achieve the full range of audio we want from 100Hz to 20kHz, we must be able to set periods
of 10ms to 50us.
- 10ms at 48MHz clock is 480,000 ticks
- 50us at 48MHz clock is 2400 ticks
- Only 16 bits are available to set the PWM period, so scale the clock by 8:
- 10ms at 6MHz clock is 60,000 ticks
- 50us at 6MHz clock is 300 ticks

Set the default period for audio on channel 0 as 1/1kHz
1ms at 6MHz = 6000 (duty = 3000)
Set the default period for audio on channel 1 as 1/4kHz
0.25ms at 6MHz = 1500 (duty = 750)

In general, the period is 6000000 / frequency and duty is always period / 2. 
*/



/***********************************************************************************************************************
%%%%% Template register settings
***********************************************************************************************************************/

/*
    31 [0] 
    30 [0] 
    29 [0] 
    28 [0] 

    27 [0] 
    26 [0] 
    25 [0] 
    24 [0] 

    23 [0] 
    22 [0] 
    21 [0] 
    20 [0] 

    19 [0] 
    18 [0] 
    17 [0] 
    16 [0] 

    15 [0] 
    14 [0] 
    13 [0] 
    12 [0] 

    11 [0] 
    10 [0] 
    09 [0] 
    08 [0] 

    07 [0] 
    06 [0] 
    05 [0] 
    04 [0] 

    03 [0] 
    02 [0] 
    01 [0] 
    00 [0] 
*/

/* 
    31 [] PA_31_HEARTBEAT 
    30 [] PA_30_AN_DEMO 
    29 [] PA_29_BUZZER2 
    28 [] PA_28_BUZZER1 

    27 [] PA_27_CLOCK_OUT 
    26 [] PA_26_ANT_PWR_EN 
    25 [] PA_25_ANT_USPI2_SCK 
    24 [] PA_24_SD_USPI1_SCK P

    23 [] PA_23_ANT_USPI2_MOSI 
    22 [] PA_22_ANT_USPI2_MISO 
    21 [] PA_21_SD_USPI1_MISO 
    20 [] PA_20_SD_USPI1_MOSI 

    19 [] PA_19_DEBUG_U0_PIMO 
    18 [] PA_18_DEBUG_U0_POMI 
    17 [] PA_17_BUTTON0 
    16 [] PA_16_BLADE_CS 

    15 [] PA_15_BLADE_SCK 
    14 [] PA_14_BLADE_MOSI 
    13 [] PA_13_BLADE_MISO 
    12 [] PA_12_BLADE_UPOMI 

    11 [] PA_11_BLADE_UPIMO 
    10 [] PA_10_I2C_SCL 
    09 [] PA_09_I2C_SDA 
    08 [] PA_08_SD_CS_MCDA3 

    07 [] PA_07_HSMCI_MCDA2 
    06 [] PA_06_HSMCI_MCDA1 
    05 [] PA_05_HSMCI_MCDA0 
    04 [] PA_04_HSMCI_MCCDA 

    03 [] PA_03_HSMCI_MCCK 
    02 [] PA_02_SD_DETECT 
    01 [] PA_01_SD_WP 
    00 [] PA_00_TP54 
*/

/*
    31 [] PB_31_
    30 [] PB_30_
    29 [] PB_29_
    28 [] PB_28_

    27 [] PB_27_
    26 [] PB_26_
    25 [] PB_25_
    24 [] PB_24_ANT_SRDY 

    23 [] PB_23_ANT_MRDY 
    22 [] PB_22_ANT_USPI2_CS 
    21 [] PB_21_ANT_RESET 
    20 [] PB_20_LED_RED 

    19 [] PB_19_LED_GRN 
    18 [] PB_18_LED_BLU 
    17 [] PB_17_LED_YLW 
    16 [] PB_16_LED_CYN 

    15 [] PB_15_LED_ORG 
    14 [] PB_14_LED_PRP 
    13 [] PB_13_LED_WHT 
    12 [] PB_12_LCD_BL_BLU 

    11 [] PB_11_LCD_BL_GRN 
    10 [] PB_10_LCD_BL_RED 
    09 [] PB_09_LCD_RST 
    08 [] PB_08_TP62  

    07 [] PB_07_TP60 
    06 [] PB_06_TP58 
    05 [] PB_05_TP56 
    04 [] PB_04_BLADE_AN1 

    03 [] PB_03_BLADE_AN0 
    02 [] PB_02_BUTTON3 
    01 [] PB_01_BUTTON2 
    00 [] PB_00_BUTTON1 
*/

/*! @endcond */


/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file lcd_nhd-c0220biz.h                                                               

@brief Header file for lcd_nhd-c0220biz.c
******************************************************************************/


/*!*********************************************************************************************************************
@file configuration.h      
@brief Main configuration header file for project.  

This file bridges many of the generic features of the firmware to the 
specific features of the design. The definitions should be updated
to match the target hardware.  
 
Bookmarks:
!!!!! External module peripheral assignments
##### UART peripheral board-specific parameters
$$$$$ SPI peripheral board-specific parameters
%%%%% SSP peripheral board-specific parameters
^^^^^ I²C peripheral board-specific parameters


***********************************************************************************************************************/


/*! @endcond */
/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/
/* Lcd_u32Flags */
/* end Lcd_u32Flags */

                                                               /* The documentation for the LCD says 0x78 however,
                                                                  that includes the Read/Write Bit */




/* LCD Commands
"CMD" requires RS = 0, R/W = 0 */







/*! @cond DOXYGEN_EXCLUDE */


/*------------------------------------------------------------------------------
Operational Notes:
RS and R/W lines are controlled to enable various states:

RS			R/W				Operation
0				 0				Instruction Write
0				 1				Read busy flag (DB7) and address counter (DB0 - DB6)
1				 0				Data Write
1				 1				Data Read

However, the I²C implementation of the LCD does not support reading data
back from the module.  Therefore, the R/W bit is always 0 which leaves
only RS to selection Instruction (Command) or Data mode.

For a two-line display, the character addresses are 0x00 - 0x27 (line 1)
and 0x40 - 0x67 (line 2), but only 20 chars can be displayed.  The extra
space can be used for scrolling displays.
*/

/* Data sheet initialization values */

/*! @endcond */


/**********************************************************************************************************************
* Function Declarations
**********************************************************************************************************************/

/*-------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void LcdCommand(u8 u8Command_);
void LcdClearChars(u8 u8Address_, u8 u8CharactersToClear_);
void LcdMessage(u8 u8Address_, u8* pu8Message_);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void LcdInitialize(void);
void LcdRunActiveState(void);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void LcdSM_Idle(void);

  




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/





/* Common driver header files */
/** \file antmessage.h
*
*  Contains ANT message IDs and other definiations useful for ANT messaging
*
* $Name:  $
*/
/*
 * Copyright (C) 2006 Dynastream Innovations Inc. All rights reserved. 
 *
 * The intellectual property contained within this file is sole property of Dynastream Innovations Inc. 
 * Any distribution without the prior written consent of Dynastream Innovations Inc. is strictly prohibited.
 *
 * Dynastream Innovations Inc. does not guarantee error free operation of the intellectual property contained 
 * herein. 
 * 
 * Please forward all questions regarding this code to ANT Technical Support.
 * 
 * Dynastream Innovations Inc.
 * 228 River Avenue
 * Cochrane, Alberta, Canada
 * T4C 2C1
 * 
 * (P) (403) 932-9292
 * (F) (403) 932-6521
 * (TF) 1-866-932-9292 in North America
 * (E) support@thisisant.com
 * 
 * www.thisisant.com
 */ 


/////////////////////////////////////////////////////////////////////////////
// Message Format
// Messages are in the format:
//
// AX XX YY -------- CK
//
// where: AX    is the 1 byte sync byte either transmit or recieve
//        XX    is the 1 byte size of the message (0-249) NOTE: THIS WILL BE LIMITED BY THE EMBEDDED RECEIVE BUFFER SIZE
//        YY    is the 1 byte ID of the message (1-255, 0 is invalid)
//        ----- is the data of the message (0-249 bytes of data)
//        CK    is the 1 byte Checksum of the message
/////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
// Buffer Indices - use these indexes when the buffer does NOT include the SYNC byte
//////////////////////////////////////////////

   
//////////////////////////////////////////////
// Message ID's
//////////////////////////////////////////////

   




//////////////////////////////////////////////
// Message Sizes
//////////////////////////////////////////////




   
   
/** \file antdefines.h
*
* Contains definitions for ANT config parameters and ANT event codes
*
* $Name:  $
*/
/*
 * Copyright (C) 2006 Dynastream Innovations Inc. All rights reserved. 
 *
 * The intellectual property contained within this file is sole property of Dynastream Innovations Inc. 
 * Any distribution without the prior written consent of Dynastream Innovations Inc. is strictly prohibited.
 *
 * Dynastream Innovations Inc. does not guarantee error free operation of the intellectual property contained 
 * herein. 
 * 
 * Please forward all questions regarding this code to ANT Technical Support.
 * 
 * Dynastream Innovations Inc.
 * 228 River Avenue
 * Cochrane, Alberta, Canada
 * T4C 2C1
 * 
 * (P) (403) 932-9292
 * (F) (403) 932-6521
 * (TF) 1-866-932-9292 in North America
 * (E) support@thisisant.com
 * 
 * www.thisisant.com
 */ 


//////////////////////////////////////////////
// ANT Clock Definition
//////////////////////////////////////////////

//////////////////////////////////////////////
// Radio TX Power Definitions
//////////////////////////////////////////////

//////////////////////////////////////////////
// Default System Definitions
//////////////////////////////////////////////

//////////////////////////////////////////////
// ID Definitions
//////////////////////////////////////////////

//////////////////////////////////////////////
// Assign Channel Parameters
//////////////////////////////////////////////

//////////////////////////////////////////////
// Assign Channel Types
//////////////////////////////////////////////

//////////////////////////////////////////////
// Channel Status
//////////////////////////////////////////////

//////////////////////////////////////////////
// Standard capabilities defines
//////////////////////////////////////////////

//////////////////////////////////////////////
// Advanced capabilities defines
//////////////////////////////////////////////

//////////////////////////////////////////////
// Burst Message Sequence 
//////////////////////////////////////////////

//////////////////////////////////////////////
// Shared Channel Commands / Datatypes
//////////////////////////////////////////////
//...

///////////////////////////////////////////////////////////////////////
// AtoD SubTypes
///////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
// Response / Event Codes
//////////////////////////////////////////////







/*!********************************************************************************************************************
@file ant.h                                                                
@brief Header file for ANT implementation for Cortex-M3 / nRF51422 with AP2 network processor 
SPI EiE Razor development board
**********************************************************************************************************************/


/**********************************************************************************************************************
Run time switches
**********************************************************************************************************************/
//#define ANT_VERBOSE                 /*!< @brief Define to enable Debug reporting of ANT Events */

/**********************************************************************************************************************
Type definitions
**********************************************************************************************************************/
/*! 
@enum AntChannelStatusType
@brief Enum to define the status of an ANT channel 
*/
typedef enum {ANT_UNCONFIGURED = 0, ANT_CONFIGURED = 1, ANT_OPENING = 2, 
              ANT_OPEN = 3, ANT_CLOSING = 4, ANT_CLOSED = 1} AntChannelStatusType;

/*! 
@enum AntApplicationMessageType
@brief Enum to define the type of message in the ANT API information buffer 
*/
typedef enum {ANT_EMPTY, ANT_DATA, ANT_TICK} AntApplicationMessageType;

/*! 
@enum AntChannelNumberType
@brief Enum to specify an ANT channel 
*/
typedef enum {ANT_CHANNEL_0 = 0, ANT_CHANNEL_1, ANT_CHANNEL_2, ANT_CHANNEL_3,
              ANT_CHANNEL_4, ANT_CHANNEL_5, ANT_CHANNEL_6, ANT_CHANNEL_7,
              ANT_CHANNEL_SCANNING = 0} AntChannelNumberType;

/*! 
@struct AntAssignChannelInfoType
@brief Data struct to fully configure an ANT channel */
typedef struct 
{
  AntChannelNumberType AntChannel;         /*!< @brief The ANT channel number */
  u8 AntChannelType;                       /*!< @brief ANT channel type from antdefines.h line 75 */
  u8 AntNetwork;                           /*!< @brief Network number */
  u8 AntNetworkKey[8];                     /*!< @brief Network key assigned to AntNetwork number */
  u8 AntDeviceIdLo;                        /*!< @brief Device ID low byte */
  u8 AntDeviceIdHi;                        /*!< @brief Device ID high byte */
  u8 AntDeviceType;                        /*!< @brief Device type byte */
  u8 AntTransmissionType;                  /*!< @brief Transmission type byte */
  u8 AntChannelPeriodLo;                   /*!< @brief Low byte of Channel Period */
  u8 AntChannelPeriodHi;                   /*!< @brief High byte of Channel Period */
  u8 AntFrequency;                         /*!< @brief RF frequency value */
  u8 AntTxPower;                           /*!< @brief RF power level from antdefines.h line 40 */
  u8 AntFlags;                             /*!< @brief Flag byte for tracking status */
} AntAssignChannelInfoType;

/* Channel flags used for AntFlags in AntAssignChannelInfoType */


/*! 
@struct AntExtendedDataType
@brief Data struct for extended data information 
*/
typedef struct
{
  u8 u8Channel;                            /*!< @brief ANT channel number byte */
  u8 u8Flags;                              /*!< @brief Extended data flags from the received message */
  u16 u16DeviceID;                         /*!< @brief Device ID from the received message */
  u8 u8DeviceType;                         /*!< @brief Device Type from the received message */
  u8 u8TransType;                          /*!< @brief Transmission Type from the received message */
  s8 s8RSSI;                               /*!< @brief RSSI from the received message */
  u8 u8Dummy;                              /*!< @brief Pad for 4-byte alignment */
} AntExtendedDataType;



/*! 
@struct AntApplicationMsgListType
@brief Data struct for the ANT application API message information 
*/
typedef struct
{
  u32 u32TimeStamp;                                  /*!< @brief Current G_u32SystemTime1s */
  AntApplicationMessageType eMessageType;            /*!< @brief Type of data */
  u8 u8Channel;                                      /*!< @brief Channel to which the data applies */
  u8 au8MessageData[(u8)8];  /*!< @brief Array for message data */
  AntExtendedDataType sExtendedData;                 /*!< @brief Struct of extended message data */
  void *psNextMessage;                               /*!< @brief Pointer to next AntApplicationMsgListType */
} AntApplicationMsgListType;


/*! 
@struct AntOutgoingMessageListType
@brief Data struct for outgoing data messages */
typedef struct
{
  u32 u32TimeStamp;                        /*!< @brief Current G_u32SystemTime1s */
  u8 au8MessageData[(((UCHAR)13) + ((((UCHAR)1) + ((UCHAR)1) + ((UCHAR)1)) + ((UCHAR)1)))];        /*!< @brief Array for message data */
  void *psNextMessage;                     /*!< @brief Pointer to next AntOutgoingMessageListType */
} AntOutgoingMessageListType;   


/*! 
@struct AntMessageResponseType
@brief Data struct for an ANT response message */
typedef struct
{
  u8 u8Channel;                            /*!< @brief The ANT channel number */
  u8 u8MessageNumber;                      /*!< @brief The message number to which the response refers */
  u8 u8ResponseCode;                       /*!< @brief The associated response code / event code */
} AntMessageResponseType;



/**********************************************************************************************************************
Macros 
**********************************************************************************************************************/






/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/


/*!@cond DOXYGEN_EXCLUDE */

/* G_u32AntFlags */
/* Error / event flags */


/* Status flags */

/* Control flags */
/* end G_u32AntFlags */


/* #### Default channel configuration parameters #### */



/* #### end of default channel configuration parameters ####*/



/* Network number */

/* Symbols for bytes in messages to help readability */


/*!@endcond */


/**********************************************************************************************************************
Function prototypes
**********************************************************************************************************************/

/*--------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
/* ANT Public Interface-layer Functions */
u8 AntCalculateTxChecksum(u8* pu8Message_);
bool AntQueueOutgoingMessage(u8 *pu8Message_);
void AntDeQueueApplicationMessage(void);


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
/* ANT Protected Interface-layer Functions */
void AntInitialize(void);
void AntRunActiveState(void);

void AntTxFlowControlCallback(void);
void AntRxFlowControlCallback(void);


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
/* ANT Private Interface-layer Functions */
static bool AntTxMessage(u8 *pu8AntTxMessage_);
static void AntRxMessage(void);
static void AntAbortMessage(void);
static void AdvanceAntRxBufferCurrentChar(void);
static void AdvanceAntRxBufferUnreadMsgPointer(void);

static u8 AntExpectResponse(u8 u8ExpectedMessageID_, u32 u32TimeoutMS_);
static u8 AntProcessMessage(void);
static bool AntParseExtendedData(u8* pu8SourceMessage_, AntExtendedDataType* psExtDataTarget_);
static bool AntQueueExtendedApplicationMessage(AntApplicationMessageType eMessageType_, u8* pu8DataSource_, AntExtendedDataType* psExtData_);
static void AntTickExtended(u8* pu8AntMessage_);
static void AntDeQueueOutgoingMessage(void);

/* ANT Private Serial-layer Functions */
static void AntSyncSerialInitialize(void);
static void AntSrdyPulse(void);

/* ANT State Machine Definition */
static void AntSM_Idle(void);
static void AntSM_ReceiveMessage(void);
static void AntSM_TransmitMessage(void);
static void AntSM_NoResponse(void);

/*!**********************************************************************************************************************
@file ant_api.h                                                                
@brief Header file for ant_api.c
**********************************************************************************************************************/


/**********************************************************************************************************************
Type definitions
**********************************************************************************************************************/


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*-------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
AntChannelStatusType AntRadioStatusChannel(AntChannelNumberType eChannel_);

bool AntAssignChannel(AntAssignChannelInfoType* psAntSetupInfo_);
bool AntUnassignChannelNumber(AntChannelNumberType eChannel_);

bool AntOpenChannelNumber(AntChannelNumberType eChannel_);
bool AntOpenScanningChannel(void);
bool AntCloseChannelNumber(AntChannelNumberType eChannel_);

bool AntQueueBroadcastMessage(AntChannelNumberType eChannel_, u8 *pu8Data_);
bool AntQueueAcknowledgedMessage(AntChannelNumberType eChannel_, u8 *pu8Data_);

bool AntReadAppMessageBuffer(void);

void AntGetdBmAscii(s8 s8RssiValue_, u8* pu8Result_);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void AntApiInitialize(void);
void AntApiRunActiveState(void);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/



/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void AntApiSM_Idle(void);    
static void AntApiSM_AssignChannel(void);       

static void AntApiSM_Error(void);         
static void AntApiSM_FailedInit(void);    


/**********************************************************************************************************************
Constants
**********************************************************************************************************************/



/**********************************************************************************************************************
Application messages
**********************************************************************************************************************/

/*----------------------------------------------------------------------------------------------------------------------
ANT_TICK communicates the message period to the application.  

If ANT is running as a Master, ANT_TICK occurs every time a broadcast or acknowledged
data message is sent (EVENT_TX). 

If ANT is running as a Slave, ANT_TICK occurs whenever ANT misses a message that it was expecting 
based on the established timing of a paired channel (EVENT_RX_FAIL).  If too many missed messages
occur, then EVENT_RX_FAIL_GO_TO_SEARCH will be sent.  If a search timeout is active, 
EVENT_RX_SEARCH_TIMEOUT will be sent if the timeout period expires.

This structure is set up to also relay other channel response messages, but is currently not used.

MSG_NAME  MSG_ID     D_0      D_1      D_2     D_3     D_4     D_5     D_6
ANT_TICK   0xFF    CHANNEL  RESPONSE  EVENT   0xFF   MISSED  MISSED  MISSED
                             TYPE     CODE            MSG #   MSG #   MSG #
                                                      HIGH    MID     LOW
---------------------------------------------------------------------------------------------------------------------*/








/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file buttons.h        
@brief Header file for buttons.c
***********************************************************************************************************************/


/***********************************************************************************************************************
Type Definitions
***********************************************************************************************************************/

/*! 
@enum ButtonStateType
@brief Self-documenting button state type */
typedef enum {RELEASED, PRESSED} ButtonStateType; 


/*! 
@struct ButtonStatusType
@brief Required parameters for the task to track what each button is doing. 
*/
typedef struct 
{
  bool bDebounceActive;                   /*!< @brief TRUE by ISR if a button interrupt occurs */
  bool bNewPressFlag;                     /*!< @brief TRUE if the press has not been acknowledged */
  ButtonStateType eCurrentState;          /*!< @brief Current state of the button */
  ButtonStateType eNewState;              /*!< @brief New state of the button */
  u32 u32DebounceTimeStart;               /*!< @brief System time loaded by ISR when button interrupt occurs */
  u32 u32TimeStamp;                       /*!< @brief System time when the button was pressed */
}ButtonStatusType;


/***********************************************************************************************************************
Function Declarations
***********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
bool IsButtonPressed(ButtonNameType eButton_);
bool WasButtonPressed(ButtonNameType eButton_);
void ButtonAcknowledge(ButtonNameType eButton_);
bool IsButtonHeld(ButtonNameType eButton_, u32 u32ButtonHeldTime_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void ButtonInitialize(void);                        
void ButtonRunActiveState(void);
void ButtonStartDebounce(u32 u32BitPosition_, PortOffsetType ePort_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void ButtonSM_Idle(void);                
static void ButtonSM_ButtonActive(void);
static void ButtonSM_Error(void);        



/***********************************************************************************************************************
Constants / Definitions
***********************************************************************************************************************/




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file leds.h                                                               
@brief Header file for leds.c
**********************************************************************************************************************/




/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@enum LedModeType
@brief The mode determines how the task manages the LED */
typedef enum {LED_NORMAL_MODE, LED_BLINK_MODE, LED_PWM_MODE} LedModeType;  

/*! 
@enum LedPWMDutyType
@brief Duty cycle state when tracking PWM mode*/
typedef enum {LED_PWM_DUTY_LOW = 0, LED_PWM_DUTY_HIGH = 1} LedPWMDutyType; 

/*! 
@enum LedRateType
@brief Standard blinky values for blinking.  

Other blinking rate values may be added as required.  The labels are frequencies, 
but the values are the toggling period in ms.

*** The PWM rates are set up to allow incrementing and decrementing rates within the allowed values.  
Be careful at the edge cases. ***
*/
typedef enum {LED_0HZ = 0, LED_0_5HZ = 1000, LED_1HZ = 500, LED_2HZ = 250, LED_4HZ = 125, LED_8HZ = 63,
              LED_PWM_0 = 0,   LED_PWM_5 = 1,   LED_PWM_10 = 2,  LED_PWM_15 = 3,  LED_PWM_20 = 4, 
              LED_PWM_25 = 5,  LED_PWM_30 = 6,  LED_PWM_35 = 7,  LED_PWM_40 = 8,  LED_PWM_45 = 9, 
              LED_PWM_50 = 10, LED_PWM_55 = 11, LED_PWM_60 = 12, LED_PWM_65 = 13, LED_PWM_70 = 14, 
              LED_PWM_75 = 15, LED_PWM_80 = 16, LED_PWM_85 = 17, LED_PWM_90 = 18, LED_PWM_95 = 19, 
              LED_PWM_100 = 20
             } LedRateType;

/*! 
@struct LedControlType
@brief Required parameters for the task to track what each LED is doing. 
*/
typedef struct 
{
  LedModeType eMode;              /*!< @brief Current mode */
  LedRateType eRate;              /*!< @brief Current rate */
  u16 u16Count;                   /*!< @brief Value of current duty cycle counter */
  LedPWMDutyType eCurrentDuty;    /*!< @brief Phase of the current duty cycle */
}LedControlType;



/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void LedOn(LedNameType eLED_);
void LedOff(LedNameType eLED_);
void LedToggle(LedNameType eLED_);
void LedBlink(LedNameType eLED_, LedRateType eBlinkRate_);
void LedPWM(LedNameType eLED_, LedRateType ePwmRate_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void LedInitialize(void);
void LedRunActiveState(void);

/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void LedSM_Idle(void);
static void LedSM_Error(void);


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file messaging.h                                                                
@brief Header file for messaging.c
**********************************************************************************************************************/



/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/
/* G_u32MessagingFlags */
/* end G_u32MessagingFlags */


/* Tx buffer allocation: be aware of RAM usage when selecting the parameters below.
Queue size in bytes is U8_TX_QUEUE_SIZE x U16_MAX_TX_MESSAGE_LENGTH */


/*! @cond DOXYGEN_EXCLUDE */
/* Future: possible time-to-live constants for messages in the queue */
/*! @endcond */


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/
/*! 
@enum MessageStateType
@brief Possible statuses of a message in the queue. 
*/
typedef enum {EMPTY = 0, WAITING, SENDING, COMPLETE, TIMEOUT, ABANDONED, FAILED, NOT_FOUND = 0xff} MessageStateType;

/*! 
@enum MessageType
@brief Message struct for data messages 
*/
typedef struct
{
  u32 u32Token;                             /*!< @brief Unique token for this message */
  u32 u32Size;                              /*!< @brief Size of the data payload in bytes */
  u8 pu8Message[(u16)128]; /*!< @brief Data payload array */
  void* psNextMessage;                      /*!< @brief Pointer to next message */
} MessageType;

/*! 
@enum MessageSlotType
@brief Message node in the message list 
*/
typedef struct
{
  bool bFree;                               /*!< @brief TRUE if message slot is available */
  MessageType Message;                      /*!< @brief The slot's message */
} MessageSlotType;

/*! 
@enum MessageStatusType
@brief Message tracking information 
*/
typedef struct
{
  u32 u32Token;                             /*!< @brief Unique token for this message; a token is never 0 */
  MessageStateType eState;                  /*!< @brief State of the message */
  u32 u32Timestamp;                         /*!< @brief Time the message status was posted */          
} MessageStatusType;


/**********************************************************************************************************************
* Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
MessageStateType QueryMessageStatus(u32 u32Token_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void MessagingInitialize(void);
void MessagingRunActiveState(void);

u32 QueueMessage(MessageType** ppeTargetTxBuffer_, u32 u32MessageSize_, u8* pu8MessageData_);
void DeQueueMessage(MessageType** pTargetQueue_);
void UpdateMessageStatus(u32 u32Token_, MessageStateType eNewState_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
static void AddNewMessageStatus(u32 u32Token_);


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void MessagingSM_Idle(void);             
static void MessagingSM_Error(void);         






/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file timer.h                                                                
@brief Header file for timer.c

**********************************************************************************************************************/


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/
/*! 
@enum TimerChannelType
@brief Controlled list of available timer channels used in the member functions. 
*/
typedef enum {TIMER0_CHANNEL0 = 0, TIMER0_CHANNEL1 = 0x40, TIMER0_CHANNEL2 = 0x80} TimerChannelType;



/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void TimerSet(TimerChannelType eTimerChannel_, u16 u16TimerValue_);
void TimerStart(TimerChannelType eTimerChannel_);
void TimerStop(TimerChannelType eTimerChannel_);
u16 TimerGetTime(TimerChannelType eTimerChannel_);
void TimerAssignCallback(TimerChannelType eTimerChannel_, fnCode_type fpUserCallBack_);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void TimerInitialize(void);
void TimerRunActiveState(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
static void TimerDefaultCallback(void);


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void TimerSM_Idle(void);    
static void TimerSM_Error(void);         


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/

/*! @cond DOXYGEN_EXCLUDE */
/*----------------------------------------------------------------------------------------------------------------------
Timer Setup
Internal timer clocks sources are based on MCK (48MHz)
TIMER_CLOCK1 = MCK/2 (41.7ns / tick)
TIMER_CLOCK2 = MCK/8 (167ns / tick)
TIMER_CLOCK3 = MCK/32 (667ns / tick)
TIMER_CLOCK4 = MCK/128 (2.67us / tick)
TIMER_CLOCK5(1) SLCK

PA0 is an open pin available for TIOB0
PA26 is an open pin availble as external clock input TCLK2 if set for Peripheral B function 
PB5 is an open pin available for TIOA1 I/O function if set for Peripheral A 
PB6 is an open pin available for TIOB1 I/O function if set for Peripheral A 

*/

/* Timer Channel 1 Setup */

/* Default Timer 1 interrupt period of just about 100us (1 tick = 2.67us); max 65535 */

/*
    31-04 [0] Reserved

    03 [0] Reserved
    02 [0] SWTRG no software trigger
    01 [1] CLKDIS Clock disabled to start
    00 [0] CLKEN Clock not enabled 
*/

/*
    31 [0] BSWTRG no software trigger effect on TIOB
    30 [0] "
    29 [0] BEEVT no external event effect on TIOB
    28 [0] "

    27 [0] BCPC no RC compare effect on TIOB
    26 [0] "
    25 [0] BCPB no RB compare effect on TIOB
    24 [0] "

    23 [0] ASWTRG no TIOA software trigger effect
    22 [0] "
    21 [0] AEEVT no TIOA effect on external compare
    20 [0] "

    19 [1] ACPC Toggle TIOA on RC compare
    18 [1] "
    17 [0] ACPA No RA compare effect on TIOA
    16 [0] "

    15 [1] WAVE Waveform Mode is enabled
    14 [1] WAVSEL Up to RC mode
    13 [0] "
    12 [0] ENETRG external event has no effect

    11 [0] EEVT external event assigned to XC0
    10 [1] "
    09 [0] EEVTEDG no external event trigger
    08 [0] "

    07 [0] CPCDIS clock is NOT disabled when reaches RC
    06 [0] CPCSTOP clock is NOT stopped when reaches RC
    05 [0] BURST not gated
    04 [0] "

    03 [0] CLKI Counter incremented on rising edge
    02 [0] TCCLKS TIMER_CLOCK4 (MCK/128 = 2.67us / tick)
    01 [1] "
    00 [1] "
*/

/*
    31-08 [0] Reserved 

    07 [0] ETRGS RC Load interrupt not enabled
    06 [0] LDRBS RB Load interrupt not enabled
    05 [0] LDRAS RA Load interrupt not enabled
    04 [1] CPCS RC compare interrupt is enabled

    03 [0] CPBS RB compare interrupt not enabled
    02 [0] CPAS RA Compare Interrupt enabled
    01 [0] LOVRS Lover's bit? Load Overrun interrupt not enabled 
    00 [0] COVFS Counter Overflow interrupt not enabled
*/

/*
    31-08 [0] Reserved 

    07 [1] ETRGS RC Load interrupt disabled
    06 [1] LDRBS RB Load interrupt disabled
    05 [1] LDRAS RA Load interrupt disabled
    04 [0] CPCS RC compare interrupt not disabled

    03 [1] CPBS RB compare interrupt disabled
    02 [1] CPAS RA Compare Interrupt not disabled
    01 [1] LOVRS Lover's bit?!? Load Overrun interrupt disabled 
    00 [1] COVFS Counter Overflow interrupt disabled
*/

/* TC Block Mode Register */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] MAXFILT Filter period is 1 (not used)
    24 [0] "

    23 [0] "
    22 [0] "
    21 [0] "
    20 [1] "

    19 [0] FILTER IDX, PHA, PHB not filtered
    18 [0] Reserved
    17 [0] IDXPHB IDX pin drives TIOA1
    16 [0] SWAP No swap between PHA and PHB

    15 [0] INVIDX IDX directly drives quadrature logic
    14 [0] INVB PHB directly drive quadrature decoder logic
    13 [0] INVA PHA directly drive quadrature decoder logic
    12 [0] EDGPHA Edges detected on PHA

    11 [1] QDTRANS Quadrature decoding logic is inactive
    10 [0] SPEEDEN Speed measure disabled
    09 [0] POSEN Position measure disabled
    08 [0] QDEN Quadrature decoder logic disabled

    07 [0] Reserved
    06 [0] "
    05 [0] TC2XC2S TCLK2 connected to XC2
    04 [0] "

    03 [0] TC1XC1S TCLK1 connected to XC1
    02 [0] "
    01 [0] TC0XC0S TCLK0 connected to XC0
    00 [0] "
*/


/*! @endcond */




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/

/*!**********************************************************************************************************************
@file sam3u_i2c.h                                                                
@brief Header file for sam3u_TWI.c
**********************************************************************************************************************/



/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@enum TwiStopType
@brief Type of behaviour for STOP condition after message. 
*/
typedef enum {TWI_STOP, TWI_NO_STOP, TWI_NA} TwiStopType;


/*! 
@enum TwiDirectionType
@brief Controlled list to specify data transfer bit order. 
*/
typedef enum {TWI_EMPTY, TWI_WRITE, TWI_READ} TwiDirectionType;


/*! 
@struct TwiPeripheralType
@brief User-defined TWI configuration information 
*/
typedef struct 
{
  AT91PS_TWI pBaseAddress;             /*!< @brief Base address of the associated peripheral */
  MessageType* pTransmitBuffer;        /*!< @brief Pointer to the transmit message struct linked list */
  u32 u32PrivateFlags;                 /*!< @brief Private peripheral flags */
} TwiPeripheralType;

/* u32PrivateFlags definitions in TwiPeripheralType */
 
/* end u32PrivateFlags */


/*! 
@struct TwiMessageQueueType
@brief Message-specific information 
*/
typedef struct
{
  u32 u32MessageTaskToken;             /*!< @brief TX ONLY: Token corresponding to Message in message task */
  u32 u32Size;                         /*!< @brief RX ONLY: Size of the transfer */
  u8* pu8RxBuffer;                     /*!< @brief RX ONLY: Pointer to receive buffer in user application */
  u8 u8Address;                        /*!< @brief Slave address */
  TwiDirectionType eDirection;         /*!< @brief Tx/Rx Message Type */
  TwiStopType eStopType;               /*!< @brief TX ONLY: STOP condition behaviour */               
  u8 u8Pad;                       
} TwiMessageQueueType;


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/
/* TWI_u32Flags */


/* end of TWI_u32Flags */




/*! @cond DOXYGEN_EXCLUDE */

/*! @endcond */



/**********************************************************************************************************************
* Function Declarations
**********************************************************************************************************************/

/*-------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
bool TwiReadData(u8 u8SlaveAddress_, u8* pu8RxBuffer_, u32 u32Size_);
u32 TwiWriteData(u8 u8SlaveAddress_, u32 u32Size_, u8* pu8Data_, TwiStopType eStop_);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void TwiInitialize(void);
void TwiRunActiveState(void);
void TwiManualMode(void);

void TWI0_IrqHandler(void);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void TwiSM_Idle(void);

static void TwiSM_Transmit(void);
static void TwiSM_TxWaitComplete(void);

static void TwiSM_PdcReceive(void);
static void TwiSM_ReceiveLastByte(void);
static void TwiSM_ReceiveComplete(void);

static void TwiSM_NextTransferDelay(void);       

static void TwiSM_Error(void);         





/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file sam3u_spi.h                                                                
@brief Header file for sam3u_spi.c
**********************************************************************************************************************/



/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@enum SpiBitOrderType
@brief Controlled list to specify data transfer bit order. 
*/
typedef enum {SPI_MSB_FIRST, SPI_LSB_FIRST} SpiBitOrderType;

/*! 
@enum SpiModeType
@brief Controlled list of SPI modes. 
*/
typedef enum {SPI_MASTER, SPI_SLAVE} SpiModeType;

/*! 
@enum SpiRxStatusType
@brief Controlled list of SPI peripheral Rx status. 
*/
typedef enum {SPI_RX_EMPTY = 0, SPI_RX_WAITING, SPI_RX_RECEIVING, SPI_RX_COMPLETE, SPI_RX_TIMEOUT, SPI_RX_INVALID} SpiRxStatusType;


/*! 
@struct SpiConfigurationType
@brief User-defined SPI configuration information 
*/
typedef struct 
{
  PeripheralType SpiPeripheral;       /*!< @brief Easy name of peripheral */
  AT91PS_PIO pCsGpioAddress;          /*!< @brief Base address for GPIO port for chip select line */
  u32 u32CsPin;                       /*!< @brief Pin location for SSEL line */
  SpiBitOrderType eBitOrder;          /*!< @brief MSB_FIRST or LSB_FIRST: this is only available in SPI_SLAVE_FLOW_CONTROL mode */
  SpiModeType eSpiMode;               /*!< @brief Type of SPI configured */
  u16 u16RxBufferSize;                /*!< @brief Size of receive buffer in bytes */
  u8* pu8RxBufferAddress;             /*!< @brief Address to circular receive buffer */
  u8** ppu8RxNextByte;                /*!< @brief Location of pointer to next byte to write in buffer for SPI_SLAVE_FLOW_CONTROL only */
} SpiConfigurationType;


/*! 
@struct SpiPeripheralType
@brief Full definition of SPI peripheral 
*/
typedef struct 
{
  AT91PS_SPI pBaseAddress;            /*!< @brief Base address of the associated peripheral */
  AT91PS_PIO pCsGpioAddress;          /*!< @brief Base address for GPIO port for chip select line */
  u32 u32CsPin;                       /*!< @brief Pin location for SSEL line */
  SpiBitOrderType eBitOrder;          /*!< @brief MSB_FIRST or LSB_FIRST: this is only available in SPI_SLAVE_FLOW_CONTROL mode */
  SpiModeType eSpiMode;               /*!< @brief Type of SPI configured */
  u8 u8PeripheralId;                  /*!< @brief Simple peripheral ID number */
  u8 u8Pad;                           /*!< @brief Preserve 4-byte alignment */
  u32 u32PrivateFlags;                /*!< @brief Private peripheral flags */
  u8* pu8RxBuffer;                    /*!< @brief Pointer to receive buffer in user application */
  u8** ppu8RxNextByte;                /*!< @brief Pointer to buffer location where next received byte will be placed (SPI_SLAVE_FLOW_CONTROL only) */
  u16 u16RxBufferSize;                /*!< @brief Size of receive buffer in bytes */
  u16 u16RxBytes;                     /*!< @brief Number of bytes to receive */
  MessageType* psTransmitBuffer;      /*!< @brief Pointer to the transmit message struct linked list */
  u32 u32CurrentTxBytesRemaining;     /*!< @brief Counter for bytes remaining in current transfer */
  u8* pu8CurrentTxData;               /*!< @brief Pointer to current location in the Tx buffer */
} SpiPeripheralType;

/* u32PrivateFlags in SpiPeripheralType */
/* end u32PrivateFlags */


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/
/* G_u32Spi0ApplicationFlags */
/* end G_u32Spi0ApplicationFlags */


/* SPI_u32Flags (local SPI application flags) */


/* end of SPI_u32Flags flags */




/**********************************************************************************************************************
* Function Declarations
**********************************************************************************************************************/

/*-------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
SpiPeripheralType* SpiRequest(SpiConfigurationType* psSpiConfig_);
void SpiRelease(SpiPeripheralType* psSpiPeripheral_);

u32 SpiWriteByte(SpiPeripheralType* psSpiPeripheral_, u8 u8Byte_);
u32 SpiWriteData(SpiPeripheralType* psSpiPeripheral_, u32 u32Size_, u8* pu8Data_);

bool SpiReadByte(SpiPeripheralType* psSpiPeripheral_);
bool SpiReadData(SpiPeripheralType* psSpiPeripheral_, u16 u16Size_);
SpiRxStatusType SpiQueryReceiveStatus(SpiPeripheralType* psSpiPeripheral_);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void SpiInitialize(void);
void SpiRunActiveState(void);

void SpiManualMode(void);

void SPI0_IrqHandler(void);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void SpiSM_Idle(void);
static void SpiSM_Error(void);         






/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file sam3u_ssp.h                                                                
@brief Header file for sam3u_ssp.c
**********************************************************************************************************************/



/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@enum SspBitOrderType
@brief Controlled list to specify data transfer bit order. 
*/
typedef enum {SSP_MSB_FIRST, SSP_LSB_FIRST} SspBitOrderType;

/*! 
@enum SspModeType
@brief Controlled list of SSP modes. 
*/
typedef enum {SSP_MASTER_AUTO_CS, SSP_MASTER_MANUAL_CS, SSP_SLAVE, SSP_SLAVE_FLOW_CONTROL} SspModeType;

/*! 
@enum SspRxStatusType
@brief Controlled list of SSP Rx peripheral status. 
*/
typedef enum {SSP_RX_EMPTY = 0, SSP_RX_WAITING, SSP_RX_RECEIVING, SSP_RX_COMPLETE, SSP_RX_TIMEOUT, SSP_RX_INVALID} SspRxStatusType;

/*! 
@struct SspConfigurationType
@brief User-defined SSP configuration information 
*/
typedef struct 
{
  PeripheralType SspPeripheral;       /*!< @brief Easy name of peripheral */
  AT91PS_PIO pCsGpioAddress;          /*!< @brief Base address for GPIO port for chip select line */
  u32 u32CsPin;                       /*!< @brief Pin location for SSEL line */
  SspBitOrderType eBitOrder;          /*!< @brief SSP_MSB_FIRST or SSP_LSB_FIRST: this is only available in SSP_SLAVE_FLOW_CONTROL mode */
  SspModeType eSspMode;               /*!< @brief Type of SPI configured */
  fnCode_type fnSlaveTxFlowCallback;  /*!< @brief Callback function for SSP_SLAVE_FLOW_CONTROL transmit */
  fnCode_type fnSlaveRxFlowCallback;  /*!< @brief Callback function for SSP_SLAVE_FLOW_CONTROL receive */
  u8* pu8RxBufferAddress;             /*!< @brief Address to circular receive buffer */
  u8** ppu8RxNextByte;                /*!< @brief Location of pointer to next byte to write in buffer for SSP_SLAVE_FLOW_CONTROL only */
  u16 u16RxBufferSize;                /*!< @brief Size of receive buffer in bytes */
  u16 u16Pad;                         /*!< @brief Preserve 4-byte alignment */
} SspConfigurationType;


/*! 
@struct SspPeripheralType
@brief Full definition of SSP peripheral 
*/
typedef struct 
{
  AT91PS_USART pBaseAddress;          /*!< @brief Base address of the associated peripheral */
  AT91PS_PIO pCsGpioAddress;          /*!< @brief Base address for GPIO port for chip select line */
  u32 u32CsPin;                       /*!< @brief Pin location for SSEL line */
  SspBitOrderType eBitOrder;          /*!< @brief SSP_MSB_FIRST or SSP_LSB_FIRST: this is only available in SSP_SLAVE_FLOW_CONTROL mode */
  SspModeType eSspMode;               /*!< @brief Type of SPI configured */
  u32 u32PrivateFlags;                /*!< @brief Private peripheral flags */
  fnCode_type fnSlaveTxFlowCallback;  /*!< @brief Callback function for SPI SLAVE transmit that uses flow control */
  fnCode_type fnSlaveRxFlowCallback;  /*!< @brief Callback function for SPI SLAVE receive that uses flow control */
  u8* pu8RxBuffer;                    /*!< @brief Pointer to receive buffer in user application */
  u8** ppu8RxNextByte;                /*!< @brief Pointer to buffer location where next received byte will be placed (SSP_SLAVE_FLOW_CONTROL only) */
  u16 u16RxBufferSize;                /*!< @brief Size of receive buffer in bytes */
  u16 u16RxBytes;                     /*!< @brief Number of bytes to receive (DMA transfers) */
  u8 u8PeripheralId;                  /*!< @brief Simple peripheral ID number */
  u8 u8Pad;                           /*!< @brief Preserve 4-byte alignment */
  u16 u16Pad;                         /*!< @brief Preserve 4-byte alignment */
  MessageType* psTransmitBuffer;      /*!< @brief Pointer to the transmit message struct linked list */
  u32 u32CurrentTxBytesRemaining;     /*!< @brief Counter for bytes remaining in current transfer */
  u8* pu8CurrentTxData;               /*!< @brief Pointer to current location in the Tx buffer */
} SspPeripheralType;

/* u32PrivateFlags in SspPeripheralType */
/* end u32PrivateFlags */


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/
/* G_u32SspxApplicationFlags */
/* end G_u32SspxApplicationFlags */

/* SSP_u32Flags (local SSP application flags) */


/* end of SSP_u32Flags flags */




/**********************************************************************************************************************
* Function Declarations
**********************************************************************************************************************/

/*-------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
SspPeripheralType* SspRequest(SspConfigurationType* psSspConfig_);
void SspRelease(SspPeripheralType* psSspPeripheral_);

void SspAssertCS(SspPeripheralType* psSspPeripheral_);
void SspDeAssertCS(SspPeripheralType* psSspPeripheral_);

u32 SspWriteByte(SspPeripheralType* psSspPeripheral_, u8 u8Byte_);
u32 SspWriteData(SspPeripheralType* psSspPeripheral_, u32 u32Size_, u8* u8Data_);

bool SspReadData(SspPeripheralType* psSspPeripheral_, u16 u16Size_);
bool SspReadByte(SspPeripheralType* psSspPeripheral_);
SspRxStatusType SspQueryReceiveStatus(SspPeripheralType* psSspPeripheral_);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void SspInitialize(void);
void SspRunActiveState(void);

void SspManualMode(void);

void SSP0_IRQHandler(void);
void SSP1_IRQHandler(void);
void SSP2_IRQHandler(void);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
static void SspGenericHandler(void);


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void SspSM_Idle(void);
static void SspSM_Error(void);         






/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file sam3u_uart.h                                                                
@brief Header file for sam3u_uart.c
**********************************************************************************************************************/



/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@struct UartConfigurationType
@brief Task-provided parameters for a UART 
*/
typedef struct 
{
  PeripheralType UartPeripheral;      /*!< @brief Easy name of peripheral */
  u16 u16RxBufferSize;                /*!< @brief Size of receive buffer in bytes */
  u8* pu8RxBufferAddress;             /*!< @brief Address to circular receive buffer */
  u8** pu8RxNextByte;                 /*!< @brief Pointer to buffer location where next received byte will be placed */
  fnCode_type fnRxCallback;           /*!< @brief Callback function for receiving data */
} UartConfigurationType;

/*! 
@struct UartPeripheralType
@brief Complete configuration parameters for a UART resource 
*/
typedef struct 
{
  AT91PS_USART pBaseAddress;          /*!< @brief Base address of the associated peripheral */
  u32 u32PrivateFlags;                /*!< @brief Flags for peripheral */
  MessageType* psTransmitBuffer;      /*!< @brief Pointer to the transmit message linked list */
  u32 u32CurrentTxBytesRemaining;     /*!< @brief Counter for bytes remaining in current transfer */
  u8* pu8CurrentTxData;               /*!< @brief Pointer to current location in the Tx buffer */
  u8* pu8RxBuffer;                    /*!< @brief Pointer to circular receive buffer in user application */
  u8** pu8RxNextByte;                 /*!< @brief Pointer to buffer location where next received byte will be placed */
  fnCode_type fnRxCallback;           /*!< @brief Callback function for receiving data */
  u16 u16RxBufferSize;                /*!< @brief Size of receive buffer in bytes */
  u8 u8PeripheralId;                  /*!< @brief Simple peripheral ID number */
  u8 u8Pad;
} UartPeripheralType;

/* u32PrivateFlags in UartPeripheralType */
/* end u32PrivateFlags */


/**********************************************************************************************************************
* Function Declarations
**********************************************************************************************************************/

/*--------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
UartPeripheralType* UartRequest(UartConfigurationType* psUartConfig_);
void UartRelease(UartPeripheralType* psUartPeripheral_);

u32 UartWriteByte(UartPeripheralType* psUartPeripheral_, u8 u8Byte_);
u32 UartWriteData(UartPeripheralType* psUartPeripheral_, u32 u32Size_, u8* pu8Data_);


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void UartInitialize(void);
void UartRunActiveState(void);

static void UartManualMode(void);

void UART_IRQHandler(void);
void UART0_IRQHandler(void);
void UART1_IRQHandler(void);
void UART2_IRQHandler(void);


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
static void UartGenericHandler(void);


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void UartSM_Idle(void);
static void UartSM_Transmitting(void);
static void UartSM_Error(void);         


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/

/* Uart_u32Flags (local UART application flags) */

/* end of Uart_u32Flags */








/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!**********************************************************************************************************************
@file adc12.h                                                                
@brief Header file for adc12.c
**********************************************************************************************************************/


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@enum Adc12ChannelType
@brief Controlled list of available ADC channels used in the member functions. 
*/
typedef enum {ADC12_CH0 = 0, ADC12_CH1 = 1, ADC12_CH2 = 2, ADC12_CH3 = 3, 
              ADC12_CH4 = 4, ADC12_CH5 = 5, ADC12_CH6 = 6, ADC12_CH7 = 7} Adc12ChannelType;


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*-------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
bool Adc12StartConversion(Adc12ChannelType eAdcChannel_);
void Adc12AssignCallback(Adc12ChannelType eAdcChannel_, fnCode_u16_type pfUserCallback_);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void Adc12Initialize(void);
void Adc12RunActiveState(void);

void ADCC0_IrqHandler(void);


/*-------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*-------------------------------------------------------------------------------------------------------------------*/
void Adc12DefaultCallback(u16 u16Result_);


/**********************************************************************************************************************
State Machine Declarations
**********************************************************************************************************************/
static void Adc12SM_Idle(void);    
static void Adc12SM_Error(void);         


/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/
/*! @cond DOXYGEN_EXCLUDE */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [1] SHTIM set for maximum time to allow for maximum source impedance
    26 [1] "
    25 [1] "
    24 [1] "

    23 [0] STARTUP set for maximum startup time at 1MHz ADC clock
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] "
    18 [1] "
    17 [0] "
    16 [0] "

    15 [0] PRESCAL is 23 (gives 1MHz ADC clock)
    14 [0] "
    13 [0] "
    12 [1] "

    11 [0] "
    10 [1] "
    09 [1] "
    08 [1] "

    07 [0] Reserved
    06 [0] "
    05 [0] SLEEP Normal mode
    04 [0] LOWRES 12-bit resolution

    03 [0] TRGSEL not applicable
    02 [0] "
    01 [0] "
    00 [0] TRGEN Hardware triggers disabled
*/

/*
    31-08 [0] Reserved

    07 [1] CH7 disabled
    06 [1] CH6 disabled
    05 [1] CH5 disabled
    04 [1] CH4 disabled

    03 [1] CH3 disabled
    02 [1] CH2 disabled
    01 [1] CH1 disabled
    00 [1] CH0 disabled
*/

/*
    31 [0] Reserved 
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] "
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] "
    18 [0] "
    17 [0] OFFSET Vrefin/2G
    16 [0] DIFF Single ended mode

    15 [0] Reserved
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] IBCTL Bias current control typical
    08 [1] 

    07 [0] Reserved
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] "
    02 [0] "
    01 [0] GAIN 1
    00 [1] "
*/


/*
    31-24 [0] Reserved

    23 [0] OFF_MODE_STARTUP_TIME target 40us
    22 [0] (4 + 1)*8/1MHz = 40us
    21 [0] "
    20 [0] "

    19 [0] "
    18 [1] "
    17 [0] "
    16 [0] "

    15-4 [0] Reserved

    03 [0] Reserved
    02 [0] "
    01 [0] "
    00 [1] OFFMODES Use off mode
*/

/*
    31 - 20 [0] Reserved

    19 [1] RXBUFF: Receive Buffer Full Interrupt Disabled
    18 [1] ENDRX: End of Receive Buffer Interrupt Disabled
    17 [1] GOVRE: General Overrun Error Interrupt Disabled
    16 [1] DRDY: Data Ready Interrupt Disabled

    15 [1] OVRE7: Overrun Error Interrupt Disabled
    14 [1] OVRE6: Overrun Error Interrupt Disabled
    13 [1] OVRE5: Overrun Error Interrupt Disabled
    12 [1] OVRE4: Overrun Error Interrupt Disabled

    11 [1] OVRE3: Overrun Error Interrupt Disabled
    10 [1] OVRE2: Overrun Error Interrupt Disabled
    09 [1] OVRE1: Overrun Error Interrupt Disabled
    08 [1] OVRE0: Overrun Error Interrupt Disabled

    07 [1] EOC7: End of Conversion Interrupt Disabled
    06 [1] EOC6: End of Conversion Interrupt Disabled
    05 [1] EOC5: End of Conversion Interrupt Disabled
    04 [1] EOC4: End of Conversion Interrupt Disabled

    03 [1] EOC3: End of Conversion Interrupt Disabled
    02 [1] EOC2: End of Conversion Interrupt Disabled
    01 [1] EOC1: End of Conversion Interrupt Disabled
    00 [1] EOC0: End of Conversion Interrupt Disabled
*/

/*! @endcond */





/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/

/* Common application header files */
/*!**********************************************************************************************************************
@file debug.h                                                                
@brief Header file for debug.c
***********************************************************************************************************************/



/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/

/*! 
@struct DebugCommandType
@brief Required members of a Debug command. 
*/
typedef struct
{
  u8 *pu8CommandName;               /*!< @brief Pointer to command mnemonic */
  fnCode_type DebugFunction;        /*!< @brief Function pointer to command function */
} DebugCommandType;


/***********************************************************************************************************************
* Function Declarations
***********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
u32 DebugPrintf(u8* u8String_);
void DebugLineFeed(void);
void DebugPrintNumber(u32 u32Number_);

u8 DebugScanf(u8* pu8Buffer_);

void DebugSetPassthrough(void);
void DebugClearPassthrough(void);

void SystemStatusReport(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void DebugInitialize(void);                   
void DebugRunActiveState(void);

void DebugRxCallback(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
inline static void AdvanceTokenCounter(void);

static void DebugCommandPrepareList(void);
static void DebugCommandDummy(void);

static void DebugCommandLedTestToggle(void);
static void DebugLedTestCharacter(u8 u8Char_);
static void DebugCommandSysTimeToggle(void);




/***********************************************************************************************************************
* State Machine Declarations
***********************************************************************************************************************/
static void DebugSM_Idle(void);                       
static void DebugSM_CheckCmd(void);                   
static void DebugSM_ProcessCmd(void);                 

static void DebugSM_Error(void);


/***********************************************************************************************************************
* Constants / Definitions
***********************************************************************************************************************/


/* G_u32DebugFlags */



/* end of G_u32DebugFlags */


/* Error codes */


/***********************************************************************************************************************
* Command-Specific Definitions
***********************************************************************************************************************/

/* New commands must update the definitions below. Valid commands are in the range
00 - 99.  Command name string is a maximum of DEBUG_CMD_NAME_LENGTH characters. */

/*                              "0123456789ABCDEF0123456789ABCDEF"  Character position reference */










/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!*********************************************************************************************************************
@file music.h      
@brief Definitions for musical notes
***********************************************************************************************************************/

/* Note lengths */


/* Note length adjustments */


/* Musical note definitions */

/* Musical note definitions - short hand */
/*!*********************************************************************************************************************
@file user_app1.h                                                                
@brief Header file for user_app1

----------------------------------------------------------------------------------------------------------------------
To start a new task using this user_app1 as a template:
1. Follow the instructions at the top of user_app1.c
2. Use ctrl-h to find and replace all instances of "user_app1" with "yournewtaskname"
3. Use ctrl-h to find and replace all instances of "UserApp1" with "YourNewTaskName"
4. Use ctrl-h to find and replace all instances of "USER_APP1" with "YOUR_NEW_TASK_NAME"
5. Add #include yournewtaskname.h" to configuration.h
6. Add/update any special configurations required in configuration.h (e.g. peripheral assignment and setup values)
7. Delete this text (between the dashed lines)
----------------------------------------------------------------------------------------------------------------------

**********************************************************************************************************************/


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void UserApp1Initialize(void);
void UserApp1RunActiveState(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void UserApp1SM_Idle(void);    
static void UserApp1SM_Error(void);         



/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/



/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!*********************************************************************************************************************
@file user_app2.h                                                                
@brief Header file for user_app2

----------------------------------------------------------------------------------------------------------------------
To start a new task using this user_app2 as a template:
1. Follow the instructions at the top of user_app2.c
2. Use ctrl-h to find and replace all instances of "user_app2" with "yournewtaskname"
3. Use ctrl-h to find and replace all instances of "UserApp2" with "YourNewTaskName"
4. Use ctrl-h to find and replace all instances of "USER_APP2" with "YOUR_NEW_TASK_NAME"
5. Add #include yournewtaskname.h" to configuration.h
6. Add/update any special configurations required in configuration.h (e.g. peripheral assignment and setup values)
7. Delete this text (between the dashed lines)
----------------------------------------------------------------------------------------------------------------------

**********************************************************************************************************************/


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void UserApp2Initialize(void);
void UserApp2RunActiveState(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void UserApp2SM_Idle(void);    
static void UserApp2SM_Error(void);         



/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/


/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
/*!*********************************************************************************************************************
@file user_app3.h                                                                
@brief Header file for user_app3

----------------------------------------------------------------------------------------------------------------------
To start a new task using this user_app3 as a template:
1. Follow the instructions at the top of user_app3.c
2. Use ctrl-h to find and replace all instances of "user_app3" with "yournewtaskname"
3. Use ctrl-h to find and replace all instances of "UserApp3" with "YourNewTaskName"
4. Use ctrl-h to find and replace all instances of "USER_APP3" with "YOUR_NEW_TASK_NAME"
5. Add #include yournewtaskname.h" to configuration.h
6. Add/update any special configurations required in configuration.h (e.g. peripheral assignment and setup values)
7. Delete this text (between the dashed lines)
----------------------------------------------------------------------------------------------------------------------

**********************************************************************************************************************/


/**********************************************************************************************************************
Type Definitions
**********************************************************************************************************************/


/**********************************************************************************************************************
Function Declarations
**********************************************************************************************************************/

/*------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/
void UserApp3Initialize(void);
void UserApp3RunActiveState(void);


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
State Machine Declarations
***********************************************************************************************************************/
static void UserApp3SM_Idle(void);    
static void UserApp3SM_Error(void);         



/**********************************************************************************************************************
Constants / Definitions
**********************************************************************************************************************/


/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/


/**********************************************************************************************************************
!!!!! External device peripheral assignments
***********************************************************************************************************************/

/* Peripheral assignments */




/* Global status flags for SPI peripherals */


/*! @cond DOXYGEN_EXCLUDE */
/* %UART% Configuration */

/* Debug UART Peripheral Allocation (USART0) */


/* Blade UART Peripheral Allocation (UART) */



/* %SPI% Configuration */

/* %SPI% Blade SPI Peripheral Allocation (SPI0) */




/* %SSP% Configuration */

/* SD SPI Peripheral Allocation (USART1) */




/* ANT SPI Peripheral Allocation (USART2) */



/* %I2C% Configuration */

/* EiE I2C (TWI0) */



/*! @endcond */
/***********************************************************************************************************************
##### UART peripheral board-specific parameters
***********************************************************************************************************************/
/*! @cond DOXYGEN_EXCLUDE */

/*----------------------------------------------------------------------------------------------------------------------
Debug UART Setup

Debug is used for the terminal (serial: 115.2k, 8-N-1) debugging interface.
*/
/* USART Control Register */
/*
    31 - 20 [0] Reserved

    19 [0] RTSDIS/RCS no release/force RTS to 1
    18 [0] RTSEN/FCS no drive/force RTS to 0
    17 [0] DTRDIS no drive DTR to 1
    16 [0] DTREN no drive DTR to 0

    15 [0] RETTO no restart timeout
    14 [0] RSTNACK N/A
    13 [0] RSTIT N/A
    12 [0] SENDA N/A

    11 [0] STTTO no start time-out
    10 [0] STPBRK no stop break
    09 [0] STTBRK no transmit break
    08 [0] RSTSTA status bits not reset

    07 [0] TXDIS transmitter not disabled
    06 [1] TXEN transmitter enabled
    05 [0] RXDIS receiver not disabled
    04 [1] RXEN receiver enabled

    03 [0] RSTTX not reset
    02 [0] RSTRX not reset
    01 [0] Reserved
    00 [0] "
*/

/* USART Mode Register */
/*
    31 [0] ONEBIT start frame delimiter is COMMAND or DATA SYNC
    30 [0] MODSYNC Manchester start bit N/A
    29 [0] MAN Machester encoding disabled
    28 [0] FILTER no filter on Rx line

    27 [0] Reserved
    26 [0] MAX_ITERATION (ISO7816 mode only)
    25 [0] "
    24 [0] "

    23 [0] INVDATA data is not inverted
    22 [0] VAR_SYNC sync field 
    21 [0] DSNACK delicious! NACK is sent on ISO line immediately on parity error
    20 [0] INACK NACK generated (N/A for async)

    19 [0] OVER 16x oversampling
    18 [0] CLKO USART does not drive the SCK pin
    17 [0] MODE9 CHRL defines char length
    16 [0] MSBF/CPOL LSB first

    15 [0] CHMODE normal mode
    14 [0] "
    13 [0] NBSTOP 1 stop bit
    12 [0] "

    11 [1] PAR no parity
    10 [0] "
    09 [0] "
    08 [0] SYNC/CPHA asynchronous

    07 [1] CHRL 8 bits
    06 [1] "
    05 [0] USCLKS MCK
    04 [0] "

    03 [0] USART_MODE normal
    02 [0] "
    01 [0] "
    00 [0] "
*/


/* USART Interrupt Enable Register */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] MANE Manchester Error interrupt not enabled

    23 [0] Reserved
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] CTSIC Clear to Send Change interrupt not enabled
    18 [0] DCDIC Data Carrier Detect Change interrupt not enabled
    17 [0] DSRIC Data Set Ready Change interrupt not enabled
    16 [0] RIIC Ring Inidicator Change interrupt not enabled

    15 [0] Reserved
    14 [0] "
    13 [0] NACK Non Ack interrupt not enabled
    12 [0] RXBUFF Reception Buffer Full (PDC) interrupt not enabled

    11 [0] TXBUFE Transmission Buffer Empty (PDC) interrupt not enabled
    10 [0] ITER/UNRE Max number of Repetitions Reached interrupt not enabled
    09 [0] TXEMPTY Transmitter Empty interrupt not enabled (yet)
    08 [0] TIMEOUT Receiver Time-out interrupt not enabled

    07 [0] PARE Parity Error interrupt not enabled
    06 [0] FRAME Framing Error interrupt not enabled
    05 [0] OVRE Overrun Error interrupt not enabled
    04 [0] ENDTX End of Transmitter Transfer (PDC) interrupt not enabled yet

    03 [1] ENDRX End of Receiver Transfer (PDC) interrupt enabled
    02 [0] RXBRK Break Received interrupt not enabled
    01 [0] TXRDY Transmitter Ready interrupt not enabled
    00 [0] RXRDY Receiver Ready interrupt enabled
*/

/* USART Interrupt Disable Register */

/* USART Baud Rate Generator Register 
BAUD = MCK / (8(2-OVER)(CD + FP / 8))
=> CD = (MCK / (8(2-OVER)BAUD)) - (FP / 8)
MCK = 48MHz
OVER = 0 (16-bit oversampling)

BAUD desired = 38400 bps
=> CD = 78.125 - (FP / 8)
Set FP = 1, CD = 78 = 0x4E

BAUD desired = 115200 bps
=> CD = 26.042 - (FP / 8)
Set FP = 0, CD = 26 = 0x1A

*/
/*
    31-20 [0] Reserved

    19 [0] Reserved
    18 [0] FP = 0
    17 [0] "
    16 [0] "

    15 [0] CD = 26 = 0x1A
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [1] "

    03 [1] "
    02 [0] "
    01 [1] "
    00 [0] "
*/


/*----------------------------------------------------------------------------------------------------------------------
Blade UART Setup

The Blade UART is used for the daughter board interface (serial: 115.2k, 8-N-1) .
*/
/* USART Control Register */
/*
    31 - 20 [0] Reserved

    19 [0] RTSDIS/RCS no release/force RTS to 1
    18 [0] RTSEN/FCS no drive/force RTS to 0
    17 [0] DTRDIS no drive DTR to 1
    16 [0] DTREN no drive DTR to 0

    15 [0] RETTO no restart timeout
    14 [0] RSTNACK N/A
    13 [0] RSTIT N/A
    12 [0] SENDA N/A

    11 [0] STTTO no start time-out
    10 [0] STPBRK no stop break
    09 [0] STTBRK no transmit break
    08 [0] RSTSTA status bits not reset

    07 [0] TXDIS transmitter not disabled
    06 [1] TXEN transmitter enabled
    05 [0] RXDIS receiver not disabled
    04 [1] RXEN receiver enabled

    03 [0] RSTTX not reset
    02 [0] RSTRX not reset
    01 [0] Reserved
    00 [0] "
*/

/* USART Mode Register */
/*
    31 [0] ONEBIT start frame delimiter is COMMAND or DATA SYNC
    30 [0] MODSYNC Manchester start bit N/A
    29 [0] MAN Machester encoding disabled
    28 [0] FILTER no filter on Rx line

    27 [0] Reserved
    26 [0] MAX_ITERATION (ISO7816 mode only)
    25 [0] "
    24 [0] "

    23 [0] INVDATA data is not inverted
    22 [0] VAR_SYNC sync field 
    21 [0] DSNACK delicious! NACK is sent on ISO line immeidately on parity error
    20 [0] INACK NACK generated (N/A for async)

    19 [0] OVER 16x oversampling
    18 [0] CLKO USART does not drive the SCK pin
    17 [0] MODE9 CHRL defines char length
    16 [0] MSBF/CPOL LSB first

    15 [0] CHMODE normal mode
    14 [0] "
    13 [0] NBSTOP 1 stop bit
    12 [0] "

    11 [1] PAR no parity
    10 [0] "
    09 [0] "
    08 [0] SYNC/CPHA asynchronous

    07 [1] CHRL 8 bits
    06 [1] "
    05 [0] USCLKS MCK
    04 [0] "

    03 [0] USART_MODE normal
    02 [0] "
    01 [0] "
    00 [0] "
*/


/* USART Interrupt Enable Register */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] MANE Manchester Error interrupt not enabled

    23 [0] Reserved
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] CTSIC Clear to Send Change interrupt not enabled
    18 [0] DCDIC Data Carrier Detect Change interrupt not enabled
    17 [0] DSRIC Data Set Ready Change interrupt not enabled
    16 [0] RIIC Ring Inidicator Change interrupt not enabled

    15 [0] Reserved
    14 [0] "
    13 [0] NACK Non Ack interrupt not enabled
    12 [0] RXBUFF Reception Buffer Full (PDC) interrupt not enabled

    11 [0] TXBUFE Transmission Buffer Empty (PDC) interrupt not enabled
    10 [0] ITER/UNRE Max number of Repetitions Reached interrupt not enabled
    09 [0] TXEMPTY Transmitter Empty interrupt not enabled (yet)
    08 [0] TIMEOUT Receiver Time-out interrupt not enabled

    07 [0] PARE Parity Error interrupt not enabled
    06 [0] FRAME Framing Error interrupt not enabled
    05 [0] OVRE Overrun Error interrupt not enabled
    04 [0] ENDTX End of Transmitter Transfer (PDC) interrupt not enabled yet

    03 [1] ENDRX End of Receiver Transfer (PDC) interrupt enabled
    02 [0] RXBRK Break Received interrupt not enabled
    01 [0] TXRDY Transmitter Ready interrupt not enabled
    00 [0] RXRDY Receiver Ready interrupt not enabled
*/

/* USART Interrupt Disable Register */

/* USART Baud Rate Generator Register
BAUD = MCK / (8(2-OVER)(CD + FP / 8))
=> CD = (MCK / (8(2-OVER)BAUD)) - (FP / 8)
MCK = 48MHz
OVER = 0 (16-bit oversampling)

BAUD desired = 115200 bps
=> CD = 26.042 - (FP / 8)
Set FP = 0, CD = 26

*/
/*
    31-20 [0] Reserved

    19 [0] Reserved
    18 [0] FP = 0
    17 [0] "
    16 [0] "

    15 [0] CD = 26 = 0x1A
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [0] "
    04 [1] "

    03 [1] "
    02 [0] "
    01 [1] "
    00 [0] "
*/


/*! @endcond */
/***********************************************************************************************************************
$$$$$ SPI peripheral board-specific parameters
***********************************************************************************************************************/
/*! @cond DOXYGEN_EXCLUDE */

/*----------------------------------------------------------------------------------------------------------------------
Blade SPI Setup 

SPI mode to communicate with a Slave device on the Blade connector. 
*/
/* SPI Control Register */
/*
    31 - 28 [0] Reserved

    27 [0] Reserved
    26 [0] "
    25 [0] "
    24 [0] LASTXFER not required

    23 - 8 [0] Reserved

    07 [0] SWRST not reset
    06 [0] Reserved
    05 [0] "
    04 [0] "

    03 [0] Reserved
    02 [0] "
    01 [1] SPIDIS SPI disabled for now
    00 [0] SPIEN SPI not enabled yet
*/

/* SPI Mode Register */
/*
    31 [0] DLYBCS Delay Between Chip Selects not applicable
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] "

    23 [0] Reserved
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] PCS Peripheral Chip Select select CS0
    18 [0] "
    17 [0] "
    16 [0] "

    15 - 08 [0] Reserved 

    07 [0] LLB Local Loopback disabled
    06 [0] Reserved
    05 [1] WDRBT Wait Data Before Transfer enabled
    04 [0] MODFDIS Mode Fault not disabled

    03 [0] Reserved
    02 [0] PCSDEC chip select direct connect
    01 [0] PS Fixed Peripheral Select
    00 [1] MSTR Master mode
*/

/* SPI Interrupt Enable Register */
/*
    31 - 12 [0] Reserved 

    11 [0] Reserved
    10 [0] UNDES not enabled
    09 [0] TXEMPTY not enabled
    08 [0] NSSR not enabled

    07 [0] Reserved
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] OVRES not enabled
    02 [0] MODF not enabled
    01 [0] TDRE not enabled yet
    00 [0] RDRF not enabled yet
*/

/* SPI Interrupt Disable Register  */

/* SPI Baud Rate Generator Register
BAUD = MCK / SCBR 
=> SCBR = MCK / BAUD
BAUD desired = 1 Mbps
=> SCBR = 48

Delay before SPCK: target 10us
DLYBS = SPCK x MCK = 10us x 48MHz = 480

Delay between transfers: target 3us (3 clock ticks)
Delay = (32 x DLYBCT) / MCK
DLYBCT = (3us x 48MHz) / 32
DLYBCT = 4.5 (round up to 5)
*/
/*
    31 [0] DLYBCT Delay between transfers = 5 (0x05)
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [1] "
    25 [0] "
    24 [1] "

    23 [0] DLYBS Delay before SCK 1us => 48 (0x30)
    22 [0] "
    21 [1] "
    20 [1] "

    19 [0] "
    18 [0] "
    17 [0] "
    16 [0] "

    15 [0] SCBR Serial clock baud rate => 48 (0x30)
    14 [0] "
    13 [1] "
    12 [1] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] BITS 8 bits per transfer
    06 [0] "
    05 [0] "
    04 [0] "

    03 [0] CSAAT CS rises after data tranfer
    02 [0] CSNAAT CS not active after transfer 
    01 [0] NCPHA Clock phase leading edge
    00 [1] CPOL Clock polarity high when inactive
*/

/* Only a single Slave is used, so other CSRs are the same as CSR0 */

/*! @endcond */
/***********************************************************************************************************************
%%%%% SSP peripheral board-specific parameters
***********************************************************************************************************************/
/*! @cond DOXYGEN_EXCLUDE */

/*----------------------------------------------------------------------------------------------------------------------
EIE_ASCII ASCII board SD USART Setup in SSP mode

SPI mode to communicate with an SPI SD card. 
*/
/* USART Control Register */
/*
    31 - 20 [0] Reserved

    19 [0] RTSDIS/RCS no release/force RTS to 1
    18 [0] RTSEN/FCS no drive/force RTS to 0
    17 [0] DTRDIS no drive DTR to 1
    16 [0] DTREN no drive DTR to 0

    15 [0] RETTO no restart timeout
    14 [0] RSTNACK N/A
    13 [0] RSTIT N/A
    12 [0] SENDA N/A

    11 [0] STTTO no start time-out
    10 [0] STPBRK no stop break
    09 [0] STTBRK no transmit break
    08 [0] RSTSTA status bits not reset

    07 [0] TXDIS transmitter not disabled
    06 [1] TXEN transmitter enabled
    05 [0] RXDIS receiver not disabled
    04 [1] RXEN receiver enabled

    03 [0] RSTTX not reset
    02 [0] RSTRX not reset
    01 [0] Reserved
    00 [0] "
*/

/* USART Mode Register */
/*
    31 [0] ONEBIT start frame delimiter is COMMAND or DATA SYNC
    30 [0] MODSYNC Manchester start bit N/A
    29 [0] MAN Machester encoding disabled
    28 [0] FILTER no filter on Rx line

    27 [0] Reserved
    26 [0] MAX_ITERATION (ISO7816 mode only)
    25 [0] "
    24 [0] "

    23 [0] INVDATA data is not inverted
    22 [1] VAR_SYNC sync field is updated on char to US_THR
    21 [0] DSNACK delicious! NACK is sent on ISO line immeidately on parity error
    20 [0] INACK transmission starts as oons as byte is written to US_THR

    19 [0] OVER 16x oversampling
    18 [1] CLKO USART drives the SCK pin
    17 [0] MODE9 CHRL defines char length
    16 [1] CPOL clock is high when inactive

    15 [0] CHMODE normal mode
    14 [0] "
    13 [0] NBSTOP N/A
    12 [1] "

    11 [1] PAR no parity
    10 [0] "
    09 [0] "
    08 [0] CPHA data captured on leading edge of SPCK (first high to low transition does not count)

    07 [1] CHRL 8 bits
    06 [1] "
    05 [0] USCLKS MCK
    04 [0] "

    03 [1] USART_MODE SPI Master
    02 [1] "
    01 [1] "
    00 [0] "
*/


/* USART Interrupt Enable Register */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] MANE Manchester Error interrupt not enabled

    23 [0] Reserved
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] CTSIC Clear to Send Change interrupt not enabled
    18 [0] DCDIC Data Carrier Detect Change interrupt not enabled
    17 [0] DSRIC Data Set Ready Change interrupt not enabled
    16 [0] RIIC Ring Inidicator Change interrupt not enabled

    15 [0] Reserved
    14 [0] "
    13 [0] NACK Non Ack interrupt not enabled
    12 [0] RXBUFF Reception Buffer Full (PDC) interrupt not enabled

    11 [0] TXBUFE Transmission Buffer Empty (PDC) interrupt not enabled
    10 [0] ITER/UNRE Max number of Repetitions Reached interrupt not enabled
    09 [0] TXEMPTY Transmitter Empty interrupt not enabled (yet)
    08 [0] TIMEOUT Receiver Time-out interrupt not enabled

    07 [0] PARE Parity Error interrupt not enabled
    06 [0] FRAME Framing Error interrupt not enabled
    05 [0] OVRE Overrun Error interrupt not enabled
    04 [0] ENDTX End of Transmitter Transfer (PDC) interrupt not enabled for now

    03 [0] ENDRX End of Receiver Transfer (PDC) interrupt not enabled for now
    02 [0] RXBRK Break Received interrupt not enabled
    01 [0] TXRDY Transmitter Ready interrupt not enabled
    00 [0] RXRDY Receiver Ready interrupt not enabled
*/

/* USART Interrupt Disable Register  */

/* USART Baud Rate Generator Register
BAUD = MCK / CD 
=> CD = MCK / BAUD
BAUD desired = 1 Mbps
=> CD = 48
*/
/*
    31-20 [0] Reserved

    19 [0] Reserved
    18 [0] FP baud disabled
    17 [0] "
    16 [0] "

    15 [0] CD = 48 = 0x30
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [1] "
    04 [1] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] "
*/


/*----------------------------------------------------------------------------------------------------------------------
EIE_DOTMATRIX Dot Matrix LCD USART Setup in SSP mode

SPI mode to communicate with an SPI LCD screen. 
*/
/* USART Control Register - Page 734 */
/*
    31 - 20 [0] Reserved

    19 [0] RTSDIS/RCS no release/force RTS to 1
    18 [0] RTSEN/FCS no drive/force RTS to 0
    17 [0] DTRDIS no drive DTR to 1
    16 [0] DTREN no drive DTR to 0

    15 [0] RETTO no restart timeout
    14 [0] RSTNACK N/A
    13 [0] RSTIT N/A
    12 [0] SENDA N/A

    11 [0] STTTO no start time-out
    10 [0] STPBRK no stop break
    09 [0] STTBRK no transmit break
    08 [0] RSTSTA status bits not reset

    07 [0] TXDIS transmitter not disabled
    06 [1] TXEN transmitter enabled
    05 [1] RXDIS receiver disabled
    04 [0] RXEN receiver not enabled

    03 [0] RSTTX not reset
    02 [0] RSTRX not reset
    01 [0] Reserved
    00 [0] "
*/

/* USART Mode Register - page 737 */
/*
    31 [0] ONEBIT start frame delimiter is COMMAND or DATA SYNC
    30 [0] MODSYNC Manchester start bit N/A
    29 [0] MAN Machester encoding disabled
    28 [0] FILTER no filter on Rx line

    27 [0] Reserved
    26 [0] MAX_ITERATION (ISO7816 mode only)
    25 [0] "
    24 [0] "

    23 [0] INVDATA data is not inverted
    22 [1] VAR_SYNC sync field is updated on char to US_THR
    21 [0] DSNACK delicious! NACK is sent on ISO line immeidately on parity error
    20 [0] INACK transmission starts as oons as byte is written to US_THR

    19 [0] OVER 16x oversampling
    18 [1] CLKO USART drives the SCK pin
    17 [0] MODE9 CHRL defines char length
    16 [1] CPOL clock is high when inactive

    15 [0] CHMODE normal mode
    14 [0] "
    13 [0] NBSTOP N/A
    12 [1] "

    11 [1] PAR no parity
    10 [0] "
    09 [0] "
    08 [0] CPHA data captured on leading edge of SPCK (first high to low transition does not count)

    07 [1] CHRL 8 bits
    06 [1] "
    05 [0] USCLKS MCK
    04 [0] "

    03 [1] USART_MODE SPI Master
    02 [1] "
    01 [1] "
    00 [0] "
*/


/* USART Interrupt Enable Register - Page 741 */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] MANE Manchester Error interrupt not enabled

    23 [0] Reserved
    22 [0] "
    21 [0] "
    20 [0] "

    19 [0] CTSIC Clear to Send Change interrupt not enabled
    18 [0] DCDIC Data Carrier Detect Change interrupt not enabled
    17 [0] DSRIC Data Set Ready Change interrupt not enabled
    16 [0] RIIC Ring Inidicator Change interrupt not enabled

    15 [0] Reserved
    14 [0] "
    13 [0] NACK Non Ack interrupt not enabled
    12 [0] RXBUFF Reception Buffer Full (PDC) interrupt not enabled

    11 [0] TXBUFE Transmission Buffer Empty (PDC) interrupt not enabled
    10 [0] ITER/UNRE Max number of Repetitions Reached interrupt not enabled
    09 [0] TXEMPTY Transmitter Empty interrupt not enabled (yet)
    08 [0] TIMEOUT Receiver Time-out interrupt not enabled

    07 [0] PARE Parity Error interrupt not enabled
    06 [0] FRAME Framing Error interrupt not enabled
    05 [0] OVRE Overrun Error interrupt not enabled
    04 [0] ENDTX End of Transmitter Transfer (PDC) interrupt not enabled for now

    03 [0] ENDRX End of Receiver Transfer (PDC) interrupt not enabled
    02 [0] RXBRK Break Received interrupt not enabled
    01 [0] TXRDY Transmitter Ready interrupt not enabled
    00 [0] RXRDY Receiver Ready interrupt not enabled
*/

/* USART Interrupt Disable Register - Page 743 */

/* USART Baud Rate Generator Register - Page 752
BAUD = MCK / CD 
=> CD = MCK / BAUD
BAUD desired = 1 Mbps
=> CD = 48
*/
/*
    31-20 [0] Reserved

    19 [0] Reserved
    18 [0] FP baud disabled
    17 [0] "
    16 [0] "

    15 [0] CD = 48 = 0x30
    14 [0] "
    13 [0] "
    12 [0] "

    11 [0] "
    10 [0] "
    09 [0] "
    08 [0] "

    07 [0] "
    06 [0] "
    05 [1] "
    04 [1] "

    03 [0] "
    02 [0] "
    01 [0] "
    00 [0] "
*/


/*----------------------------------------------------------------------------------------------------------------------
ANT USART Setup in SSP
SPI slave mode to communicate with an ANT device. 
*/
/* USART Control Register */
/*
    31 - 20 [0] Reserved

    19 [0] RTSDIS/RCS no release/force RTS to 1
    18 [0] RTSEN/FCS no drive/force RTS to 0
    17 [0] DTRDIS no drive DTR to 1
    16 [0] DTREN no drive DTR to 0

    15 [0] RETTO no restart timeout
    14 [0] RSTNACK N/A
    13 [0] RSTIT N/A
    12 [0] SENDA N/A

    11 [0] STTTO no start time-out
    10 [0] STPBRK no stop break
    09 [0] STTBRK no transmit break
    08 [0] RSTSTA status bits not reset

    07 [0] TXDIS transmitter not disabled
    06 [1] TXEN transmitter enabled
    05 [0] RXDIS receiver not disabled
    04 [1] RXEN receiver enabled

    03 [0] RSTTX not reset
    02 [0] RSTRX not reset
    01 [0] Reserved
    00 [0] "
*/

/* USART Mode Register */
/*
    31 [0] ONEBIT start frame delimiter is COMMAND or DATA SYNC
    30 [0] MODSYNC Manchester start bit N/A
    29 [0] MAN Machester encoding disabled
    28 [0] FILTER no filter on Rx line

    27 [0] Reserved
    26 [0] MAX_ITERATION (ISO7816 mode only)
    25 [0] "
    24 [0] "

    23 [0] INVDATA data is not inverted
    22 [1] VAR_SYNC sync field is updated on char to US_THR
    21 [0] DSNACK (delicious!) NACK is sent on ISO line immeidately on parity error
    20 [0] INACK transmission starts as soon as byte is written to US_THR

    19 [0] OVER 16x oversampling
    18 [0] CLKO USART does not drive the SCK pin
    17 [0] MODE9 CHRL defines char length
    16 [1] CPOL clock is high when inactive

    15 [0] CHMODE normal mode
    14 [0] "
    13 [0] NBSTOP N/A
    12 [1] "

    11 [1] PAR no parity
    10 [0] "
    09 [0] "
    08 [0] CPHA data captured on leading edge of SPCK (first high to low transition does not count)

    07 [1] CHRL 8 bits
    06 [1] "
    05 [1] USCLKS SCK
    04 [1] "

    03 [1] USART_MODE SPI Slave
    02 [1] "
    01 [1] "
    00 [1] "
*/


/* USART Interrupt Enable Register */
/*
    31 [0] Reserved
    30 [0] "
    29 [0] "
    28 [0] "

    27 [0] "
    26 [0] "
    25 [0] "
    24 [0] MANE Manchester Error interrupt not enabled

    23 [0] Reserved
    22 [0] "
    21 [0] "
    20 [0] "

    19 [1] CTSIC Clear to Send Change interrupt enabled 
    18 [0] DCDIC Data Carrier Detect Change interrupt not enabled
    17 [0] DSRIC Data Set Ready Change interrupt not enabled
    16 [0] RIIC Ring Inidicator Change interrupt not enabled

    15 [0] Reserved
    14 [0] "
    13 [0] NACK Non Ack interrupt not enabled
    12 [0] RXBUFF Reception Buffer Full (PDC) interrupt not enabled 

    11 [0] TXBUFE Transmission Buffer Empty (PDC) interrupt not enabled
    10 [0] ITER/UNRE Max number of Repetitions Reached interrupt not enabled
    09 [0] TXEMPTY Transmitter Empty interrupt not enabled (yet)
    08 [0] TIMEOUT Receiver Time-out interrupt not enabled

    07 [0] PARE Parity Error interrupt not enabled
    06 [0] FRAME Framing Error interrupt not enabled
    05 [0] OVRE Overrun Error interrupt not enabled
    04 [0] ENDTX End of Transmitter Transfer (PDC) interrupt not enabled 

    03 [0] ENDRX End of Receiver Transfer (PDC) interrupt not enabled
    02 [0] RXBRK Break Received interrupt not enabled
    01 [0] TXRDY Transmitter Ready interrupt not enabled YET
    00 [0] RXRDY Receiver Ready interrupt enabled 
*/

/* USART Interrupt Disable Register */

/* USART Baud Rate Generator Register 
!!!!! Not applicable for Slave (note that incoming clock cannot 
exceed MCLK/6 = 8MHz.  To date, ANT devices communicate at 500kHz
or 2MHz, so no issues.
*/


/*! @endcond */
/***********************************************************************************************************************
^^^^^ I²C (TWI) peripheral board-specific parameters
***********************************************************************************************************************/
/*! @cond DOXYGEN_EXCLUDE */

/*----------------------------------------------------------------------------------------------------------------------
I²C Master mode for EiE development board (TWI0)
ASCII: LCD and Blade
Dot Matrix: Blade and R01 EIE_DOTMATRIX accelerometer
*/

/* Control Register */
/*
    31-8 [0] Reserved

    07 [0] SWRST - Software reset
    06 [0] QUICK - SMBUS Quick Command
    05 [1] SVDIS - Slave mode disabled
    04 [0] SVEN - Slave mode enable

    03 [0] MSDIS - Master mode disable
    02 [1] MSEN - Master mode enable
    01 [0] STOP - Stop a transfer
    00 [0] START - Start a transfer
*/

/* Master Mode Register */
/*
    31-24 [0] Reserved
    
    23 [0] Reserved
    22 [0] DADR - device Slave address - start with zero
    21 [0] "
    20 [0] "

    19 [0] "
    18 [0] "
    17 [0] "
    16 [0] "

    15 [0] Reserved
    14 [0] "
    13 [0] "
    12 [0] MREAD - Master Read Direction - 0 -> Write, 1 -> Read

    11 [0] Reserved
    10 [0] "
    09 [0] IADRSZ - Internal device address - 0 = no internal device address
    08 [0] "

    07-00 [0] Reserved
*/

/* Clock Wave Generator Register */
/* 
    Calculation:
        T_low = ((CLDIV * (2^CKDIV))+4) * T_MCK
        T_high = ((CHDIV * (2^CKDIV))+4) * T_MCK

        T_MCK - period of master clock = 1/(48 MHz)
        T_low/T_high - period of the low and high signals
        
        CKDIV = 2, CHDIV and CLDIV = 59
        T_low/T_high = 2.5 microseconds

        Data frequency - 
        f = ((T_low + T_high)^-1)
        f = 200000 Hz 0r 200 kHz

    Additional Rates:
        50 kHz - 0x00027777
       100 kHz - 0x00023B3B
       200 kHz - 0x00021D1D
       400 kHz - 0x00030707  *Maximum rate*
*/
/*
    31-20 [0] Reserved
    
    19 [0] Reserved
    18 [0] CKDIV
    17 [1] "
    16 [0] "

    15 [0] CHDIV
    14 [0] "
    13 [0] "
    12 [1] "

    11 [1] "
    10 [1] "
    09 [0] "
    08 [1] "

    07 [0] CLDIV - Clock Low Divider
    06 [0] "
    05 [0] "
    04 [1] "

    03 [1] "
    02 [1] "
    01 [0] "
    00 [1] "
*/

/*Interrupt Enable Register*/
/*
    31-16 [0] Reserved

    15 [0] TXBUFE - Transmit Buffer Empty
    14 [0] RXBUFF - Receive Buffer Full
    13 [0] ENDTX - End of Transmit Buffer not enabled yet
    12 [0] ENDRX - End of Receive Buffer not enabled yet

    11 [0] EOSACC - End of Slave Address
    10 [0] SCL_WS - Clock Wait State
    09 [0] ARBLST - Arbitration Lost
    08 [1] NACK - Not Acknowledge

    07 [0] Reserved
    06 [0] OVRE - Overrun Error
    05 [0] GACC - General Call Access
    04 [0] SVACC - Slave Access

    03 [0] Reserved
    02 [0] TXRDY - Transmit Holding Register Ready
    01 [0] RXRDY - Receive Holding Register Ready
    00 [0] TXCOMP - Transmission Completed
*/





/*! @endcond */
/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/


/***********************************************************************************************************************
Global variable definitions with scope across entire project.
All Global variable names shall start with "G_<type>Messaging"
***********************************************************************************************************************/
/* New variables */
u32 G_u32MessagingFlags;                               /*!< @brief Global state flags */


/*--------------------------------------------------------------------------------------------------------------------*/
/* Existing variables (defined in other files -- should all contain the "extern" keyword) */
extern volatile u32 G_u32SystemTime1ms;                /*!< @brief From main.c */
extern volatile u32 G_u32SystemTime1s;                 /*!< @brief From main.c */
extern volatile u32 G_u32SystemFlags;                  /*!< @brief From main.c */
extern volatile u32 G_u32ApplicationFlags;             /*!< @brief From main.c */


/***********************************************************************************************************************
Global variable definitions with scope limited to this local application.
Variable names shall start with "Msg_<type>" and be declared as static.
***********************************************************************************************************************/
static fnCode_type Messaging_pfnStateMachine;          /*!< @brief The state machine function pointer */

static u32 Msg_u32Token;                               /*!< @brief Incrementing message token used for all external communications */

static MessageSlotType Msg_asPool[(u8)32];   /*!< @brief Array of MessageSlotType used for the transmit queue */
static u8 Msg_u8QueuedMessageCount;                    /*!< @brief Number of messages slots currently occupied */

/* A separate status queue needs to be maintained since the message information in Msg_asPool will be lost when the message
has been dequeued.  Applications must be able to query to determine the status of their message, particularly if
it has been sent. */
static MessageStatusType  Msg_asStatusQueue[(u8)(2 * (u8)32)]; /*!< @brief Array of MessageStatusType used to monitor message status */
static MessageStatusType* Msg_psNextStatus;                        /*!< @brief Pointer to next available message status */



/**********************************************************************************************************************
Function Definitions
**********************************************************************************************************************/

/*--------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/

/*!---------------------------------------------------------------------------------------------------------------------
@fn MessageStateType QueryMessageStatus(u32 u32Token_)

@brief Checks the state of a message and returns the current MessageStateType

If the state is COMPLETE, TIMEOUT or ABANDONED, calling this function
forces the associated status to be cleared from the message queue.
Since the queue is quite short, most of the time it will hold very little entries.  
New entries are always filled at the front, using a simple linear search starting at index 0.

Requires:
@param u32Token_ is the token (ID) of the message of interest

Promises:
- Returns MessageStateType indicating the status of the message
- if the message is found in COMPLETE, TIMEOUT, or ABANDONED state, the status is removed from
the queue and time-stamped for debugging purposes.

*/
MessageStateType QueryMessageStatus(u32 u32Token_)
{
  MessageStateType eStatus = NOT_FOUND;
  MessageStatusType* pListParser = &Msg_asStatusQueue[0];
  
  /* Brute force search for the token - the queue will never be large enough on this system to require a more
  intelligent search algorithm */
  while( (pListParser->u32Token != u32Token_) && 
         (pListParser != &Msg_asStatusQueue[(u8)(2 * (u8)32)]) )
  {
    pListParser++;
  }

  /* If the token was found pListParser is pointing at it, take appropriate action */
  if(pListParser != &Msg_asStatusQueue[(u8)(2 * (u8)32)])
  {
    /* Save the status */
    eStatus = pListParser->eState;

    /* Release the slot if the message state is final (the client must deal with it now) */
    if( (eStatus == COMPLETE) || (eStatus == TIMEOUT) || (eStatus == ABANDONED) )
    {
      pListParser->u32Token = 0;
      pListParser->eState = EMPTY;
      pListParser->u32Timestamp = G_u32SystemTime1ms;
    }
  }

  /* If the message was not found, the state is already set correctly, so just return */
  return(eStatus);
  
} /* end QueryMessageStatus() */


/*--------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/

/*!--------------------------------------------------------------------------------------------------------------------
@fn void MessagingInitialize(void)

@brief Runs required initialization for the task.  

Should only be called once in main init section.

Requires:
- No messaging in progress

Promises:
- Message queues are zeroed
- Flags and state machine are initialized

*/
void MessagingInitialize(void)
{
  /* Initialize variables */
  Msg_u8QueuedMessageCount = 0;
  Msg_u32Token = 1;

  /* Ensure all message slots are deallocated and the message status queue is empty */
  for(u8 i = 0; i < (u8)32; i++)
  {
    /* Clear the Slot value */
    Msg_asPool[i].bFree = TRUE;
    
    /* Clear the slot's message values */
    Msg_asPool[i].Message.u32Token = 0;
    Msg_asPool[i].Message.u32Size = 0;
    Msg_asPool[i].Message.psNextMessage = 0;
    
    /* Clear the slot's message's contents */
    for(u16 j = 0; j < (u16)128; j++)
    {
      *(Msg_asPool[i].Message.pu8Message + j) = 0;
    }
  }

  /* Clear the message status queue */
  for(u8 i = 0; i < (u8)(2 * (u8)32); i++)
  {
    Msg_asStatusQueue[i].u32Token = 0;
    Msg_asStatusQueue[i].eState = EMPTY;
    Msg_asStatusQueue[i].u32Timestamp = 0;
  }

  Msg_psNextStatus = &Msg_asStatusQueue[0];

  G_u32MessagingFlags = 0;
  Messaging_pfnStateMachine = MessagingSM_Idle;

} /* end MessagingInitialize() */


/*!--------------------------------------------------------------------------------------------------------------------
@fn void MessagingRunActiveState(void)

@brief Selects and runs one iteration of the current state in the state machine.

All state machines have a TOTAL of 1ms to execute, so on average n state machines
may take 1ms / n to execute.

Requires:
- State machine function pointer points at current state

Promises:
- Calls the function to pointed by the state machine function pointer

*/
void MessagingRunActiveState(void)
{
  Messaging_pfnStateMachine();

} /* end MessagingRunActiveState */


/*!--------------------------------------------------------------------------------------------------------------------
@fn u32 QueueMessage(MessageType** ppsTargetTxBuffer_, u32 u32MessageSize_, u8* pu8MessageData_)

@brief Allocates one of the positions in the message queue to the calling function's send queue.

Requires:
- Msg_asPool should not be full 

@param  ppsTargetTxBuffer_ is the peripheral transmit buffer where the message will be queued
@param  u32MessageSize_ is the size of the message data array in bytes
@param  pu8MessageData_ points to the message data array

Promises:
- The message is inserted into the target list and assigned a token
- If the message is created successfully, the message token is returned; otherwise, NULL is returned

*/
u32 QueueMessage(MessageType** ppsTargetTxBuffer_, u32 u32MessageSize_, u8* pu8MessageData_)
{
  MessageSlotType *psSlotParser;
  MessageType *psNewMessage;
  MessageType *psListParser;
  u8  u8SlotsRequired;
  u32 u32BytesRemaining = u32MessageSize_;
  u32 u32CurrentMessageSize = 0;
  u32 u32MaxTxMessageLength = (u32)((u16)128) & 0x0000FFFF;
  
  /* Check for empty message */
  if(u32MessageSize_ == 0)
  {
    return(0);
  }

  /* Carefully check for available space in the message pool */
  u8SlotsRequired = (u8)(u32MessageSize_ / u32MaxTxMessageLength);
  if( (u32MessageSize_ % u32MaxTxMessageLength) != 0 )
  {
    u8SlotsRequired++;
  }

  if( (Msg_u8QueuedMessageCount + u8SlotsRequired) > (u8)32)
  {
    G_u32MessagingFlags |= (u32)0x00000001;
    return(0);
  }

  /* Space available, so proceed with allocation.  Though only one message is queued at a time, we
  use a while loop to handle messages that are too big and must be split into different slots.  The slots
  are always sequential and the message processor will send the bytes continuously across slots */
  while(u32BytesRemaining)
  {
    /* Increment the message count.  Interrupts are disabled here since this global
    can be accessed by an interrupt. */
    __disable_interrupt();
    Msg_u8QueuedMessageCount++;
    __enable_interrupt();
  
    /* Flag if we're above the high watermark */
    if(Msg_u8QueuedMessageCount >= (u8)((u8)32 - 3))
    {
      G_u32MessagingFlags |= (u32)0x00000002;
    }
    else
    {
      G_u32MessagingFlags &= ~(u32)0x00000002;
    }

    /* Find an empty slot: this is non-circular and there must be at least one free slot if we're here */
    psSlotParser = &Msg_asPool[0];
    while(!psSlotParser->bFree)
    {
      psSlotParser++;
    }
    
    /* Allocate the slot and set the message pointer */
    psSlotParser->bFree = FALSE;
    psNewMessage = &(psSlotParser->Message);
  
    /* Check the message size and split the message up if necessary */
    if(u32BytesRemaining > u32MaxTxMessageLength)
    {
      u32CurrentMessageSize = u32MaxTxMessageLength;
      u32BytesRemaining -= u32MaxTxMessageLength;
    }
    else
    {
      u32CurrentMessageSize = u32BytesRemaining;
      u32BytesRemaining = 0;
    }
    
    /* Copy all the data to the allocated message structure */
    psNewMessage->u32Token      = Msg_u32Token;
    psNewMessage->u32Size       = u32CurrentMessageSize;
    psNewMessage->psNextMessage = 0;
    
    /* Add the data into the payload */
    for(u32 i = 0; i < psNewMessage->u32Size; i++)
    {
      *(psNewMessage->pu8Message + i) = *pu8MessageData_;
      pu8MessageData_++;
    }
  
    /* Link the new message into the client's transmit buffer.  This must happen
    with interrupts off since other functions can operate on the transmit buffer. */
    __disable_interrupt();
    
    /* Handle an empty list */
    if(*ppsTargetTxBuffer_ == 0)
    {
      *ppsTargetTxBuffer_ = psNewMessage;
    }

    /* Add the message to the end of the list */
    else
    {
      /* Find the last node */
      psListParser = *ppsTargetTxBuffer_;
      while(psListParser->psNextMessage != 0)
      {
        psListParser = psListParser->psNextMessage;
      }
     
      /* Found the end: add the new node */
      psListParser->psNextMessage = psNewMessage;
    }

    /* Safe to re-enable interrupts */
    __enable_interrupt();

    /* Update the Public status of the message in the status queue */
    AddNewMessageStatus(Msg_u32Token);
  
    /* Increment message token and catch the rollover every 4 billion messages... Token 0 is not allowed. */
    Msg_u32Token++;
    if(Msg_u32Token == 0)
    {
      Msg_u32Token = 1;
    }
      
  } /* end while */

  /* Return only the current (and highest) message token, as it will be the last portion to be sent if the message was split up */
  return(psNewMessage->u32Token);
  
} /* end QueueMessage() */


/*!--------------------------------------------------------------------------------------------------------------------
@fn void DeQueueMessage(MessageType** pTargetQueue_)

@brief Removes a message from a message queue and adds it back to the pool.

Requires:
- The message to be removed has been completely sent and is no longer in use
- New message cannot be added into the list during this function (via interrupts)

@param  pTargetQueue_ is a FIFO linked-list where the message that needs to be killed is at the front of the list

Promises:
- The first message in the list is deleted; the list is hooked back up
- The message space is added back to the available message queue

*/
void DeQueueMessage(MessageType** pTargetQueue_)
{
  MessageSlotType *psSlotParser;
      
  /* Make sure there is a message to kill */
  if(*pTargetQueue_ == 0)
  {
    G_u32MessagingFlags |= (u32)0x00000004;
    return;
  }
  
  /* Find the message's slot: this message pool is non-circular and the message must be one of the slots */
  psSlotParser = &Msg_asPool[0];
  while( (&psSlotParser->Message != *pTargetQueue_) && 
         (psSlotParser != &Msg_asPool[(u8)32]) )
  {
    psSlotParser++;
  }

  /* Make sure the message has been found */
  if(psSlotParser == &Msg_asPool[(u8)32])
  {
    G_u32MessagingFlags |= (u32)0x00000008;
    return;
  }

  /* Unhook the message from the current owner's queue and put it back in the pool */
  *pTargetQueue_ = (*pTargetQueue_)->psNextMessage;
  psSlotParser->bFree = TRUE;
  Msg_u8QueuedMessageCount--;
  
} /* end DeQueueMessage() */


/*!--------------------------------------------------------------------------------------------------------------------
@fn void UpdateMessageStatus(u32 u32Token_, MessageStateType eNewState_)

@brief Changes the status of a message in the statue queue.

Requires:
@param u32Token_ is message that should be in the status queue
@param eNewState_ is the desired status setting for the message

Promises:
- if the token is found, the eState of the message is set to eNewState_

*/
void UpdateMessageStatus(u32 u32Token_, MessageStateType eNewState_)
{
  MessageStatusType* pListParser = &Msg_asStatusQueue[0];
  
  /* Search for the token */
  while( (pListParser->u32Token != u32Token_) && (pListParser != &Msg_asStatusQueue[(u8)(2 * (u8)32)]) )
  {
    pListParser++;
  }

  /* If the token was found, change the status */
  if(pListParser != &Msg_asStatusQueue[(u8)(2 * (u8)32)])
  {
    pListParser->eState = eNewState_;
  }
  
} /* end UpdateMessageStatus() */


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/

/*!--------------------------------------------------------------------------------------------------------------------
@fn static void AddNewMessageStatus(u32 u32Token_)

@brief Adds a new message into the message status queue.  

Due to the tendency of applications to forget that they wrote a message here, 
this buffer is circular and will overwrite the oldest message if it needs space for a 
new message.

Requires:
- Msg_psNextStatus points to the next status location

@param u32Token_ is the token of the message of interest

Promises:
- A new status is created at Msg_psNextStatus indexed by u32Token_

*/
static void AddNewMessageStatus(u32 u32Token_)
{
  /* Install the new message */
  Msg_psNextStatus->u32Token = u32Token_;
  Msg_psNextStatus->eState = WAITING;
  Msg_psNextStatus->u32Timestamp = G_u32SystemTime1ms;
  
  /* Safely advance the pointer */
  Msg_psNextStatus++;
  if(Msg_psNextStatus == &Msg_asStatusQueue[(u8)(2 * (u8)32)])
  {
    Msg_psNextStatus = &Msg_asStatusQueue[0];
  }
  
} /* end AddNewMessageStatus() */

/**********************************************************************************************************************
State Machine Function Definitions
**********************************************************************************************************************/

/*!-------------------------------------------------------------------------------------------------------------------
@fn static void MessagingSM_Idle(void)

@brief Right now this doesn't do anything 
*/
static void MessagingSM_Idle(void)
{
  static u32 u32CleaningTime = (u32)10000;
  
  /* Periodically check for stale messages */
  if(--u32CleaningTime == 0)
  {
    u32CleaningTime = (u32)10000;
    
    /* ??? Probably should add clean of the main message queue to detect any messages that have become stuck */
  }
    
} /* end MessagingSM_Idle() */





/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File */
/*--------------------------------------------------------------------------------------------------------------------*/
