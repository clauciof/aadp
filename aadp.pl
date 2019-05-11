% metodo que checa se um elemento pertence a uma lista
% caso elemento seja a cabeca, retorna true
pertence(Elem,[Elem|_]).

% caso contrario, procura na cauda
pertence(Elem,[_|Cauda]) :- pertence(Elem,Cauda).

% se o estado não tiver sucessor, falha e não procura mais (corte)
estende( _ ,[]).

% metodo que faz a extensao do caminho até os nós filhos do estado
estende([Estado|Caminho],ListaSucessores) :- bagof(
    [Sucessor,Estado|Caminho], 
    (s(Estado,Sucessor), not(pertence(Sucessor,[Estado|Caminho]))), 
    ListaSucessores),!.

% metodo que concatena duas listas
concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :-concatena(Cauda,L2,Resultado).

% solucao por busca em largura (bl)
solucao_bl(Inicial,Solucao) :- bl([[Inicial]],Solucao).

% se o primeiro estado de F for meta, entao o retorna com o caminho
bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).

% falha ao encontrar a meta, entao estende o primeiro estado ate seus sucessores e os coloca no final da fronteira
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), 
    concatena(Outros,Sucessores,NovaFronteira), 
    bl(NovaFronteira,Solucao).

% solucao por busca em profundidade (bp)
solucao_bp(Inicial,Solucao) :- bp([],Inicial,Solucao).

% se o primeiro estado da lista eh meta, retorna a meta
bp(Caminho,Estado,[Estado|Caminho]) :- meta(Estado).

% se falha, coloca o no caminho e continua a busca
bp(Caminho,Estado,Solucao) :- s(Estado,Sucessor), 
    not(pertence(Sucessor,[Estado|Caminho])),
    bp([Estado|Caminho],Sucessor,Solucao).



