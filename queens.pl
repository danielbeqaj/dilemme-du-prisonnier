% jouer/3 de queens (BEQAJ Daniel,BOUROI Tamara)
nbElements_queens([],0).
nbElements_queens([_|L],R):-nbElements_queens(L,R1),R is R1+1.

troisPremiersCoupsAd_queens(L,P1,P2,P3):-reverse(L,InvL),InvL=[[_,P1]|L1],L1=[[_,P2]|L2],L2=[[_,P3]|_].
troisDerniersCoupsAd_queens(L,P1,P2,P3):-L=[[_,P3]|L1],L1=[[_,P2]|L2],L2=[[_,P1]|_].

dernierCoupAd_queens([[_,R]|_],R).

jouer(queens,[],t).
jouer(queens,[[_,_]],t).
jouer(queens,[[_,_],[_,_]],t).

jouer(queens,L,R):-troisPremiersCoupsAd_queens(L,c,c,c),R=t.


jouer(queens,L,R):-not(troisPremiersCoupsAd_queens(L,c,c,c)),nbElements_queens(L,NE),(NE=:=3;NE=:=4),R=c.
jouer(queens,L,R):-not(troisPremiersCoupsAd_queens(L,c,c,c)),nbElements_queens(L,NE),NE>4,NE<96,
                                      ((dernierCoupAd_queens(L,c),R=c);(dernierCoupAd_queens(L,t),R=t)).
jouer(queens,L,R):-not(troisPremiersCoupsAd_queens(L,c,c,c)),nbElements_queens(L,NE),NE>=96,R=t.




