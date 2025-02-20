*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_fibonacci DEFINITION.

  PUBLIC SECTION.

TYPES: lt_int_tab TYPE STANDARD TABLE OF int4 WITH EMPTY KEY.

    METHODS get_fibonacci
      IMPORTING !n TYPE i
      RETURNING VALUE(fib_numbers) TYPE lt_int_tab.

*  PROTECTED SECTION.
*  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_fibonacci  IMPLEMENTATION.

  METHOD get_fibonacci.
    fib_numbers = COND #( WHEN n = 0
                                THEN VALUE #( ( |0| ) )
                              WHEN n = 1
                                THEN VALUE #( ( |0| ) ( |1| ) )
                              ELSE
                                VALUE #( LET fn1 = get_fibonacci( n - 1 )
                                             x   = fn1[ lines( fn1 ) ]
                                             y   = fn1[ lines( fn1 ) - 1 ]
                                          IN
                                          ( LINES OF fn1 ) ( x + y ) ) ).

  ENDMETHOD.

ENDCLASS.
