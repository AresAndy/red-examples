Red [
    Title: "Exercises from a book, done in Red"
    Author: "Rispoli Silvio"
    Email: "silvio.rispoli.scuola@gmail.com"
    Date: 24-05-2016
    Version: 0.6.0 May build
    License: BSD
    File: %exercise-bundle-2.red
    Purpose: "These bundles should help a new entry get an idea of how Red works"
]

take-n: function ["take already exists, but I want my version of it :D"
                  l "Series to take from"
                  n "Number of elements to take"][

    res: first l ; Just to give it something, and help type inference as well

    i: 1
    while [i > n] [
      append res (pick l i)
      i: i + 1
    ]
    res
]

ex1: context [
    text: "Determine the minimum, maximum and average value of a series"

    vmin: function ["Minimum applied over a series"
                    vect ][
        vet-i: first vect

        forall vect [  ;for all elements in vect
            vet-i-1: second vect
            if all [(not none? vet-i-1) vet-i > vet-i-1] [vet-i: vet-i-1] ; determine which one is the smallest
        ]
        vet-i
    ]

    vmax: function ["Maximum applied over a series"
                    vet][
        vet-i: first vet

        forall vet [
            vet-i-1: second vet
            if all [(not none? vet-i-1) vet-i < vet-i-1] [vet-i: vet-i-1] ; determine which one is the biggest
        ]
        vet-i
    ]

    vavg: function ["Average of a series"
                    vet][
        l: length? vet
        tot: 0.0 ; use the point to tell Red "this must be floating point"

        forall vet [ ; sum all elements together
            tot: tot + index? vet
        ]
        tot / l ; divide the total by the number of elements
    ]
]

ex2: context [
    text: "Verify if a word or sentence is palindrome"

    comment {
      Any word or phrase is palindrome if you can read it from left to right and backwards
      remaining the same. Examples of palindrome strings:
      - radar
      - ABBA
      - Never a foot too far, even.

      We can check if a string is palindrome by uppercasing it, removing every blank space and
      special characters like ".", "!", "[]", splitting it in half
      and then see if the first half is equal to the other half when reversed.
    }

    palindrome: function ["Check if a string is palindrome"
                          str "String to check"][
        l: length? str
        s: trim (uppercase str)                    ;trims blank spaces and uppercase the string
        equal? (take-n s l) (take-n (reverse s) l) ;checks the two halves
    ]

    comment {
        This function does not handle special characters yet, it's an exercise for you:
        Allow the function palindrome to handle special characters.

        HINT:

        >> replace "hello." "." ""
        "hello"
    }
]
