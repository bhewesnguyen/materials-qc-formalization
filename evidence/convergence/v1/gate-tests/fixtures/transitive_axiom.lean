axiom GateFixture.hidden : False
theorem GateFixture.helper : False := GateFixture.hidden
theorem GateFixture.indirect : False := GateFixture.helper
#print axioms GateFixture.indirect
