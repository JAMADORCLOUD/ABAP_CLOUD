CLASS zcl_24_cons_ins_est DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_24_cons_ins_est IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA producto TYPE REF TO lcl_producto.
    DATA productos TYPE TABLE OF REF TO lcl_producto.
*    DATA lv_type_fm TYPE string.

* to call instance method you need an instance of the class
* CALL METHOD obj_ref->methodname
* connection->constructor( ). "Wrong
    producto = NEW #(  ). "Instance

* to call static method using class name
* class_name=>methodname "
* lcl_producto=>class_constructor( ). "Wrong


    DATA(lv_type_fm) = producto->get_fm( ).
*lv_type_fm = producto->get_fm( ).

    IF lcl_producto=>lv_type_ci = 'I'.
      out->write( 'Instance Constructor' ).
    ENDIF.

    IF lcl_producto=>lv_type_ce = 'E'.
      out->write( 'Static Constructor' ).
    ENDIF.

    IF lv_type_fm = 'F'.
      out->write( 'Functional Method' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
