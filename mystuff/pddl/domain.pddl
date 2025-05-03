(define (domain igibson)
    (:requirements :strips :typing :negative-preconditions :conditional-effects :equality :disjunctive-preconditions)

    (:types
        container movable - object
        sliceable slicer - movable
    )

    (:predicates

        ;; Agent predicates
        (reachable ?o - object)
        (holding ?m - movable)

        ;; Object attributes
        (open ?c - container)

        ;; Object relations
        (ontop ?o1 - object ?o2 - object) ;; no assumptions on the types of objects that can be on top or below others
        (inside ?o - object ?c - container) ;; only containers can contain objects
        (nextto ?o1 - object ?o2 - object) ;; no assumptions on the types of objects that can be next to each other

        ;; Specific object attributes
        (sliced ?s - sliceable) ;; (e.g. sliced tomato)
    )

    (:action grasp
        :parameters (?m - movable)
        :precondition (and
            (reachable ?m)
            (forall
                (?x - movable)
                (not (holding ?x))) ;; Agent must not be holding anything
            ;;(forall
            ;;    (?x - movable)
            ;;    (not (ontop ?x ?m))) ;; Can't grasp an object that has something on top of it
        )
        :effect (and
            (holding ?m)
            ;;(not (reachable ?m)) ;; not sure if necessary
            (forall
                (?y - object)
                (and
                    (not (ontop ?m ?y)) ;; If grasped object is on top of something, it is no longer on top of it
                    (not (nextto ?m ?y)))) ;; Same for next to
            (forall
                (?c - container)
                (when
                    (inside ?m ?c)
                    (not (inside ?m ?c)))) ;; If m was in a container, it's not anymore
        )
    )

    (:action place-on
        :parameters (?m - movable ?o2 - object)
        :precondition (and
            (holding ?m)
            (reachable ?o2)
        )
        :effect (and
            (ontop ?m ?o2)
            (not (holding ?m))
        )
    )

    (:action place-next-to
        :parameters (?m - movable ?o2 - object)
        :precondition (and
            (holding ?m)
            (reachable ?o2)
        )
        :effect (and
            (nextto ?m ?o2) ;; this will break if we need an object to be both nextto an object inside a container and inside the container itself
            (not (holding ?m))
        )
    )

    (:action place-inside
        :parameters (?m - movable ?c - container)
        :precondition (and
            (holding ?m)
            (reachable ?c)
            (open ?c)
        )
        :effect (and
            (inside ?m ?c)
            (not (holding ?m))
        )
    )

    (:action open-container
        :parameters (?c - container)
        :precondition (and
            (reachable ?c)
            (not (open ?c))
            (forall
                (?x - movable)
                (not (holding ?x))) ;; Agent must not be holding anything
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
            (reachable ?o) ;; make target object reachable

            ;; Make every other object unreachable - ok
            (forall (?x - object)
                (when
                    (not (= ?x ?o)) ;; condition
                    (not (reachable ?x)))) ;; effect

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

            ;; If ?o is inside a container (which is open because of the preconditions), 
            ;; mark the container and all the objects inside as reachable
            ;;(forall (?c - container ?x - object)
            ;;  (when
            ;;    (and
            ;;      ;;(open ?c) ;; should be already true due to preconditions
            ;;      (inside ?o ?c)
            ;;      (inside ?x ?c))
            ;;    (and
            ;;      (reachable ?c)
            ;;      (reachable ?x))))

        )
    )

    (:action slice
        :parameters (?o - sliceable ?s - slicer)
        :precondition (and
            (holding ?s)
            (reachable ?o)
            (not (sliced ?o))
        )
        :effect (and 
            (sliced ?o)
        )
    )
    
)