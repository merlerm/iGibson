(define (problem locking_every_door_0)
    (:domain igibson)

    (:objects
     	door_1 door_2 - container
    	agent_1 - agent
    )
    
    (:init 
        (openable door_1) 
        (openable door_2) 
        (open door_1) 
        (open door_2) 
    )
    
    (:goal 
        (and 
            (not (open door_1)) 
            (not (open door_2))
        )
    )
)
