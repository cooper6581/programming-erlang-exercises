-module(geometry).
-export([area/1, perimeter/1, test/0]).

area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) -> math:pi() * Radius * Radius;
area({rtriangle, A, B}) -> (A * B) / 2.

perimeter({rectangle, Width, Height}) -> 2 * (Width + Height);
perimeter({square, Side}) -> 4 * Side;
perimeter({circle, Radius}) -> 2 * math:pi() * Radius;
perimeter({rtriangle, A, B}) -> A + B + (math:sqrt(A * A + B * B)).

test() ->
    35                = area({rectangle, 5, 7}),
    36                = area({square, 6}),
    68.51468002287444 = area({circle, 4.67}),
    24.0              = area({rtriangle, 12, 4}),
    10                = perimeter({rectangle, 2, 3}),
    12                = perimeter({square, 3}),
    87.96459430051421 = perimeter({circle, 14}),
    10.47213595499958 = perimeter({rtriangle, 4, 2}),
    passed.
