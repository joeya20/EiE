/*!*********************************************************************************************************************
@file user_app1.c                                                                
@brief User's tasks / applications are written here.  This description
should be replaced by something specific to the task.

----------------------------------------------------------------------------------------------------------------------
This is the first project completed in the EiE program
This app is a simple "hello World" implementation
The red LED simply blinks twice a second, aka 50% duty cycle
------------------------------------------------------------------------------------------------------------------------
GLOBALS
- NONE

CONSTANTS
- NONE

TYPES
- NONE

PUBLIC FUNCTIONS
- NONE

PROTECTED FUNCTIONS
- void HelloWorldInitialize(void)
- void HelloWorldRunActiveState(void)


**********************************************************************************************************************/

#include "configuration.h"

/***********************************************************************************************************************
Global variable definitions with scope across entire project.
All Global variable names shall start with "G_<type>HelloWorld"
***********************************************************************************************************************/
/* New variables */
volatile u32 G_u32HelloWorldFlags;                          /*!< @brief Global state flags */


/*--------------------------------------------------------------------------------------------------------------------*/
/* Existing variables (defined in other files -- should all contain the "extern" keyword) */
extern volatile u32 G_u32SystemTime1ms;                   /*!< @brief From main.c */
extern volatile u32 G_u32SystemTime1s;                    /*!< @brief From main.c */
extern volatile u32 G_u32SystemFlags;                     /*!< @brief From main.c */
extern volatile u32 G_u32ApplicationFlags;                /*!< @brief From main.c */


/***********************************************************************************************************************
Global variable definitions with scope limited to this local application.
Variable names shall start with "HelloWorld_<type>" and be declared as static.
***********************************************************************************************************************/
static fnCode_type HelloWorld_pfStateMachine;               /*!< @brief The state machine function pointer */
//static u32 HelloWorld_u32Timeout;                           /*!< @brief Timeout counter used across states */


/**********************************************************************************************************************
Function Definitions
**********************************************************************************************************************/

/*--------------------------------------------------------------------------------------------------------------------*/
/*! @publicsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------------*/
/*! @protectedsection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/

/*!--------------------------------------------------------------------------------------------------------------------
@fn void HelloWorldInitialize(void)

@brief
Initializes the State Machine and its variables.

Should only be called once in main init section.

Requires:
- NONE

Promises:
- NONE

*/
void HelloWorldInitialize(void)
{
  HEARTBEAT_OFF();
  /* If good initialization, set state to Idle */
  if( 1 )
  {
    HelloWorld_pfStateMachine = HelloWorldSM_Idle;
  }
  else
  {
    /* The task isn't properly initialized, so shut it down and don't run */
    HelloWorld_pfStateMachine = HelloWorldSM_Error;
  }

} /* end HelloWorldInitialize() */

  
/*!----------------------------------------------------------------------------------------------------------------------
@fn void HelloWorldRunActiveState(void)

@brief Selects and runs one iteration of the current state in the state machine.

All state machines have a TOTAL of 1ms to execute, so on average n state machines
may take 1ms / n to execute.

Requires:
- State machine function pointer points at current state

Promises:
- Calls the function to pointed by the state machine function pointer

*/
void HelloWorldRunActiveState(void)
{
  HelloWorld_pfStateMachine();

} /* end HelloWorldRunActiveState */


/*------------------------------------------------------------------------------------------------------------------*/
/*! @privatesection */                                                                                            
/*--------------------------------------------------------------------------------------------------------------------*/


/**********************************************************************************************************************
State Machine Function Definitions
**********************************************************************************************************************/
/*-------------------------------------------------------------------------------------------------------------------*/
/* What does this state do? */
static void HelloWorldSM_Idle(void)
{
      static u32 u32counter = 0;
  static bool bLightIsOn = FALSE;
  
  // Increment u32Counter every 1ms cycle
  u32counter++;
  
  //check and roll over
  if(u32counter == COUNTER_LIMIT_MS)
  {
    
    u32counter = 0;
  /*Since bLight changes every 500 ms then HEARTBEAT state changes every 500ms accordingly*/
    if(bLightIsOn)
    {
      HEARTBEAT_OFF();
    }
    else
    {
      HEARTBEAT_ON();
    }
    
  /*when counter hits 500 ms, bool bLightIsOn switches.*/
  bLightIsOn = !bLightIsOn;
  }
} /* end HelloWorldSM_Idle() */
     

/*-------------------------------------------------------------------------------------------------------------------*/
/* Handle an error */
static void HelloWorldSM_Error(void)          
{

} /* end HelloWorldSM_Error() */




/*--------------------------------------------------------------------------------------------------------------------*/
/* End of File                                                                                                        */
/*--------------------------------------------------------------------------------------------------------------------*/
