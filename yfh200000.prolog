%1- Div by x
div-by-xy(X, Y, Z) :-
    0 is X mod Y,
    0 is X mod Z.

%2 -List Product
% Predicate to calculate the product of a list of numbers
% If the input list is empty, the product is 0
list_prod([], 0).

% If the input list contains a single element, the product is that element
list_prod([X], X):- !.

% For lists with more than one element:
list_prod([H|T], Product) :-
    % Recursively calculate the product of the tail of the list
    list_prod(T, RestProduct),
    % Multiply the head of the list with the product of the rest of the list
    Product is H * RestProduct.

%3 - palindrome
palindrome(List) :-
    reverse(List,List). %The predicate reverses the order of elements in the list and compare it with the original list

%4 - secondMin
% insert(X1, List, SortedList) inserts X1 into SortedList so that SortedList remains sorted.
insert(X1, [], [X1]) :- !. % Base case: If the list is empty, X1 becomes the single element of the new list.
insert(X1, [X2|L], [X1, X2|L]):- X1 =< X2, !. % If X1 is less than or equal to the head of the list, insert X1 before X2.
insert(X1, [X2|L2], [X2|L1]):- insert(X1, L2, L1). % Recursively insert X1 into the tail of the list.

% mySort(List, SortedList) sorts the input List using insertion sort algorithm.
mySort([], []) :- !. % Base case: Sorting an empty list results in an empty list.
mySort([X|L], S):- mySort(L, S1), insert(X, S1, S). % Sort the tail of the list, then insert the head into the sorted tail.

% isListOfOneValue_Helper(List, Value) checks if all elements of List are equal to Value.
isListOfOneValue_Helper([], _). % Base case: An empty list trivially satisfies the condition.
isListOfOneValue_Helper([H|T], X) :-
    (   H = X
    ->  isListOfOneValue_Helper(T, X) % If the head of the list is equal to X, check the tail.
    ;   false). % Otherwise, the list contains elements different from X.

% isListOfOneValue(List) checks if all elements of List are equal to each other.
isListOfOneValue([H|T]) :-
    isListOfOneValue_Helper(T, H). % Call the helper predicate to check if all elements are equal to the head.

% getSecondDistinct_Helper(List, Value, SecondDistinct) finds the second distinct element in List after Value.
getSecondDistinct_Helper([], _, _). % Base case: An empty list cannot have a second distinct element.
getSecondDistinct_Helper([Min2|T], X, Min2) :-
    (   X = Min2
    ->  getSecondDistinct_Helper(T, X, Min2) % If Min2 equals X, continue checking the tail.
    ;   true). % Otherwise, Min2 is the second distinct element.

% getSecondDistinct(List, SecondDistinct) finds the second distinct element in List.
getSecondDistinct([H|T], Min2) :-
    getSecondDistinct_Helper(T, H, Min2). % Call the helper predicate with the head of the list as the initial value.

% myNumberListPrint(List) prints all elements of List that are numbers.
myNumberListPrint([]). % Base case: An empty list has no numbers to print.
myNumberListPrint([H|T]) :-
    number(H), myNumberListPrint(T), !. % If the head is a number, print it and continue with the tail.
myNumberListPrint([H|_]) :-
    \+ number(H), write(H). % If the head is not a number, print it.

% secondMin(List, Min2) finds the second smallest element in List.
secondMin(List, Min2) :-
    \+ List = [], % Ensure the list is not empty.
    (   maplist(number, List)
    ->  (   \+ isListOfOneValue(List) % If the list contains more than one unique value.
    	->   mySort(List, Sorted), getSecondDistinct(Sorted,Min2) % Sort the list and find the second distinct element.
    	;   format("ERROR: List has fewer than two unique elements.\n"), fail) % Otherwise, print an error message.
    ;   format("ERROR: \""), myNumberListPrint(List), format("\" is not a number"), nl, fail). % If the list contains non-numeric elements, print an error message.


%5-Classify
% Predicate to check if an element is even
is_even(N) :- 0 is N mod 2.

% Predicate to check if an element is odd
is_odd(N) :- 1 is N mod 2.

% Predicate to check if an element is an integer
is_integer(N) :- integer(N).

% Predicate to check if an element is a string
is_string(S) :- string(S).

