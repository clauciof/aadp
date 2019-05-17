cenario([Sujeiras, Paredes, Elevadores, Dockstation]):-sujeiras(Sujeiras), paredes(Paredes), elevadores(Elevadores),
    dockstation(Dockstation).

paredes([[1,2], [3,1], [4,0], [4,3], [9,4]]).
sujeiras([[0,0],[4,2],[5,3]]).
limitesH([0,1,2,3,4,5,6,7,8,9]).
limitesV([0,1,2,3,4]).
elevadores([2,8]).
dockstation([5,0]).
lixeira([3,4]).


%quantidade de elementos de uma lista
qtde([],0).
qtde([_|T],S):-qtde(T,G),S is 1+G.

%!  %%%%%%%%%%%%%
%solucao por busca em profundidade (bp)
solucao_bp(Inicial,Solucao) :- bp([],Inicial,Solucao).

%Se o primeiro estado da lista é meta, retorna a meta
bp(Caminho,Estado,[Estado|Caminho]) :- meta(Estado).

%se falha, coloca o no caminho e continua a busca
bp(Caminho,Estado,Solucao) :- s(Estado,Sucessor),
not(pertence(Sucessor,[Estado|Caminho])),
 bp([Estado|Caminho],Sucessor,Solucao).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%retirar elemento da lista
retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Cabeca|Cauda],[Cabeca|Resultado]) :- retirar_elemento(Elem,Cauda,Resultado).




% caso elemento seja a cabeca, retorna true
pertence(Elem,[Elem|_]).

% caso contrario, procura na cauda
pertence(Elem,[_|Cauda]) :- pertence(Elem,Cauda).


% mover o robo para a direita. X e Y representam respectivamente a
% coluna e o andar que o robo se encontr
s([[X,Y], Reservatorio, C],
  [[X2,Y], Reservatorio, C]):-
    X2 is X + 1,
    limitesH(L), paredes(P),  pertence(X2, L), cenario(C), not(pertence([X2,Y], P)).

% Mover O robo para a esquerda. X e Y representam respectivamente a
% coluna e o andar que o robo se encontraq
s([[X,Y], Reservatorio, C],
  [[X2,Y], Reservatorio, C]):-
    X2 is X-1, limitesH(L), paredes(P), pertence(X2, L), cenario(C), not(pertence([X2,Y], P)).

% mover o robo para cima. X e Y representam respectivamente a coluna e o
% andar que o robo se encontra
s([[X,Y], Reservatorio, C],
  [[X,Y2], Reservatorio, C]):-
    Y2 is Y+1, limitesV(L), elevadores(E),
    pertence(Y2, L), pertence(X, E), cenario(C).

% mover o robo para baixo. X e Y representam respectivamente a coluna e o
% andar que o robo se encontra
s([[X,Y], Reservatorio, C],
  [[X,Y2], Reservatorio, C]):-
    Y2 is Y-1,limitesV(L), elevadores(E),
    pertence(Y2, L), pertence(X, E), cenario(C).


%cata lixo
 s([[X,Y],Reservatorio,[S, P, E, D]],
   [[X,Y], Reservatorio1, [S1, P, E, D]]):-
    sujeiras(S), paredes(P), elevadores(E), dockstation(D),
    pertence([X,Y], S), Reservatorio1 is Reservatorio + 1, pertence([X,Y], S),
    pertence(Reservatorio, [0,1]), retirar_elemento([X,Y], S, S1).

%poe o lixo na lixeira
s([[X,Y], Reservatorio,C], [[X,Y], Reservatorio1, C]):-cenario(C),
    lixeira(L), pertence([X,Y], [L]), Reservatorio1 is Reservatorio - Reservatorio.

%meta
meta([[X,Y], 0,[[], P, E, D]]):-paredes(P), elevadores(E), dockstation(D), pertence([X,Y], [D]).
