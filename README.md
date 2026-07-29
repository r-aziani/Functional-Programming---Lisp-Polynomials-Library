## Progetto Lisp: Manipolazione di Polinomi
Progetto realizzato durante la laurea triennale presso l'Università degli Studi di Milano-Bicocca.

Questo progetto implementa in Lisp un sistema per il parsing, la rappresentazione e la manipolazione algebrica di monomi e polinomi.

---

## 1. Parsing e Costruzione

### `as-monomial/1`
Prende in input un'espressione e ritorna la struttura dati (lista) che rappresenta il monomio risultante dal parsing dell’espressione presa in input.
Viene prima controllato se l'input sia uno zero, un integer o una lettera, e costruito il corrispondente monomio. Se non viene riconosciuto come tale, verifica che sia una espressione nella forma corretta `( * [coefficient] var-expt )` e costruisce il corrispondente monomio; se l'input non è valido viene restituito `NIL`.

**Funzioni di supporto a `as-monomial`:**
*   **`symbol-letter-p/1`**: Verifica che l'espressione passata a `as-monomial` sia una lettera, per costruire l'eventuale monomio composto solo da una variabile.
*   **`get-vars-n-powers/1`**: Prende in input l'espressione da parsare tolta di `*` ed eventuale coefficiente, per costruire il monomio sfruttando le chiamate ricorsive. Se l'input è una lista di due elementi con il primo elemento uguale a `expt`, viene creata una lista con un elemento di tipo `(V esponente variabile)`; se l'input è un simbolo, viene creata una lista con un elemento di tipo `(V 1 variabile)`; in tutti gli altri casi, viene restituita la lista vuota.
*   **`get-powers/1`**: Prende in input la lista delle variabili con esponenti `vars-n-powers`, e restituisce una lista contenente solo gli esponenti. Utilizza la funzione `get-powers-helper`.
*   **`get-powers-helper/1`**: Prende in input un singolo elemento della lista `vars-n-powers`, e restituisce l'esponente di quel singolo elemento.
*   **`get-total-degree/1`**: Prende in input la lista degli esponenti e restituisce la somma di tutti gli esponenti. Se l'input è una lista vuota, restituisce `0`.
*   **`order-vars-n-powers/1`**: Prende in input la lista delle variabili con esponenti `vars-n-powers` e la ordina in base all'ordine alfabetico dei caratteri delle variabili.
*   **`order-char/1`**: Funzione di confronto per ordinare i caratteri delle variabili. Prende in input due variabili `a` e `b` e restituisce `T` se il carattere corrispondente ad `a` precede `b` nell'ordine alfabetico.

### `as-polynomial/1`
Prende in input un'espressione e ritorna la struttura dati (lista) che rappresenta il polinomio risultante dal parsing dell’espressione presa in input.
Viene prima controllato che l'input sia zero (costruendo il corrispondente polinomio); successivamente viene controllato che l'input sia un numero o una lettera (costruendo il corrispondente monomio). Altrimenti viene controllato che l'input sia un'espressione del tipo `( + monomial )` e costruito il corrispondente polinomio. Se l'input non è valido viene restituito `NIL`.

**Funzioni di supporto a `as-polynomial`:**
*   **`build-poly/1`**: Prende la stessa espressione che arriva a `as-polynomial`, e costruisce il polinomio corrispondente come una lista di monomi.
*   **`order-poly/1`**: Ordina la lista dei monomi secondo l'ordine crescente dei gradi di ciascun monomio.
*   **`order-poly-aux/1`**: Funzione di confronto per `order-poly`. Prende in input due monomi `a` e `b` e restituisce `T` se il grado di `a` è minore del grado di `b`.

---

## 2. Stampa e Visualizzazione

### `pprint-polynomial/1`
Controlla che l'input sia un polinomio e successivamente chiama `pprint-polynomial-aux` per effettuare la stampa vera e propria.

