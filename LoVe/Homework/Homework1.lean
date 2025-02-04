import LoVe.LoVelib
import AutograderLib

namespace LoVe
namespace HW1

/- # Homework 1: Definitions and Statements

The goal of this homework is to get you used to interacting with Lean.
We're not doing any *proving* yet, just some defining!

Replace the placeholders (e.g., `:= sorry`) with your solutions. When you are
finished, submit *only* this file to the appropriate Gradescope assignment.

When you submit to Gradescope, problems tagged as `autogradedProof` or
`autogradedDef` will be autograded. *This is not your final grade*; a
significant portion of the assignment will be manually graded. Therefore, you
should still check your submission for completeness and correctness even if
the autograder does not produce errors.

In the same vein, even if the autograder cannot prove that your definitions
are equal to our solutions, it does not mean that they are semantically incorrect.
Specifically, the autograder will not be able to prove that two functions are
definitionally equal if one contains redundant cases. We will give you partial
credit for this if the function is correct otherwise.

Finally, homework must be done in accordance with the course policies on
collaboration and academic integrity. -/

/- ## Question 1 (6 points): Terms

We start by declaring three new opaque types. -/

opaque α : Type
opaque β : Type
opaque γ : Type

/- ### 1.1 (4 points)

Complete the following definitions by replacing the `sorry`
placeholders with terms of the expected type.

Please use reasonable names for the bound variables, e.g., `a : α`, `b : β`,
`c : γ`.

Hint: A procedure for doing so systematically is described in Section 1.4 of the
Hitchhiker's Guide. As explained there, you can use `_` as a placeholder while
constructing a term. By hovering over `_`, you will see the current logical
context. -/

@[autogradedProof 1] def B : (α → β) → (γ → α) → γ → β :=
  fun f g c ↦ f (g c)

@[autogradedProof 1] def S : (α → β → γ) → (α → β) → α → γ :=
  fun f g a ↦ f a (g a)

@[autogradedProof 1] def moreNonsense : (γ → (α → β) → α) → γ → β → α :=
  fun f c b  ↦ f c (λ a ↦ b) 

@[autogradedProof 1] def evenMoreNonsense : (α → α → β) → (β → γ) → α → β → γ :=
  fun f g a b ↦ g (f a a)

/- ### 1.2 (2 points)

Complete the following definition.

This one looks more difficult, but it should be fairly straightforward if you
follow the procedure described in the Hitchhiker's Guide.

Note: Peirce is pronounced like the English word "purse." -/
@[autogradedProof 2] def weakPeirce : ((((α → β) → α) → α) → β) → β :=
  fun f: ((((α → β) → α) → α) → β) ↦ f (fun g: (α -> β) -> α ↦ g (fun x: α ↦ f (fun h ↦ x)))

/- ## Question 2 (4 points): Typing Derivation

Show the typing derivation for your definition of `S` above, using ASCII or
Unicode art. You might find the characters `–` (to draw horizontal bars) and `⊢`
useful.

Feel free to introduce abbreviations to avoid repeating large contexts `C`. -/

-- Write your solution here
/- 
Let C:= a: α , b: β , c: γ f: α -> β -> γ, g: α -> β 

-------- Var
C ⊢ f: α -> β -> γ, a: α 
------- App      ---Var
⊢ f a: β -> γ    C ⊢ b: β  
----------- App
a: α ⊢ f a b: γ                    
--------- Fun                       
g: α -> β (var?)  ⊢ (fun a: α ↦ f a b): α -> γ  
--------- Fun       
f: α -> β -> γ ⊢ (fun (g: α -> β) (a: α) ↦ f a b): (α -> β) -> α -> γ 
--------- Fun       
 ⊢ (fun (f: α -> β -> γ )(g: α -> β) (a: α) ↦ f a b): (α -> β -> γ ) -> (α -> β) -> α -> γ 
-/





/- ## Question 3 (3 points): Implicit Arguments

In this question, we'll show you some useful syntax features of Lean that will
appear throughout the semester.

