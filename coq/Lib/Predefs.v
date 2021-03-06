
Require Import Coq.Unicode.Utf8.
Require Import Coq.Bool.Bool.
Require Import Coq.Arith.EqNat.
Require Import Coq.Arith.Peano_dec.
Require Import Coq.Arith.Compare_dec.
Require Import Coq.Lists.List.
(* Require Import Coq.Lists.ListSet. *)



(*
Print sumbool.
Delimit Scope value with value.
Notation "a && b" := (andb a%value b%value).
Notation "a || b" := (orb a%value b%value).
Notation "a && b" := (if a then (if b then true else false) else false).
Notation "a || b" := (if a then true else (if b then true else false)).
Notation "!! a" := (match a with 
                      | left p => right p 
                      | right p => left p
                    end) (at level 20).
*)

Notation "'Yes'" := (left _ _).
Notation "'No'" := (right _ _).
Notation "'Decide' x" := (if x then Yes else No) (at level 50).


(*
Definition Nat := nat.
Definition s := S.
*)

(*
Require Export Coq.Arith.EqNat.
Require Export Coq.Arith.Compare_dec.
Notation "a =_? b" := (beq_nat a b) (at level 20).
Notation "a <>_? b" := (negb (beq_nat a b)) (at level 20).

Notation "a <=_? b" := (leb a b) (at level 20).
Definition ltb a b := 
  if (a =_? b) then
    false
  else
    if (a <=_? b) then
      true
    else
      false.
Notation "a <_? b" := (ltb a b) (at level 20).
Definition eq_dec (a b: nat): {a = b} + {a <> b}.
Proof.
  decide equality.
Qed.

*)



Notation "a =_? b" := (eq_nat_dec a b) (at level 20).
Notation "a <>_? b" := (negb (a =_? b)) (at level 20).
Notation "a <_? b" := (lt_dec a b) (at level 20).
Notation "a <=_? b" := (le_dec a b) (at level 20).
Notation "a >_? b" := (gt_dec a b) (at level 20).
Notation "a >=_? b" := (ge_dec a b) (at level 20).

Notation "a <>? b" := (negb (beq_nat a b)) (at level 70).
Notation "a =? b" := (beq_nat a b) (at level 70).
Notation "a <=? b" := (leb a b) (at level 70).


(*
  Programming bools
  &&  ||  =?  <>?  <=?
  ----
  andb_prop
  orb_prop
  beq_nat_true_iff  beq_nat_false_iff
  leb_iff
  negb_true_iff  negb_false_iff
*)

Lemma eq_nat_dec_eq:
  forall (A: Type) n (s1 s2: A),
    (if eq_nat_dec n n then s1 else s2) =
    s1.

  Proof.
    intros.
    destruct (eq_nat_dec n n).
    reflexivity.

    exfalso. apply n0. reflexivity.
  Qed.

