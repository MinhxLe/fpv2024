import LoVe.Lectures.LoVe01_02_TypesAndTerms_Demo


/- # FPV Lab 1: Definitions and Statements

Replace the placeholders (e.g., `:= sorry`) with your solutions. -/


set_option autoImplicit false
set_option tactic.hygienic false

namespace LoVe


/- ## Question 1: Terms

Complete the following definitions by replacing the `sorry` markers with terms
of the expected type.

Hint: A procedure for doing so systematically is described in Section 1.4 of
the Hitchhiker's Guide. As explained there, you can use `_` as a placeholder
while constructing a term. By hovering over `_`, you will see the current
logical context. -/

def I : α → α :=
  fun a ↦ a

def K : α → β → α :=
  fun a b ↦ a

def C : (α → β → γ) → β → α → γ :=
  fun f b a ↦ f a b

def projFst : α → α → α :=
  fun a b ↦ a

/- Give a different answer than for `projFst`. -/

def projSnd : α → α → α :=
  fun a b ↦ b

def someNonsense : (α → β → γ) → α → (α → γ) → β → γ :=
  fun a b c d  ↦  a b d


/- ## Question 2: Typing Derivation

Show the typing derivation for your definition of `C` above, on paper or using
ASCII or Unicode art. You might find the characters `–` (to draw horizontal
bars) and `⊢` useful. -/

-- write your solution in a comment here or on paper
/- 
I want to show fun f b c ↦ f b c

Let C := f: α -> β -> γ , b: β, a: α

------- Var
C ⊢ f: α -> β -> γ , a: α 
-------------- App    ------- Var
C ⊢ f a: β -> γ        C ⊢ b: β 
---------------- App
f a: (β -> γ), b: Β ⊢ f a b: γ 
-------- Fun
f: α -> β -> γ, b: β  ⊢ (fun a: α ↦ f a b): α -> γ 
-------- Fun (a new unbounded b)
f: α -> β -> γ  ⊢ (fun (b: β)(a: α) ↦ f a b): β -> α -> γ 
-------- Fun 
⊢ (fun (f: α -> β -> γ)(b: β)(a: α) ↦ f a b): (α -> β -> γ  -> β -> α -> γ 
-/


/- ## Question 3: Arithmetic Expressions

Consider the type `AExp` from the lecture and the function `eval` that
computes the value of an expression. You will find the definitions in the file
`LoVe02_ProgramsAndTheorems_Demo.lean`. One way to find them quickly is to

1. Hold down the Control (on Linux and Windows) or Command (on macOS) key,
2. Move the cursor to the identifier `AExp` or `eval`, and
3. Click the identifier.
-/

#check AExp
#check eval

/-
### 3.1.

Test that `eval` behaves as expected. Make sure to exercise each
constructor at least once. You can use the following environment in your tests.
What happens if you divide by zero?

Note that `#eval` (Lean's evaluation command) and `eval` (our evaluation
function on `AExp`) are unrelated. -/

def someEnv : String → ℤ
  | "x" => 3
  | "y" => 17
  | _   => 201

#eval eval someEnv (AExp.var "x")   -- expected: 3
-- invoke `#eval` here
#eval eval someEnv (AExp.add (AExp.var "x") (AExp.num 1))
#eval eval someEnv (AExp.sub (AExp.var "x") (AExp.var "y"))
#eval eval someEnv (AExp.mul (AExp.var "x") (AExp.var "y"))
#eval eval someEnv (AExp.mul (AExp.var "x") (AExp.var "y"))
-- why does this evaluate to 0
#eval eval someEnv (AExp.div (AExp.var "x") (AExp.num 0))

/-
### 3.2.

The following function simplifies arithmetic expressions involving
addition. It simplifies `0 + e` and `e + 0` to `e`. Complete the definition so
that it also simplifies expressions involving the other three binary
operators. -/

def simplify : AExp → AExp
  | AExp.add (AExp.num 0) e₂ => simplify e₂
  | AExp.add e₁ (AExp.num 0) => simplify e₁

  | AExp.sub e₁ (AExp.num 0) => simplify e₁

  | AExp.mul e₁ (AExp.num 1) => simplify e₁
  | AExp.mul (AExp.num 1) e₂ => simplify e₂

  | AExp.div e₁ (AExp.num 1) => simplify e₁
  -- insert the missing cases here
  -- catch-all cases below
  | AExp.num i               => AExp.num i
  | AExp.var x               => AExp.var x
  | AExp.add e₁ e₂           => AExp.add (simplify e₁) (simplify e₂)
  | AExp.sub e₁ e₂           => AExp.sub (simplify e₁) (simplify e₂)
  | AExp.mul e₁ e₂           => AExp.mul (simplify e₁) (simplify e₂)
  | AExp.div e₁ e₂           => AExp.div (simplify e₁) (simplify e₂)

/-
### 3.3.

Is the `simplify` function correct? In fact, what would it mean for it
to be correct or not? Intuitively, for `simplify` to be correct, it must
return an arithmetic expression that yields the same numeric value when
evaluated as the original expression.

Given an environment `env` and an expression `e`, state (without proving it)
the property that the value of `e` after simplification is the same as the
value of `e` before. -/

theorem simplify_correct (env : String → ℤ) (e : AExp) :
  eval env e = eval env (simplify e) :=   -- replace `True` with your theorem statement
  sorry     -- leave `sorry` alone

/-! ## Question 4: Lists and Options

Another common inductive datatype in functional programming is the `Option`
type. Intuitively, an `Option α` is a "possibly-empty container" that either
holds a single value of type `α` or is "empty." The type is defined as follows:

  inductive Option (α : Type)
  | none           : Option α
  | some (val : α) : Option α

We can pattern-match on options just as we do on `List`s or `AExp`s.

Here are some examples of options: -/

#check (none : Option Nat)
#check (none : Option Bool)
#check some "hello"
#check some 14
#check some (λ x => 2 * x)
/-!
### 4.1.

Declare a function `omap : (α → β) → List (Option α) → List (Option β)`
that applies a provided function to every non-"empty" element of a list of
options. In other words, given a function `f` and list `xs`, `omap` should take
every element of `xs` of the form `some x` to the element `some (f x)` in the
output; and it should take every element of `xs` of the form `none` to `none` in
the output. Here's an example:

`omap (λ x => x + 1) [some 0, none, some 2] = [some 1, none, some 3]` -/

def omap {α β : Type} (f : α → β) : List (Option α) → List (Option β)
  | List.nil => List.nil
  | List.cons Option.none xs => List.cons Option.none (omap f xs)
  | List.cons (Option.some x) xs => List.cons (Option.some (f x)) ((omap) f xs)

/-!

### 4.2.

State as Lean theorems (without proving them) the so-called functorial
properties of `omap`, which are stated informally below:

- `omap`ping the identity function over a list gives back that same list.
- `omap`ping the composition of two functions `g` and `f` over a list gives the
  same result as first `omap`ping `f` over that list and then `omap`ping `g`
  over the result.

Try to give meaningful names to your theorems, and make sure to state them
as generally as possible. You can enter `sorry` in lieu of a proof. -/

  -- Write your theorem statements here

theorem omap_identity_is_identity (l: List (Option α)): 
  l = omap I l := sorry

theorem omap_is_distributive (l: List (Option α))(f: α -> β )(g: β -> γ): 
  omap g (omap f l)  = omap (λ x ↦ g (f x)) l:= sorry
