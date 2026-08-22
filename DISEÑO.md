# FÚTBOL CESTO — diseño del juego

*(título provisorio, cambiable)*

Juego de estrategia y suerte inspirado en el sistema de **Sol Cesto**
(ver [notas-sol-cesto.md](notas-sol-cesto.md)), aplicado a partidos de fútbol
con progresión de campeonato.

---

## 1. La idea en una frase

Cada partido es una **grilla de 4×4 jugadas**. No elegís la jugada: **elegís una
línea**, y el azar decide cuál de sus casillas te toca. Ves todas las
probabilidades antes de decidir. Ganás partidos, cobrás plata, comprás
jugadores, y avanzás hasta la final del campeonato.

---

## 2. Los recursos

| Recurso | Qué es | Cómo se pierde / gana |
|---|---|---|
| **AGUANTE** ❤ | El físico y la cabeza del equipo | Lo bajan los duelos perdidos. Lo suben bidones y cambios |
| **MARCADOR** | Goles tuyos y del rival | Casillas de gol, penales, tiros libres |
| **DINERO** 🪙 | Para el mercado de pases | Taquilla, sponsors, premios por partido |
| **RELOJ** ⏱ | Jugadas que quedan en el partido | Cada línea que elegís gasta una |
| **RACHA** ☀ | Se carga ganando duelos | Al llenarse, habilita elegir **columna** |

### Regla clave: cómo se conectan aguante y goles

Cuando el **AGUANTE llega a 0**, el rival convierte: **gol en contra**, y tu
aguante vuelve a llenarse pero con **1 punto menos de máximo** (el equipo se va
fundiendo).

Así el aguante no es una barra de "game over" abrupta: es *cuánto podés
aguantar antes de que te la metan*, y se degrada a lo largo del partido. Los dos
recursos son el mismo sistema.

---

## 3. Los stats del equipo

| Stat | Color | Contra qué se compara |
|---|---|---|
| **ATAQUE** | 🔴 rojo | Defensores y arqueros rivales — cuando atacás vos |
| **DEFENSA** | 🔵 azul | Delanteros rivales — cuando ataca el rival |

Igual que en Sol Cesto: si tu stat **alcanza o supera** el de la casilla, ganás
el duelo. Si no, perdés.

Subir un stat no es "pegar más fuerte": es **volverte inmune a toda una clase de
casillas**. Con ATAQUE 2 todos los defensores de valor 3 te frenan; con ATAQUE 3
dejan de existir como amenaza. Ese es el motor de progresión del campeonato.

**Los stats solo cambian en el mercado de pases.** Durante un partido son fijos:
nada del tablero te los sube ni te los baja. El jugador tiene que poder mirar
una casilla y saber con certeza qué le va a pasar — si un stat pudiera moverse
a mitad de partido, todos los carteles del tablero estarían mintiendo.

### Los rivales se acomodan a tu plantel

Cada partido es un poco más difícil si mejoraste. Los valores de las casillas
suben junto con tus fichajes, pero **a la mitad de tu ritmo**:

> Por cada **2 puntos** que subís un stat, las casillas de ese color suben **1**.

Los rojos siguen a tu ATAQUE, los azules a tu DEFENSA. Esto se suma al aumento
propio de cada ronda del campeonato.

La constante está en el código como `ESCALA_RIVAL = 0.5`.

**Por qué a la mitad y no 1 a 1:** si el rival subiera al mismo ritmo que vos,
fichar no serviría para nada y toda la economía del juego sería decorativa. A la
mitad, cada fichaje te deja neto mejor parado que antes — pero nunca convierte
el partido en un trámite. El primer punto que comprás es ganancia pura (el rival
no se mueve); el segundo trae al rival +1 mientras vos subiste +2.

| Escala | Copas ganadas |
|---|---|
| x0 — sin escalado | 31,8% |
| x0,34 | 27,0% |
| **x0,5 — el que usa el juego** | **21,3%** |
| x0,75 | 18,0% |
| x1 — el rival te sigue 1 a 1 | 15,0% |

---

## 4. Catálogo de casillas

### Duelos

| Casilla | Color | Si ganás el duelo | Si perdés |
|---|---|---|---|
| **DEFENSOR** 🔴 N | rojo | Lo pasás: **+1 RACHA** | **-1 aguante** |
| **ARQUERO** 🔴 N | rojo | **¡GOL!** | -1 aguante |
| **DELANTERO RIVAL** 🔵 N | azul | Se la sacás: **+1 RACHA** | **GOL EN CONTRA** |
| **MEDIOCAMPISTA** 🔵 N | azul | Le ganás la pelota | -1 aguante |

### Casillas de gol

| Casilla | Efecto |
|---|---|
| **JUGADA CLARA** ⚽ | **Gol directo**, sin tirada |
| **PENAL A FAVOR** 🎯 | **50%** de gol |
| **PASE GOL** 🤝 | **35%** de gol |
| **CÓRNER** 🚩 | **35%** de gol. Si no entra, **+1 RACHA** |
| **TIRO LIBRE** 🚧 | **30%** de gol |
| **PENAL EN CONTRA** 💀 | **50%** de gol del rival |

### Casillas de aguante

Suman:

| Casilla | Efecto |
|---|---|
| **HINCHADA** 📣 | **+1 aguante** |
| **BIDÓN** 💧 | **+1 aguante** |
| **BANCO DE SUPLENTES** 🪑 | **+2 aguante** y te limpia las amarillas |

Restan, en escalera:

| Casilla | Efecto |
|---|---|
| **CALAMBRE** 🦵 | **-1 aguante** |
| **LESIÓN** 🩹 | **-2 aguante** |
| **ROJA** 🟥 | **-3 aguante** (ver abajo) |

