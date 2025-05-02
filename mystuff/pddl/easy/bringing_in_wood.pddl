(define (problem bringing_in_wood_0)
    (:domain igibson)

    (:objects
        plywood_1 plywood_2 plywood_3 - object
        floor_1 floor_2 - floor
        agent_1 - agent
    )
    
    (:init 
        (movable plywood_1)
        (movable plywood_2)
        (movable plywood_3)
        (ontop plywood_1 floor_1) 
        (ontop plywood_2 floor_1) 
        (ontop plywood_3 floor_1) 
    )
    
    (:goal 
        (and 
            (
            (ontop plywood_1 floor_2)
            (ontop plywood_2 floor_2)
            (ontop plywood_3 floor_2)
            )
        )
    )
)