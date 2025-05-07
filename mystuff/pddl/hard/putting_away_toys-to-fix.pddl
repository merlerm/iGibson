(define (problem putting_away_toys_0)
    (:domain igibson)

    (:objects
        plaything_1 plaything_2 plaything_3 plaything_4 plaything_5 plaything_6 plaything_7 plaything_8 - object
        floor_1 floor_2 - object
        carton_1 carton_2 - container
        agent_1 - agent
        table_1 - object
    )
    
    (:init 
        (movable plaything_1)
        (movable plaything_2)
        (movable plaything_3)
        (movable plaything_4)
        (movable plaything_5)
        (movable plaything_6)
        (movable plaything_7)
        (movable plaything_8)

        (ontop plaything_1 floor_1) 
        (ontop plaything_2 floor_1) 
        (ontop plaything_3 floor_1) 
        (ontop plaything_4 floor_1) 
        (ontop plaything_5 floor_2) 
        (ontop plaything_6 floor_2) 
        (ontop plaything_7 floor_2) 
        (ontop plaything_8 floor_2) 

        (openable carton_1)
        (openable carton_2)
        (not (open carton_1))
        (not (open carton_2))
    )
    
    (:goal 
        (and 
                (or 
                    (inside plaything_1 carton_1)
                    (inside plaything_1 carton_2)
                )
                (or 
                    (inside plaything_2 carton_1)
                    (inside plaything_2 carton_2)
                )
                (or 
                    (inside plaything_3 carton_1)
                    (inside plaything_3 carton_2)
                )
                (or 
                    (inside plaything_4 carton_1)
                    (inside plaything_4 carton_2)
                )
                (or 
                    (inside plaything_5 carton_1)
                    (inside plaything_5 carton_2)
                )
                (or 
                    (inside plaything_6 carton_1)
                    (inside plaything_6 carton_2)
                )
                (or 
                    (inside plaything_7 carton_1)
                    (inside plaything_7 carton_2)
                )
                (or 
                    (inside plaything_8 carton_1)
                    (inside plaything_8 carton_2)
                )
            )
        )
    )
)