Lemma eq_nat_dec_neq:
  forall (A: Type) n n' (s1 s2: A),
    (not (n = n'))
    -> (if eq_nat_dec n n' then s1 else s2) =
       s2.

  Proof.
    intros.

    destruct (eq_nat_dec n n').
    exfalso. apply H in e. assumption.

    reflexivity.    
  Qed.

  Lemma fold_left_and_false:
    forall (A: Type) ls (f: A -> bool),
      fold_left (fun b l => b && f l) ls false = false.
    
    Proof.
      intros.
      induction ls.
      simpl.
      reflexivity.
      simpl.
      assumption.
    Qed.


  Lemma fold_left_and:
    forall (A: Type) ls (l: A) f,
      (fold_left (fun b l => b && f l) ls true = true
       /\ In l ls)
      -> f l = true.

    Proof.
      intros.
      destruct H.
      generalize dependent l.
      generalize dependent f.
      induction ls.

      intros. unfold In in H0. contradiction.

      intros.
      apply in_inv in H0.
      destruct H0.

      subst a.
      simpl in H.
      destruct (f l).
      reflexivity.
      simpl in H.
      rewrite fold_left_and_false in H.
      assumption.
      
      apply IHls.
      simpl in H.
      destruct (f a).
      assumption.
      rewrite fold_left_and_false in H.
      inversion H.
      assumption.
    Qed.

(*
Definition Option := option.
Definition some {A: Type} := @Some A.
Definition none {A: Type} := @None A.
*)

Require Import Coq.Lists.List.
(* Require Import Coq.Lists.List.ListNotations. *)
(*
Definition List := list.
Notation " [ ] " := nil.
Notation " [ x ] " := (cons x nil).
*)
Notation " [ x ; .. ; y ] " := (cons x .. (cons y nil) ..).



(* 
Print proj1_sig.
Definition elem (A : Type) (P : A → Prop) (e : {x | P x}): A := @proj1_sig A P e.
*)


Theorem call:
  forall {A B : Type} {f g: A -> B} (x: A),
    f = g -> f x = g x.

  Proof.
    intros.
    rewrite H.
    reflexivity.
  Qed.

Theorem f_equal : forall (A B : Type) (f: A -> B) (x y: A), 
                    x = y -> f x = f y. 
Proof.
intros A B f x y eq. rewrite eq. reflexivity. 
Qed.

Theorem f2_equal : forall (A B C: Type) (f: A -> B -> C) (x1 x2: A)(y1 y2: B), 
                    (x1 = x2 /\ y1 = y2) -> f x1 y1 = f x2 y2. 
Proof.
intros A B C f x1 x2 y1 y2 eq. destruct eq as [eq1 eq2]. rewrite eq1. rewrite eq2. reflexivity. 
Qed.

Theorem f3_equal : forall (A B C D: Type) (f: A -> B -> C -> D)
                          (x1 x2: A)(y1 y2: B)(z1 z2: C), 
                     (x1 = x2 /\ y1 = y2 /\ z1 = z2) -> f x1 y1 z1 = f x2 y2 z2. 
Proof.
intros A B C D f x1 x2 y1 y2 z1 z2 eq. 
destruct eq as [eq1 [eq2 eq3]].
rewrite eq1. 
rewrite eq2. 
rewrite eq3. 
reflexivity. 
Qed.

Axiom functional_extensionality: ∀{X Y: Type} {f g : X → Y},
  (∀(x: X), f x = g x) → f = g.



Definition nat_dec (n: nat): {n' | n = S n'} + {n = 0}.
  destruct n; eauto.
Defined.

Definition option_dec {A}(n: option A): {n' | n = Some n'} + {n = None}.
  destruct n; eauto.
Defined.

(* ------------------------------------------------------- *)
(* General tactics. *)

Tactic Notation "open_conjs" :=
  repeat(match goal with
           | [ H : _ /\ _ |- _ ] => destruct H
         end).

Tactic Notation "split_all" :=
  repeat(match goal with
           | [ |- _ /\ _ ] => split
         end).


Ltac specex H :=
  repeat match type of H with
           | forall x : ?T, _ =>
             match type of T with
               | Prop =>
                 fail 1
               | _ =>
                 let x := fresh "x" in
                   evar (x : T);
                   let x' := eval unfold x in x in
                     clear x; specialize (H x')
             end
         end.

Ltac depremise H :=
  match type of H with
    | forall x : ?T, _ =>
      let x := fresh "x" in
      assert (x: T);
      [ clear H | specialize (H x); clear x ]                  
  end.

Ltac specex_deprem H :=
  specex H; depremise H.

Ltac subv x :=
  match goal with 
    | H: x = _ |- _ => rewrite H; simpl
    | H: _ = x |- _ => rewrite <- H; simpl
    | _ => try unfold x; simpl
  end.

Ltac subv_in x H' :=
  match goal with 
    | H: x = _ |- _ => rewrite H in H'; simpl in H'
    | H: _ = x |- _ => rewrite <- H in H'; simpl in H'
    | _ => try unfold x in H'; simpl in H'
  end.

  (*
  Lemma subv_test:
    let m := 0 in
    forall a b c d e, 
      c = 2 + 2
      -> 2 + 2 = d
      -> m + 1 = e
      -> a = 0
      -> 0 = b
      -> a + b = m + 2
      -> a + b = m.

    Proof.
      intros.
      subv b.
      subv a.
      subv m.
      subv_in a H4.
      subv_in b H4.
      subv_in m H4.     
    Qed.
  *)

(*
Tactic Notation "depremise" ident(H) :=
  match goal with
    | [ H: ?ps -> _ |- _ ] => 
      assert (PS: ps);
      [ clear H | match goal with
                    | PS: _ |- _ => specialize (H PS); clear PS
                  end]
  end.
*)

Tactic Notation "rewrite_clear" ident(H) ident(H') :=
  rewrite H in H'; clear H.
      
Tactic Notation "r_rewrite_clear" ident(H) ident(H') :=
  rewrite <- H in H'; clear H.


Tactic Notation "bool_to_prop" :=
  try match goal with
    | [ |- negb _ = true ] =>  try apply negb_true_iff
    | [ |- negb _ = false ] =>  try apply negb_false_iff
  end;
  (apply andb_prop ||
   apply orb_prop ||
   apply beq_nat_true_iff ||
   apply beq_nat_false_iff ||
   apply leb_iff).

Tactic Notation "bool_to_prop_in" ident(H) :=
  try match goal with
    | [ H: negb _ = true |- _ ] =>  try apply negb_true_iff in H
    | [ H: negb _ = false |- _ ] =>  try apply negb_false_iff in H
  end;
  (apply andb_prop in H ||
   apply orb_prop in H ||
   apply beq_nat_true_iff in H ||
   apply beq_nat_false_iff in H ||
   apply leb_iff in H).


(* ------------------------------------------------------- *)
(* list set lemmas *)


Lemma nil_cons_end:
  forall (T: Type)(l: list T)(e: T),
    not((l++[e]) = nil).

  Proof.
    intros.
    intro.
    destruct l.

      rewrite app_nil_l in H.
      assert (A := @nil_cons T e nil).
      symmetry in H.
      apply A in H.
      assumption.

      rewrite <- app_comm_cons in H.
      assert (A := @nil_cons T t (l ++ [e])). 
      symmetry in H.
      apply A in H.
      assumption.

  Qed.

Lemma list_end:
  forall (T: Type)(l: list T),
    l = nil \/ exists l' e, l = l' ++ [e].

  Proof.
    intros.
    destruct l.

      left. reflexivity.
      
      right.
      assert (A1 := @nil_cons T t l).
      apply not_eq_sym in A1.

      assert (A2 := @exists_last T (t :: l) A1). 
      destruct A2. destruct s.
      exists x. exists x0.
      assumption.
  Qed.

Lemma cons_to_app:
  forall {T: Type}(ls: list T)(e: T),
    e :: ls = [e] ++ ls.

  Proof.
    intros.
    assert (A := app_nil_l ls).
    rewrite <- A at 1.
    rewrite app_comm_cons.
    reflexivity.
  Qed.

  

Lemma filter_filter:
  forall A (f g: A->bool) l,
    filter f (filter g l) = filter (fun x => (andb (f x) (g x))) l.
Proof.
  intros.
  induction l.
  reflexivity.

  unfold filter at 2 3.
  (* unfold compose. *)
  destruct (g a); simpl; destruct (f a);

  simpl;
  try apply f_equal;
  unfold filter in IHl at 2 3;
  rewrite IHl;
  reflexivity.
Qed.



Lemma nodup_filter:
  forall A (l: list A) f,
    NoDup l
    -> NoDup (filter f l). 

  Proof.
    intros.
    induction l.

    simpl. constructor.

    simpl. 
    inversion H.
    subst.
    destruct (f a).
    depremise IHl. assumption.
    constructor.
    intro. apply filter_In in H0. destruct H0. contradiction.
    assumption.

    apply IHl. assumption. 

  Qed.


(*
Lemma set_union_nil_l:
  forall s,
    set_union eq_dec s nil = s.

Proof.
  intros. unfold set_union. reflexivity.
Qed.

    Lemma set_union_nil_r:
      forall s,
        set_union eq_dec nil s = s.
      
    Proof.
      intros.
      induction s.x
      reflexivity.

      unfold set_union.
      unfold set_union in IHs.
      rewrite IHs.
      unfold set_add.

      simpl.
      unfold set_add.
      simpl.

    Qed.
 *)


(*
Lemma filter_set_union:
  forall {A} (f: A -> bool) (s1 s2: set A) eq_dec,
    filter f (set_union eq_dec s1 s2) =
    set_union eq_dec 
              (filter f s1)
              (filter f s2).
Proof.
  intros.

      intros.
      induction s2.

        simpl.
        reflexivity.

        unfold set_union.
        simpl.

        generalize dependent s1.
        induction s1 as [| s1']; intros.


          simpl.
          destruct (f a) eqn: E.
            unfold set_add. reflexivity.
            reflexivity.
Qed.
*)            



(* ------------------------------------------------------- *)