### Casillas de dinero

Tres escalones, marcados en pantalla con `+`, `++` y `+++`:

| Casilla | Efecto |
|---|---|
| **FAMA** 🌟 | +4 a 9 |
| **PUBLICIDAD** 🪧 | +8 a 14 |
| **SPONSOR** 💰 | +14 a 23 |

### Casillas que cambian las probabilidades

| Casilla | Efecto |
|---|---|
| **AMARILLA** 🟨 | **-1 aguante**. La **segunda amarilla se vuelve roja** |
| **ROJA** 🟥 | **-3 aguante**, nada más. **Como mucho una por tablero** — las de más se convierten en amarillas al generar la grilla |
| **OFFSIDE** 🚫 | Casilla neutra: no pasa nada, pero **gastaste la jugada** |
| **VAR** 📺 | **Se repite la tirada** en esa misma línea |
| **AUTOGOL RIVAL** 🎁 | Raro. **Gol a favor** de regalo |

---

## 5. La mecánica de selección

1. Mirás la grilla. Cada línea muestra sus casillas **con el resultado que
   traerían y su probabilidad**.
2. **Elegís una FILA.** El azar sortea cuál de sus casillas te toca.
3. Se resuelve la casilla.
4. **La casilla se vacía.** La fila queda con menos casillas, así que las que
   sobreviven **suben de probabilidad** (de 4 casillas al 25% se pasa a 3 al
   33%).
5. Se gasta **1 del RELOJ**.

Con la **RACHA llena** podés elegir una **COLUMNA** en lugar de una fila. Es el
escape para cuando ninguna fila te cierra.

**La decisión nunca es "a qué casilla entro" sino "qué reparto de resultados me
conviene comprar con el aguante que me queda".**

### Cómo se elige, según con qué estés jugando

| Entrada | Comportamiento |
|---|---|
| **Mouse** | Pasar por encima resalta la línea entera. Un click la elige |
| **Dedo** | El primer toque resalta la línea. El segundo la confirma. Tocar otra línea mueve el resaltado sin gastar nada |

Se resalta la fila completa desde cualquier lado: el botón de la izquierda o
cualquiera de sus casillas. Con la racha llena, la barra dorada hace lo mismo
con las columnas.

No se detecta "si es un celular" sino **con qué te acaban de tocar**
(`pointerType` del evento). El media query de hover miente en tablets, en
notebooks con pantalla táctil y en los emuladores; el evento real no.

### El cartel de gol

Cada gol frena el partido con un cartel a pantalla completa, anclado sobre el
tablero. Los dos casos se diferencian por **tres cosas a la vez**, no solo por
el marcador:

| | A favor | En contra |
|---|---|---|
| Texto | **¡GOL!** | **GOL RIVAL** |
| Bajada | A FAVOR | CONVIRTIÓ EL RIVAL |
| Color | Verde con resplandor | Rojo con resplandor |

Aparece con cualquier gol, incluido el que te hacen cuando se te termina el
aguante.

---

## 6. Ítems

Se compran con dinero y se usan durante el partido.

| Ítem | Efecto |
|---|---|
| **BIDÓN** | +1 aguante |
| **FALTA TÁCTICA** | **Elimina una casilla del tablero a elección** |
| **CAMBIO** | Recupera 2 aguante y limpia amarillas |
| **GRITO DEL DT** | +2 RACHA al instante |

La **falta táctica** es el ítem más importante del juego, igual que la flecha en
Sol Cesto: no sirve para "hacer daño", sirve para **manipular probabilidades**.
Sacás la peor casilla de una fila y todo lo bueno que queda ahí sube de chance.

---

## 7. El campeonato

Copa de eliminación directa, **5 partidos**:

| Ronda | Rival | Dificultad |
|---|---|---|
| 1 | Treintaidosavos | Rivales de valor 2-3, tablero amable |
| 2 | Octavos | Aparecen tarjetas y penales en contra |
| 3 | Cuartos | Rivales de valor 3-4, más casillas azules |
| 4 | Semifinal | Tablero cargado, poco aguante de arranque |
| 5 | **FINAL** | Rivales de valor 4-5, todo en contra |

- **Ganás** → cobrás premio y pasás al mercado de pases.
- **Empatás** → definición por penales (5 tiros, 50% cada uno).
- **Perdés** → se termina la corrida. Volvés a empezar el campeonato.

### Mercado de pases (entre partidos)

Con el dinero acumulado:

- **Fichar jugadores** → +1 ATAQUE o +1 DEFENSA (cada vez más caro)
- **Comprar ítems** para el próximo partido
- **Recuperar aguante máximo** perdido en partidos anteriores

---

## 8. Por qué esto funciona

- **La suerte está expuesta, no escondida.** Ves los porcentajes exactos y
  decidís igual. Perder no se siente injusto: elegiste ese riesgo.
- **Tres recursos que compiten.** Ir por la taquilla es una jugada que no usás
  para atacar. Cada decisión cuesta algo.
- **La progresión cambia el tablero sin cambiar el tablero.** El mismo rival de
  valor 3 pasa de ser una amenaza a ser un trámite cuando subís el stat.
- **Es simple de leer y difícil de dominar.** Una sola pregunta por turno: qué
  línea elijo.

---

## 9. Decisiones abiertas

- Tamaño de la grilla: **4×4** para arrancar. Podría ser 5×5 en rondas
  avanzadas.
- Cuántas jugadas dura un partido: propuesta **8 del RELOJ**.
- Aguante inicial: propuesta **5**.
- Stats iniciales: propuesta **ATAQUE 2 · DEFENSA 1**.
- ¿Se ve el tablero del rival o solo el tuyo? Propuesta: **un solo tablero
  compartido**, como en Sol Cesto.
