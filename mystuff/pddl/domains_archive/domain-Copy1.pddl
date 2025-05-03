(define (domain igibson)
    (:requirements :strips :typing :negative-preconditions :conditional-effects :equality :disjunctive-preconditions)

    (:types
        agent receptacle - object
        container - receptacle ;; A container is a type of receptacle that can be opened and closed
    )

    (:predicates

        ;; Agent predicates
        (reachable ?o - object ?a - agent)
        (holding ?a - agent ?o - object)

        ;; Object attributes
        (movable ?o - object)
        (openable ?o - object) ;; equivalent to is-container
        (open ?c - container)

        ;; Object relations
        (ontop ?o1 - object ?o2 - object)
        (inside ?o - object ?r - object)

        ;; Specific object attributes
        (slicer ?o - object) ;; (e.g. knife)
        (sliced ?o - object) ;; (e.g. sliced tomato)
    )

    (:action grasp
        :parameters (?a - agent ?o - object)
        :precondition (and
            (reachable ?o ?a)
            (movable ?o)
            (forall
                (?x - object)
                (not (holding ?a ?x))) ;; Agent must not be holding anything
            (forall
                (?x - object)
                (not (ontop ?x ?o))) ;; Can't grasp an objectect that has something on top of it
        )
        :effect (and
            (holding ?a ?o)
            (not (reachable ?o ?a))
            (forall
                (?y - object)
                (not (ontop ?o ?y))) ;; If grasped objectect is on top of something, it is no longer on top of it
            (forall
                (?r - receptacle)
                (when
                    (inside ?o ?r)
                    (not (inside ?o ?r)))) ;; If o was in a receptacle, it's not anymore
        )
    )

    (:action place-on
        :parameters (?a - agent ?o1 - object ?o2 - object)
        :precondition (and
            (holding ?a ?o1)
            (reachable ?o2 ?a)
        )
        :effect (and
            (ontop ?o1 ?o2)
            (not (holding ?a ?o1))
        )
    )

    (:action place-inside
        :parameters (?a - agent ?o - object ?r - receptacle)
        :precondition (and
            (holding ?a ?o)
            (reachable ?r ?a)
            ;; We should divide it in two actions, place-inside-nonopenable and place-inside-openable
            ;;(or
            ;;  (not (openable ?r)) ;; receptacle is not openable => the action is always valid
            ;;  (open ?r)           ;; receptacle is openable, then it's required to be open - throws error probably because r is not a container 
            ;;) 
        )
        :effect (and
            (inside ?o ?r)
            (not (holding ?a ?o))
        )
    )

    (:action open-container
        :parameters (?a - agent ?c - container)
        :precondition (and
            (openable ?c)
            (reachable ?c ?a)
            (not (open ?c))
        )
        :effect (and
            (open ?c)
            (forall
                (?o - object)
                (when
                    (inside ?o ?c)
                    (reachable ?o ?a))) ;; All objects inside the container are reachable
        )
    )

    (:action close-container
        :parameters (?a - agent ?c - container)
        :precondition (and
            (openable ?c)
            (reachable ?c ?a)
            (open ?c)
        )
        :effect (and
            (not (open ?c))
            (forall
                (?o - object)
                (when
                    (inside ?o ?c)
                    (not (reachable ?o ?a)))) ;; All objects inside the container are unreachable
        )
    )

    (:action navigate-to
        :parameters (?a - agent ?o - object)
        :precondition (and
                        (not (reachable ?o ?a))
                        ;; don’t navigate-to things hidden in a closed container
                        (not (exists (?c - container)
                                (and (inside ?o ?c) 
                                     (not (open ?c)))
                            ))
                        )
        :effect (and

            ;; Make every object unreachable - ok
            (forall (?x - object)
                (not (reachable ?x ?a)))

            ;; If ?o is not inside any receptacle, mark it as reachable - ok
            ;; This makes ?o reachable even if it's a receptacle or a container (I'm guessing)
            (when
                (forall (?r - receptacle)
                    (not (inside ?o ?r)))
                (reachable ?o ?a))

            ;; If ?o is inside a receptacle that is non openable, 
            ;; mark the receptacle and all the objects inside as reachable - ok
            (when
              (exists (?r - receptacle)
                (and
                  (not (openable ?r))
                  (inside ?o ?r)))
              (and
                ;; make the receptacle itself reachable
                (reachable ?r ?a)
            
                ;; make every object inside it reachable
                (forall (?x - object)
                  (when
                    (inside ?x ?r)
                    (reachable ?x ?a)))))
                    

            ;; If ?o is inside a container (which is open because of the preconditions), 
            ;; mark the container and all the objects inside as reachable
            (when
              (exists (?c - container)
                (and
                  (open ?c)
                  (inside ?o ?c)))
              (and
                ;; make the container itself reachable
                (reachable ?c ?a)
            
                ;; make every object inside it reachable
                (forall (?x - object)
                  (when
                    (inside ?x ?c)
                    (reachable ?x ?a)))))

            ;; Also, if there exists a container which is ?o and that it's open,
            ;; set the objects inside as reachable
            (when
                (exists (?c - container)
                    (and 
                        (= ?o ?c)
                        (open ?c)))
                (and
                ;; make the container itself reachable - probably not necessary
                (reachable ?c ?a)
            
                ;; make every object inside it reachable
                (forall (?x - object)
                  (when
                    (inside ?x ?c)
                    (reachable ?x ?a)))))
                

            ;; Finally, if there exists a receptacle which is ?o and it's not openable, 
            ;; mark any object inside as reachable.
            (when
                (exists (?r - receptacle)
                    (and 
                        (= ?o ?r)
                        (not (openable ?r))))
                (and
                ;; make the receptacle itself reachable - probably not necessary
                (reachable ?r ?a)
            
                ;; make every object inside it reachable
                (forall (?x - object)
                  (when
                    (inside ?x ?r)
                    (reachable ?x ?a)))))

        )
    )


    (:action slice
        :parameters (?a - agent ?o - object)
        :precondition (and
            (exists (?s - object) 
                (and 
                    (holding ?a ?s)
                    (slicer ?s)))
            (reachable ?o ?a)
            (not (sliced ?o))
        )
        :effect (and 
            (sliced ?o)
        )
    )
    
)