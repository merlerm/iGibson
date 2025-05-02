(define (problem cleaning_out_drawers_0)
    (:domain igibson)

    (:objects
     	bowl_1 bowl_2 - object
    	cabinet_1 cabinet_2 - container
    	spoon_1 spoon_2 - object
    	piece_of_cloth_1 - object
    	sink_1 - container
    	agent_1 - agent
    )
    
    (:init 
        (inside bowl_1 cabinet_1) 
        (inside bowl_2 cabinet_1) 
        (inside spoon_1 cabinet_2) 
        (inside spoon_2 cabinet_2) 
        (inside piece_of_cloth_1 cabinet_1) 

        (movable piece_of_cloth_1)
        (movable bowl_1)
        (movable bowl_2)
        (movable spoon_1)
        (movable spoon_2)
        
        (openable cabinet_1)
        (openable cabinet_2)

        (not open cabinet_1)
        (not open cabinet_2)
    )
    
    (:goal 
        (and 
            (ontop piece_of_cloth_1 sink_1) 
            (ontop bowl_1 sink_1) 
            (ontop bowl_2 sink_1) 
            (ontop spoon_1 sink_1) 
            (ontop spoon_2 sink_1)
        )
    )
)