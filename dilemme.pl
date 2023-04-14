% DILEMME DU PRISONNIER REPETE %
% Licence MIASHS, Université Grenoble-Alpes, 2021.
% Ajouter le nom de votre programme dans la liste du prédicat inscrits/1.
% Ajouter le code de votre stratégie dans la section JOUEURS
% Lancer le tournoi avec la requête: go.
% Vous pouvez afficher chaque coup en indiquant oui dans le prédicat affichageDetails    

%%%%%%%%%%%%%%%%%%%%%%%%
%  INSCRITS AU TOURNOI %
%%%%%%%%%%%%%%%%%%%%%%%%
inscrits([oeilPourOeil,mechant,gentille,alea,queens]).    

% Affichage ou non des détails de chaque partie (oui/non).
affichageDetails(non).     % Indiquer oui pour voir les détails 

%%%%%%%%%%%
% JOUEURS %
%%%%%%%%%%%    
    
% Oeil pour oeil : coopération puis répétition du coup précédent de l'adversaire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
joue(oeilPourOeil,[],c).    % Premier coup : on coopère
joue(oeilPourOeil, [[_,Prec]|_], Prec).  % Ensuite, on repète le coup précédent de l'adversaire

% Trahison systématique
%%%%%%%%%%%%%%%%%%%%%%%%%
joue(mechant,_,t).

% Coopération systématique
%%%%%%%%%%%%%%%%%%%%%%%%%
joue(gentille,_,c).

% Coup aléatoire
%%%%%%%%%%%%%%%%%
joue(alea,_,c):-random(Alea),Alea<0.5,!.
joue(alea,_,t).

%%%%%%%%%%%%%%%%%%%%%%
% GESTION DU TOURNOI %
%%%%%%%%%%%%%%%%%%%%%%

go :- inscrits(L),tournoi(L,R),predsort(comparePairs,R,RSorted),writef("Resultats : %t",[RSorted]).

% Prédicat qui gère le tournoi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tournoi([],[]).
tournoi([J|L],R):- inscrits(Ins),member(J,Ins),!,matchs(J,[J|L],R1),tournoi(L,R2),fusionne(R1,R2,R).
tournoi([J|_],_):-writef("Le joueur %t est inconnu.",[J]),fail.

fusionne([],L,L).
fusionne([[J,G]|L],L2,R) :- update(J,G,L2,R2),fusionne(L,R2,R).

matchs(_,[],[]).
matchs(J,[J1|L1],R):-run(J,J1,GainsJ,GainsJ1),matchs(J,L1,R1),update(J,GainsJ,R1,R2),update(J1,GainsJ1,R2,R).

update(J,Gain,[[J,OldTotal]|R],[[J,Total]|R]):-!,Total is OldTotal+Gain.
update(J,Gain,[P|L],[P|LUpdated]):-update(J,Gain,L,LUpdated).
update(J,Gain,[],[[J,Gain]]).

% Affichage des coups et des scores
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
affiche(Joueur1,Joueur2,C1,C2,Score1,Score2,Tscore1,Tscore2):-affichageDetails(oui),!,writef("%t joue %t, %t joue %t : [%t,%t]. Cumul: [%t,%t]\n",[Joueur1,C1,Joueur2,C2,Score1,Score2,Tscore1,Tscore2]).
affiche(_,_,_,_,_,_,_,_).

% Prédicat qui lance 100 parties entre J1 et J2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run(J1,J2,Points1,Points2):-run(100,J1,J2,[],0,0,Points1,Points2).

run(0,J1,J2,_,S1,S2,S1,S2):- !,writef("%t %t - %t %t.\n",[J1,S1,S2,J2]).
run(NbCoups,J1,J2,Prec,Score1,Score2,Points1,Points2):-joue(J1,Prec,C1),!,inversePaires(Prec,InvPrec),joue(J2,InvPrec,C2),score(C1,C2,NScore1,NScore2),Tscore1 is Score1+NScore1,Tscore2 is Score2+NScore2,affiche(J1,J2,C1,C2,NScore1,NScore2,Tscore1,Tscore2),NbCoups1 is NbCoups-1,run(NbCoups1,J1,J2,[[C1,C2]|Prec],Tscore1,Tscore2,Points1,Points2).

% Calcul des scores
%%%%%%%%%%%%%%%%%%%%%%%%%
score(t,t,1,1).
score(c,t,0,5).
score(t,c,5,0).			  
score(c,c,3,3).											  
					
% UTILITAIRES						      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inversePaires([],[]).
inversePaires([[X,Y]|R1],[[Y,X]|R2]):-inversePaires(R1,R2).

comparePairs(=,[_,X],[_,X]):-!.   % Predicat utilisé pour le classement
comparePairs(<,[_,X],[_,Y]):-X>Y,!.
comparePairs(>,_,_).


% jouer/3 de queens (BEQAJ Daniel,BOUROI Tamara)
nbElements_queens([],0).
nbElements_queens([_|L],R):-nbElements_queens(L,R1),R is R1+1.

troisPremiersCoupsAd_queens(L,P1,P2,P3):-reverse(L,InvL),InvL=[[_,P1]|L1],L1=[[_,P2]|L2],L2=[[_,P3]|_].
troisDerniersCoupsAd_queens(L,P1,P2,P3):-L=[[_,P3]|L1],L1=[[_,P2]|L2],L2=[[_,P1]|_].

dernierCoupAd_queens([[_,R]|_],R).

joue(queens,[],t).
joue(queens,[[_,_]],t).
joue(queens,[[_,_],[_,_]],t).

joue(queens,L,R):-troisPremiersCoupsAd_queens(L,c,c,c),R=t.


joue(queens,L,R):-not(troisPremiersCoupsAd_queens(L,c,c,c)),nbElements_queens(L,NE),(NE=:=3;NE=:=4),R=c.
joue(queens,L,R):-not(troisPremiersCoupsAd_queens(L,c,c,c)),nbElements_queens(L,NE),NE>4,NE<96,
                                      ((dernierCoupAd_queens(L,c),R=c);(dernierCoupAd_queens(L,t),R=t)).
joue(queens,L,R):-not(troisPremiersCoupsAd_queens(L,c,c,c)),nbElements_queens(L,NE),NE>=96,R=t.








