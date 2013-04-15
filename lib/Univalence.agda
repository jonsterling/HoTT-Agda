{-# OPTIONS --without-K #-}

open import lib.Base
open import lib.Equivalences

module lib.Univalence where

coe : ∀ {i} {A B : Type i} → A == B → A → B
coe idp = idf _

abstract
  idf-is-equiv : ∀ {i} (A : Type i) → is-equiv (idf A)
  idf-is-equiv A =
    record {g = idf A; f-g = λ _ → idp; g-f = λ _ → idp; adj = λ _ → idp }

coe-is-equiv : ∀ {i} {A B : Type i} (p : A == B) → is-equiv (coe p)
coe-is-equiv idp = idf-is-equiv _

ide : ∀ {i} (A : Type i) → A ≃ A
ide A = (idf A , idf-is-equiv A)

coe-equiv : ∀ {i} {A B : Type i} → A == B → A ≃ B
coe-equiv p = (coe p , coe-is-equiv p)

postulate  -- Univalence axiom
  ua : ∀ {i} {A B : Type i} → (A ≃ B) → A == B
  coe-equiv-β : ∀ {i} {A B : Type i} (e : A ≃ B) → coe-equiv (ua e) == e
  ua-η : ∀ {i} {A B : Type i} (p : A == B) → ua (coe-equiv p) == p

postulate -- TODO
  coe-β : ∀ {i} {A B : Type i} (f : A → B) (f-is-equiv : is-equiv f) (a : A)
    → coe (ua (f , f-is-equiv)) a == f a

-- Induction along equivalences

equiv-induction : ∀ {i j} {A B : Set i} (P : {A B : Set i} (f : A ≃ B) → Type j)
  (d : (A : Type i) → P (ide A)) {A B : Type i} (f : A ≃ B)
  → P f
equiv-induction {i} {j} {A} {B} P d f =
  transport P (coe-equiv-β f)
    (equiv-induction-int P d (ua f)) where

  equiv-induction-int : ∀ {j}
    (P : {A : Type i} {B : Type i} (f : A ≃ B) → Type j)
    (d : (A : Type i) → P (ide A)) {A B : Type i} (p : A == B)
    → P (coe-equiv p)
  equiv-induction-int P d idp = d _
