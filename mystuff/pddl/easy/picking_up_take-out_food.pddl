(define (problem picking_up_take-out_food_0)
    (:domain igibson)

    (:objects
    	floor_1 - object
    	carton_1 - container
        table_1 - object
        sushi_1 - object
        hamburger_1 - object
    	agent_1 - agent
    )
    
    (:init 
        (ontop carton_1 floor_1) 
        (movable carton_1)
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
