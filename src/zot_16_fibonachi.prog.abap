*&---------------------------------------------------------------------*
*& Report zot_16_fibonachi
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_fibonachi.




SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
 PARAMETERS: p_fnum TYPE i LENGTH 5 OBLIGATORY,
             P_knum TYPE i LENGTH 1 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.




START-OF-SELECTION.

   DATA(firstTerm) = 1.
   DATA(secondTerm) = 1.
   DATA(i) = 0.
   WHILE firstterm <= p_fnum.
         if i MOD p_knum = 0.
                NEW-LINE.
                WRITE: firstterm.
            else.
             WRITE: firstterm.
        endif.
        DATA(term) = firstterm + secondterm.
        firstterm = secondterm.
        secondterm = term.

        i = i + 1.
   ENDWHILE.