% Classify predicate for even and odd numbers
classify(even, List, Even, Odd) :-
    partition(is_even, List, Even, Odd).
classify(odd, List, Odd, Even) :-
    partition(is_odd, List, Odd, Even).

% Classify predicate for integers and non-integers
classify(integer, List, Int, NotInt) :-
    partition(is_integer, List, Int, NotInt).
classify(string, List, String, NotString) :-
    partition(is_string, List, String, NotString).

%6-bookends
bookends(List1, List2, List3) :-
    append(List1,_,List3), %List3 is the concatenation of List1 + Some list
    append(_,List2,List3), %List3 is the concatenation of Some list + List2
    !.
%7-subslice
% subslice(Subslice, List) checks if Subslice is a subslice of List.
subslice(Subslice, List) :- 
    % Using append to break List into two parts: Subslice and Rest.
    append(_, Rest, List), % Rest is a suffix of List.
    % Further using append to break Rest into two parts: Subslice and the remaining part (which we discard).
    append(Subslice, _, Rest), 
    !. % Cut operator to prevent backtracking after finding a solution.

%8-Shift
% Base case: Shifting an empty list results in an empty list
shift([], [], _).

% Predicate to shift elements in a list by a specified number of positions
shift(List, N, Shifted) :-
    % Get the length of the list
    length(List, Length),
    % Normalize the shift amount to ensure it's within the range of list indices
    NNormalized is N mod Length,
    % Split the list into two parts at the normalized shift position
    split_list(List, NNormalized, L1, L2),
    % Concatenate the second part with the first part to create the shifted list
    append(L2, L1, Shifted).

% Predicate to split a list into two parts at a specified position
split_list(List, 0, [], List) :- !.
split_list([H|T], N, [H|L1], L2) :-
    % If N is greater than 0, split the list recursively
    N > 0,
    N1 is N - 1,
    split_list(T, N1, L1, L2).

%9-Luhn Algorithm
% Predicate to calculate the sum of digits of an integer
splitSum(Integer, Result) :-
    % Extract the last digit of the integer
    X is Integer mod 10,
    % Remove the last digit from the integer
    Y is div(Integer, 10),
    % Calculate the sum of the last digit and the remaining integer
    Result is X + Y.

% Predicate to calculate the sum of two digits according to the Luhn algorithm
sumOfTwo(Integer, Result) :-
    % Extract the last digit of the integer
    X is Integer mod 10,
    % Remove the last digit from the integer
    Y is div(Integer, 10),
    % Double the value of the last digit
    Z is Y * 2,
    % If the doubled value is greater than 9, split and sum its digits
    (   Z > 9
    ->  splitSum(Z, R1), Result is R1 + X
    ;   Result is X + Z).

% Predicate to calculate the sum of digits in an integer using the Luhn algorithm
sumOfDigits(0, Result, Result).
sumOfDigits(Integer, Sum, Result) :-
    % Extract the last two digits of the integer
    X is Integer mod 100,
    % Remove the last two digits from the integer
    Y is div(Integer, 100),
    % Calculate the sum of two digits according to the Luhn algorithm
    sumOfTwo(X, R1),
    % Update the cumulative sum
    Z is Sum + R1,
    % Recursively process the remaining integer
    sumOfDigits(Y, Z, Result), !.

% Predicate to check if an integer satisfies the Luhn algorithm
luhn(Integer) :-
    % Calculate the sum of digits using the Luhn algorithm
    sumOfDigits(Integer, 0, Result),
    % Check if the sum is divisible by 10
    R is Result mod 10,
    R = 0.
%10 - Zebra Puzzle
% Define the domain of attributes
shirt([blue, green, pink, red, white]).
name([ann, cheryl, jill, lori, susan]).
destination([australia, chile, jamaica, morocco, thailand]).
visit([brother, cousin, grandfather, nephew, uncle]).
duration([5, 10, 15, 20, 25]).
age([30, 35, 40, 45, 50]).