**Funzioni di supporto a `pprint-polynomial`:**
*   **`pprint-polynomial-aux/1`**: Ritorna `NIL` dopo aver stampato una rappresentazione tradizionale del termine polinomio passato come input.
*   **`p-tostring/1`**: Prende in input la lista che rappresenta un polinomio nella forma (ad esempio): `(#+ #\Space #\A #\Space #\B #^ #\2 #\Space #+ #\2 #\Space #\X #^ #\5 #\Space)` e la trasforma in una stringa con la funzione `coerce`.
*   **`serialize-p/1`**: Prende in input un polinomio come lista di monomi, ad esempio `((M 1 3 ((V 1 A) (V 2 B))) (M 2 5 ((V 5 X))))`, e restituisce la corrispondente lista formattata per la stampa chiamando `serialize-m` sul singolo monomio tramite ricorsione in coda.
*   **`serialize-m/1`**: Prende in input un monomio (es. `(M 1 3 ((V 1 A) (V 2 B)))`) e restituisce la corrispondente lista di caratteri per la stampa.
*   **`vars-tostring/1`**: Prende in input la lista delle variabili `vars-n-powers` e restituisce la corrispondente stringa in forma tradizionale. Esempio: con input `((V 3 S) (V 3 T) (V 1 X))` restituisce la stringa `"S^3 T^3 X "`.

---

## 3. Utilità ed Estrazione Dati

### Funzioni di Analisi
*   **`is-zero/1`**: Ritorna `T` quando il valore preso in input è una rappresentazione corretta dello zero. Controlla prima che il valore sia proprio `0`, poi verifica se è una rappresentazione tramite monomio o polinomio.
*   **`var-powers/1`**: Controlla che l'input sia un monomio e lo passa a `var-powers-aux`; altrimenti stampa un messaggio di errore.
    *   **`var-powers-aux/1`**: Estrae la lista delle potenze dal monomio. Esempio: `(M 1 2 ((V 1 A) (V 2 B)))` ➔ `((V 1 A) (V 2 B))`.
*   **`vars-of/1`**: Ritorna la lista delle variabili del monomio. Esempio: `(M 1 2 ((V 1 A) (V 2 B)))` ➔ `(A B)`.
    *   **`vars-of-aux/1`**: Prende in input una VP-list e restituisce la lista delle variabili che vi compaiono estraendo il terzo elemento di ogni sottolista.
*   **`monomial-degree/1`**: Ritorna il grado totale (il terzo elemento) di una struttura monomiale.
*   **`monomial-coefficient/1`**: Ritorna il coefficiente (il secondo elemento) di una struttura monomiale.
*   **`monomials/1`**: Prende in input una struttura `poly` e ritorna la lista ordinata dei monomi che vi compaiono tramite `order-poly`.
*   **`coefficients/1`**: Ritorna la lista dei coefficienti presenti in una struttura `poly`.
    *   **`coeff-aux/1`**: Funzione ricorsiva che estrae il secondo elemento da ogni monomio.
*   **`variables/1`**: Ritorna la lista dei simboli di variabile che compaiono nel polinomio, rimuovendo i duplicati.
    *   **`variables-aux/1`**: Estrae le variabili da ogni monomio tramite chiamate ricorsive in coda.
*   **`max-degree/1`**: Ritorna il massimo grado dei monomi presenti in un polinomio.
*   **`min-degree/1`**: Ritorna il minimo grado dei monomi presenti in un polinomio.
    *   **`get-grades/1`**: Costruisce la lista dei gradi di ciascun monomio tramite chiamate ricorsive in coda.

---

## 4. Operazioni Algebriche (Addizione e Sottrazione)

### `poly-plus/2` & `poly-minus/2`
*   **`poly-plus/2`**: Prende in input due polinomi/monomi e restituisce il polinomio somma.
*   **`poly-minus/2`**: Restituisce il polinomio differenza. La differenza è implementata come una somma tra il primo polinomio e il secondo con i segni invertiti.

