*&---------------------------------------------------------------------*
*& Report ZOT_16_P_ASSOCIATIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_associations.


START-OF-SELECTION.

  SELECT *
      FROM zot_16_ddl_associations
      INTO TABLE @DATA(lt_data).





    SELECT *
        FROM zot_16_ddl_parametre( p_meins = 'DE' )
        INTO TABLE @DATA(lt_dataa).



      PARAMETERS p_meins TYPE meins.

      SELECT *
       FROM zot_16_ddl_parametre( p_meins = @p_meins )
       INTO TABLE @DATA(lt_dataaa).



        TABLES: vbak,vbap.
        SELECT-OPTIONS: p_matnr FOR vbap-matnr NO INTERVALS,
                        p_kunnr FOR vbak-kunnr NO INTERVALS.


        DATA lt_de TYPE TABLE OF vbak.

        SELECT
            *
            FROM vbak
            INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
            INNER JOIN makt ON makt~matnr = vbap~matnr
            INNER JOIN kna1 ON kna1~kunnr = vbak~kunnr
            WHERE vbap~matnr IN @p_matnr AND vbak~kunnr IN @p_kunnr
            INTO CORRESPONDING FIELDS OF TABLE @lt_de
            UP TO 100 ROWS.
