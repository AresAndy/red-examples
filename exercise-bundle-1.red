Red [
    Title: "Exercises from a book, done in Red"
    Author: "Rispoli Silvio"
    Email: "silvio.rispoli.scuola@gmail.com"
    Date: 23-05-2016
    Version: 0.6.0 May build
    License: BSD
    File: %exercise-bundle-1.red
    Purpose: "These bundles should help a new entry get an idea of how Red works"
]

square: function ["Simple helper function, takes a number and .. squares it"
                  n] [ ;notice how no types are specified because of type inference
    power n 2          ;no return keyword is used, since a function returns its last expression, if not specified otherwise
]

comment {
    We can also write comments like this.
    I'll put every exercise in a context, just as a reminder
    of which exercise I'm solving. Context can NOT be changed on the run,
    think of them as a constant structure.
}

ex1: context [
    text: "Determine the speed of a bicycle given its wheel's diameter and the rounds per second"

    bicycle-speed: function ["Returns the speed of a bicycle"
                             diameter "Diameter of the wheels"
                             rounds "Rounds per second"] [
        pi * rounds * diameter
    ]
]

comment {
    How do you use this context? Simple:

    ex1/bicycle-speed 2 34

    In Red, we use the / symbol, because it gives the idea of a path to something
}

tau: pi * 2 ;we can define stuff even outside some code block
g: 9.81

ex2: context [
    text: "Determine the length of a pendulum given its oscillation period"

    length-pendulum: function ["Return the lenght of a pendulum"
                               period "Its oscillation period"] [
        divide power divide period tau 2 g             ;-- was (square(period / tau)) / g
    ]
]

ex3: context [
    text: "Determine the distance between two cartesian coordinates"

    comment {
        We'll represent coordinates like this:

         [1 2]

        Those are series (we'll get into the details of series later on),
        where the first element is the x value, and the second one .. you
        guessed it. As a reminder, the distance between two points A and B,
        regardless of their position, is:

        d = sqrt((Bx - Ax)^2 + (By - Ay)^2)

        We will define some our own predicates, calculate the distance,
        and abstract the concept while we're at it :)
    }

    cartesian2D?: function ["Is this a 2D cartesian point?"
                            point "Thing to be checked"] [
        all [(series? point)             ;in order to be true, point must be a series
             not none? (first point)     ;AND it must have two not null elements
             not none? (second point)]
    ]

    cartesian3D?: function ["Is this a 3D cartesian point?"
                            point "Thing to be checked"] [
        all [cartesian2D? point       ;In order to be 3D, it must be 2D first
             not none? (third point)]
    ]

    distance-coordinate: function ["Distance between point A and B"
                                   p1 "Point A"
                                   p2 "Point B"][
        either all[(cartesian2D? p1) (cartesian2D? p2)] [ ;either A and B are 2D coordinates
            Ax: first p1
            Bx: first p2
            Ay: second p1 ; we can define local variables. Later on during compile time, those
            By: second p2 ; will be capture as /local parameters. See print mold of this function

            square-root (square(Bx - Ax) +
                         square(By - Ay))
        ] [; or 3D
            if all[(cartesian3D? p1) (cartesian3D p2)] [ ;if in Red has no else body
                Ax: first p1
                Bx: first p2
                Ay: second p1
                By: second p2
                Az: third p1
                Bz: third p2
                square-root (square(Bx - Ax) +
                             square(By - Ay) +
                             square(Bz - Az))  ; now you know also how to calculate the distance between 3D coordinates
            ]
        ]
    ]

    perimeter-triang: function ["Calculate the perimeter of a triangle, using its three corner's coordinates"
                                a "Coordinates of corner A"
                                b "Coordinates of corner B"
                                c "Coordinates of corner C"][
        ((distance-coordinate a b) + ;vertex AB
         (distance-coordinate b c) + ;vertex BC
         (distance-coordinate a c))  ;vertex AC
    ]
]

ex4: context [
    text: "Convert a color from RGB (red green blue) to the printers standard"

    rgb-to-printer: function ["Convert from RGB to printer standard"
                              r "Red component"
                              g "Green component"
                              b "Blue component"] [
        ret: []              ; we create an empty series
        append ret (255 - r) ; and append every color after conversion
        append ret (255 - g)
        append ret (255 - b)
        ret                  ; we could have written return ret, but since the last expression is always returned
                             ; we can simply write ret
    ]
]

ex5: context [
    text: "Calculate the Maximum Common Divider of two numbers"

    MCD: function [a b][         ;the MCD is the MCD, if documentation is required for this, first do some math at school
        either b == 0 [a]        ;recursion, ladies and gents
            [MCD b (modulo a b)]
    ]
]

ex6: context [
    text: "Given a fraction, reduce it to its minimal terms"

    num: function [frac] [first frac]
    den: function [frac] [second frac] ; some helper functions for readability

    print-frac: function ["Pretty-prints a fraction"
                          frac "Prints this fraction"] [
        if series? frac [
            print num frac
            if (den frac) <> 1 [
                print "-"
                print den frac
            ]
        ]
    ]

    comment {
        Math remainder:

        In order to minimize a fraction, you must divide numerator and denominator
        by their MCDs
    }

    minim-frac: function ["Reduces a fraction to its minimal terms"
                          frac "Fraction to be reduced"] [
        ret: [] ; we create a new fraction
        either series? frac [
            num: first frac
            den: second frac
            append ret num / es5/MCD num den
            append ret den / es5/MCD num den ; and append the reduced terms
        ] [1] ; or return 1, rather than giving an error and crash the application
    ]
]

ex7: context [
    text: "Multiply two fractions together"

    frac-prod: function ["Multiplies two fractions"
                         a "Fraction a"
                         b "Fraction b"] [
        if all [series? a series? b] [
            ret: []
            append ret ((es6/num a) * (es6/num b))
            append ret ((es6/den a) * (es6/den b)) ; we multiply term by term, put the results in a new fraction
            es6/minim-frac ret                     ; and then minimize it
        ]
    ]
]

comment {
    As a treat, I'll give you the definition of the iota function,
    and some homework :D .. The examples above might be faulty, because:
    1) I'm human
    2) I'm expert enough to do this thing in Red
    3) I'm not expert enough in Red, so I'm sure there are things to change/improve

    Feel free to do so, and send at the email written at the start of the document any suggestion or fix made.
    I'll upload commits giving credit to who suggested an useful change. #go #team #red

    Bye,
    Silvio
}

iota: function ["Return a sequence of number from 1 to n"
                n "End limit of sequence"] [
    seq: copy []
    repeat i n [append seq i]
]
