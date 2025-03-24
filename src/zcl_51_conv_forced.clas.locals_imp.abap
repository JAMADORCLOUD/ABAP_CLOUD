*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_class DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS do_something
        IMPORTING i_string TYPE string.         "2
*        IMPORTING i_string TYPE char10.        "1
*       RETURNING VALUE(i_string) TYPE string.  "3

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_class IMPLEMENTATION.

  METHOD do_something.

*  i_string = 'JESUS AMADOR VALDEZ'.            "3

  ENDMETHOD.

ENDCLASS.