% Predicate to determine who is traveling for 10 days
who(Name) :-
    % Define a list of lists representing women's attributes
    Women = [[_, _, _, _, _, _], [_, _, _, _, _, _], [_, _, _, _, _, _], [_, _, _, _, _, _], [_, _, _, _, _, _]],
    % Retrieve the list of names
    name(Names),
    % Assign unique names to each woman
    assign_names(Women, Names),
    % Clues for determining who is traveling for 10 days
    member([blue, _, morocco, _, _, _], Women), % The woman wearing the Blue shirt is going to travel to Morocco.
    member([_, _, _, _, 15, 50], Women), % The oldest woman is going to travel for 15 days.
    next_to([_, _, _, _, _, 35], [_, _, _, nephew, _, _], Women), % The 35-year-old woman is exactly to the left of the woman that is going to visit her Nephew.
    right_of([green, _, _, _, _, _], [_, _, _, _, _, 45], Women), % The 45-year-old woman is somewhere to the right of the woman wearing the Green shirt.
    Women = [_, _, [_, _, _, _, _, 50], _, _], % The 50-year-old woman is at the third position.
    left_of([_, _, _, _, 5, _], [green, _, _, _, _, _], Women), % The woman wearing the Green shirt is somewhere to the left of the woman traveling for 5 days.
    Women = [_, _, _, _, [_, _, _, uncle, _, _]], % At the fifth position is the woman who is going to visit her Uncle.
    next_to([_, jill, _, _, _, _], [_, _, australia, _, _, _], Women), % Jill is next to the woman that is going to the Outback.
    next_to([_, _, _, _, 20, _], [_, _, _, _, _, 35], Women), % The woman traveling for 20 days is exactly to the right of the 35-year-old woman.
    between_women([pink, _, _, _, _, _], [white, _, _, _, _, _], [red, _, _, _, _, _], Women), % The woman wearing the White shirt is somewhere between the woman wearing the Pink shirt and the woman wearing the Red shirt, in that order.
    next_to([_, _, chile, _, _, _], [_, _, _, _, _, 45], Women), % The woman who is going to Chile is visiting her Brother.
    right_of([red, _, _, _, _, _], [_, _, _, _, _, 40], Women), % The 40-year-old woman is somewhere to the right of the woman wearing the Red shirt.
    next_to([_, cheryl, _, _, 10, _], [_, _, _, _, 15, _], Women), % Cheryl is exactly to the right of the woman that is going to travel for 15 days.
    member([_, _, chile, brother, _, _], Women), % The woman who is going to Chile is visiting her Brother.
    next_to([_, _, _, grandfather, _, _], [_, _, australia, _, _, _], Women), % The woman who is going to Sydney is exactly to the left of the woman visiting her Grandfather.
    next_to([_, ann, _, _, _, _], [_, _, _, brother, _, _], Women), % Ann is next to the woman that is visiting her Brother.
    between_women([_, _, _, _, 25, _], [_, ann, _, _, _, _], [_, _, white, _, _, _], Women), % The woman wearing the White shirt is somewhere between the woman that is going to travel for 25 days and Ann, in that order.
    next_to([green, _, _, _, _, _], [_, _, _, grandfather, _, _], Women), % The woman that is going to visit her Grandfather is next to the woman wearing the Green shirt.
    member([pink, jill, _, _, _, _], Women), % Jill is wearing the Pink shirt.
    next_to([_, _, thailand, _, _, _], [_, _, _, _, _, 30], Women), % The 30-year-old woman is exactly to the left of the woman that is going to Thailand.
    member([_, Name, _, _, 10, _], Women), % Find who is traveling for 10 days
    !. % Cut to prevent backtracking

% Assign unique names to each woman
assign_names([], _).
assign_names([W|Ws], Names) :-
    select(Name, Names, RemainingNames),
    W = [_, Name, _, _, _, _],
    assign_names(Ws, RemainingNames).

% Define spatial predicates

% Predicate to check if two elements are adjacent in a list
next_to(X, Y, List) :-
    append(_, [X,Y|_], List) ; append(_, [Y,X|_], List).

% Predicate to check if X is to the right of Y in a list
right_of(X, Y, List) :-
    append(_, [Y|Tail], List), member(X, Tail).

% Predicate to check if X is to the left of Y in a list
left_of(X, Y, List) :-
    append(_, [X|Tail], List), member(Y, Tail).

% Predicate to check if X, Y, and Z are consecutive in a list
between_women(X, Y, Z, List) :-
    append(_, [X|Tail], List),
    append(_, [Y|Tail2], Tail),
    append(_, [Z|_], Tail2).
