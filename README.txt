866037 Aziani Riccardo 
869257 Castelli Luca

FUNZIONE as-monomial/1
Prende in input un'espressione e ritorna la struttura dati (lista) che rappresenta il monomio risultante dal parsing dell’espressione presa in input.
Nel dettaglio, viene prima controllato se l'input sia uno zero, un integer o una lettera, e costruito il corrispondente monomio. Se non viene riconosciuto come tale, verifica che sia una espressione nella forma corretta ‘(’ ‘*’ [coefficient ] var-expt * ‘)’ e costruito il corrispondente monomio; se l'input non è valido viene restituito NIL.

Funzioni di supporto a as-monomial:
FUNZIONE symbol-letter-p/1
Verifica che l'espressione passata a as-monomial sia una lettera, per costruire l'eventuale monomio composto solo da una variabile.

FUNZIONE get-vars-n-powers/1
Prende in input l'espressione da parsare tolta di '*' ed eventuale coefficiente, per costruire il monomio sfruttando le chiamate ricorsive.
Se l'input è una lista di due elementi con il primo elemento uguale a expt, viene creata una lista con un elemento di tipo (V esponente variabile); se l'input è un simbolo, viene creata una lista con un elemento di tipo (V 1 variabile); in tutti gli altri casi, viene restituita la lista vuota.

FUNZIONI get-powers/1
Prende in input la lista delle variabili con esponenti vars-n-powers, e restituisce una lista contenente solo gli esponenti delle variabili. Viene utilizzata la funzione get-powers-helper per estrarre gli esponenti da ciascun elemento della lista vars-n-powers.

FUNZIONE get-powers-helper/1
Prende in input un singolo elemento della lista vars-n-powers, e restituisce l'esponente di quel singolo elemento.

FUNZIONE get-total-degree/1
Prende in input la lista degli esponenti, e restituisce la somma di tutti gli esponenti presenti nella lista. Se l'input è una lista vuota, viene restituito 0.

FUNZIONE order-vars-n-powers/1
Prende in input la lista delle variabili con esponenti vars-n-powers e la ordina in base all'ordine alfabetico dei caratteri delle variabili.

FUNZIONE order-char/1
Funzione che viene utilizzata come funzione di confronto per ordinare i caratteri delle variabili nella funzione order-vars-n-powers. Prende in input due variabili 'a' e 'b' e restituisce T se il carattere corrispondente ad 'a' precede il carattere corrispondente a 'b' nell'ordine alfabetico.


FUNZIONE as-polynomial/1
Prende in input un'espressione e ritorna la struttura dati (lista) che rappresenta il polinomio risultante dal parsing dell’espressione presa in input.
Nel dettaglio, viene prima controllato che l'input sia zero e nel caso costruito il corrispondente polinomio; successivamente viene controllato che l'input sia un numero o una lettera e costruito il corrispondente monomio.
Altrimenti viene controllato che l'input sia un'espressione del tipo ‘(’ ‘+’ monomial + ‘)’) e costruito il corrispondente polinomio. Se l'input non è valido viene restituito NIL.

Funzioni di supporto a as-polynomial:
FUNZIONE build-poly/1
Prende la stessa espressione che arriva a as-polynomial, e costruisce polinomio corrispondente come una lista di monomi.

FUNZIONE order-poly/1
Funzione utilizzata per ordinare la lista dei monomi secondo l'ordine crescente dei gradi di ciascun monomio.

FUNZIONE order-poly-aux/1
Funzione utilizzata come funzione di confronto per ordinare i monomi del polinomio nella funzione order-poly. Prende in input due monomi 'a' e 'b' e restituisce T se il grado del monomio 'a' è minore del grado del monomio 'b'.


FUNZIONE pprint-polynomial/1
Controlla che l'input sia un polinomio e successivamente chiama pprint-polynomial-aux per effettuare la stampa vera e propria.

Funzioni di supporto a pprint-polynomial:
FUNZIONE pprint-polynomial-aux/1
Ritorna NIL dopo aver stampato una rappresentazione tradizionale del termine polinomio passato come input.

