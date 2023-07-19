*&---------------------------------------------------------------------*
*& Include zot_16_i_sport_top
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gty_teams,
         id         TYPE i,
         gv_team    TYPE c LENGTH 20,
         gv_country TYPE c LENGTH 20,
         gv_bag     TYPE i,
       END OF gty_teams.

DATA gt_dbTeams TYPE TABLE OF gty_teams.


TYPES: BEGIN OF gty_group,
         gv_team TYPE c LENGTH 20,
       END OF gty_group.



DATA gt_groupa TYPE TABLE OF gty_group.
DATA gt_groupb TYPE TABLE OF gty_group.
DATA gt_groupc TYPE TABLE OF gty_group.
DATA gt_groupd TYPE TABLE OF gty_group.


gt_dbteams = VALUE #( BASE gt_dbteams (
                                          id = 1
                                         gv_team = 'Liverpool'
                                        gv_country = 'İngiltere'
                                        gv_bag = 1 )

                                        (
                                         id = 2
                                        gv_team = 'Bayer Münih'
                                        gv_country = 'Almanya'
                                        gv_bag = 1 )

                                        (
                                        id = 3
                                        gv_team = 'Inter'
                                        gv_country = 'İtalya'
                                        gv_bag = 1 )

                                         (
                                         id = 4
                                          gv_team = 'PSG'
                                        gv_country = 'Fransa'
                                        gv_bag = 1 )

                                         (
                                         id = 5
                                          gv_team = 'Manchester United'
                                        gv_country = 'İngiltere'
                                        gv_bag = 2 )

                                        (
                                        id = 6
                                        gv_team = 'PSV'
                                        gv_country = 'Hollanda'
                                        gv_bag = 2 )

                                         (
                                         id = 7
                                         gv_team = 'Porto'
                                        gv_country = 'Portekiz'
                                        gv_bag = 2 )

                                          (
                                          id = 8
                                          gv_team = 'Real Madrid'
                                        gv_country = 'İspanya'
                                        gv_bag = 2 )

                                         (
                                         id = 9
                                         gv_team = 'Dortmund'
                                        gv_country = 'Almanya'
                                        gv_bag = 3 )

                                         (
                                         id = 10
                                          gv_team = 'Galatasaray'
                                        gv_country = 'Türkiye'
                                        gv_bag = 3 )

                                         (
                                         id = 11
                                          gv_team = 'Marsilya'
                                        gv_country = 'Fransa'
                                        gv_bag = 3 )

                                        (
                                        id = 12
                                         gv_team = 'Ajax'
                                        gv_country = 'Hollanda'
                                        gv_bag = 3 )

                                         (
                                         id = 13
                                          gv_team = 'AEK'
                                        gv_country = 'Yunanistan'
                                        gv_bag = 4 )

                                        (
                                        id = 14
                                         gv_team = 'Roma'
                                        gv_country = 'İtalya'
                                        gv_bag = 4 )

                                         (
                                         id = 15
                                          gv_team = 'Shaktar'
                                        gv_country = 'Rusya'
                                        gv_bag = 4 )

                                          (
                                          id = 16
                                          gv_team = 'Atletico Madrid'
                                        gv_country = 'İspanya'
                                        gv_bag = 4 )
                                         ).
