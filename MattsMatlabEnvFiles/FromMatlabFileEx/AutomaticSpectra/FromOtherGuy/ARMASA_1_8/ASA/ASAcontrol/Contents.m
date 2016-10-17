%ASACONTROL Function control variable
%   The structure variable ASACONTROL is used to pass that information 
%   between functions, which is not directly related to these functions' 
%   main computational goals. The ASACONTROL variable can always be added 
%   to an input argument list as the final argument, and can always be 
%   retrieved as the final argument of an output list of any ARMASA main 
%   function. In addition, it is allowed to use ASACONTROL as the only 
%   input argument to any ARMASA main function. By assigning one or more 
%   fields with predefined names and values to ASACONTROL, a user is able 
%   to control specific operation modes of called functions, when using 
%   ASACONTROL as an input argument to an ARMASA function. The called 
%   function itself and its internally called ARMASA functions will then 
%   be submitted to the specific operation mode.
%    
%   Predefined field names and allowed values are:
%   
%   show_ASAwarn
%   ------------
%   
%   Its status determines whether any non-empty warning message will be 
%   generated by invoking ASAwarn. By calling an ARMASA main function 
%   with ASACONTROL.SHOW_ASAWARN defined as an input argument, a user can 
%   control whether any ARMASA warning message will be shown on screen.
%   
%   0            - suppresses ARMASA warning messages
%   1            - shows ARMASA warning messages
%   undefined    - shows ARMASA warning messages
%   
%   run
%   ---
%   
%   Its status determines whether the computational kernel of a function 
%   will be run. It can be used to run the header sections of functions 
%   individually, for the purpose of retrieving or checking version 
%   information. Without user intervention, a default status is set 
%   automatically at an appropriate value.
%   
%   0            - skips the computational kernel
%   1            - runs the computational kernel
%   undefined    - run status depends on input arguments
%   
%   error_chk
%   ---------
%   
%   Its status determines whether the procedure that checks input 
%   arguments for errors is active. Switching off error check procedures 
%   is typically used inside m-files that call other functions. It avoids 
%   needless checks on internal variables, thereby improving performance. 
%   Using invalid input arguments, while error check is turned off, 
%   however causes the function to crash or produce wrong answers without 
%   prior notification.  
%   
%   0            - switches off error check procedure
%   1            - turns on error check procedure
%   undefined    - error check will be performed
%   
%   version_chk
%   -----------
%   
%   Its status determines whether the 'ASAversionchk' procedure will be 
%   performed in the called function, that checks the version 
%   compatibility between the called and the caller function. Switching 
%   off version check is used inside m-files that call other functions, 
%   whose versions have already been checked at the beginning of the 
%   program. In this way, it avoids repetition of identical version 
%   checks that are relatively time consuming. The version check 
%   procedure can only be run successfully if the function is called by 
%   another function using ASAcontrol with a properly defined field 
%   req_version (see below). 
%   
%   0            - switches off version check procedure
%   1            - turns on version check procedure
%   undefined    - version check will be performed if possible 
%   
%   is_version
%   ----------
%   
%   The row array defines the function's current version. It is assigned 
%   to ASACONTROL in the body of ARMASA main functions. When making any 
%   changes to the contents of the m-file of the function, it is strongly 
%   advised to update the version identifier. The version identifier 
%   identifies the date and time the function is revised. It must be 
%   formatted according to the Matlab date vector format, see also 
%   ASAVERSION2NUMSTR and DATEVEC.
%   
%   [YEAR MONTH DAY HOUR MINS SECS]  - identifies the function's current
%                                      version
%   undefined                        - allowed when calling a function
%   
%   comp_version
%   ------------
%   
%   The row array defines the function's compatibility with former 
%   versions. Like ASACONTROL.IS_VERSION, it is assigned to ASACONTROL in 
%   the body of ARMASA main functions. By adding functionality to a 
%   function, its compatibility with former versions will NOT change as 
%   long as formerly used input arguments will still return the same 
%   results when using the new function. In this case, updating 
%   ASACONTROL.IS_VERSION and leaving ASACONTROL.COMP_VERSION intact, is 
%   the proper strategy. Updating COMP_VERSION to the function's current 
%   version (equal to IS_VERSION) is however advised when in- or output 
%   argument lists have been changed or when new calculations with 
%   changed outcomes are implemented. This strategy deliberately forces 
%   that any calls to this function by other functions must be updated, 
%   so that consistency can be guaranteed.
%   
%   [YEAR MONTH DAY HOUR MINS SECS]  - identifies the function's
%                                      compatibility with former versions
%   undefined                        - allowed when calling a function
%   
%   req_version.FUNCTION
%   --------------------
%   
%   FUNCTION is the name of a field nested in REQ_VERSION. Its value (a 
%   version identifier) is used to request a minimum version 
%   specification of a function FUNCTION, that is called from within the 
%   body of a m-file. The called function FUNCTION uses this field to 
%   confront the version request with its own current-version and 
%   compatible-version, by invoking ASAVERSIONCHK. 
%   
%   [YEAR MONTH DAY HOUR MINS SECS]  - specifies a required minimum
%                                      version of a called function
%   undefined                        - skips the version check procedure
%   
%   See also: ASAVERSIONCHK

disp('  Variable ASACONTROL is currently undefined.')
disp('  Type ''help ASAcontrol'' for more information.')