FUNZIONE p-tostring/1
Prende in input la lista che rappresenta un polinomio nella forma (ad esempio): (#\+ #\Space #\A #\Space #\B #\^ #\2 #\Space #\+ #\2 #\Space #\X #\^ #\5 #\Space) e la trasforma in una stringa con la funzione coerce.

FUNZIONE serialize-p/1
Prendendo in input un polinomio come lista di monomi nella forma (ad esempio) ((M 1 3 ((V 1 A) (V 2 B))) (M 2 5 ((V 5 X)))) , restituisce la corrispondente lista nella forma (#\+ #\Space #\A #\Space #\B #\^ #\2 #\Space #\+ #\2 #\Space #\X #\^ #\5 #\Space) chiamando serialize-m sul singolo monomio e facendo una chiamata ricorsiva in coda.

FUNZIONE serialize-m/1
Prende in input un monomio nella forma (ad esempio) (M 1 3 ((V 1 A) (V 2 B)) e restituisce la corrispondente lista nella forma (#\+ #\Space #\A #\Space #\B #\^ #\2 #\Space).

FUNZIONE vars-tostring/1
Prende in input la lista delle variabili vars-n-powers e restituisce la corrispondente stringa in forma tradizionale; ad esempio con l'input ((V 3 S) (V 3 T) (V 1 X)) viene restituita la stringa "S^3 T^3 X ".


FUNZIONE is-zero/1
Ritorna T come result quando il valore preso in input è una rappresentazione corretta dello zero. Nel primo caso controlla che il valore sia proprio 0, dopo verifica se è una rappresentazione tramite monomio o polinomio.


FUNZIONE var-powers/1
Controlla che ciò che gli viene passato sia un monomio e in caso affermativo lo passa a var-powers-aux; altrimenti stampa un messaggio di errore.

Funzione di supporto a var-powers: var-powers-aux/1
Prende in input una struttura monomial ritorna la lista di var-powers: ad esempio (M 1 2 ((V 1 A) (V 2 B))) --> ((V 1 A) (V 2 B)) .
Per ritornare la struttura VP-list vengono fatte della chiamate ricorsive andando man mano a scartare i primi elementi della struttura monomial, fino a quando rimane la lista desiderata.


FUNZIONE vars-of/1
Prende in input una struttura monomial e ritorna la lista delle sue variabili: (M 1 2 ((V 1 A) (V 2 B))) --> (A B) . Chiama la funzione su vars-of-aux sulla VP-list della strutura monomial presa in input.

Funzione di supporto a vars-of: vars-of-aux/1
Prende in input una VP-list e restituisce la lista delle variabili che vi compaiono: ad esempio ((V 1 A) (V 2 B)) --> (A B) . Prende da ciascun elemento, ovvero una lista, il terzo elemento e poi fa una chiamata ricorsiva in coda.


FUNZIONE monomial-degree/1
Prende in input una struttura monomial e ritorna il suo grado totale. Controlla che la struttura presa in input sia un monomio e poi ritorna il suo grado totale, ovvero il terzo elemento.


FUNZIONE monomial-coefficient/1
Prende in input una struttura monomial e ritorna il suo coefficiente. Controlla che la struttura presa in input sia un monomio e poi ritorna il suo coefficiente, ovvero il secondo elemento.


FUNZIONE monomials/1
Prende in input una struttura poly e ritorna la lista ordinata dei monomi che vi compaiono. Chiama la funzione order-poly sulla lista dei monomi.


FUNZIONE coefficients/1
Prende in input una struttura poly e ritorna la lista dei coefficienti che vi compaiono. Chiama la funzione ausiliaria coeff-aux sulla lista dei monomi che compongono poly.

Funzione di supporto a coefficients: coeff-aux/1
Prende in input una lista di monomi che compaiono in poly. Prende da ciascun elemento, ovvero una lista, il secondo elemento e poi fa una chiamata ricorsiva in coda.


FUNZIONE variables/1
Prende in input una struttura poly e ritorna la lista dei simboli di variabile che vi compaiono, rimuovendo i duplicati. Controlla che l'input sia un polinomio rappresentato correttamente e chiama la funzione variables-aux sui suoi monomi.

Funzione di supporto a variables: variables-aux/1
Prende in input la lista dei monomi di un polinomio; per ognuno estrae le sue variabili, facendo delle chiamate ricorsive in coda.


FUNZIONE max-degree/1
Prende in input una struttura poly e ritorna il massimo grado dei monomi che vi compaiono. Controlla che l'input sia un polinomio rappresentato correttamente ed estrae il massimo dalla lista composta dai gradi di ciascun monomio.


FUNZIONE min-degree/1
Prende in input una struttura poly e ritorna il minimo grado dei monomi che vi compaiono. Controlla che l'input sia un polinomio rappresentato correttamente ed estrae il minimo dalla lista composta dai gradi di ciascun monomio.

Funzione di supporto a max-degree e min-degree:
get-grades/1
Prende in input la lista dei monomi di un polinomio e costruisce la lista dei gradi di ciascun monomio facendo delle chiamate ricorsive in coda.


FUNZIONE poly-plus/2
Prende in input due polinomi/monomi e restituisce il polinomio somma. Controlla che i polinomi passati in input siano rappresenentati secondo la struttura corretta e chiama poly-plus-aux.

FUNZIONE poly-minus2
Prende in input due polinomi/monomi e restituisce il polinomio differenza. Controlla che i parametri passati in input siano rappresentati secondo la struttura corretta, poi chiama poly-plus-aux cambiando il segno ai coefficienti dei monomi del secondo polinomio: la differenza viene infatti implementata come una somma tra il primo polinomio e il secondo cambiato di segno.

Funzioni di supporto a poly-plus e poly-minus:
FUNZIONE mono-to-poly/1
Prende in input un monomio e lo restituisce sotto forma di polinomio.

FUNZIONE poly-plus-aux/1
Prende in input una lista di monomi ed effettua la loro somma. Tramite check-vars controlla se la variabili del monomio in testa sono uguali a quelle di uno nel resto della lista: se sì viene fatta la loro somma e poi fatta una chiamata ricorsiva sulla coda, togliendo il monomio che è stato sommmato; altrimenti viene semplicemente fatta una chiamata ricorsiva in coda.

FUNZIONE change-sign/1
Prende in input una lista di monomi e restituisce la stessa lista cambiando però il segno di ciascun monomio, moltiplicando il coefficiente per -1.

FUNZIONE check-vars/2
Prende in input un monomio e una lista di monomi. Restituisce T se nella lista di monomi ne è presente uno con le stesse variabili di quello passato in input, nil altrimenti. La funzione è implementato confrontando i monomi uno a uno tramite chiamate ricorsive.

FUNZIONE sum-ms/2
Prende in input un monomio e una lista di monomi. Quando trova nella lista un monomio con le stesse variabili di quello preso in input, fa la loro somma e la restituisce.

FUNZIONE remove-ms/2
Prende in input un monomio e una lista di monomi. Chiama remove-element per rimuovere il monomio con le stesse variabili di quello passato in input (identificato tramite la funzione find-monomial-by-vars) dalla lista di monomi.

FUNZIONE remove-element/2
Prende in input un elemento e una lista. Rimuove quell'elemento dalla lista. La funzione è utilizzata per rimuovere un monomio quando esso viene sommata o sottratto ad un altro.

FUNZIONE find-monomial-by-vars/2
Prende in input una VP-list e una lista di variabili. Restituisce il monomio che ha le variabili uguali a quelle della VP-list presa in input.

FUNZIONE remove-zero/1
Prende in input una lista di monomi e restituisce la stessa lista rimuovendo eventuali monomi con coefficienti uguali a 0, ottenuti come risultato di addizione o sottrazione tra monomi.


FUNZIONE poly-times/2
Prende in input due polinomi e ritorna il polinomio risultante dalla moltiplicazione dei due. Passa a poly-times-aux le liste dei monomi del primo e del secondo polinomio.

Funzioni di supporto a poly-times:
FUNZIONE poly-times-aux/2
Prende in input due liste di monomi e ritorna la lista di monomi risultante dalla moltiplicazione delle due prese in input. Il metodo usato è quello di prendere il monomio in testa alla prima lista e moltiplicarlo con tutti quelli della seconda lista, e procedere in questo modo in maniera ricorsiva; per farlo viene chiamata multiply-one-with-others passando il monomio in testa alla prima lista e la seconda lista, per poi aggiungere in coda la chiamata ricorsiva.

FUNZIONE multiply-one-with-others/2
Prende in input un monomio e una lista di monomi, e restituisce la lista di monomi ottenuti come moltiplicazione tra le due strutture passate in input. Il metodo usato è di moltiplicare il monomio con quello in testa alla lista chiamando la funzione multiply-monos, per poi aggiungere in coda la chiamata ricorsiva.

FUNZIONE multiply-monos/2
Prende in input due monomi e restituisce il monomio ottenuto dalla moltiplicazione dei due. Dopo aver controllato che entrambi i coefficienti siano diversi da zero, costruisce il monomio da ritornare: moltiplicando i coefficienti, sommando il grado totale di ciascun monomio e chiamando build-vars sulle VP-list concatenate.

FUNZIONE build-vars/1
Prende in input una VP-list ordinata ottenuta come concatenazione di due VP-list appartenenti a due monomi, e costruisce la VP-list del monomio prodotto. Il metodo usato è di controllare per ogni elemento in testa se quello successivo ha la stessa variabile: se sì vengono addizionati i gradi e poi fatta la chiamata ricorsiva.


FUNZIONE poly-val/2
Prende in input un polinomio e una lista di valori per ognuna delle variabili che compaiono nel polinomio, seguendo l'ordine alfabetico. Se superati i controlli, il metodo usato è quello di prendere il primo monomio, calcolare il suo valore sostituendo alle variabili i rispettivi valori passati in input, per poi fare una chiamata ricorsiva in coda; si ottiene una lista con il valore di ciascun monomio, che addizionati danno il valore del polinomio nel punto desiderato.

Funzioni di supporto a poly-val:
FUNZIONE poly-val-aux/2
Prende in input la lista di monomi del polinomio e una lista che associa ad ogni variabile del polinomio il suo valore (ad esempio ((X 1) (Y 3)) ). Chiama calculate-mono passando la VP-list del monomio in testa e la lista variabili-valori, e il valore che quest'ultima ritorna viene moltiplicato per il coefficiente per ottenere il valore del monomio in testa; viene poi fatta una chiamata ricorsiva sulla coda della lista dei polinomi.

FUNZIONE calculate-mono/2
Prende in input una VP-list e la lista variabili-valori. Chiama calculate-mono-aux e moltiplica gli elementi della lista che viene ritornata dalla chiamata.

FUNZIONE calculate-mono-aux/2
Prende in input una VP-list e la lista variabili-valori. Chiama calculate-vars passando la variabile in testa alla VP-list e la lista variabili-valori, per poi fare una chiamata ricorsiva sulla coda della VP-list. Ritorna una lista che contiene il valore calcolato di ciascuna variabile della VP-list, che verranno moltiplicati tra loro per ottenere il valore totale.

FUNZIONE calculate-vars/2
Prende in input un elemento di una VP-list e una lista variabili-valori. Esamina l'elemento con quello in testa alla lista variabili-valori, se corrispondono calcola la potenza ricavando base ed esponente; altrimenti fa una chiamata ricorsiva sulla coda della lista variabili-valori.

FUNZIONE vars-n-values/2
Prende in input la lista ordinata dei simboli di variabile di un polinomio e una lista con i rispettivi valori; costruisce la lista variabile-valore.
Esempio: (vars-n-values '(A B) '(1 2) ) --> ((A 1) (B 2))

FUNZIONE power/2
Prende in input una base e un esponente; restituisce il valore di base elevato ad esponente.

FUNZIONE sum-list/1
Prende in input una lista di numeri, ritorna la somma di tutti gli elementi della lista.

FUNZIONE multiply-list/1
Prende in input una lista di numeri, ritorna il prodotto di tutti gli elementi della lista.









