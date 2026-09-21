theorem GateFixture.target (h : False) : True := False.elim h
example : True := GateFixture.target
