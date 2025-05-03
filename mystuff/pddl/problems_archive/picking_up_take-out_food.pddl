(define (problem picking_up_take-out_food_0)
    (:domain igibson)

    (:objects
    	floor_1 - object
    	carton_1 - container ;; this one breaks
        table_1 - object
        sushi_1 - movable
        hamburger_1 - movable
    )
    
    (:init 
        (ontop carton_1 floor_1) 
        (inside sushi_1 carton_1) 
        (inside hamburger_1 carton_1) 
    )
    
    (:goal 
        (and 
            (ontop carton_1 table_1)
            (inside sushi_1 carton_1) 
            (inside hamburger_1 carton_1)
        )
    )
)
