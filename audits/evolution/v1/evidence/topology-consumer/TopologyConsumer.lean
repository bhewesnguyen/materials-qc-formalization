import FormalScience.OpenSystems.TwoStateEvolution

open FormalScience.Stage0 FormalScience.OpenSystems

-- No local matrix norm instances or matrix norm scopes are enabled here.
example (a b t : ℝ) (X : QubitMatrix) :
    HasDerivAt (fun s : ℝ => evolution a b s X)
      (generator a b (evolution a b t X)) t :=
  hasDerivAt_evolution a b t X

example {φ : ℝ → QubitMatrix} {φ' : QubitMatrix} {t : ℝ}
    (h00 : HasDerivAt (fun s => φ s 0 0) (φ' 0 0) t)
    (h01 : HasDerivAt (fun s => φ s 0 1) (φ' 0 1) t)
    (h10 : HasDerivAt (fun s => φ s 1 0) (φ' 1 0) t)
    (h11 : HasDerivAt (fun s => φ s 1 1) (φ' 1 1) t) :
    HasDerivAt φ φ' t :=
  hasDerivAt_qubitMatrix h00 h01 h10 h11