There are times when arguments can be inferred easily from context -- there is
only one value they could possibly be. In those cases, it is convenient not to
have to explicitly specify such arguments when calling a function. This mainly
happens with type inferences: a type argument to a function can be inferred from
the types of the arguments that follow.

For example, we define the `append` function for lists: -/

def append (α : Type) : List α → List α → List α
  | List.nil,       ys => ys
  | List.cons x xs, ys => List.cons x (append α xs ys)

/- Because `append` must work for any type of list, the type of the list's
elements is provided as an argument. As a result, the type must be provided in
every call (though we can wite `_` to ask Lean to infer the type).

Note that we use the following convenience notation: `[]` for `List.nil`,
`x :: xs` for `List.cons x xs`, and `[x₁, …, xN]` for `x₁ :: … :: xN :: []`. -/

#check append
#eval append ℕ [3, 1] [4, 1, 5]
#eval append _ [3, 1] [4, 1, 5]
#eval append Bool [true] [true, false]

/- If the type argument is enclosed in `{ }` rather than `( )`, it is implicit
and need not be provided when calling the function (Lean will attempt to infer
it). -/

-- This is defined in the library as `List.append`
def appendImplicit {α : Type} : List α → List α → List α
  | List.nil,       ys => ys
  | List.cons x xs, ys => List.cons x (appendImplicit xs ys)

#eval appendImplicit [3, 1] [4, 1, 5]
#eval appendImplicit [true] [true, false]

/- Notice that we did not need to give the argument `ℕ` or `Bool` to
`appendImplicit`.

Prefixing a definition name with `@` gives the corresponding defintion in
which all implicit arguments have been made explicit. This is useful in
situations where Lean cannot work out how to instantiate the implicit
argument. -/

#check @appendImplicit
#eval @appendImplicit ℕ [3, 1] [4, 1, 5]
#eval @appendImplicit _ [3, 1] [4, 1, 5]

/- ### 3.1 (1 point)

Define the function `reverse`, which takes a list (whose
elements have arbitrary type `α`) and reverses it. Write the type signature and
implement this function. Make the type `α` an implicit argument.

Hint: you might find `List.append` useful in your implementation! You can also
use the notation `xs ++ ys` for `List.append xs ys`. -/


-- write your solution here
def reverse {α : Type}: List α -> List α
  | [] => []
  | x :: xs => reverse xs ++ [x]

-- Once you've written your solution, uncomment these test cases and check that
-- they give the expected outputs
#eval reverse [1, 2, 3, 4, 5] -- expected: [5, 4, 3, 2, 1]
#eval reverse ([] : List ℕ)  -- expected: []
#eval @reverse ℕ []          -- expected: []




/- Notice that when the list argument to `reverse` is empty, it is not clear
what type should be filled in for `α`. (Try evaluating `reverse []`, without
explicitly specifying any types, and see what happens!) The last two examples
above demonstrate two ways to specify types when that happens.

In `reverse ([] : List ℕ)`, we added an explicit type signature to the otherwise
underspecified empty list. This forces the list to have type `List ℕ`, allowing
Lean to determine that `α` must be `ℕ`.

In `@reverse ℕ []`, we used the `@` symbol to force the implicit argument `α` to
be explicit and specify that it should be `ℕ`.

We can also specify *named* implicit arguments by using the following syntax: -/

#eval append (α := ℕ) [] []

/- For functions with multiple implicit arguments, we can also choose to specify
just some of the implicit arguments using named arguments. -/

/- We can also used named arguments with explicit arguments, too! Notice that
in this definition, we're also using *default arguments*: if we specify `x` and
`z` but fail to specify `y` and/or `w`, `y` and/or `w` will automatically be
bound to the values `1` and/or `2`, respectively. Notice also that, using named
arguments, we can pass arguments out of order. -/

def f (x : ℕ) (y : ℕ := 1) (w : ℕ := 2) (z : ℕ) :=
  x + y + w - z

#eval f 4 1 2 3      -- 4 + 1 + 2 - 3
#eval f (z := 3) 4   -- 4 + 1 + 2 - 3
#eval f 4 (z := 3)   -- 4 + 1 + 2 - 3
#eval f 4 0 (z := 3) -- 4 + 0 + 2 - 3