**Funzioni di supporto:**
*   **`mono-to-poly/1`**: Trasforma un monomio nella sua rappresentazione come polinomio.
*   **`poly-plus-aux/1`**: Effettua la somma di una lista di monomi. Tramite `check-vars` verifica se le variabili del monomio in testa sono uguali a quelle nel resto della lista: se sì, li somma e procede ricorsivamente togliendo il monomio sommato.
*   **`change-sign/1`**: Moltiplica per `-1` il coefficiente di ciascun monomio in una lista.
*   **`check-vars/2`**: Restituisce `T` se nella lista di monomi ne è presente uno con le stesse variabili di quello passato in input.
*   **`sum-ms/2`**: Somma due monomi aventi le stesse variabili.
*   **`remove-ms/2`**: Rimuove un monomio specifico (identificato da `find-monomial-by-vars`) da una lista tramite `remove-element`.
*   **`remove-element/2`**: Rimuove un elemento specifico da una lista.
*   **`find-monomial-by-vars/2`**: Restituisce il monomio che possiede le variabili uguali a quelle della VP-list presa in input.
*   **`remove-zero/1`**: Rimuove dalla lista eventuali monomi con coefficiente uguale a `0` (derivati da elisioni in addizioni/sottrazioni).

---

## 5. Operazioni Algebriche (Moltiplicazione)

### `poly-times/2`
Prende in input due polinomi e ritorna il polinomio risultante dalla loro moltiplicazione, delegando il lavoro a `poly-times-aux`.

**Funzioni di supporto:**
*   **`poly-times-aux/2`**: Moltiplica il monomio in testa alla prima lista con tutti quelli della seconda lista ricorsivamente, avvalendosi di `multiply-one-with-others`.
*   **`multiply-one-with-others/2`**: Moltiplica un singolo monomio con una lista di monomi tramite chiamate ricorsive a `multiply-monos`.
*   **`multiply-monos/2`**: Restituisce il monomio ottenuto dalla moltiplicazione di due monomi. Moltiplica i coefficienti, somma i gradi totali e chiama `build-vars` sulle VP-list concatenate.
*   **`build-vars/1`**: Costruisce la VP-list del monomio prodotto. Controlla per ogni elemento se quello successivo ha la stessa variabile: in caso affermativo, addiziona i gradi.

---

## 6. Valutazione Polinomiale

### `poly-val/2`
Prende in input un polinomio e una lista di valori per ognuna delle variabili (seguendo l'ordine alfabetico). Sostituisce i valori alle variabili in ciascun monomio e ne somma i risultati per ottenere il valore totale del polinomio nel punto desiderato.

**Funzioni di supporto:**
*   **`poly-val-aux/2`**: Itera sulla lista dei monomi del polinomio. Per ciascuno, chiama `calculate-mono` e moltiplica il risultato per il coefficiente del monomio, sommando poi i risultati ricorsivamente.
*   **`calculate-mono/2`**: Chiama `calculate-mono-aux` e moltiplica gli elementi della lista restituita.
*   **`calculate-mono-aux/2`**: Ritorna una lista contenente il valore calcolato di ciascuna variabile della VP-list chiamando `calculate-vars`.
*   **`calculate-vars/2`**: Esamina un elemento della VP-list rispetto alla lista `variabili-valori`. Se corrispondono, calcola la potenza ricavando base ed esponente; altrimenti procede ricorsivamente.
*   **`vars-n-values/2`**: Costruisce la lista di associazione variabile-valore.
    *   Esempio: `(vars-n-values '(A B) '(1 2))` ➔ `((A 1) (B 2))`
*   **`power/2`**: Restituisce il valore di una base elevata a un esponente.
*   **`sum-list/1`**: Restituisce la somma di tutti gli elementi di una lista di numeri.
*   **`multiply-list/1`**: Restituisce il prodotto di tutti gli elementi di una lista di numeri.
