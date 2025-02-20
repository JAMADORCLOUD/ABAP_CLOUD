*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_producto DEFINITION.      "Add lcl Then Ctrl + Space Create a new implementation

  PUBLIC SECTION.

    CLASS-DATA: lv_type_ci TYPE c,
                lv_type_ce TYPE c.

    METHODS: constructor,            "Click next to Statement METHOD Ctrl + 1 Create a new Method
             get_fm RETURNING VALUE(lv_type_fm) TYPE string.

    CLASS-METHODS: class_constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_producto IMPLEMENTATION.

  METHOD constructor.

    lv_type_ci = 'I'.        "Instance Constructor
                             "Access Second, this needs Instance

  ENDMETHOD.

  METHOD class_constructor.

    lv_type_ce = 'E'.        "Static Constructor
                             "Access First, this doesn't need Instance

  ENDMETHOD.

  METHOD get_fm.

  lv_type_fm = 'F'.          "Functional Method
                             "Access Third, this needs Instance

  ENDMETHOD.

ENDCLASS.
