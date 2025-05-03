(define (domain igibson)
    (:requirements :strips :typing :negative-preconditions :conditional-effects :equality :disjunctive-preconditions)

    (:types
        agent receptacle - object
        container - receptacle ;; A container is a type of receptacle that can be opened and closed
    )

    (:predicates

        ;; Agent predicates
        (reachable ?o - object)
        (holding ?o - object)

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
        :parameters (?o - object)
        :precondition (and
            (reachable ?o)
            (movable ?o)
            (forall
                (?x - object)
                (not (holding ?x))) ;; Agent must not be holding anything
            (forall
                (?x - object)
                (not (ontop ?x ?o))) ;; Can't grasp an objectect that has something on top of it
        )
        :effect (and
            (holding ?o)
            (not (reachable ?o ))
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
        :parameters (?o1 - object ?o2 - object)
        :precondition (and
            (holding ?o1)
            (reachable ?o2)
        )
        :effect (and
            (ontop ?o1 ?o2)
            (not (holding ?o1))
        )
    )

    (:action place-inside
        :parameters (?o - object ?r - receptacle)
        :precondition (and
            (holding ?o)
            (reachable ?r )
            ;; We should divide it in two actions, place-inside-nonopenable and place-inside-openable
            ;;(or
            ;;  (not (openable ?r)) ;; receptacle is not openable => the action is always valid
            ;;  (open ?r)           ;; receptacle is openable, then it's required to be open - throws error probably because r is not a container 
            ;;) 
        )
        :effect (and
            (inside ?o ?r)
            (not (holding ?o))
        )
    )

    (:action open-container
        :parameters (?c - container)
        :precondition (and
            (openable ?c)
            (reachable ?c)
            (not (open ?c))
        )
        :effect (and
            (open ?c)
            (forall
                (?o - object)
                (when
                    (inside ?o ?c)
                    (reachable ?o))) ;; All objects inside the container are reachable
        )
    )

    (:action close-container
        :parameters (?c - container)
        :precondition (and
            (openable ?c)
            (reachable ?c)
            (open ?c)
        )
        :effect (and
            (not (open ?c))
            (forall
                (?o - object)
                (when
                    (inside ?o ?c)
                    (not (reachable ?o)))) ;; All objects inside the container are unreachable
        )
    )

    (:action navigate-to
        :parameters (?o - object)
        :precondition (and
                        (not (reachable ?o))
                        ;; don’t navigate-to things hidden in a closed container
                        (not (exists (?c - container)
                                (and (inside ?o ?c) 
                                     (not (open ?c)))
                             )
                        )
                      )
        :effect (and

            ;; Make every object unreachable - ok
            (forall (?x - object)
                (not (reachable ?x)))

            ;; If ?o is not inside any receptacle, mark it as reachable - ok
            ;; This makes ?o reachable even if it's a receptacle or a container (I'm guessing)
            (when
                (forall (?r - receptacle)
                    (not (inside ?o ?r)))
                (reachable ?o))

            ;; If ?o is inside a receptacle that is non openable, 
            ;; mark the receptacle and all the objects inside as reachable - ok
            (forall (?r - receptacle ?x - object)
              (when
                (and
                  (not (openable ?r))
                  (inside ?o ?r)
                  (inside ?x ?r))
                (and
                  (reachable ?r)
                  (reachable ?x))))

            ;; If ?o is inside a container (which is open because of the preconditions), 
            ;; mark the container and all the objects inside as reachable
            (forall (?c - container ?x - object)
              (when
                (and
                  (open ?c)
                  (inside ?o ?c)
                  (inside ?x ?c))
                (and
                  (reachable ?c)
                  (reachable ?x))))

            ;; Also, if there exists a container which is ?o and that it's open,
            ;; set the objects inside as reachable
            (forall (?c - container ?x - object)
              (when 
                (and
                  (= ?c ?o)
                  (open ?c)
                  (inside ?x ?c)
                )
                (reachable ?x)))

            ;; Finally, if there exists a receptacle which is ?o and it's not openable, 
            ;; mark any object inside as reachable.
            (forall (?r - receptacle ?x - object)
              (when 
                (and
                  (= ?r ?o)
                  (not (openable ?r))
                  (inside ?x ?r)
                )
                (reachable ?x)))

        )
    )



    (:action slice
        :parameters (?o - object)
        :precondition (and
            (exists (?s - object) 
                (and 
                    (holding ?s)
                    (slicer ?s)))
            (reachable ?o)
            (not (sliced ?o))
        )
        :effect (and 
            (sliced ?o)
        )
    )
    
)