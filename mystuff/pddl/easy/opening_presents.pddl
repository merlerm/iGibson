(define (problem opening_presents_0)
    (:domain igibson)

    (:objects
     	package_1 package_2 - container
    	floor_1 - object
    	bed_1 - object
    	agent_1 - agent
    )
    
    (:init 
        (openable package_1)
        (openable package_2)
        (not (open package_1)) 
        (not (open package_2)) 
    )
    
    (:goal 
        (and 
            (open package_1)
            (open package_2)
        )
    )
)