/- ### 3.2 (1 point)

Change the value of `z` below so that the expression evaluates to `2`. -/

#eval f (z := 2) 1


/- ### 3.3 (1 point)

Specify a value for `w` below so that the expression evaluates to `5`. -/

#eval f (y := 3) (x := 1) (z := 1) (w:= 2)
-- 3 + 1 + w - 1
/-
## Question 4 (5 points): Combining Lists

### 4.1. (2 points)

We define the *melding* (a coined term) of two lists to be the list formed
by applying a combining function to each corresponding pair of elements in the
two lists. For instance, the melding of `[1, 2, 3]` and `[4, 5, 6]` using the
combining function `(+)` would be the list `[5, 7, 9]`. If one list is longer
melding of `["a"]` and `["b", "c"]` using `(++)` is `["ab"]`.

Implement a function `meld` that performs this operation.
-/
def meld {α β γ : Type} : (α → β → γ) → List α → List β → List γ
  | f, [], _ => []
  | f,_, []  => []
  | f, x :: xs, y :: ys => (f x y) :: (meld f xs ys)

/-!
### 4.2 (1 point)

The *product* of two types `α` and `β`, denoted `α × β`, is the type of
pairs `(a, b)` such that `a : α` and `b : β`. (`(a, b)` is syntactic sugar for
`Prod.mk a b`, where `Prod.mk : ∀ {α β : Type}, α → β → α × β`.) -/

#check (1, 2)
#check Prod.mk 1951 "X"

/-!
The *zipping* of two lists is the list formed by pairing corresponding
elements. For instance, zipping `[1, 2, 3] : list Nat` and
`["a", "b", "c"] : List String` yields the list
`[(1, "a"), (2, "b"), (3, "c")] : List (Nat × String)`.

Use `meld` to implement `zip`. The only modification you may make to the line
below is to replace `sorry` with a *non-recursive* function.
-/
@[autogradedDef 1, validTactics #[rfl]]
def zip {α β : Type} : List α → List β → List (α × β) :=
meld Prod.mk 

/-
### 4.3 (1 point)

State a lemma that says that the length of the melding of any two lists
using any combining function is equal to the minimum of the lengths of the two
lists.

Hint: `min : ℕ → ℕ → ℕ` returns the minimum of two numbers.
-/

-- Replace `True` with your lemma statement. No need to fill in the `sorry`!
def length {α : Type}: (l: List α ) -> ℤ 
  | [] => 0
  | x :: xs => 1 + length xs

theorem length_meld {α β γ
: Type}(f: α -> β -> γ )(l1: List α )(l2: List β): min (length l1) (length l2) = length (meld f l1 l2) := sorry

/-
### 4.4 (1 point)

`Prod.swap` is a function that will take in a pair `(a, b) : α × β` and
produce the pair `(b, a) : β × α`. That is, it reverses the order of a pair.
-/

#check Prod.swap
#eval Prod.swap (1951, "X")

/-
The following theorem states that zipping lists `xs` and `ys` and then applying
`swap` to each element of the result is the same as zipping `ys` and `xs`.
Is this theorem true? If so, explain why, in natural language.
(You do *not* need to fill in the `sorry`!)
If not, give a counterexample: that is, provide concrete examples for `xs` and `ys`
for which this property does not hold.

-/

theorem swap_zip {α β : Type} (xs : List α) (ys : List β) :
  (zip xs ys).map Prod.swap = zip ys xs :=
sorry

/-
Your answer here:
Two lists are the same if they have the same length and each element is the same. 
1. the length of both list is dicated by the zip application which means the length is min(length xs, length ys). so the lengths are the same
2. on RHS, let x_i be the ith element of  xs and y_i be the ith element of ys. 
- the ith element of zip xs ys is then (x_i, y_i)
- the ithe leemtn of (zip xs ys).map Prod.swap is then (y_i, x_i)
- This is exactly the ith elemnt of zip ys xs. 
- therefore the 2 lists are equivalent.





-/

end HW1 end LoVe
