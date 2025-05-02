(define (problem packing_food_for_work_0)
    (:domain igibson)

    (:objects
        carton_1 - container
        countertop_1 - object
        sandwich_1 - object
        electric_refrigerator_1 - container
        apple_1 - object
        snack_food_1 - object
        cabinet_1 - container
        juice_1 - object
        floor_1 - object
        agent_1 - agent
    )
    
    (:init 
        (openable carton_1)
        (openable cabinet_1)
        (openable electric_refrigerator_1)

        (not (open carton_1))
        (not (open cabinet_1))
        (not (open electric_refrigerator_1))

        (inside sandwich_1 electric_refrigerator_1) 
        (inside snack_food_1 cabinet_1) 

        (ontop carton_1 floor_1) 
        (ontop apple_1 countertop_1) 
        (ontop juice_1 countertop_1) 
    )
    
    (:goal 
        (and 
            (ontop carton_1 floor_1)
            (inside sandwich_1 carton_1) 
            (inside apple_1 carton_1) 
            (inside snack_food_1 carton_1) 
            (inside juice_1 carton_1) 
        )
    )
)