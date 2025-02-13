CLASS zcl_13_iterate_amador DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_13_iterate_amador IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  DATA output TYPE TABLE OF string.

  CONSTANTS max_count TYPE i VALUE 20.
  DATA numbers TYPE TABLE OF i.

  DO max_count TIMES.

   CASE sy-index.
      WHEN 1.
        APPEND 0 TO numbers.
      WHEN 2.
        APPEND 1 TO numbers.
      WHEN OTHERS.
        APPEND numbers[  sy-index - 2 ]
             + numbers[  sy-index - 1 ]
            TO numbers.
   ENDCASE.

  ENDDO.

  DATA(counter) = 0.
  LOOP AT numbers INTO DATA(number).

     counter = counter + 1.
     APPEND |{ counter WIDTH = 4 }: { number WIDTH = 10 ALIGN = RIGHT }|
         TO output.

  ENDLOOP.

  out->write(
         data   = output
         name   = |The first { max_count } Fibonacci Numbers|
                ) .

  ENDMETHOD.

ENDCLASS.
