# DUELO FUTBOLERO

*(título provisorio, cambiable)*

Juego de estrategia y suerte inspirado en el sistema de **Sol Cesto**
(ver [notas-sol-cesto.md](notas-sol-cesto.md)), aplicado a partidos de fútbol
con progresión de campeonato.

---

## Cómo está organizada la pantalla

Tres columnas alrededor de la mesa, más una marquesina arriba:

```
┌──────────────────────────────────────────────────┐
│  RONDA        CLUB vs RIVAL        TIEMPO        │  marquesina
│                   2 · 1              70'         │
├───────────┬──────────────────────┬───────────────┤
│  ÍTEMS    │                      │  TU EQUIPO    │
│  (con su  │      MESA         │  aguante      │
│  descrip- │       4 x 4          │  racha        │
│  ción)    │                      │  presupuesto  │
├───────────┤                      ├───────────────┤
│  RELATO   │                      │  PLANTEL      │
│  DEL      │                      │  ataque       │
│  PARTIDO  │                      │  defensa      │
└───────────┴──────────────────────┴───────────────┘
```

**Arriba, al medio: el partido.** Ronda, rivales, marcador grande y el reloj. Es
lo único que se mira sin buscar.

**Derecha: el estado del equipo.** Aguante, racha y presupuesto, uno abajo del
otro, más los dos stats. Todo lo que *tenés*.

**Izquierda: lo que podés hacer.** Los ítems, cada uno **con su descripción a la
vista** —antes estaba en un `title` que en celular no existe, y un ítem que no se
entiende no se usa— y abajo el relato del partido, con lo último arriba.

Las columnas quedan fijas al hacer scroll. Debajo de 1120px las dos laterales
bajan abajo de la mesa en dos mitades; debajo de 700px se apilan en una sola,
con el estado del equipo antes que los ítems.

### La identidad visual

**El fondo es la cancha**, dibujada entera con gradientes CSS: césped con
franjas de corte, círculo central, línea de mitad, las dos áreas grandes y los
arcos. Ni una imagen — pesa cero y escala a cualquier pantalla. Encima va un
oscurecido radial para que la interfaz siga legible sobre el verde.

**La paleta es de noche de competición europea:** azul profundo y plateado sobre
el césped, con dorado para lo importante. Los paneles llevan un filo dorado
arriba, como los gráficos de televisación.

**La tipografía** son dos: *Saira Condensed* (condensada, pesada, en mayúsculas)
para marcadores, títulos y números, y *Archivo* para el texto corrido. Reemplazan
a Anton + Share Tech Mono, que tiraban más a fanzine que a transmisión de fútbol.
Se sacó la itálica de toda la interfaz: la condensada recta se lee mejor y es más
parecida a la gráfica de las competiciones europeas.

## 1. La idea en una frase

Cada partido es una **grilla de 4×4 jugadas**. No elegís la jugada: **elegís una
línea**, y el azar decide cuál de sus cartas te toca. Ves todas las
probabilidades antes de decidir. Ganás partidos, cobrás plata, comprás
jugadores, y avanzás hasta la final del campeonato.

---

## 2. Los recursos

| Recurso | Qué es | Cómo se pierde / gana |
|---|---|---|
| **AGUANTE** ❤ | El físico y la cabeza del equipo | Lo bajan los duelos perdidos y los goles del rival. Lo suben la hinchada, el cooling break y los ítems |
| **MARCADOR** | Goles tuyos y del rival | Cartas de gol, penales, tiros libres |
| **PRESUPUESTO** € | Solo para comprar **ítems** | Taquilla y sponsors, solo durante el partido |
| **CRONÓMETRO** ⏱ | Los 90 minutos del partido | Cada línea que elegís gasta **10 minutos** |
| **RACHA** ⚡ | Se carga ganando duelos | Al llenarse te da una **situación de gol a favor** y habilita la **columna** |

### Regla clave: cómo se conectan aguante y goles

Cuando el **AGUANTE llega a 0**, el rival **se gana una situación de gol** —no un
gol regalado— y tu aguante **vuelve a llenarse entero**.

El **máximo nunca se toca**: son 4 en todos los partidos, y se resetea al empezar
cada uno. El castigo por fundirte es el gol, punto. No hay espiral: un partido
malo no te deja peor parado para el siguiente.

La situación se sortea entre cuatro, con la misma probabilidad que su
equivalente a favor:

| Situación | Chance de gol | Peso en el sorteo |
|---|---|---|
| **PENAL** 🎯 | 50% | 2 |
| **PASE GOL** 🤝 | 40% | 3 |
| **CÓRNER** 🚩 | 30% | 3 |
| **TIRO LIBRE** 🚧 | 35% | 3 |

En conjunto: fundirte el aguante termina en gol el **~36%** de las veces, no el
100%. Se muestra en un pop-up que **primero te dice qué le tocó al rival y
con qué probabilidad**, y recién con un click se ejecuta.

### El aguante y la racha viajan entre partidos

Ninguno de los dos se resetea al empezar un partido: **son el estado del
equipo, no del partido**. Terminás fundido, arrancás fundido; terminás con la
racha cargada, arrancás pudiendo cobrarla —incluida la elección entre situación
de gol y columna, que sigue disponible desde la primera jugada.

Lo único que se resetea es lo que sí pertenece al partido: marcador, reloj y
amarillas. Y una corrida nueva sí arranca con el equipo entero.

Los dos efectos se compensan casi exactamente. Sobre 30.000 campeonatos:

| | Copas | ❤ al empezar cada ronda |
|---|---|---|
| Ambos se resetean | 2,76% | 4,0 / 4,0 / 4,0 / 4,0 / 4,0 |
| Solo la racha viaja | 3,86% | 4,0 / 4,0 / 4,0 / 4,0 / 4,0 |
| Solo el aguante viaja | 2,16% | 4,0 / 2,4 / 2,4 / 2,5 / 2,5 |
| **Los dos viajan** | **2,99%** | 4,0 / 2,4 / 2,4 / 2,5 / 2,5 |

La racha sola aflojaría el juego un 40% y el aguante solo lo endurecería un 22%.
Juntos quedan donde estaban: se gana continuidad sin tocar la dificultad.

Por eso las pantallas de entre-partidos muestran **cómo llega el equipo** —
corazones y racha— arriba del dinero: es lo que decide qué conviene comprar.

### Fundirse nunca termina en nada

Cuando el aguante se vacía, el rival se gana su situación — y **si la erra, te
llevás +1 ⚡**. Es la misma regla de las cartas de porcentaje en contra: te
salvaste, el equipo se levanta.

Cierra un círculo que quedaba abierto: antes, fundirte y que el rival fallara no
dejaba nada, ni bueno ni malo. Ahora el peor momento del partido tiene su premio
consuelo, y hasta puede completarte la racha.

| | Racha | Marcador |
|---|---|---|
| El rival convierte | sin cambio | -1 |
| **El rival la erra** | **+1 ⚡** | sin cambio |

El pop-up lo muestra debajo del marcador (`+1 ⚡ RACHA`), y la racha se suma
recién al cerrarlo, para que su propio aviso no se monte encima.

### Los dos medidores son el mismo mecanismo

**AGUANTE y RACHA valen 4 los dos**, y llegar al final del recorrido reparte una
situación de gol en cada caso:

| | Recorrido | Al llegar al final |
|---|---|---|
| **AGUANTE** ❤ | 4 → 0, lo vacían los golpes | Situación de gol **para el rival**, y se rellena entero |
| **RACHA** ⚡ | 0 → 4, la llenan los duelos ganados | **Elegís**: situación de gol **a favor** o atacar por **columna** |

Misma tabla de situaciones y mismas probabilidades de los dos lados: lo único
que cambia es quién patea.

**Dónde aparece cada cosa.** La **POSIBILIDAD DE GOL** va arriba de todo, justo
debajo del marcador. Las **cuatro columnas** van pegadas arriba de la mesa,
alineadas con las cartas que atacan: el botón tiene que estar donde está la
columna, no en otra parte de la pantalla.

**Las dos se muestran siempre, apagadas mientras no las tengas.** Escondiéndolas
hasta que la racha se llenara, un jugador nuevo no se enteraba de que existían
—y eso puede tardar partidos—. Apagadas se ven en gris, quietas, y el botón de
la derecha lleva el contador: `⚡ 0/4`, `⚡ 2/4`. Se entiende desde el minuto 0
qué hay que juntar y para qué sirve.

| | Apagado | Encendido |
|---|---|---|
| Banner | gris, ícono en escala de grises, `⚡ 2/4` | verde, latiendo, `USAR` |
| Columnas | grises, sin hover | doradas, clickeables |

El subtítulo también cambia: *"Se habilita con la racha llena"* mientras falta,
*"Cambiás la racha por una llegada clara"* cuando está lista.

**La racha es una moneda con dos precios.**

| Salida | Cuesta | Se habilita con |
|---|---|---|
| **COLUMNA** ⚡ | 3 ⚡ | **3** de racha |
| **SITUACIÓN DE GOL** ⚽ | la racha entera | **4** de racha (llena) |

La columna se habilita un escalón antes que el gol y cuesta 3; la situación de
gol exige llegar a 4 y se lleva todo. Ahí está la decisión: **gastar en 3 o
aguantar un paso más**. Antes las dos costaban lo mismo y la elección era solo
*cuál*, nunca *cuándo*.

Con la columna a 3 la diferencia es de un solo punto de racha, así que renunciar
al gol por una columna es una decisión cara — que es lo que se buscaba después de
ver que a 2 la columna se comía al gol por completo.

> **Riesgo conocido:** con la columna a 2, la simulación mostraba que casi nunca
> se llegaba a la situación de gol (0,04 usos por partido contra 0,49). A 3 la
> diferencia con el gol es de un punto, así que ahorrar cuesta mucho menos. Si
> aun así nunca llegás a cobrar el gol, `COSTO_COLUMNA` sigue siendo una línea.

**La racha llena no se cobra sola, y no te apura.** Al completarse sale un
pop-up que solo avisa: **se habilita la posibilidad de gol**. Le das a *continuar
partido* y volvés al mesa — no se gasta nada todavía.

El aviso menciona **únicamente la situación de gol**, porque es lo único que
aparece recién ahí. La columna se habilita antes, a los 3 de racha, así que a
esta altura el jugador ya la viene usando y repetirla sería ruido.

A partir de ahí la racha queda **cargada y marcada**: el medidor RACHA del HUD
se enciende en dorado con el cartel `⚡ LISTA` y late suave, la línea de ayuda lo
recuerda, y aparece la barra dorada con las cuatro columnas más el botón verde
de **situación de gol**. Podés seguir eligiendo filas normalmente todas las
jugadas que quieras: las dos salidas siguen ahí hasta que gastes una, y recién
entonces la racha se vacía entera.

Las dos cuestan una jugada, así que la pregunta es cuál te sirve más con el
mesa que tenés delante:

- **Situación de gol** — un ~36% de gol limpio, sin riesgo de que te lastimen.
  Sirve cuando la mesa está feo y cualquier carta que toques te pega.
- **Columna** — atacás donde vos querés. Sirve cuando hay una columna cargada de
  cosas buenas que ninguna fila te deja alcanzar.

Sobre 20.000 campeonatos simulados las dos opciones dan prácticamente el mismo
resultado (1,4% contra 1,5% en el simulador de referencia). Que ninguna domine
es la señal de que la elección es real.

El click de los pop-ups no cambia nada del azar: le da el momento de tensión
que el resultado automático no tenía.

Así el aguante no es una barra de "game over" abrupta: es *cuánto podés aguantar
antes de que te la metan*. Marcador y aguante son el mismo sistema.

---

## 3. Los stats del equipo

| Stat | Color | Contra qué se compara |
|---|---|---|
| **ATAQUE** | 🔴 rojo | Defensores y arqueros rivales — cuando atacás vos |
| **DEFENSA** | 🔵 azul | Delanteros rivales — cuando ataca el rival |

Igual que en Sol Cesto: si tu stat **alcanza o supera** el de la carta, ganás
el duelo. Si no, perdés.

Subir un stat no es "pegar más fuerte": es **volverte inmune a toda una clase de
cartas**. Con ATAQUE 2 todos los defensores de valor 3 te frenan; con ATAQUE 3
dejan de existir como amenaza. Ese es el motor de progresión del campeonato.

**Los stats solo cambian entre partidos.** Durante un partido son fijos:
nada de la mesa te los sube ni te los baja. El jugador tiene que poder mirar
una carta y saber con certeza qué le va a pasar — si un stat pudiera moverse
a mitad de partido, todos los carteles de la mesa estarían mintiendo.

### Los rivales se acomodan a tu plantel

Cada partido es un poco más difícil si mejoraste. Los valores de las cartas
suben junto con tus fichajes, pero **a la mitad de tu ritmo**:

> Por cada **2 puntos** que subís un stat, las cartas de ese color suben **1**.

**Ojo con esto:** con los 4 refuerzos que se reparten en una corrida, en la final
seguís perdiendo prácticamente todos los duelos — hacen falta ATAQUE 5 / DEFENSA 4
para cruzar el umbral del nivel 5, y no se llega. El motor de progresión funciona
en las primeras rondas y se apaga en las últimas. Pendiente de arreglar: bajar los
valores de los pools 4-5, o `ESCALA_RIVAL` a 0,34.

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

## 4. Catálogo de cartas

### Duelos

| Carta | Color | Si ganás el duelo | Si perdés |
|---|---|---|---|
| **DEFENSOR RIVAL** 🔴 N | rojo | Lo pasás: **+1 RACHA** | **-1 aguante** |
| **ARQUERO RIVAL** 🔴 N | rojo | **¡GOL!** | -1 aguante |
| **DELANTERO RIVAL** 🔵 N | azul | Se la sacás: **+1 RACHA** | **GOL EN CONTRA** |
| **MEDIOCAMPISTA** 🔵 N | azul | Le ganás la pelota | -1 aguante |

### Cartas de gol

| Carta | Efecto |
|---|---|
| **JUGADA CLARA** ⚽ | **Gol directo**, sin tirada |
| **AUTOGOL RIVAL** 🎁 | **Gol directo**, sin tirada |
| **PENAL A FAVOR** 🎯 | **50%** — entra: gol **+1 ⚡** / no entra: **-1 ❤** |
| **PASE GOL** 🤝 | **40%** — entra: gol **+1 ⚡** / no entra: **-1 ❤** |
| **CÓRNER** 🚩 | **30%** — entra: gol **+1 ⚡** / no entra: **-1 ❤** |
| **TIRO LIBRE** 🚧 | **35%** — entra: gol **+1 ⚡** / no entra: **-1 ❤** |

Y las mismas, pero **para el rival** (aparecen desde la ronda 2 en adelante):

| Carta | Efecto |
|---|---|
| **CONTRAATAQUE RIVAL** 💥 | **Gol del rival** directo, sin tirada |
| **AUTOGOL PROPIO** 🙈 | **Gol del rival** directo, sin tirada |
| **PENAL RIVAL** 💀 | **50%** — entra: gol rival **-1 ❤** / no entra: **+1 ⚡** |
| **PASE GOL RIVAL** 🕳 | **40%** — entra: gol rival **-1 ❤** / no entra: **+1 ⚡** |
| **CÓRNER RIVAL** 🌪 | **30%** — entra: gol rival **-1 ❤** / no entra: **+1 ⚡** |
| **LIBRE RIVAL** 🧨 | **35%** — entra: gol rival **-1 ❤** / no entra: **+1 ⚡** |

### Campeonatos encadenados

Salir campeón **no termina la partida**: arrancás otro campeonato con la plata y
los ítems que te quedaron, pero con el equipo entero.

| Se conserva | Se reinicia |
|---|---|
| 💰 la plata acumulada | ❤ aguante (y su máximo) |
| 🎒 los ítems sin usar | ⚡ racha |
| 🏆 las copas ganadas | ⚔🛡 ataque y defensa |

**Los ítems de arranque se reponen, no se reemplazan.** De cada uno —SUPLENTES y
GRITO DEL DT— se garantiza al menos uno, sin tocar lo que hayas acumulado:

| Con lo que terminás | Con lo que arrancás |
|---|---|
| *(nada)* | `suplentes:1  grito:1` |
| `suplentes:3  grito:2` | `suplentes:3  grito:2` |
| `suplentes:4` | `suplentes:4  grito:1` |
| `suplentes:1  var:2` | `suplentes:1  var:2  grito:1` |
| `var:1  aire:2` | `var:1  aire:2  suplentes:1  grito:1` |

Nunca empezás un campeonato con las manos vacías, pero ahorrar tampoco se
castiga: si llegaste con tres suplentes, seguís con los tres.

La cadena se corta al perder. Ahí la pantalla de ELIMINADO muestra **cuántas
copas llevabas** y el resumen de cada una, y el botón *empezar de nuevo* resetea
todo —plata, ítems y copas— para arrancar limpio.

Los stats vuelven a 2/1 en cada campeonato: si se acumularan, el segundo sería
un paseo. La plata sí se acumula porque es lo que le da sentido a encadenar —
llegás con billetera al mercado de la ronda 1.

### El partido único

Un partido suelto, con las mismas reglas del campeonato pero sin rondas ni
mercado. Dos cosas propias:

**Elegís tres ítems antes de jugar.** No hay plata acumulada, así que en vez de
comprar se reparten cupos:

```
   ELEGÍ TUS ÍTEMS
   ● ● ○   te queda 1

   🪑 SUPLENTES  x2      📢 GRITO DEL DT
   💪 SEGUNDO AIRE       📺 VAR
```

| Ítem | Máximo |
|---|---|
| 🪑 SUPLENTES | **3** |
| 📢 GRITO DEL DT | **3** |
| 💪 SEGUNDO AIRE | **1** |
| 📺 VAR | **1** |

Los básicos se repiten —tres suplentes es una estrategia tan válida como uno de
cada uno— pero **los dos fuertes van de a uno**: el SEGUNDO AIRE recupera un
corazón de máximo y el VAR destraba una carta, así que tres de cualquiera de
ellos desbalancea el partido.

El tope se ve en la ficha (`máx 1`) y el botón se apaga al llegar, pero **el cupo
sigue libre** para los demás. La ✕ del inventario lo devuelve.

**El empate se define con tanda completa**, como en la final: cinco penales cada
uno y muerte súbita. Los dos son el último partido de su modo, así que merecen su
tanda; en el campeonato una ronda de paso se define con un penal suelto porque
todavía queda torneo por delante.

### El menú principal

La primera pantalla muestra el logo y los seis caminos:

| | | |
|---|---|---|
| 🏆 | **CAMPEONATO** | cinco rondas hasta la copa |
| ⚽ | **PARTIDO ÚNICO** | un partido suelto, mismas reglas |
| 🤝 | **1 vs 1** *(beta)* | dos jugadores, misma mesa |
| 🥅 | **SERIE DE PENALES** | directo a la tanda |
| ⚙ | OPCIONES | volumen, pantalla, animaciones *(pendientes)* |
| ★ | CRÉDITOS | |

Antes se entraba directo a crear el club y el 1v1 quedaba escondido detrás de un
botón secundario. Con el menú, cada modo pesa lo que tiene que pesar: el
campeonato lleva el borde dorado por ser el camino principal, el resto va parejo.

**PARTIDO ÚNICO** usa las mismas reglas del campeonato pero termina ahí: sin
rondas, sin mercado y sin refuerzos. Al terminar ofrece revancha o volver al
menú.

**SERIE DE PENALES** arma dos equipos mínimos y llama a la misma `serieDePenales`
del campeonato, con la moneda y la tanda completa.

El estilo toma del logo el azul profundo con filo dorado, y cada opción se
enciende como una carta de la mesa al pasar por encima.

### Cómo se juega

Al tocar **EMPEZAR LA COPA** sale una pantalla con las cinco cosas que hay que
saber, en el orden en que se necesitan:

| | |
|---|---|
| 🎲 | **Elegís una FILA y el azar cae en una de sus cartas** — pero ves lo que hace cada una antes |
| ❤ | **El AGUANTE es el físico** — al vaciarse, el rival se gana una situación |
| ⚡ | **La RACHA es el envión** — con 3 atacás por columna, llena la cambiás por una **posibilidad de gol** (38%, no un gol seguro) |
| ⚔ | **Los duelos se ganan con stats** — y si empatan, se abre un **mini juego** al 50% |
| ⏱ | **Nueve jugadas** — cinco rondas, el que pierde queda afuera |

Las tres correcciones que hubo que hacerle al texto muestran lo fácil que es
prometer de más al explicar: *"cambiarla por un gol"* cuando en realidad es una
**posibilidad** de gol, *"elegís la fila"* sin decir que el azar elige la carta,
y *"mano a mano"* cuando el juego lo llama **mini juego**. Un tutorial que no usa
las palabras exactas del juego enseña algo distinto al juego.

**Se puede reabrir durante el partido** con el `?` que está debajo de la mesa.
Son más reglas que las del 1v1 y nadie las retiene de una sola lectura; tener que
salir de la partida para releerlas sería peor que no explicarlas.

El botón de abajo cambia según de dónde se abrió: `EMPEZAR LA COPA` la primera
vez, `VOLVER AL PARTIDO` si se abrió con el `?`.

### La pantalla del club

Dos columnas: el escudo grande a la izquierda con el nombre debajo, los
controles a la derecha. **Entra sin scroll** —`max-height: calc(100vh - 72px)`—
en desktop, celular y celular acostado.

Antes era una lista vertical larga y en pantallas bajas había que scrollear para
llegar al botón de empezar, que es lo último que uno quiere buscar.

En el celular las dos columnas se apilan y el escudo pasa al costado del nombre,
en horizontal. **Acostado vuelve a dos columnas**: ahí lo que falta es alto, no
ancho.

Toma del menú su lenguaje: azul profundo, filo dorado, y los botones se encienden
como cartas de la mesa.

### El escudo del club

Antes de empezar elegís **forma** y **colores**, y el escudo lleva la inicial del
nombre que vayas escribiendo.

| Forma | De dónde sale | Patrón |
|---|---|---|
| **CLÁSICO** | hombros rectos y punta redondeada | mitades verticales |
| **INGLÉS** | esquinas suaves arriba, base ancha | franja horizontal |
| **ITALIANO** | cintura marcada y punta larga | banda diagonal |
| **BANDERÍN** | vertical con punta en V, típico argentino | tres franjas |
| **OVALADO** | la elipse de los clubes europeos | franja central |

Cinco siluetas de **escudos reales**, no formas geométricas. Con 9 colores de
fondo y 9 de detalle son **405 combinaciones**, todas verificadas.

**El escudo arranca al azar** cada vez que se abre la pantalla: el jugador ve
algo armado en vez de un molde vacío, y si le gusta lo deja. Antes siempre
empezaba en el mismo azul y amarillo.

Cinco siluetas tomadas de **escudos reales**, no formas geométricas. Con
9 colores de fondo y 9 de detalle son **405 combinaciones**, todas verificadas.

Cada forma trae su propio patrón para que se distingan **de lejos y en chico** —
en la marquesina el escudo mide 26px, y a ese tamaño la silueta sola no alcanza
para diferenciar cuatro opciones.

**Dos colores independientes** —fondo y detalle— de una paleta de nueve:

`BLANCO · NEGRO · ROJO · AMARILLO · AZUL · VERDE · VIOLETA · NARANJA · ROSA`

Son **324 combinaciones** (4 formas × 9 × 9) contra las 24 de la versión con
paletas armadas. Elegir los dos por separado deja armar el escudo de cualquier
club real en vez de tener que conformarse con la combinación más parecida.

Los botones del selector **son el escudo real en miniatura**, no nombres: se
elige mirando el resultado. Y la vista previa se actualiza mientras escribís, así
que ves tu inicial adentro antes de confirmar.

El botón **🎲 ALEATORIO** sortea una combinación, y siempre distinta a la que
estabas viendo: si pudiera repetir la anterior, parecería que el botón no hizo
nada.

El escudo acompaña al club toda la partida —en la marquesina junto al nombre y en
todos los marcadores— y sobrevive tanto a encadenar campeonatos como a empezar de
nuevo: es tu club, no la corrida.

### Cada rival tiene el suyo

El rival estrena escudo **en cada partido**, sorteado, con su propia inicial:

```
DEPORTIVO BARRIAL     REDONDO / VERDE Y BLANCO
ATLÉTICO DEL SUR      ROMBO / CELESTE
RACING DEL PUERTO     CLÁSICO / ROJO Y BLANCO
UNIÓN FERROVIARIA     ROMBO / ROJO Y BLANCO
CLUB IMPERIAL         REDONDO / CELESTE
```

**Nunca usa tu color de fondo**, y sus dos colores son siempre distintos entre
sí. En el marcador los dos escudos van uno al lado del otro, y si compartieran
colores el marcador dejaría de leerse de un vistazo — que es justamente lo que el
escudo vino a mejorar.

### El footer

Barra fija abajo, centrada, de 26px:

```
──────────────────────────────────────────────
     📷 @nickkdia  ·  ✉ nicolasdiani@gmail.com
```

Fondo semitransparente con desenfoque, texto en gris que se dora al pasar.
Instagram abre en pestaña nueva y el mail dispara `mailto:`.

**Va por encima de todo** (`z-index: 300`), así que las cuatro capas que pueden
ocupar la pantalla reservan su franja para que ningún botón quede tapado:

| Capa | Reserva |
|---|---|
| `body` | `padding-bottom: 36px` |
| `.overlay` (tarjetas) | `padding-bottom: 56px` |
| `.sit-flash` · `.gol-flash` · `.play-flash` | `padding-bottom: 56px` |

Sin eso, el botón de una tarjeta o el de una situación de gol podía quedar
debajo de la barra — el pop-up se centra en la pantalla entera y no sabe que hay
algo fijo abajo.

En pantallas de menos de 380px el separador `·` se oculta y los dos enlaces
pasan a dos líneas.

### Las copas, en la marquesina

Arriba de la instancia, en la esquina izquierda, va la racha de campeonatos
ganados: un 🏆 por copa hasta cuatro, y de ahí en más `🏆🏆🏆🏆 x7`.

```
🏆🏆 CAMPEONATOS
CUARTOS
```

**Solo aparece si hay al menos una.** El que todavía no ganó ninguna no necesita
un recuadro vacío recordándoselo, y esas partidas son la mayoría.

En pantallas chicas la etiqueta se oculta y quedan solo los trofeos, en la misma
línea que la ronda. En el modo 1v1 no aparece: ahí la serie tiene su propio
marcador.

### El sorteo, a la vista

Elegir una fila son **dos toques**:

1. **El primero resalta** — las cuatro cartas se encienden con su color y el
   aviso dice `Tocá otra vez F1`
2. **El segundo sortea** — un cursor blanco recorre las cartas frenando como una
   ruleta, hasta parar en la que salió

Antes con mouse el primer click iba directo: el resaltado no se llegaba a leer y
la carta aparecía resuelta sin más. **El azar quedaba invisible**, que es
justamente el corazón del juego.

| | |
|---|---|
| Velocidad del cursor | 85ms, frenando 48ms por paso al final |
| Color del cursor | blanco al 55%, no dorado |
| Vueltas | cuatro pasadas completas antes de frenar |

El cursor va en **blanco semitransparente** a propósito: el dorado ya está en el
filo de las cartas y en los tonos del resaltado, y un cursor dorado se perdía
encima. El blanco no compite con ningún tono y se lee sobre los cuatro.

**Las cartas no se dan vuelta.** Se probó taparlas con el logo al dorso, pero el
jugador ya leyó los colores al resaltar la fila y sigue queriendo ver qué puede
tocarle mientras el cursor corre — taparlas le sacaba justo ese momento de
tensión.

Solo corre cuando hay **más de una carta jugable** — con una sola no hay nada que
sortear.

### El alto se reparte por filas de grid

```css
.cancha{
  display:grid;
  grid-template-rows: auto auto minmax(0,1fr) auto auto auto;
                              └── la mesa toma lo que sobra
}
```

> **La mesa se desbordaba y el marcador quedaba cortado.** La cancha era un grid
> con `flex:1`, pero **`flex` no reparte el alto entre las filas de un grid**:
> la mesa pedía su tamaño natural, el total superaba la pantalla, y el
> `overflow:hidden` del body cortaba lo que sobraba — sin manera de llegar a ello.
>
> Ahora la fila de la mesa lleva `minmax(0,1fr)`: toma exactamente lo que queda
> después de las demás. Y el body usa `min-height` en vez de `height`, así que
> si en algún dispositivo no entrara, la página crece y se puede scrollear en
> vez de esconder contenido.

| Dispositivo | Útil | Mesa | Por fila |
|---|---|---|---|
| iPhone SE | 580px | 374px | 89px |
| iPhone 14 | 734px | 528px | 128px |
| **iPhone 17 Pro** | 760px | 554px | **134px** |
| S24 Ultra | 796px | 590px | 143px |
| 14 Pro Max | 811px | 605px | 147px |
| iPad vertical | 1027px | 821px | 201px |

*(el «útil» descuenta ~13% por las barras del navegador)*

### Las fichas fluyen en desktop

En **mobile** la ficha va flotando sobre el juego: el espacio es escaso y tapar
un momento no molesta. En **desktop fluye dentro del panel**, ocupa su lugar y
empuja lo de abajo.

> La ficha del ítem salía del panel de ítems, que en desktop tiene el relato
> justo debajo — con `position: absolute` le quedaba encima y tapaba el texto.
> Sin absolute no hay nada que se superponga y el navegador acomoda el resto
> solo.

**La ficha es una sola, pero se muda** al contenedor que la abre: la de ítems al
panel de ítems, la de gol junto a su banner. Antes se creaba una vez y se quedaba
donde nació, así que la de gol aparecía colgada del panel equivocado.

### El panel de PLANTEL

```
   ┃ 2   ATAQUE
   ┃     vs. defensores y arqueros

   ┃ 1   DEFENSA
   ┃     vs. delanteros rivales
```

El número pasó de 23px a **34px** y va a la izquierda con ancho fijo, así los dos
textos quedan alineados sobre la misma vertical. El nombre del stat sube a 13px
en la tipografía de títulos, con la explicación debajo en 10,5px.

Cada ficha lleva un **filo de 3px** en su color —rojo el ataque, azul la
defensa— que la identifica sin depender de leer.

### Ningún panel se mueve

Los paneles quedan **donde los pone el HTML**. Cada media query les asigna su
lugar con `grid-area`, y `display: contents` disuelve los contenedores que
sobran.

> **Antes se movían con JS al cargar**, según el ancho de pantalla. Eso rompía al
> **rotar la tablet**: si arrancaba en vertical el DOM quedaba armado para
> mobile, y al girar el CSS pasaba a desktop con los paneles en el lugar
> equivocado — medidores sueltos flotando, la mesa fuera de su columna.
>
> Con todo en CSS, rotar solo cambia qué media query aplica.

### Qué layout toma cada pantalla

La separación ya no es solo por ancho, porque **una tablet acostada tiene la
misma forma que un monitor**:

| | Condición |
|---|---|
| **Mobile** | `max-width:1024px` **y vertical**, o menos de 820px |
| **Desktop** | más de 1025px, **o** más de 821px **y acostado** |

| Dispositivo | | Layout |
|---|---|---|
| iPhone 14 vertical | 390×844 | mobile |
| iPhone 14 acostado | 844×390 | desktop |
| iPad vertical | 820×1180 | mobile |
| **iPad acostado** | 1180×820 | **desktop** |
| Portátil | 1366×768 | desktop |

Cada pantalla toma un layout y solo uno: no hay solapamiento.

### Desktop: el layout que fluye

```
┌──────────┬────────────────────────┬──────────┐
│ TU EQUIPO│  la marquesina          │ PLANTEL  │
│ ❤ ⚡ €   │  ─────────────────      │ ATK DEF  │
│ ÍTEMS    │  LA MESA (4x4)          │ RELATO   │
│ ⚽ GOL    │  columnas               │          │
└──────────┴────────────────────────┴──────────┘
```

**La página fluye**: no se fuerza el alto de nada, el contenido manda y el
navegador scrollea si hace falta. Las columnas laterales quedan **pegajosas**
(`position: sticky`) para que los ítems y el estado no se vayan de vista al
bajar.

| | ≤1300px | 1025-1600 | ≥1600px | ≥1900px |
|---|---|---|---|---|
| Columnas | 210 / 190 | 245 / 215 | 265 / 235 | 290 / 260 |
| Alto de carta | 118px | 126px | 150px | 170px |
| Título de carta | 12px | 13px | 14,5px | 16px |
| Ancho máximo | — | 1320px | 1480px | 1640px |

**Lo que cambia respecto de mobile:**

- los **ítems muestran su descripción completa**
- la **posibilidad de gol** muestra su bajada explicativa
- los **medidores llevan etiqueta** (`AGUANTE`, `RACHA`)
- el **relato vive en su panel**, sin botón flotante

> **Se probó forzar el alto con `100dvh` y no funcionaba**: la mesa se comprimía
> y las columnas laterales quedaban con huecos. En mobile ese enfoque es
> necesario —la pantalla es alta y angosta, todo tiene que entrar— pero en
> desktop el contenido cabe de sobra y dejarlo fluir se ve mejor.
>
> **Los dos layouts no se pisan.** Mobile vive en `max-width` y desktop en
> `min-width`. Y el JS que arma la fila de acción **solo corre en pantallas
> angostas**, porque en desktop cada panel se queda en su columna.

### El alto real de la pantalla

```css
body{ height:100dvh; display:flex; flex-direction:column; overflow:hidden }
.cancha{ flex:1; min-height:0 }
.board{ flex:1; min-height:0 }
```

**`dvh` y no `vh`.** En el celular la barra del navegador se suma y resta al alto
de la ventana, y `100vh` mide la pantalla **completa** —incluidas esas barras—,
así que la última fila quedaba debajo del borde. `100dvh` mide lo que se ve de
verdad.

Con el alto fijado, la mesa **toma lo que sobra** en vez de calcularse por `vh`:
así entra exacto en cualquier pantalla, con barras o sin ellas. `--carta` queda
en 76px como piso de legibilidad, no como medida.

### Espacio para la posibilidad de gol

| | Antes | Ahora |
|---|---|---|
| Ícono del ítem | 14px | **12px** |
| Efecto del ítem | 38px de ancho | **30px** |
| Stats | dos fichas en fila | **apiladas, número al lado de su etiqueta** |
| Nombre de la carta | 9,2px | **10,8px** |

Los ítems son un atajo que se usa de vez en cuando; la posibilidad de gol se mira
en cada jugada. El ancho que ceden se lo lleva la columna del medio.

Los stats apilados con el número **al lado** de su etiqueta ocupan mucho menos
ancho que dos fichas en fila con el número arriba.

### El nombre de la carta, más grande

| Breakpoint | Antes | Ahora |
|---|---|---|
| Mobile chico | 9,6px | **11,2px** |
| Mobile | 10,8px | **12,6px** |
| Desktop | 13px | **15px** |
| ≥1600px | 14,5px | **16,5px** |
| ≥1900px | 16px | **18px** |

Subió entre **15% y 17%** en los siete breakpoints. El nombre es lo primero que
se lee de una carta —dice de qué se trata antes que el número o el efecto— y a
los tamaños anteriores había que fijarse.

Los nombres largos siguen entrando: el más largo es `DELANTERO RIVAL` con 15
caracteres, y el corte por `overflow-wrap: anywhere` los parte en dos líneas
cuando hace falta. Con la carta más cargada —la de mini juego— quedan entre 34px
y 71px para la ilustración según el dispositivo.

### Las cuatro filas miden lo mismo

```css
.board{ display:grid; grid-auto-rows:minmax(var(--carta), 1fr) }
```

Las cuatro se reparten el alto **en partes iguales**, sin importar qué cartas les
toquen. `--carta` es el piso —lo que garantiza que se sigan leyendo en pantallas
bajas— y `1fr` reparte lo que sobra.

> **Antes la mesa saltaba.** Las cartas con mini juego pedían `min-height: 142px`
> contra los 126px normales, porque llevan una línea más. Esa fila crecía y las
> otras tres se achicaban, así que la mesa cambiaba de forma según qué salía en
> el sorteo.

La carta lleva `overflow: hidden`: si el contenido no entra en el alto que le
tocó se recorta, que es preferible a una mesa que se mueve entre jugadas. Con la
carta más cargada —la de mini juego, ~58px de texto fijo— queda espacio para la
ilustración en todos los dispositivos, desde 32px en un iPhone SE hasta 66px en
un S24 Ultra.

### El dinero, junto a las columnas

```
   ┌────────┬─────────┬──────────────────┬─────────┐
   │ ÍTEMS  │ ❤ ❤ ❤ · │ [⚽ POSIBILIDAD]  │ [2] [1] │
   │        │ ⚡ ⚡ · · │                  │ ATK DEF │
   └────────┴─────────┴──────────────────┴─────────┘

   €25M   [C1 · 25% −3⚡] [C2] [C3] [C4]
```

El dinero se mudó al **hueco que dejan las columnas** —el que queda alineado con
los botones de fila, que estaba vacío— en vez de apretar la columna de
medidores. Eso le devuelve una línea entera a la racha.

Los dos medidores ahora comparten **celda y tamaño**: `repeat(4, 21px)` con
íconos de 19px, así cada rayo queda justo debajo de su corazón, a la misma
altura.

| | Antes | Ahora |
|---|---|---|
| Corazón | 17px | **19px** |
| Rayo | 14×18px | **16×19px** |
| Columna de medidores | 3 líneas | **2 líneas** |

### Filas y columnas, del mismo peso

| | Mobile |
|---|---|
| Botón de fila `F1` | 12px, tipografía de títulos |
| Botón de columna `C1 · 25% −3⚡` | **11,5px**, tipografía de títulos |

La columna iba en 9,5px con la tipografía de texto y parecía secundaria, cuando
**las dos son la misma decisión**: elegís una línea y el azar cae en una de sus
cartas. Ahora comparten peso y tamaño.

El texto de la columna lleva más información —el porcentaje y el costo en
racha— así que va un punto por debajo. Verificado: entra en 360px, que es la
pantalla más angosta de los celulares actuales.

### El sorteo mostraba una carta y jugaba otra

> **Había dos sorteos independientes.** La animación elegía con `rnd()` cuál
> resaltar, y `situacionGol` elegía por su cuenta cuál resolver. Coincidían solo
> por casualidad: veías ganar el PENAL y te salía un CÓRNER.
>
> Ahora el sorteo se hace **una sola vez**, en la animación, y la carta elegida
> viaja hasta `situacionGol` para que resuelva esa misma. Verificado en cuatro
> corridas seguidas.

### Un solo gesto para el azar

Los dos sorteos del juego usan **el mismo cursor**: recorre las opciones
frenando como una ruleta y para en la que salió.

```
   ○ ▪ ▪ ▪ ▪
   ▪ ○ ▪ ▪ ▪      tres vueltas completas
   ▪ ▪ ○ ▪ ▪
   ▪ ▪ ▪ ○ ▪
   ▪ ▪ ▪ ▪ ○      y va frenando
   · ★ · · ·      para en la que salió
```

| | Dónde |
|---|---|
| La mesa | las cartas de la fila elegida |
| La posibilidad de gol | las cinco opciones de la ficha |

> **Se probó eliminarlas de a una** y se volvió atrás: es el mismo azar, con las
> mismas reglas, así que merece el mismo gesto. Dos animaciones distintas para
> lo mismo obligan a aprender dos códigos.

Velocidad: **85ms**, frenando 48ms por paso sobre el final. El cursor es blanco
semitransparente en los dos casos.

### Las cinco pesan igual

| | Sale | Gol |
|---|---|---|
| ⚽ JUGADA CLARA | 20% | **GOL** |
| 🎯 PENAL 🎮 | 20% | 50% |
| 🤝 PASE GOL | 20% | 40% |
| 🚩 CÓRNER | 20% | 35% |
| 🚧 TIRO LIBRE | 20% | 30% |

Antes los pesos iban de 1 a 3, así que la jugada clara salía el **8%** y el tiro
libre el 25%: el premio grande de llenar la racha casi no aparecía.

Con todas iguales el **gol esperado sube de 43% a 51%**, así que la racha llena
pasó a valer bastante más.

### La ficha de la posibilidad de gol

Tocar el cartel verde abre las **cinco cartas que pueden salir**, con su chance
de aparecer y de terminar en gol:

```
   ⚽ POSIBILIDAD DE GOL                    43% de gol

   ┌─────┐ ┌──🎮─┐ ┌─────┐ ┌─────┐ ┌─────┐
   │  ⚽  │ │  🎯  │ │  🤝  │ │  🚩  │ │  🚧  │
   │ GOL │ │50%  │ │40%  │ │35%  │ │30%  │
   │sale8│ │sale17│ │sale25│ │sale25│ │sale25│
   └─────┘ └─────┘ └─────┘ └─────┘ └─────┘
      ★  verde: entra siempre    🎮 dorado: se patea

   [ USAR LA RACHA ]  [ VOLVER ]
```

Antes se cobraba la racha a ciegas: el cartel decía «43% de gol» pero no de dónde
salía ese número, ni que una de las cinco **entra siempre** y otra **se juega**.

| | Sale | |
|---|---|---|
| ⚽ JUGADA CLARA | 8% | **GOL** |
| 🎯 PENAL 🎮 | 17% | 50% GOL |
| 🤝 PASE GOL | 25% | 40% GOL |
| 🚩 CÓRNER | 25% | 35% GOL |
| 🚧 TIRO LIBRE | 25% | 30% GOL |

El penal lleva el **mismo dorado con 🎮** que las cartas de duelo, para que el
código se reconozca: dorado con mando significa que vas a jugar algo.

Usa la misma franja anclada que los ítems, así abrir cualquiera de las dos es el
mismo gesto.

### La ficha del ítem sale al costado

```
   [🪑 +1❤] ◄─┐
              │  🪑 SUPLENTES  +1 ❤
              │  Entra sangre nueva del banco.
              │  [ USAR ]  [ VOLVER ]
              └──────────────────────────
```

Sale **a la derecha del ítem**, con un pico que lo señala. Antes caía debajo y
empujaba lo que seguía; ahora no mueve nada y queda claro de qué ítem salió.

**Paleta propia: violeta grafito con filo lila.** Las cartas de la mesa son
azules con filos de color y los paneles también azules — la ficha necesitaba
salirse de esa familia para no confundirse con el fondo. El halo difuminado la
despega todavía más.

En pantallas de menos de 560px no hay lugar a la derecha, así que **cae debajo
del ítem** y el pico apunta hacia arriba.

### La ficha del ítem

Tocar un ítem ya no lo usa: **abre una ficha** al pie de la fila de acción con lo
que hace y dos botones.

```
   🪑 SUPLENTES  +1 ❤              [ USAR ] [ VOLVER ]
   Entra sangre nueva del banco.
```

Antes el toque lo gastaba directo, así que había que acordarse de memoria qué
hacía cada uno — o gastarlo para enterarse.

Va **anclada a la fila**, no centrada en la pantalla: el juego sigue a la vista
mientras decidís. El ítem abierto se marca con borde dorado, porque la franja no
tiene pico que lo señale.

**Cuando el ítem no sirve**, la ficha lo explica y no ofrece usarlo:

```
   🪑 SUPLENTES  +1 ❤                      [ ENTENDIDO ]
   El aguante ya está completo.
```

**El VAR** es el caso especial: tiene que apuntar a una carta trabada. Ahí USAR
cierra la ficha y pasa a modo apuntado, y tocar el ítem de nuevo cancela.

En pantallas de menos de 440px los botones bajan a su propia línea y ocupan el
ancho completo.

### Los ítems se acomodan en grilla

| Ítems | Cómo se ven |
|---|---|
| 0 | `SIN ÍTEMS` en una ficha de borde punteado |
| 1-2 | una columna |
| 3-4 | **dos columnas de dos** |

Apilados en una sola columna, con cuatro ítems la fila crecía al doble de alto y
se comía el espacio de la mesa. Con `grid-auto-flow: column` y dos filas a partir
del tercero, la columna llega a **55px** contra los **58px** de los medidores —
así que los ítems nunca empujan la fila.

> **El mensaje de «sin ítems» era una frase entera**: *«No tenés ítems. Se
> compran en el mercado, entre partido y partido.»* En mobile la columna es
> angosta y ese texto la ensanchaba, empujando al resto. Ahora dice `SIN ÍTEMS`
> y va en una ficha del mismo tamaño que un ítem — dónde se compran ya lo
> explica el tutorial y el propio mercado.

### La barra y la fila de acción

```
   CLASIF      🛡        🛡      ╭──╮
             LOCAL 2-1 VISIT    │70│
                                ╰──╯

   ┌────────┬─────────┬──────────────────┬─────────┐
   │ ÍTEMS  │ ❤❤❤·   │  [⚽ POSIBILIDAD] │ [2] [1] │
   │        │ ⚡⚡··   │                  │ ATK DEF │
   │        │ €25M    │                  │         │
   └────────┴─────────┴──────────────────┴─────────┘
```

**El marcador** lleva los números al centro con el guion y cada equipo a su
lado, con el **escudo arriba del nombre**. El escudo va a 17px para que la barra
no crezca por apilarlos.

**La fila de acción** es un grid de cuatro columnas: las tres de los costados
toman su ancho y **la del medio se estira** con `1fr`. Así la fila siempre llena
la pantalla y la posibilidad de gol queda centrada por construcción, sin
depender de márgenes.

Aguante, racha y dinero van **uno debajo del otro** pegados a los ítems, que es
lo que deja la columna del medio más ancha.

| Dispositivo | Carta | Sobra |
|---|---|---|
| iPhone SE | 90px | 116px |
| Samsung S23 | 105px | 168px |
| iPhone 14 | 114px | 197px |
| iPhone 17 Pro | 118px | 211px |
| Samsung S24 Ultra | 124px | 230px |
| 14 Pro Max | 126px | 238px |

### El relato, en un botón flotante

En mobile el relato ya no ocupa una franja fija arriba de la mesa: vive detrás de
un **📋 abajo a la derecha** y se abre como panel sobre el juego.

Un **punto verde** en el botón avisa que hay relato sin leer — lo enciende un
`MutationObserver` sobre el log y se apaga al abrirlo.

Eso libera **66px**, que es casi media carta más de alto para la mesa.

### La barra, más angosta

```
CLASIFICATORIA   🛡 INDE 0 - 0 DEPO 🛡   ╭──╮
                                         │70│
                                         ╰──╯
```

Los escudos van **en la misma fila que los números**, no debajo. El lado del
rival usa `flex-direction: row-reverse` para que su escudo quede por fuera, en
espejo.

| | Antes | Ahora |
|---|---|---|
| Alto de la barra | 54px | **46px** |
| Reloj | 46px | **42px** |
| Botón de fila | 34px | **28px** |
| `%` de la fila | 9px | **7,5px** |

### Aguante, racha y dinero en una línea

Van en `grid-template-columns: auto 1fr auto`: aguante a la izquierda, racha
centrada, plata a la derecha. Antes se envolvían en dos renglones y el `€0M`
quedaba suelto abajo.

Con todo eso los bloques fijos bajaron a **162px**, así que a la mesa le quedan
682px en un iPhone 12 Pro — con 177px de sobra.

### Las tarjetas en mobile

Mercado, refuerzo, tutorial y creación de club entran sin scroll de página: si
el contenido no cabe, **scrollea la tarjeta**, nunca el fondo.

Cada una baja sus tamaños en dos escalones —≤700px y ≤420px— sin tocar la
estructura: título, texto, fichas de ítem, reglas del tutorial y botones.

**La pantalla del club** pasó a una grilla ordenada:

- el escudo y el nombre en la misma fila
- las cinco formas repartidas parejo con `flex:1`
- los colores en `grid-template-columns: repeat(9, 1fr)`, llenando el ancho

Antes los campos flotaban con `flex-wrap` y quedaban en filas desparejas de 4, 4
y 1, con huecos a la derecha.

> **Los corazones se cortaban de línea.** Con cuatro de aguante el último bajaba
> solo a un renglón nuevo y el bloque quedaba torcido al lado de la racha. Ahora
> los dos medidores comparten `flex-wrap: nowrap` y el mismo tamaño de ícono.

### Un solo sistema responsive

Todo el layout sale de **tres variables**:

```css
--gap     el aire entre bloques
--carta   el alto de cada carta
--cro     el diámetro del anillo del reloj
```

Y cinco breakpoints que solo cambian esas variables:

| Breakpoint | Carta | Gap | Reloj |
|---|---|---|---|
| ≤440px | `clamp(80, 13vh, 128)` | 5px | 50px |
| ≤1024px | `clamp(88, 14.5vh, 150)` | 7px | 58px |
| landscape bajo | `clamp(62, 19vh, 110)` | 5px | 44px |
| ≥1025px | `clamp(98, 15vh, 178)` | 10px | 78px |
| ≥1600px | `clamp(120, 17vh, 200)` | 10px | 92px |

**La carta se mide en `vh`**, así que se adapta al alto real de la ventana en vez
de depender solo del ancho. Verificado en nueve dispositivos:

| | Carta | Sobra |
|---|---|---|
| iPhone SE | 87px | 94px |
| iPhone 14 | 122px | 125px |
| Samsung S24 | 101px | 151px |
| iPad portrait | 150px | 349px |
| iPhone acostado | 74px | 9px |
| Portátil 1366×768 | 115px | 128px |
| Full HD | 184px | 164px |

> **Había veintiún media queries**, muchos duplicados, fijando alturas en píxeles
> para cada ancho. Se pisaban entre sí según el orden y el resultado dependía de
> cuál ganara: la mesa desbordaba, o las cartas quedaban en cero y desaparecían.
> Ahora son **doce**, y los cinco que importan solo tocan variables.

**Mobile y tablet portrait** van en una columna:

```
   RACING 2-1 DEP  ❤❤❤· ⚡⚡·· €25M      ╭────╮
                                         │ 70 │
                                         ╰────╯
   [🪑 +1❤] [📢 +1⚡]   [⚽ POSIBILIDAD]   [2 ATK][1 DEF]
   
   ── LA MESA ──
   
   C1  C2  C3  C4
   ▸ RELATO
```

La fila de acción lleva **tres bloques**: ítems a la izquierda, posibilidad de
gol centrada con `margin: 0 auto`, y ATK/DEF pegados a la derecha con
`margin-left: auto`. El reloj va arriba a la derecha, alineado al borde.

**El aguante, la racha y la plata suben a la barra del marcador.** El JS los
mueve ahí al arrancar y el CSS decide dónde se ven: en mobile dentro de la
barra, en desktop de vuelta en su panel con las etiquetas completas.

| | Alto |
|---|---|
| Barra con reloj | 66px |
| Fila de acción | 46px |
| Columnas, hint y relato plegado | 82px |
| **Fijo** | **230px** |

Con eso la mesa se queda con 437px en un iPhone SE y 614px en un iPhone 14.

**Acostado** la mesa ocupa la columna izquierda y los tres bloques se apilan en
una columna de 190px a la derecha.

**Acostado** la mesa pasa a la izquierda y los paneles a una columna de 190px a
la derecha: ahí sobra ancho y falta alto.

**Desktop** mantiene su grid de tres columnas; solo cambia el alto de la carta.

### Lo que hay que mirar, titila

Cuatro cosas laten cuando piden atención:

| Qué | Cuándo |
|---|---|
| ❤ **El último corazón** | queda 1 de aguante — el próximo golpe funde |
| ⚡ **Las columnas** | la racha llegó a 3 y se pueden usar |
| ⚽ **La posibilidad de gol** | la racha se llenó |
| ⏱ **El reloj** | las dos últimas jugadas (minutos 80 y 90) |

Los cuatro comparten **una sola animación**, `titilar`, a ritmos parecidos
(1,1 a 1,5s). Con animaciones distintas se leerían como cuatro avisos separados
compitiendo entre sí; con una sola, el jugador aprende que *lo que late es lo que
puede usar o lo que se está por acabar*.

Las columnas **dejan de latir al pasar por encima**: ya las estás mirando, el
aviso cumplió su función.

### El resaltado dice qué te hace cada carta

Al pasar por una fila o columna, cada carta se pinta según **lo que te hace**,
no todas del mismo color:

| Color | Qué significa | Ejemplos |
|---|---|---|
| 🟩 **Verde** | te suma | jugada clara, hinchada, taquilla, el duelo que **ganás** |
| 🟥 **Rojo** | juega el rival o te resta | **todas las que dicen RIVAL**, contraataque, calambre, el duelo que **perdés** |
| 🩵 **Celeste** | hay un **porcentaje de gol** en juego | penal, pase gol, tiro libre, córner |
| 🟨 **Amarillo** | se juega la **racha** en un empate | el empate del defensor o el medio |
| 🟧 **Naranja** | está en el aire y **puede costarte el marcador** | el empate del **delantero rival** |
| ⬜ Gris | no hace nada | offside |

El celeste y el amarillo eran un solo color. Los dos casos quedaban iguales
—«50% GOL» y un empate de duelo— cuando son decisiones distintas: uno es una
chance de convertir, el otro es la racha jugándose a cara o cruz. Ahora el
celeste marca el gol y el amarillo la racha.

Es **el mismo celeste de las fichas** (`--fi-luz`), así que la mesa y los
pop-ups hablan el mismo idioma.

**El cartel del empate dice MINI JUEGO y el nombre del que sale**:

```
   ┌────────────────┐
   │ 🎮 MINI JUEGO  │   ← pastilla dorada
   └────────────────┘
      MANO A MANO
    ⚽ GOL o -2 ❤
```

La etiqueta va en **pastilla dorada con el 🎮**: es el único aviso de que esa
carta no se resuelve sola, y en gris se perdía entre las otras dos líneas.

> **Las dos líneas salían pegadas** — `MINI JUEGODEFENDER` — porque el CSS de
> `.mj-lb` y `.mj` **nunca llegó a escribirse**. El HTML tenía las clases y el
> navegador las mostraba como texto corrido. Es el mismo fallo que ya pasó con
> el marcador de los pop-ups: el script que insertaba el CSS no encontró su
> ancla y falló en silencio.

La carta con mini juego lleva **una línea más que el resto**, así que va más
alta: 142px en desktop contra los 126px normales, y escala en los cuatro
breakpoints.

La etiqueta de arriba es lo que distingue a estas cartas de todas las demás: acá
**no se resuelve solo**, hay que elegir un lado. El nombre por sí solo —LA MARCA,
DEFENDER— no alcanzaba para saberlo.

es el mismo título que aparece al abrirse el pop-up:

| Carta | Cartel |
|---|---|
| DEFENSOR RIVAL | **UNO CONTRA UNO** · +1 ⚡ o -1 ❤ |
| ARQUERO RIVAL | **MANO A MANO** · ⚽ GOL o -2 ❤ |
| MEDIO RIVAL | **LA MARCA** · +1 ⚡ o -1 ❤ |
| DELANTERO RIVAL | **DEFENDER** · +2 ⚡ o ⚽ GOL RIVAL |

Es el mismo título que aparece al abrirse el pop-up, así las dos pantallas se
conectan: leés `MANO A MANO` en la carta y después se abre un mini juego que
dice `MANO A MANO`.

El número se sacó porque los cuatro son 50/50 **siempre**: una vez que aprendés
que mini juego = moneda al aire, la probabilidad es redundante. Lo que sí cambia
entre uno y otro es qué se juega, y eso está en la línea de abajo.

**En los empates el color dice quién puede marcar.** Los cuatro son 50/50, pero
no es lo mismo un 50/50 que te puede poner arriba en el marcador que uno que te
puede poner abajo:

| Empate | Color | Porque |
|---|---|---|
| **DELANTERO RIVAL** | 🟧 naranja | perderlo es **GOL DEL RIVAL** |
| ARQUERO · DEFENSOR · MEDIO, todos RIVAL | 🟨 amarillo | está en el aire |

> **El arquero estuvo en verde y se volvió atrás.** El argumento a favor era que
> ganarlo es GOL TUYO. El problema: en el resto de la mesa el verde significa
> **te suma, sin condiciones** —hinchada, jugada clara, un duelo ganado—, y ahí
> no hay nada que perder. El empate del arquero es una moneda al aire donde el
> lado malo cuesta **2 ❤**, el castigo más caro de todos los duelos.
>
> Un 50/50 no puede verse igual que una carta segura. El `⚽ GOL` sigue en
> verde **dentro del cartel**, que es donde corresponde: marca cuál es el buen
> resultado sin prometer que va a pasar.

El naranja `#e87414` queda entre el amarillo del riesgo común y el rojo de la
derrota segura, que es exactamente lo que significa: no perdiste todavía, pero
si perdés te cuesta el marcador.

Dentro del cartel, el **`⚽ GOL`** a favor va en verde con resplandor y el
**`⚽ GOL RIVAL`** en rojo: son los dos extremos de lo que puede pasar en esa
carta y tienen que saltar por encima del resto del texto.

**El color sale de `predict()`**, la misma función que colorea el cartel de la
carta. Por eso el resaltado nunca puede contradecir lo que dice el texto: si
el cartel dice `50/50` en dorado, el borde va dorado.

En los duelos eso significa que **el resaltado te dice cómo venís de stats**. Con
ATAQUE 3, un defensor de 2 se pinta verde, uno de 3 amarillo y uno de 4 rojo —
leés la fila entera de un vistazo sin comparar números.

El resaltado es **fino y tenue**: borde de 2px al 75% de opacidad y una sombra
suave. Con cuatro colores fuertes a la vez la mesa se volvía un semáforo y las
ilustraciones de las cartas quedaban tapadas.

Los botones se llaman **F1 a F4** y **C1 a C4**. Con nombres cortos el botón de
fila pasó de 78px a 52px, y ese ancho se lo lleva la mesa. En el relato, en
cambio, siguen escritos largos —*"te repetís en la fila 3"*— porque ahí son
frases, no etiquetas.

**Las cartas trabadas 🔒 quedan fuera del resaltado.** Mantienen su borde de
1px y su aspecto apagado aunque la fila esté encendida: pintarlas de verde o
rojo prometería un resultado que no va a pasar, porque no se pueden jugar.

### Lo apagado se atenúa, no se transparenta

El botón de una fila sin cartas libres usaba `opacity:.25`, que baja el bloque
entero —borde incluido— y la fila prácticamente desaparecía. El de columna, en
cambio, ya lo hacía bien: **texto y fondo tenues, marco intacto**.

Ahora los dos comparten el mismo tratamiento. La diferencia importa: con el
marco visible se entiende que la fila está ahí y que no se puede jugar; sin él,
parece que la interfaz se rompió.

> Hubo un intento de pintar de amarillo las de porcentaje en contra, con el
> argumento de que su resultado también está en el aire. Se revirtió: **que la
> pelota la tenga el rival es la información más importante de la carta**, y el
> amarillo la disimulaba. El riesgo es secundario frente a de quién es la jugada.

### Los cuatro mini juegos

| Mini juego | Pregunta | ✅ Ganado | ❌ Perdido |
|---|---|---|---|
| 🥅 **MANO A MANO** | ¿DÓNDE LA DEFINÍS? | ¡GOLAZO! | ATAJADÓN |
| 🧱 **UNO CONTRA UNO** | ¿POR DÓNDE LO ENCARÁS? | ¡LO PASÁS! | LA PERDISTE |
| 🌀 **LA MARCA** | ¿DE QUÉ LADO LO MARCÁS? | ¡SE LA ROBÁS! | TE PASÓ |
| 👟 **DEFENDER** | ¿PARA QUÉ LADO LO MARCÁS? | ¡LO CORTÁS! | SE VA SOLO |

Los dos de arriba y los dos de abajo funcionan al revés, y los textos lo
reflejan: en **MANO A MANO** y **UNO CONTRA UNO** la pelota es tuya y ganás
**esquivando** al rival —clavás o pasás—; en **LA MARCA** y **DEFENDER** la
pelota es de él y ganás **adivinando** dónde va —robás o cortás—.

### El que no entró

Cuando una carta de porcentaje no convierte, sale un cartel corto que se va
solo: el desenlace en grande y abajo lo que costó. Son **ocho cartas con
cuatro frases cada una**, sorteadas — 32 frases en total.

**El dibujo va con la frase, no con la carta.** Antes cada carta tenía un emoji
fijo: el PENAL mostraba siempre 🧤 y después sorteaba entre ATAJA EL ARQUERO,
SE VA AL PALO, LA MANDA AFUERA y AL TRAVESAÑO. En tres de los cuatro el arquero
ni la tocaba, así que **el dibujo contradecía al texto la mitad de las veces**.

Las 32 frases caen en diez desenlaces y cada frase se lleva el suyo:

| Desenlace | Frases que lo usan |
|---|---|
| **Atajada** | ataja el arquero · ataja tu arquero · ¡atajado! |
| **Descuelgue** | descuelga el arquero · descuelga tu arquero |
| **Al palo** | se va al palo |
| **Al travesaño** | al travesaño |
| **Afuera** | la manda afuera · la tira afuera · se va alto · la manda a las nubes · se va largo |
| **En la barrera** | en la barrera · en tu barrera |
| **Despeje** | despeja la defensa · despeja tu defensa |
| **Llega tarde** | llega tarde |
| **Le pega mal** | le pega mal |
| **Cabezazo** | cabezazo afuera |

Son animaciones SVG, no emoji, y eso resuelve tres cosas de una:

**Se miden en `em`**, así que heredan el `font-size` que el cartel ya tiene en
cada breakpoint —42px en mobile, 58 en desktop— y el responsive que ya andaba
sigue mandando sin una sola regla nueva de tamaño.

**Se dibujan con `currentColor`**, así que el cartel les presta su color: el
mismo dibujo sale rojo cuando el que erró fuiste vos y verde cuando erró el
rival. No hay dos versiones de nada.

**Corren una sola vez y quedan congeladas en el desenlace.** El cartel vive
2,5s y se va: una animación en loop lo convertiría en un gif colgado. Por eso
la coordenada que está escrita en el SVG es siempre **la que se lee bien
quieta** — AFUERA tiene la pelota pasada por arriba del arco y no adentro,
que detenida decía «gol»; y los tres botines (DESPEJE, LLEGA TARDE, LE PEGA
MAL) tienen la pelota en tres lugares distintos para que no queden idénticos
cuando frenan.

La regla común del dibujo: **la pelota va maciza y el decorado en línea**. El
ojo sigue a la pelota, y el arco, el guante o la barrera no le compiten.

### La pelota, y lo que pasa con ella

Los cuatro mini juegos y el penal son **por la pelota**, y la pelota no lo
contaba.

**En el penal**, la atajada terminaba con la pelota sobre el pecho del
arquero, como si lo hubiera atravesado. Ahora se centra en el **guante del
lado al que se tiró** —o contra el cuerpo si se quedó en el medio— y queda ahí,
un poco más chica por el impacto, con un anillo dorado que sale del guante y
el arquero sacudiéndose.

**En los duelos**, la pelota se iba siempre con el que la traía: un robo se
veía como que se quedaba con el que la había perdido. Ahora **termina con el
que gana**:

| | Ganás | Perdés |
|---|---|---|
| La pelota era tuya | la mantenés | te la sacan |
| La pelota era de él | se la robás | se le escapa |

Cuando cambia de dueño, cruza a los pies del que ganó y sale el anillo del
quite. Verificado en las cuatro combinaciones, ocho corridas seguidas.

**Y es la misma pelota en todos lados.** Antes cada escena dibujaba la suya y
no eran iguales; ahora sale de un solo `pelotaSVG()`: círculo, pentágono y
costuras, con el trazo del arco y de la cancha.

#### El `transform-box` de los SVG

Al centrar la pelota en el guante apareció un bug viejo: **en SVG, el
`transform-origin` por defecto es el (0,0) del viewBox, no el centro del
elemento.** Así que el `scale` de la atajada no achicaba la pelota en su
lugar: la corría hacia el ángulo superior izquierdo, y terminaba fuera del
arco. Lo mismo con el `rotate` del vuelo del arquero, que pivoteaba sobre el
origen y le desplazaba la figura entera.

Se arregla con `transform-box:fill-box; transform-origin:center`. Va en la
pelota, el arquero y los anillos — todo lo que escale o rote en SVG.

### Los mini juegos, cara a cara

Eran **dos emoji deslizándose sobre una franja rayada** y dos botones de
texto: el mismo problema que tenían los penales antes del arco dibujado.
Ahora es una escena de costado —los dos enfrentados, la pelota entre ellos— y
**se toca uno de los dos caminos**.

Lo que gana con esto no es solo estética. En dos de los cuatro duelos ganás
**esquivando** y en dos **adivinando**, según de quién sea la pelota, y esa
regla vivía nada más que en el texto de la pregunta:

| Duelo | La pelota es | Ganás |
|---|---|---|
| Mano a mano · arquero | tuya | esquivando |
| Uno contra uno · defensor | tuya | esquivando |
| La marca · medio | de él | adivinando |
| Defender · delantero | de él | adivinando |

**Ahora la pelota está dibujada a los pies del que la tiene**, así que se ve.
Verificado en los cuatro: la posición de la pelota coincide siempre con el
flag `adivinar`.

Mismo lenguaje que el arco de los penales: las dos zonas laten hasta que
elegís —con la esquina redondeada—, cada figura lleva **los colores de su
escudo** (vos los tuyos, el rival los suyos), y el rival sale primero para que
se vea el cruce. Si los dos van al mismo lado, salta el destello del choque.

**La pregunta va más grande.** Es la instrucción del momento —qué hay que
hacer— y estaba escrita al mismo cuerpo que un pie de foto, más chica que el
nombre del duelo. Pasó de 11px a 18px en desktop, 14 en mobile, y de gris a
blanco.

Las zonas de toque miden **97x109 px en un 390**. Entra sin scroll en
320x568, 360x640, 390x844 y 1440x900.

**Y arriba dice de qué carta salió.** El mini juego era el único pop-up de
acción sin el nombre de la carta en la cabecera: la regla `.sit.mam .sit-tag`
existía desde el rebranding, pero el markup nunca la usaba. El nombre aparecía
solo de costado, a 10px y mezclado con un número —«⚔ ATAQUE 5 vs ARQUERO RIVAL
3»—, así que la carta que tocaste en la mesa y el pop-up que se abre no se
leían como la misma cosa.

Ahora el orden es el de todos los demás:

```
┌───────────────────────────┐
│  [ la foto de la carta ]  │
│      ARQUERO RIVAL        │  ← de qué carta salió
│  ⚔ ATAQUE 5  vs  RIVAL 3  │  ← cuánto pega cada uno
│      MANO A MANO          │  ← qué mini juego es
└───────────────────────────┘
```

Y con el nombre arriba, el marcador dejó de nombrar: repetía «ARQUERO RIVAL»
diez píxeles más abajo. Abajo va solo la fuerza, que es lo único que el
marcador tiene que decir — y como los cuatro rivales terminan en «RIVAL», la
palabra sola alcanza.

### Los penales, con arco de verdad

Eran **dos emoji moviéndose adentro de una caja con borde**: un guante y una
pelota. Ahora el arco se dibuja —palos, travesaño, red y línea del área— y
**se apunta tocando adentro**, no con tres botones de flecha.

Tres cosas lo sostienen:

**Las zonas laten.** Un arco dibujado sin nada más se lee como decoración; el
latido escalonado en celeste dice que hay que tocarlo. Se apagan al disparar.

**El arquero lleva los colores del equipo que ataja** — camiseta y guantes
salen del escudo. El del rival cuando pateás vos, el tuyo cuando atajás. Y se
balancea mientras decidís, para que no parezca una estatua esperando: al
disparar se corta el vaivén y vuela al palo que adivinó, **antes** que salga
la pelota, así se ve el duelo.

**La pelota está dibujada con el mismo trazo** que el arco —círculo, pentágono
y costuras— en vez del emoji, que era el único elemento con otro estilo.

Las zonas de toque miden **56x82 px en un 390 y 52x76 en un 360**, bastante
por encima de lo cómodo: era el riesgo de cambiar botones por zonas.

#### Un solo arco para los tres lugares

Los penales aparecen en tres lados: la **tanda de la final** (y del partido
único), el **penal definitorio** de una ronda de paso, y la **serie del menú**.
La tanda y la serie ya compartían `penalUno`, pero el definitorio tenía su
propio dibujo y sus propios botones con nombre. Ahora los tres usan
`arcoPenalHTML` y `animarPenal`.

La probabilidad no cambió: sigue siendo azar puro entre tres palos, **2 de
cada 3 convertidos** (verificado con 6000 tiros simulados: 66,7%).

#### La pizarra de la tanda

El marcador era una línea de ⚽ y ✖ de 13px con **solo los tiros ya**
**pateados**: no se veía cuántos quedaban, que en una tanda es la mitad de la
información — «le queda uno y va perdiendo» es todo el drama.

Ahora van los **cinco huecos de cada equipo desde el primer tiro**: verde el
que entró, rojo el que erró, vacío el que falta, y el que se está por patear
late en dorado. La fila del que patea se enciende.

**Los dos tiros jugados se pintan.** El gol era un círculo lleno de verde y el
fallo un círculo **vacío** con una rayita roja al borde, así que de lejos el
fallo se parecía más a un tiro que todavía no se pateó que a uno errado. Ahora
los dos se pintan enteros y **los huecos son solo los que faltan**, que es la
lectura que la pizarra tiene que dar de un vistazo.

La rayita se queda, pero pasa a ser **oscura sobre el rojo**: es la única
diferencia que no depende del color, y sin ella un daltonismo rojo-verde deja
la tanda ilegible.

**Y las dos hileras caen una debajo de la otra.** Cada fila es su propia
grilla, así que la columna `auto` del nombre la medía cada equipo por su
cuenta: con BOCA arriba y RIVER abajo los círculos arrancaban en x distintos y
las dos hileras quedaban corridas. La columna del club pasa a **ancho fijo**
—11ch, 8ch en mobile— y con eso miden igual pase lo que pase.

El `▸` del turno tiene ahora su **lugar reservado siempre**, encendido o
apagado. Iba adentro del texto del club y aparecía y desaparecía en cada tiro,
así que movía el nombre de un lado al otro; con el ancho fijo además le habría
comido una letra. Verificado con nombres cortos y largos en 320, 900 y 1366:
los círculos de los dos equipos arrancan en el **mismo píxel** en los tres.

### La pantalla del club, en vitrina

Era un formulario: el escudo chico a la izquierda y a la derecha una lista con
cinco formas y **dos filas de nueve colores** — dieciocho botones a la vez, de
26px. Es el único momento en que el jugador crea algo suyo y se veía como un
trámite.

Ahora el escudo va **al centro y grande, sobre una peana con luz**. Debajo, la
tira de formas con cada silueta dibujada **en los colores elegidos** —te ves a
vos mismo en cinco siluetas— y una sola fila de nueve con un interruptor de
**COLOR 1 / COLOR 2**: la mitad de botones en pantalla y cada uno de 34px.

Todo centrado. En una columna sola, alinear a la izquierda dejaba los rótulos
colgando de un lado y el escudo en el otro.

#### Fuera la letra del escudo

El escudo llevaba la inicial del club en el medio. Se sacó: se lee por su
**forma y sus dos colores**, y la inicial competía justo con las formas que
traen franja —el banderín y el inglés la partían al medio—. El nombre del club
ya está al lado en todos los lugares donde aparece el escudo.

Se sacó del dibujante (`escudoSVG`), así que vale también para la marquesina,
los marcadores y la pantalla del 1 vs 1.

#### El alto, en cuatro escalones

La columna única es más alta que las dos columnas de antes, así que hubo que
escalonarla. El escudo se mide contra `vh`: es lo que más ocupa, y cede él
antes que los controles.

| Pantalla | Escudo |
|---|---|
| Normal | 180px |
| Desktop ≤800px de alto | 17vh (150 máx) |
| Desktop ≤660px | 15vh |
| Mobile ≤620px | 19vh (120 máx) |

Y el tope de la tarjeta pasó a medirse contra el hueco real del overlay
(`max-height:100%`) en vez de `calc(100vh - 72px)`, que se quedaba corto
frente a los 76px que reserva el padding. Va con las dos clases
—`.card.card-club`— porque `.card` vuelve a declararlo más adelante con la
misma especificidad y ganaba él.

Verificado en 320x568, 360x640, 390x844, 1024x640, 1280x700, 1366x768 y
1440x900: la tarjeta entra entera, sin scroll propio ni del fondo.

### Cuando se te funde el equipo

Quedarte sin aguante es el **único castigo permanente** del juego: perdés un
corazón de máximo para todo lo que queda del campeonato. Hasta ahora eso
pasaba en una línea de relato, y la llegada del rival aparecía ya sorteada,
sin decir de dónde salía ni qué otras podían tocarle.

Ahora tiene cartel, y junta las dos cosas:

**Lo que perdiste** — los corazones que te quedan, con el que se fue tachado.
Si el máximo ya está en el piso, el cartel lo dice en vez de mentir.

**Lo que viene** — las cinco cartas del rival, con el mismo cursor de sorteo
que usa la ficha de la racha llena, en rojo. **El sorteo arranca con el botón,
no con el cartel**: antes corría solo apenas aparecía y, para cuando terminabas
de leer que te habías fundido, el cursor ya había pasado por las cinco y
frenado. Ahora leés lo que perdiste, mirás las cinco, y recién cuando tocás
A VER QUÉ PASA sale el sorteo — el mismo gesto que del lado tuyo, donde el
cursor arranca al tocar USAR LA RACHA y no al abrir la ficha.

La carta que se juega es **esa misma** (`yaElegida`), no un segundo sorteo a
espaldas del jugador.

#### Los dos lados juegan el mismo mazo

`SIT_RIVAL` tenía **cuatro** cartas —sin la jugada clara— y con pesos
desparejos: 2/3/3/3, así que el penal salía el 18% de las veces y las otras
tres el 27% cada una.

| | Antes | Ahora |
|---|---|---|
| Cartas del rival | 4 | 5 |
| Pesos | 2 / 3 / 3 / 3 | 1 / 1 / 1 / 1 / 1 |
| Gol esperado | 38% | **51%** |
| Peor caso para vos | penal al 50% | jugada clara, **entra sin sorteo** |

Los dos lados son ahora el mismo mazo, con los mismos porcentajes y la misma
chance de salir. Es más justo de leer —el cartel del rival muestra exactamente
las mismas cinco cartas que el tuyo— pero **sube la dificultad**: cada vez que
te fundís, el rival pasa de 38% a 51% de convertir, y una de cada cinco veces
le toca la JUGADA CLARA, que no tiene salvada posible.

Si el juego queda demasiado duro, la palanca es `peso` en `SIT_RIVAL`: bajarle
el peso a `jugada` lo suaviza sin volver a desalinear las cartas.

#### El arte del rival está pendiente

Las cinco casillas usan por ahora el arte del lado tuyo. Del lado del rival la
camiseta tendría que ser blanca, y hoy `penalC` y `libreC` son alias de las
tuyas, `pasegolC` no tiene imagen y solo `cornerC` tiene arte propio. En la
mesa se disimula porque las cartas están lejos; **juntas en un cartel se
nota**. Se cambia cuando estén las imágenes.

### La ficha de posibilidad de gol

Las cinco casillas mostraban un emoji y un porcentaje. Midiéndola apareció el
problema de fondo: en desktop **cada casilla mide 157x47 px y adentro había un
emoji de 16 y un porcentaje de 9**. Sobraba lugar, y faltaba el dato más
básico — de qué jugada era ese porcentaje. Había que saberse de memoria que 🚩
es el córner y 🚧 el tiro libre.

Ahora cada casilla lleva **la ilustración de su propia carta**, la misma que
sale en la mesa, con el nombre debajo. No hay íconos nuevos que aprender: la
reconocés porque ya la viste salir.

| | Antes | Ahora |
|---|---|---|
| Ficha desktop | 836 x 147 | 836 x 213 |
| Ficha mobile | 380 x 132 | 380 x 172 |
| Casilla desktop | 157 x 47 | 157 x 115 |
| Contenido | emoji + % | foto + nombre + % |

Dos cosas más que se arreglaron de paso:

**La chapa del mini juego** era un 🎮 de 8px flotando en el borde de la
casilla. Pasa a ser la misma chapa dorada que llevan las cartas del tablero,
apoyada sobre la foto.

**Las cinco pesan igual** —una de cada cinco— y la ficha nunca lo decía, así
que se leía que la JUGADA CLARA era la rara. Ahora lo aclara al lado del
porcentaje esperado.

La foto va contra `vh` como en los avisos, para que en una pantalla baja ceda
ella antes que el resto de la ficha.

### Los dos avisos de racha llena

**RACHA LLENA** y **TIEMPO DE DESCUENTO** son el mismo momento contado dos
veces —se te llenaron los cuatro rayos—, y hasta ahora se anunciaban con un
emoji de 50px sobre azul liso. Ninguno mostraba la racha que acabás de llenar,
ni la ilustración que el juego ya tenía guardada para eso: la carta **RACHA
FULL** (`noche` en el mazo), que no aparecía en ningún otro lado.

Los dos pasan al molde del pop-up del mini juego: **la foto a sangre como
cabecera, con el título encima del degradado**, y abajo los cuatro rayos
encendidos. No estrena un lenguaje nuevo — es el mismo que el jugador ya vio
cuando le tocó un empate de duelo.

Los rayos son los mismos del medidor del panel, misma imagen y mismo orden,
porque es ahí donde los vio llenarse: repetirlos en el cartel cierra el
círculo. Laten escalonados, 90ms entre uno y otro.

**La foto se sale del cartel con `--apx`**, que es el mismo padding que el
aviso entra por los costados. Así no hay números que mantener a mano cuando el
padding cambia de breakpoint.

**Y el alto va contra `vh`** —`clamp(96px, 16vh, 170px)`— porque el cartel del
descuento ya venía siendo el más largo de los avisos: trae marcador y dos
opciones. Con una foto de alto fijo, en un 360x640 se pasaba 36px del hueco
que deja el overlay, y como `.sit-flash` centra sin scrollear, lo que sobra no
se corta: queda fuera de alcance. En desktop no pasaba porque ahí el aviso ya
tenía su `max-height:88vh`.

Ahora hay tope de alto también en mobile —la red de contención— y una
compactación por alto de pantalla que hace que no haga falta usarla.
Verificado en 320x568, 360x640, 390x844 y 1280x700: los dos entran enteros,
sin scroll.

### Los mismos dibujos en los siete carteles

Lo que arrancó en el tiro errado se extendió a **todos los carteles que
cierran una jugada**: el mini juego, la situación de gol, el penal pateado, el
penal de la ronda, el resumen de la tanda y el sorteo de la moneda. Con seis
dibujos más —gol, gambeta, quite, copa y las dos caras de la moneda— son
**dieciséis para todo el juego**, y ningún cartel de desenlace usa ya un emoji.

| Cartel | Desenlaces que usa |
|---|---|
| Mini juego | gol · atajada · gambeta · quite |
| Situación de gol | gol · afuera · atajada |
| Penal pateado | gol · atajada |
| Penal de la ronda | gol · atajada |
| Resumen de la tanda | copa |
| Sorteo de la moneda | cara · seca |

**GAMBETA y QUITE cubren los ocho finales del mini juego entre los dos.** Son
los dos finales posibles de cualquier uno contra uno: la pelota pasa o se
queda. Cuál te conviene depende de quién la tenía —la regla `adivinar`— y eso
ya lo dice el color. Dibujar «lo pasás» y «te pasó» por separado sería dibujar
dos veces lo mismo.

En estos carteles el color del desenlace vive en el **título**, no en la caja,
así que el dibujo salía blanco al lado de un «¡TE SALVASTE!» verde. Se pasó el
color a la caja: no pisa nada —el rótulo, el marcador y la chapa ya tienen el
suyo— y el único que lo hereda es el dibujo.

### El dibujo, la chapa y los tres segundos

**El dibujo va más grande.** 42px era el tamaño heredado del emoji, que a ese
cuerpo ya dice todo con la cara; una escena con pelota, arco y guante necesita
más lugar. Pasó a 58px en mobile y 80 en desktop, y como se mide en `em`
alcanzó con mover el `font-size` del contenedor.

**Lo que costó la jugada salió del renglón gris.** El aguante que perdés o la
racha que ganás estaba escrito más chico que todo lo demás, al final de una
línea tenue — y es el dato por el que mirás el cartel. Ahora va en su propia
chapa (`.ef-fin`), centrada y al doble de cuerpo.

**Y el cartel dura lo que dura el dibujo.** Tres vueltas de 1,15s son 3,45s, y
el cartel vive 3,5s (`ESPERA_FIN`). Con los 2,5s de antes se cortaba a mitad de
la segunda vuelta. Se saltea con un toque, como todos — incluido el penal de la
ronda, que antes esperaba con un `wait` y no se podía apurar.

### El color se lee desde tu lado

En los cinco carteles de desenlace del juego el color no cuenta lo que pasó en
la cancha sino **cómo te afecta**: verde lo que te conviene, rojo lo que no.
Por eso una pelota que no entra sale roja si era tuya y verde si era del rival,
y es la misma regla que usan el latido de los medidores y el borde de las
cartas resueltas.

Había una sola excepción: **gastar la racha llena y errar la situación de gol**
salía en gris. El argumento era que ahí no perdés aguante. Se corrigió a rojo:
te comiste la racha entera y una jugada, es el peor resultado posible de esa
decisión, y el gris lo contaba como si no hubiera pasado nada.

### La jugada se ve, no solo se lee

**En el penal:**

| Momento | Qué pasa |
|---|---|
| El tiro | la pelota **gira 380°** y se achica al alejarse — da la profundidad hacia el arco |
| El vuelo | el arquero se **inclina 28°** hacia su palo |
| ⚽ Gol | la **red se infla** en verde, justo en el palo donde entró |
| 🧤 Atajada | la pelota **frena en la mano**, sale un anillo dorado y el guante tiembla |

**En el mini juego:**

| Momento | Qué pasa |
|---|---|
| El cruce | las dos figuras van a su lado, con 300ms de diferencia |
| Ganás | tu figura **crece** y la del rival se apaga en gris |
| Perdés | al revés |
| Los dos al mismo lado | salta el **destello del choque** |

Antes las figuras llegaban a su lado y se quedaban quietas: había que esperar el
texto para saber quién ganó. Ahora el resultado se ve en la cancha y el texto
solo lo confirma.

> Las reglas de la pelota y el guante **se habían perdido** al reescribir el
> bloque del mini juego, así que las dos figuras aparecían pero no se movían.

### Los íconos dicen quién tiene la pelota

| Mini juego | Vos | El rival |
|---|---|---|
| MANO A MANO *(atacás)* | ⚽ | 🧤 |
| UNO CONTRA UNO *(atacás)* | ⚽ | **👟** |
| LA MARCA *(defendés)* | **👟** | ⚽ |
| DEFENDER *(defendés)* | **👟** | ⚽ |

Tres figuras, cada una con su papel: **⚽ el que lleva la pelota**, **👟 el que
marca** y **🧤 el arquero**.

> El que marca llevaba un **escudo** 🛡, que es un símbolo abstracto de defensa:
> en la cancha lo que hace un marcador es **meter la pierna**. Aparecía en dos
> mini juegos —como el rival en UNO CONTRA UNO y como vos en LA MARCA.
>
> Y en **DEFENDER** tu figura era el **guante**: ahí te cruzás como defensor
> contra el delantero rival, no lo atajás. El arquero recién aparecería si el
> delantero te pasa, que es justamente lo que pasa cuando perdés. Ahora el
> guante queda **solo en MANO A MANO**, donde hay un arquero de verdad.

**La pelota la tiene el que ataca.** Antes era tuya en los cuatro, incluso
cuando estabas defendiendo: en `DEFENDER` aparecía tu pelota corriendo hacia el
arquero rival, que es lo contrario de lo que pasa.

Ahora la escena se lee sola: si ves la pelota abajo, atacás; si la ves arriba,
te están atacando.

### El mini juego, más grande

| | Antes | Ahora |
|---|---|---|
| Ancho del cartel | 380px | **420px** |
| Alto de la cancha | 74px | **104px** |
| Figura tuya | 22px | **34px** |
| Figura del rival | 30px | **40px** |

**El penal comparte las mismas reglas** —`.sit.mam, .sit.penal`— así que el arco
creció igual y los dos usan los mismos botones: azul profundo con filo del color
de la carta, radio de 8px y tipografía de títulos, como las opciones del menú.

### El mini juego habla como su carta

El pop-up del duelo toma **el mismo tono que la carta de la que salió**:

| Duelo | Borde |
|---|---|
| MANO A MANO *(arquero)* | 🟩 verde |
| DEFENDER *(delantero)* | 🟧 naranja |
| UNO CONTRA UNO · LA MARCA | 🟨 dorado |

Y lleva **la ilustración de esa carta** como cabecera, con el degradado al pie
que ya usan los otros pop-ups. El cartel que leíste en la mesa y el que se
abre son visiblemente la misma cosa.

Arriba va el marcador del duelo con los colores de la mesa:

```
   ⚔ ATAQUE 3   vs   ARQUERO 3
```

Rojo el ataque, azul la defensa, blanco el número del rival — los mismos que usa
el panel del equipo.

**La cancha del mini juego pasó de verde césped a azul.** Era lo último que
quedaba de la paleta anterior: un rectángulo verde en medio de una interfaz azul
que ya no tenía nada más de ese color. Ahora usa las mismas franjas azules del
resto, con una línea al medio para que se lea como media cancha.

Los botones toman el tono del duelo al pasar por encima, igual que las cartas
en la mesa.

### Cartas y mesa

El juego se llama a sí mismo con el vocabulario que le corresponde: lo que se
elige son **cartas** y donde están es la **mesa de juego**. Antes eran «casillas»
y «tablero», que sonaban a juego de tablero clásico y no a lo que esto es.

El cambio tocó **263 menciones en el código** y **368 en la documentación**. Los
identificadores internos —`#board`, `.board-zona`, `.board-hint`— quedaron como
estaban: renombrarlos no cambia nada para el jugador y sí rompería el CSS.

### La posibilidad de gol tiene cinco cartas

Al llenar la racha sale una de estas:

| Carta | Chance | Sale |
|---|---|---|
| ⚽ **JUGADA CLARA** | **100%** | 8% |
| 🎯 PENAL | *lo pateás vos* | 17% |
| 🤝 PASE GOL | 40% | 25% |
| 🚩 CÓRNER | 35% | 25% |
| 🚧 TIRO LIBRE | 30% | 25% |

La **jugada clara** entra sola: es el premio grande de llenar la racha y con peso
1 sale una de cada doce veces. Sube el gol esperado de **38% a 43%**.

Y el **PENAL se juega**: abre el mismo mini juego de la tanda —elegís palo, el
arquero vuela— con la misma probabilidad que tenía la tirada al azar (2 de 3).
No cambia el balance; cambia que ahora lo jugás.

### Los íconos, al doble

Tres tamaños, de mayor a menor, y siempre en ese orden:

| | Desktop | Mobile | Mínimo |
|---|---|---|---|
| **Título** *(PENAL)* | 14px | 12,5px | 10px |
| **Resultado** *(50% GOL)* | 13,5px | 12px | 10px |
| **Efecto** *(+1 ⚡ o -1 ❤)* | 12,5px | 11px | 9,5px |

> **Estaba invertida.** El efecto medía 13px y el resultado 11,5px, así que la
> línea de abajo pesaba más que la de arriba y el cartel se leía al revés de su
> jerarquía. Pasaba en los cinco breakpoints.

El resultado va en la tipografía de títulos con peso 800, el efecto en la de
texto con 600: además del tamaño, la familia los separa.

> **Cuatro lugares donde el rayo mostraba código.** Al reemplazar los 44 emojis
> por la etiqueta `<i class="ir">`, algunos quedaron en contextos donde el HTML
> no se interpreta:
>
> | Dónde | Por qué | Solución |
> |---|---|---|
> | `⚡ LISTA` de la racha | dentro de un `content:` de CSS | imagen de fondo en un pseudo-elemento |
> | Botones de columna | asignados con `textContent` | `innerHTML` |
> | Bajada del banner de gol | ídem | `innerHTML` |
> | Botón `USAR` del banner | ídem | `innerHTML` |
>
> `textContent` **escapa** el markup y lo muestra literal; `innerHTML` lo
> interpreta. Es el precio de reemplazar un emoji —que es texto— por una
> etiqueta: hay que revisar cómo se inserta cada uno.

### Los íconos, al doble

| | Antes | Ahora |
|---|---|---|
| Medidor ❤ / ⚡ | 19px | **34px** |
| El ícono dentro del texto | 1,06em | **1,7em** |
| Texto del efecto (`-2 ❤`) | 10,4px | **13px** |

El aguante y la racha son lo que más se mira durante el partido, y a 19px había
que buscarlos. Y en un cartel como `-2 ❤` el número dice **cuánto** pero el
ícono dice **de qué**: el ícono tiene que reconocerse primero.

Escala en los cinco breakpoints —40px en large desktop, 23px en el más chico—
y el cartel sigue entrando en la carta: el caso más ajustado es el mínimo de
96px, que queda con 6px libres.

### Los dos medidores, con imagen propia

El **❤ del aguante** —un corazón con una pelota adentro— y el **⚡ de la racha**
—un rayo con filamentos eléctricos— son imágenes, y aparecen **en todo el
juego**: los del medidor, los carteles de las cartas (`-2 ❤`, `+1 ⚡`), los
ítems, el tutorial y el panel del 1v1. Son **79 apariciones** en total.

Se resuelve con una clase CSS, no tocando los 35 textos uno por uno:

```css
.ih,.ir{ display:inline-block; width:1.06em; height:1.06em;
         vertical-align:-.18em; background:center/contain no-repeat }
.ih{ background-image:var(--ico-aguante) }
.ir{ background-image:var(--ico-racha); width:.92em; height:1.14em }
```

El rayo va un poco más angosto y más alto que el corazón: es su proporción real,
y sin eso se veía más chico al lado.

La imagen se expone como variable CSS al arrancar, igual que el fondo de cancha.
Ocupa lo mismo que ocupaba el emoji y se alinea con la línea de base, así ningún
cartel cambió de alto.

> Van embebidos a **96px**, que es lo que pide mostrarlos a 34px en pantallas
> retina: **6,2 KB** el corazón y **3,9 KB** el rayo.
>
> El rayo tiene **contorno negro**, y eso simplificó su recorte: se detecta el
> amarillo y el negro, se rellenan los huecos del interior y se descarta todo lo
> que no sea la mancha más grande. Sale limpio sin ajustar umbrales a mano.
>
> Su proporción es **0,66** de ancho sobre alto, bastante más angosta que el
> corazón, así que lleva medidas propias (`1.22em × 1.85em` en los textos, 26px
> en el medidor). Con las del corazón quedaba con aire a los costados y se veía
> más chico de lo que es.
>
> **La pelota del corazón se veía sucia**, y no era la foto: el filtro que
> descartaba el beige del chat también atrapaba el gris neutro de la pelota, y
> el desenfoque de la máscara le comía el brillo del borde. Se resolvió
> **protegiendo el área de la pelota** antes de aplicar el filtro y bajando el
> desenfoque de 0,9 a 0,5.
>
> Recortarlos del fondo de WhatsApp necesitó dos técnicas distintas: el corazón
> por **silueta dibujada a mano**, porque el beige del chat se parecía al blanco
> de la pelota; el rayo por **saturación**, porque el fondo daba `R-B≈72` y el
> rayo `R-B>96`. Solo con color, el corazón dejaba restos; solo con silueta, el
> rayo perdía los filamentos.

### Imágenes compartidas

Una clave de `ART` puede ser **alias de otra**:

```js
cornerC: '@corner'
```

`ARTSRC` lo resuelve al leerlo, así que el córner del rival usa la misma imagen
que el propio sin repetir sus 8 KB de base64. Sirve para las jugadas que son la
misma vista desde el otro lado — el tiro libre, el penal, la pelota entrando al
arco.

Con 28 cartas y un archivo que tiene que seguir siendo portable, cada imagen
que no se duplica cuenta.

### El cartel de gol

```
   ┌────────────────────────────────┐
   │            ¡GOL!               │   ← 50px, verde
   │  ─────────────────────────     │
   │  RACING   2 - 1   DEP. BARRIAL │   ← 56px
   └────────────────────────────────┘
```

**El marcador es lo más grande del cartel.** Acabás de convertir —o te
convirtieron— y lo que querés saber es cómo va el partido. Pasó de 26px a
**56px**, con los dos nombres a los costados como en la marquesina: vos a la
izquierda, el rival a la derecha.

El equipo que acaba de marcar **se enciende**: verde si fuiste vos, rojo si fue
él. Así el cartel dice quién convirtió sin depender solo del título.

Funciona en los dos modos —en el 1v1 toma los nombres de los dos jugadores— y
los nombres largos se recortan con puntos suspensivos en vez de romper el
marcador.

### Los carteles de situación

Tipografía sobre el azul del juego, con el filo del color que corresponde:

```
   ┌──────────────────┐
   │     A FAVOR      │
   │      ¡GOL!       │   ← verde
   │      2 - 1       │
   └──────────────────┘
```

**Verde lo que te suma, rojo lo que te resta**, y eso incluye los cruces:

| Situación | Color |
|---|---|
| Gol tuyo | 🟩 verde |
| Gol del rival | 🟥 rojo |
| **El rival erra la suya** | 🟩 **verde** |
| **Errás una tuya** | 🟥 **rojo** |

> **La ilustración del gol se sacó.** Ocupaba el cartel entero y tapaba el
> marcador, que es el dato que importa en ese momento: acabás de convertir y
> querés ver cómo va el partido. También ahorra 46 KB del archivo.

Estos carteles **se van solos a los 2,5 segundos**: informan un resultado corto
—entró o no entró— y cortarlos con un toque rompía el ritmo del partido. Los que
siguen esperando el click son los que traen una decisión o un dato largo: la
tanda de penales, el sorteo y el resumen final.

### Tiempo o toque, lo que pase primero

Todos los carteles duran un tiempo y **se pueden adelantar con un toque**:

| Cartel | Dura |
|---|---|
| ⚽ **GOL** y **GOL RIVAL** | **3,0s** |
| Chance errada · mini juego · situación | 2,5s |
| Sorteo de la moneda · penal de la tanda | 2,6s |
| Resumen de la tanda | 3,2s |

El tiempo asegura que el cartel se llegue a leer; el toque deja seguir al que ya
lo leyó. Es mejor que cualquiera de los dos comportamientos por separado: solo
tiempo obliga a esperar de más, y solo click frena el partido en cada jugada.

El gol dura más que el resto porque es el momento del partido — y ahora muestra
el marcador, que es lo que uno quiere ver justo ahí.

> **El cartel se apagaba antes de tiempo.** La animación de entrada `golpop`
> también hacía el desvanecido —terminaba en `opacity:0`— con una duración fija
> de 1,5 segundos. Cuando el cartel pasó a durar 3s, se apagaba a la mitad y
> quedaba **la pantalla gris sin nada encima** hasta que el JS lo sacaba.
>
> Ahora la animación **solo entra** (0,42s) y el desvanecido va aparte, en una
> clase `.saliendo` que el JS agrega justo antes de sacar el cartel. La duración
> la decide el JS, no el CSS, así que las dos no se pueden desincronizar.

> El click se habilita **200ms después** de que aparece el cartel. Sin ese
> respiro, el mismo toque con el que resolviste la jugada anterior lo cerraba
> antes de que lo vieras.
>
> Y el juego **espera a que el cartel de gol se cierre** antes de seguir, en vez
> de a un tiempo fijo. Si no, al adelantarlo con un toque el partido seguía
> corriendo por debajo.

### Un solo lenguaje, del menú a los pop-ups

Los botones y los títulos de todas las pantallas hablan igual que el menú:

| | Antes | Ahora |
|---|---|---|
| Botón principal | verde macizo, sin borde | **azul profundo con filo dorado** |
| Botón secundario | gris plano | mismo molde, borde tenue |
| `<em>` del título | verde | **dorado**, como en el logo |
| Etiqueta de sección | gris | **dorada** |

El verde era el color del botón principal en todas las tarjetas, y **no aparecía
en ningún otro lado del juego** — ni en el logo, ni en el menú, ni en la mesa. El
dorado sí: es el filo de las cartas del logo y el acento de `FUTBOLERO`.

El verde y el rojo quedan reservados para lo que **significan** algo: el gol
propio, el gol del rival, un duelo ganado o perdido. Usarlos también como color
de botón les sacaba fuerza justo donde importan.

### Un solo lenguaje para todos los pop-ups

Los cinco tipos de cartel —jugada, gol, situación, aviso y tarjeta— comparten
**fondo, radio y desenfoque** con las cartas de la mesa:

```css
.gf, .sit, .aviso, .play, .card{
  background: linear-gradient(160deg, rgba(0,22,72,.96), rgba(0,8,31,.97));
  backdrop-filter: blur(10px);
  border-radius: 9px;
}
```

Lo único que cambia entre uno y otro es **el color del borde**, que dice de qué
se trata: verde el gol propio, rojo el del rival, dorado el aviso de racha.
Antes cada uno traía su propio degradado y su propio radio, y el juego parecía
cinco interfaces distintas.

La tipografía también se unificó: la etiqueta de arriba, el título y el pie usan
la misma escala en los cinco, solo que más grande que en la carta.

**El pop-up de jugada muestra la ilustración de su carta**, apaisada y con un
degradado al pie para que el nombre se lea encima. Si esa carta todavía no
tiene arte, cae al emoji sin que se note el hueco.

### El fondo del juego

Una foto aérea de estadio, embebida en WEBP (39 KB), **con blur mínimo** —1,4px—
para que se reconozca el lugar sin competirle al texto.

La foto es diurna y clara, así que antes de embeberla se la trata: brillo al
66%, saturación al 72% y un **tinte azul** de la paleta. Sin eso, el césped verde
y el cielo celeste pelean con la interfaz azul y blanca.

Encima va un velo radial que **abre al centro y cierra en los bordes**: al medio
se ve el estadio, en los extremos el azul cierra la composición.

Y los elementos que van encima ganaron **fondo propio y `backdrop-filter`**:

| Elemento | Opacidad | Desenfoque |
|---|---|---|
| Paneles | 93-95% | 10px |
| Marquesina | 95-96% | 8px |
| Cartas | 95-96% | 6px |

Sin ese tratamiento, el texto de las cartas quedaba sobre las tribunas de la
foto y se volvía ilegible. El desenfoque de fondo es lo que permite subir el
brillo de la foto sin perder contraste.

### En mobile los paneles van arriba

Debajo del marcador y **antes** de la mesa:

```
      MARCADOR + reloj
   ┌──────────┬─────────┐
   │ TU EQUIPO│ PLANTEL │   ← el estado, en una fila
   ├──────────┼─────────┤
   │  ÍTEMS   │ POSIB.  │   ← lo que se usa, en otra
   │          │ DE GOL  │
   ├──────────┴─────────┤
   │      MESA       │
   ├────────────────────┤
   │      RELATO        │   ← al final
   └────────────────────┘
```

Quedan **dos filas de a dos** antes de la mesa: arriba lo que se mira (estado y
plantel), abajo lo que se usa (ítems y la posibilidad de gol). El banner de gol
vivía dentro de la columna central, arriba de la mesa; en mobile sube a
compartir fila con los ítems porque los dos son cosas que se deciden **antes** de
elegir la fila.

El **reloj crece a `clamp(88px, 25vw, 118px)`**: en el celular es la referencia
más mirada del partido y a 80px fijos quedaba perdido en la esquina del banner.

Abajo de la mesa quedaban fuera de vista: había que scrollear para saber con
cuánto aguante venías, y eso es justo lo que se mira **antes** de elegir la fila.

Los ÍTEMS van a ancho completo y no en la fila de arriba, porque son botones y
necesitan área para tocar. El **relato baja al final**: es lo único que se lee
después de la jugada, no antes.

> Se resuelve con `display:contents` sobre los dos `.lado` **y sobre `.centro`**,
> que los disuelve y deja todos los bloques como hijos directos del mismo flex.
> Sin eso, ÍTEMS quedaba atado a la columna izquierda junto con el relato, y el
> banner de gol atado a la central junto con la mesa — no había forma de
> emparejarlos.

### Responsive: siete escalones

| Ancho | Layout | Carta |
|---|---|---|
| **≥1900** | tres columnas, tope 1700px | 160px |
| **≥1600** | tres columnas anchas | 150px |
| 1301-1599 | tres columnas (por defecto) | 126px |
| **1025-1300** | tres columnas apretadas · *tablet landscape* | 126px |
| **≤1024** | mesa arriba, paneles abajo en dos · *tablet portrait* | 132px |
| **≤700** | una sola columna · *mobile* | 118px |
| **≤440** | compacto | 106px |
| **≤360** | mínimo | 96px |

Más uno por altura: **celular acostado** (`max-height:520px` y landscape) baja las
cartas a 88px, porque ahí lo que falta no es ancho sino alto.

**La regla de fondo: la mesa nunca se achica antes que los paneles.** Es lo
único que no se puede leer a medias — un panel con la descripción cortada sigue
sirviendo, una carta con el cartel cortado no.

Por eso, a medida que baja el ancho, lo primero que se sacrifica es la
descripción de los ítems (`.idesc` se oculta en tablet landscape y en mobile
mínimo), después la etiqueta del cronómetro, y recién al final el tamaño del
mesa.

Dos protecciones globales: `*{max-width:100%}` y `overflow-x:hidden` en el body,
para que ninguna ilustración embebida provoque scroll horizontal en un celular.

### El reparto de la marquesina

El marcador se queda con el **ancho libre** y la ronda y el cronómetro toman solo
lo que necesitan (`auto minmax(0,1fr) auto`). Antes los tres tomaban una fracción
igual y el bloque del reloj —que es un círculo de tamaño fijo— le comía el lugar
a los nombres de los equipos, que quedaban recortados a 16 caracteres.

| | Antes | Ahora |
|---|---|---|
| Nombre del equipo | 12px · máx 16 car. | **14px · máx 22** |
| Anillo del cronómetro | 86px · trazo 9 | **96px · trazo 15** |
| Número del minuto | 31px | **34px + resplandor** |

El anillo es el que cuenta el partido, así que va grande y grueso: el avance se
lee de reojo sin buscar el número. El aviso de las últimas jugadas se ve también
en el resplandor —dorado a falta de dos, rojo en la última— no solo en el color.

> El radio del SVG bajó de 40 a **38** al engrosar el trazo. Con `stroke-width:15`
> el anillo ocupa de `r-7.5` a `r+7.5`, así que con radio 40 el borde externo
> llegaba a 47,5 sobre un viewBox de 50 y el trazo se cortaba contra el borde.

**El número llena el hueco.** Todo el cronómetro se dimensiona desde una sola
variable, `--cro`, y el minuto es el **50% de ese valor**:

| Anillo | Hueco interno | Número |
|---|---|---|
| 118px *(large desktop)* | 72px | **59px** |
| 96px *(desktop)* | 59px | **48px** |
| 80px *(mobile)* | 49px | **40px** |
| 64px *(mobile chico)* | 39px | **32px** |

Antes el número era fijo en 34px y cada breakpoint lo redefinía a mano, así que
ocupaba poco más de la mitad del hueco y el círculo se veía vacío en el centro.
Ahora los breakpoints solo cambian `--cro` y las proporciones se mantienen
solas.

### El marcador se lee sin pensar

**Tu equipo siempre a la izquierda, el rival siempre a la derecha.** Los dos
nombres van en blanco: el lado ya lo dice la posición, y pintar al rival en gris
lo hacía parecer secundario cuando en el marcador los dos pesan igual.

En la **marquesina** el nombre va pegado a su número:

```
RACING DE MI BARRIO  2  -  1  DEPORTIVO BARRIAL
```

En los **pop-ups** el resultado va al medio y los nombres a los costados, en un
grid de `1fr auto 1fr`. La columna del medio es `auto`, así el resultado queda
**centrado sin importar cuánto ocupen los nombres**:

```
   CLUB ATLÉTICO SAN                        DEPORTIVO
   LORENZO DE ALMAGRO      3 - 0             BARRIAL
```

Los nombres largos se parten en dos líneas en vez de correr el resultado hacia un
costado. Probado con un nombre de una letra contra otro de 38: el marcador no se
mueve.

Se sacó la línea de **"vs"** que iba encima del marcador: con los nombres al
lado de cada gol, decir otra vez quién juega contra quién era repetir. Y en los
pop-ups los nombres iban en dos líneas sueltas —una arriba, otra abajo— sin dejar
claro cuál correspondía a cada número.

### La primera ronda es clasificatoria

Se llamaba DIECISEISAVOS y ahora es **CLASIFICATORIA**: ganarla te mete en el
playoffs, y de ahí sí van octavos, cuartos, semifinal y la final. Los playoffs tienen
cuatro rondas, que es lo que corresponde a 8 equipos, y la clasificatoria queda
como la puerta de entrada.

### Encadenar desgasta el plantel

Cada copa ganada le saca **un corazón de máximo** al campeonato siguiente, con
piso en 2:

| Copas | Techo | Arranca con |
|---|---|---|
| 0 | 4 | ❤4/4 |
| 1 | 3 | ❤3/3 |
| 2 | 2 | ❤2/2 |
| 3 o más | 2 | ❤2/2 |

La pantalla de campeón lo avisa antes de encadenar: *"el equipo llega gastado,
el próximo campeonato arranca con 3 ❤ de máximo"*. Sin ese aviso, arrancar con
menos aguante parecería un bug.

**El 💪 SEGUNDO AIRE lo recupera, y para toda la corrida** — no solo para el
partido en curso. Si solo subiera el máximo de ese partido, al siguiente lo
perderías de nuevo y el ítem no serviría para revertir el desgaste.

Eso es lo que lo convierte de salvavidas en compra estratégica:

| Campeonato | Ítems para volver a 4 | Costo | % de la corrida |
|---|---|---|---|
| 2º | 1 | €30M | **51%** |
| 3º o más | 2 | €60M | **102%** |

Del tercero en adelante, volver al máximo cuesta **más de lo que junta una
corrida entera**: hay que llegar con plata guardada del campeonato anterior. Esa
es la decisión que abre la mecánica — gastar en el camino o ahorrar para reparar
el plantel.

Con los mismos €30M comprás **3 suplentes** (+3 ❤ de una vez, sin tocar el
techo) o **1 segundo aire** (+2 ❤ ahora y +1 de techo para siempre). Cuál
conviene depende de si venís entero o gastado, que es exactamente lo que una
decisión de compra debería preguntar.

### Compartir el resultado

Las dos pantallas finales traen **COMPARTIR** y **COPIAR**. El primero usa el
menú nativo del sistema —en el celular abre WhatsApp, Telegram, lo que tengas— y
si el navegador no lo soporta, cae a un enlace de WhatsApp. El segundo copia al
portapapeles, y si el navegador lo niega, muestra el texto en un cuadro para
copiar a mano.

El texto que se manda:

```
⚽ DUELO FUTBOLERO — ¡CAMPEÓN!

🏆 2 copas ganadas

COPA 1:
  CLASIFICATORIA  2-0
  OCTAVOS  1-1 (ganado en penales)
  CUARTOS  3-1
  SEMIFINAL  2-1
  LA FINAL  1-0

COPA 2:
  ...
```

Texto plano a propósito: se lee igual en WhatsApp, en un mail o pegado en
cualquier lado, sin depender de que el formato sobreviva.

### Las pantallas finales

**CAMPEÓN** y **ELIMINADO** son el remate de la corrida, así que la palabra ocupa
todo el ancho —hasta 86px, dorada o roja con resplandor— y debajo va el marcador
grande del último partido.

Antes esa palabra iba en un tag chiquito arriba y el titular era genérico: lo
primero que se leía era *"se terminó la copa"* en vez de qué pasó.

**Y debajo, el camino completo.** Una fila por partido con la ronda, el rival, el
marcador y, si hubo empate, cómo se resolvió:

```
EL CAMINO
CLASIFICATORIA                    2-0
DEPORTIVO BARRIAL

OCTAVOS                          1-1
ATLÉTICO DEL SUR
ganado en penales

SEMIFINAL                        1-1
UNIÓN FERROVIARIA
perdido en penales
```

Cada fila se pinta de verde o rojo según cómo terminó, y los empates aclaran
**"ganado en penales"** o **"perdido en penales"** — sin eso, un 1-1 en la lista
no dice si pasaste o te fuiste.

Es lo que convierte "perdiste" en "perdiste después de esto".

### El penal definitorio

Empate en los 90: **un solo penal** y se termina la historia.

Primero sale el **cartel del empate**: la palabra EMPATE grande, el marcador
todavía más grande, los dos equipos, y abajo en rojo *"te queda una sola
pelota"*. Va solo, con su propio botón, porque el empate es la noticia y no una
nota al pie del penal — si el penal apareciera de golpe, habría que deducir del
marcador chico por qué se está pateando. El pop-up del penal lo repite arriba
para no perderlo de vista.

Después elegís **IZQUIERDA**, **AL MEDIO** o **DERECHA**; el arquero elige el suyo. Si no
coinciden, gol y pasás de ronda. Si coinciden, te lo ataja y la corrida se
termina ahí.

Sale en un pop-up con un arco dibujado: al elegir palo, la pelota sale para ese
lado y el arquero se tira, y recién ahí se revela el resultado.

**Convertís el 66,7% de las veces** (dos de cada tres palos son los que el
arquero no eligió). La tanda anterior era de cinco tiros a 50/50 resueltos sin
que el jugador tocara nada.

Los stats **no entran** acá, y es a propósito: el penal es la moneda al aire con
la que termina cualquier partido de fútbol. Es azar declarado, no azar
disfrazado de estrategia — el jugador sabe perfectamente que está adivinando.

Con qué frecuencia importa, medido sobre 30.000 campeonatos:

| | R1 | R2 | R3 | R4 | Final |
|---|---|---|---|---|---|
| Partidos empatados en los 90 | 14,1% | 12,7% | 23,0% | 23,1% | 25,7% |

### Tiempo de descuento

Si la racha se llena **justo en la última jugada**, el partido no termina sin
más: se juega el descuento. Sale un pop-up con el marcador y dos botones:

- **JUGARLA** — una última situación de gol al 38%. Gasta la racha entera.
- **GUARDARLA** — se va cargada al próximo partido, lista desde la primera jugada.

Comparte esqueleto con el aviso de racha llena —ícono, título, subtítulo,
opciones y nota al pie— con dos diferencias: acá las tarjetas son **botones**
porque hay que elegir, y en el medio va el **marcador grande**, que es el dato
del que depende la decisión.

La nota al pie cambia según cómo vayas, porque es lo que decide: si vas
perdiendo, guardarla no sirve de nada (no hay próximo partido); si vas ganando,
jugarla es tirar una racha que ya te llevabas gratis; y si estás empatado, es la
diferencia entre ganar en los 90 o irte a penales.

Sin esto, llenar la racha en la última jugada era plata tirada: el reloj llegaba
a cero y el partido se cerraba con la racha cargada sin poder usarla.

### Un cartel por vez

Los carteles de gol y de tiro errado **no bloquean**: se muestran y se van
solos. Los pop-ups que esperan un click, en cambio, aparecen apenas se los
llama. Sin cuidado, un gol que además llena la racha mostraba las dos cosas
encima y el aviso de racha —que va en una capa superior— se comía el momento
del gol.

Ahora todo gol espera a que su cartel termine antes de mover cualquier medidor,
y esa espera reemplaza a la que hacía la resolución de la carta, así que el
turno no se alarga.

> **La espera estuvo mal calibrada**: `ESPERA_GOL` era 1250ms contra una
> animación de 1500ms, así que el aviso de racha llena salía 250ms antes de
> tiempo y tapaba el final del gol. Ahora las dos salen de la misma constante
> —`DURA_GOL`, que el JS le pasa al CSS como variable— y no se pueden
> desincronizar. Verificado en las seis vías de gol: el cartel se ve hasta los
> 1400ms y el aviso aparece a los 1800ms. La cadena más larga del juego —gol
del rival, que vacía el aguante, que reparte una situación— se ve en orden:

```
   280ms   CARTEL GOL (GOL RIVAL)    ❤1  0-1
  1120ms   CARTEL GOL (GOL RIVAL)    ❤1  0-1
  1400ms   CARTEL GOL (GOL RIVAL)    ❤4  0-1     ← se funde y rellena
  1680ms   SITUACIÓN (PENAL)         ❤4  0-1
```

### El ícono de la racha

La racha es **⚡**, y el medidor del HUD lo usa igual que el aguante usa ❤:
cuatro rayos, los ganados encendidos con un brillo dorado y los que faltan en
gris. Antes eran cuatro círculos que no se parecían a nada de lo que decían los
carteles de la mesa.

Ahora si una carta dice `+2 ⚡` y arriba hay cuatro ⚡, la relación se entiende
sin que nadie la explique. El rayo se eligió sobre el fuego —la otra opción
natural para "racha"— porque es amarillo y se alinea con el dorado del medidor,
mientras que el fuego habría competido visualmente con el rojo del aguante.

### El ⚡ siempre en dorado

Todo lo que carga la racha se marca con **⚡ en dorado**, el mismo color del
medidor, sin importar de qué tono sea el cartel. Un `CÓRNER EN CONTRA` es rojo
porque es una carta del rival, pero su `+⚡ racha` va dorado igual.

Eso hizo visible algo que estaba escondido: **los duelos ganados también cargan
la racha** y el cartel no lo decía. Ahora un defensor superable muestra
`PASA +⚡`, el mediocampo `ROBO +⚡`, el delantero cortado `CORTE +⚡` y una jugada
clara `GOL +⚡`. Antes había que saberse la regla de memoria para leer bien el
mesa.

### El cronómetro

Un reloj redondo en la marquesina que **se llena por porciones**, una por
jugada: arranca vacío en `0` y se completa a los `90`. Se lee al revés que el
contador anterior — antes mostraba lo que faltaba, ahora lo que ya se jugó, que
es como se mira un partido.

Las **dos últimas porciones** salen amarilla y roja, y el número del centro las
acompaña: a falta de dos jugadas se pone dorado, a falta de una se pone rojo y
late. El aviso está en el anillo *y* en el número, porque en el momento en que
importa el jugador está mirando la mesa, no contando porciones.

| Minuto | Porciones | Estado |
|---|---|---|
| 0 | 9 vacías | — |
| 40 | 4 verdes | — |
| 70 | 7 verdes | dorado: quedan dos |
| 80 | 7 verdes + 1 dorada | rojo latiendo: última |
| 90 | + 1 roja | pitazo |

### El mesa es sobre todo goles

Las cartas de gol —las ocho de porcentaje y las cuatro directas— pesan **un
40% más** que el resto, y las del rival un 90% más en las rondas 1 a 3, donde
arrancaban muy por detrás. El mesa pasó de tener más duelos que situaciones a
lo contrario:

| Cartas por mesa | gol a favor | gol en contra | total gol | duelos |
|---|---|---|---|---|
| Nivel 1 | 3,5 | 1,2 | **4,7** | 6,4 |
| Nivel 2 | 3,9 | 2,2 | **6,1** | 5,0 |
| Nivel 3 | 3,0 | 3,0 | **6,1** | 4,6 |
| Nivel 4 | 3,1 | 2,9 | **6,0** | 4,5 |
| Nivel 5 | 2,8 | 3,7 | **6,5** | 4,3 |

Antes eran 3,0 cartas de gol contra 7,3 duelos en la primera ronda. El
resultado en el marcador:

| Goles por partido | a favor | en contra | total |
|---|---|---|---|
| Ronda 1 | 1,30 | 0,79 | 2,09 |
| Ronda 3 | 1,25 | 1,26 | 2,51 |
| Ronda 5 | 0,97 | 2,15 | **3,13** |
| **Promedio** | 1,31 | 1,17 | **2,48** |

Resultados más frecuentes: **1-1** (12,4%), **1-0** (11,3%), **2-0** (9,3%),
**2-1** (8,7%). Los 0-0 bajaron del 11% al 6,4%.

**Por qué las del rival subieron más.** Multiplicar parejo habría favorecido al
jugador: en las rondas bajas hay muchas más cartas a favor que en contra, y
duplicar algo que no existe sigue dando cero. Con el aumento parejo los goles a
favor subían 39% y los del rival 7%. Con el refuerzo extra quedan 1,31 contra
1,17 — apretado, que es lo que se buscaba.

La ronda 3 es donde se emparejan (3,0 y 3,0) y de ahí en adelante el rival pasa
al frente.

### Techos de concentración

Dos grupos de cartas se acumulaban demasiado en un misma mesa:

| | Mesas con 3 o más | |
|---|---|---|
| | **antes** | **ahora** |
| Goles directos | hasta 14% | **0%** |
| Penales | hasta **25%** | **0%** |

Un mesa con tres penales concentra tanta probabilidad de gol que deja de
parecerse a un partido. Ahora hay **techo de 2** para cada grupo, y si quedan
dos y las dos son a favor, **una pasa al rival**: el regalo no puede ser solo
tuyo. Verificado sobre 20.000 mesas por nivel, cero excepciones.

**El sobrante no desaparece.** Se convierte en una carta de **porcentaje del
mismo lado**, así el volumen de situaciones se mantiene y lo único que baja es
el gol garantizado. Un tercer penal a favor pasa a ser un córner o un pase gol:
sigue siendo una chance, pero al 35-40% en vez de al 50%.

### Todo partido puede terminar en gol para los dos

El sorteo de la mesa podía dar 16 cartas sin una sola situación de gol a
favor —o sin ninguna en contra, que era el caso de **toda la primera ronda**— y
entonces el partido se resolvía nada más que por duelos.

Ahora se garantiza **al menos una de cada lado en cada mesa**. Si el sorteo
no la dio, se pisa una carta anodina (offside, taquilla, hinchada, calambre),
nunca un duelo ni algo que ya defina el marcador, y nunca la garantía del otro
lado. Verificado sobre 20.000 mesas por nivel: **cero mesas sin situación
para alguno de los dos**.

| Situaciones por mesa | a favor | en contra |
|---|---|---|
| Nivel 1 | 2,1 | 1,0 |
| Nivel 3 | 2,1 | 1,8 |
| Nivel 5 | 1,9 | 2,5 |

### Los goles seguros, de a pares

Cada carta de gol sin tirada tiene su espejo del otro lado:

| A favor | En contra |
|---|---|
| ⚽ **JUGADA CLARA** — entra sola | 💥 **CONTRAATAQUE RIVAL** — te agarran mal parado |
| 🎁 **AUTOGOL RIVAL** — te la regalan | 🙈 **AUTOGOL PROPIO** — se la regalás |

Antes había **dos** a favor y **ninguna** en contra: el marcador solo podía
abrirse solo para un lado. El contraataque es el gol elaborado del rival; el gol
en contra es el regalo, con los mismos pesos y en los mismos niveles que el
autogol rival.

| Gol seguro por mesa | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| ⚽ Jugada clara | 1,0 | 0,5 | 0,5 | 0,4 | 0,4 |
| 🎁 Autogol rival | — | — | — | 0,2 | 0,2 |
| 💥 Contraataque | — | 0,3 | 0,2 | 0,2 | 0,4 |
| 🙈 Autogol propio | — | — | — | 0,2 | 0,2 |
| **Total a favor** | 1,0 | 0,5 | 0,5 | 0,6 | 0,6 |
| **Total en contra** | 0,0 | 0,3 | 0,2 | 0,4 | 0,6 |

La ronda 1 no tiene ninguno en contra y la final queda pareja (0,6 y 0,6): el
regalo empieza siendo solo tuyo y termina repartido.

### Las estadísticas del partido

| Goles por partido | a favor | en contra | total |
|---|---|---|---|
| Ronda 1 | 1,12 | 0,72 | 1,84 |
| Ronda 3 | 1,14 | 1,05 | 2,19 |
| Ronda 5 | 0,83 | 2,11 | **2,94** |
| **Promedio** | 1,15 | 1,05 | **2,20** |

Resultados más frecuentes: **1-0** (13,3%), **1-1** (13,0%), **0-1** (10,4%),
**2-0** (9,3%), **0-0** (9,1%).

Dos cosas que valen la pena: el promedio de 2,20 goles por partido queda cerca
del fútbol real (~2,6), y la curva de goles **en contra** crece de 0,73 a 1,96
mientras la de goles a favor se mantiene plana. Avanzar en el campeonato no te
hace marcar más: te hace defender peor.

Las dos incorporaciones —garantía y contraataque— subieron el total de 2,00 a
2,20, casi todo del lado de los goles en contra (0,87 → 1,06). Hay más
*situaciones* que antes sin que el marcador se infle: la mayoría de las cartas
nuevas son de porcentaje, no de gol seguro.

### Cómo se nombran las cartas

**La palabra RIVAL en el nombre significa que la pelota la tiene él.** Es el
único criterio, y vale para las dieciséis:

| La pelota es tuya | La pelota es del rival |
|---|---|
| ⚽ JUGADA CLARA | 💥 CONTRAATAQUE RIVAL |
| 🎁 AUTOGOL RIVAL | 🙈 AUTOGOL PROPIO |
| 🎯 PENAL | 💀 PENAL **RIVAL** |
| 🤝 PASE GOL | 🕳 PASE GOL **RIVAL** |
| 🚩 CÓRNER | 🌪 CÓRNER **RIVAL** |
| 🚧 TIRO LIBRE | 🧨 LIBRE **RIVAL** |
| 🧱 DEFENSOR **RIVAL** | 🌀 MEDIO **RIVAL** |
| 🥅 ARQUERO | 👟 DELANTERO **RIVAL** |

El DEFENSOR y el ARQUERO **no** llevan "rival" aunque sean jugadores del otro
equipo: ahí la pelota la tenés vos y ellos son el obstáculo. Ponerles "rival"
haría que la palabra significara dos cosas distintas.

Y el criterio coincide con la mecánica: las de la derecha son las que resuelve
tu **DEFENSA**, y son las que en el mini juego se ganan **adivinando** en vez de
esquivando. Un mismo concepto —de quién es la pelota— ordena el nombre, el stat
y la forma de jugar el empate.

Antes cuatro cartas de ataque rival no lo decían en el nombre (MEDIOCAMPO,
DELANTERO, CONTRAATAQUE, GOL EN CONTRA) y las que sí lo decían usaban tres
fórmulas distintas: "en contra", "rival" y "contraataque".

### Los valores de los duelos

| | defensor | arquero | medio | delantero |
|---|---|---|---|---|
| Ronda 1 | 2-3 | 3 | 1-2 | 1-2 |
| Ronda 2 | 2-3 | 3-4 | 2 | 2-3 |
| Ronda 3 | **2-4** | 3-4 | 2-3 | 2-3 |
| Ronda 4 | **3-4** | 4 | 3-4 | 3-4 |
| Ronda 5 | **3-4** | 4 | 3-4 | 3-4 |

La ronda 3 es la de transición: conviven cartas de 2 (que ya ganás), de 3 (que
ganás si reforzaste) y alguna de 4 (que todavía no). De la 4 en adelante **no
aparece ningún 2**: nada se gana con el plantel de arranque.

### El techo del escalado — pendiente

Con estos valores, llegar a la final con los 4 refuerzos de la corrida te da
**19%** de duelos ganados, contra el **0%** que daba antes. El motor de
progresión al menos arranca. Pero queda una meseta fea:

| Refuerzos | ATK/DEF | R4 | R5 |
|---|---|---|---|
| 2 | 3/2 | 20% | 19% |
| 3 | 4/2 | 20% | 19% |
| 4 | 4/3 | **20%** | **19%** |

**El tercer y el cuarto refuerzo no cambian nada.** `ESCALA_RIVAL = 0.5` sube a
los rivales exactamente al mismo ritmo que vos, y como los rangos son de dos
valores, cada punto de escalado se come el refuerzo entero.

Bajarlo a **0,4** lo destraba —0% → 19% → 19% → 46% → **73%**, con cada refuerzo
sirviendo para algo— pero **casi triplica las copas** (2,05% a 5,75%). Con
aguante 3 en vez de 4 queda en 4,24%, un punto intermedio.

Es una decisión abierta: progresión real y juego más fácil, contra el estado
actual, donde el plantel se estanca a mitad de camino.

### Siempre 3 o 4 duelos por mesa

La cantidad de cartas de duelo está **fijada en 3 o 4**, sorteado 50/50. Si el
reparto dio más, los de sobra pasan a cartas anodinas; si dio menos, se pisan
anodinas para completar.

Antes dependía del sorteo y variaba muchísimo:

| | Duelos antes | Ahora |
|---|---|---|
| Ronda 1 | 6,4 | **3,5** |
| Ronda 3 | 4,6 | **3,5** |
| Ronda 5 | 4,3 | **3,5** |

Y no solo el promedio: en la final **el 15% de los mesas traía dos duelos o
menos**, con más de una fila sin ninguno. En esos partidos tus stats no pintaban
nada y todo se resolvía por cartas de porcentaje.

**Por qué fijarlo y no solo poner un piso.** Un duelo no vale lo mismo en cada
ronda: con 4 refuerzos ganás el **100%** en la primera y el **17%** en la final.
Eran cartas regaladas al principio y casi seguras en contra al final. Fijar la
cantidad aplana esa curva: el plantel pesa parecido en todas las rondas.

Lo que **no** se toca al ajustar: las cartas de gol —romperían la garantía de
que todo mesa pueda terminar en gol para los dos lados— ni las tarjetas, que
tienen su propia regla de convivencia. Verificado sobre 20.000 mesas por
nivel: 50/50 exacto entre 3 y 4, y cero garantías rotas.

### El uno contra uno: el empate se juega

Cuando tu stat queda **exacto** contra el valor de la carta, el duelo no se
resuelve solo: sale un pop-up, elegís un lado, el rival elige el suyo. Si no
coinciden, ganás. **50/50 limpio**, con la misma mecánica del penal definitorio
pero con dos opciones en vez de tres.

**De quién es la pelota decide cómo se gana.** Con la pelota tuya ganás
**esquivando** —elegir el lado que el rival no eligió—; con la pelota del rival
ganás **adivinando**, yendo justo a donde él va. La probabilidad es 50/50 en los
cuatro; lo que cambia es qué estás tratando de hacer.

| Carta | Título | Pregunta | La pelota es | Ganás si |
|---|---|---|---|---|
| 🥅 ARQUERO | MANO A MANO | ¿Dónde la ponés? | tuya | **no** coincidís |
| 🧱 DEFENSOR **RIVAL** | UNO CONTRA UNO | ¿Por dónde lo encarás? | tuya | **no** coincidís |
| 🌀 MEDIO RIVAL | LA MARCA | ¿Para qué lado se la lleva? | del rival | **coincidís** |
| 👟 DELANTERO RIVAL | DEFENDER | ¿Para qué lado va a encarar? | del rival | **coincidís** |

Al principio los cuatro usaban la misma regla —no coincidir gana— y en el
mediocampo y el delantero quedaba al revés de lo que dice la pantalla: te
preguntaba para qué lado salías y ganabas yendo al lado contrario del rival, que
en una disputa no tiene sentido. Las preguntas también cambiaron para que se
entienda qué se está tratando de anticipar.

El cartel de la carta lo avisa antes de que elijas la fila, y **dice qué se
juega con números**, no con verbos:

| Carta | Cartel del empate |
|---|---|
| 🧱 DEFENSOR **RIVAL** | `50/50` · **+1 ⚡** o **-1 ❤** |
| 🥅 **ARQUERO** | `50/50` · **⚽ GOL** o **-2 ❤** |
| 🌀 MEDIO RIVAL | `50/50` · **+1 ⚡** o **-1 ❤** |
| 👟 **DELANTERO RIVAL** | `50/50` · **+2 ⚡** o **⚽ GOL RIVAL** |

**El mano a mano de los dos que definen vale doble.** Errarle al arquero cuesta
**2 ❤** y cortar al delantero da **2 ⚡**, mientras que el defensor y el medio
mueven 1. Es el momento más caro de la mesa y se juega a cara o cruz: que
pesara como los otros dos sería no distinguirlo.

Fuera del empate manda la diferencia, igual que en los otros duelos — un arquero
de 3 contra ataque 2 sigue costando 1.

En el arquero y el delantero lo que está en el aire es el **marcador**, y eso
cambia por completo si conviene meterse en esa fila. El gol propio va en verde y
el del rival en rojo. Decir solo "mano a mano" en las cuatro escondía la mitad
de la información.

El duelo pasa a tener tres estados, no dos.

**Los rangos se ajustaron para que el empate sea posible siempre.** Antes el
arquero valía 4 fijo en las rondas 4 y 5 —con el escalado quedaba en 5 y tu
ataque llegaba a 4—, así que nunca se empataba; lo mismo el mediocampo y el
delantero en las rondas altas. Solo el defensor permitía empatar en las cinco.

| Rangos | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| 🧱 defensor | 2-3 | 2-3 | 2-4 | 3-4 | 3-4 |
| 🥅 arquero | **2-3** | 3-4 | 3-4 | **3-4** | **3-4** |
| 🌀 mediocampo | 1-2 | **1-2** | 2-3 | **2-3** | **2-3** |
| 👟 delantero | 1-2 | **1-3** | 2-3 | **2-3** | **2-3** |

Ahora las **20 combinaciones** de carta y ronda pueden terminar en empate.

**Endurece bastante.** Empatar era ganar seguro y ahora es jugártela, y con estos
stats el empate es frecuente:

| | Antes | Con mini juego |
|---|---|---|
| Copas | 2,74% | **1,00%** |
| Racha llena por partido | 0,62 | 0,43 |
| Fundidas en la final | 1,61 | 1,93 |
| Goles en contra en la final | 1,89 | 2,20 |

Es el precio de que el momento en que tu plantel llega justo pase a ser el más
tenso del partido en vez del más tibio.

### Siempre 4 duelos, nunca todos del mismo lado

El mesa trae **exactamente 4 cartas de duelo**, y nunca las cuatro del mismo
lado. Los tres repartos posibles:

| Reparto (a favor + en contra) | Frecuencia |
|---|---|
| **3+1** | 37% |
| **2+2** | 37% |
| **1+3** | 26% |

Antes eran 3 o 4 y **uno de cada cinco mesas los traía todos de un lado**
(3+0 o 0+3). En esos partidos uno de tus dos stats no se usaba nunca: subir
DEFENSA no servía de nada si la mesa solo traía defensores y arqueros.

### Los tres resultados existen siempre

| Ronda | Ganás | Empatás | Perdés |
|---|---|---|---|
| 1 | 20% | 40% | 40% |
| 2 | 19% | 33% | 48% |
| **3 a 5** | **33%** | **33%** | **33%** |

> **Estuvo roto y no lo vimos:** al ajustar los rangos para garantizar que el
> empate fuera posible en todas las rondas, quedaron **centrados sobre el stat
> esperado** — el piso del rango era exactamente tu número. Resultado: en las
> rondas 1, 4 y 5 **nunca ganabas un duelo limpio**, solo empate o derrota. Eso
> dejaba el premio por diferencia sin usar y convertía la mitad de los duelos en
> mini juegos.
>
> Se arregló bajando **un punto el piso** de cada rango, sin tocar los techos ni
> los pesos. Ahora los tres resultados conviven y desde la ronda 3 quedan en un
> tercio cada uno.

### El duelo: manda la diferencia, sin excepciones

**Cuánto ganás o perdés en un duelo es por cuánto lo ganaste o lo perdiste.**
Rango 1-3, en las cuatro cartas y de los dos lados:

| Diferencia | Ganás | Perdés |
|---|---|---|
| por 1 | **+1 ⚡** | **-1 ❤** |
| por 2 | **+2 ⚡** | **-2 ❤** |
| por 3 o más | **+3 ⚡** | **-3 ❤** |

Ganarle por dos cuerpos a un defensor levanta al equipo el doble que ganarle
raspando, igual que perder por dos duele el doble. El techo de 3 evita que un
solo golpe vacíe el aguante entero.

Los dos duelos que definen el marcador suman además su gol: el **ARQUERO**
ganado es GOL y el **DELANTERO RIVAL** perdido es GOL RIVAL.

**Cada gol del rival cobra una sola cosa.** El del DELANTERO RIVAL cobra el
duelo perdido y **no toca la racha**; los que no salen de un duelo cobran el
ánimo y no tocan el aguante:

| Gol del rival | Aguante | Racha |
|---|---|---|
| 👟 DELANTERO RIVAL | **-N ❤** | — |
| 💥 CONTRAATAQUE RIVAL | — | **-1 ⚡** |
| 💀 PENAL RIVAL | — | **-1 ⚡** |
| 🙈 AUTOGOL PROPIO | — | **-1 ⚡** |

El delantero cobraba las dos —el `-N ❤` del duelo y el `-1 ⚡` de la regla del
gol— y era la única carta que castigaba por triplicado.

> **Hubo una versión con piso de 2** para el arquero y el delantero, con el
> argumento de que deciden el marcador. Se sacó al verla jugando: un arquero de
> 3 contra ataque 2 cobraba **-2** cuando la diferencia era **1**, y eso rompe
> la única regla que el jugador puede deducir mirando los números del cartel.
> Una excepción que hay que memorizar cuesta más de lo que aporta.

### El duelo es simétrico: manda la diferencia

| | Ganás | Perdés |
|---|---|---|
| 🧱 **DEFENSOR** | pasás **+N ⚡** | **-N ❤** |
| 🌀 **MEDIO RIVAL** | robás **+N ⚡** | **-N ❤** |
| 👟 **DELANTERO RIVAL** | cortás **+N ⚡** | *gol rival* |
| 🥅 **ARQUERO** | *gol tuyo* | **-N ❤** |

**N es la diferencia**, con rango 1-3 de los dos lados. Ganarle por dos cuerpos a
un defensor levanta al equipo el doble que ganarle raspando, igual que perder por
dos duele el doble. Ganar justo (mismo número) cuenta como 1.

Los dos duelos que **terminan en gol** quedan afuera de la regla: ahí manda la
del gol —`+1 ⚡` el tuyo, `-1 ❤ -1 ⚡` el del rival— porque el gol ya es el
premio o el castigo.

> **Ojo: hoy esta regla casi no se activa.** Con `ESCALA_RIVAL = 0.5`, los
> rivales suben al mismo ritmo que vos y **la diferencia al ganar nunca pasa de
> 1**, en ninguna ronda y con cualquier cantidad de refuerzos. El premio medio
> es exactamente 1,00, o sea lo mismo que antes de implementarla.
>
> | Escalado | Premio medio con 4 refuerzos | Duelos con premio > 1 en R1 |
> |---|---|---|
> | **0,5 (actual)** | **1,00** | **0%** |
> | 0,4 | 1,23 | 50% |
>
> Es el mismo problema estructural que apaga la progresión de stats: el escalado
> se come cualquier ventaja que saques. La regla queda escrita y correcta, lista
> para cuando se baje el escalado.

### Perder un duelo cuesta la diferencia

Si el defensor vale 4 y tu ataque es 2, te pasa por encima **por dos cuerpos** y
eso son **-2 ❤**. Perder por poco duele poco; que te pasen por arriba duele de
verdad. Vale igual para ataque y defensa, y el cartel muestra el número real
antes de que elijas. Techo en 3, como el resto del daño.

En las tres primeras rondas **no cambia nada**: la diferencia es siempre 1
porque los rivales todavía no te sacan tanta ventaja. Recién se nota arriba:

| Diferencia al perder | R1-R3 | R4 | R5 |
|---|---|---|---|
| por 1 | 100% | 69% | 39% |
| por 2 | — | 31% | 46% |
| por 3 | — | — | 14% |

El efecto es un final bastante más áspero, y casi nada antes:

| Aguante perdido por partido | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| Antes (siempre -1) | 3,5 | 4,5 | 4,7 | 5,5 | **7,0** |
| Ahora (la diferencia) | 3,5 | 4,4 | 4,7 | 5,7 | **8,2** |

| Veces que te fundís por partido | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| Antes | 0,42 | 0,69 | 0,72 | 0,93 | **1,30** |
| Ahora | 0,42 | 0,68 | 0,71 | 0,96 | **1,61** |

En la final te fundís una vez y media por partido en vez de una y cuarto. Las
copas bajan poco (1,64% contra 1,89%) porque fundirse rellena el aguante, así
que parte del castigo extra se absorbe solo.

### El daño no es fijo

Las cartas que restan aguante traen su propio número, y **el cartel lo
muestra** antes de que elijas: `-1 ❤`, `-2 ❤`, `-3 ❤`. Sube por dos motivos a la
vez.

**Por ronda**, con el rango que trae cada pool. Y **por lo bueno que sea tu
equipo**: al que juega bien lo marcan más duro, con la misma fórmula del escalado
rival aplicada al promedio de tus dos stats. Techo en **3**, para que un solo
golpe nunca te vacíe el aguante entero de una.

| | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| **CALAMBRE** sin refuerzos | -1 | -1/-2 | -1/-2 | -1/-2 | -2 |
| **CALAMBRE** con 4 refuerzos | -2 | -2/-3 | -2/-3 | -2/-3 | -3 |
| **LESIÓN** sin refuerzos | — | -2 | -2 | -2/-3 | -2/-3 |
| **LESIÓN** con 4 refuerzos | — | -3 | -3 | -3 | -3 |

### Rachas grandes: OLA 🌊 y RACHA FULL ✨

Dos cartas nuevas que cargan la racha de golpe: la **OLA EN LA TRIBUNA** suma
**+2 ⚡** y la **RACHA FULL** **llena la racha entera**, venga de donde venga: si
estabas en 0, quedás en 4 y con las dos salidas habilitadas de una.

Son las cartas más raras del juego (1 a 2,6% del pool cada una), y la noche
mágica recién aparece en cuartos. Encontrar una es el golpe de suerte que te
cambia el partido, no algo con lo que se pueda contar.

Resolvieron de paso el problema que arrastrábamos hacía varias versiones: **la
racha en la final pasó de llenarse 0,10 a 0,30 veces por partido**, el triple.
Era la ronda donde la racha estaba prácticamente muerta.

### Cómo se lee una carta

```
   CON DUELO                   SIN DUELO
┌──────────────────┐      ┌──────────────────┐
│ DEFENSOR    ┌──┐ │      │      PENAL       │  título centrado
│             │ 4│ │      │                  │
│      🧱     └──┘ │      │        🎯        │
│ ──────────────── │      │ ──────────────── │
│      -2 ❤        │      │     50% GOL      │  lo que puede pasar
└──────────────────┘      │ ·············    │
                          │ +1 ⚡ o -1❤│  lo que te deja
                          └──────────────────┘
```

Tres franjas: **qué es**, **qué puede pasar**, **qué te deja**.

**El valor del duelo es solo el número**, con el borde del color del stat contra
el que se compara —rojo ataque, azul defensa—. Llevaba la etiqueta `ATAQUE` /
`DEFENSA` escrita y se sacó: el color ya lo dice y el texto le robaba el ancho
que necesita el nombre.

**El nombre y el número son hermanos en un flex**, no elementos absolutos. Por
eso no pueden encimarse por más largo que sea el nombre: el título se achica y
corta, el número nunca se mueve. Cuando la carta no tiene duelo, el título usa
todo el ancho y va **centrado**.

**Los efectos sobre los medidores van en su propia línea**, debajo de una línea
punteada. El bloque de arriba es *lo que puede pasar* (`50% GOL`) y el de abajo
*lo que te deja* (`+1 ⚡ o -1 ❤`). Mezclados no se distinguía qué era la
probabilidad y qué la consecuencia.

### Cartas trabadas 🔒

A lo largo del partido se traban **cuatro cartas: una por fila**, y quedan
trabadas hasta el pitazo final. No desaparecen: se siguen viendo enteras, con su
cartel legible y un 🔒 encima, pero ya no pueden salir sorteadas.

El partido **arranca sin ninguna**. Aparecen de a una, no en todas las jugadas
(70%), y nunca sobre la última carta jugable de una fila.

**Una por fila es la clave.** Cada fila pierde exactamente una opción, así que
ninguna se cierra más que las otras y la mesa no termina lleno de candados.
Lo que cambia es la lectura: la fila que tenía cuatro cartas ahora tiene tres,
y si te trabaron justo la buena, esa fila dejó de servir.

| Jugada | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|---|---|---|---|---|---|---|---|---|---|
| Trabadas 🔒 | 0,0 | 0,7 | 1,4 | 2,1 | 2,8 | 3,2 | 3,5 | 3,6 | 3,7 |
| Cartas jugables | 16,0 | 14,3 | 12,6 | 10,9 | 9,2 | 7,8 | 6,5 | 5,4 | 4,3 |
| Filas elegibles | 4,0 | 4,0 | 4,0 | 4,0 | 4,0 | 3,9 | 3,7 | 3,5 | 3,1 |

Sobre 30.000 partidos simulados: ningún partido quedó sin jugadas posibles.
Igual hay una red de seguridad: si no quedara ninguna, el árbitro pita el final.

### Repetir fila se castiga

**Tope del partido: 4 trabadas, una por fila.** La **quinta** existe solo como
castigo por repetirse de fila, y de ahí no pasa nunca.

Si elegís la **misma fila dos veces seguidas**, en la jugada siguiente se traba
una carta **de esa fila**: sin sorteo, sin el 70%, y aunque la fila ya tuviera
una. Es la única excepción al "una por fila". Al segundo click aparece el aviso:
*"Te repetís en la fila 2. El rival te la va a cerrar."*

Dos límites: solo se cobra si a la fila le queda **más de una carta jugable**
—no tiene sentido rematar una fila que ya no da nada— y nunca si la mesa ya
llegó a las 5.

| Estilo de juego | Trabadas al final del partido |
|---|---|
| Variando de fila | 3 (34%) · **4 (62%)** |
| Repitiendo fila | **4 (100%)** |

Repetir no suma trabadas de más: **acelera** el cierre. El que varía a veces
termina con 3; el que se repite llega a 4 siempre, y toca la quinta si insiste
sobre una fila que todavía estaba entera.

Verificado sobre 3.000 mesas por caso:

| Caso | Resultado |
|---|---|
| Con 4 trabadas, ¿la repetición cobra la quinta? | 3.000/3.000 |
| ¿Alguna vez pasa de 5? | **0**/3.000 |
| Con 5 puestas, ¿traba una sexta? | **0**/3.000 |

Usar una **columna** no cuenta para la repetición: el contador se reinicia.

> **Estaba roto:** la marca por repetición no tenía tope y, si no podía
> aplicarse en su fila, buscaba otra donde caer. Repitiendo se acumulaban **6 o
> 7** trabadas y la mesa terminaba cerrado. El tope duro (`TRABAS_MAX`) y
> quitar ese rebote lo dejaron en 4-5.


**La prueba de que premia leer la mesa.** Se simularon 30.000 campeonatos con
dos jugadores: uno que elige la fila con más cartas vivas (no evalúa nada) y
otro que evalúa cada fila por su valor esperado.

| | Sin trabas | Con trabas |
|---|---|---|
| Jugador que no evalúa | 2,70% | 2,58% |
| Jugador que evalúa | 29,67% | **36,23%** |

Al que no piensa las trabas no le dan nada. Al que lee la mesa le suben las
copas un 22%. Eso es lo que tiene que hacer una mecánica de este tipo: premiar
la lectura, no agregar ruido.

> Nota de calibración: esa tabla también muestra que las tasas de copas medidas
> en otras secciones (~2-3%) son las de un jugador que juega muy mal, y sirven
> solo para comparar variantes entre sí. La tasa real de alguien que lee el
> mesa está en el orden del 30%.

### Ninguna situación se desperdicia

Las ocho cartas de porcentaje **siempre** mueven algo, entre o no entre:

| | Entra | No entra |
|---|---|---|
| **A favor** | Gol **+1 ⚡ RACHA** | **-1 ❤ AGUANTE** — el equipo se viene abajo |
| **En contra** | Gol del rival **-1 ❤ AGUANTE** | **+1 ⚡ RACHA** — te salvaste y el equipo se levanta |

La regla es la misma de los dos lados y se dice en una frase: **lo bueno carga
la racha, lo malo gasta aguante.** Un penal convertido levanta al equipo; uno
errado lo hunde. Que el arquero saque un penal en contra vale tanto como meter
uno.

**Y vale para todo gol, venga de donde venga.** No solo en las cartas de
porcentaje: una jugada clara, un duelo ganado al arquero, un autogol a favor o
un delantero que te gana la espalda mueven también el medidor. El marcador nunca
se mueve solo — todo gol propio suma **+1 ⚡** y todo gol del rival cuesta
**-1 ❤**.

> Única excepción: el gol que sale de una *situación de gol* (la del aguante
> vaciado o la racha cobrada). Ahí el medidor ya se movió —vaciarse el aguante
> *fue* el castigo— y volver a restar podría encadenar una situación tras otra.

Antes era al revés en las dos mitades —fallar a favor *daba* racha, y que el
rival fallara *costaba* aguante— y aunque el balance daba parecido, había que
explicarlo dos veces. Lo que decidió el cambio fue otra cosa:

| Racha llena por partido | R1 | R2 | R3 | R4 | Final |
|---|---|---|---|---|---|
| Regla anterior | 0,68 | 0,68 | 0,64 | 0,48 | **0,28** |
| Regla actual | 0,60 | 0,67 | 0,69 | 0,59 | **0,44** |

En la final la racha se llena un 57% más seguido, con las copas prácticamente
iguales (1,67% contra 1,74%). La causa: en las rondas de arriba hay más cartas
del rival, y ahora que el rival falle te *da* racha en vez de quitarte aguante.
La curva deja de desplomarse justo donde más la necesitás.

Y el tiro que no entra **también se muestra**: sale un cartel con cómo se erró
—*ataja el arquero*, *al travesaño*, *en la barrera*, *despeja tu defensa*—
sorteado entre cuatro desenlaces por carta. No cambia nada del resultado, que
ya se decidió; sirve para que un fallo se lea como algo que pasó y no como una
carta que no hizo nada. El cartel aprovecha para recordar el efecto: dorado
cuando fallás vos (+1 ⚡), verde cuando falla el rival (-1 ❤).

Esto le da a la racha una segunda fuente que no depende de tus stats: al
arrancar, con ATAQUE 2 y DEFENSA 1, casi todos los duelos se pierden, así que
sin esta regla la racha prácticamente no se llenaba. Sobre 20.000 campeonatos
simulados, **duplica la frecuencia con que la racha llega a llenarse** (de 0,11
a 0,20 veces por partido) sin mover casi nada la tasa de copas, porque la mitad
a favor y la mitad en contra se compensan.

### Cartas de aguante

Suman:

| Carta | Efecto |
|---|---|
| **HINCHADA** 📣 | **+1 aguante** |
| **COOLING BREAK** 💧 | **+1 aguante** (desde la ronda 3) |

**Suplentes y cooling break intercambiaron lugares.** Los SUPLENTES eran una
carta que daba +2 y limpiaba amarillas, y el COOLING BREAK un ítem de +1; ahora
los suplentes son el **ítem** (€10M, +1 aguante) y el cooling break la **carta**
(+1 aguante). El sentido cierra mejor: meter gente del banco es una decisión del
técnico, y parar a tomar agua es algo que pasa en el partido.

Con el intercambio, la mesa ya no regala +2 de aguante ni limpieza de
amarillas: las dos cartas de aguante dan +1, y las amarillas no se borran con
nada.

Restan, en escalera:

| Carta | Efecto |
|---|---|
| **CALAMBRE** 🦵 | **-1 aguante** |
| **LESIÓN** 🩹 | **-2 aguante** |
| **ROJA** 🟥 | **-3 aguante** (ver abajo) |

### Cartas de dinero

Tres escalones, marcados en pantalla con `+`, `++` y `+++`:

| Carta | Efecto |
|---|---|
| **FAMA** 🌟 | +4 a 9 &nbsp;·&nbsp; **+1 RACHA** |
| **PUBLICIDAD** 🪧 | +8 a 14 &nbsp;·&nbsp; **+1 RACHA** |
| **SPONSOR** 💰 | +14 a 23 |

Las dos chicas suman racha; el **SPONSOR** no. Es plata pura, y así queda una
carta de dinero que sigue compitiendo de verdad contra atacar.

**Costo asumido:** que la plata dé racha afloja la tensión entre recursos —
antes ir por la taquilla era una jugada que no usabas para atacar, y ahora
avanza los dos medidores a la vez. Se aceptó a cambio de que la racha sea
alcanzable: sin esto se llenaba 0,20 veces por partido (y nunca en semifinal ni
final), con esto 0,50.

### Cartas que cambian las probabilidades

| Carta | Efecto |
|---|---|
| **AMARILLA** 🟨 | **-1 aguante**. La **segunda amarilla se vuelve roja** |
| **ROJA** 🟥 | **-3 aguante**, nada más. **Como mucho una por mesa** — las de más se convierten en amarillas al generar la grilla |
| **OFFSIDE** 🚫 | Carta neutra: no pasa nada, pero **gastaste la jugada** |
| **AUTOGOL RIVAL** 🎁 | Raro. **Gol a favor** de regalo |

---

## 5. La mecánica de selección

1. Mirás la grilla. Cada línea muestra sus cartas **con el resultado que
   traerían y su probabilidad**.
2. **Elegís una FILA.** El azar sortea cuál de sus cartas te toca.
3. **Sale el cartel de la jugada** al centro de la pantalla: qué carta te
   tocó, su valor contra tu stat, y qué haría. **Un click la ejecuta.**
4. Se resuelve la carta, y **el parámetro que se movió se resalta en el HUD**
   — verde si te favoreció, rojo si te perjudicó, dorado si fue plata. Si hubo
   gol, sale además el cartel de gol.
5. **La carta se vacía.** La fila queda con menos cartas, así que las que
   sobreviven **suben de probabilidad** (de 4 cartas al 25% se pasa a 3 al
   33%).
6. Se gastan **10 minutos** del reloj.

El click del paso 3 **no cambia nada del azar**: la carta ya salió sorteada.
Separa la jugada en dos tiempos para que el jugador registre qué le tocó antes
de ver el efecto — si todo pasara de una, el cambio en el HUD se perdería.

Con la **RACHA llena** podés elegir una **COLUMNA** en lugar de una fila. Es el
escape para cuando ninguna fila te cierra.

**La decisión nunca es "a qué carta entro" sino "qué reparto de resultados me
conviene comprar con el aguante que me queda".**

### Cómo se elige, según con qué estés jugando

| Entrada | Comportamiento |
|---|---|
| **Mouse** | Pasar por encima resalta la línea entera. Un click la elige |
| **Dedo** | El primer toque resalta la línea. El segundo la confirma. Tocar otra línea mueve el resaltado sin gastar nada |

Se resalta la fila completa desde cualquier lado: el botón de la izquierda o
cualquiera de sus cartas. Con la racha llena, la barra dorada hace lo mismo
con las columnas.

No se detecta "si es un celular" sino **con qué te acaban de tocar**
(`pointerType` del evento). El media query de hover miente en tablets, en
notebooks con pantalla táctil y en los emuladores; el evento real no.

### El cartel de gol

Cada gol frena el partido con un cartel a pantalla completa, anclado sobre el
mesa. Los dos casos se diferencian por **tres cosas a la vez**, no solo por
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
| **SUPLENTES** 🪑 | +1 aguante |
| **GRITO DEL DT** 📢 | +1 racha |
| **VAR** 📺 | **Destraba una carta 🔒** |
| **SEGUNDO AIRE** 💪 | +2 aguante y recupera un ❤ de máximo |

El **VAR** es el que manipula la mesa: devuelve al sorteo una carta trabada,
normalmente la buena que te cerraron y no llegaste a jugar.

---

## 7. El campeonato

Copa de eliminación directa, **5 partidos**:

| Ronda | Rival | Dificultad |
|---|---|---|
| 1 | Treintaidosavos | Rivales de valor 2-3, mesa amable |
| 2 | Octavos | Aparecen tarjetas y penales en contra |
| 3 | Cuartos | Rivales de valor 3-4, más cartas azules |
| 4 | Semifinal | Mesa cargado, poco aguante de arranque |
| 5 | **FINAL** | Rivales de valor 4-5, todo en contra |

- **Ganás** → elegís un refuerzo y pasás al mercado de ítems.
- **Empatás** → definición por penales (5 tiros, 50% cada uno).
- **Perdés** → se termina la corrida. Volvés a empezar el campeonato.

### El gol del rival baja la racha

Todo gol del rival resta **1 ⚡**: te lo hicieron y al equipo se le cae el ánimo.
Es el espejo exacto del gol propio, que la sube. **No toca el aguante.**

El motivo es una cadena que se veía fea en la mesa: gol del rival → el -1 te
funde el aguante → fundirte reparte una situación → la situación entra (38%) →
**segundo gol en la misma jugada**, sin que llegaras a hacer nada. Dos goles
seguidos no se leen como partido, se leen como castigo doble.

```
ANTES                                    AHORA
💀 Penal en contra. Gol.  0-1            💀 Penal en contra. Gol.  0-1
😮‍💨 Se te funde el equipo...
💀 Penal. La clava.       0-2
```

**Por qué la racha y no el aguante.** Bajar la racha no dispara nada, así que la
simetría queda sin el efecto colateral. Y narrativamente es lo correcto: el
aguante es el físico y un gol no te cansa, te desmoraliza.

**La excepción es el DELANTERO** 👟, que además resta aguante. No por ser gol,
sino por ser un **duelo perdido**: defensor, mediocampo y delantero cuestan
aguante cuando no te alcanza el stat, y eso vale igual aunque este además
termine en gol. La regla del duelo pesa más que la del gol.

Cómo queda la simetría completa:

| | A favor | En contra |
|---|---|---|
| **Entra** | Gol **+1 ⚡** | Gol rival **-1 ⚡** |
| **No entra** | **-1 ❤** | **+1 ⚡** |

Y el efecto en el juego: las copas bajan de 1,04% a 0,92% y la racha se llena
0,52 veces por partido en vez de 0,61. El aguante no se mueve —las fundidas
quedan igual— porque el cambio no lo toca.

El efecto sobre el partido:

| | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| Fundidas/partido **antes** | 0,48 | 1,44 | 1,46 | 2,01 | **2,50** |
| Fundidas/partido **ahora** | 0,41 | 1,19 | 1,14 | 1,69 | **2,10** |
| Goles en contra antes | 0,76 | 1,72 | 1,58 | 2,11 | 2,60 |
| Goles en contra ahora | 0,74 | 1,61 | 1,45 | 1,98 | 2,45 |

Las copas suben de 0,95% a 1,06%: afloja, pero poco. Lo que se gana no es
dificultad sino legibilidad — un gol es un gol y se termina ahí.

### La expulsión es una sola, venga de donde venga

Quedarte con diez cuesta **-3 ❤ y un corazón menos de aguante máximo**, y vale
igual para la **ROJA directa** 🟥 y para la **segunda amarilla** 🟨🟨.

| Con ❤ 4/4 | Antes | Ahora |
|---|---|---|
| ROJA | 4/4 → 2/2 · 1 situación | 4/4 → **2/2** · 1 situación |
| Doble amarilla | 4/4 → **4/4** · **0** situaciones | 4/4 → **2/2** · **1** situación |

**Y baja el máximo una sola vez**, aunque el golpe además te funda. Caso por
caso:

| Antes | Después | Situaciones | Bajadas de máximo |
|---|---|---|---|
| 4/4 | **1/3** | **0** | 1 |
| 2/4 | **2/3** | 1 | 1 |
| 1/4 | **1/3** | 1 | 1 |
| 2/2 | **1/2** | 1 | 1 |

> **Tres. Con el aguante lleno, la roja te lo vaciaba.**
>
> El recorte por el máximo nuevo estaba **arriba de todo**, antes de contar el
> golpe, y ahí te robaba un corazón que nadie cobró:
>
>     tenías 4/4
>     el máximo baja a 3   ->  el recorte te deja en 3/3   <- el corazón fantasma
>     -3                   ->  3, 2, 1, 0
>     0                    ->  se te funde el equipo + una llegada para el rival
>
> La carta promete «-3 ❤» y «-1 ❤ de máximo»: con cuatro hay que quedar en
> **uno**, no en cero. Ahora el recorte va **al final** —para el caso raro de
> terminar por encima del máximo nuevo— y en el camino normal no hace nada:
>
>     tenías 4/4  ->  el máximo baja a 3  ->  4, 3, 2, 1  ->  queda 1/3
>
> Cambia **solo cuando el aguante está lleno** (`aguante == aguanteMax`): en
> cualquier otro caso el recorte ya era una operación vacía, así que el resto
> de la tabla queda igual. Verificado en el juego con 4/4→1/3, 5/5→2/4, 4/5→1/4
> y 6/6→3/5, las cuatro **sin fundir**; y 3/4→3/3, que sí funde porque tenías
> justo tres.

> **Dos bugs encadenados, los dos encontrados jugando:**
>
> **Uno.** La bajada del máximo estaba escrita dentro de la rama de la roja, no
> en `expulsion()`. La segunda amarilla llamaba a `expulsion()` directamente y se
> saltaba ese costo — te expulsaban pero el equipo seguía entero.
>
> **Dos.** Una vez unificado, el máximo bajaba **dos o tres veces** por una sola
> carta: uno por la expulsión y otro por cada vez que ese mismo golpe te
> fundía. Con ❤1/4 la roja te dejaba en 2/2 cuando debía dejarte en **1/3**.
> Ahora `hurt()` cobra el máximo una sola vez por golpe, igual que reparte una
> sola situación de gol.

Los castigos menores **no** tocan el máximo: amarilla simple, lesión y calambre
solo restan aguante.

### Un golpe funde una sola vez

Un mismo golpe puede vaciar el aguante **una vez como mucho**. Con el máximo ya
degradado, un `-3` podía vaciarlo dos veces y repartir **dos situaciones de gol
seguidas**: dos goles posibles por una sola carta, sin que el jugador tocara
nada en el medio.

Ahora la primera fundida se cobra normal —máximo -1, aguante lleno, situación
para el rival— y si el resto del golpe vuelve a vaciarlo, el aguante se rellena
igual pero **sin repartir otra situación**. El desgaste se mantiene, la chance de
gol no se duplica.

| Con aguante | ROJA (-3 ❤) | Situaciones |
|---|---|---|
| 1/3 | → 2/2 | **1** |
| 1/2 | → 2/2 | **1** |
| 2/2 | → 1/2 | **1** |
| 4/4 | → **1/3** | **0** |

Antes, los casos `1/3` y `1/2` daban **2**. Vale para todo lo que lastima: roja,
doble amarilla, lesión y calambre.

La ROJA sigue igual en todo lo demás: **-3 ❤ y -1 de aguante máximo**.

### El aguante se degrada dentro del partido

Cada vez que se te vacía el aguante, se rellena **con un corazón menos de
máximo**: 4 → 3 → 2. La ROJA hace lo mismo (te quedaste con diez el resto del
partido). El piso es **2** (`AGUANTE_PISO`): con máximo 1 cada golpe sería gol y
el partido dejaría de tener decisiones.

**Es solo por partido.** Al empezar el siguiente el máximo vuelve a 4 —el equipo
descansa— pero el **aguante con el que llegás es el que traías**: si terminaste
en 2/2, arrancás en 2/4. El desgaste viaja, la degradación no.

Eso es lo que separa esta versión de la que se descartó hace tiempo, donde el
máximo bajaba para toda la corrida y un mal partido te dejaba inservible el
resto del campeonato. Acá la espiral existe pero se corta en el pitazo final.

**Es un endurecimiento fuerte**, sobre todo arriba:

| | R1 | R2 | R3 | R4 | R5 |
|---|---|---|---|---|---|
| Fundidas/partido **antes** | 0,46 | 1,07 | 0,98 | 1,30 | **1,50** |
| Fundidas/partido **ahora** | 0,48 | 1,41 | 1,47 | 2,01 | **2,46** |
| ❤ máximo al terminar | 3,5 | 2,7 | 2,7 | 2,4 | **2,3** |
| Goles en contra | 0,77 | 1,68 | 1,57 | 2,08 | **2,61** |

En la final te fundís 2,46 veces por partido contra 1,50, y la mayor parte del
tiempo jugás con 2 o 3 corazones en vez de 4. Las copas bajan de 1,37% a 0,87%.

### La plata de la mesa

Como mucho **3 cartas de dinero** y **€50M en total** por mesa, en valores
redondos: **5, 10, 15, 20 o 30**.

| | Antes | Ahora |
|---|---|---|
| Cartas por mesa | hasta 8 | **máx. 3** |
| Mesa más rico visto | **€340M** | **€30M** |
| Valores | rangos (€8-16M, €35-60M) | **fijos** |

Antes eran rangos sueltos que podían apilarse hasta €300M en una mesa, contra
ítems que cuestan entre 10 y 40 — la plata dejaba de ser una decisión. Y los
carteles mostraban el rango (`+€8-16M`), así que ni siquiera sabías cuánto ibas a
cobrar hasta jugarla; ahora dicen el número exacto.

**El ícono dice cuánto vale** sin leer la cifra: 🌟 FAMA lo chico (5-10), 🪧
PUBLICIDAD lo medio (15-20), 💰 SPONSOR el premio gordo (30).

Los repartos salen de una tabla explícita —`5+5+5`, `10+10+5`, `15+15`, `20+5+5`,
etc.— en vez de repartirse al azar, para que los montos sean siempre exactos.

**La economía de la corrida:**

| Nivel | En la mesa | Lo que llegás a jugar |
|---|---|---|
| 1 | €27,2M | €15,3M |
| 3 | €19,9M | €11,2M |
| 5 | €18,1M | €10,2M |

Total: **~€59M** en toda la corrida, contra los ~€93M de antes. Alcanza para
cinco ítems baratos, o para un VAR y poco más. El SEGUNDO AIRE a €30M entra en
un mercado si venís ahorrando desde la ronda anterior.

### Ninguna fila hace cuatro veces lo mismo

Elegís la fila, no la carta. Si las cuatro hacen lo mismo, **la elección deja
de tener sentido**: da igual cuál te toque.

| | Antes | Ahora |
|---|---|---|
| Filas con 4 iguales | 175-239 de 80.000 | **0** |
| Mesas con alguna | **1,2%** | **0%** |

Un 1,2% por mesa es 1 de cada 20 campeonatos — bastante como para que
aparezca jugando, y las de gol eran las más frecuentes.

Las cartas se agrupan en familias por **lo que hacen**: gol a favor, gol en
contra, duelo, plata, aguante, racha, castigo.

> **Se resuelve intercambiando, no reemplazando.** El mesa conserva
> exactamente las mismas cartas y solo cambian de lugar, así que ninguna
> garantía global se toca: los 4 duelos siguen siendo 4, el tope de plata sigue
> valiendo, el equilibrio de goles no se mueve. Verificado: los siete controles
> siguen en cero después del cambio.
>
> Va **al final de todo** porque los ajustes anteriores crean cartas nuevas —
> el equilibrio de goles convierte lo que sobra en CALAMBRE o LESIÓN, y armaba
> filas de cuatro castigos justo después de que este bloque ya había pasado.

Tres iguales sigue permitido y pasa en el **7,5%** de las filas. Ahí la elección
todavía tiene sentido: la cuarta carta es distinta.

### El empate del delantero paga 3

| | Ganás | Perdés |
|---|---|---|
| Antes | +2 ⚡ | ⚽ gol en contra |
| **Ahora** | **+3 ⚡** | ⚽ gol en contra |

Perder ese mini juego es **gol en contra**, el peor resultado de la mesa, así que
el premio tiene que estar a la altura del riesgo. Con 2 el 50/50 no compensaba y
la carta era solo un peligro que se esquivaba.

Con 3 hay algo que ganar: **alcanza para la columna**, que cuesta exactamente 3.
Ganar el mini juego te habilita el ataque dirigido en la misma jugada.

### El delantero rival no pasa de 1 al arranque

En la **clasificatoria** y en **octavos**, la carta DELANTERO RIVAL vale siempre 1:

| Tu DEF | Valor | Resultado |
|---|---|---|
| 1 *(base)* | 1 | mini juego al 50% |
| 2 o más | 1 | **lo cortás** · +1 ⚡ |

Es la carta más cara de la mesa —perder su mano a mano es **gol en contra**— y
el arranque tiene que ser accesible. Con DEF 1 sigue habiendo mini juego, así
que la carta no deja de existir; el primer refuerzo a defensa te la saca de
encima, que es una recompensa clara para esa decisión.

> **El pool ya decía 1, pero salía 3.** El valor escala con tu defensa, así que
> `['delantero',4,1,1]` daba 1 con DEF 1, 2 con DEF 3 y 3 con DEF 5. El techo
> hay que ponerlo **después** del escalado, no en el pool.

### Los duelos se ponen difíciles al final

Los valores de las cartas de duelo suben en las tres últimas rondas:

| Ronda | ATAQUE | DEFENSA |
|---|---|---|
| CLASIFICATORIA | 1-3 | 1-2 |
| OCTAVOS | 2-4 | 1-3 |
| **CUARTOS** | 2, **3**, 3, 4 | **2**, 2, 3 |
| **SEMIFINAL** | **3**, 3, **4**, 4 | 2, **3**, 3 |
| **LA FINAL** | 3, **4**, 4, **5** | 2, **3**, 3, **4** |

Van como lista explícita en vez de rango, para poder sesgar: en cuartos el 3
sale el doble que el 2 o el 4.

**Cuántos duelos ganás con ATK 4 / DEF 3**, que es a lo que llega el camino
equilibrado con un refuerzo por ronda:

| Ronda | ATK 4 | DEF 3 |
|---|---|---|
| OCTAVOS | 84% | 83% |
| CUARTOS | 87% | 83% |
| SEMIFINAL | **75%** | **67%** |
| **LA FINAL** | **50%** | **50%** |

> **Estaba al revés.** De octavos a la final los rangos eran **idénticos** —
> ataque 2-4 y defensa 1-3 en las cuatro rondas— así que el jugador subía sus
> stats y la mesa no. El camino equilibrado ganaba el **83% de los duelos en
> la final**, contra el 34% de octavos: la última ronda era la más cómoda del
> campeonato.

Ahora llegar con ATK 3 a la final significa ganar el **12%** de los duelos de
ataque. La final se volvió un examen de cómo repartiste los refuerzos, que es
justo lo que el sistema de refuerzos debería preguntar.

### El mesa no puede cargarse hacia un lado

Dos reglas sobre las cartas de gol:

- **máximo 5 por lado**
- **si un lado llega a 5, el otro tiene al menos 2**

| | Antes | Ahora |
|---|---|---|
| Máximo de un lado | **10** | **5** |
| Mesas con >5 a favor | hasta 15% | **0%** |
| Mesas con >5 en contra | hasta 14% | **0%** |
| Desbalance de 4 o más | hasta 3326 de 20.000 | **17** |

El sorteo llegaba a **7 en contra y ninguna a favor**, que es un partido perdido
antes de elegir la primera fila. El jugador no tiene forma de compensarlo: no
elige la carta, elige la fila.

El equilibrado corre **al final del armado**, igual que la garantía de dinero, y
lo que saca lo convierte en CALAMBRE, LESIÓN u OLA — tipos sin tope propio, para
no reabrir la cadena de reemplazos que ya se resolvió más arriba.

### Calambre y lesión: daño fijo

| Carta | Daño |
|---|---|
| 🦵 CALAMBRE | **-1 ❤** siempre |
| 🩹 LESIÓN | **-2 ❤** siempre |

**No escalan con nada.** Antes el rango subía con el nivel —el calambre iba de 1
a 2 y la lesión de 2 a 3— y encima se le sumaba un escalado por tus stats, así
que un calambre podía llegar a costar 3 ❤ si venías con buen equipo.

Ahora son lo que son. El jugador aprende de memoria lo que cuesta cada una y no
necesita leer el número para decidir. El resto de las cartas que lastiman sí
sigue escalando.

### Un solo conector: «o»

Las doce cartas con dos resultados usan **«o»**, no «si no»:

```
   50% GOL              50% RIVAL
   +1 ⚡  o  -1 ❤       -1 ⚡  o  +1 ⚡
```

«Si no» sugiere una secuencia —primero pasa esto, y si falla, aquello— cuando en
realidad son **dos resultados posibles del mismo sorteo**. Los mini juegos ya
usaban «o» y las de porcentaje no, así que dos cartas con la misma estructura se
leían distinto.

### El dinero en verde

| | Antes | Ahora |
|---|---|---|
| 💰 Dinero | dorado `#e8c25a` | **verde `#3ddc6b`** |
| % de la fila | dorado | **blanco al 82%** |

El dinero y la racha aparecen **en la misma línea** de la fila de acción, y el
dorado del dinero se confundía con el amarillo de la racha. Ahora usa el mismo
verde del GOL: las dos cosas que te suman comparten color.

El **porcentaje de la fila** es un dato neutro —cuántas cartas quedan por
jugar— así que va en blanco. En dorado competía con la racha y con el filo de
las cartas, que sí significan algo.

> Sale todo de la variable `--coin`, así que los **diez lugares** donde aparece
> el dinero cambiaron juntos: el medidor, el pop-up de jugada, el cartel de la
> carta, el relato, el mercado, el tutorial y el panel del 1v1.

### La aparición de las cartas de ayuda

| Carta | R1 | R2 | R3 | R4 | FINAL |
|---|---|---|---|---|---|
| 📣 HINCHADA | **46%** | 44% | 40% | 39% | 49% |
| 💧 COOLING BREAK | 64% | 38% | 39% | 38% | 46% |
| 🌊 OLA | 41% | 32% | 28% | 39% | 40% |
| 🪄 CAÑO | 23% | 19% | 16% | 16% | 15% |
| ✨ RACHA FULL | **25%** | **27%** | 16% | 16% | 15% |

*(chance de que salga al menos una en la mesa)*

La **hinchada** bajó del 79% al 46% en la clasificatoria, y la **racha full**
—que antes no existía hasta cuartos— ahora aparece en las dos primeras rondas al
25%.

> **La hinchada no bajaba aunque se le bajara el peso.** Aparecía **dos veces**
> en la lista de relleno que usa el tablero cuando tiene que reemplazar cartas,
> así que se reponía sola. Los pesos del pool son solo la mitad de la historia:
> los rellenos también cuentan.
>
> El ajuste fino se hizo con **pesos decimales** —`['hinchada', 1.6]`— porque
> entre 1 y 2 la diferencia era de 15 puntos porcentuales.

### Máximo 3 hinchadas por mesa

| Nivel | 0 | 1 | 2 | 3 | +de 3 |
|---|---|---|---|---|---|
| 1 | 22% | 34% | 27% | 17% | **0** |
| 2 | 45% | 34% | 15% | 5% | **0** |
| 3-4 | 54% | 32% | 11% | 3% | **0** |
| 5 | 46% | 33% | 15% | 6% | **0** |

La HINCHADA da **+1 ❤ sin condiciones** y es la carta de ayuda más común. Con
cuatro juntas el aguante deja de ser un recurso escaso y las decisiones pierden
peso: da lo mismo qué fila elijas si tres de las cuatro te curan.

El sobrante pasa a **COOLING BREAK** —que hace lo mismo pero cuenta aparte— o a
un castigo si la ayuda ya llegó a su techo de 5.

### Los duelos son siempre 2 y 2

Dos cartas de **ataque** (DEFENSOR, ARQUERO) y dos de **defensa** (MEDIO RIVAL,
DELANTERO RIVAL) en cada mesa, sin excepción: **100%** en los cinco niveles.

Antes solo se garantizaba *al menos uno de cada lado*, así que una mesa podía
traer 3 de ataque y 1 de defensa. Eso hacía que el refuerzo que elegiste
importara por azar y no por decisión — con 2 y 2 fijos, subir ataque o defensa
vale exactamente lo mismo en todas las mesas.

### 🪄 CAÑO

Una carta nueva: **+2 de racha**, lo mismo que la OLA, con **una sola por mesa**.

| Nivel | Aparece |
|---|---|
| 1 | 25% |
| 2-4 | 16-20% |
| 5 | 15% |

Dos caños en la misma mesa te regalarían la posibilidad de gol sin haber ganado
un duelo, que es justo lo que la racha debería costar. El sobrante se convierte
en CALAMBRE o LESIÓN — tipos sin techo propio, para no reabrir la cadena de
reemplazos.

### Siempre hay plata, menos en la final

Fuera de la final, **todos los mesas traen al menos una carta de dinero**:

| Ronda | Sin plata | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| 1 | **0%** | 18% | 26% | 26% | 30% |
| 2 | **0%** | 47% | 27% | 17% | 9% |
| 3 | **0%** | 50% | 27% | 15% | 8% |
| 4 | **0%** | 52% | 27% | 14% | 7% |
| **Final** | **23%** | 77% | — | — | — |

Antes un **19%** de los mesas no traía ninguna, y una mala racha de sorteos te
dejaba sin plata para el mercado, que es donde se arma el equipo.

El tope subió de 3 a **4 cartas**, manteniendo el máximo de **€50M** por
mesa.

> **La garantía va al final del armado**, después de todos los demás topes.
> Puesta antes, los ajustes posteriores la pisaban y quedaba un 1% de mesas
> sin plata igual.
>
> Busca en tres niveles: primero una carta de relleno (hinchada, cooling,
> offside); si no hay, cualquiera que no sea gol, duelo ni tarjeta; y como último
> recurso, un gol de un lado que tenga **3 o más**, para que sacarlo deje dos.
> Con esos tres pasos, cero fallos en 20.000 mesas por nivel.

### En la final casi no hay plata

Una sola carta de dinero como mucho, y **siempre FAMA**:

| | Resto de rondas | **La final** |
|---|---|---|
| Cartas de plata | 1,5 a 2,4 | **0,77 (máx. 1)** |
| SPONSOR 💰 | sí | **nunca** |
| Valores | €5 a €30 | **€10 o €20** |

Después de la final no hay mercado, así que la plata ahí no compra nada. Lo
único que la salva es el **+1 ⚡** que dan la fama y la publicidad — por eso el
SPONSOR queda afuera: es plata pura, sin racha, o sea una carta que en la final
no hace absolutamente nada.

**El valor va al doble** (€10 o €20 en vez de €5 o €10): si en todo el partido
sale una sola, que valga la pena jugarla. Como el ícono se elige por el monto, la
de €20 se ve como 🪧 PUBLICIDAD y la de €10 como 🌟 FAMA — las dos dan el mismo
**+1 ⚡**.

El lugar que se libera va a lo que sí importa en una final: los goles suben a
**6,6 por mesa** y las cartas de ayuda a **2,0**.

### Cada ítem dice qué hace, en íconos

| Ítem | Efecto | Precio |
|---|---|---|
| 🪑 SUPLENTES | **+1 ❤** | €10M |
| 📢 GRITO DEL DT | **+1 ⚡** | €15M |
| 💪 SEGUNDO AIRE | **+2 ❤** y recuperás un ❤ de máximo | €30M |
| 📺 VAR | **DESTRABA 🔒** | €40M |

Los mismos íconos que los medidores y las cartas: **❤ aguante**, **⚡ racha**,
**🔒 trabada**. El aguante en rojo, la racha en dorado y el VAR en azul — los
colores que ya usa el resto del juego para esas tres cosas.

Aparece en los tres lugares donde se ven los ítems: el panel del partido, la
tienda del mercado y el inventario. Antes había que leer la descripción para
saber qué movía cada uno, y en pleno partido eso no se hace.

### Un ítem que no haría nada no se gasta

Cada ítem se apaga cuando no tiene efecto, y al tocarlo dice por qué en vez de
consumirse:

| Ítem | Se apaga cuando |
|---|---|
| 🪑 SUPLENTES | el aguante está completo |
| 📢 GRITO DEL DT | la racha está llena |
| 💪 SEGUNDO AIRE | aguante **y** máximo al tope |
| 📺 VAR | no hay ninguna carta 🔒 |

Antes solo el VAR se fijaba. Los otros tres se gastaban igual con el medidor
lleno — perdías el ítem a cambio de nada, y ni siquiera te enterabas.

El caso que mejor muestra la diferencia: con el **máximo degradado a 2/2**, el
SUPLENTES se apaga —el aguante ya está al tope— pero el SEGUNDO AIRE sigue
activo, porque todavía puede recuperar máximo. Son dos ítems que suben aguante y
uno sirve y el otro no.

Se ven **apagados con borde punteado, pero siguen clickeables**: apagarlos del
todo dejaría al jugador sin saber si están rotos o si no corresponde usarlos
ahora.

### Se puede deshacer

**En el mercado**, lo que comprás en esa ronda se marca en verde y trae un **✕**
para devolverlo con reintegro completo. Lo que traías de rondas anteriores no lo
tiene: ya está jugado. Al pasar de ronda, lo comprado queda firme.

Sin eso, gastar €30M en el ítem equivocado era irreversible y empujaba a no
comprar nada por las dudas — lo contrario de lo que un mercado tiene que
provocar.

**Durante el partido**, el **VAR** —que pide apuntar a una carta— se cancela
tocándolo de nuevo o con **Escape**. Mientras apuntás, el
ítem queda encendido en dorado y latiendo, y ese click lo apaga sin gastarlo.
Antes seleccionarlo te obligaba a usarlo: no había forma de arrepentirse.

### El SEGUNDO AIRE 💪

€30M, y el único que **devuelve máximo perdido**: +2 de aguante y un ❤ de máximo
si lo perdiste. Es la salida de una fundida en cadena — cuando venís 1/2 y sabés
que el próximo golpe es otro gol.

> **Se llamaba NUEVO REFUERZO y no se entendía**, por una razón concreta: el
> juego ya usa "refuerzo" para el +1 de ATAQUE o DEFENSA que elegís en el
> vestuario. Dos cosas distintas con el mismo nombre, y encima este ítem no sube
> stats. "Segundo aire" es una expresión futbolera real y describe exactamente
> lo que hace: sacar fuerzas cuando ya no quedaban.

### Los topes de la mesa, y el orden en que corren

Seis reglas limitan qué puede haber de más en una mesa. Todas verificadas en
cero sobre 20.000 mesas por nivel:

| Regla | Tope |
|---|---|
| Cartas de plata | 3 (1 en la final) |
| Cartas que reponen aguante | **5** |
| OFFSIDE | 2 |
| Cartas de duelo | exactamente 4 |
| Goles directos · penales | 2 de cada uno |
| Tarjetas | 0 o 2 amarillas · hasta 2 rojas |

**El orden importa más que las reglas.** Cada tope reemplaza lo que sobra por
otro tipo de carta, así que un tope que corre después puede romper al anterior.
Pasó tres veces seguidas al implementar el de aguante:

1. El **relleno de duelos** generaba hinchada y cooling → el tope corría antes y no las veía
2. El **techo del offside** convertía sus sobrantes en hinchada → volvía a pasarse
3. El **techo de la plata** hacía lo mismo → seguía pasándose

La solución fue ordenarlos en cadena —plata, después offside, después aguante— y
que **los últimos reemplacen por tipos sin techo propio**: CALAMBRE y LESIÓN.
Mandar el sobrante a una carta que sí tiene tope reabre el problema en el
siguiente eslabón.

### La carta que no hace nada

El **OFFSIDE** 🚫 tiene techo de **2 por mesa**. No es una carta inofensiva:
te come una de las nueve jugadas sin darte nada, que es un castigo encubierto —
un 11% del partido, sin números en el cartel que lo delaten.

| Nivel | 3 o más antes | ahora | promedio | jugadas perdidas |
|---|---|---|---|---|
| 1 | **33%** | **0%** | 0,87 | 0,49 de 9 |
| 3 | 9% | **0%** | 0,48 | 0,27 |
| 5 | 7% | **0%** | 0,40 | 0,23 |

**La causa del exceso era nuestra.** Al fijar los duelos en 3-4, el sobrante se
convertía en `hinchada` u `offside` al 50%, y como en la primera ronda sobran
casi tres duelos por mesa, eso llenaba la mesa de cartas muertas. Ahora
el sobrante se reparte entre siete opciones —hinchada, cooling break, taquilla,
publicidad y solo una de offside— así que la fuente se secó antes de aplicar el
techo.

> **Detalle de implementación:** el techo va **al final** de `buildGrid`, después
> del ajuste de duelos. Puesto antes no servía de nada, porque el ajuste genera
> offside después de aplicarlo — un error que apareció al medir y que la
> validación de sintaxis no detecta.

### Las tarjetas

**Amarillas: 0 o exactamente 2.** Una sola es una carta inofensiva disfrazada
de amenaza —la amarilla solo duele de a dos, porque la segunda es roja— y tres
serían una trampa que no se puede esquivar en nueve jugadas.

**Rojas: hasta 2, pero solo 1 si hay amarillas.** Un mesa con dos amarillas ya
trae su propia forma de terminar expulsado; sumarle dos rojas encima es apilar
castigos sobre la misma idea.

Las cinco combinaciones posibles, medidas sobre 20.000 mesas por nivel:

| Combinación | R3 | R5 |
|---|---|---|
| Sin tarjetas | 47% | 52% |
| **2 amarillas** | 36% | 33% |
| 1 roja | 9% | 9% |
| **2 amarillas + 1 roja** | 7% | 6% |
| **2 rojas** | 1% | 1% |

Cero mesas con una amarilla sola, con tres amarillas, con tres rojas o con
dos rojas y amarillas juntas.

> **Cambió respecto de la versión anterior**, donde amarillas y roja no podían
> convivir: mandaba la roja y las amarillas se convertían. Ahora conviven,
> siempre que la roja sea una sola. El mesa puede traer las dos amenazas a la
> vez sin volverse imposible.

### La amarilla acumulada se muestra

Con el CAMBIO fuera del mercado, **no hay forma de limpiar una amarilla dentro
del partido**. Si te sacan la primera, la segunda es roja (-3 ❤) y no hay
escapatoria. **Se limpian al terminar el partido**: cada uno arranca con el
equipo sin tarjetas, a diferencia del aguante y la racha, que sí viajan.

Como cambia el valor de una carta entera de la mesa, tiene que verse. Cuando
arrastrás una amarilla aparece un aviso en el panel del equipo, debajo del
presupuesto: recuadro amarillo de tarjeta con un brillo suave, **AMARILLA** y
debajo *"La próxima es roja: -3 ❤"*. Desaparece solo al terminar el partido.

Va en amarillo y no en el rojo del resto de las advertencias, porque es la misma
señal que ves en la cancha. Y al mismo tiempo la carta de amarilla de la mesa
cambia su cartel de `-1 ❤` a `¡ROJA! -3 ❤`, así que la amenaza se lee en los dos
lugares.

Pesa menos de lo que suena, porque la amarilla es poco frecuente:

| Nivel | Amarillas por mesa | Probabilidad de comerse la roja |
|---|---|---|
| 1 | 0,0 | 0% |
| 2 | 0,7 | 5,0% |
| 3 | 0,6 | 3,9% |
| 5 | 0,5 | 3,0% |

Uno de cada 25 partidos, más o menos. Lo que cambia es la lectura de la mesa:
después de la primera amarilla, esa carta pasa a mostrar `¡ROJA! -3 ❤` y se
vuelve la peor de la mesa, sin nada que puedas hacer para desactivarla.

### Por qué se sacó la FALTA TÁCTICA

Borraba de la mesa la carta que eligieras. Sobre el papel era el ítem más
interesante —manipular probabilidades en vez de hacer daño— pero en la práctica
**no era una decisión**: siempre se borra la peor carta, que en general es un
gol del rival. Un ítem que se usa siempre igual no agrega nada más que un click.

El VAR se queda porque su elección está acotada: solo actúa sobre las cartas
trabadas, que son cuatro o cinco, y cuál conviene depende de qué te trabaron y
en qué fila.

### El VAR 📺

El ítem más caro del mercado (€40M) y el único que **devuelve al juego** en vez
de sacar: tocás una carta trabada 🔒 y vuelve a poder salir sorteada. La
jugada estaba anulada, la revisan, la habilitan.

Devuelve al sorteo la carta buena que te trabaron y no llegaste a jugar. Al
apuntarlo, solo responden las trabadas: se
encienden en dorado, recuperan el contenido a la vista y el candado pasa a 🔓,
para que veas cuál estás por revisar. Si no hay ninguna trabada, avisa y no se
gasta.

**El VAR dejó de ser carta.** Antes existía como carta de la mesa (hacía
repetir la jugada en otra carta al azar) y se sacó para liberar el nombre: dos
cosas distintas llamadas igual se pisan, y encima la carta era azar puro
mientras el ítem es una decisión. El peso que ocupaba en los pools quedó
repartido entre el resto de las cartas de castigo.

> Nota para el código: la clave interna del ítem es `revision`, no `var`, porque
> `var` es palabra reservada de JavaScript. El nombre que ve el jugador es VAR.

### El dinero se cuenta en millones

Se muestra como **€10M, €25M, €50M**, la escala de los pases reales. La escala
interna no cambió —un punto es un millón—, así que todo el balance medido sigue
valiendo: lo único distinto es cómo se lee.

Los precios están **redondeados a múltiplos de 5**, que es lo que
hace comparable de un vistazo cuánto tenés contra cuánto cuesta lo que querés:

| Ítem | Precio | Qué hace |
|---|---|---|
| **SUPLENTES** 🪑 | €10M | +1 de aguante |
| **GRITO DEL DT** 📢 | €15M | +1 de racha |
| **VAR** 📺 | €40M | Destraba una carta 🔒 y vuelve a jugarse |

La escala sigue lo que cada uno mueve. **Suplentes y grito valen lo mismo**
porque hacen lo mismo de los dos lados: un paso de aguante y un paso de racha, y
los dos medidores son gemelos. De ahí para arriba se paga por lo que ninguna
carta te da: el **VAR** devuelve al sorteo una carta trabada, y el **NUEVO
SEGUNDO AIRE** es el único que recupera aguante máximo perdido.

**El CAMBIO se eliminó.** Daba +2 de aguante y limpiaba las amarillas por €35M —
era el ítem más caro y consumía casi todo el presupuesto de la final. Sin él, el
mercado son cuatro ítems y el tope baja a €30M: alcanza para combinar dos cosas
en vez de gastar todo en una.

**Ganar un partido no paga.** No hay premio por ronda: el dinero **solo** se
saca de las cartas de taquilla durante el partido. Eso devuelve la tensión de
recursos que el premio había aflojado — si no gastás jugadas en ir a buscar
plata, llegás al mercado sin nada, por bien que hayas jugado.

Como la taquilla pasó a ser la única fuente, paga como tal:

| Carta | Da |
|---|---|
| **FAMA** 🌟 | €8-16M · +1 ⚡ |
| **PUBLICIDAD** 🪧 | €16-28M · +1 ⚡ |
| **SPONSOR** 💰 | €35-60M |

Con eso juntás unos **€93M** antes de la final, contra los ~€110M que había con
premios — un poco más ajustado, y todo ganado en la cancha.

Las **ganancias de las cartas no se redondean** (fama €3-7M, publicidad
€6-11M, sponsor €14-23M): ahí la variabilidad es parte de la tensión, y los
carteles de la mesa ahora muestran el rango en vez de un `+ 🪙` que no decía
nada.

El redondeo cuesta muy poco: 2,22% de copas contra 2,38% con los valores
anteriores.

### Entre partidos: refuerzo primero, mercado después

Son dos pantallas y dos monedas distintas.

**1. El vestuario — elegís un refuerzo.** Una sola decisión, sin precio:
**+1 ATAQUE** o **+1 DEFENSA**. Pasa en los cuatro intervalos, así que llegás a
la final con 4 puntos repartidos como quieras.

Los stats **no se compran**. Antes se fichaban con plata, y eso ataba la
progresión a la suerte con las cartas de dinero: una corrida sin sponsors te
dejaba sin equipo y sin arreglo posible. Ahora la progresión está garantizada y
lo único que elegís es de qué lado.

**2. El mercado — la plata solo compra ítems.** La pantalla muestra primero
**cómo llega el equipo** (aguante y racha), después **qué ítems ya tenés
guardados**, y recién ahí el presupuesto y la lista de compra. Cada botón repite
el `TENÉS x2` al lado del nombre, porque es en el botón donde se decide: sin ese
dato estarías comprando a ciegas, sin saber si te faltan GRITOS para llenar la
racha o SUPLENTES para aguantar la ronda.

El resto de la economía: los stats ya no se compran y los partidos no pagan
premio, así que **todo el presupuesto sale de las cartas de taquilla**. Se
juntan unos €93M en la corrida, alcanza para 8 o 9 ítems, y llegás al mercado
previo a la final con ~€30M: un VAR, o una FALTA y un GRITO, o tres SUPLENTES.
Alcanza para combinar dos cosas, no para tres.

---

## 8. Por qué esto funciona

- **La suerte está expuesta, no escondida.** Ves los porcentajes exactos y
  decidís igual. Perder no se siente injusto: elegiste ese riesgo.
- **Tres recursos que compiten.** Ir por la taquilla es una jugada que no usás
  para atacar. Cada decisión cuesta algo.
- **La progresión cambia la mesa sin cambiar la mesa.** El mismo rival de
  valor 3 pasa de ser una amenaza a ser un trámite cuando subís el stat.
- **Es simple de leer y difícil de dominar.** Una sola pregunta por turno: qué
  línea elijo.

---

## 9. Decisiones abiertas

- Tamaño de la grilla: **4×4** para arrancar. Podría ser 5×5 en rondas
  avanzadas.
- Un partido son **90 minutos = 9 jugadas de 10 minutos**, igual en las cinco
  rondas. La constante es `MIN_POR_TURNO = 10`.
- Aguante inicial: **4**, igual que la racha (`AGUANTE_BASE` / `RACHA_MAX`).
- Stats iniciales: propuesta **ATAQUE 2 · DEFENSA 1**.
- ¿Se ve la mesa del rival o solo el tuyo? Propuesta: **un solo mesa
  compartido**, como en Sol Cesto.


---

# MODO 1 vs 1

Flujo paralelo al campeonato. **Mesa compartido**: 8 turnos cada uno,
alternando, hasta agotar las 16 cartas. La carta que te sirve te la puede
sacar el otro antes de que te toque — eso es lo que hace distinto al modo.

Queda afuera el reloj de 90 minutos y las cartas trabadas: existen para meter
presión en un solitario, y acá la presión la pone el rival.

## Aviso de beta

El botón de la pantalla de inicio lleva una etiqueta dorada `BETA`, y al tocarlo
—**antes** de crear los equipos— sale un aviso:

```
              🚧
          VERSIÓN
           BETA

El modo 1 vs 1 está recién salido del horno
y puede tener errores. Si encontrás alguno,
escribime y lo arreglo.

  CÓMO SE JUEGA
  · Un solo mesa para los dos: 8 turnos cada uno
  · La carta que te sirve te la puede sacar el otro
  · Entretiempo a la mitad: mercado y +2 de plantel
  · Un partido o al mejor de 3

  [ ENTENDIDO, VAMOS ]   [ VOLVER ]
```

Aprovecha el momento para explicar las cuatro reglas que hacen distinto al modo:
alguien que viene del campeonato se encuentra con una mesa que se agota entre
dos y sin reloj de 90 minutos, y conviene decírselo antes y no a mitad del
partido.

El campeonato no pasa por ninguna pantalla intermedia: sigue entrando directo.

## El reloj cuenta los 16 turnos

El cronómetro del 1v1 tiene **16 porciones** —8 por jugador— y se llena de a una
por turno jugado, en vez de vaciarse como en el campeonato:

| Turno | Minuto |
|---|---|
| 0 | 0' |
| 4 | 23' |
| **8** | **45'** ← el entretiempo |
| 12 | 68' |
| 16 | 90' |

Los 90 minutos se reparten entre 16 turnos, así que cada uno vale **5,6 minutos**
en vez de los 10 del campeonato. El entretiempo cae exacto en el 45.

El aire entre porciones baja de 3,2° a **1,6°** cuando hay más de 12: con 16
porciones, el hueco original se comía casi un quinto de cada una.

El aviso del final sigue igual — dorado a falta de dos turnos, rojo en el último.

## Los dos jugadores a la vista

Los paneles laterales muestran a **los dos enteros**: local a la izquierda,
visitante a la derecha, cada uno con su escudo, goles, aguante, racha, stats,
plata e ítems.

```
┌──────────────────────┐        ┌──────────────────────┐
│ 🛡 BOCA           1  │        │ 🛡 RIVER          2  │
│ SU TURNO             │        │                      │
│ ❤ ❤❤❤❤              │        │ ❤ ❤❤❤                │
│ ⚡ ⚡⚡⚡⚡              │        │ ⚡ ⚡⚡⚡⚡              │
│ 3 ATAQUE  2 DEFENSA  │        │ 2 ATAQUE  3 DEFENSA  │
│              €25M    │        │              €10M    │
│ ────────────────     │        │ ────────────────     │
│ 🪑2  📢1             │        │ 📺1                  │
└──────────────────────┘        │ 🟨 amarilla · la...  │
   ↑ resaltado                  └──────────────────────┘
```

**El panel del que juega se enciende entero** —borde dorado, fondo tenue y un
`SU TURNO` que parpadea— y el otro baja al 55% de opacidad. Es la señal
principal de a quién le toca, más visible que el resaltado del marcador.

Los corazones muestran **el máximo de cada uno**: si al visitante lo degradaron a
3, se ven tres. Sin esto había que adivinar con cuánto venía el otro, que en un
juego donde la mesa es compartido es justamente lo que hay que saber para
elegir fila.

En el campeonato estos paneles se ocultan y vuelven los de siempre: ÍTEMS a la
izquierda, TU EQUIPO y PLANTEL a la derecha.

## Volver a jugar reparte de nuevo

**JUGAR OTRA VEZ** vuelve a la pantalla de reparto, con los nombres y escudos ya
cargados. Antes creaba los dos equipos de cero y arrancaban en **1/1** sin que
nadie eligiera nada: los 3 puntos se perdían.

> **Bug del marcador, y por qué costó encontrarlo.** El marcador mostraba
> resultados viejos durante el partido. La causa final no era la lógica de
> turnos sino un `else` sin llaves:
>
> ```js
> } else
> $('gU').textContent = G.gU;
> $('gC').textContent = G.gC;   // ← se ejecutaba SIEMPRE
> ```
>
> La segunda línea quedaba fuera del `else` y pisaba el marcador del visitante
> con `G.gC`, que en el 1v1 son "los goles del que no juega" y cambian de dueño
> en cada turno. Por eso fallaba turno sí, turno no.
>
> De paso se ordenó dónde viven los goles: ahora `scoreU` y `scoreC` los anotan
> en el jugador **en el mismo momento del gol**, y `guardarTurno` ya no los
> copia — esa copia doble se los asignaba al equipo equivocado si el turno ya
> había cambiado.

## Los stats se reparten a mano

Cada uno arranca en **1/1** y reparte **3 puntos**; en el entretiempo suma **2
más**. El techo es 5.

**Las cartas de duelo valen 2, 3, 4 o 5 al azar, sin escalado.** El mesa es
compartido, así que escalarlo contra los stats de uno sería injusto para el otro.
Y sin escalado cada punto se siente:

| Tu stat | Ganás | Empate 50/50 | Perdés | **Efectivo** |
|---|---|---|---|---|
| 2 | 0% | 25% | 75% | **12,5%** |
| 3 | 25% | 25% | 50% | **37,5%** |
| 4 | 50% | 25% | 25% | **62,5%** |
| 5 | 75% | 25% | 0% | **87,5%** |

Cada punto vale exactamente **25% más de duelos ganados** — lo contrario del
campeonato, donde el escalado se come la progresión. El repartidor muestra ese
porcentaje al lado de cada barra: sin el número, elegir entre 3/2 y 2/3 es a
ciegas.

## El sorteo

El árbitro tira la moneda al empezar cada partido y antes de los penales. Canta
el visitante, y el que gana saca. El segundo tiempo lo abre el otro.

### El penal suelto y el de la tanda

El mismo pop-up sirve para los dos, y se distinguen por `ronda`:

| | Penal de partido | Penal de la tanda |
|---|---|---|
| Cuándo | la posibilidad de gol saca PENAL | empate en la final o en el 1v1 |
| Etiqueta | `POSIBILIDAD DE GOL` | `PENAL 1 DE 5` |
| Título | `🎯 PENAL` | `PATEA RIVER` |
| Tabla de la serie | — | **sí** |
| Resultado | `EL PENAL` | `PATEÓ BOCA` |

> El penal de partido mostraba **«PENAL 1 DE 5»** y el tablero de la tanda, que
> ahí no existen: es un penal suelto dentro del partido, no parte de una serie.
> Pasaba porque reusa la misma función y se le pasaban los valores de la tanda.

## La tanda de penales

El penal tiene **dos modos**, y en el campeonato alternás entre los dos:

| Modo | Elegís | Resultado |
|---|---|---|
| **PATEAR** | a qué palo la mandás | gol si el arquero vuela para el otro lado |
| **ATAJAR** | adónde vuela **tu arquero** | atajada si le acertás al tiro |

Antes el penal del rival se resolvía solo —`chance(.667)` y a otra cosa— y vos
mirabas. **La probabilidad es exactamente la misma** (1 de 3 al arquero, 2 de 3
al que patea), pero ahora la jugás.

| Situación | Cartel | Color |
|---|---|---|
| Pateás y entra | ⚽ `¡GOL!` | **verde** |
| Pateás y la atajan | 🧤 `ATAJADO` | rojo |
| Atajás vos | 🧤 `¡ATAJADA!` | **verde** |
| Te convierten | ⚽ `GOL RIVAL` | rojo |

> **El CSS los tenía invertidos.** Las clases `salvado` y `gol` venían del penal
> viejo, donde `gol` significaba *"entró la tuya"* y por eso se pintaba verde.
> Cuando el penal pasó a servir también para **atajar**, ese nombre dejó de
> tener un significado fijo: ahora `salvado` es *te fue bien* y `gol` es *te fue
> mal*, sin importar quién marcó.

Y el pop-up de resultado del 1v1 se pinta igual: **verde si ganó el local, rojo
si ganó el visitante**, en vez del dorado neutro que usaba para los dos.

La animación acompaña: la pelota vuela al palo elegido y el guante al suyo. Si
coinciden, **la pelota frena en la mano** con un halo dorado en vez de seguir a
la red.

En el **1v1** los dos patean —cada jugador elige su palo cuando le toca— porque
ahí no hay máquina a la que atajarle.

El mesa de la tanda marca **⚽ el convertido** y **✖ el errado**, y los dos
equipos van **siempre en el mismo orden** —el local arriba— con una flecha en el
que está por patear:

```
  ▸ BOCA           ⚽⚽✖     2
    RIVER          ⚽✖       1
```

> **Estaba invertido y costaba verlo.** Las filas se ordenaban por *quién patea
> primero*, no por equipo: cuando el rival ganaba la moneda, tu equipo aparecía
> abajo y el marcador se leía al revés. Ahora el orden es fijo y lo que cambia es
> la flecha.

Los carteles también se aclararon. Antes decían `¡GOL!` / `ATAJADO` sin nombrar
al que pateó, y con el rival pateando el mismo `⚽` significaba lo contrario:

| Quién patea | Convierte | Erra |
|---|---|---|
| **Vos** | ⚽ `¡GOL!` en verde | ✖ `LA ERRÓ` en rojo |
| **El rival** | ⚽ `CONVIRTIÓ` en **rojo** | ✖ `ERRÓ` en **verde** |

Cada cartel encabeza con **PATEÓ + el nombre**, así el color y el texto siempre
se leen desde tu lado.

Y la moneda dice explícitamente **EL QUE GANA PATEA PRIMERO**, con el relato
confirmándolo: *"Patea primero BOCA"*.



Como en la cancha: **cinco cada uno**, alternando, con corte anticipado cuando
al que va perdiendo ya no le alcanzan los que le quedan. Si terminan empatados,
**muerte súbita** de a uno por cabeza.

La misma tanda se usa en **la final del campeonato** —y solo ahí—. El resto de
las rondas sigue definiéndose con el penal único: una final merece su tanda, una
ronda de paso no. En el campeonato el rival patea solo (66,7%, igual que el penal
único) y vos elegís palo; en el 1v1 los dos eligen.

| Situación | |
|---|---|
| 3-0 y le faltan 2 | **corta** |
| 3-0 y le faltan 3 | sigue (puede empatar) |
| 4-0 y le falta 1 | **corta** |
| 5-5 | muerte súbita |

El que patea elige el palo; el arquero vuela al azar. El mesa de la tanda
—● entró, ○ erró— está a la vista en cada tiro.

## Lo demás

- **Entretiempo** tras el turno 8: los dos pasan por el mercado, uno después del
  otro, y reparten sus +2 puntos
- **Ítems de arranque**: 1 SUPLENTES y 1 GRITO DEL DT para cada uno
- **Plata más generosa** que el campeonato: tope de €90M por mesa contra €50M
- **Sin cartas de dinero** en el último partido de una serie: no queda mercado
  donde gastarla
- **Un partido o al mejor de 3**, a elección

## Las señales que laten

Cuatro cosas del tablero laten para pedir atención: el **último corazón**, la
**racha llena**, las **cuatro columnas habilitadas** y el **cartel de
posibilidad de gol**. Las cuatro funcionaban, pero laten poco: todas cambiaban
*brillo y sombra* y **ninguna cambiaba de tamaño**, que es lo que el ojo detecta
primero. Con el tablero lleno de cartas encendidas, se perdían.

Ahora hay **dos intensidades**, según cuánto tenga que gritar cada una.

### Un pulso parejo — la racha y las columnas

Son cinco cosas que aparecen **juntas** —la racha se llena y en el mismo momento
se habilitan las cuatro columnas— así que no pueden competir entre ellas. Late
lo mismo de siempre, con más volumen: halos al doble, bordes un poco más gruesos
y un crecimiento chico.

| | Antes | Ahora |
|---|---|---|
| racha llena (`rachaviva`) | halo 14px al 45% | halo 20px al 60% + `scale(1.025)` |
| columnas (`titilarBorde`) | borde 1→2px, halo 26px al 60% | borde 1→2.5px, halo 30px al 75% + crecimiento |

Las columnas crecen **1,2% de ancho y 5,5% de alto**, no un 3% parejo. Son
`flex:1` sobre un `gap:6px` **fijo**, así que el botón crece con la pantalla
pero el hueco no: con un 3% parejo quedaban 0,4px entre botón y botón en 1366 y
en 1920 —244px cada uno— **se superponían 1,4px** en el pico. El crecimiento que
se ve pasa a ser el alto, que es a donde el botón tiene lugar de sobra.

### Dos golpes y una pausa — el corazón y el gol

Las dos que sí tienen que **interrumpir** lo que estés mirando. En vez de una
onda pareja, un pulso de verdad: un golpe fuerte, uno más chico, y descanso.

```
0%   14%    28%   42%      60% ────────── 100%
│     ▲      │     ▲        │
│    fuerte  │   más chico  └─ y descansa más de medio ciclo
```

El ritmo irregular es lo que las hace imposibles de ignorar **sin subirles el
brillo hasta molestar**: el pico dura poco y después se queda quieto.

- `latido` — el último corazón (`scale(1.22)` + `brightness(1.7)` en el pico) y
  el botón USAR del cartel
- `golvivo` — el cartel entero: halo verde de 34px y `scale(1.03)`

El **reloj** de las dos últimas jugadas se queda con el titileo parejo de
siempre: es texto, y un número que cambia de tamaño mientras corre el reloj se
lee peor, no mejor.

### Lo que hubo que resolver para que crecieran

- **El levantón del hover del cartel dejó de funcionar.** Estaba en
  `transform:translateY(-2px)` y la animación —que ahora también anima
  `transform`— le gana siempre. Pasó a la propiedad `translate`, que es aparte
  y **se compone** con el `transform` de la animación, así que el cartel late y
  se levanta a la vez. En touch, donde el `:hover` se queda pegado, el bloque
  `(hover:none)` lo devuelve a `translate:none`.
- **`prefers-reduced-motion`.** Antes eran pulsos de brillo y sombra y podían
  quedar afuera; el tamaño es justo lo que la preferencia pide que no se mueva.
  Ahora las cinco se apagan y la señal la sigue dando la sombra, **quieta**: se
  ve igual de encendido, pero no se mueve.

### Y el cartel, centrado en mobile

En mobile el cartel esconde la descripción y quedan solo el ícono, el título y
el botón. Ahora los tres van **juntos en el medio**, como un grupo.

El que lo impedía era `.gb-txt{flex:1}`. Se quedaba con **todo** el ancho
sobrante, y eso hacía dos cosas a la vez: el título salía pegado a la izquierda
de una caja enorme, y el botón USAR terminaba empujado contra el borde derecho,
lejos del texto al que pertenece. Un `text-align:center` arreglaba lo primero
pero dejaba el botón donde estaba —el hueco seguía existiendo, solo que ahora
adentro de la caja del texto—.

La caja pasa a `flex:0 1 auto`: mide lo que mide el texto, no más, y el
`justify-content:center` que el cartel ya tenía centra a los tres como un solo
bloque. En 390px quedan 110px de aire parejo a cada lado; en 320px, 75px, con el
título todavía en una sola línea. En desktop la descripción vuelve, `.gb-txt`
recupera su `flex:1` y con él la alineación a la izquierda de siempre.

## Los emojis que quedaban en el flujo de la racha

Usar la racha llena son cuatro pantallas seguidas, y dos ya mostraban la
ilustración de las cartas mientras las otras seguían con los emoji del
teclado. La peor era la del medio: la ficha te mostraba **la foto del PENAL** y
tres segundos después el pop-up que anuncia esa misma carta te mostraba **un 🎯
de 66 píxeles**. Misma carta, dos dibujos distintos, con tres segundos de
diferencia.

### La foto de la carta en el pop-up de qué salió

El cambio grande, y va para los dos lados —la racha llena tuya y la fundida del
rival—. Es el **mismo molde del pop-up del mini juego**: foto a sangre arriba,
nombre grande abajo en el color del resultado. `.sit.con-art` toma el padding
de `.sit.mam`, así los márgenes negativos de `.mam-art` —que están calculados
contra ese padding— sirven para los dos sin duplicar nada.

Con eso los **dos pop-ups de acción del juego pasan a ser la misma pieza**, y la
carta que viste frenar en la ruleta es la que ves acá.

La pantalla siguiente —¡GOL! / LA ERRASTE— no se toca: sigue con su
`icoDesenlace` animado, que ya estaba bien.

#### De qué carta sale la foto

```
artSituacion(key, favor)  ->  favor ? la carta tuya : ART_RIVAL[key] || la tuya
```

Hoy **solo el córner tiene arte propio del rival** (10KB contra los 6 de la
tuya). `penalC` y `libreC` son alias que apuntan a las tuyas y `pasegolC` no
tiene imagen, así que las otras cuatro caen en la carta tuya. Cuando lleguen
las cinco del rival se cambian en `ART_RIVAL` y el pop-up no se toca.

### Y la pelota de los carteles

Los otros tres lugares que hablan de la posibilidad de gol —el cartel verde de
la mesa, el título de la ficha y las tarjetas de los dos avisos— mostraban un
**⚽ del sistema**, que además es azul y blanco y no pega con la paleta.

> **`ico_gol` no servía.** El archivo trae un `ico_gol` y un `ico_golrival`
> guardados y sin un solo uso, y la idea era usar esos. Pero al probarlos en
> tamaño resultó que **no son un ícono, son una chapa**: un escudo verde con un
> arco adentro, aro de luz, fondo de tribuna y la palabra GOL escrita, en
> 101x128. Se lee de 29px para arriba; abajo de eso es una mancha verde. Y los
> cuatro lugares miden **16, 19, 24 y 29**.

La pelota que sí funciona en todos ya estaba dibujada: **`pelotaSVG()`**, la
misma del penal y de los cuatro mini juegos. Es vector, así que es nítida a 16
y a 46, y es el dibujo con el que el juego ya cuenta las jugadas. `icoPelota()`
la devuelve suelta, medida en `em`, así cada lugar la escala con su propio
`font-size` y no hay un tamaño escrito cuatro veces.

La chapa queda guardada para cuando haya un lugar grande donde luzca.

**El 🎒 de GUARDARLA** pasa al rayo de la racha: guardarla es quedarte con la
racha, y el rayo sí es un ícono limpio que baja de tamaño sin romperse.

**El 🎮 de la chapa MINI JUEGO se queda.** Es exactamente la misma que llevan
las cartas del tablero; cambiarla acá la desalinearía de la mesa, que es lo
contrario de lo que hace todo el resto de este cambio.

## El botón de columna mide siempre lo mismo

Cuando en una columna queda **una sola carta viva**, el porcentaje pasa de
`25%` a `100%` y el texto se lleva un carácter más. Ese carácter tiraba el
botón a dos renglones: la fila crecía de **27px a 48** y **empujaba el
casillero entero hacia abajo**, en el medio de la partida. En un 320 pasaba
incluso con el 25%, así que la mesa arrancaba corrida.

Tres cosas lo dejan quieto:

| | |
|---|---|
| `white-space:nowrap` | nunca hay un segundo renglón, así que el alto no depende del texto |
| `line-height` fijo | el alto tampoco depende de la fuente que llegue a cargar |
| `overflow:hidden` | si algún día un texto no entra, se recorta — no rompe la mesa |

**Y el rayo se achica.** A `1.85em` era más alto que el renglón, así que era él
—y no el texto— el que decidía el alto del botón. Dentro del botón de columna
va a `1.4em`.

### El tamaño lo decide el ancho de pantalla

```css
font-size: min(11px, 2.8vw)
```

Los cuatro botones se reparten el ancho de la mesa, así que **el hueco cambia
con la pantalla** y un tamaño fijo que entra en un 414 no entra en un 320. El
tope de 11px es para que en una tablet en vertical no se agrande de más, y el
interletrado se va: en catorce caracteres se comía 3,5px él solo.

Medido con el texto más largo del juego —`C4 · 100% −3⚡`— contra la caja de
contenido del botón, con el latido congelado:

| ancho | tamaño | sobra | alto del botón | tope de la mesa |
|---|---|---|---|---|
| 320 | 8,96px | 3,1px | 25,64px | 246,2 |
| 360 | 10,08px | 5,0px | 27,50px | 227,1 |
| 390 | 10,92px | 6,3px | 28,63px | 228,2 |
| 414 | 11,00px | 9,1px | 28,81px | 228,4 |
| 1366 | 13,00px | 48,9px | 35,88px | 238,9 |

En los cinco, el alto del botón y el tope de la mesa son **idénticos** con 25,
33, 50 y 100%.

## La pantalla de arranque: la marquesina y el modo principal

Era **el logo y cuatro botones iguales apilados**, y tenía dos problemas a la
vez. Uno: los cuatro modos **pesaban lo mismo** —CAMPEONATO, que es el modo de
verdad, el que dura cinco rondas, se distinguía solo por el borde dorado, que en
un teléfono se pierde—. Dos: era **la única pantalla del juego** que no usaba el
molde de todas las demás —foto a sangre arriba, título encima del degradado—, así
que el logo flotaba sobre un panel liso y la cancha del fondo quedaba tapada por
la tarjeta.

### Arriba, la marquesina

La misma pieza que ya usan el aviso de RACHA LLENA, el mini juego y la situación
de gol. La foto es **el estadio desde arriba**, y va recortada de cerca: la
imagen entera se ve lejos —media ciudad alrededor del estadio— así que se agranda
un 140% y se corre hacia abajo, hasta que quedan el cuenco de la tribuna y el
césped.

El velo lleva **dos capas** a propósito:

| | |
|---|---|
| lineal, de arriba abajo | baja el brillo del césped para que el logo no compita |
| radial, desde abajo | apoya el logo sobre una sombra, no sobre el pasto |

Con una sola capa, o el logo quedaba flotando sobre verde claro, o la foto entera
se veía apagada.

**El logo se mide contra la marquesina, no contra la pantalla.** Al principio
tenía su propio `clamp` en `vh` y había que mantener los dos números en sincro
a mano: cada vez que cambiaba el alto del banner, el logo quedaba flotando en el
medio o rozando el borde. Ahora es `calc(100% - 12px)` del banner, así que lo
llena entero y **el único número que hay que tocar es el de arriba**. El
`max-width` queda de seguro: en una pantalla muy angosta manda el ancho y el
logo baja de alto solo.

Con eso el logo es la pieza más grande de la pantalla en todos los tamaños —
más que el recuadro de CAMPEONATO, que es lo que tiene que pasar en una
portada:

| Pantalla | Logo | Recuadro |
|---|---|---|
| 320 x 568 | 153 | 114 |
| 390 x 844 | 233 | 169 |
| 640 x 480 | 113 | 88 |
| 820 x 400 | 84 | 72 |
| 1366 x 768 | 211 | 154 |
| 1920 x 1080 | 240 | 176 |

(Dato: el logo es de **400x420**, casi cuadrado, no apaisado. Dimensionarlo por
ancho lo dejaba a menos de la mitad de lo que medía en el menú viejo.)

### Y el logo venía con tres marcas pegadas

El export traía **restos de la herramienta de diseño** dentro del arte, que en
el menú viejo pasaban desapercibidos y con el logo grande saltan a la vista:

| Dónde | Qué era | Píxeles |
|---|---|---|
| Arriba a la izquierda | una banda dorada en diagonal | x 0-23, y 0-23 |
| Abajo a la derecha | la grilla de puntos del tirador de tamaño | x 374-399, y 403-417 |
| Abajo a la izquierda | una marquita triangular | x 0-6, y 413-419 |

Se borran los tres recuadros y el resto del arte queda intacto. **Recortar la
imagen no servía**: la punta del escudo baja hasta la fila 412 y un recorte
rectangular que se llevara los puntos se llevaba también la punta. El archivo
pasa de 41KB a 43KB.

### Abajo, el modo principal

CAMPEONATO pasa a un **recuadro grande con foto** —la de los dos jugadores de
espaldas, la misma de siempre— y los otros tres bajan a **tres fichas**: una
puerta y tres atajos. De paso el menú ocupa menos alto que antes, que en las
pantallas bajas venía justo.

Las dos fotos son **a propósito distintas**: un plano general verde arriba y un
primer plano azul abajo. Con dos primeros planos seguidos el banner competía con
el botón en vez de acompañarlo.

El BETA del 1 vs 1 no entra al lado del nombre en una ficha tan angosta, así que
va de **chapita en la esquina**.

### Que entre en todos lados

Todo se mide en `vh` con tope y piso, como el resto de lo que tiene que entrar
sí o sí. Pero los `vh` solos no alcanzaban: **lo que desborda en un teléfono
acostado no es el `vh` sino el piso de cada clamp**. Con los mínimos originales
—148 de foto, 112 de recuadro, 62 de ficha— la tarjeta pedía 443px en un 820x400
que solo tiene 359 de hueco, y aparecía scroll adentro de la tarjeta.

Dos escalones más, que bajan los pisos y no los topes, así en un alto normal no
cambia nada. En el segundo —teléfono acostado, 430px de alto o menos— se va
también el subtítulo del recuadro: el nombre y la foto ya dicen cuál es.

Medido con la tarjeta abierta, en siete tamaños:

| Pantalla | Alto de la tarjeta | Hueco | Entra |
|---|---|---|---|
| 320 x 568 | 440 | 530 | sí |
| 390 x 844 | 585 | 806 | sí |
| 640 x 480 | 375 | 371 | sí |
| 820 x 400 | 313 | 309 | sí |
| 844 x 390 | 317 | 313 | sí |
| 1366 x 768 | 552 | 730 | sí |
| 1920 x 1080 | 604 | 601 | sí |

En los siete, sin scroll adentro de la tarjeta. Y los seis caminos siguen
llevando a donde llevaban: campeonato y partido único a la pantalla del club,
1 vs 1 al club en modo duelo, y penales, opciones y créditos a las suyas.

## El toque: la onda

El juego apagaba el destello nativo de Android —el rectángulo celeste que
Chrome pinta encima de lo que tocás— **y no ponía nada en su lugar**. Buscando
`:active` en las 900KB del archivo no aparecía ni una vez. En un teléfono, donde
no hay `:hover`, apretabas un botón y **no pasaba nada** hasta que el juego
respondía, y entre el toque y la respuesta hay animaciones de medio segundo
largo.

Ahora sale una onda **del punto exacto donde apoyaste el dedo**, así que el
botón no solo confirma que lo tocaste sino **dónde**.

### Una regla, no siete

Va en `currentColor`, o sea que **cada botón la tiñe con su propio color** sin
necesitar una regla por familia: dorada la del CTA y las columnas, verde la del
cartel de gol, blanca la de las cartas y las fichas del menú.

Y la engancha **un solo oyente para todo el juego**, en `pointerdown` y en fase
de captura —la onda tiene que salir cuando el dedo baja, no cuando se levanta—.
Botón por botón habrían sido siete lugares que hay que acordarse de tocar cada
vez que aparece uno nuevo; así cualquier cosa apretable lo tiene desde el
momento en que existe, la dibuje quien la dibuje.

**Qué cuenta como acción**, para que la onda aparezca *solo donde el toque hace
algo*:

```
un <button> que no esté deshabilitado
algo con role="button"
cualquier otra cosa que tenga un onclick puesto
```

El tercer caso es el que importa: las **celdas del tablero** solo son
clickeables mientras el VAR está apuntando, así que el resto del tiempo no
hacen onda.

### La onda trae su propia caja

El botón **no lleva `overflow:hidden`**. Es a propósito, y es la trampa de esta
implementación: la **ficha del ítem vive adentro del botón** y se despliega
hacia afuera —`left: calc(100% + 10px)`—, así que recortar el botón la haría
desaparecer del todo.

En vez de eso la onda viene envuelta en un `.onda-caja` de `inset:0` que hereda
el `border-radius` del botón, recorta solo a la onda y se va con ella.

Dos detalles más:

| | |
|---|---|
| `position:relative` | se pone desde JS y solo al botón que tocaste, no a los cientos que nadie tocó |
| color de respaldo | un par de piezas heredan un color oscuro —el FAB del relato lo tiene en negro— y ahí la onda sería negra sobre azul negro. Si la luminancia del color del botón baja de 70, va blanca |

### Y las zonas de SVG

El arco de los penales y los dos caminos de los mini juegos son `<rect>` de
SVG: no pueden llevar un `<span>` adentro. Su onda es un `<circle>` que sale
del mismo punto, convirtiendo las coordenadas de pantalla a unidades del
`viewBox` con `getScreenCTM().inverse()`. Va **detrás de la zona**, no encima, y
lleva un `blur` para que sea el mismo halo difuso que la de HTML y no un disco
de canto duro.

Verificado en las once familias: CTA, fichas y recuadro del menú, opciones
chicas, filas, columnas, ítems, cartel de gol, ayuda, FAB del relato, celdas
del tablero con el VAR apuntando, zonas del arco y zonas del duelo. Treinta
toques seguidos sobre el mismo botón dejan **cero** cajas colgadas, y la ficha
del ítem sigue abriéndose entera.

## Cuántos te quedan de cada ítem

La cantidad **existía y no se veía**. Vivía adentro del nombre —«SUPLENTES x2»—
con dos problemas encadenados: le comía ancho al nombre, que en mobile ya se
corta con puntos suspensivos, y **por eso mismo estaba escondida en el
teléfono** con un `display:none` y el comentario «la cantidad no entra en 89px».
O sea que justo donde se juega, no se veía nunca cuántos quedaban.

Ahora va de **chapita dorada sobre el ícono**, que es donde la busca cualquiera
que jugó a algo con inventario y donde no le pelea el ancho a nadie. Y el «x1»
desaparece: **si hay uno solo, el número no informa nada**.

### Los tres píxeles que costó

La chapita arrancó en la esquina de abajo a la derecha del ícono, saliéndose
6px hacia afuera — que es lo que se hace normalmente. Pero entre el ícono y el
texto hay **4px de hueco**, y el texto de abajo es el efecto: la chapita le
tapaba el signo del «+1 ❤».

Medido botón por botón, la posición que entra es **pegada al ícono**
(`right:-1px`), no afuera:

| | Se pisa con el efecto |
|---|---|
| `right:-4px` | **+1px** — tapaba |
| `right:-1px` | **-2px** — limpio |
| a la izquierda del ícono | -9px, pero se sale del botón |

Verificado con tres ítems y cantidades distintas, en mobile y en desktop: la
chapita queda **2px libre del texto en el teléfono y 3px en escritorio**, y el
ítem que tiene uno solo no muestra nada.

## El tiempo de descuento

### La racha llena, por fin nombrada

El cartel decía que tenías la racha llena en **una línea gris de 11px** —«se
acabaron los 90 con la racha llena»— y los cuatro rayos aparecían arriba **sin
que nada los nombrara**. El dato que habilita la pantalla era lo que menos se
veía.

Ahora va en una **cinta dorada a todo el ancho**, pegada abajo de la foto: es lo
primero que se lee después del título.

> La cinta se sale del cartel con márgenes negativos de `--apx`, igual que la
> foto de la cabecera. Y como la foto, se comió media hora hasta darme cuenta de
> que el guardián global `*{max-width:100%}` se los estaba comiendo y la dejaba
> **60px corta del lado derecho**. Entró en la lista de excepciones al lado de
> `.a-foto` y `.mam-art`, que tuvieron exactamente el mismo problema.

### Las dos opciones, con foto

Pasan a ser **cartas**, el mismo molde que el pop-up de la situación de gol y el
del mini juego: el cartel deja de tener un lenguaje propio. JUGARLA lleva la
ilustración de la jugada clara y GUARDARLA la de la hinchada — ninguna de las
dos es la de la cabecera, que es RACHA FULL, para que no se repita ninguna foto
en la misma pantalla.

### Perdiendo no se puede guardar

**No es que convenga menos: es que no hay dónde guardarla.** Perder es
`ELIMINADO` —la corrida se termina— y la única salida es `newRun()`, que
arranca `G.racha = 0` sin importar si venías encadenando. Guardarla yendo abajo
era un botón que decía «renunciar» disfrazado de decisión.

| Cómo vas | Opciones | Por qué |
|---|---|---|
| Ganando | las dos | hay próximo partido seguro |
| Empatando | las dos | se va a penales, y de ahí se puede salir ganando |
| **Perdiendo** | **solo JUGARLA** | no hay próximo partido donde usarla |

Con una sola carta ocupa todo el ancho y la foto respira más: es la única
salida, no una de dos. Y la nota al pie lo dice: «si no la jugás ahora no hay
próximo partido, así que guardarla no es una opción».

### Que entre en todos lados

Dos problemas de alto, con causas distintas:

**Apiladas, las cartas no entraban.** De 420px para abajo `.a-ops` se pone en
columna —una regla que ya existía para las dos tarjetas de texto— y con la foto
arriba cada carta medía 145px: las dos juntas se comían el cartel y en un
320x568 la nota del pie quedaba abajo del corte. **Acostadas** —foto a la
izquierda, texto a la derecha— cada una mide 66 y entra todo.

**Y en pantalla baja se acuestan siempre**, aunque haya ancho de sobra: un
teléfono acostado tiene 340px de hueco y el cartel pedía 474. Acá el problema no
es el ancho sino el alto, así que esa regla se cuelga del **alto** y no del
ancho — y acostar las cartas solo devolvía la mitad, así que también se aprietan
el título, el marcador y los textos.

Medido con la tarjeta abierta, en las tres situaciones de marcador y en cuatro
pantallas:

| Pantalla | Ganando | Empatando | Perdiendo |
|---|---|---|---|
| 320 x 568 | 365 | 354 | 350 |
| 390 x 844 | 453 | 439 | 441 |
| 820 x 400 | 218 | 218 | — |
| 1366 x 768 | 487 | 487 | 486 |

En las doce, **sin scroll adentro de la tarjeta** y con la cinta al ancho
exacto de la foto. Verificado también el flujo: GUARDARLA cierra y deja la
racha en 4, JUGARLA la gasta y abre la situación de gol, y yendo abajo el botón
de guardar directamente no existe.

## El tutorial, con las piezas del juego

Eran **seis párrafos de cuarenta palabras** con un emoji del teclado al costado
—🎲, ⚔, 🎒, ⏱— y **ni una imagen del juego en toda la pantalla**. Es la única
que se lee *antes* de ver una carta, así que las palabras tenían que hacer todo
el trabajo solas.

Ahora cada regla muestra **la pieza que nombra**, dibujada con lo que ya existe,
y el texto baja a un título y una línea:

| Regla | Qué se ve |
|---|---|
| Elegís una fila | una **fila de cuatro cartas** encendida, con nombre y foto |
| El aguante | los **corazones del medidor**, tres llenos y uno gris |
| La racha | los **cuatro rayos**, llenos |
| Los duelos | los **chips de ataque y defensa** contra el número de la carta |
| Los ítems | los **SVG de los ítems** que ya estaban en el archivo |
| Nueve jugadas | el **reloj del marcador**, con su arco dorado |

### La frase que faltaba

Los dos medidores terminan en lo mismo y el texto no lo decía: el aguante
hablaba de «situación de gol» y la racha de «posibilidad de gol al 51%», como si
fueran dos premios distintos. **Son el mismo**, para el rival o para vos:

```
EL AGUANTE   Si se vacía, es una situación de gol para el rival.
LA RACHA     Si se llena, es una situación de gol para vos.
```

Y entra la regla que no estaba en ningún lado: **con 3 ⚡ ya podés atacar por
columna**. Va de nota al pie de la racha —separada por un punteado— para no
sumar un séptimo renglón a la pantalla más larga del juego.

### Lo que costó que entrara

**Un error que rompía el juego entero.** `tutoItems` era una constante que
llamaba a `icoItem()`, y `icoItem` se define 400 líneas más abajo: evaluarla
ahí arriba tiraba un `ReferenceError` de zona muerta temporal que **cortaba el
script antes de definir `$`**. La pantalla en blanco no tenía nada que ver con
el tutorial. Pasó a ser una función, que resuelve `icoItem` recién al llamarla.

**Y los escalones por alto no alcanzaban.** La columna de la izquierda pasó de
30px —un emoji— a entre 42 y 106, así que la pantalla creció justo la que ya
venía más justa. Aparecieron dos huecos:

- En **escritorio** el título ocupaba **99px**, más que dos reglas juntas, y la
  tarjeta se pasaba 31px. Se achica solo en el tutorial, con una clase propia
  `.card-reglas` — los otros carteles que comparten `card-final` lo siguen
  queriendo grande.
- Los escalones que ya tenía el juego están **todos colgados de
  `(max-width:820px)`**, así que un teléfono acostado de 844 se llevaba el
  tratamiento de escritorio —padding de 30px, texto de 11.8— en 390px de
  pantalla. El escalón nuevo **no mira el ancho: solo el alto**.

En pantalla baja los dos botones pasan a ir **uno al lado del otro**: apilados
se llevaban 68px de los 358 que hay, que son dos reglas enteras.

Medido con la tarjeta abierta, en siete pantallas:

| Pantalla | Tarjeta | Hueco |
|---|---|---|
| 320 x 568 | 437 | 433 |
| 360 x 640 | 465 | 461 |
| 390 x 844 | 589 | 585 |
| 820 x 400 | 349 | 345 |
| 844 x 390 | 350 | 346 |
| 1366 x 768 | 719 | 715 |
| 1920 x 1080 | 719 | 715 |

En las siete, **sin scroll adentro de la tarjeta**. Y los dos caminos siguen
funcionando: EMPEZAR LA COPA cierra y arranca el partido, VOLVER vuelve al menú,
y desde el «?» del tablero sale con un solo botón.

## Tres arreglos en la pantalla del club

### Las formas, centradas de verdad

La tira tenía `justify-content:center`, pero en mobile había un
`flex-start` que la pisaba, y las cinco formas quedaban pegadas a la izquierda
con un hueco a la derecha.

Ese `flex-start` **no era un descuido**: la tira scrollea, y centrar una caja
que desborda deja la primera forma **abajo del borde izquierdo, sin manera de
llegar a ella** —el scroll arranca en cero y el contenido está corrido hacia la
izquierda—. Elegir entre centrar y poder tocar la primera es un falso dilema:

```css
justify-content: safe center
```

`safe` es exactamente esa condición: **centra mientras entra, y se cae a
`start` recién cuando desbordaría**. Medido en 320, 390 y 1366: los tres
centrados al píxel —35,5 de aire a cada lado en el más chico, 140 en el más
grande— y en ninguno la tira desborda.

### La primera forma, siempre

La forma arrancaba **sorteada**, igual que los colores. Con eso la tira de abajo
abría con la selección en cualquier lado —a veces en la última, fuera de la
vista en una pantalla angosta— y no se entendía que esos cinco botones eran para
elegir.

Ahora arranca en la **primera**, así la tira se lee de izquierda a derecha como
lo que es: una lista. **Los colores siguen sorteándose**, que es lo que hace que
la pantalla no abra como un molde vacío, y el dado sigue sorteando las tres
cosas.

### El interruptor de color no se mueve solo

Se probó que al elegir el primer color la fila saltara sola al segundo, para
ahorrar el toque del medio. **Se volvió atrás.**

El razonamiento a favor era bueno en el papel —son dos colores, siempre en ese
orden, y el toque del interruptor no decide nada— pero en la mano no: el salto
te cambia de contexto **justo cuando estás mirando el resultado del color que
acabás de poner**. Elegís, levantás la vista al escudo, y la fila de abajo ya
está pintando otra cosa. Cambiar de color es una decisión del jugador, no un
trámite que convenga adelantarle.

## El mano a mano es un remate, no una carrera

En los otros tres duelos las dos figuras se cruzan —vos encarás, él sale a
cortar— y mover los dos cuerpos cuenta bien lo que pasa. En el **mano a mano**
no: enfrente hay **un arquero**, y un arquero no corre hacia vos. Vos definís
desde donde estás y lo único que viaja es la pelota.

Antes tu figura salía disparada al palo elegido junto con el balón, así que el
mano a mano se veía como los otros tres: dos muñecos corriendo hacia los
costados. Ahora, **solo en éste**:

| | |
|---|---|
| tu figura | se queda quieta en el medio |
| la pelota | sale sola al palo que elegiste, **y sube** — va a la altura del arquero, que es adonde se patea |
| el arquero | sigue volando a su palo |

Si él adivinó, los dos llegan al mismo punto y ahí sale el anillo de la
atajada; si no, la pelota queda del otro lado, sola. Y como el balón **ya está
arriba** cuando termina el vuelo, la segunda fase —la que en los otros duelos
cruza la pelota al que ganó— no lo vuelve a mover: le pone el anillo y nada
más.

Verificado en los cuatro mini juegos: en el del arquero `yo` queda en `none`
y la pelota en `(±50, -54)`; en los otros tres las dos figuras y el balón
siguen yendo a `±50` como antes. Y con la atajada forzada, el anillo cae en
`cx` 150 — el palo al que fueron los dos.


## El cartel de gol vuelve a tener foto, y el marcador no se pierde

El cartel de **¡GOL!** y **GOL RIVAL** era solo tipografía sobre el azul. No
era un olvido: ya se había probado con una foto de fondo y se sacó, porque la
imagen ocupaba todo y **tapaba el marcador**, que es justo el dato que uno
busca en ese momento —acabás de convertir o te acaban de convertir, y lo
primero que querés saber es cómo va el partido.

El error no era la foto: era ponerle el resultado encima. Ahora son **dos
pisos**:

| | |
|---|---|
| arriba | la foto, tamaño de póster, con la palabra al centro sobre un velo radial |
| abajo | el marcador sobre el azul liso, en una banda propia |
| entre las dos | un filo de 2px del color del gol — verde si es tuyo, rojo si es del rival |

Es el mismo molde que ya usan la marquesina del menú, el tiempo de descuento y
la situación de gol. No estrena lenguaje: lo único distinto es que acá la foto
pesa el doble, porque el gol es **el** momento del partido.

### Las dos imágenes son la misma foto

`cartelGol` y `cartelGolC` salen del mismo original: un 9 festejando después
de convertir, con la pelota adentro de la red y el arquero de cara al piso.

| | qué muestra |
|---|---|
| `cartelGol` | el lado derecho del cuadro — el jugador viniendo de frente |
| `cartelGolC` | el lado izquierdo — la pelota en la red y el arquero vencido |

La pelota adentro del arco con el arquero en el piso **es** un gol recibido:
no hizo falta arte nuevo para el cartel del rival, estaba en la otra mitad de
la misma imagen. Y como los dos recortes vienen del mismo original, comparten
luz, cancha y estadio: se leen como una pieza y su reverso, no como dos fotos
que no se conocen.

Pesan 58 y 60 KB —700px de ancho, WEBP al 62%—, en la familia de `cancha`
(40 KB) y `logo` (44 KB), que son las otras dos grandes. Las cartas de la mesa
son de 248x164 y pesan entre 4 y 10 KB: éstas se ven diez veces más grandes,
así que no podían salir de ahí.

### Si algún día no hay arte, el cartel vuelve a ser tipografía

La clase `gol-foto` y los dos pisos **solo aparecen si `ARTSRC` devolvió
algo**. Sin imagen, el cartel se arma como antes —palabra y marcador sobre el
azul—, igual que el resto del `ART`, que está pensado para migrarse de a poco
sin que nada quede a medias.

### El tamaño, de 320px a 1920

El bloque va **al final de la hoja** a propósito: `.gf.favor` y `.gf.contra`
—que fijan el padding y el ancho del cartel viejo— tienen la misma
especificidad que `.gf.gol-foto`, así que gana el que está más abajo.

| | ancho del cartel | alto de la foto | la palabra |
|---|---|---|---|
| teléfono | `min(94vw, 430px)` | `clamp(158px, 27vh, 250px)` | `clamp(40px, 11vw, 62px)` |
| escritorio | `clamp(500px, 42vw, 700px)` | `clamp(210px, 36vh, 360px)` | `clamp(52px, 4.6vw, 76px)` |
| pantalla baja | — | `min(150px, 40vh)` | `min(46px, 12vh)` |

El ancho de escritorio es el mismo `clamp(..., 42vw, 700px)` de los avisos, así
que el cartel de gol entra en la familia de anchos que ya existía.

La tercera fila es la que importa y es la que se olvida: **en una pantalla baja
lo que desborda es el piso del `clamp`, no el término en `vh`**. Un teléfono
acostado de 844x390 entra en la consulta de escritorio —es landscape y mide más
de 821px— y ahí el piso de 210px de foto más la banda no entraban. Por eso el
alto se fija con `min()`, que sí baja, en un bloque `@media (max-height:430px)`
que va después: misma especificidad, gana el de abajo.

Medido en 320x568, 360x640, 390x844, 640x480, 768x1024, 820x400, 844x390,
1366x768 y 1920x1080, con `¡GOL!` y con `GOL RIVAL` —que es la palabra larga—:
el cartel entra entero en la pantalla en las nueve y el título nunca desborda
su caja. Va de 280x231 en el teléfono más chico a 700x464 en 1920.


## El tutorial: la pieza baja al medio del renglón

Cada regla mostraba su pieza en una **columna de 58px a la izquierda**, con el
título y el texto al lado. Esa columna es la que aplastaba las imágenes: las
cuatro cartas de ELEGÍS UNA FILA entraban a 20px de alto con el nombre a
**4,4px**, ilegible, y los medidores quedaban del tamaño de un emoji.

Y sobraba lugar: la tarjeta usaba **589px de los 844** de un teléfono parado.
Había 255px sin tocar.

Ahora el orden es **título, pieza, texto**, y la pieza va a todo el ancho —318px
en un teléfono, 420 en escritorio— dentro de una **banda hundida**: fondo más
oscuro y un filo interno. La banda dice «esto es un pedazo del tablero», no «acá
va un ícono». Es la misma idea que la cinta de RACHA LLENA en el descuento.

Y el renglón entero va **centrado**. Con la pieza al medio, el título y el texto
apoyados a la izquierda dejaban la columna coja: la banda tiraba al centro y las
otras dos líneas al borde. Centrado, las tres cosas comparten el mismo eje.

| | antes | ahora |
|---|---|---|
| nombre de la carta | 4,2 – 5,6px | 6,4 – 9,5px |
| ilustración de la carta | 15 – 24px | 30 – 50px |
| corazón del aguante | 13 – 20px | 18 – 28px |
| rayo de la racha | 10x14 – 15x20 | 13x18 – 20x28 |
| ícono de ítem | 11 – 17px | 16 – 24px |
| reloj | 28 – 40px | 34 – 48px |

La fila de cartas es la única pieza que **no** lleva banda: ya trae su propio
marco dorado y adentro quedaba enmarcada dos veces.

### La pieza va adentro de `.rg-txt`, no al lado

Podría ser hermana del título, que sería lo obvio leyendo el HTML. Pero
`.rg-txt .rg-tit`, `.rg-txt > span` y `.rg-txt em` se ajustan en **cinco
escalones por alto**, y sacar el título de ahí adentro los rompía todos.
Metiendo la pieza **dentro** de `.rg-txt`, entre el título y el texto, el orden
visual cambia y ninguna de esas reglas se entera.

### Una columna cuando la pantalla es alta, dos cuando es ancha

Apiladas, seis reglas con su pieza cuestan unos 190px más que antes. En un
teléfono parado eso es justo el aire que sobraba. En **escritorio no alcanza**:
en una sola columna piden 998px y la pantalla da 736, así que para entrar
habría que dejar las piezas **más chicas que en un teléfono** — exactamente lo
contrario de lo que se buscaba.

Así que la regla quedó simple:

| | columnas | alto de la tarjeta |
|---|---|---|
| teléfono parado | una | 520 – 717px |
| escritorio y pantalla ancha | dos | 526 – 607px |
| pantalla baja (≤560px de alto) | dos, apretadas | 343 – 350px |

En dos columnas la tarjeta se ensancha —hasta 880px en escritorio, 860 en una
pantalla baja— y ahí la fila de cartas **tampoco se queda a lo ancho**: con 420px
por celda ya tiene más de lo que tenía una tarjeta entera en un teléfono, y
dejándola en su celda son tres renglones en vez de cuatro. Ese renglón de menos
es justo lo que hace entrar todo en un teléfono acostado.

### Los dos botones, uno al lado del otro

Apilados se llevaban **110px** —dos reglas enteras— y con la pieza en el medio de
cada renglón ya no sobraban. Uno al lado del otro cuestan la mitad. Con un solo
botón, que es cuando el tutorial se abre desde el partido, `flex:1` lo deja a
todo el ancho igual.

Su cuerpo y su interletrado se miden en `vw`: con la mitad del ancho, en una
pantalla de 320px «EMPEZAR LA COPA» se partía en dos renglones y eso solo ya
mandaba la tarjeta al scroll.

### Los escalones, redibujados

Los que había angostaban la columna de la izquierda, que ocupaba **ancho**. Los
de ahora achican la banda y la pieza que tiene adentro, que es lo que ocupa
**alto**. Y hay dos cortes nuevos:

- el primero arranca en **800px** y no en 740, porque un teléfono de 390 deja
  unos 780 útiles con la barra del navegador puesta y ahí se pasaba por 17px;
- **≤700px de alto con pantalla ancha**: una ventana de escritorio de 600px deja
  560 de hueco y las dos columnas pedían 607. Ahí las piezas bajan un tercio;
- el corte de pantalla baja pasó de **430 a 560px**, porque el problema no era el
  teléfono acostado sino el hueco: en 640x480 quedan 438px y seis reglas
  apiladas piden 567. Un teléfono de 320x568 se queda afuera por ocho píxeles,
  que es justo lo que hace falta: ahí las seis entran en una columna.

Medido en catorce pantallas —320x568, 360x640, 390x780, 390x844, 414x896,
640x480, 768x1024, 820x400, 844x390, 900x500, 1024x768, 1280x720, 1366x600,
1366x768 y 1920x1080—, con los dos botones y con uno solo: **ninguna hace
scroll**.


## El fondo de la mesa: el césped, y nada más

Había **dos canchas superpuestas y no se veía ninguna**.

La primera era una foto aérea que en realidad no es una cancha: es una ciudad
entera vista desde el aire —cielo, edificios, avenidas— con el estadio en el
medio y la cancha ocupando cerca de **un octavo del cuadro**. La foto además
viene ya desenfocada y oscurecida en el archivo, y encima llevaba un velo azul
que llegaba al **94% de opacidad** en las esquinas. De verde no quedaba nada.

La segunda eran las **dos áreas dibujadas** con líneas blancas, `body::before` y
`body::after`, que sobraban de cuando el fondo era todo gradientes —«el fondo es
la cancha: césped rayado, círculo central y los dos arcos», decía el comentario—
y que después de meter la foto ya no coincidían con nada.

El resultado era que **el tablero azul flotaba sobre un fondo azul**.

### El césped ya estaba adentro de la foto

No hizo falta arte nuevo. `pasto` es el rectángulo verde de `cancha`, recortado:

| | |
|---|---|
| recorte | 450x190 del original de 1200x655 |
| tratamiento | saturación x3,4, brillo +0,20, y el tinte azul sacado con `colorlevels` |
| trae puestas | las franjas, el círculo central, las dos áreas y la línea de mitad de cancha |
| peso | **15 KB** contra los 40 de la foto entera |

`cancha` sigue igual y sigue en uso: la marquesina del menú sí quiere ver el
estadio completo.

### El velo pasa de azul a verde

```
radial-gradient(ellipse 118% 96% at 50% 45%,
  rgba(6,32,18,.04) 0%, rgba(4,26,15,.5) 62%, rgba(2,14,9,.92) 100%)
```

Dos efectos de un solo movimiento:

- **el verde aparece de verdad**, no como un detalle al centro que el velo apaga
  hacia los bordes;
- y como el verde es el opuesto del azul de las cartas, **el contraste sale
  gratis**: el tablero se recorta solo, sin tener que iluminarlo.

> *Lo segundo resultó falso al medirlo, y el velo se sacó entero: ver «El velo
> se va, y el contraste sube» al final del documento.*

Las áreas dibujadas se fueron con `--cal`, la variable que solo ellas usaban. La
cancha de la foto ya trae las suyas.

### El filo de los paneles sube

Sobre el azul de antes, un borde de `--line` (#12336e) alcanzaba: el panel y el
fondo eran del mismo color y el borde solo marcaba dónde terminaba uno. Sobre el
verde el trabajo es otro —separar dos colores opuestos— y ahí un filo oscuro se
pierde. Entra `--filo` (#1c4a8f) para `.cell`, `.panel` y `.marquesina`, más una
sombra proyectada y un reflejo de 1px arriba.

Detalle de la marquesina: `border-color` pinta los cuatro lados, así que hay que
devolverle el `border-top-color` dorado después.

### Dónde se nota

En **escritorio** es donde se juega la decisión: el tablero mide 1320px y
alrededor queda césped a la vista. En un **teléfono** las dieciséis cartas tapan
casi todo y del fondo quedan los milímetros del borde y los huecos entre
filas — que ahora son verdes en vez de azules, y alcanzan para que cada carta
se lea como una pieza suelta y no como parte de un bloque.


## Un solo cartel de gol, y una regla para saber cuál

El juego tiene **dos carteles** que dicen ¡GOL!, y no hacen el mismo trabajo:

| | qué es | cómo se va |
|---|---|---|
| **el de la foto** (`flashGol`) | **anuncia**: aparece solo, dice el marcador y nada más | se va solo a los 3s |
| **el del dibujo** (situación resuelta) | **resuelve**: es la misma ventana donde apretaste EJECUTAR, dada vuelta | espera un toque |

Auditando las doce rutas por las que se puede mover el marcador apareció que la
**situación de gol no se comportaba igual consigo misma**: cuatro de sus cinco
cartas terminaban en el dibujo, y la quinta —el penal a favor— terminaba en los
dos. Y era el único gol del partido que no mostraba el cartel grande: la jugada
más importante, la que te dio la racha llena o te vació el aguante, terminaba
más chica que un córner.

### La regla

**El cartel con foto sale siempre que se mueva el marcador del partido.**

| de dónde viene el gol | qué se ve |
|---|---|
| las siete rutas de la mesa | foto |
| situación de gol · racha llena | foto |
| situación de gol · aguante vacío | foto |
| situación de gol · si sale PENAL a favor | el mini juego, y después la foto |
| tanda de penales · penal de definición | el dibujo, sin foto |

El penal a favor sigue mostrando los dos **porque lo pateás vos**: el mini juego
tiene que contarte si el arquero la sacó antes de que el cartel diga el
resultado. Y la tanda y el penal de definición no muestran la foto porque **no
tocan el marcador del partido**: tienen su propia pizarra.

### Qué cambió en el código

En `situacionGol`, la rama del gol deja de transformar la caja y pasa a sacarla:

```js
if(esGol){
  if(favor) G.gU++; else G.gC++;
  say(...);
  wrap.remove();
  render();
  await flashGol(favor ? 'favor' : 'contra');
  resolve();
  return;
}
```

El dibujo se queda para lo que **no** es gol —LA ERRASTE, ¡TE SALVASTE!—, que es
el desenlace de la jugada y no el anuncio de un tanto, y ahí sigue apareciendo el
`+1 ⚡ RACHA` cuando el rival falla la suya.

Con eso quedaron dos reglas de CSS sin dueño: `.sit.resuelta.gol.lado-favor`
—borde y color— ya no puede existir, porque el gol a favor de la situación no se
resuelve más en esa caja. Se fueron.

Verificado en los cuatro caminos: gol a favor, gol en contra, tiro errado a favor
y penal a favor con su mini juego. El marcador se mueve bien en los cuatro.


## La pizarra de los penales se reinicia en la muerte súbita

La tanda son **cinco cada uno**, y si terminan empatados sigue de **a uno por
cabeza** hasta que uno convierta y el otro no. Eso funcionaba bien: el bucle
alternaba y cortaba donde tenía que cortar.

Lo que no funcionaba era la pizarra. Dibujaba **siempre cinco casillas por
equipo**, del índice 0 al 4:

```js
for(let k = 0; k < TANDA_TIROS; k++){
  const t = tiros[i][k];
  ...
```

Del sexto tiro en adelante el índice se iba más allá de la última casilla, así
que **los penales de la muerte súbita no tenían dónde dibujarse**: la pizarra se
quedaba congelada en el 5-5 de la serie normal mientras el partido seguía. El
único que se movía era el número de la derecha, que cuenta todos los goles.

Ahora, pasados los cinco, las casillas son las de **esta** serie y arrancan de
cero: una por ronda, verde la que entró, roja la que erró, y la que se está por
patear late en dorado, igual que en la serie normal.

| | casillas | número |
|---|---|---|
| serie normal | las cinco, desde el primer tiro | goles de la tanda |
| muerte súbita | las de la muerte súbita, desde cero | goles de la tanda, **sin reiniciar** |

El número no se reinicia a propósito: ese es el marcador de la tanda entera —5,
6, 7…— y es el que dice quién va ganando. Reiniciarlo también dejaría la pantalla
sin ese dato.

### `muerte` la manda quien llama

No se puede deducir de `tiros`. Cuando se está por patear el primero de la
muerte súbita los dos equipos tienen **exactamente cinco tiros**, que es
indistinguible de lo que se ve al terminar la serie normal. Así que `tandaHTML`
recibe un quinto parámetro: el pop-up del penal le pasa su propio `muerte`, y el
resumen final lo calcula con `tiros[0].length > TANDA_TIROS`.

Cuántas casillas dibujar es la ronda que se está jugando:

```js
const cols = muerte
  ? (Math.max(desde[0], desde[1]) + (vivo && desde[0] === desde[1] ? 1 : 0)) || 1
  : TANDA_TIROS;
```

Si los dos patearon lo mismo y la serie sigue, se suma la que viene; si uno va
uno arriba, ya está contada. En el resumen final —`vivo` es falso— son las
rondas jugadas y nada más.

### Los dos rótulos

El del pop-up pasa de `MUERTE SÚBITA` a **`MUERTE SÚBITA · PENAL n`**, y el del
resumen de `DEFINIDO EN LOS PENALES` a **`DEFINIDO EN MUERTE SÚBITA`** cuando
corresponde. Con eso las casillas reiniciadas se explican solas.

Hubo un intento de poner además un rótulo sobre la pizarra y se sacó: decía
exactamente lo mismo que el del pop-up, uno arriba del otro.

Verificado en cinco estados de pizarra —serie normal a mitad de camino, el
primero de la muerte súbita, mitad de ronda, ronda nueva y resumen final— y en
los dos resúmenes, con y sin muerte súbita.


## La amarilla acumulada, en el teléfono, sin robarle alto a la mesa

El aviso de amarilla acumulada es una caja de **158x51** y la línea de medidores
del teléfono mide **301px de ancho**. No le cabía: envolvía y se llevaba un
renglón entero.

| en un teléfono de 390x844 | sin amarilla | con amarilla |
|---|---|---|
| la franja del equipo | 24px | **79px** |
| la mesa | 575px | **520px** |
| cada carta | 140px | **126px** |

Catorce píxeles menos por carta es lo que hacía que el texto se le empezara a
salir: nombres partidos en dos líneas y el efecto montado encima del nombre.

Y el aviso **se mostraba dos veces**: la caja arriba, y abajo, en la línea de
ayuda, un «🟨 amarilla acumulada» que además se le montaba al texto del hint
porque los dos juntos no entraban en el renglón.

### La misma advertencia, dos formas según el lugar

| | qué se ve |
|---|---|
| escritorio | la caja entera, en la columna del equipo, que tiene lugar de sobra |
| teléfono | **la tarjeta pegada al aguante** —que es justo lo que la amarilla amenaza— y la línea de abajo, que lo dice con palabras |

En el teléfono el aguante se enmarca en dorado y lleva el 🟨 al costado. Es la
relación que importa: la segunda amarilla cuesta **−3 ❤**, así que el aviso vive
encima de los corazones que se van a ir.

### Los dos trucos para que cueste cero

**El anillo se dibuja con `outline`**, no con `border` ni `padding`: no ocupa
lugar en el flujo, así que enmarcar los corazones no empuja nada.

**La tarjeta va fuera del flujo.** El primer intento la puso como un elemento
más de la línea y volvió a envolver: se llevaba su ancho más el hueco de la
línea —unos 35px contra los **34 que sobran** ahí— y estábamos en el mismo
problema, con 15px de mesa perdidos en vez de 55. Absoluta, se apoya en el hueco
que ya existe entre el aguante y la racha y no cuesta nada.

Medido con y sin amarilla en 320x568, 360x640, 390x780, 390x844 y 414x896: la
franja, la mesa y las cartas miden **exactamente lo mismo** en los dos estados, y
ninguna hace scroll. En 320 la línea envuelve, pero envuelve igual sin amarilla:
ahí los tres medidores ya no entran en 231px.

### Y la línea de abajo deja de pisarse

El aviso de abajo se queda —es el que lo explica con palabras— pero antes no le
cabía al renglón. Ahora la ayuda cede primero: `overflow:hidden` con puntos
suspensivos. De los dos textos, el que se puede perder es el que dice siempre lo
mismo.

### La visibilidad pasa a ser una clase

`render` escribía `style.display` en línea, y un estilo en línea le gana a la
hoja: el teléfono no tenía forma de esconder la caja. Ahora es
`classList.toggle('hay', …)`, y el bloque del teléfono la apaga con una regla
normal.


## Las cartas del rival dejan de parecerse a las tuyas

Tres de las cinco llegadas del rival no tenían ilustración propia:

| | antes | ahora |
|---|---|---|
| `penalC` | alias de `penal` | foto propia |
| `libreC` | alias de `libre` | foto propia |
| `pasegolC` | **sin imagen** | foto propia |
| `cornerC` | ya tenía la suya | igual |
| `jugadaC` | **no existía** | foto propia |

Que compartieran imagen no era un detalle: **en la mesa la única diferencia que
importa mirar antes de elegir una fila es de quién es la llegada**, y PENAL y
PENAL RIVAL se veían exactamente igual. El nombre y el efecto lo decían, pero la
foto —que es lo primero que se mira— decía lo contrario.

Las tres nuevas cuentan la misma escena desde el otro lado:

- **PASE GOL RIVAL**: el 10 de blanco centra y el 9 de blanco entra al área. En
  la tuya el que centra es el de azul.
- **LIBRE RIVAL** y **PENAL RIVAL**: el árbitro cobra, el de blanco está en el
  piso y **el que hizo la falta sos vos** — se ve la pierna azul.
- **JUGADA CLARA RIVAL**: los dos de blanco encarando solos contra tu arquero.
  En la tuya los que encaran son los de azul.

Miden 248x164 y pesan entre 9 y 11 KB, que es la familia de las que ya estaban
(entre 6 y 10). El archivo pasó de 1,14 a 1,20 MB.

Con `jugadaC` quedan **las cinco llegadas del rival con ilustración propia**:
jugada clara, penal, pase gol, córner y tiro libre. Ninguna se ve ya como la
tuya, ni en la mesa ni en el pop-up de situación de gol.

### El alias que queda

`autogol: '@encontra'` sigue siendo alias, y con razón: un autogol tuyo y uno
del rival **son la misma escena** —la pelota entrando en un arco por error—, así
que ahí compartir imagen no confunde nada. Los otros cuatro eran jugadas
opuestas disfrazadas de la misma.

Verificado que las cinco devuelven arte distinto del propio, en la mesa y en el
pop-up de situación de gol, que las toma por `ART_RIVAL` sin tocar nada más.


## El mercado de ítems: una franja y cuatro renglones

Era la única pantalla que había quedado afuera del rebranding, y la que peor se
portaba: **hacía scroll en las dos**. 815px de contenido contra 764 de hueco en
un teléfono, y 915 contra 736 en escritorio, así que el botón de JUGAR quedaba
abajo del corte.

| | antes | ahora |
|---|---|---|
| teléfono 390x844 | 815px, con scroll | **515px** |
| teléfono 320x568 | con scroll | **469px** |
| escritorio 1366x768 | 915px, con scroll | **647px** |
| teléfono acostado 844x390 | 915px | 523px, con scroll adentro |

### Lo que se fue, y por qué

**El inventario.** Un bloque «YA TENÉS» arriba que listaba los ítems con su
cantidad… y después cada botón repetía «TENÉS x2». La misma información dos
veces en la misma pantalla. Ahora el `x2` vive pegado al nombre, en el renglón
que corresponde, y el bloque desapareció.

**La descripción larga.** «Entra sangre nueva del banco» repetía en prosa lo que
el efecto dice en tres caracteres: **+1 ❤**. Para decidir una compra alcanza con
el efecto.

**La plata suelta.** Flotaba sin marco en el medio de la pantalla, entre el
inventario y la lista, cuando es el dato que gobierna todo lo demás.

### Lo que entró

**La franja**: los tres datos con los que se compra, en tres columnas separadas
por un filo — **presupuesto, aguante y racha**. La plata primero porque decide
qué se puede; las otras dos porque dicen qué conviene: sin aguante, un SUPLENTES
vale más que un VAR.

**El faltante escrito.** Antes, lo que no te alcanzaba solo bajaba a opacidad
.32 y **el precio seguía en verde**: había que comparar €25M contra €30M de
cabeza. Ahora el precio va en rojo y debajo dice **«faltan €5M»**.

### Dos trampas del camino

**La ✕ de devolver no puede ir adentro del renglón.** El renglón es un
`<button>` y un botón adentro de otro es HTML inválido: el navegador rompe la
interacción de los dos. Es el mismo problema que tuvo la ficha del cartel de
gol. Se resolvió igual: el renglón es una caja con el botón de comprar y la ✕
como **hermana**, posicionada en la esquina, fuera del flujo.

**Los medidores traían una grilla de la mesa.** El bloque del teléfono le pone a
`.hearts` y a `.racha-track` cuatro columnas fijas de 26px —104px cada
medidor— para que en la franja de la mesa caigan alineados uno debajo del otro.
En 320px de ancho eso hacía que la franja del mercado se pisara a sí misma.
Adentro de `.franja` se les desarma la grilla y se miden en `vw`, con los topes
de siempre: en un teléfono normal y en escritorio no cambia nada.

### El vestuario va con el mismo renglón

El mercado del campeonato, el entretiempo del 1v1 y el vestuario del partido
único comparten la lista. Los tres usan `filaItem`; lo único que cambia es lo
que va a la derecha:

| | a la derecha |
|---|---|
| mercado y entretiempo | el precio, y el faltante si no alcanza |
| vestuario | un **+** si podés sumar, **listo** si llegaste al tope del ítem, **sin cupo** si se acabaron los tres |

Y de paso apareció un bug viejo: **los tres cupos del vestuario nunca se habían
dibujado**. El HTML emitía `<span class="cupo">` desde el primer día y `.cupo`
no tenía una sola regla en toda la hoja, así que quedaba el «te quedan 3» solo,
sin los puntos que lo explican. Ahora son tres círculos que se llenan en dorado.

### Lo que queda

En un **teléfono acostado** la tarjeta sigue con scroll adentro: 523px contra
358 de hueco. Los renglones ya van de a dos —ancho sobra, son 844px— y eso la
bajó de 681 a 523, pero con cabecera, franja, cuatro ítems y botón no hay forma
de entrar en 358. Es scroll de la tarjeta, no de la página.


## El vestuario: dos barras que crecen

Elegir el refuerzo eran **dos botones iguales** con un emoji del teclado y un
«3 → 4» suelto. Decían cuánto sumabas pero no **cuánto te faltaba**, que es la
otra mitad de la decisión: con ATAQUE 3 de 6 y DEFENSA 2 de 6, saber que uno va
por la mitad y el otro por un tercio cambia la respuesta.

Ahora cada stat es una **barra de tramos**: los que tenés en su color, **el que
vas a ganar en dorado y latiendo**, y los que quedan vacíos. Elegir es mirar cuál
barra crece.

El plantel arranca en ATAQUE 2 y DEFENSA 1 y se refuerza una vez por ronda
—cuatro veces—, así que un stat puede llegar a 6. El tope de la barra es
`Math.max(6, n + 2)`: si alguna vez pasara de ahí, la barra crece en vez de
dejar un tramo sin dibujar.

### Los dos íconos que faltaban

El ⚔ y el 🛡 eran **los últimos dos emoji del teclado** en una pantalla de
decisión, y encima eran los mismos que ya usa el panel PLANTEL de la mesa. Se
dibujaron dos SVG en el estilo de los cuatro de ítems:

| | qué es |
|---|---|
| `i-atk` | la pelota saliendo, con las tres líneas del remate detrás |
| `i-def` | el escudo, con el corte adentro |

### Y la advertencia deja de gritar

«Los rivales se acomodan…» estaba en **13,5px y en dorado pleno**, compitiendo
con las dos opciones. Baja a `clamp(9.2px, 2.7vw, 11px)` con opacidad .78: sigue
estando, pero deja de pelear con lo que hay que mirar.

Todo se mide en `vw` con tope y piso, así que la misma barra sirve en 320px y en
la tarjeta de 520 del escritorio. Medido en 320x568, 390x844, 1366x768 y
1920x1080: **371, 445, 596 y 596px**, sin scroll en ninguna.

## Al tocar, se nota; al abrir, no queda nada enfocado

Dos cambios que valen para **todo el juego**, no para una pantalla.

### El toque se siente en toda la pieza

La onda sola no alcanzaba. En las piezas grandes —una carta de la mesa, una
opción del descuento— el círculo se abre en un rincón y la pieza entera no acusa
el golpe. Ahora son tres cosas juntas:

| | antes | ahora |
|---|---|---|
| la onda | opacidad .5 | **.62**, y dura 560ms |
| el hundido | `translateY(1px)` | `translateY(1.5px) scale(.985)` |
| la pieza | — | la caja de la onda se **aclara** un 10% |

El aclarado se queda incluso con `prefers-reduced-motion`: no es movimiento, y
sin él no quedaría ninguna respuesta al toque.

### Ninguna pantalla abre con algo enfocado

El navegador le deja el foco puesto al botón que tocaste. En un juego que se
juega a dedazos eso se lee como «esto quedó elegido» — y peor: si ese botón abre
otra pantalla, **el foco viaja con vos** y la pantalla nueva aparece con algo
resaltado que nadie eligió.

Se resuelve en dos lugares:

- un `pointerup` global que saca el foco de donde esté;
- y `openCard`, que hace lo mismo al abrir, porque **muchas pantallas se abren
  solas** —al terminar un partido, al vencerse el reloj, al resolverse una
  jugada— y ahí no hubo ningún toque que lo limpiara.

Dos cosas quedan intactas a propósito. **Los campos de texto**: tocar un input es
justamente pedirle el foco, así que `INPUT`, `TEXTAREA` y lo editable quedan
afuera. Y **el teclado**: `pointerup` no dispara al navegar con Tab ni al activar
con Enter, así que el anillo de `:focus-visible` sigue entero para quien lo
necesita.


## El resultado de la carta, un 20% más grande

«GOL» en JUGADA CLARA y «GOL RIVAL» en CONTRAATAQUE se leían chicos: son la
razón por la que tocás esa carta y estaban en **9,6px** contra los 11,2 del
nombre. La palabra no tiene tamaño propio —vive en `.c-out`, la línea de
resultado que comparten las dieciséis cartas—, así que agrandarla es agrandar
toda la línea, incluidos los «30% GOL», los «50% RIVAL» y los «+€20M».

Se comparó **hoy contra +10%, +20% y agrandar solo la palabra**, y se eligió el
+20% parejo. La línea sube en todos los tramos:

| pantalla | antes | ahora | el nombre va en |
|---|---|---|---|
| teléfono chico (≤440) | 9,6 | **11,5** | 11,2 |
| tableta en pie / ≤820 | 9,2 | **11** | 12,6 |
| acostado bajo (≤560 de alto) | 9 | **10,8** | 10,4 |
| desktop | 14,4 | **17,3** | 15 |
| franja media (1025–1300) | 12,9 | **15,5** | 13,6 |
| ≥1600 | 15,6 | **18,7** | 16,5 |
| ≥1900 | 16,8 | **20,2** | 18 |

En desktop el resultado queda **por encima del nombre**, y es a propósito: el
nombre dice de qué va la jugada, el resultado dice qué te deja, y en la mesa se
decide por lo segundo.

`.efe` —el renglón de los medidores, «−1 ⚡ o +1 ⚡»— **no se tocó**. En la
comparación tampoco se movía, y dejarlo quieto es lo que abre la distancia entre
las dos líneas: antes eran casi el mismo cuerpo, ahora el resultado manda.

### Lo que se midió antes de tocarlo

La duda era si una línea más grande parte las etiquetas largas o desborda la
carta. Se midió el **mismo tablero** con los dos tamaños, alternando una hoja de
estilo que revierte los siete tramos:

| | 320×568 | 360×640 | 390×844 | 768×1024 | 844×390 | 1366×768 | 1920×1080 |
|---|---|---|---|---|---|---|---|
| cartas recortadas | 13 → **13** | 2 → **2** | 0 → **0** | 0 → **0** | 0 → **0** | 0 → **0** | 0 → **0** |
| etiquetas en dos renglones | 3 → **3** | 3 → **3** | 3 → **3** | 3 → **3** | 12 → **13** | 3 → **2** | 3 → **3** |
| alto de la página | igual | igual | igual | igual | +21px | +13px | +16px |

No aparece **ningún** corte ni ningún renglón partido que no estuviera antes: en
teléfono el tablero mide exactamente lo mismo, porque los 2 o 3px que gana el
texto se los cede la ilustración. Lo que ya venía recortado a 320px lo sigue
estando igual, ni más ni menos.


## El mini juego dice qué te dejó

Los cuatro duelos terminaban contando **cómo salió** —¡LO PASÁS!, ATAJADÓN, SE
VA SOLO— y nada más. El medidor se movía después, en el HUD, con el cartel ya
cerrado: la carta te había prometido «+1 ⚡ o −1 ❤» antes de elegir el lado, y
el resultado no cerraba la frase.

Ahora la cierra, en la **misma chapa** que ya usaba el cartel de fallo (`.ef-fin`).
El mini juego sale solo con las stats empatadas, así que los ocho desenlaces son
fijos:

| carta | mini juego | ganás | perdés |
|---|---|---|---|
| DEFENSOR RIVAL | UNO CONTRA UNO | ¡LO PASÁS! · **+1 ⚡** | LA PERDISTE · **−1 ❤** |
| MEDIO RIVAL | LA MARCA | ¡SE LA ROBÁS! · **+1 ⚡** | TE PASÓ · **−1 ❤** |
| ARQUERO RIVAL | MANO A MANO | ¡GOLAZO! · **GOL · +1 ⚡** | ATAJADÓN · **−2 ❤** |
| DELANTERO RIVAL | DEFENDER | ¡LO CORTÁS! · **+3 ⚡** | SE VA SOLO · **GOL RIVAL · −1 ❤** |

Los números no están escritos: salen de `premioDuelo` y `costoDuelo`, **las
mismas funciones que después cobra `resolveCell`**. No hay una segunda tabla que
se pueda desincronizar el día que cambie un premio.

Los dos desenlaces que mueven además el marcador lo dicen adelante. El del
delantero es el que más falta hacía: perder ese duelo es gol en contra **y**
encima cuesta aguante por ser un duelo perdido, y de las dos cosas no se veía
ninguna.

### Dos puntas y un separador

A 320px «GOL EN CONTRA» se partía en dos renglones dentro de la caja. Cada punta
va ahora en su propio `.ef-p` con `white-space:nowrap`, la chapa envuelve entre
puntas y no dentro de ellas, y se dice **GOL RIVAL** —que es lo que dicen la
carta y el cartel de gol— en vez de «GOL EN CONTRA». Medido a 320px: la chapa
más larga ocupa 222px de los 250 disponibles, en un solo renglón, y la caja del
pop-up sigue midiendo lo mismo.

### Y dos cartas que se quedaban cortas

Repasando los carteles aparecieron dos que prometían de menos en el empate:

- **DELANTERO RIVAL** decía `+3 ⚡ o ⚽ GOL RIVAL`, sin el **−1 ❤** que además
  cuesta. Fuera del empate el mismo cartel sí lo decía, así que el empate era el
  único lugar donde la carta escondía la mitad del castigo. *(Se agregó, y más
  tarde se volvió a sacar: ver «El empate del delantero, sin el aguante» abajo.)*
- **ARQUERO RIVAL** decía `⚽ GOL o −2 ❤`, sin el **+1 ⚡** que carga ese gol.
  Todas las demás cartas que dicen GOL llevan el ⚡ al lado; ésta era la
  excepción.


## Las cartas de stat dicen qué pasa, no sólo cuánto cuesta

Las cuatro cartas de duelo tienen tres estados: tu stat es mayor y ganás solo,
es menor y perdés solo, o están empatados y sale el mini juego. Sólo el del
medio tenía nombre.

Ganando, el cartel era **un sustantivo seco** —PASA, ROBO, CORTE—. Y perdiendo
no era nada: sólo el `-1 ❤`. Tres de las cuatro cartas se veían **idénticas**
cuando ibas a perder, y no había forma de saber si te la robaban, te
gambeteaban o te la atajaban. Se sabía cuánto costaba, no qué pasaba.

Ahora los dos lados llevan **la palabra del mini juego**:

| carta | ganás | empate | perdés |
|---|---|---|---|
| DEFENSOR RIVAL | **LO PASÁS** | 1 vs 1 | **LA PERDÉS** |
| ARQUERO RIVAL | **GOL** | MANO A MANO | **ATAJADÓN** |
| MEDIO RIVAL | **LA ROBÁS** | LA MARCA | **TE PASA** |
| DELANTERO RIVAL | **LO CORTÁS** | DEFENDER | **GOL RIVAL** |

Leés LO PASÁS en la mesa y, si el duelo se juega, leés ¡LO PASÁS! en el cartel:
dos pantallas, una sola frase. El número se va abajo, al renglón del efecto, que
es donde ya vivía del lado ganador — así los tres estados tienen la misma forma.

### 1 vs 1

«UNO CONTRA UNO» eran catorce caracteres en una carta de 62px: el nombre del
mini juego era el más largo de los cuatro y el que menos entraba. **1 vs 1** dice
lo mismo en seis.

Escrito así, en minúscula, aparecía bien en la carta y mal en el pop-up: `.sit`
pone `text-transform:uppercase` y ahí salía «1 VS 1». Los otros tres títulos ya
venían escritos en mayúscula, así que el `uppercase` nunca se había notado. Se
apaga para el título del mini juego y el nombre se lee **como está escrito**.

### El gol del arquero, en su propio renglón

El empate del ARQUERO decía `⚽ GOL +1 ⚡ o -2 ❤` todo seguido, como si el gol
fuera parte de la cuenta. `.esgol` pasa a ser `display:block`: el gol arriba,
los dos medidores abajo. Vale igual en la carta y en el pop-up de la jugada.

### Lo que costó, medido

**Las ocho palabras entran en un renglón en las tres pantallas.** El hueco de la
carta —su ancho menos los 4px de padding de cada lado— es de 54px en un teléfono
de 320, 64 en uno de 360 y 72 en uno de 390. Las más largas son LO CORTÁS y LA
PERDÉS con 47px, y después ATAJADÓN con 46.

La única que no entraba era **SE LA ROBÁS: 56px contra 54 de hueco**. Se quedó en
**LA ROBÁS**, que son 43 y dice lo mismo. El cartel del mini juego sigue diciendo
«¡SE LA ROBÁS!» —ahí hay lugar de sobra y la exclamación pide la frase entera—.

Y el mismo tablero de doce cartas, antes y después:

| | 320×568 | 360×640 | 390×844 | 1366×768 |
|---|---|---|---|---|
| cartas que recortan | 9 → **12** | 4 → **4** | 0 → **0** | 0 → **0** |
| alto de la página | igual | igual | igual | igual |

En 320px las tres cartas de «perdés» pasan a recortar: antes tenían un número
suelto y ahora tienen una palabra más el renglón del efecto. Conviene leerlo con
lo que ya pasaba ahí: **en 320×568 la carta queda en 67px de alto y la
ilustración se achica hasta desaparecer**, y nueve de las doce ya recortaban sin
tocar nada. Es un problema de esa pantalla, anterior a esto y pendiente aparte.


## El empate del delantero, sin el aguante

`+3 ⚡ o ⚽ GOL RIVAL -1 ❤` era la línea más larga de las cuatro cartas de duelo,
y se rompía en el peor lugar: **«GOL / RIVAL»**, partido en dos renglones, se lee
como dos avisos en vez de uno.

Se saca el `-1 ❤`. Lo que está en juego en ese 50/50 es **el gol**; el aguante es
el costo de haber perdido un duelo, que vale igual para las cuatro cartas y ya se
cobra solo. Escribirlo ahí alargaba la única línea que no tenía lugar.

Y «GOL RIVAL» pasa a ser `white-space:nowrap`: o entra al lado del «o», o baja
entero.

### La pelota se queda en el lado bueno

Con `nowrap`, «⚽ GOL RIVAL» ya no se partía —pero medía **66px contra los 54 de
hueco** que tiene la carta en un teléfono de 320, así que en vez de partirse **se
salía de la caja** y `overflow:hidden` le comía la cola. Peor que antes.

Sin la pelota son **50px** y entra en las cuatro pantallas medidas —320, 360, 390
y 1366— siempre en un renglón. El ⚽ se queda donde sí hace falta: en el «⚽ GOL»
verde del arquero, que es lo único bueno que puede salir de esa carta.


## El remate del campeonato

CAMPEÓN y ELIMINADO eran **una lista**: el título suelto arriba, el marcador, el
camino, la plata flotando sin rótulo, un párrafo de letra chica y tres botones
del mismo dorado. Lo primero que la pantalla te ofrecía tocar era COMPARTIR, y
JUGAR OTRO CAMPEONATO —lo que casi todo el mundo quiere hacer— estaba último.

Ahora las dos son la misma pieza, con cabecera:

| | qué es |
|---|---|
| **la banda** | la palabra a todo el ancho, sobre un degradé del color del desenlace |
| **la cinta** | una línea: el dato duro —la copa, la ronda— y al lado la frase |
| **el cuerpo** | marcador, camino, y los números en **chapas** con su rótulo |

Los dos números que decidían —la plata que te queda y el máximo con el que
arranca el próximo campeonato— estaban uno flotando y el otro escondido en el
párrafo de abajo. Ahora cada uno tiene su chapa. En ELIMINADO las chapas dicen
otra cosa: hasta dónde llegaste y con qué plantel terminaste.

### El botón que manda

Volver a jugar va **primero** y es el **único botón relleno de todo el juego**:
los demás son contorno, así que no hay forma de confundirlo con COMPARTIR. Verde
—el color de «te suma»— también en ELIMINADO: perder no lo vuelve menos la
acción que querés.

### La foto que no entró

Se probó con la ilustración de campeón que el juego trae guardada y **se
descartó**: la imagen tiene su propio «¡¡CAMPEON!!» pintado adentro y la palabra
terminaba dos veces en la misma pantalla. La banda quedó como tipografía sola.

### Que no se corte abajo

Dos cosas, las dos medidas:

`.card` ya trae `max-height:calc(100vh - 28px)` y `overflow-y:auto`: en una
pantalla baja la tarjeta se topa con el techo y **rueda por dentro**. La primera
versión de esto le puso `overflow:hidden` por costumbre —no hace falta, `.card`
no tiene esquinas redondeadas— y en vez de rodar **se recortaba**: a 320×568 el
contenido pedía 721px, la caja quedaba en 530 y el botón verde no existía.

Y debajo de **700px de alto** el camino deja de ser una lista de cinco filas y
pasa a ser **cinco tramos en una sola fila**: el resultado grande, la ronda
abreviada arriba. Son los mismos 250px de lista en 60. No cambia una línea de
HTML —son las mismas filas, puestas en fila—; se cae el nombre del rival, que no
entra en 55px de ancho, y «ganado en penales» se abrevia a PEN.

Con eso, en 320×568 la pantalla de CAMPEÓN **entra entera**: 521px de contenido
en 525 de caja, sin rodar y con el botón a la vista.

| | 320×568 | 360×640 | 390×844 | 414×896 | 1366×768 |
|---|---|---|---|---|---|
| CAMPEÓN | 521 / **entra** | 521 / **entra** | 757 / **entra** | 748 / **entra** | 760 / rueda 6px |
| ELIMINADO | 591 / rueda 61px | 591 / rueda | 745 / **entra** | 745 / **entra** | 746 / rueda 6px |

ELIMINADO es más alta porque lleva además **las copas ganadas antes de caer**,
que también se apretaron: el trofeo y el título pasan a compartir renglón en vez
de ocupar tres. En 320×568 lo que queda abajo del borde es la fila de COMPARTIR
y COPIAR; el botón principal se ve.


## Pasaste de ronda: lo que cerraste y lo que se abre

Es la pantalla que aparece cuatro veces por campeonato y usaba **339 de los
768px** que tiene: el título, cinco chips del cuadro que se partían en dos
renglones, el marcador y el botón. El resto era aire.

Y le faltaban las dos cosas que se necesitan **dos toques después**, en el
vestuario, para elegir el refuerzo:

- **contra quién jugás ahora** — no se mencionaba;
- **con qué llegás** — aguante, racha y plata viajan entre partidos y tampoco.

De yapa, el nombre de la ronda aparecía dos veces con dos sentidos distintos:
arriba la que ganaste, y en el cuadro un chip verde con ese mismo nombre
mientras el dorado era **otra** ronda, la que viene.

Ahora la pantalla son **dos cajas lado a lado** —lo que cerraste y lo que se
abre— con el mismo molde que el remate del campeonato, en verde:

| | |
|---|---|
| **GANASTE** | el escudo del rival, el marcador y su nombre |
| **AHORA VA** | en dorado: el escudo del que viene, la ronda y su nombre |

Debajo, **el cuadro en cinco tramos** —✓ la ganada, VA la que viene, · las que
faltan— y **la franja del estado**: con cuántos ❤, cuánta ⚡ y cuánta plata
llegás. Y el botón verde relleno, el mismo de las otras dos pantallas de fin de
partido.

### El escudo del que viene es el que vas a ver en la cancha

El rival estrena escudo en cada partido, pero se sorteaba **dentro de
`startMatch`**: cuando esta pantalla se dibuja, ese escudo todavía no existe.
Mostrar uno cualquiera y después sacar otro en la cancha sería un cambio de
camiseta sin explicación.

Así que el sorteo se adelanta acá y se guarda en `G.escudoProx`; `startMatch`
lo usa si está y lo limpia. Verificado: lo que promete la pantalla es lo que
aparece en el partido.

`escudoRivalNuevo` además ahora acepta **a quién esquivar**. Evitaba la paleta
del jugador —los dos escudos van juntos en el marcador— pero no la del rival
anterior, y en esta pantalla los dos van uno al lado del otro: dos escudos
parecidos se leen como el mismo equipo. Ahora esquiva el fondo **y la forma**.

### Medido

| | 320×568 | 360×640 | 390×844 | 414×896 | 1366×768 |
|---|---|---|---|---|---|
| alto | 398 | 398 | 438 | 440 | 452 |
| entra sin rodar | sí | sí | sí | sí | sí |

Los cinco tramos del cuadro entran **en una sola fila** en las cinco, y ninguno
recorta su texto. La única que rueda es la horizontal de 390px de alto, donde no
entra ninguna pantalla del juego.

El `bracketHTML` de los cinco chips se borró: era su único uso.


## La ficha del ítem se borra, no se esconde

Al abrir la ficha de un ítem se veía **primero una vieja y rota, y después la
buena**. La ficha era **un solo elemento reciclado** y cerrarla sólo le sacaba
la clase `on`. Medido después de cerrar:

```
sigueEnElDOM: true      padre: SUPLENTES
conservaContenido: true nm: "SUPLENTES +1"
opacity: 0              --fx: 31px   --fy: 145px
```

Un zombi con el contenido del ítem anterior y las coordenadas del ancla
anterior, esperando a que alguien lo encendiera. Y tres formas de que eso
pasara:

1. **Se mudaba al ancla nueva antes de cambiarle el contenido.**
   `fila.appendChild(f)` iba diez líneas antes que `f.innerHTML = …`.
2. **La encendía un `requestAnimationFrame` sin guarda.** `cerrarFichaItem()`
   no lo cancelaba: si algo la cerraba en el mismo frame —el click global que
   cierra al tocar afuera, un `render()`— el frame siguiente la abría lo mismo,
   con lo viejo.
3. **Se cerraba en singular.** `querySelector('.item-ficha')`, y si alguna vez
   quedaban dos, la segunda no se cerraba nunca.

Ahora:

- `cerrarFichaItem()` **las borra del DOM**, todas, con `querySelectorAll`.
- `nuevaFicha()` arma una en cada apertura y **se llena antes de colgarla** del
  ancla: no existe el instante en que el contenido de un ítem esté puesto sobre
  otro.
- `mostrarFicha()` la enciende **en el mismo tick**, forzando el reflow
  (`void f.offsetWidth`) para que la transición arranque igual. Sin
  `requestAnimationFrame` no hay nada pendiente que pueda reabrirla.
- Los handlers se buscan **dentro de la ficha** (`f.querySelector`) y no por
  `getElementById`, que podía encontrar el botón de una ficha vieja.

Vale para las dos que comparten el elemento: la de ítems y la de la posibilidad
de gol.

### De paso, dos cosas que estaban de más

`abrirFichaGol` le ponía `position:relative` **al contenedor de afuera** del
banner, no al ancla; el `.gol-ancla` ya lo trae del CSS. Y le agregaba la clase
`ficha-gol` a mano, que ahora viene con `nuevaFicha('ficha-gol')`.

### Lo que no se pudo mirar, y por qué importa

En el panel del navegador de trabajo la página corre **oculta**
(`visibilityState: 'hidden'`) y ahí **`requestAnimationFrame` no dispara nunca**
—0 frames en 1,2s, medido—. Con el código viejo eso significaba que la ficha
**no aparecía en absoluto**: quedaba en `opacity: 0` para siempre. No era el bug
que se reportó, pero es el mismo `rAF` el culpable de las dos cosas, y sacarlo
arregla las dos.

Probado con la transición desactivada para poder medir el estado final: la ficha
abre en `opacity: 1`, 370×117 en el teléfono, anclada en `--fy`. Cambiar de ítem
deja **una sola** ficha con el contenido del ítem nuevo; el segundo toque en el
mismo ítem la cierra; tocar afuera la cierra y **no queda ninguna en el DOM**;
USAR gasta el ítem y cobra el efecto; y abrir un ítem con la ficha de gol
abierta no arrastra ni la clase `ficha-gol` ni sus cinco casillas.


## El pop-up roto no era viejo: era el mismo, deformado

La limpieza de la ficha no alcanzó, y el dato que lo resolvió fue **que a la
ficha de la posibilidad de gol no le pasaba**. Las dos son el mismo elemento con
el mismo CSS; lo único distinto es **de quién cuelgan**:

| | dónde vive | qué se toca |
|---|---|---|
| ficha de ítem | **adentro** del botón del ítem | el botón, su padre |
| ficha de gol | en `.gol-ancla` | el cartel, su **hermano** |

Y en mobile la ficha va `position:fixed`, con `top:var(--fy); left:10px;
right:10px`. Un `transform` en cualquier ancestro convierte a ese ancestro en el
**bloque contenedor** de los descendientes fijos: la ficha deja de medirse contra
la pantalla y pasa a medirse contra el botón, que tiene 73px de ancho.

`.onda-viva` —el hundido del toque, `translateY(1.5px) scale(.985)`— pone
exactamente ese transform en lo que tocás, **durante 130ms**.

Medido en 390×844, poniendo y sacando el transform con la ficha abierta:

```
sin transform    370x117 en (10, 145)   <- su lugar
con transform     51x283 en (92, 254)   <- una columna rota, abajo de todo
```

Eso es lo que se veía: no un pop-up viejo, **el mismo pop-up deformado** mientras
duraba el hundido, y después saltando a su lugar. 130ms alcanzan para verlo.

La ficha de gol se salvaba porque el transform va en el cartel y ella cuelga del
padre del cartel, no del cartel.

### El arreglo

El botón **no se hunde**; se hunde **lo que tiene adentro**:

```css
.item.onda-viva{transform:none !important}
.item.onda-viva > *:not(.item-ficha){
  transform:translateY(1.5px) scale(.985);
  transition:transform .09s;
}
```

Se ve igual —el ícono, el texto y la caja de la onda bajan lo mismo— y el botón
deja de crear bloque contenedor. La ficha queda fuera del hundido, que además es
lo correcto: no es parte del botón, está anclada a la pantalla.

Probado con `.onda-viva` puesta a mano en los cuatro ítems: la ficha abre en
`10,145 370x117` en los cuatro, el botón computa `transform:none`, USAR sigue
gastando el ítem y cobrando el efecto, y no queda ninguna ficha en el DOM.


## El velo se va, y el contraste sube

El fondo de la mesa era la foto del césped **más un velo radial** que abría al
centro y cerraba casi a negro en los bordes. La idea era que el tablero se
recortara mejor. Medido, hacía **lo contrario**.

El promedio real de la foto —sacado pixel a pixel— es **rgb(73, 137, 104)**. El
relleno de la carta es casi opaco (`.95`), así que queda en **rgb(4, 28, 74)**:
casi negro. Con las cartas tan oscuras, **cuanto más se oscurece el fondo menos
se despegan**. El velo no las hacía resaltar: las escondía.

Contraste WCAG entre la carta y el fondo que la rodea, en tres puntos:

| fondo | centro | costados | esquina |
|---|---|---|---|
| con velo | 3,8:1 | 1,9:1 | **1,0:1** |
| **sin velo** | **4,0:1** | **4,0:1** | **4,0:1** |

**1,0:1 quiere decir que la carta y el fondo tienen la misma luminancia.** En las
esquinas —donde caen las filas 1 y 4— la carta se fundía con el pasto.

Se compararon seis fondos en la mesa real a 390px: el de hoy, la foto sola, la
foto con el verde levantado (`saturate(1.3) brightness(1.08)`, 4,7:1 pero un
verde que la foto no tiene), un velo plano (2,0:1, se come la mitad), la viñeta a
la mitad (3,9 / 2,8 / 1,9) y un verde liso sin foto (3,1 / 2,0 / 1,3).

Queda **la foto sola**: es el verde real de la cancha, el contraste más alto sin
retocar nada y el único parejo de punta a punta.

```css
background:
  var(--fondo-pasto, none) center/cover no-repeat,
  #0a3a20;
```

### Lo que se pierde

El velo no estaba sólo por contraste: **bajaba el ruido** de la foto en los
bordes y llevaba la vista al centro. Sin él el césped se ve entero, con su
textura y sus líneas. Es el precio de que el verde sea el que la cancha tiene.


## El fondo termina en negro, y el borde pasa a hacer el trabajo

Se compararon seis fondos sin foto sobre la mesa real —negro, azul noche,
papelitos, verde liso, gris pizarra y una luz de reflector— y quedó **el negro**.

```css
background:
  radial-gradient(ellipse 120% 90% at 50% 35%, #14141a 0%, #0a0a0d 65%, #060608 100%);
```

No es negro plano: abre un punto en el centro y cierra en los bordes, así la
mesa cae sobre la parte más clara sin que se note el degradé.

### Lo que cambia al sacar la foto

La carta es una caja casi negra —`rgb(4, 28, 74)`— con un borde fino. Contra el
verde de la foto el relleno contrastaba **4,0:1** y la carta se leía **como
bloque**. Contra negro ese número cae a **1,1:1**: la carta deja de ser un bloque
y pasa a ser **un contorno con una foto adentro**.

No es peor, es otra cosa —las cartas flotan en vez de recortarse— pero cambia
quién hace el trabajo: lo hace el borde. Y el borde de hoy tampoco alcanzaba:

| fondo | borde / fondo | relleno / fondo |
|---|---|---|
| la foto del césped | 2,9:1 | 4,0:1 |
| negro, con el borde viejo | 1,6:1 | 1,1:1 |
| **negro, con el borde claro** | **4,7:1** | 1,1:1 |

Así que `--filo` sube de `#1c4a8f` a **`#3d7ed6`**. El contorno queda en 4,7:1,
más de lo que llegó a tener sobre el césped.

### La regla que nunca se aplicó

Buscando esto apareció que **el borde de la carta no usaba `--filo`**. El bloque
«EL FILO SOBRE EL CÉSPED» le ponía `border-color:var(--filo)`, y cien líneas más
abajo otro `.cell` repetía el atajo completo:

```css
border:1px solid var(--line);
```

El atajo pisa el `border-color` anterior. Medido en el juego, el borde computaba
`rgb(18, 51, 110)` —que es `--line`—, así que el ajuste hecho cuando se puso el
césped **vino sin efecto desde entonces**. Ahora el color va en la misma
declaración que el borde, que es el único lugar donde no se lo pueden pisar.

Le pasa lo mismo a `.panel` y a `.marquesina`: declaran `border-color:var(--filo)`
y un rulo posterior se los pisa con el atajo. Quedan como están —con el borde
oscuro— y eso está bien: sobre negro el que tiene que gritar es el borde de la
carta, no el de los paneles. Pero conviene saberlo antes de tocar `--filo` de
nuevo esperando que los mueva a los tres.

### Lo que quedó sin usar

`pasto` —el recorte del césped, unos 15KB de base64— **ya no lo usa nadie**: era
el único consumidor de `--fondo-pasto`. La variable se sigue calculando al
arrancar. `cancha`, la foto del estadio completo, sí sigue en uso en la
marquesina del menú.


## Al arquero se la clavás

La carta del ARQUERO RIVAL, cuando le ganás por stats, decía **GOL**. Cuenta el
resultado, pero no dice quién lo hace — y las otras tres cartas de stat sí:

```
DEFENSOR RIVAL   LO PASÁS
MEDIO RIVAL      LA ROBÁS
DELANTERO RIVAL  LO CORTÁS
ARQUERO RIVAL    LA CLAVÁS     ← la cuarta, misma forma
```

Pronombre y verbo en segunda persona, como las otras tres.

**Y el gol baja a la línea del efecto**, con el mismo `.esgol` verde que usa el
empate de esa misma carta. Los tres estados del arquero pasan a leerse como
hermanos:

| | arriba | abajo |
|---|---|---|
| ganás | LA CLAVÁS | ⚽ GOL · +1 ⚡ |
| empate | MINI JUEGO · MANO A MANO | ⚽ GOL · +1 ⚡ o −2 ❤ |
| perdés | ATAJADÓN | −1 ❤ |

`duelo()` toma un parámetro nuevo, `golGana`, porque es la única de las cuatro
donde ganar el duelo además es gol.

### Por qué no «LE HACÉS EL GOL»

Era lo pedido, y **no entra**: mide 72px contra los 54 de hueco que tiene la
carta en un teléfono de 320, así que se parte en dos renglones. Medido con la
tipografía real, a 11,5px:

| | ancho | ¿entra? |
|---|---|---|
| LA CLAVÁS | 46px | sí |
| LA METÉS | 43px | sí |
| LO VENCÉS | 47px | sí |
| GOLAZO | 35px | sí |
| SE LA METÉS | 56px | no |
| LE HACÉS GOL | 60px | no |
| LE HACÉS EL GOL | 72px | no |

### El renglón del gol va apretado

Poner el gol en su propia línea le agrega un renglón a la carta, y en un teléfono
de 360 eso la pasaba **por 2px**. El renglón del gol es una sola palabra, no
necesita el interlineado de una frase: `line-height:1.05` en vez del 1,35 del
resto del efecto, y sobra.

Medido con el mismo tablero de doce arqueros, antes y después:

| | 320×568 | 360×640 | 390×844 |
|---|---|---|---|
| la carta ganada recorta | 11px → 21px | 0 → **0** | 0 → **0** |

En 320 ya recortaban las doce antes de tocar nada —es el apretón conocido de esa
pantalla— y ahí el sobrante crece. En 360 y 390 no cambia nada.


## El penal definitorio dice qué se juega

Empatás en los 90 en una ronda de paso y el campeonato se define en **un solo
penal**. Son dos pantallas —el aviso del empate y el tiro— y ninguna decía la
única cosa que importa: **si el arquero la ataja, se terminó la corrida**.

Lo que había era «TE QUEDA UNA SOLA PELOTA»: suena bien y no aclara nada.

Ahora el aviso lleva **dos chapas**, una verde y una roja:

| | ronda de paso | la final | partido único |
|---|---|---|---|
| verde | SI ENTRA → *SEMIFINAL* | SI LA GANÁS → CAMPEÓN | SI LA GANÁS → TE LO LLEVÁS |
| roja | SI LA ATAJA → SE ACABÓ | SI LA PERDÉS → SE ACABÓ | SI LA PERDÉS → SE ACABÓ |

La verde **nombra la ronda que ganás**, no dice «pasás de ronda». Y la pantalla
distingue los tres casos porque la final y el partido único van a tanda de cinco,
donde el penal no es uno solo.

La misma información baja al tiro, fina, abajo del arco: `ENTRA → SEMIFINAL` y
`LA ATAJA → SE ACABÓ`. Ahí es donde hay que poder mirarla mientras elegís.

Y el desenlace **nombra** lo que ganaste o perdiste: antes decía «PASÁS DE RONDA»
o «SE TERMINA ACÁ», ahora dice **SEMIFINAL** o **SE ACABÓ EL CAMPEONATO**.

### De paso, dos cosas más

El marcador pasa a ser **el mismo componente** que usan las pantallas de fin de
partido —con los dos escudos— en vez de un número grande con los nombres sueltos
abajo. Y se fue el **⚖**, que era de los últimos emoji del teclado que quedaban
en una pantalla grande. La cabecera es ahora EMPATE con una cinta abajo que dice
la ronda, el mismo molde que el remate del campeonato.

**El mini juego no se tocó**: el arco, las tres zonas, la animación del tiro y la
del arquero quedan exactamente como estaban.

### La cinta que se salía mal

`.pn-cinta` usa `margin: 0 calc(var(--apx) * -1)` para salirse del padding del
cartel, como la foto de cabecera. No alcanzaba: el `*{max-width:100%}` de arriba
de la hoja se lo anulaba y la cinta quedaba del ancho de su contenido y pegada a
la izquierda, con el hueco del padding a la vista a la derecha. Es un caso ya
conocido y ya tenía su lista —`.c-art, .a-foto, .mam-art, .dc-cinta`—; la cinta
del penal se suma.

Medido en 320×568, 390×844 y 1366×768, en los tres casos —ronda de paso, final y
partido único—: ninguna pantalla rueda.


## El tutorial pasa a fichas

Las seis reglas iban apiladas, centradas y pegadas. Medido en un teléfono de
390×844: la pantalla ocupaba **735 de los 768px** disponibles y entre el texto de
una regla y el título de la siguiente quedaban **7px**. Sin lugar para separar
nada, las seis se leían como una sola columna de texto dorado y blanco alternado.

Ahora cada regla es **una ficha**, y van de a dos. La separación no la da el aire
sino **el borde de cada caja**, y de paso se ve de un golpe que las reglas son
seis. La de las cuatro cartas ocupa las dos columnas: necesita el ancho.

El resultado es más corto que antes en todos lados:

| | hueco | antes | ahora | sobra |
|---|---|---|---|---|
| 320×568 | 530 | 521 | **496** | 34px |
| 360×640 | 590 | 581 | **522** | 68px |
| 390×844 | 768 | 718 | **667** | 101px |
| 414×896 | 820 | — | **658** | 162px |

En escritorio ya eran dos columnas desde una regla vieja; esto sólo extiende lo
mismo al teléfono.

### Posibilidad de gol

El aguante y la racha terminan en lo mismo y el texto no lo decía con el nombre
que usa el juego. El cartel de la mesa dice **POSIBILIDAD DE GOL**; las dos
fichas ahora también:

- **el aguante** — «El físico. Si se **vacía**, es **posibilidad de gol** para el rival.»
- **la racha** — «El envión. Si se **llena**, es **posibilidad de gol** para vos.»

El resto de los textos se acortaron: es lo que pide una caja de media pantalla.

### Dos cosas que costaron

**`.fi` ya existía.** La primera versión llamó a las fichas `.fi`, y esa clase
es el ícono del cartel de gol (`.gf .fi`) **y los dos íconos del pie de página**
(`.ft .fi`): una regla `.fi{}` sin scope les puso borde, fondo y padding a los
dos del pie. Se ven en la captura antes de renombrar a `.tu-fi`, que es el
prefijo que ya usan las piezas del tutorial.

**Y en el teléfono no entraba.** Con los mismos valores que en 390, la pantalla
pedía 609px de los 590 que hay en un 360 y 633 de 530 en un 320 — el texto en una
caja de media pantalla se parte en tres o cuatro renglones. Se aprieta por tramo:
debajo de 440px bajan el padding, el gap y el interlineado; debajo de 360, además,
los cuerpos de letra y el reloj.

`tutoRegla` se reemplazó por `tutoFicha`. Las reglas `.regla`, `.rg-txt`,
`.rg-vis` y `.rg-tit` quedan sin uso —están repartidas en media docena de media
queries— y conviene limpiarlas en una pasada aparte.


## La posibilidad de gol, de los dos lados

Es **una sola jugada** y se anunciaba de dos maneras. Cuando se te vacía el
aguante, la posibilidad de gol del rival frena la pantalla con un cartel grande
al centro: tag, medidor, título, la línea, el 51% y las cinco jugadas. Cuando se
te llena la racha, la tuya se abría en una fichita colgada del cartel de la mesa
—la mitad de tamaño, con el tablero todavía a la vista debajo—.

Medido en un teléfono de 390px: el cartel del rival mide **463px de alto** y la
fichita medía **178**. La misma información, y la que menos pesaba era la que te
convenía.

Ahora son la misma pieza. `.sit.sorteo` es lo que comparten —las casillas, el
cursor blanco del sorteo, el tope de alto y el scroll propio— y encima va el
color: `.sit.fundida` en rojo, `.sit.llena` en verde. Lo único que cambia entre
una y otra es de quién es la llegada y qué medidor va arriba: los cuatro
corazones o los cuatro rayos.

| | hueco | cartel | sobra |
|---|---|---|---|
| 320×568 | 492 | **382** | 110px |
| 360×640 | 564 | **345** | 219px |
| 390×844 | 768 | **437** | 331px |
| 1280×720 | 644 | **521** | 123px |

### Lo que no se copió

El cartel del rival **no se puede cerrar**: te fundiste y el sorteo va igual. El
tuyo sí, con un VOLVER al lado del USAR LA RACHA —la racha queda cargada hasta
que la gastes, así que mirarla no puede costarte nada—. También cierra tocando
el velo, o volviendo a tocar el cartel de la mesa. Mientras corre el sorteo no
cierra por ningún lado: los botones ya están deshabilitados y el resultado ya
está decidido.

Y se quedan las dos marcas que sólo existen de tu lado: la jugada clara en verde
—la que entra siempre— y el penal en dorado, que se patea en vez de sortearse.

### La chapa del mini juego

Aprovechando, un bug que estaba en vivo. La chapa **MINI JUEGO** de la casilla
del penal salía sin el pill dorado: las reglas que lo pintan están scopeadas a
las cartas de la mesa (`.c-out .mj-lb, .p-out .mj-lb`), así que adentro de
`.fg-art` no llegaba ninguna. Quedaba texto blanco en bloque y sin fondo dorado:
**34px de ancho por 22 de alto**, partido en tres renglones encima de una foto
de 30.

Puesto el pill, apareció el segundo problema: no entra en el ancho de la foto
—pide 53px y la foto tiene 41—. Dos cosas lo resuelven:

- el recorte redondeado pasa de la caja a la imagen, así `.fg-art` puede dejar
  que la chapa se salga y use el ancho de la casilla entera;
- el `*{max-width:100%}` de arriba de todo la seguía atando al ancho de la foto,
  aunque el `width:max-content` dijera otra cosa. Ya hay cinco elementos con
  la excepción puesta a mano (`.c-art`, `.a-foto`, `.mam-art`, `.dc-cinta`,
  `.pn-cinta`); éste la lleva en su propia regla.

Medida por tramo, para que entre en la casilla y no pise a la vecina: **45 de 51**
en el teléfono (sin el 🎮, que se lleva 8 de esos píxeles) y **87 de 91** en
escritorio, ahí sí con el emoji.

### Duplicación que se fue

`esperadoDe(lista)` y `minisGol(lista, favor)`: el promedio de las cinco estaba
escrito **tres veces** y el marcado de las casillas **dos**. Ya habían quedado
distintos una vez —los avisos prometían 38% cuando la ficha decía 51—.

Queda sin uso el CSS de la fichita vieja: `.item-ficha.ficha-gol`, `.fg-top`,
`.fg-nm`, `.fg-esp` y `.gol-ancla`, repartidos en seis media queries, más los
`:not(.ficha-gol)` que ahora sobran. Conviene limpiarlo en una pasada aparte,
junto con `.regla` / `.rg-*` del tutorial.


## El filo subido no había llegado a los paneles

Cuando se cambió el fondo a negro, `--filo` pasó de `#1c4a8f` a `#3d7ed6` para
que el borde de las cartas se despegara. Medido ahora en el navegador, el filo
nuevo estaba **sólo en las cartas**: la marquesina y los cuatro paneles seguían
en `--line` (`#12336e`).

Es el mismo error que ya se había arreglado en `.cell`, en otros dos lugares. El
color estaba escrito:

```css
.panel{border-color:var(--filo);box-shadow:0 10px 30px rgba(0,6,18,.6)}
.marquesina{border-color:var(--filo);border-top-color:var(--gold); …}
```

…pero **más abajo en la hoja** los dos vuelven a declarar `border:1px solid
var(--line)`, y el shorthand repinta el color. Las sombras de ese bloque también
las pisaba un `box-shadow` posterior, así que las dos líneas enteras no hacían
nada. Se borraron, y el filo va en la misma declaración que el borde:

| | antes | ahora |
|---|---|---|
| `.cell` | `#3d7ed6` | `#3d7ed6` |
| `.marquesina` | `#12336e` | **`#3d7ed6`** |
| `#panelItems` | `#12336e` | **`#3d7ed6`** |
| `#panelEquipo` | `#12336e` | **`#3d7ed6`** |
| `#panelPlantel` | `#12336e` | **`#3d7ed6`** |
| `#panelLog` | `#12336e` | **`#3d7ed6`** |

El relato tenía además **su propio** `border` en la media query de escritorio, así
que hicieron falta tres declaraciones, no dos. El filo de arriba de la marquesina
sigue dorado.

**La regla que sale de acá:** en esta hoja, un `border-color` suelto sólo es
seguro si no hay ningún `border` shorthand para ese selector más abajo. Cuando lo
hay —y acá suele haberlo, porque los bloques de color están arriba y los de
estructura abajo— el color tiene que ir en el shorthand.

### Y se fue el césped

`pasto` era el recorte de la cancha que usaba el fondo de la mesa. Cuando se sacó
la imagen de fondo, quedaron los **20 KB de base64** y el arranque que los cargaba
en `--fondo-pasto` en cada partida. Ninguna regla leía esa variable. El archivo
pasa de 1259 a 1238 KB.


## Las cartas tienen canto

La carta era un rectángulo plano con un borde de 1px. Ahora es una ficha
apoyada sobre la mesa, y al elegir la fila se levanta. Todo con CSS: no entra
ni una imagen ni una línea de JavaScript.

### El canto

Cuatro sombras de 1px apiladas hacia abajo dibujan el espesor; la quinta,
difusa, es la sombra que la carta tira sobre la mesa. Dos sombras internas
hacen la luz del borde de arriba y el filo oscuro del de abajo, y un degradado
blanco en el relleno es el brillo del plástico.

Son sombras: se pintan una vez con la carta y **no cuestan nada por cuadro**.

El canto vive en `--canto` y no en un `box-shadow` suelto. El resaltado por
tono —`.row.hl .cell.tono-good` y sus cinco hermanos— es más específico y su
`box-shadow` de color habría borrado el canto apenas se resaltaba la fila. Con
la variable, cada tono **compone**: `box-shadow:var(--canto), 0 3px 14px <tono>`.

### Levantarse

Al elegir la fila la carta sube 7px, se acerca 30 en el eje Z y se inclina 6
grados. La perspectiva vive en `.cells`, es decir **en cada fila**: así las
cuatro cartas comparten punto de fuga y la mesa en reposo no se inclina.

Se descartó inclinar el tablero entero, que era la opción más espectacular:
rasterizar en ángulo ablanda los nombres y los porcentajes, que es justamente
lo que hay que leer para elegir.

El levantado usa `translate` y `rotate`, **no** `transform`. Son propiedades
aparte, así que se componen con el `transform` en vez de pisarlo: la animación
de la carta jugada (`.hit`, que la agranda de golpe) y el `scale` del VAR
siguen corriendo encima del levantado, sin el salto que había al arrancar la
animación con la carta ya inclinada.

Y un brillo diagonal cruza la ilustración de la carta elegida, en una sola capa.

### Las tres cosas que hubo que atender

**El hueco vacío no es una ficha.** `.cell.empty` lleva `--canto:none` y
`box-shadow:none`: un agujero en la mesa no puede tener espesor.

**En el teléfono el canto es otro.** En escritorio la carta mide 185px de ancho
y el canto de 4px es el 2% de eso; en un teléfono de 390 la carta mide 80 y ese
mismo canto pasa a ser el 5%, con la sombra difusa comiéndose los 5px que
separan las filas. Debajo de 440px el canto baja a 2px y la carta se levanta 4
en vez de 7.

**Movimiento reducido.** La carta no se inclina ni se acerca: sube los mismos
2px de antes. El canto se queda, que es color y no movimiento.

### Medido

Nada de esto toca el layout —sombras, `translate`, `rotate` y un `::after`
absoluto no mueven una caja—, y se verificó con el partido andando:

| | carta | levantada | scroll horizontal |
|---|---|---|---|
| 320×568 | 62×67 | 64×68 | no |
| 390×844 | 80×140 | — | no |
| 1050×720 | 127×217 | 136×216 | no |
| 1280×800 | 185×221 | — | no |

El recorte de texto es el mismo que antes del cambio: 2 a 3px en `.c-nm` por
redondeo de interlineado, en las 16 cartas, con y sin el canto. Se comparó
guardando el cambio en un `stash` y midiendo las dos versiones sobre el mismo
tablero.


## Después del pitazo final no se juega más

Se podía. Entre el pitazo y el cartel del resultado quedaba **casi un segundo**
con la mesa viva: dos toques ahí adentro y salía una jugada más, con el reloj
en cero y el «📣 Pitazo final» ya escrito en el relato.

Reproducido espiando `chooseLine` en un partido llevado a mano hasta el final:

```
chooseLine(row,0) con phase=match  busy=false reloj=1   ← la última, legítima
chooseLine(row,1) con phase=result busy=false reloj=0   ← una más, después del final
```

### Por qué

Tres cosas, y ninguna sola alcanzaba para abrir el agujero:

1. `finDeJugada` apagaba `G.busy` **antes** de llamar a `endMatch`. Como
   `endMatch` es asíncrono —`await wait(500)`, y después los penales o el cartel
   de resultado—, entre una cosa y la otra la mesa quedaba destrabada.
2. `tapLine` sólo miraba `G.busy` y `G.targeting`. La fase no.
3. Y el `render` seguía dando las filas por jugables: `const usable = libres > 0
   && !G.busy && !G.targeting`. Sin la fase, la fila se mostraba encendida,
   con cursor de mano y resaltado al pasar — invitando al toque.

Los **ítems ya lo hacían bien** desde antes: `b.disabled = G.busy || G.phase !==
'match' || …`. Las filas y las columnas eran las que faltaban.

### Lo que se hizo

- `tapLine` se cierra con `G.phase !== 'match'`.
- `usable` de las filas y `libre` de las columnas —que también apaga el cartel
  de la posibilidad de gol— suman la fase, así la mesa **se ve** apagada y no
  sólo no responde.
- `endMatch` se llama antes de soltar `G.busy`, para que no quede ni un tick con
  las dos puertas abiertas.

### Y el 1v1 lo tenía peor

`duelFinDePartido` no marcaba fase ninguna: se iba directo a los penales con
`G.phase` todavía en `'match'`, así que ahí la mesa quedaba viva **durante toda
la tanda**, no un segundo. Ahora marca `'result'` en la primera línea;
`duelResultado` la devuelve a `'match'` para el partido siguiente de la serie.

### Medido

Con el arreglo puesto, martillando `tapLine` dos veces por tick durante los 19
ticks que van del pitazo al cartel de GANASTE:

| | antes | ahora |
|---|---|---|
| llamadas a `chooseLine` tras el pitazo | 1 | **0** |
| filas con `onclick` | 4 | **0** |
| botones de fila habilitados | 4 | **0** |
| botones de columna habilitados | — | **0** |
| ítems habilitados | 1 | **0** |
| cartel de posibilidad de gol | activo | **apagado** |

Verificado en los dos modos —partido único y 1v1— y comprobado que un partido
nuevo vuelve a habilitar todo: `phase=match`, 4 filas jugables, ítems activos.


## La franja del teléfono es una consola

Arriba de la mesa había **cinco cajas sueltas** flotando sobre el fondo: el
aguante, la racha, la plata, el plantel y los ítems, con los ocho medallones al
aire y sin nada que los contuviera. Ahora son **dos cajas** con el mismo marco y
el mismo radio —el tablero de mandos y el plantel— y adentro de la primera los
tres medidores separados por hilos en vez de por aire.

**La grilla no se toca.** Las áreas, las filas y los gaps son los de antes, así
que el responsive se sigue comportando igual; lo único que cambia es qué pasa
adentro de cada celda.

### El medidor, en barra

Cuatro dibujos del mismo corazón ocupaban 104px para decir un número del 0 al 4.
Ahora el dibujo va **una sola vez**, a la izquierda, y el nivel lo dicen cuatro
tramos de 19px: se lee de un golpe, sin contar medallones.

El medallón **sigue siendo un `<img>`**: en vez de cambiar el marcado, el mapa
de bits se empuja fuera de la caja con `object-position:-999px`. La imagen no se
dibuja, el fondo del elemento sí, y queda el tramo. Un `content-visibility:hidden`
hacía lo mismo en una línea, pero es mucho más nuevo y en un iPhone viejo habría
mostrado el corazón aplastado en 7px de alto.

### Los huecos de ítem que te quedan libres

La fila ya tenía cuatro columnas fijas, pero las vacías no se veían: con dos
ítems parecía que la fila se había quedado corta en vez de que te sobraban dos
lugares. Ahora se dibujan punteadas. Sólo en el teléfono — en escritorio la
lista es una columna y serían renglones muertos.

### Dos cosas que costaron

**El `#panelEquipo` adelante, y no las clases a secas.** Los mismos `.hearts` y
`.racha-track` aparecen en el vestuario (`.e-item`), donde tienen que seguir
siendo los medallones. Y con dos clases tampoco alcanzaba: más abajo en la hoja
hay un `.med-art{width:22px;height:22px}` para pantallas de 440 que ganaba por
orden y dejaba los corazones como bolas rojas de 19×22 en vez de barras.
Medido: con `.hearts .med-art` la racha salía bien y el aguante no, porque la
racha tenía una segunda regla que la salvaba de casualidad.

**La amarilla acumulada** se dibujaba como un anillo alrededor de los cuatro
corazones. Sin corazones, el anillo pasa al ícono.

### El pop-up del ítem

Se revisó lo que pediste —que el de la derecha no se salga del margen— y **no se
sale en ningún lado**, porque en el teléfono la ficha no está anclada al botón:
va `position:fixed` con `left:10px;right:10px`, ocupando la pantalla menos el
margen, y lo único que apunta al ítem es el pico. Medido abriendo los cuatro:

| | ficha | ¿se sale? | pico |
|---|---|---|---|
| 320×568 | 10 → 310 | no | 23 · 81 · 139 · 198 |
| 390×844 | 10 → 380 | no | 31 · 107 · 183 · 259 |
| 740×400 (apaisado) | 10 → 730 | no | — |
| 1050×760 (escritorio) | 214 → 396 | no | — |

En escritorio sí está anclada, pero se abre **hacia la derecha** del panel de
ítems, que es la columna de la izquierda: le sobran 650px.

Lo que sí cambió es el radio: la ficha pasa de 9 a 12px y sus botones a 8, para
que hable el mismo idioma que la consola.


## Las filas y las columnas, con el material del tablero

Eran **los dos únicos rectángulos del juego sin una sola esquina redondeada**, y
los últimos con el borde viejo de `--line`, mientras las cartas, la consola, los
ítems y los carteles ya habían pasado a `--filo` y radios de 9 a 12px. Ahora
llevan el degradado de las cartas, el filo y 12px.

### Los pesos, dados vuelta

Lo que se decide al tocar una fila es **el porcentaje** —cuántas cartas quedan
por jugar ahí—, no el número de fila. «F1» es un nombre, y ya está escrito cuatro
veces en la pantalla. Así que F1 baja a rótulo de 9,5px y el 25% sube a número
de 19.

La columna era **una sola cadena de texto**: `'C1 · 25% −3⚡'`, con las tres
cosas pesando igual. Ahora son tres partes envueltas: el nombre de rótulo, el
porcentaje de número, y el costo apartado por un hilo, porque es lo único que
*te sale* en vez de lo que ganás.

Los tamaños de esas tres partes van en **`em`, no en píxeles**: el botón ya se
achica por breakpoint —en el teléfono es `min(11px, 2.8vw)`— y así las tres se
achican con él sin repetir la escala en cada media query. Y el color se hereda,
que es lo que mantiene el encendido intacto: apagada la columna es `--dim2`, con
la racha llena es dorada, y el porcentaje se pone blanco sólo cuando de verdad
se puede jugar.

### El `line-height:1.25` que no es al ojo

Pasar el texto de una cadena a tres hijos flex **borra el strut** de la caja de
línea del botón, y ahí se perdían 3px de alto. La mesa, que es `flex:1`, se
comía esos 3px — justo lo que no se puede mover.

El número va a `1.25em` con `line-height:1.25`. Se probó primero `1.16`, que es
el ratio exacto en el papel (`1.25 × 1.16 = 1.45em`, la caja de línea de antes),
y dejaba el botón en 25px contra los 26 de siempre: el strut no se recupera con
la cuenta, hay que medirlo. Con `1.25` el botón vuelve a medir **exactamente**
lo de antes en los tres teléfonos.

### Medido, antes y después

Comparado guardando el cambio en un `stash` y midiendo las dos versiones:

| | fila | columna | tablero | scroll |
|---|---|---|---|---|
| 320×568 | 38×68 → **38×68** | 63×26 → **63×26** | 310×285 → **310×285** | ninguno |
| 360×640 | 38×85 → **38×85** | 73×28 → **73×28** | 350×356 → 350×355 | ninguno |
| 390×844 | 38×136 → **38×136** | 81×29 → **81×29** | 380×558 → **380×558** | ninguno |
| 740×400 apaisado | — | 122×29 | 534×269 | ninguno |

En 320 y en 390 los tres números son idénticos. En 360 el tablero queda 1px más
bajo por acumulación de subpíxeles, sin scroll de ningún lado. En escritorio la
columna crece 0,4px —de 35,9 a 36,3— sobre una página que ya scrollea por
diseño, así que no mueve nada.

El texto de la columna entra en todos lados: pide 61px de los 63 que hay en un
320, 79 de 81 en un 390 y 120 de 122 apaisado.


## Cuántos ítems tenés, en su propia columna

Lo único que decía qué llevabas era una chapita pegada al nombre: **24×17px con
el número en 10**. Y sólo aparecía si tenías al menos uno, así que la lista no
distinguía «no tengo» de «no hay nada que decir» — para saber con qué contabas
había que leer los cuatro renglones.

Ahora es **una columna**, alineada en los cuatro: el número pasa de 10 a 19px y
el que no tenés muestra un cero apagado en vez de no mostrar nada.

```
antes:  [icono]  SUPLENTES x1          €10M
        [icono]  SEGUNDO AIRE          €30M     ← no dice nada

ahora:  [icono]  SUPLENTES      ┌───┐  €10M
                                │ 1 │
                                │Tenés│
        [icono]  SEGUNDO AIRE   ┌───┐  €30M     ← dice cero
                                │ 0 │
                                │Tenés│
```

El `min-width:40px` es lo que la mantiene alineada: sin él, el 0 y el 2 dan
anchos distintos y la lista deja de barrerse de un vistazo.

### Lo que cuesta

La columna le roba 40px de ancho al texto, y eso puede partir un efecto largo en
dos renglones. Medido, con un suplente y dos gritos en la mochila:

| | 320×568 | 390×844 |
|---|---|---|
| SUPLENTES | 62 → **62** | 62 → **62** |
| GRITO DEL DT | 64 → **64** | 64 → **64** |
| SEGUNDO AIRE | 62 → **74** | 62 → **62** |
| VAR | 62 → **62** | 62 → **62** |
| la tarjeta entera | 469 → **481** | 515 → **515** |

O sea: **en 390 no cuesta nada**, y en 320 cuesta 12px, todos del efecto largo de
SEGUNDO AIRE —«+2 ❤ y recuperás un ❤ de máximo»— que ahí sí se parte en dos.
La tarjeta sigue sin scroll propio en las dos medidas.

### Y también en el vestuario

`filaItem` la comparten el mercado del campeonato y la pantalla de elegir ítems
del partido único, así que el contador aparece en las dos. En el vestuario
cuenta lo que llevás elegido, que es justo lo que el jugador está armando.

La chapita `.f-x` se fue. Compartía regla con el `máx 1` de los ítems que no se
acumulan (`.f-max`), así que esa regla se separó en vez de borrarse entera.


## El arquero del penal se describe desde tu lado

Reporte: «me dijo que el arquero se tiró a la izquierda, yo pateé a mi izquierda
de la pantalla, e hice el gol». No era ambigüedad — **el texto contradecía la
animación**.

El cartel decía «se tira a su derecha» y «a su izquierda», que es correcto
**desde el arco** y al revés de todo lo demás que ve el jugador: los botones, las
flechas ⬅ ➡ y el arquero moviéndose están en el lado de la pantalla. Como el
arquero está de frente, su izquierda es tu derecha.

```
zona 0 → x 48  → izquierda de la pantalla → decía «se tira a su derecha»
zona 1 → x 100 → el medio                 → decía «se queda parado en el medio»
zona 2 → x 152 → derecha de la pantalla   → decía «se tira a su izquierda»
```

Así que al patear a la izquierda y ver al arquero volar a la derecha, el cartel
decía «se tira a su izquierda». Y encima era gol, que es lo que lo volvía
incomprensible.

`animarPenal` lo manda a la zona `suyo`, que es la misma coordenada de pantalla
que los botones, así que ahora el texto nombra esa zona: **vuela a tu izquierda**
/ **se queda parado en el medio** / **vuela a tu derecha**.

Se descartó «se tiró para el otro lado», que era la otra salida: no sirve cuando
el arquero se queda en el medio y pateaste a un palo, ni cuando los dos van al
mismo lado.

### Verificado

Reproducido el caso del reporte pateando siempre a la izquierda de la pantalla y
midiendo **al arquero en plena animación**, antes de que el cartel tape el arco:

| | |
|---|---|
| pateo | izquierda de la pantalla |
| el arquero se mueve a | `+52px` → derecha de la pantalla |
| resultado | ¡GOL! |
| cartel | «LA PONÉS IZQUIERDA · EL ARQUERO VUELA A TU DERECHA» |

Y las nueve combinaciones de palo contra palo dan un texto que nombra la zona a
la que el arquero efectivamente fue, con el resultado que corresponde.

`PALOS` la usa sólo `tirarPenal` —el penal definitorio—; la tanda de cinco tiene
sus propios textos y no se tocó.


## Un solo velo y una sola caja

Cada pop-up era un overlay suelto: se creaba su `div`, se colgaba del `body` y
al cerrarse se sacaba entero. Encadenar dos —que es lo que pasa todo el tiempo:
la jugada y el gol, el empate y el penal, el sorteo y la llegada— daba tres
cortes seguidos.

```
del empate al arco   wrap.remove() saca el overlay y recién después se monta
                     el siguiente → un fotograma con la mesa a la vista, y el
                     cartel nuevo arrancando de scale(.72)

del arco al result.  no es un pop-up nuevo: es un innerHTML sobre el mismo.
                     Corte seco, y la caja salta de 370 a 196px de alto

al cerrar            .saliendo le bajaba la opacidad **al velo entero**, no al
                     cartel: la mesa aparecía por detrás mientras el cartel
                     todavía se estaba yendo
```

Ahora los **catorce** pop-ups del juego comparten un velo y una caja. Cuando uno
sigue a otro no se saca nada: la caja se estira o se encoge hasta el tamaño del
cartel nuevo, el filo se funde del color viejo al nuevo, y el contenido que se
va queda un instante encima —quieto, en su lugar— y se apaga.

### Las tres piezas

`montarPop(wrap)` reemplaza al `document.body.appendChild(wrap)` de cada
pop-up. Si no hay nada arriba monta el velo tal cual venía, con su animación de
entrada de siempre; si ya hay uno, transforma el que está y **devuelve ese**,
que es el que el pop-up tiene que seguir usando para enganchar sus botones. Por
eso cada llamador pasó de `const wrap` a `let wrap`.

`morfarPop(caja, clase, contenido)` es el cambio en sí. Lo usan tanto el pop-up
que reemplaza a otro como los cinco que se resuelven en el lugar —la moneda, el
penal de la tanda, el mano a mano, la situación de gol y el penal definitorio—,
que antes hacían `box.className = …; box.innerHTML = …` de un fotograma al otro.

`cerrarPop()` reemplaza a los `wrap.remove()`. **No levanta el velo en el
acto**: le da 90ms de gracia por si atrás viene otro cartel. Si viene, el velo
no se levanta nunca; si no, se va. Es lo único que hace falta para que las
cadenas se encadenen solas, sin que ningún pop-up tenga que saber cuál es el
siguiente.

Y `esperarOClick` ahora resuelve en el acto en vez de esperar a que el velo
termine de desvanecerse: si esperara, el pop-up de atrás no llegaría a tiempo
para agarrar el tiempo de gracia y la cadena volvería a cortarse.

### El que se va

El truco para que el contenido se disuelva sin tocar el marco es un **fantasma**:
los hijos del cartel viejo se mudan a un `div` absoluto adentro de la caja, con
las clases del cartel viejo —para que se siga viendo igual— pero sin su borde ni
su fondo, que son los de la caja y no se van a ningún lado. El `padding` se le
copia antes de cambiar las clases, porque el aviso y la situación no tienen el
mismo.

Así el contenido nuevo está en su lugar **sincrónicamente**, que es lo que
permitió no tocar ni una línea de los catorce pop-ups: todos siguen haciendo su
`wrap.querySelector('#unBoton').onclick = …` en el renglón de abajo.

### Los tamaños se sueltan

El píxel es lo que rompe el responsive, así que dura poco: la caja lleva un
`width`/`height` explícito **solo mientras corre la transición**, y a los 360ms
se sueltan. En reposo cada cartel mide exactamente lo que dicen sus reglas, con
sus mismos breakpoints — rotar el teléfono o cambiar de ancho lo reacomoda igual
que antes.

Medido, abriendo los doce pop-ups uno por uno contra la versión anterior:

| | 320×568 | 390×844 | 1280×800 |
|---|---|---|---|
| aviso de empate | 296×434 | 350×421 | 538×474 |
| el arco del penal | 294×370 | 350×370 | 538×512 |
| el penal resuelto | 294×207 | 350×196 | 538×273 |
| mano a mano | 294×455 | 350×487 | 538×684 |
| mano a mano resuelto | 294×225 | 350×225 | 538×299 |
| situación de gol | 294×298 | 350×301 | 538×401 |
| cartel de gol | 280×231 | 350×301 | 538×379 |
| aviso de racha llena | 296×431 | 350×553 | 538×612 |
| se te funde el equipo | 296×395 | 350×461 | 563×529 |
| tiempo de descuento | 296×486 | 350×613 | 538×679 |

**Los treinta valores son idénticos a los de v154**, incluidos los cinco que
pasan por una transformación. Tenía que ser así: al soltarse los píxeles la caja
queda con la misma clase y el mismo contenido que le ponía el código viejo.

### Lo que sí se mueve

La cadena del penal definitorio, medida en vivo:

| | alto | filo |
|---|---|---|
| empate | 421px | blanco |
| a mitad de camino | 414px | blanco → dorado |
| el arco | 370px | dorado |
| ¡GOL! | 196px | verde |

Un solo cartel que cambia tres veces, en vez de tres carteles que se pisan.

### Detalles

`.pop-caja` lleva `animation:none`: `poppin` se dispara cada vez que se le
aplica la clase al elemento, así que sin eso la caja rebotaba en el medio de la
transformación. El cierre sí la necesita, y por eso `.saliendo .pop-caja` la
vuelve a pedir con `!important`.

La clase de la caja se pone **un recálculo antes** que el resto, para que el filo
ya tenga su transición puesta cuando le cambia el color. Y el arranque de la
transformación no usa `requestAnimationFrame` sino un `void offsetHeight`: así
también termina bien cuando el navegador tiene los frames congelados —una
pestaña en segundo plano, una ventana tapada—, donde `rAF` no corre nunca.

`.saliendo` ahora desvanece también el aviso y el pop-up de la jugada, que no
estaban en la lista y se iban de golpe. Y el velo espera 60ms antes de empezar a
irse, para que el cartel salga primero; el velo se saca a los 300, que es lo que
suman esa espera y sus 220 de desvanecido.

Las **pantallas** —el mercado, el resultado del partido, el menú— no entran acá:
esas son `openCard`, tienen su propio overlay y su propia apertura, y no se
encadenan entre sí.


## El botón verde se volvía ilegible al tocarlo

Reporte: «el texto del hover en los botones verdes queda mal contrastado y en
algunos casos no se ve».

Pasaba **sólo en el teléfono**, y no era el color del texto: era el fondo. En
touch el `:hover` se queda pegado al último elemento que tocaste hasta que
tocás otra cosa —por eso existe el bloque de `@media (hover:none)` que los
apaga uno por uno—, y ahí había una regla de más:

```css
/* el hover del CTA dorado, que se pintaba siempre */
.cta:hover{ …; background:linear-gradient(160deg, rgba(58,48,6,.95), …) }

/* y el deshacer, en (hover:none) */
.cta:hover:not(.alt):not(.ghost){ background:<el marrón de base del dorado> }
```

El deshacer pesa **(0,4,0)** —los dos `:not()` cuentan como clase—, y
`.cta.jugar` pesa (0,2,0) y `.cta.jugar:hover` (0,3,0). Así que el marrón del
dorado le ganaba al verde, y el verde tiene su texto en `#04220f`, que es casi
negro porque va sobre verde claro.

Medido, en un teléfono emulado:

| | en reposo | con el hover pegado |
|---|---|---|
| JUGAR OTRO CAMPEONATO | 6.57 | **1.04** |
| IR AL VESTUARIO | 6.57 | **1.04** |
| EMPEZAR DE NUEVO | 6.57 | **1.04** |

1.04 es texto invisible: el mínimo legible es 4.5.

### El arreglo

El fondo del hover se mudó adentro de `@media (hover:hover)`, que es donde va:
si no hay mouse no se pinta, y entonces **no hay nada que deshacer**. El
deshacer de `(hover:none)` se borró.

El peso de la regla no cambia —una media query no suma especificidad— así que
sigue perdiendo contra `.cta.alt` y contra `.cta.jugar`, que van después. Y el
mismo tratamiento se le dio a `.cta.jugar:hover`, que en touch dejaba el verde
encendido como si el botón siguiera elegido.

De paso se arregló otro que venía en el mismo paquete: el **A VER QUÉ PASA** de
la fundida, que es rojo, también perdía su tinte y se pintaba de marrón al
tocarlo.

### Verificado

Con la hoja del juego entera espejada —`:hover` → `[data-hov]`, en su mismo
lugar del cascade, para no cambiar ningún desempate—, en las dos condiciones:

| | teléfono (reposo → hover) | escritorio (reposo → hover) |
|---|---|---|
| `.cta.jugar` verde | 6.57 → **6.57** | 6.57 → **7.92** |
| `USAR LA RACHA` verde | 6.57 → 6.57 | 6.57 → 6.57 |
| `.cta` dorado | 10.24 → **10.24** | 10.24 → **8.24** |
| `A VER QUÉ PASA` rojo | 4.87 → **4.87** | 4.87 → 4.87 |

En el teléfono ya **no cambia nada** al tocar, que es justo lo que el bloque de
`(hover:none)` quería lograr. En escritorio el hover sigue haciendo lo de
siempre.


## El remate, sobre una chapa

PASASTE, CAMPEÓN y ELIMINADO comparten molde: banda con la palabra, cinta con
el dato, cuerpo. Eran la **única pantalla plana que quedaba** — desde el
relieve 3D el tablero tiene las cartas levantadas y los paneles hundidos, y acá
todo seguía siendo una caja igual a la otra, seis una abajo de la otra, con el
marcador pesando lo mismo que el camino y que la plata.

Ahora la tarjeta es una **placa**: filo claro arriba, canto abajo, 16 de radio.
Y todo lo que va adentro —las dos cajas del partido, el marcador, el camino, la
plata, la franja— está **hundido** en ella: filo negro, fondo más oscuro que la
placa y una sombra interior arriba. Es el mismo par que el tablero: la carta se
levanta, el panel se hunde. El botón es lo único que sobresale, y lleva su
propio canto.

### El color se muda de filo

La banda dejó de ser un lavado del color del resultado —un dorado, un verde o
un rojo al 15% detrás de la palabra— y pasó al azul de la placa. El color vive
ahora en el **filo de abajo de la banda**: 2px a todo el ancho, pegado a la
palabra.

```
antes:  borde de arriba de la tarjeta, 3px del color
        + banda con un lavado del mismo color detrás del título

ahora:  borde de arriba, 2px de --filo    ← el filo levantado de la placa
        + banda azul
        + filo de abajo, 2px del color    ← dorado, verde o rojo
```

El filo de arriba lo necesita la placa: es lo que la hace parecer levantada. Y
el color se lee mejor pegado a la palabra que en un borde arriba de todo.

La tarjeta **no lleva `overflow:hidden`**: el radio recorta solo, porque
`.card` ya tiene `overflow-y:auto` para poder rodarse. Ponérselo dejaba a
CAMPEÓN sin scroll, con el botón abajo del borde.

### Los escudos, grandes

Son lo que el jugador reconoce —el suyo y el del que viene— y medían 40px en
PASASTE y 34 en el marcador, menos que el número que tienen al lado. El tamaño
se lo daba un atributo del SVG, así que crecen desde el CSS sin tocar una línea
de JS:

| | antes | ahora | en pantalla corta |
|---|---|---|---|
| PASASTE, las dos cajas | 40 | **58** | 46 (antes 32) |
| el marcador | 34 | **42** | 38 |

### El camino, un riel

Eran cinco cajas con filo y fondo propios, y contra la placa competían con las
dos del partido, que son las que importan. Ahora es el nombre, el estado y un
tramo del color que corresponde: **40 → 35px**, y deja de pedir atención.

### Lo que cuesta, medido

Los escudos cuestan alto y CAMPEÓN no tiene de dónde sacarlo: en un teléfono de
844 mide 761 contra un hueco de 768. Así que lo que crece de un lado se
devuelve del otro —el marcador achica su `padding` de 13 a 9 y el escudo se
despega 3px menos— y en pantallas cortas los escudos crecen menos.

Alto de la tarjeta, contra v156:

| | 320×568 | 390×700 | 390×844 | 1280×800 |
|---|---|---|---|---|
| PASASTE | 402 → **414** | 403 → **415** | 442 → **461** | 456 → **475** |
| ELIMINADO | 494 → **488** | 480 → **474** | 621 → **619** | 622 → **620** |
| CAMPEÓN | 525 → **519** | 527 → **521** | 761 → **759** | 764 → **762** |

CAMPEÓN y ELIMINADO quedaron **más cortos** que antes, y ninguna de las tres
necesita rodarse en ninguna de las cuatro medidas. PASASTE crece de 12 a 19px y
le sobra pantalla: su botón termina a 618 de 844.

### Scopeado

`.marcador` y `.hist` los comparten otros carteles —el aviso de empate, el
resumen del duelo—, así que todo el material va bajo `.card-remate`. Verificado
en el aviso de empate: sigue con su `padding` de 13, sin radio y con el escudo
en 24.


## La ficha del ítem: una foto y el antes → después

La tira que se abre al tocar un ítem decía el nombre, el efecto y media línea
—«El DT levanta al equipo»— con un ícono de 18px. No contestaba la única
pregunta que uno se hace con el ítem en la mano: **qué me va a pasar si lo uso
ahora**.

Ahora son dos cosas nuevas: una **miniatura de 78px** y un renglón con el
medidor **antes y después**.

### La foto: no hay arte de ítems, hay arte prestado

El juego tiene 44 imágenes y **ninguna se hizo para un ítem**: son las cartas de
la mesa, las situaciones, los carteles de gol y los remates. Pero cuatro de las
que hay dicen exactamente lo que el ítem hace:

| | foto | qué se ve |
|---|---|---|
| SUPLENTES | `medio` | un jugador entero, entrando |
| GRITO DEL DT | `cooling` | **el DT gritándoles en el cooling break** |
| SEGUNDO AIRE | `hinchada` | la tribuna empujando |
| VAR | `offside` | la jugada que quedó anulada |

Van en `ITEMS[k].art`, así que el día que haya arte propio se cambia la clave y
nada más. Peso agregado: **cero** — las cuatro ya estaban en el juego.

### El antes → después, con los números de la partida

```
antes:   GRITO DEL DT  +1 ⚡
ahora:   GRITO DEL DT  +1 ⚡
         2 ⚡  →  3 ⚡
```

«+1 ⚡» obliga a mirar el medidor, acordarse de en cuánto estaba y sumar.
`pasoItem(k)` lo dice hecho, con los topes que cobra `useItem`, así que lo que
promete la ficha es exactamente lo que va a pasar — incluido el máximo que
recupera el SEGUNDO AIRE, que cambia el techo del aguante en la misma jugada:
`2 ❤ → 4 ❤ de 4 máx`.

Con el medidor al tope **no se muestra el paso**: ahí el ítem no hace nada, y
prometer «3 ❤ → 3 ❤» sería peor que no decir nada. En su lugar va el motivo,
que es lo que ya hacía `itemInutil`.

### El filo, dorado

El celeste (`#5ecdf2`) no aparecía en ningún otro lado del juego. La ficha **es
una decisión** —tiene un USAR y un VOLVER—, así que va en el color con el que el
juego pregunta: el dorado del CTA y de las chapas.

Se redefine **en la ficha, no en `:root`**: `--fi-luz` es además el tono «gol»
de las cartas de la mesa —`.play.gol`, `.c-out.gol`— y pisarlo arriba les
cambiaba el color a ellas.

### Dónde se despliega

No cambió, y conviene dejarlo escrito porque las maquetas de comparación la
mostraban al pie y daban a entender otra cosa: en el teléfono la ficha es
`position:fixed` con `z-index:300`, pegada **8px debajo de la barra de ítems** y
**por encima del tablero**. Nunca hay que rodar nada.

| | ficha | arriba de todo | libre abajo |
|---|---|---|---|
| 320×568 | 300×156 | 145 (barra a 142) | 267 |
| 390×844 | 370×156 | 145 (barra a 142) | 543 |
| 740×360 apaisado | 720×162 | 144 (barra a 141) | 54 |

### Y de paso, el escritorio

En escritorio la ficha **nunca llegó a medir los 250px que pide**: el
`*{max-width:100%}` global la ataba al ancho del botón del ítem, 184. Se armaba
angosta y altísima y nadie lo había mirado. Con la miniatura adentro pasó de feo
a inusable —62px de columna de texto y 364 de alto—, así que salió a la luz:

| | antes | ahora |
|---|---|---|
| SUPLENTES | 182×251 | **250×158** |
| GRITO DEL DT | 182×261 | **250×148** |
| SEGUNDO AIRE | 182×364 | **250×238** |

Un `max-width:none` en la regla base. Y la columna de texto necesitaba su
`flex`: sin él se quedaba en su ancho mínimo —121 de los 250 libres— y la
descripción se desbordaba de la fila.


## La columna latía con el texto adentro

Reporte: «el % y el número de las columnas cambian de tamaño cuando están
activas; solo deberían resaltarse y parpadear».

El parpadeo de la columna habilitada es `titilarBorde`, y en el medio del ciclo
tenía un `transform`:

```css
0%,100%{ box-shadow: …1px…;   transform:scale(1, 1) }
50%    { box-shadow: …2.5px…; transform:scale(1.012, 1.055) }
```

La escala es **del botón entero**, así que se la comen también el porcentaje y
el costo — y no es pareja: 1.2% de ancho contra 5.5% de alto, o sea que el texto
además se estira.

Medido en 390, con el botón en su estado de reposo y en el del 50%:

| | 0% y 100% | 50% |
|---|---|---|
| el botón | 80.5 × 29.1 | 81.5 × 30.7 |
| el «25%» | 22.8 × 17.1 | **23.1 × 18.0** |

Casi un píxel de alto, dos veces por ciclo. Y al pasarle el dedo o el mouse
—que corta la animación con `animation:none`— volvía de golpe a 17.1: por eso
se leía como que el texto cambiaba de tamaño **al activarse** la columna, cuando
en realidad dejaba de latir.

El parpadeo no necesitaba la escala: lo hace el anillo, que es `box-shadow` y no
toca el layout. Sacándola, la columna se sigue resaltando y latiendo igual —de
1px a 2.5px de anillo y de .25 a .75 de resplandor— con el texto quieto en
22.8 × 17.1 en todo el ciclo y también con la columna activa.

`titilarBorde` lo usa **sólo** la barra de columnas, así que no arrastra nada
más. Las filas nunca tuvieron el problema: no laten, y su estado activo es un
`translateX(2px)`, que mueve pero no escala.


## El cartel de posibilidad de gol: una luz que pasa

Misma historia que las columnas en v159, un cartel más arriba. El cartel corría
`golvivo` —que además de la luz lo escalaba a **1.03**— y la chapa USAR corría
`latido`, que la escalaba a **1.22**. Las dos escalas son del elemento entero,
así que se llevaban puesto el texto de adentro.

Medido en 390, comparando el reposo con el pico del ciclo:

| | en reposo | en el pico |
|---|---|---|
| el cartel | 380.0 × 39.0 | **391.4 × 40.2** |
| POSIBILIDAD DE GOL | 74.0 × 10.4 | **76.2 × 10.8** |
| la chapa USAR | 44.4 × 23.0 | **55.8 × 28.9** |

La chapa crecía **un cuarto de su tamaño**, dos veces por ciclo. Y había algo
peor que lo estético: en el pico el cartel medía **391.4px en una pantalla de
390**. Se salía del margen.

### Lo que hace ahora

El resplandor verde pasa a ser **fijo** y lo que se mueve es **una luz que cruza
el cartel** de punta a punta, en un pseudo-elemento que recorta el
`overflow:hidden` del cartel. La chapa tiene su propia luz, que le pasa por
adentro: es un `background-position` que se corre, no una escala.

```
el cartel   barrido    1.8s   el brillo ocupa el último 56% del ciclo:
                              cruza en 1s y descansa 0.8s
la chapa    chapaluz   2.2s   continuo, sin pausa
```

Los dos ritmos son distintos a propósito: sincronizados, el cartel entero
pulsaría de una sola vez, que es de lo que veníamos.

**No hay un solo `transform` en juego.** El cartel se queda en 380.0 × 39.0, el
título en 74.0 × 10.4 y la chapa en 44.4 × 23.0 — siempre, en todo el ciclo.

El `barrido` arrancó en 2.6s y quedó en **1.8**: a 2.6 la luz pasaba una vez
cada dos segundos y medio y se hacía esperar demasiado.

### Contraste

La chapa cambió de fondo plano a degradado, así que hay dos extremos que
verificar. El texto pasó de `--black` a `#04220f`:

| | |
|---|---|
| USAR sobre el verde | 9.39 |
| USAR sobre el claro del degradado | 15.14 |
| POSIBILIDAD DE GOL sobre el cartel | 7.03 |

### Lo que se fue

`golvivo` no lo usaba nadie más que este cartel, así que se borró. `latido`
queda para el último corazón, que es lo único que sí tiene que interrumpir lo
que estés mirando — ahí el pulso irregular es lo que corresponde, y como es un
ícono sin texto adentro, la escala no rompe nada.

El bloque de `prefers-reduced-motion` ya apagaba las dos animaciones viejas;
ahora además esconde el pseudo-elemento del brillo, así que ahí el cartel queda
con su resplandor fijo y nada más.

### La familia de animaciones, actualizada

Al comentario de arriba de todo le quedaba una categoría sola. Ahora son dos:
`latido` para lo que tiene que interrumpir, y `barrido` / `chapaluz` —una luz
que pasa, sin pulso— para lo que puede quedar encendido varias jugadas al lado
de la mesa.


## La marquesina, hundida en la pantalla

Era **lo único cuadrado que quedaba**: `border-radius: 0` mientras las cartas,
los paneles, los botones de fila y columna y la ficha del ítem están todos en 12
y la placa del remate en 16.

Ahora tiene radio 14 y, en vez de levantarse como el remate, **se hunde**: es el
marco del partido, no algo que se toca. El relieve queda para lo que sí se toca
—las cartas, los botones— y la marquesina se lee como parte de la pantalla.

El dorado no se va: pasa de borde a **hilo interior**, del mismo grosor que
tenía.

### Sin tocar el modelo de caja

Los breakpoints ya le cambian el `padding` a la marquesina —`11px 18px`,
`4px 8px`, `5px 9px` según la medida— así que el cambio no podía meterse ahí.
Cambian **sólo color, radio y sombras**; los anchos de borde y el `padding`
quedan exactamente como estaban.

Medido contra v160, con y sin la chapa de campeonatos:

| | v160 | v161 |
|---|---|---|
| 320×568 | 310.0 × 62.0 | **310.0 × 62.0** |
| 390×844 | 380.0 × 62.0 | **380.0 × 62.0** |
| 740×360 apaisado | 730.0 × 58.0 | **730.0 × 58.0** |
| 1280×800 | 1237.0 × 104.0 | **1237.0 × 104.0** |

### La chapa de campeonatos ocupaba el doble de lo que se veía

Tenía un `transform:scale(.75)` en el teléfono. Eso **pinta más chico pero no
achica la caja**: con tres copas se veía a 90px y seguía ocupando **120**. Esos
30px de aire, más los 120 en sí, empujaban el marcador hasta dejar al rival en
«DEPO…».

Y lo que más medía era la palabra: «CAMPEONATOS» son 63 de los 120. Así que en
el teléfono la chapa se achica con **tamaños de verdad** y se queda con la copa
y el número; la palabra sigue en escritorio, donde sobra lugar.

De paso, el trofeo dejó de repetirse: era uno por campeonato hasta cuatro. Ahora
es **una copa y un ×N**.

| con 3 campeonatos | antes | ahora |
|---|---|---|
| la chapa | 119.7px | **40.7px** |
| la columna izquierda | 159.6px | **65.3px** — la del nombre de la ronda |

Con una sola copa la chapa mide 27.7 y el `×N` no aparece: una copa sola ya
dice que ganaste uno.

### El escudo, siempre arriba del nombre

En el teléfono ya era así, pero en escritorio no había ninguna regla para
`.mq-eq` y el escudo y el nombre caían uno al lado del otro: el escudo terminaba
**96.7px a la izquierda** del centro del nombre. Es la misma pieza en las dos
medidas, así que la columna va en la regla de base y ahora el desplazamiento es
**0.0** en todos lados.

### Y los nombres entran hasta INDEPENDIENTE

El tope estaba en 9ch en la caja y 8ch en el nombre —39px, que cortaba en
«DEPORTIV…»—. Ahora son **18ch, 79px**:

| | antes | ahora |
|---|---|---|
| INDEPENDIENTE (74.4px) | cortado a 39.5 | **entero** |
| DEPORTIVO BARRIAL (95.4px) | cortado | cortado a 89.0 |

Lo que no entra se sigue cortando con puntos suspensivos, como pedía el reporte.
Y entra entero **aunque estén las tres copas**, porque la chapa dejó de robarle
ancho al centro.

### Al pasar

`.mq-lado` quedó sin dueño: el marcado usa `.mq-eq` y esa clase no existe en el
DOM, así que las reglas de `.mq-lado` —incluidas las de `turno-0` / `turno-1`,
que apagan al equipo que no tiene la pelota— no se aplican a nada. No se tocó
acá para no mezclar, pero está anotado.


## Las puntas del pop-up: la mesa se va atrás

Lo del medio se resolvió en v155 —un velo y una caja que se transforma— pero las
dos puntas habían quedado sin hacer. Y eran desparejas: **la salida sí estaba
pensada** —el cartel se va en 220ms y el velo lo sigue 60 después— y la entrada
no tenía nada. El velo se colgaba del `body` **ya con su fondo y su desenfoque
puestos**, así que la mesa pasaba de nítida a tapada en un fotograma y el cartel
arrancaba su `poppin` sobre una pantalla que ya había cambiado del todo.

Ahora pasan dos cosas juntas: el velo **se enciende** en 200ms, y la mesa **se va
atrás** — se aleja a `scale(.955)` y se apaga a `brightness(.72)`. No es que se
tapó la mesa: es que el cartel está delante de ella. Al cerrarse, la mesa vuelve
sola, y esa vuelta es lo que le faltaba a la salida.

```
entra   el velo      opacidad y desenfoque, 200ms
        la mesa      scale(.955) + brightness(.72), 240ms, origen 50% 42%
sale    el cartel    golsale, 220ms
        la mesa      vuelve, 240ms — arranca junto con el cartel
        el velo      220ms con 60 de retraso, y se saca a los 300
```

El origen está arriba del centro geométrico —42%— porque abajo hay menos mesa
que arriba: con 50% el alejado se comía la franja de ítems más que la marquesina.

### En la cadena, la mesa se queda atrás

La mesa va atrás cuando se monta el velo y vuelve cuando se le pone `.saliendo`,
no cuando se lo saca. Como el velo es uno solo y sobrevive a toda la cadena, la
mesa no parpadea entre cartel y cartel. Medido en la del penal definitorio:

| | mesa |
|---|---|
| empate | atrás |
| en el cambio | atrás |
| el arco | atrás |
| ¡GOL! | atrás |
| cerrando | **adelante** |

### El pozo del bloque contenedor

Un `transform` —y un `filter`— convierten al elemento en el **bloque contenedor
de todo lo que tenga `position:fixed` adentro**. Y adentro de `.wrap` hay dos
cosas fijas en mobile: la ficha del ítem y el panel del relato.

Es el mismo pozo que ya está documentado dos veces en la hoja —el hover del ítem
y el hundido del toque—, así que acá se cierran las dos antes de mover la mesa.
Medido, abriendo la ficha con la mesa en cada posición:

| | la ficha del ítem |
|---|---|
| mesa adelante | 370 × 156 en (10, 145) — contra la pantalla |
| mesa atrás | 344 × 149 en (23, 168) — contra la mesa |

No es sólo defensivo: con un cartel ocupando la pantalla, dejar la ficha o el
relato abiertos abajo no tiene sentido igual.

**Y la vuelta dura 240 y no 280 por la misma razón.** Mientras la transición
corre, el `transform` sigue vivo y con él el bloque contenedor. El velo —que es
lo que impide tocar un ítem— se saca 300ms después del cierre, así que con 280
quedaban 20ms de margen y con 240 quedan 60. La vuelta más corta además se
siente mejor.

### Verificado

Un partido entero jugado solo, con los trece tipos de cartel que salieron:
**nunca hubo más de un velo** a la vez, no quedó ninguno colgado y la mesa
terminó siempre adelante.

En `prefers-reduced-motion` la mesa no se mueve: queda sólo el apagado a `.78`,
que es lo que separa los planos.


## Los pop-ups acostados, sin tocar el vertical

Del testeo de los once pop-ups en nueve medidas salieron dos cosas: **las siete
verticales pasan limpias** y las dos apaisadas estaban rotas. Lo apaisado no es
prioridad, así que el arreglo tenía una condición: **no puede influir en
vertical**.

Entra entero en el bloque que ya existía de
`@media (max-height:560px) and (orientation:landscape)`. Una consulta con
`orientation:landscape` **no puede matchear en vertical**: el vertical queda
igual por construcción, no por cuidado.

### Qué estaba roto

En 780 × 360 el cartel del mano a mano medía **539px de alto en una pantalla de
360**. Sin `max-height` y sin scroll ni en el cartel ni en el velo, se salía
105px por arriba y 75 por abajo, y lo de arriba era **inalcanzable**. El penal
de la tanda hacía lo mismo con 464. Son los dos pop-ups donde hay que elegir
algo, así que la jugada no se podía terminar sin volver a poner el teléfono
vertical.

Los que sí se clavaban lo hacían por el `max-height:88vh` del bloque de 821+ de
ancho, que en un iPhone acostado —844 de ancho— es el que gana. Los de 780 no
entraban en esa puerta y quedaban sueltos.

### Qué hace ahora

```css
@media (max-height:560px) and (orientation:landscape){
  .gol-flash,.play-flash,.sit-flash{padding:8px 12px 34px}
  .gf,.sit,.aviso,.play,.pop-caja{max-height:calc(100dvh - 50px);overflow-y:auto}
}
```

Dos cosas. El tope, atado al alto real de la pantalla, para que los carteles se
rueden adentro en vez de perderse afuera. Y el velo, que dejaba **56px
reservados abajo para una franja que mide 29**: acostado, donde el hueco útil
bajaba a 284, esos 27px son la diferencia entre rodar y no rodar.

| apaisado | antes | ahora |
|---|---|---|
| 780 × 360 | 7 de 11 rotos | **8 de 8 ok** |
| 844 × 390 | 9 de 11 rotos | **8 de 8 ok** |

El mano a mano pasa de 420 × **539** —fuera de la pantalla por los dos lados— a
420 × **310**, rodable y entero adentro del hueco.

### Y el vertical, idéntico

Los once pop-ups, medidos en las siete medidas verticales, antes y después:

| | |
|---|---|
| 320 × 568 | idéntico |
| 375 × 667 | idéntico |
| 360 × 780 | idéntico |
| 390 × 844 | idéntico |
| 412 × 915 | idéntico |
| 430 × 932 | idéntico |
| 744 × 1133 | idéntico |

**77 medidas, 77 iguales.** Y la cadena del penal definitorio sigue andando
igual en apaisado: un solo velo, la mesa atrás los tres carteles y adelante al
cerrar.

### Lo que se dejó como está

El **breakpoint** —que un iPhone acostado se lleve el layout de escritorio
porque mide 844 de ancho y la puerta de mobile pide 820— no se tocó. Arreglarlo
es una línea, pero cambia qué layout gana en esa medida: es un cambio grande
para algo que no es prioridad, y con los carteles clavados ya no molesta.

Y el **descuento en 320 × 568**, que entra con margen cero —492 en un hueco de
492—, tampoco: achicarlo sería tocar vertical, que es justo lo que no había que
hacer. Queda anotado: un renglón más de texto ahí se corta.


## La franja de la derecha

Dos cosas que pasaban en el mismo renglón: el **plantel** no cerraba con los
dos renglones que tiene al lado, y el **dinero** quedaba pegado a la racha.

### El plantel, corto por tres píxeles de cada lado

La franja es una grilla de dos filas —medidores arriba, ítems abajo— y el
plantel ocupa las dos. Pero la grilla tiene `align-items:center`, así que en
vez de estirarse se **centraba**: medía 57 donde las dos filas abarcan 63.
Arrancaba 3px más abajo que los medidores y terminaba 3px más arriba que los
ítems, y las tres cajas no cerraban por ningún lado.

```css
#panelPlantel{grid-area:stats;justify-self:end;align-self:stretch}
#panelPlantel{... gap:5px ...}
#panelPlantel .stat{flex:1;justify-content:center; ...}
```

Las tres líneas van juntas. `align-self:stretch` estira el panel; `flex:1`
hace que los dos stats se repartan el alto —sin eso el panel se estira pero
las cajas siguen midiendo su contenido y el aire sobrante se junta en el
medio—; y el hueco pasa de 3 a **5**, que es el de la grilla. Ese último es el
que hace que cierren también los bordes de adentro: con 3 cada stat se estira
a 30 contra los 29 del renglón de al lado y quedan corridos 1px.

| a 390 | v163 | v164 |
|---|---|---|
| alto del plantel | 57 | **63** |
| desfasaje arriba / abajo | 3 / 3 | **0 / 0** |
| ATAQUE contra los medidores | 3 / 1 | **0 / 0** |
| DEFENSA contra los ítems | −1 / −3 | **0 / 0** |

### El dinero, en chapa

Más arriba el diseño le daba al dinero un hilo y 8px de aire para despegarlo
de la racha. Pero cien líneas después venía
`#m-dinero{padding:0;border:none;background:none}` y lo apagaba entero —no en
un breakpoint más chico, como parecía: **en el mismo bloque, por orden de
aparición**—. El €24M terminaba contra la última barra de la racha sin nada en
el medio: dos números pegados que no tienen nada que ver entre sí.

En vez de devolver el hilo va la chapa, con el mismo dorado de la moneda en
filo y en fondo, para que el dinero se lea como una cosa aparte y no como el
final de la racha.

### Lo que costaba la chapa, y cómo se pagó

**De alto.** La franja mide lo que mide su hijo más alto. Con el dinero en 17,
como los otros dos medidores, `5 + 17 + 5 + 2` daban los 29 de siempre. La
chapa lo lleva a 23 y la franja se iba a 35, o sea **6px que salen de la
mesa**: el tablero bajaba de 245 a 239. Se arregla bajando el relleno del panel
de 5 a 2: `2 + 23 + 2 + 2` vuelve a dar 29. Y el aguante y la racha no se
mueven ni un píxel, porque van centrados: quedan a los mismos 6 del borde por
más que el relleno cambie.

**De ancho.** La chapa lleva el dinero de 49 a 65, y esos 16px salen de las dos
columnas `1fr` —ocho por barra—. Seis se recuperan bajando el relleno
horizontal del panel de 8 a 6 y el de la chapa de 7 a 6. Los otros cinco se
pagan: la barra de racha pasa de 45 a 40 en un teléfono de 320, y cada tramo
de 9 a 7.8. En 390 la pérdida es de 17.8 a 16.5. **Es lo único que esta versión
empeora**, y quedó anotado.

### Medido en seis anchos

| | 320 | 360 | 375 | 390 | 412 | 430 |
|---|---|---|---|---|---|---|
| alto de la franja | 29 | 29 | 29 | 29 | 29 | 29 |
| los dos renglones | 63 | 63 | 63 | 63 | 63 | 63 |
| alto del plantel | 63 | 63 | 63 | 63 | 63 | 63 |
| desfasaje | 0/0 | 0/0 | 0/0 | 0/0 | 0/0 | 0/0 |
| lo que le queda a la mesa | = | = | = | = | = | = |
| tramo de la racha | 7.8 | 12.8 | 14.5 | 16.5 | 19.3 | 21.5 |

La fila de la mesa es lo que importa: **el tablero mide exactamente lo mismo
que en v163 en los seis anchos**, y el cartel de gol también. No hay scroll
horizontal en ninguno.

Acostado, en 780 × 360 —la única medida apaisada que comparte el bloque de
mobile— el plantel pasa de 57 a 66 pero ahí hay aire de sobra: el tablero queda
en 574 × 253 igual que antes, y sin scroll. En 844 y 932 acostados manda el
layout de escritorio, donde el dinero es una fila apilada con su rótulo y no lo
toca nada de esto.


## El empate dice a dónde se fue el partido

El cartel que aparece cuando termina 2-2 **no nombraba en ningún renglón ni a
los penales ni al penal definitorio**. Lo más cerca que llegaba era «TE QUEDA
UNA SOLA PELOTA» y un botón que decía «PATEAR EL PENAL»: de ahí el jugador
tenía que deducir solo que el empate se define desde los doce pasos y que le
tocó el que termina la historia.

Y encima tenía un renglón desperdiciado. La cinta contaba que empataron y que
nadie se sacó diferencia, que es exactamente lo que se acababa de ver en la
cancha.

### Tres textos, cero CSS

| | antes | ahora |
|---|---|---|
| la cinta | 90 minutos y nadie se sacó diferencia | nadie se sacó diferencia: **va a penales** |
| el renglón rojo | TE QUEDA UNA SOLA PELOTA | **UN SOLO PENAL** Y SE DEFINE |
| el botón | PATEAR EL PENAL | **PATEAR PENAL DEFINITORIO** |

Las tres cambian también del lado de la tanda —la final y el partido único—,
donde lo que viene no es un penal sino cinco: ahí el renglón rojo dice **TANDA
DE CINCO** y el botón **IR A LA TANDA**.

No se tocó ni una línea de CSS ni la estructura del cartel. Las dos palabras
que faltaban aparecen ahora tres veces, a tres alturas distintas.

### Lo que costó de alto, que es casi nada

La primera redacción era más larga —la cinta decía «90 minutos, nadie se sacó
diferencia · se define en penales» y el rojo «TANDA DE CINCO CADA UNO»— y
**engordaba el cartel entre 23 y 64px** según el ancho: la cinta se partía en
tres renglones y el rojo en dos. Medido en cuatro anchos y en los cuatro casos
que el cartel puede mostrar, se acortaron los textos hasta que la cuenta diera
cero.

| alto del cartel | 320 | 360 | 390 | 430 |
|---|---|---|---|---|
| ronda de paso | +19 | **=** | **=** | **=** |
| nombres largos | +19 | **=** | **=** | **=** |
| la final | **=** | **=** | **=** | **=** |
| partido único | **=** | **=** | **=** | **=** |

**Catorce de dieciséis dan exactamente el mismo alto que antes.** Los dos que
crecen son los de ronda de paso en un teléfono de 320, donde «PATEAR PENAL
DEFINITORIO» no entra en un renglón y el botón pasa a dos. Ahí el cartel mide
482 contra un hueco de 506, así que entra igual —y de todas formas el aviso ya
tenía su `max-height` con scroll, que es la red que se puso justo para esto.

### Lo que quedó anotado

En 320 el nombre del rival se parte feo en el marcador —«DEPORT / IVO /
BARRIA / L»—, pero eso ya venía de antes y no lo toca este cambio.


## Las filas dicen que se tocan

Las columnas laten cuando se habilitan, y son la **jugada especial**. Las filas,
que son la jugada de todos los turnos, no decían nada hasta que las tocabas: al
que llegaba nuevo nada le avisaba que esos cuatro botones de la izquierda eran
la forma de jugar.

### El latido ensaya el gesto

De tres formas probadas —un anillo que respira, una luz que cruza y esto— quedó
la que no adorna: **la fila asoma 2px hacia la mesa y vuelve**, que es
exactamente lo que hace al tocarla. No dice «mirame», dice «apretame».

```css
@keyframes filaEmpuja{
  0%,100%{transform:translateX(0);   box-shadow:0 0 0 0 rgba(255,255,255,0)}
  12%    {transform:translateX(2px); box-shadow:0 0 0 1.5px rgba(255,255,255,.55), 0 3px 14px rgba(255,255,255,.2)}
  26%    {transform:translateX(0);   box-shadow:0 0 0 1px rgba(255,255,255,.3)}
  38%    {transform:translateX(1.5px);box-shadow:0 0 0 1.5px rgba(255,255,255,.45)}
  55%    {transform:translateX(0);   box-shadow:0 0 0 0 rgba(255,255,255,0)}
}
```

Dos golpes y una pausa larga: del 0 al 55% pasa todo y el resto del ciclo
descansa. Con cuatro filas latiendo durante diez minutos de partido, la pausa
es lo que separa invitar de molestar. Los 2px son **los mismos del hover**, no
un número nuevo.

### Cuatro interruptores, y ninguno es adorno

| se apaga cuando | por qué |
|---|---|
| la fila está agotada | `:not(:disabled)` — invitar a tocar algo que no se puede tocar es peor que no invitar nada |
| la fila ya está elegida | ya la estás mirando |
| hay un pop-up arriba | la mesa está atrás: no hay nada que invitar |
| le pasás el dedo, **con mouse** | ver abajo |

El del dedo tiene truco. En un teléfono el `:hover` **se queda pegado** en lo
último que tocaste —por eso el bloque de `hover:none` ya le anulaba el
`transform` al hover de las filas—, así que un `:hover{animation:none}` a secas
habría dejado la última fila tocada sin latir por el resto del partido. Va
adentro de `@media (hover:hover)`: sólo se apaga donde el dedo se puede pasar
de verdad.

Y con `prefers-reduced-motion` se apaga el latido pero queda **el anillo
quieto** —el fotograma del pico—, para que la fila siga diciendo que se toca sin
moverse.

### El tamaño, que era la condición

`transform` y `box-shadow` **pintan pero no miden**. Medido antes y después en
siete medidas, tomando el ancho y alto de las cuatro filas, del tablero y de una
carta:

| | 320×568 | 360×640 | 375×667 | 390×844 | 412×915 | 430×932 | 780×360 |
|---|---|---|---|---|---|---|---|
| filas, tablero y carta | **=** | **=** | **=** | **=** | **=** | **=** | **=** |

Idéntico hasta el píxel en las siete, y sin scroll en ninguna. En el juego real
se comprobó además que el tamaño tampoco cambia al deshabilitar una fila ni al
activarla: 62×251 en los tres estados.


## Se va el escudo redondo

De las cinco siluetas, el OVALADO no era un escudo: era una **chapa**. Al lado
de las otras cuatro no se leía como una variante sino como otra cosa, y era la
única sin punta abajo — que es justamente lo que hace que un escudo parezca un
escudo. Quedan cuatro: clásico, inglés, italiano y banderín.

### Lo que se llevó puesto

Nada. El juego **no guarda nada en disco**, así que el índice de la forma no
sobrevive a un reload: el escudo se elige de nuevo en cada partida. Bajar el
arreglo de cinco a cuatro no corrompe ninguna partida vieja porque no hay
partidas viejas.

Medido en el juego andando, con 400 sorteos de `escudoRivalNuevo()`:

| | |
|---|---|
| siluetas | 4 |
| reparto | 106 / 107 / 98 / 89 |
| escudos inválidos | **0** |
| choques en PASASTE | **0** |

El reparto es parejo y la regla de PASASTE sigue en pie: los dos escudos que
van juntos —el que ganaste y el que viene— nunca coinciden ni en silueta ni en
color de fondo.

### Dos limpiezas que venían de arrastre

**Tres bloques de comentario apilados** arriba de `ESCUDOS`, dos de ellos
obsoletos: uno hablaba de «cuatro formas y seis paletas» —cuando hay cinco
formas y nueve colores sueltos— y otro listaba siluetas con nombres que ya no
existían: ESPAÑOL y REDONDO. Quedó uno solo y al día.

Y **una rama muerta** en `escudoSVG`. La cadena de patrones abría con:

```js
if(F.id === 'espanol') dentro = mitades verticales
```

Ninguna silueta se llama `espanol` —quedó del nombrado viejo— así que ese
`if` no matcheaba nunca y **el patrón de mitades verticales no se dibujaba en
ninguna parte del juego**. De los cinco patrones que el código parecía tener,
se usaban tres. La rama se fue con el ovalado; el CLÁSICO sigue cayendo al
`else`, igual que siempre, así que no cambia de dibujo.

Las mitades vuelven cuando se separe el patrón de la silueta, que es lo que hoy
impide que un club sea celeste a bastones y otro azul con franja.


## Elegís un equipo de verdad, y el rival también

Hasta acá la pantalla de inicio era un **formulario**: escribías un nombre,
elegías una silueta y dos colores de una fila de doce. Salía un club que no
existía y que no significaba nada. Y el rival tampoco: los cinco nombres
estaban fijos en `RONDAS` —DEPORTIVO BARRIAL, ATLÉTICO DEL SUR…— y el escudo se
sorteaba **aparte**, así que el mismo rival podía ser rosa y verde una partida
y negro y naranja la siguiente.

Ahora hay una tabla con los **treinta de la Primera 2026**, cada uno con su
nombre corto y su escudo pegado.

### Lo que impedía todo esto

El dibujo de la camiseta lo decidía la **silueta**: si elegías banderín te
tocaban rayas, si elegías inglés te tocaba franja. Con eso no había forma de
que un club fuera celeste a bastones y otro azul con franja, porque para
cambiar el dibujo había que cambiar la forma.

El dibujo pasa a ser su propio eje —cinco: sólido, bastones, franja, banda y
mitades— y con cuatro siluetas y doce colores alcanza para los treinta y sobra.
Vuelve además el de **mitades**, que el código tenía escrito desde siempre pero
no dibujaba en ninguna parte.

Los escudos **no son los reales**: son obra gráfica con derechos. Se toma lo
que no se registra —los colores y el dibujo de la camiseta— que es además lo
único que se distingue a 26px, el tamaño en que el jugador los ve casi siempre.

### La pantalla: la vitrina se queda, la lista se abre

De tres formas probadas —una cinta horizontal, una grilla de treinta y esto—
quedó la que **no le saca el escudo grande al jugador**. Elegir club es el
único momento del juego en que arma algo suyo, y ese escudo sigue ocupando
media pantalla. Los treinta viven en un panel que se abre encima, con buscador.

El panel se abre **sobre** la tarjeta y no la empuja: empujando, el botón de
empezar se iría abajo del corte justo cuando el jugador está por tocarlo.

La lista va ordenada **por nivel, de la Final para abajo** —el que abre el
panel se encuentra primero con los que conoce— pero **sin títulos de ronda**:
el nivel ordena, no se anuncia.

Y el encabezado pasa a dos renglones: el modo arriba y del mismo tamaño, TU
CLUB abajo. El modo no es una etiqueta del título, es la otra mitad: estás por
empezar un campeonato, o un partido único, y eso cambia todo lo que sigue.

### Más corta que la que reemplaza

| alto de la tarjeta | v167 | v168 |
|---|---|---|
| 320 × 568 | 530 | **411** |
| 390 × 844 | 660 | **478** |

**119px menos en el teléfono más chico y 182 en uno normal**, sin scroll en
ninguno de los dos y con el botón de empezar a la vista. Es una pantalla que
siempre sufrió en pantallas bajas y ahora sobra lugar.

### El sorteo, con sus dos reglas

```js
function armarCopa(){
  const previos = G.rivalesPrevios || [];
  G.copa = RONDAS.map(r => {
    const delNivel = EQUIPOS.filter(e => e.lvl === r.lvl && e.nm !== G.club);
    const bombo = delNivel.filter(e => previos.indexOf(e.nm) < 0);
    const pool = bombo.length ? bombo : delNivel;
    return Object.assign({}, r, { rival: pool[rnd(pool.length)].nm, eq: ... });
  });
  G.rivalesPrevios = G.copa.map(c => c.rival);
}
```

Tu club nunca te toca de rival, y el campeonato siguiente no repite los cinco
del anterior. La memoria es de **una copa para atrás**: si mirara la historia
entera, al cuarto campeonato no quedarían equipos.

Medido con **mil sorteos** en el juego andando, eligiendo BOCA:

| | |
|---|---|
| veces que te tocó tu propio club | **0** |
| veces que repitió uno de la copa anterior | **0** |
| rivales de nivel equivocado | **0** |
| copas con un rival repetido adentro | **0** |
| equipos distintos que aparecieron | **29** de 30 |

Y la tercera copa sí puede repetir la primera, que es lo que se pidió: en la
prueba volvió HURACÁN.

### Dos cosas que había que tocar con cuidado

`escudoSVG` recibe ahora el dibujo, **pero es opcional**: sin él cae al que da
la silueta, que es lo que hacía antes. Así las pantallas donde el escudo se
arma a mano —el visitante del 1v1, los penales sueltos— siguen dando
exactamente lo mismo sin tocarles una línea.

Y el buscador salía **centrado y en mayúscula**, como un cartel. `.cp-bs input`
y `.card-club input{text-align:center}` tienen la misma especificidad, así que
ganaba el que viene después en el archivo —y el de `.card-club` está dos mil
líneas más abajo—. Se le sumó la clase de la tarjeta para que gane por
especificidad y no por dónde cayó.

### Los escudos, como archivos

En `assets/escudos/` quedan los treinta en SVG, un sprite con todos y el JSON
de datos. **No hay copias por tamaño**: los SVG no llevan `width` ni `height`,
solo el `viewBox`, así que el mismo archivo se dibuja a 26 y a 150. Una copia
por tamaño sería el mismo archivo pesando el doble.

Los SVG son una **salida**, no la fuente: el escudo es una función de cinco
campos y eso vive en `equipos.json`. Si cambia un color de un club se cambia
ahí y se regeneran los treinta.


## El escudo del club, en las cartas

Durante el turno el jugador mira **la mesa**, no la marquesina. Y en la mesa no
había nada que dijera contra quién está jugando: que DELANTERO RIVAL fuera del
rival se sabía por la palabra RIVAL en el nombre, y que PASE GOL fuera tuya,
porque no la tenía.

Ahora cada carta lleva el escudo del club **al que pertenece la escena**,
arriba a la izquierda de la ilustración, como el logo del canal en una
transmisión.

### Dónde hay lugar de verdad

El primer intento lo puso **al lado del nombre**, que parecía el lugar obvio.
Le comía 16 de los 80px del título y DEFENSOR RIVAL se partía en
«DEFE / NSO / R / RIV / AL». En una carta de 90px de ancho no sobra nada en el
renglón del nombre.

El lugar que sí sobra es **encima de la foto**: ahí el escudo va en absoluto,
no está en el flujo y no le saca ancho a nada.

### Los tamaños, que era la condición

```css
.cell .c-esc svg{
  height:clamp(11px, calc(var(--carta) * .135), 18px);
  width:auto;max-height:calc(100% - 4px);
}
```

El tamaño cuelga de `--carta`, que es la variable que ya maneja todo el
responsive de la mesa: el escudo se achica con la carta, como el resto.

Medido antes y después en siete medidas, tomando la carta, el hueco de la
ilustración, el ancho del nombre, el alto del resultado y las dos tipografías:

| | 320×568 | 360×640 | 375×667 | 390×844 | 412×915 | 430×932 | 780×360 |
|---|---|---|---|---|---|---|---|
| todo | **=** | **=** | **=** | **=** | **=** | **=** | **=** |

**Idéntico hasta el píxel en las siete.** Es lo que se esperaba —`position:
absolute` no ocupa lugar— pero era justo lo que había que no romper.

### De quién es la escena

```js
const esDelRival = tipo => /RIVAL/.test((TYPES[tipo] || {}).nm || '');
```

Se deriva del **nombre** y no de una lista aparte. Podría llevar un `riv:true`
en cada tipo, pero entonces habría dos fuentes de verdad que se pueden
desincronizar: una carta nueva con RIVAL en el nombre y sin la marca mostraría
tu escudo sobre una jugada del rival. El nombre es lo que el jugador lee, así
que atándolo al nombre **no pueden contradecirse nunca**, y una carta del rival
que se agregue mañana trae su escudo sola.

Ojo con lo que significa: es de quién es la **escena**, no a quién le conviene.
DEFENSOR RIVAL es una oportunidad tuya y AUTOGOL RIVAL te da un gol, pero los
dos pasan del lado de ellos. Lo que te conviene ya lo dice el color del tono.

### Donde no entra, no va

En pantallas bajas la ilustración se achica hasta ser una franja y después
desaparece. Medido en el juego andando:

| | alto de la foto | el escudo |
|---|---|---|
| 390 × 844 | 78 | 13 × 15, cómodo |
| 360 × 780 | 63 | 12 × 14, cómodo |
| 360 × 640 | **11** | quedaba una astilla |
| 320 × 568 | **0** | no quedaba nada |

Una astilla de 10px de alto no se lee como un escudo sino como un error de
dibujo, así que abajo de 700px de alto se va con la foto:

```css
@media (max-height:700px){ .cell .c-esc{display:none} }
```

No es una renuncia: en esas medidas la carta ya quedó reducida a nombre y
resultado, y meterle un escudo encima sería taparle una de las dos cosas que le
quedan.


## La cinta del club en el pop-up de la jugada

La carta de la mesa ya trae el escudo desde v169. Pero al tocarla se abría un
cartel de 400px —cuatro veces la carta— que **no decía de quién era la jugada**,
así que la cadena se cortaba justo en el momento en que el jugador mira más
grande.

### Reemplaza, no se agrega

El renglón de arriba decía «MINUTO 3' · TE TOCÓ». Ahora dice de quién es la
jugada: escudo, nombre del club, y el minuto corrido a la derecha y más chico.

De tres formas probadas —el mismo rincón de la foto que en la carta, el escudo
al lado del título, y esto— quedó la única que **no le saca lugar a nada**: en
vez de sumarse, ocupa un renglón que ya estaba.

| | alto del cartel |
|---|---|
| como estaba | 409 / 449 |
| el escudo en el rincón de la foto | 409 / 449 |
| el escudo al lado del título | 427 / 467, y **59px menos de título** |
| **la cinta** | 428 / 468 |

La cinta cuesta 19px de alto. El del título costaba 18 **y** le sacaba 59px al
nombre —de 346 a 287—, y DELANTERO RIVAL, que es el nombre más largo que
existe, ya entraba justo: no quedaba margen para uno nuevo.

Su costo real no son los 19px sino la decisión de fondo: ese renglón **decía
cuándo** pasa la jugada y ahora **dice de quién** es. El minuto no se fue, se
corrió a la derecha y bajó a 11px.

### El nombre del club sale de donde ya salía

```js
const nm = delRival
  ? (G.modo === 'duelo' ? (G.J[1] || {}).club : (RONDA(G.ronda) || {}).rival)
  : (G.modo === 'duelo' ? (G.J[0] || {}).club : G.club);
```

Las mismas dos fuentes que usa el relato: la ronda en el campeonato, el jugador
2 en el 1v1. Así los dos modos lo dicen bien sin una rama aparte. Y si todavía
no hay escudos en juego —el tutorial, una pantalla suelta— cae en el renglón de
antes.

De quién es la jugada lo decide `esDelRival`, el mismo de v169: se deriva del
nombre de la carta, así que el escudo de la carta y el del pop-up **no pueden
decir cosas distintas**.

### Probado en el juego andando

| jugada | la cinta dice | tinte |
|---|---|---|
| PASE GOL | RIVER · MINUTO 10' | neutro |
| DELANTERO RIVAL | EST. RÍO IV · MINUTO 10' | rojo |

El rojo de la cinta es lo único del cartel que cambia de color según de quién
sea la jugada.


## Se va el RIVAL de las cuatro de duelo

Desde v169 el escudo dice de quién es cada carta, así que la palabra RIVAL en
el nombre pasó a ser redundante. Pero **sólo en cuatro**.

### Por qué sólo cuatro

DEFENSOR, ARQUERO, MEDIO y DELANTERO pierden la palabra: no existe «tu
defensor» como carta, así que no distinguía nada. Y son las que peor se
partían, porque además llevan el número del duelo, que le roba ancho al título:

| a 320 de ancho | antes | ahora |
|---|---|---|
| DELANTERO RIVAL | **4 renglones** | 1 |
| DEFENSOR RIVAL | 3 | 1 |
| ARQUERO RIVAL | 3 | 1 |
| MEDIO RIVAL | 3 | 1 |

Cuatro renglones en una carta de 62px es lo que hacía que se leyera
«DELAN / TERO / RIV / AL».

**A las otras seis se les queda**, y no por costumbre. Sin la palabra:

| tuya | del rival | chocarían en |
|---|---|---|
| PENAL | PENAL RIVAL | PENAL |
| PASE GOL | PASE GOL RIVAL | PASE GOL |
| CÓRNER | CÓRNER RIVAL | CÓRNER |
| TIRO LIBRE | LIBRE RIVAL | LIBRE |

Dos cartas con el mismo nombre y efectos opuestos en la misma mesa. Y peor:
AUTOGOL RIVAL es **gol tuyo** —ellos se la meten— y convive con AUTOGOL PROPIO,
que es gol en contra. Sin RIVAL, el significado se da vuelta.

### El dato deja de deducirse del nombre

```js
const esDelRival = tipo => !!(TYPES[tipo] || {}).riv;
```

Salía de un `/RIVAL/` sobre el título, y era elegante mientras todas las cartas
del rival lo dijeran: el escudo y el texto no podían contradecirse porque eran
lo mismo. Dejó de servir en el momento en que cuatro cartas perdieron la
palabra y siguieron siendo del rival. Ahora `riv:true` está escrito en los diez
tipos.

## Un crash que venía de v168

Al probar esto saltó un error que **ya estaba pusheado**: el mano a mano y el
arco de los penales explotaban.

```js
const A = COLORES[((esc && esc.c1) || 0) % COLORES.length].hex;
```

Los dos dibujan muñecos con los colores del escudo, y sacaban el hex indexando
la paleta a mano. Eso anda con un índice, pero desde v168 el escudo del club
sale de la tabla de los treinta y trae **nombres**: `'blanco' % 12` es `NaN`, y
`COLORES[NaN].hex` tira `Cannot read properties of undefined`.

Se rompía al jugar cualquier carta de duelo —una de cada cuatro— y en toda la
tanda de penales. `escudoSVG` ya traducía nombre a índice desde v168; estas dos
funciones no pasan por ahí y se quedaron afuera.

Ahora hay **un solo lugar donde se traduce**:

```js
const hexEscudo = v => COLORES[aIndice(v, IDX_COL) % COLORES.length].hex;
```

Probado en el juego andando, con pestaña de consola limpia: los cuatro mini
juegos abren con sus dos muñecos, el arco del penal se dibuja, y no queda ni un
error. Quedan tres accesos a la paleta en todo el archivo —los dos de
`escudoSVG` y el de `hexEscudo`— y un guardián en el parche los cuenta, para
que el próximo que agregue un dibujo con colores de escudo no repita el camino.


## JUGADA CLARA dice GOL y nada más

Decía `GOL +⚡`. El rayo no mentía —el gol carga un tramo de racha, lo hace
`scoreU`— pero la carta **más simple de la mesa** terminaba con dos datos, y el
segundo es el mismo que dan todas las cartas de gol.

Acá el gol es **seguro**: no hay porcentaje que leer ni duelo que ganar. Eso se
cuenta mejor con una palabra sola.

| | antes | ahora |
|---|---|---|
| JUGADA CLARA | GOL +⚡ | **GOL** |
| AUTOGOL RIVAL | GOL +⚡ | GOL +⚡ |

Lo que se pierde es el aviso: la racha va a subir igual, pero la carta ya no lo
anticipa. Se ve en el medidor cuando pasa. Medido en el juego andando: el gol
sigue sumando y la racha sigue yendo de 0 a 1, sólo cambió el texto.

**AUTOGOL RIVAL conserva el rayo** aunque hace exactamente lo mismo. Es una
diferencia a propósito y no un olvido: las dos líneas quedaron una al lado de
la otra, con el comentario que lo dice.

El cambio vale para los dos lugares de una: la carta de la mesa y el pop-up de
la jugada leen el mismo `label` de `predict`.


## El tutorial pregunta lo que contesta

El titular decía **DUELO FUTBOLERO**: el nombre del juego, que el jugador ya
vio en el menú. Lo que la pantalla es —cómo se juega— iba arriba, en una
chapita de 9px. Ahora el titular **es la pregunta** y la chapita dice EL
PARTIDO.

Y de las seis reglas, sólo la primera traía una imagen del juego. Las otras
cinco eran íconos sobre fondo liso, en la única pantalla que se lee **sin haber
visto nunca una carta**. Ahora todas muestran algo de la cancha.

### Lo que cambió en cada ficha

| | antes | ahora |
|---|---|---|
| EL AGUANTE | ícono solo | + foto del calambre |
| LA RACHA | ícono solo | + foto de la hinchada |
| LOS DUELOS | ícono solo | + el delantero definiendo |
| LOS ÍTEMS | ícono solo | + foto de la fama |
| NUEVE JUGADAS | reloj dibujado aparte | **el cronómetro del partido** + foto del pase gol |

El reloj era una pieza dibujada sólo para el tutorial: un anillo con un número,
parecido pero **no igual** al del marcador. Parecido no alcanza — la pantalla
que enseña a jugar tiene que mostrar la pieza que se va a ver en la cancha.
Ahora arma el cronómetro de verdad, con la misma cuenta de arcos que
`renderCronometro`: nueve porciones, tres corridas, el minuto en el medio.

La última ficha queda sola en su renglón y va **centrada**: estirada a todo el
ancho se leía como un pie de página. Y los botones pasan a estar **uno arriba
del otro**, con EMPEZAR LA COPA primero: es el que se toca casi siempre y a lo
ancho compartía el renglón con VOLVER como si valieran lo mismo.

### La banda no cuesta alto (y donde cuesta, se va)

La foto va **detrás del ícono**, que sube con un margen negativo: la banda pone
fondo, no empuja. Aun así suma 8px por ficha, 40 en las cinco, y con los
botones apilados la tarjeta se pasaba del hueco.

Medido antes y después, en seis medidas:

| | v172 | v173 al principio | v173 final |
|---|---|---|---|
| 320 × 568 | 500, entra | **+57 de scroll** | 512, entra |
| 360 × 640 | 526, entra | **+24 de scroll** | entra |
| 375 × 667 | entra | **+25 de scroll** | 604, entra |
| 390 × 844 | 671, entra | 756, entra | 756, entra |
| 412 × 915 | entra | entra | 748, entra |
| 430 × 932 | entra | entra | 757, entra |

El tutorial entra entero en todas las medidas desde que se pasó a dos columnas,
y eso no se podía perder: es la pantalla donde alguien decide si el juego le
interesa, y llegar al botón scrolleando es un peaje.

Así que abajo de **680px de alto** pasan dos cosas: la foto se va —es clima, el
ícono es lo que enseña— y los botones vuelven a la fila. Lo segundo no es una
excepción inventada: el bloque de apaisado ya lo hacía, con el mismo motivo
escrito al lado.

### Un tropiezo de especificidad, otra vez

El `display:none` de la banda no hacía nada. `.tu-fi .tu-banda` dentro de la
consulta y `.tu-fi .tu-banda` de la regla base tienen **la misma
especificidad** —una consulta no suma— así que ganaba el que viene después, y
el base está 570 líneas más abajo. Se resolvió con `.card-reglas` adelante, que
es lo mismo que hubo que hacer con el buscador en v168.


## El botón que espera

Los carteles que **frenan el partido** —el empate, la racha llena, el fin de
ronda, la fundida— esperaban un toque sin decirlo. El jugador terminaba de leer
y tenía que darse cuenta solo de que el juego estaba detenido esperándolo.

El único que avisaba era el de la jugada, con su «TOCÁ PARA JUGARLA»
parpadeando abajo — y es justo el que menos falta le hacía, porque ahí la
tarjeta entera es el botón.

### Dónde va y dónde no

De los trece carteles del juego con botón de acción, el latido va en **ocho**.
El corte es simple: lo lleva el que frena el partido —venías jugando y el juego
se detuvo— y no lo lleva la pantalla de menú, donde ya sabés que estás
eligiendo algo.

| lleva | no lleva |
|---|---|
| EMPATE · *patear penal definitorio* | CÓMO SE JUEGA |
| RACHA LLENA · *usar la racha* | TU CLUB |
| PASASTE · *ir al vestuario* | MENÚ, OPCIONES, CRÉDITOS |
| SE TE FUNDIÓ · *a ver qué pasa* | fin de campeonato |
| AVISO · *continuar partido* | |
| FIN DE RONDA · *jugar octavos…* | |
| SITUACIÓN DE GOL | |
| ENTRETIEMPO del 1 vs 1 | |

### Dos golpes y una pausa larga

```css
@keyframes ctaLatido{
  0%      {transform:scale(1);    outline-width:0}
  10%     {transform:scale(1.035);outline-width:3px}
  20%     {transform:scale(1)}
  30%     {transform:scale(1.022);outline-width:2px}
  45%,100%{transform:scale(1);    outline-width:0}
}
```

Del 0 al 45% pasa todo y el resto del ciclo descansa. Un botón que late sin
parar en un cartel que quizás estés leyendo con calma es una mano en el hombro
cada dos segundos.

### El anillo va con `outline`, no con `box-shadow`

Y es a propósito. El botón verde —IR AL VESTUARIO— tiene **su propia sombra con
un `inset`**, y animar `box-shadow` se la comería entera. El `outline` no la
toca, y además **nunca ocupa lugar**: medido con y sin la clase, el botón mide
284×46 y el cartel 292 en los dos casos.

El color del anillo sigue al botón: dorado en los siete normales y verde en el
de PASASTE, con su propia regla. Comprobado en el juego andando —
`rgba(245,200,66,.55)` en el empate y `rgba(61,220,107,.65)` en el vestuario,
con la sombra del verde intacta.

### Se apaga sólo donde el dedo se puede pasar

```css
@media (hover:hover){ .cta.llama:hover{animation:none} }
```

En un teléfono el `:hover` se queda pegado en lo último que tocaste, así que un
`:hover` a secas dejaría mudo el botón del cartel siguiente. Es la misma trampa
que tuvo el latido de las filas en v166, y se resuelve igual.

Con `prefers-reduced-motion` el latido se apaga y queda el anillo prendido en
2px, que es el fotograma del pico.

### Lo que se resignó

De tres formas probadas quedó la más marcada. Las otras dos —el anillo que
respira de las columnas y el barrido del cartel de gol— reusaban un recurso que
en este juego **ya significa otra cosa**: el barrido dice «la racha está llena»
y el latido dice «te queda un corazón».

Elegir el latido le pone a un botón el gesto que hasta ahora era de urgencia.
Queda anotado: si en el partido se siente como un apuro donde nadie corre, el
anillo de las columnas es el reemplazo, y es un cambio de tres líneas.


## Las filas llaman más seguido

El latido de v166 tenía una pausa **demasiado prudente**. Con un ciclo de 3,2s
la fila llamaba 18 veces por minuto, y entre un par de golpes y el siguiente
quedaba segundo y medio de silencio — que en una mesa que estás mirando es una
eternidad.

### Hay dos maneras de ir más seguido, y no dan lo mismo

El latido son **dos golpes y una pausa**. Se puede acortar sólo la pausa, o
acortar el ciclo entero. Lo segundo acelera también los golpes y **cambia el
gesto**: a 2,2s el empujón deja de leerse como un ensayo del toque y pasa a ser
un tic.

Se eligió lo primero:

| | ciclo | late | descansa | por minuto |
|---|---|---|---|---|
| v166 | 3,2s | 1,76s | 1,44s | 18 |
| **v175** | **2,4s** | **1,76s** | **0,65s** | **25** |

Casi un 40% más seguido, con el gesto intacto.

### Los porcentajes, recalculados

```css
@keyframes filaEmpuja{
  0%,100%{translateX(0)}
  16%    {translateX(2px)}      /* antes 12% de 3,2s */
  35%    {translateX(0)}        /* antes 26% */
  51%    {translateX(1.5px)}    /* antes 38% */
  73%    {translateX(0)}        /* antes 55% */
}
```

Se ven raros pero están calculados: con el ciclo en 2,4s, el 16% cae a los
**0,384s**, el 35% a **0,84** y el 51% a **1,224** — exactamente donde caían
antes. Comprobado en el juego andando, congelando la animación y midiendo el
`transform` en cada momento:

| momento | desplazamiento |
|---|---|
| 0s | 0 |
| 0,384s | **2px** |
| 0,84s | 0 |
| 1,224s | **1,5px** |
| 1,75s en adelante | 0, descansando |

Queda anotado en el código: si algún día se toca la duración hay que
recalcularlos, o el gesto se acelera solo.


## El vestuario, contra alguien

El refuerzo es **la decisión más definitiva del juego**: una por ronda, cuatro
en todo el campeonato, sin vuelta atrás. Hasta v175 la pantalla la trataba como
información. Dos renglones apilados, sin un cartel que dijera que había que
elegir y sin nada que avisara que eran botones; lo único que se movía era el
tramo dorado de cada barra, de 26px.

### Se eligió entre seis

Primero se probaron tres marcos (las barras latiendo, las dos enfrentadas, y
una cabecera con el escudo del que viene). Elegido el tercero, se probaron
**cinco maneras distintas de mostrar las dos opciones** adentro de ese marco
—enfrentadas, con el +1 en una chapa dorada, con foto, con el track en fichas
que se cuentan, y como un interruptor de color pleno— dejando el resto de la
tarjeta congelado para que se comparara eso y nada más.

Quedó la de la foto: **el idioma de las cartas**, que es lo que el jugador
viene tocando toda la partida.

### La cabecera

El refuerzo no se elige en el aire: se elige contra alguien. Arriba de las dos
chapas va el escudo del rival que viene, el mismo recurso de la cinta de la
jugada, y de paso es donde entra el **ELEGÍ UNO**, que era lo que faltaba
decir.

El nombre del club se corta con puntos suspensivos y no se parte: hay rivales
de dos palabras largas que partidos quedan ilegibles.

### Las dos chapas

Enfrentadas y no apiladas, porque **una decisión entre dos se lee mejor lado a
lado**: dos renglones son una lista, dos chapas son una disyuntiva. Cada una
lleva la foto arriba con el degradé de las cartas, el ícono en el rincón y el
texto abajo, subido sobre el pie del degradé para ganar alto sin perder
contraste.

El arte tiene que ser una foto limpia. Las pizarras tácticas del juego
(`art_ataja`, `art_roba`) traen **el texto quemado adentro**: la primera versión
mostraba una chapa que decía DEFENSA arriba y "ATAJA EL ARQUERO" en la imagen,
diciendo dos cosas a la vez. Quedaron `delantero` y `arquero`.

Las dos laten con el gesto de los botones de v174, **desfasadas medio ciclo**.
Latiendo juntas parecen una sola cosa que respira; alternadas se leen como dos
opciones que se turnan para llamarte.

### El `max-width` global que se comía el sangrado

La cabecera salía **corrida 12px a la izquierda** en vez de llegar a los dos
bordes. El margen negativo estaba bien calculado y el navegador lo reportaba
aplicado, pero la caja no se ensanchaba.

La causa es un `*{max-width:100%}` global: le pone de techo el ancho del
contenido de la tarjeta, la caja queda **sobredeterminada** y en ese caso el
navegador descarta el margen derecho en silencio. El resultado es una cinta que
se corre pero no se estira. Se arregla con `max-width:none`.

Queda anotado porque **la cinta de la jugada tiene el mismo problema desde
v170** y nadie lo vio: medida en el pop-up real a 320, arranca a 9px del borde
izquierdo y termina a 45px del derecho, cuando tendría que ir de punta a punta.

### El padding lateral, ahora en una variable

Para que una cinta llegue a los bordes hay que saber cuánto padding lateral
tiene la tarjeta, y ese valor **cambia seis veces** según el hueco: 26, 15, 13,
12, 11 y 10px. La cinta de la jugada lo tenía escrito a mano (`-18px`), que no
coincide con ninguno de los seis. Ahora es `--cpx`, declarada en cada
breakpoint junto al `padding` que le corresponde.

### Lo que costó

Medido en el juego andando, abriendo el pop-up en cada ancho:

| pantalla | v175 | v176 | |
|---|---|---|---|
| 320 x 480 | — | 384 | sin scroll |
| 320 x 568 | 362 | 384 | +22 |
| 360 x 640 | 386 | 412 | +26 |
| 390 x 844 | 433 | 448 | +15 |
| 414 x 896 | 443 | 452 | +9 |
| 768 x 1024 | — | 567 | sin scroll |
| 1280 x 800 | 600 | **575** | −25 |
| 844 x 390, acostado | 596 | **571** | −25 |

Las dos cosas tiran para lados distintos: **la cabecera suma unos 40px y las
chapas enfrentadas ahorran unos 25**. En teléfono gana la cabecera y la tarjeta
crece; de tablet para arriba gana el ahorro y baja. No aparece scroll en
ninguna medida nueva, y el que ya había en acostado —que viene de que el
breakpoint móvil pide 820 y un teléfono acostado mide 844— se achica 25px.

La línea de "contra defensores y arqueros" se temía que se partiera en dos
renglones en 320, como pasaba en la maqueta. En el juego **no pasa**: la
maqueta tenía la tipografía fija en 9,4px y el juego la mide con
`clamp(8.4px, 2.5vw, 10px)`, así que en 320 baja a 8px y entra en un renglón.


## Los escudos, corregidos

Repasando los treinta aparecieron tres cosas, y dos eran defectos de verdad.

### Cinco se dibujaban de un solo color

El patrón `solido` es `() => ''`: **no pinta nada encima del fondo**. Así que
los clubes que lo usaban tenían el segundo color cargado en la tabla y no se
veía nunca. Eran RIVADAVIA, ARGENTINOS, LANÚS, HURACÁN y BELGRANO.

No era un dato faltante: era un dibujo faltante. Por eso la corrección no
agrega colores, agrega **dibujos**.

### Faltaban cuatro dibujos

El motor sabía hacer cinco —`solido`, `rayas`, `franja`, `banda`, `mitades`—
y ninguno alcanzaba para lo que pedían los clubes de verdad:

| dibujo | qué es | para quién |
|---|---|---|
| `franjav` | la `franja`, pero vertical y al medio | RIVADAVIA, TIGRE |
| `finas` | los bastones de `rayas` a la mitad de ancho y casi al doble de cantidad | HURACÁN, RACING |
| `barra` | la otra diagonal: `banda` sube de izquierda a derecha, `barra` baja | INDEPENDIENTE |
| `uve` | dos brazos que bajan de los hombros y se juntan abajo del medio | VÉLEZ |

Los cuatro ids son de **siete letras o menos a propósito**. La tabla de los
treinta está alineada en columnas para poder corregirla a ojo, y un id de ocho
obligaba a recorrer las treinta filas para reacomodarlas.

### Dos además invirtieron los colores

DEFENSA y PLATENSE no cambiaron sólo el dibujo: **el que era fondo pasó a ser
la línea**. Defensa es verde con la línea amarilla, no amarillo con verde; y
Platense es blanco con la banda marrón, no al revés.

### Qué se movió

De 30 clubes, 9 cambiaron. Los que se dibujan planos bajaron de **5 a 2**, y
las rayas de **19 a 16**:

| dibujo | antes | ahora |
|---|---|---|
| `rayas` | 19 | **16** |
| `solido` | 5 | **2** |
| `banda` | 3 | **4** |
| `franja` | 2 | **1** |
| `mitades` | 1 | 1 |
| `franjav` | — | **2** |
| `finas` | — | **2** |
| `barra` | — | **1** |
| `uve` | — | **1** |

Se deshicieron además dos grupos que compartían colores y dibujo: TIGRE se fue
del par con San Lorenzo, y RACING del trío con Tucumán y Est. Río IV.

### Lo que sigue pendiente

**UNIÓN y ESTUDIANTES son el mismo escudo**: rojo, blanco, rayas, inglés, los
cuatro campos iguales. Están en niveles distintos, así que pueden salir los dos
en la misma copa sin forma de distinguirlos. Alcanza con cambiarle la silueta a
uno de los dos.

**LANÚS** sigue plano. La camiseta es granate lisa, así que probablemente esté
bien, pero tiene un blanco cargado en `c2` que no se dibuja. **BELGRANO** es
celeste dos veces y eso fue a propósito.

### Un error viejo que apareció de paso

Mientras se probaba esto saltó una vez, sin poder reproducirlo después, un
`TypeError: Cannot read properties of undefined (reading 'hex')` en el flujo
del sorteo de la racha.

La fragilidad está identificada y **no la trae este cambio**: `hexEscudo` es
`COLORES[aIndice(v, IDX_COL) % COLORES.length].hex`, y `aIndice` devuelve los
números tal cual. Con `NaN` o con `-1` el índice no resuelve y revienta —
comprobado llamándola con los dos valores. Es el mismo defecto que rompió el
juego en v171, tapado en un lugar y no en el resto.

No se toca acá porque es otro asunto y sin reproducción no hay forma de
verificar el arreglo. Queda anotado.

### Cómo se revisó

Las dos páginas de comparación **no copian nada**: le sacan `escudoSVG`,
`COLORES`, `PATRONES` y `EQUIPOS` al `index.html` y los ejecutan. El "antes"
sale de `git show HEAD:index.html` y el "después" del archivo de trabajo, cada
uno dibujado con su propio motor. Un detalle que costó: **git escupe el blob
con LF y el archivo de trabajo está en CRLF**, así que los cortes de bloque no
matcheaban en uno de los dos lados.

Y en el juego se verificó que los treinta resuelven color, silueta y dibujo, y
que ninguno de los que no es `solido` pinta un solo color.


## No quedan dos escudos iguales

UNIÓN pasa a `finas`. Era el que faltaba: hasta v177 tenía los cuatro campos
iguales que ESTUDIANTES —rojo, blanco, rayas, inglés— y como están en niveles
distintos podían salir **los dos en la misma copa**, uno en cuartos y otro en
semis, sin forma de distinguirlos.

Cruzando los treinta después del cambio: **cero grupos idénticos**. Las rayas
bajan de 16 a 15 y `finas` sube a 3.

Lo que queda son cinco grupos que comparten colores y dibujo pero se
diferencian por la silueta, que es una distinción más débil pero existe:

| | |
|---|---|
| RIESTRA / C. CÓRDOBA | negro y blanco a rayas |
| SARMIENTO / BANFIELD | verde y blanco a rayas |
| EST. RÍO IV / TUCUMÁN | celeste y blanco a rayas |
| GIMNASIA LP / TALLERES | azul y blanco a rayas |
| INSTITUTO / ESTUDIANTES | rojo y blanco a rayas |

### El error del `hex`, aclarado

En v177 quedó anotado un `TypeError ... reading 'hex'` que había saltado una
vez sin poder reproducirlo. Ahora se entiende **por qué no se reproducía**: era
una entrada retenida en la consola del panel, de una navegación anterior de esa
misma pestaña. Volvió a aparecer al probar v178 y esta vez se pudo separar:

- el *listener* puesto adentro de la página no capturó **nada**;
- la consola del panel sí mostraba el error;
- en una **pestaña nueva**, cargando lo mismo, no aparece.

O sea que ni v177 ni v178 lo producen. Queda como método: en este panel, para
afirmar que no hay errores de consola **hace falta una pestaña recién creada**,
porque las entradas sobreviven a las navegaciones.

Lo que no cambia es que **la fragilidad existe**: `hexEscudo` revienta con
`NaN` o con `-1`, comprobado llamándola con los dos valores. Sigue sin
tocarse, pero el arreglo de fondo no es tapar el caso: es que `aIndice` no
devuelva nunca un índice inválido, y así se cierra la familia entera en vez de
un lugar por vez.


## Los treinta, a la vista

La pantalla que te presenta el juego **no mostraba ninguno** de los escudos que
la hacen valer: los treinta vivían adentro de un panel que se abría encima, y
para saber que existían había que tocar.

Ahora están a la vista, en una tira que se desliza. El renglón de arriba quedó
diciendo algo limpio: **escribí, deslizá o sorteá**, tres caminos al mismo lugar,
los tres del mismo alto y uno al lado del otro.

### El botón del azar

Decía `SORPRENDEME` con borde punteado y letra apagada: **la pinta exacta de un
control deshabilitado**, que es lo último que querés para el que no tiene equipo
favorito. Ahora dice `ALEATORIO` y es una chapa dorada del alto del buscador.

Va con clase propia (`.club-azar`) y no con `.op-azar`, que la usa la pantalla
del 1 vs 1 —donde, de paso, ya decía ALEATORIO— y no se toca.

### El ancho de la ficha lo fija el nombre más largo

INDEPENDIENTE, con trece letras. El nombre va en **un solo renglón y sin
partirse**: con dos renglones las fichas quedaban de alturas distintas según el
nombre y la tira entera se veía despareja. Medido en el juego, el texto entra
con aire en los tres anchos:

| ancho | ficha | tipografía | sobra |
|---|---|---|---|
| 320 | 78px | 8,2px | **18,9px** |
| 360 | 78px | 8,5px | 17,4px |
| 390 | 84px | 9,2px | 19,3px |

### El orden

Los de nivel 5 pasan a ir como se los nombra: **River, Boca, Independiente,
Racing**, San Lorenzo, Vélez. El orden de la tabla es el que manda adentro de
cada nivel, así que alcanzó con mover cuatro filas. El sorteo de la copa saca
del bombo al azar, así que no le cambia nada.

### Tres errores que costaron encontrar

**La coma que me llevé puesta.** Al sacar el panel se fue con él la coma que
separaba el marcado del segundo argumento de `openCard`. El `+` colgado pegó la
cadena `'card-club'` al final del HTML y la tarjeta **se quedó sin su clase**:
el buscador volvía a tomar los estilos de `.card input` —20px, centrado, con
margen— y el renglón de arriba medía 72px en vez de 34. Se ve raro pero no
rompe nada, que es lo que lo hace difícil de ver.

**La consulta de medios que perdía.** El bloque de acostado quedó escrito arriba
de las reglas base. Una consulta de medios **no suma especificidad**, así que
una regla base de la misma fuerza escrita más abajo le gana: los botones seguían
apilados en acostado. Se movió al final de la hoja, que es el único lugar donde
no depende de quién esté más abajo. Van tres veces que tropiezo con lo mismo.

**La tira que se encogía.** `.card-club` es un flex de columna y la tarjeta
tiene tope de alto; cuando el contenido lo pasa, los items se **encogen** porque
`flex-shrink` vale 1 por defecto. La tira, que no tiene nada que la sostenga por
dentro, se iba a 10px: los escudos seguían midiendo 26 pero colgaban fuera de
una ficha de 11. Se arregla con `flex:0 0 auto` — la tarjeta ya scrollea, así
que encogerse no gana nada.

### Los botones, uno debajo del otro

EMPEZAR LA COPA arriba y VOLVER abajo, como en el tutorial. En fila se leen como
opciones del mismo peso y no lo son: una arranca la copa y la otra se vuelve.

En acostado vuelven a la fila, que es donde sobra ancho y falta alto.

### Lo que costó

| pantalla | v178 | v179 | |
|---|---|---|---|
| 320 x 568 | 411 | 473 | +62 |
| 360 x 640 | 452 | 518 | +66 |
| 390 x 844 | 478 | 549 | +71 |
| 1280 x 800 | — | 593 | sin scroll |
| 844 x 390, acostado | 435 | **424** | −11 |

**No aparece scroll en ningún teléfono parado.** De los 71px que suma en 390, la
tira pone unos 43 y los botones apilados los otros 28.

Y acostado **mejoró**: era la única pantalla que ya scrolleaba antes de esto, y
la compactación por alto le devolvió más de lo que la tira le sacó.

### Cómo se probó

Andando: tocar un club lejano lo trae al centro de la tira y cambia la vitrina;
el dado tirado cinco veces seguidas no repitió ni una; el buscador encuentra
VÉLEZ escribiendo «velez» sin tilde y las dos GIMNASIA con «gimnasia»; con un
texto sin resultados la tira se esconde y aparece el cartel; y EMPEZAR LA COPA
deja el club puesto y sigue al tutorial.

El centrado de la tira **no usa `scrollIntoView`**: ese sube por los ancestros y
con el snap puesto no movía nada, así que al sacar uno lejano con el dado el
elegido se resaltaba fuera de la vista y el botón parecía no hacer nada. El
destino se calcula a mano.


## La cinta de la jugada, derecha

Desde v170 la cinta con el escudo del club que encabeza el pop-up de la jugada
**no estaba centrada**: pegada al borde izquierdo y lejos del derecho. No rompía
nada, y por eso pasó diez versiones sin que nadie la viera.

La causa es la misma que en v176 dejó torcida la cabecera del vestuario: un
`*{max-width:100%}` global. La cinta sale a todo el ancho con márgenes
negativos, el `max-width` le pone de techo el ancho del contenido y la caja
queda **sobredeterminada**; en ese caso el navegador **descarta el margen
derecho en silencio**. La cinta se corre pero no se estira.

```css
.play .p-cinta{ max-width:none }
```

Medido en el juego, con y sin el arreglo inyectado en vivo:

| pantalla | pop-up | izquierda | derecha | con el arreglo |
|---|---|---|---|---|
| 320 x 568 | 280px | 9px | **45px** | 9 / 9 |
| 390 x 844 | 350px | 9px | **45px** | 9 / 9 |
| 1280 x 800 | 563px | 15px | **51px** | 15 / 15 |

Siempre **36px corta a la derecha**, en los tres anchos.

### Dos cosas que aprendí midiendo esto

**Los rects mienten mientras corre una animación.** La primera medición dio 6 y
32 en vez de 9 y 45, y el pop-up 252px en vez de 350. Estaba midiendo con
`getBoundingClientRect` durante la animación de entrada, que escala el pop-up:
los rects venían multiplicados por 0,72. Para geometría hay que esperar a que
termine, o usar valores de layout —`offsetWidth`, `clientWidth`— que el
`transform` no toca.

**Los 36px no van al nombre.** Había anotado que un nombre largo que se cortaba
con puntos suspensivos iba a entrar entero, y **era falso**. El hueco entre el
nombre y el minuto es un `margin-left:auto`, así que el espacio que se recupera
se lo lleva ese margen. Medido con INDEPENDIENTE, el nombre más largo de la
tabla: ocupa 108,9px y tiene 109 disponibles **antes y después**. No se cortaba,
y sigue sin cortarse.

### El otro pendiente, el del `hex`, sigue sin tocarse

Antes de proponerlo fui a ver si se puede disparar. Envolví `arcoPenalHTML` y
`figuraDuelo` para anotar todo lo que les llega y ejercité los tres caminos por
los que puede venir un escudo:

| camino | lo que llega | |
|---|---|---|
| la copa (tabla de clubes) | `c1='azul' c2='amarillo'` | válido |
| escudo sorteado (1 vs 1, penales) | `c1=1 c2=7` | válido |
| el selector de colores | `+b.dataset`, siempre 0..11 | válido |

Ninguno produce `NaN` ni un negativo, que son los dos únicos valores con los que
`hexEscudo` revienta. Repasadas además todas las escrituras a `c1`/`c2` del
archivo. **Es una mina enterrada, no un incendio**, y queda enterrada hasta que
se toque la tabla de clubes o el sorteo de escudos.


## La ficha del ítem, la chapa limpia

Tres quejas, tres causas:

**El color.** La ficha era dorada con degradé y halo. En un juego donde el
dorado quiere decir «esto se toca» —los CTA, las chapas, los títulos, el filo
de las tarjetas— una ficha dorada no dice nada propio.

**La alineación.** La foto de 78px al costado empujaba el texto contra el borde
derecho, y el nombre, el efecto, el salto y la descripción quedaban los cuatro
apilados en la misma columna angosta.

**El tamaño.** 154px tapando la mesa justo cuando hay que decidir mirándola.

### Qué cambió

Se va el degradé y el halo: queda fondo plano y un filo arriba, que es lo único
que hace falta para despegarla del tablero. La foto pasa de cuadrado al costado
a **banda a todo el ancho** con el mismo degradé con el que las cartas apoyan
su texto, y el antes→después se despega en su propia chapa.

La caja del ítem **no cambia de tamaño**: 73 x 29 a 390 de ancho, igual que
antes. Sólo se le apaga el borde y se le aplana el fondo, porque la caja es el
marco y lo que tiene que saltar es el ícono y el efecto.

Todo va con `:not(.ficha-gol)`: el cartel de la posibilidad de gol usa las
mismas clases de caja con otro contenido y **no se rediseña acá**.

### Las tres condiciones que se pidieron

**Todo el ancho, sin salirse.** `left:10px; right:10px` en mobile: 370px de
ficha en una pantalla de 390, con 10px exactos de cada lado. Medido en los
cuatro ítems.

**Por encima de todo.** La ficha estaba en `z-index:300`, **empatada con la
barra del pie** —y en un empate gana el que está después en el marcado— y
**por debajo del botón del relato**, que va en 310. Ahora va en 400. Comprobado
con `elementFromPoint` en tres puntos de la ficha: lo único que devuelve son
sus propios hijos.

**Que no se salga por abajo.** La banda de foto la hizo más alta —272px contra
154— y con `--fy` colgando del pie de la barra de ítems, en una pantalla baja
los botones quedaban fuera de la vista. Ahora hay dos defensas: un
`max-height` que la limita a lo que queda de pantalla, y un ajuste en el JS que
la sube lo justo si no entra.

El ajuste mide con `scrollHeight` y no con `offsetHeight`: el tope de alto del
CSS ya recortó el segundo, así que la cuenta daría que entra cuando en realidad
la ficha se está comiendo su propio contenido. Con el alto real, a 390x420 la
ficha se sube de 150 a 138 y entra casi entera.

### Lo que costó

| pantalla | ficha | dentro | scroll interno |
|---|---|---|---|
| 320 x 568 | 256px | sí | no |
| 390 x 844 | 272px | sí | no |
| 390 x 420 | 268px | sí | 4px |
| 844 x 390, acostado | 251px | sí | no |
| 1280 x 800 | 250 x 251 | sí | no |

De 154 a 272 en teléfono: **+118px**. Es el precio de la banda de foto, y es la
pega de esta variante —se eligió sabiéndolo—. En acostado y en escritorio la
ficha sigue anclada al ítem, no a la pantalla, y ahí mide 251.

### Un error que me hice solo

Al reemplazar el bloque de CSS **me llevé puesta `.item-ficha.on`**, que es la
regla que la enciende. La ficha se abría con la clase puesta pero en
`opacity:0` y `pointer-events:none`: invisible e intocable. Lo delató medir la
opacidad computada en vez de mirar la pantalla.

Y de paso, una trampa del panel de pruebas: la opacidad seguía dando 0 aun con
la regla repuesta, porque **las transiciones no avanzan en un documento que no
se está dibujando**. Apagando la transición se ve el valor de destino. Es la
misma familia que el scroll suave que no corría: si el panel está oculto, todo
lo que depende del reloj de animación queda congelado.


## Las pantallas se deslizan

Entre pantallas **no había ninguna transición**. `openCard` reemplaza el
contenido de la tarjeta con el fondo ya abierto, así que el menú se convertía en
la pantalla de club en el mismo fotograma. Medido con un observador puesto sobre
la tarjeta, recorriendo menú → club → tutorial → tablero:

```
5816ms  contenido reemplazado → CAMPEONATO / TU CLUB
5816ms  fondo = «overlay open»   (no cambia)
6246ms  contenido reemplazado → ¿CÓMO SE JUEGA?
6246ms  fondo = «overlay open»   (no cambia)
6767ms  fondo = «overlay»        ← el único paso animado
```

El contenido y su clase cambiaban **en el mismo milisegundo**, dos veces. Lo
único que se animaba en todo el recorrido era el último paso, cuando el fondo se
apaga para dejar ver el tablero.

O sea que el juego **ya tenía una transición, y era la de salida**. Faltaba la
de pantalla a pantalla, que es justo donde el jugador pasa tres veces seguidas
antes de empezar a jugar.

### Cómo funciona

La tarjeta que entra es **la de verdad, con sus ids**: se le pone el contenido
nuevo enseguida y arranca corrida un ancho de pantalla. La que sale es un
**clon** congelado en el lugar donde estaba, que se va para el otro lado más
despacio y apagándose.

El clon va **sin ids**. `$()` devuelve el primero del documento, así que un clon
con los ids de la pantalla vieja le robaría los botones a la nueva —y el juego
engancharía los `onclick` en una tarjeta que está por borrarse—.

El desplazamiento es `calc(50vw + 50%)`: medio ancho de pantalla más la mitad
del ancho de la propia tarjeta la deja enteramente afuera, mida lo que mida el
hueco. Medido: a 390 arranca en 370px, a 1280 en 950.

### La dirección

Una variable, `dirPantalla`, que `openCard` consume y devuelve a 1. El que
navega para atrás llama a `atras()` antes. Si alguien se olvida de marcarla, la
pantalla avanza, que es lo normal.

Son **nueve** los caminos de vuelta que se marcaron, todos los que van de una
pantalla a otra con el fondo abierto. Los que cierran primero —del tablero al
menú— no se deslizan: ahí la animación es el fundido del fondo, que ya existía y
es la correcta para cruzar esa frontera.

### Dos cosas que hubo que cuidar

**El fondo no puede estrenar una barra horizontal.** La pantalla que sale se va
por el costado, así que el overlay lleva `overflow-x:hidden`.

Pero `hidden` le prohíbe scrollear **al dedo, no a un script**: si algo hiciera
foco en la tarjeta mientras está corrida, el navegador la traería a la vista
moviendo el fondo de costado, y sin barra no habría forma de volver. Comprobado
que se puede —`scrollLeft = 300` funciona igual—, así que al terminar la
animación se resetea a cero.

**Sólo se desliza de pantalla a pantalla.** Si el fondo estaba cerrado, la
apertura ya tiene su fundido y encimarle un desplazamiento la ensucia.
Comprobado: abriendo desde cerrado no se crea ningún clon y la tarjeta no lleva
ningún `transform`.

Y con `prefers-reduced-motion` no se desliza nada.

### Lo que se descartó

**La vertical**, que era mi preferida al proponerla: el eje que la tarjeta ya
usa. Se eligió la horizontal, que dice la dirección más claro —arriba/abajo se
lee como *abrir y cerrar* antes que como *ir y volver*—.

Queda anotado el reparo que tenía: en iOS el *swipe* desde el borde va para
atrás, y una pantalla que viaja a lo ancho invita a ese gesto. Como el juego
vive en una sola pantalla y no hay navegación del navegador que perder, el
choque es teórico; si alguna vez molesta, la vertical está descripta acá.

### Lo verificado

Recorrido completo con los botones de verdad, a 390 y a 1280: menú → club →
tutorial → tablero y de vuelta. Dirección correcta en los dos sentidos —adelante
arranca en +, atrás en −—, ningún clon colgado al terminar, ningún estilo
pegado en la tarjeta, el fondo sin desplazamiento lateral y sin un solo error de
consola en pestaña nueva.

Se animan **sólo `transform` y `opacity`**, que son las dos que el navegador
resuelve sin recalcular el layout.


## I. Rivadavia

El club del nivel 1 pasa de `RIVADAVIA` a `I. RIVADAVIA`, que es como se lo
nombra: Independiente Rivadavia, de Mendoza. A secas se confundía con el
Rivadavia de Lincoln y con el propio Independiente de Avellaneda, que está en
la misma tabla.

El nombre va en mayúsculas como los otros veintinueve: la interfaz los escribe
con `text-transform:uppercase`, así que la tabla habla en el mismo idioma en el
que se lee.

### El largo importa

La ficha de la tira mide **lo que mide el nombre más largo**, así que cualquier
nombre nuevo hay que medirlo antes. La primera versión fue `IND. RIVADAVIA`, de
catorce letras, y pasaba a ser el más largo de la tabla; al medirlo resultó que
entraba igual —54,7px contra los 54,5 de INDEPENDIENTE, porque el punto y el
espacio son angostos— pero quedaba al borde.

Con `I. RIVADAVIA` el más largo vuelve a ser INDEPENDIENTE, con 49,1px de texto
en 68 de hueco a 320 de ancho. Sin recorte en ninguna pantalla.

### Verificado

Que se puede elegir de la tira, que llega entero a la vitrina sin puntos
suspensivos, que arranca la copa con ese nombre y su escudo, que puede salir de
rival, y que **el buscador lo encuentra escribiendo «rivadavia»** —que era lo
que había que cuidar al ponerle una inicial adelante—.


## El escudo de la carta: chapita y esquina nueva

Dos cambios sobre lo mismo: **d&oacute;nde va** y **c&oacute;mo se ve**.

### La esquina, medida y no a ojo

Estaba arriba a la izquierda. Recort&eacute; **las 21 fotos** que usan las cartas
igual que las recorta la carta y med&iacute; el detalle de cada esquina en un
cuadrado del tama&ntilde;o de la chapita. El detalle es cu&aacute;nto var&iacute;a la imagen ah&iacute;:
mucho detalle significa que hay algo que mirar y taparlo cuesta.

| esquina | detalle | fotos cargadas | peor caso |
|---|---|---|---|
| arriba izquierda **(donde estaba)** | 44 | 8 de 21 | 72 |
| arriba derecha | 41 | 7 de 21 | — |
| abajo izquierda | 34 | 4 de 21 | — |
| **abajo derecha** | **32** | **3 de 21** | **50** |

La esquina de antes era **la peor de las cuatro**, y no por poco: casi tres
veces más fotos cargadas que la nueva y un peor caso muchísimo más duro. El
motivo se ve apenas se mira: en las cartas de jugador **el cuerpo del futbolista
está justo ahí** —DELANTERO 72, DEFENSOR 70, CAÑO 69—.

Lo que se pierde es la diagonal con el número de la carta, que vive arriba a la
derecha: ahora los dos pesos quedan sobre el mismo borde. Se eligió sabiéndolo.

### La chapita

Antes era el escudo suelto con una sombra difuminada, y sobre una foto clara se
perdía. Ahora se apoya en una chapita con el fondo desenfocado: la foto se sigue
viendo detrás pero deja de competir, y el escudo pasa a apoyarse en **una
superficie propia en vez de en la imagen**.

El escudo crece de **13 x 15 a 16 x 19**, y la carta no cambia ni un píxel: la
chapita es absoluta sobre la ilustración, como antes.

**El fondo va más claro que la foto, no más oscuro.** El primer intento tenía un
negro al 50% y los escudos oscuros —Riestra, C. Córdoba, Newell's— se fundían
con la chapa: sólo se veía la silueta. Un azul levantado los despega a los doce.

### El corte por alto hubo que subirlo

Había un `max-height:700px` que esconde el escudo cuando la ilustración se
achica hasta ser una franja. Ese número estaba calculado para un escudo de 15px
y **con la chapita quedó corto**. Medido a 390 de ancho, qué proporción de la
franja se come:

| alto | franja | chapita | |
|---|---|---|---|
| 710 | 27px | 23 | **85%** — la tapa entera |
| 730 | 32px | 23 | 72% |
| 750 | 37px | 24 | 65% |
| 770 | 42px | 24 | 57% |
| 844 | 60px | 26 | 43% — lo normal |

Con el corte en 700, la chapita aparecía justo donde no entra. Se subió a
**760**: el que pierde el escudo es el mismo teléfono al que la carta ya le
quedó reducida a nombre y resultado.

Hay un `max-height:calc(100% - 4px)` en el SVG que estaba pensado como red para
esto y **nunca funcionó**: el porcentaje se mide contra la altura del padre, que
es `auto`, así que no resuelve y el navegador lo trata como `none`. Queda,
porque no molesta, pero la red de verdad es la consulta por alto.

### Verificado

A 390x844: los 16 escudos en la mesa, chapita de 25 x 26 a 4px de los dos
bordes, enteramente adentro de la ilustración, y la carta en 80 x 139 como
antes. A 1280x800: 27 x 28 sobre una ilustración de 169 x 116, el 25%. A 750 el
escudo no está; a 780 sí. Sin errores de consola en pestaña nueva.

## v185 · el escudo sobre la foto y el renglón del valor

Dos arreglos al mismo cartel: el pop-up que se abre cuando tocás una carta.

### El escudo, ahora en los dos lugares

La cinta de arriba ya llevaba el escudo chico al lado del nombre del club desde
que existe. Ahora hay **también uno grande abajo a la derecha de la foto**, con
la misma chapita de vidrio esmerilado que la carta estrenó en v184: mismo fondo
azul al 50%, mismo `blur(5px) saturate(1.3)`, mismo borde blanco tenue, misma
esquina. El de la cinta acompaña al nombre y dice **de quién es la jugada**; el
de la foto es el que se ve de lejos y **ata el cartel a la carta que acabás de
tocar**. Hacen cosas distintas, así que van los dos.

De dónde sale el escudo lo decide ahora una sola línea, `escudoDeLaJugada`, que
usan la carta de la mesa, la cinta y la foto. Antes la misma cuenta estaba
escrita dos veces; con tres no podían seguir discrepando en silencio.

Si todavía no hay escudos en juego —tutorial, pantallas sueltas— la cinta cae en
el renglón viejo y **el escudo de la foto simplemente no se dibuja**. Verificado
poniendo `G.escudo` y `G.escudoRival` en nulo: aparece el `p-tag` de antes y no
queda ninguna chapa vacía.

### El renglón del valor es el renglón del panel

Era una línea de texto apagado, «VALOR 2 · TU ATAQUE 2», mientras el resto del
juego mete todos sus números en un recuadro de color. Ahora usa **el molde del
panel de stats de la columna derecha** —el número grande en su recuadro sin
radio, y al lado el rótulo arriba con la aclaración abajo.

No es una copia: son **las mismas clases**, `.stat` y `.stat-txt`. Si el panel
cambia, el cartel lo sigue solo. Lo único que se pisa acá es lo que el panel
necesita por estar en una columna —el relleno y la línea punteada que separa una
fila de la siguiente— que adentro del cartel no separan nada.

**El color es el eje, no el resultado.** Rojo cuando la carta se pelea con tu
ataque, azul cuando se pelea con tu defensa, igual que la chapita del valor
arriba de la carta. Eso significa que el renglón **se ve idéntico en los tres
desenlaces** y no dice quién gana: eso lo dicen el cartel de abajo —LO PASÁS, LA
PERDÉS, MINI JUEGO— y el borde del pop-up. Arriba los datos, abajo la
conclusión.

El precio de esa regla es que cuando ganás un duelo de ataque quedan **números
rojos arriba de un cartel verde**. Se miró y se dejó así: el rojo ahí significa
«con qué stat tuyo se pelea esta carta», y cambiarlo por el tono del resultado
haría que el mismo color quisiera decir dos cosas distintas según dónde estés
mirando.

### Entró al tamaño del panel, sin achicar nada

La duda era si el molde completo —número de 29px, rótulo de 12.5— entraba en un
cartel que en el teléfono es mucho más angosto que la columna. Medido en el
juego andando, con DEFENSA que es el rótulo más largo:

| pantalla | ancho útil | lo que usa | sobra |
|---|---|---|---|
| 320 x 568 | 226px | 198px | 28px |
| 390 x 844 | 296px | 198px | 98px |
| 1280 x 840 | 497px | 224px | 273px |

Entra hasta en el teléfono más angosto, así que **no hubo que achicar el molde**
y las dos piezas quedaron literalmente del mismo tamaño. En escritorio el
renglón crece con el resto del cartel: número de 34px y separación de 26.

### Lo que empeoró un poco, y por qué se deja

En teléfono acostado —844 x 390— el pop-up **ya se desbordaba 159px antes de
este cambio** y ahora se desborda 188. El renglón agrega 29px a un problema que
ya estaba: a 844 de ancho manda la rama de escritorio, porque la consulta de
móvil pregunta por ≤820. Scrollea, así que se usa; arreglarlo es mover ese
breakpoint, que es otro cambio y sigue en la lista.

### Verificado

A 390x844 los tres desenlaces con DEFENSOR —empate 2v2 con borde dorado, ganado
1v2 verde, perdido 3v2 rojo— y el eje en rojo en los tres. Con DELANTERO el eje
pasa a azul y el rótulo dice DEFENSA. Renglón de 296x35 sin desbordes ni rótulos
cortados; escudo de 29x32, entero adentro de la foto, tapando el 23% de su alto
(29% a 320px). Carta con foto y sin valor: escudo sí, renglón no. Sin errores de
consola.

## v186 · que la carta entre con la barra del navegador a la vista

El síntoma era «no se ajusta hasta que hago un gesto mínimo para arriba».

### No era lo que parecía

La primera sospecha fue el tiempo: que `dvh` tardara en resolverse, o que
faltara escuchar `resize`. Medido, ninguna de las dos. El juego **no tiene un
solo listener de tamaño** —el ajuste es cien por ciento CSS— y la cadena de
flex está bien armada: `body{height:100dvh}` → `.wrap` → `.cancha` → `.board`,
todos con `min-height:0`.

Lo que pasa es más simple y más tonto: **con la barra del navegador a la vista
la carta no tiene alto para su propio texto**, y el gesto que esconde la barra
es justo lo que le da los 80px que le faltaban. El jugador no estaba
destrabando un cálculo: le estaba regalando pantalla.

Medido en el juego andando a 390 de ancho, cuánto se recorta del renglón de
resultado y en cuántas cartas:

| alto | qué pasa |
|---|---|
| 745 — barra plegada | nada |
| 664 — barra a la vista | 9px en 1 carta |
| 600 | 25px en 1 |
| 560 — iPhone SE | 35px en 12 |

El salto 664 → 745 es exactamente el que produce el gesto. Por eso «se
arreglaba solo».

### Por qué la del mini juego es la primera en romperse

Es **la única carta con tres piezas apiladas**: la chapa 🎮 MINI JUEGO, el
nombre MANO A MANO y el efecto. Las demás tienen dos. A 664 la ilustración ya
colapsó a **cero**, así que no queda nada más que ceder y el texto se sale por
abajo del `overflow:hidden` de la celda.

### La escalera

Tres escalones que sacan **de lo más decorativo a lo más informativo**, nunca
al revés:

| alto | qué se va | por qué se puede |
|---|---|---|
| ≤700 | la chapa 🎮 MINI JUEGO | dice lo mismo que el nombre que tiene debajo |
| ≤620 | aire entre piezas | uno de los dos huecos rodea una ilustración que ya vale cero |
| ≤580 | el detalle del efecto | queda el veredicto, que es lo que hace falta para elegir la fila; el detalle sigue entero en el pop-up |

Primero se probó bajar el escalón del efecto sólo a la carta del mini juego, y
a 560 seguía rozando 8px: no es la única de dos líneas, también están las de
«LA CLAVÁS / ⚽ GOL +1». Va para todas, y la escalera quedó en tres pasos en
vez de cuatro.

También se probó volver `.esgol` a `display:inline` para ganar una línea.
**Empeoró**: el texto envuelve igual y la caja crece de 25 a 28px. Descartado.

### La guarda de ancho no es opcional

Las tres consultas preguntan por `(max-width:820px) and (max-height:…)`. Sin la
parte del ancho, **una ventana de escritorio baja entra en las reglas**: a
1280x600 la carta mide 185x254 y no le sobra nada, y aun así perdía la chapa.

Es el mismo error que traía la consulta del escudo desde v184 —
`@media (max-height:760px){ .cell .c-esc{display:none} }` sin guarda— que a
1280x600 escondía el escudo con una ilustración de **112px**, donde entraba de
sobra. Corregido en esta misma versión.

### Verificado

Con una grilla sembrada a propósito con las cuatro cartas de duelo, que son las
más altas, en 390 de ancho: 560, 664, 745 y 844 quedan en **cero recortes**,
con el marcador visible, la última fila entera y sin desborde. A 745 y 844 las
reglas son **inertes**: la chapa vuelve sola. A 1280x600 y 1280x840 la chapa y
el escudo están visibles, que es lo que corrige la guarda.

### Lo que sigue abierto

En **escritorio** el tablero no se ajusta a la ventana: a 1280x840 la página
desborda 431px y la última fila queda abajo del pliegue. No es de esta versión
—ya pasaba antes— y no lo toca: la cáscara de `100dvh` vive sólo en la rama de
móvil. Es el mismo problema que se acaba de arreglar en el teléfono, del otro
lado del breakpoint.

A 1280x600 el desborde pasa de 627 a 706px, porque devolver la chapa y el
escudo hace la carta 25px más alta. Es el precio de no esconder cosas que
entran.

## v187 · la pantalla principal es un póster

De las cinco maquetas que se compararon, salió **la C**.

### Lo que cambia

El menú dejó de ser una tarjeta con una foto adentro y pasó a ser **una sola
imagen a sangre con el menú encima**. La foto es la misma de antes —el estadio
desde arriba— pero entera y sin agrandar: a sangre no hace falta acercarse.

Tres razones, en orden de peso:

1. Es la primera pantalla que se ve. Una tarjeta centrada sobre fondo oscuro se
   lee como un cuadro de diálogo; el estadio ocupando todo se lee como la
   portada de un juego.
2. **Todo lo tocable bajó al tercio inferior**, que es adonde llega el pulgar.
   Antes el modo principal quedaba en el medio de la pantalla.
3. El logo dejó de competir con la foto del recuadro de CAMPEONATO. Eran dos
   imágenes grandes a diez píxeles una de la otra.

CAMPEONATO es ahora **el único botón relleno de toda la pantalla**, así que no
necesita ser más grande para mandar. Los otros tres son chips de vidrio
esmerilado sobre la foto, con el mismo tratamiento que la chapita del escudo en
las cartas.

### Se fueron los seis emoji

El menú tenía **🏆 ⚽ 🤝 🥅 ⚙ ★** y no combinaban entre sí. Los cuatro primeros
los dibuja el sistema operativo, o sea que **el menú se veía distinto en cada
teléfono** y ninguno combinaba con el logo; los otros dos son glifos monocromos,
así que ni entre ellos pegaban.

Ahora son seis símbolos del sprite que ya existía —`i-copa`, `i-pelota`,
`i-dos`, `i-arco`, `i-ajustes`, `i-firma`— con el mismo molde que `i-atk` o
`i-gri`: 24x24, trazo de 1.6 y `currentColor`. No es una dirección nueva: es la
que el juego ya venía siguiendo y que un comentario de `i-atk` dejó anotada.

Dos decisiones de dibujo que no son obvias:

- **OPCIONES lleva deslizadores, no un engranaje.** Un engranaje dice «acá está
  el motor»; los deslizadores dicen «acá se ajusta algo», que es lo que hay.
- **CRÉDITOS lleva una firma**, no una estrella. La estrella dice «favorito»;
  la firma dice quién lo hizo, que es de lo que se trata.

Se agregó `ICO(n)`, que arma un `<use>` del sprite, y la clase `.ic`, que los
mide en `em`: cada lugar los escala con su propio `font-size` y no hace falta
una regla de tamaño por ícono.

### Tres cosas que sólo aparecieron al probarlo en el juego

**El gris con relieve del navegador.** `.mm-enl` —OPCIONES y CRÉDITOS— era el
único botón del menú que no declaraba fondo ni borde propios, y el juego **no
tiene un reset global de `button`**. Salían con el `#f0f0f0` y el `border:2px
outset` de fábrica. En la maqueta no pasaba porque ahí sí había reset.

**El toque de 25px.** Medido, esos dos botones quedaban en 25px de alto, que
para un dedo es poco. Con `min-height:40px` suben sin dejar de parecer enlaces.
En pantalla baja el piso cede a 32, como todo lo demás.

**La franja negra de 15px.** Acostado, el tablero que queda **detrás** del menú
desborda y la página estrena su barra vertical; como el overlay es `fixed`,
abarca la ventana menos esa barra, y la pantalla a sangre quedaba con una franja
a la derecha. Se resuelve con un candado: mientras el menú está arriba, `html` y
`body` van en `overflow:hidden`. No hay nada que scrollear atrás, y si el menú
llegara a necesitarlo, el overlay tiene su propio scroll.

El candado se pone en `openCard` junto con `ov-menu` y **se suelta en
`closeCard`**, que es el camino por el que el menú se va cuando arranca el
partido. Sin eso el tablero quedaba sin poder moverse. Verificado en los seis
pasos del recorrido —menú, OPCIONES, vuelta al menú, tablero, menú otra vez,
cerrado— y el candado entra y sale sin fugas.

### Verificado

A 390x844, 390x664, 320x568, 844x390 y 1280x840: cero texto recortado, cero
desborde, los seis botones visibles y tocables, y la tarjeta **a sangre** en los
cinco —el ancho de la tarjeta es igual al de la ventana—. El toque más chico
mide 40px parado y 32 acostado. Sin errores de consola en pestaña nueva.

### Lo que queda por limpiar

`.menu-op`, `.mo-ico`, `.mo-txt` y `.menu-fila` quedaron **sin uso**: eran del
menú viejo y no los toca nadie más. No se borran acá porque `.menu-op:hover`
aparece agrupado con `.palo`, `.cta` y otros en dos reglas del bloque de touch, y
sacarlo de esas listas es un cambio aparte que merece su propia revisión.

## v188 · el relleno de los botones

Sólo botones. Ningún otro estilo se toca.

### El problema

Todos los botones del juego eran **contornos dorados**. El que arranca el
partido se veía igual que el que te saca de la pantalla, y en una pila de tres
no había manera de saber cuál era la salida principal sin leer los tres.

La única excepción era `.cta.jugar`, verde y relleno, que ya existía **en tres
lugares sueltos** y hacía exactamente lo mismo que otros cinco botones dorados.
O sea que la idea ya estaba en el juego, a medio aplicar.

### La regla

Uno relleno por pantalla, y es la acción principal. El color dice de qué clase:

| tratamiento | para qué |
|---|---|
| **verde relleno** | arranca o sigue el partido |
| **dorado relleno** | confirma una elección y avanza |
| **contorno** | la salida secundaria |
| **fantasma** | volver, cuando arriba hay algo más importante |

El verde es **el de `.cta.jugar`**, borde claro incluido, para que los tres que
ya eran verdes y los diecisiete nuevos sean el mismo verde y no dos parecidos.

### Por qué ninguna pantalla cambia de tamaño

Porque **no son una clase nueva, son modificadores**: `.cta.n-verde`,
`.cta.n-oro`, `.cta.n-linea`, `.cta.n-fantasma` y `.cta.n-apagado` se le suman
a `.cta`, no la reemplazan. Heredan el ancho, el alto, el relleno, la
tipografía y **todas las consultas de pantalla** que `.cta` ya tenía.

No es una promesa: es consecuencia de cómo está escrito, y está medido. Con
v187 sacado de su etiqueta y servido al lado, los mismos botones en las mismas
pantallas dan **exactamente las mismas medidas**:

| pantalla | v187 | v188 |
|---|---|---|
| elegir club | 324x48 / 324x45 | 324x48 / 324x45 |
| opciones | 324x46 | 324x46 |
| créditos | 324x46 | 324x46 |
| penales | 324x46 / 324x45 | 324x46 / 324x45 |
| aviso beta | 324x46 / 324x45 | 324x46 / 324x45 |
| cómo se juega | 324x43 / 324x41 | 324x43 / 324x41 |

Lo mismo a 320x568. La primera versión de esto **sí crecía 22px por botón**,
porque definía una clase propia; al medirlo se rehízo como modificador.

### Tres cosas que aparecieron contando los botones

**Los conté por línea y no por rama, y me equivoqué.** Dije que
`duelResultado` tenía dos botones principales juntos. No es cierto: están en
ramas opuestas de un `if` y **nunca aparecen juntos**. Si la serie terminó sale
JUGAR OTRA VEZ con VOLVER AL INICIO; si sigue, JUGAR EL PARTIDO N solo.

**El mismo botón con dos sentidos.** En `comoSeJuega`, entrando desde el menú
el `.cta` dice EMPEZAR LA COPA y entrando desde el partido dice **VOLVER AL
PARTIDO**. Así que el tratamiento también cambia con la rama: verde en un caso,
contorno en el otro.

**El estado apagado.** El botón de `showElegirItems` arranca deshabilitado
diciendo ELEGÍ AL MENOS UNO. Con relleno no alcanza con bajarle la opacidad: un
verde lleno al 40% se lee como un botón **roto**, no como uno que todavía no se
puede tocar. Va en contorno apagado y se rellena recién cuando hay algo que
confirmar. Lo mismo en `showDuelLocal`.

### Lo que no cambia

El **latido** de `.cta.llama` se conserva tal cual: es lo que avisa que el juego
está frenado esperándote, y es información, no decoración.

Y **33 de los 60 botones no se tocan**, porque no son acciones sino selectores:
los palos del penal, los escudos, los colores, la tira de clubes y los del menú,
que ya se hicieron en v187.

### Verificado

Recorriendo el juego pantalla por pantalla: **ningún botón quedó sin
tratamiento**. Los íconos del sprite se dibujan a 14–15px, el desplegable de
ítems muestra bien sus dos estados —con USAR y sin USAR— y los pop-ups que
frenan el partido conservan el latido con el relleno nuevo. Sin errores de
consola en pestaña nueva.

### Cómo volver atrás

Esta versión toca **sólo botones**, así que se puede deshacer sola:

```
git revert v188-duelo-futbolero
```

o volver al estado exacto de antes con `git checkout v187-duelo-futbolero`.

### v188.1 · el USAR del desplegable no se pintaba

Jugando una partida entera apareció el único que se había escapado: en la ficha
del ítem, **USAR seguía saliendo dorado plano** en vez de verde.

La causa es de manual: `.item-ficha:not(.ficha-gol) .if-btn`, que la ficha
estrenó en v181, pesa **0,3,0** y el modificador `.if-btn.n-verde` pesa **0,2,0**.
Encima la regla de la ficha va más abajo en la hoja, así que ganaba por los dos
lados.

Se arregla subiendo el modificador a **0,4,0** y —esto es lo que importa para la
próxima vez— **poniéndolo pegado a la regla que lo pisaba**, no en el bloque de
botones. Si algún día cambia la ficha, las dos reglas están juntas.

El resto de la partida salió limpio: el menú, el club, el tutorial, el tablero,
el pop-up de la jugada, el mini juego, el cartel de racha llena, el fin de
partido, el vestuario y el mercado. Sin errores de consola.

## v189 · el cartel de gol: escudos y marcador centrado

De los tres ejemplos salió **la A**: la foto no se toca y lo que cambia es la
franja de abajo.

### Tres columnas y no cinco

El marcador era una grilla de cinco —nombre, número, guion, número, nombre— con
los nombres en las columnas elásticas de los extremos. Eso hacía que **el
resultado no estuviera centrado de verdad**: se corría según cuánto midiera cada
nombre. BANFIELD contra EST. RÍO IV lo empujaba para un lado; RIVER contra BOCA
lo dejaba derecho.

Ahora son tres columnas —equipo, resultado, equipo— y el resultado queda clavado
en el medio mida lo que mida el nombre. Medido: el desvío entre el centro del
marcador y el centro de la franja es **0px** en todas las pantallas probadas, y
las dos columnas de los costados dan siempre lo mismo.

### Y aparecen los escudos

Cada equipo pasa a ser una chapa con **el escudo arriba del nombre**, que es
como el juego los muestra en todos lados —la marquesina, el pop-up de la jugada,
la carta—. Acá faltaban: el cartel más importante del partido era el único que
no decía de quién era el gol con algo más que el color del nombre.

Salen de donde ya salían para la marquesina: `G.J[0]` y `G.J[1]` en el duelo,
`G.escudo` y `G.escudoRival` en el campeonato. **Si no hay ninguno** —el
tutorial, una pantalla suelta— el cartel se arma igual con el nombre solo.
Verificado poniendo los dos en nulo.

### Los tamaños

El ancho y la banda de la foto no se tocan. El cartel pasa de **350x301 a
350x305** a 390 de ancho: cuatro píxeles, que son los que ocupa el escudo arriba
del nombre.

| pantalla | cartel | escudo |
|---|---|---|
| 320 x 568 | 280 x 232 | 30px |
| 390 x 844 | 350 x 305 | 30px |
| 844 x 390 | 500 x 215 | 22px |
| 1280 x 840 | 538 x 401 | 40px |

Acostado el escudo cede antes que el número, que es el dato que se busca.

### El que no entraba

A 320 de ancho, **INDEPENDIENTE** —el nombre más largo del juego, 13 letras—
pedía 95px y tenía 88: se recortaba con puntos suspensivos. Los otros 29 clubes
entraban de una. Apretando el relleno de la franja y el hueco de la grilla en
pantallas de hasta 360 entran los siete que faltaban, y ahora **entran los
treinta**.

### Verificado

Los dos carteles —el tuyo y el del rival— en 320x568, 390x844, 844x390 y
1280x840: grilla simétrica, marcador centrado, ningún nombre recortado, los dos
escudos presentes y el cartel entero en pantalla. Sin errores de consola en
pestaña nueva.

Una nota de medición para la próxima: el panel del navegador **congela las
animaciones cuando está oculto**, y `golpop` arranca en `scale(.72)`. Medir el
escudo con `getBoundingClientRect` daba 29px en vez de 40. Los números de arriba
salen de `offsetWidth` y de estilo computado, que no dependen de eso.

## v190 · las cajas de PASASTE, en dos tiempos

De los tres ejemplos salió **la B**.

### El orden estaba al revés

Era **etiqueta → escudo → dato → nombre**. O sea que el marcador se metía
**entre el escudo y el nombre al que pertenece**: el 2-1 separaba el escudo de
SARMIENTO de la palabra SARMIENTO.

Y había algo peor, que no se ve hasta mirar el CSS: el nombre iba último, a
10px y con `opacity:.85`. **Lo más apagado de la caja era justamente de quién
estamos hablando.**

### Cómo queda

Arriba **quién** —escudo y nombre pegados— y abajo, separado por un hilo, **qué
pasó**: el marcador o la ronda que viene. La caja se lee en dos tiempos en vez
de cuatro renglones del mismo peso.

El hilo toma el color de la caja: gris en la que ganaste, dorado en la que
viene. Y el nombre sube a 11px sin opacidad, con algo de peso: si es lo que
identifica al equipo, no puede ser lo más tenue.

El `padding-bottom` de la caja pasa a cero y se lo lleva el pie, así el hilo
llega a los dos bordes en vez de quedar flotando con aire debajo.

### El «en penales»

Estaba suelto abajo del nombre. Ahora vive **en el pie, al lado del marcador**,
alineado a la misma línea de base: se lee «2-1 en penales», que es una sola cosa
y no dos.

### Los tamaños

La caja crece **15px de alto** —de 139 a 154 a 390 de ancho— que es lo que ocupa
el hilo con su respiro. La tarjeta entera queda en 350x472 y entra sin problema.

| pantalla | caja | tarjeta |
|---|---|---|
| 320 x 568 | 131 x 139 | 304 x 425 |
| 390 x 844 | 154 x 154 | 350 x 472 |
| 844 x 390 | 231 x 139 | 520 x 362 |
| 1280 x 840 | 239 x 154 | 520 x 485 |

A 320 y en horizontal la caja mide 139 y no 154 porque la consulta de
`max-height:700px` ya achicaba los escudos de 70 a 55px; el pie entra en el
lugar que eso libera.

### Verificado

Las dos cajas en 320x568, 390x844, 844x390 y 1280x840, con y sin «en penales»:
mismo alto las dos, nada recortado —ni con **INDEPENDIENTE**, el nombre más
largo, forzado en las dos— y la tarjeta entera en pantalla. Sin errores de
consola en pestaña nueva.

## v191 · el reflejo del ítem que se puede usar

De los tres ejemplos salió **la B**, con el reflejo más rápido que el de la
maqueta.

### La marca era por ausencia

El ítem usable **no tenía ninguna señal propia**: era la caja común. Lo que
estaba marcado era el que *no* sirve —punteado y todo al 50%—, así que para
saber si podías usar algo había que **compararlo con otro**.

Y eso falla justo cuando más importa: si los cuatro se pueden usar, o si no se
puede ninguno, **no hay con qué comparar** y la franja se ve igual en los dos
casos.

### El reflejo

Una luz cruza el ítem usable cada **2,2 segundos**, y el barrido se lleva el 20%
del ciclo —440ms—. En la maqueta era 3,4s; quedó más rápido a pedido.

Van **escalonados** de a 280ms: cuatro reflejos saliendo juntos parecen un
parpadeo de la pantalla, saliendo en fila se leen como cuatro objetos distintos.

Con `prefers-reduced-motion` no se mueve nada y queda un filo interior quieto,
que dice lo mismo sin insistir.

### El recorte no puede ir en el botón

Esto es lo único delicado del cambio. El reflejo necesita `overflow:hidden` para
no salirse de la caja, pero **no se lo puede poner al `.item`**: la ficha del ítem
vive *adentro* del botón y se despliega hacia afuera, así que recortar el botón
la haría desaparecer.

Es exactamente la misma razón que ya está escrita unas líneas más abajo para
`.onda-caja`, y la solución es la misma: el reflejo trae **su propia caja que
recorta**, absoluta y con `border-radius:inherit` para seguir la forma del botón.

Verificado: con el reflejo puesto la ficha abre en **370x226**, sigue siendo hija
del botón y **no se recorta**.

### Cuándo aparece

Sólo en el que se puede usar **de verdad**. Se calcula de las dos condiciones que
ya existían —`itemInutil(k)` y el `disabled` del botón— así que no pueden
discrepar. Medido en los cuatro estados:

| estado | reflejo |
|---|---|
| inútil con la mesa que hay | no |
| usable | **sí** |
| mesa ocupada (`G.busy`) | no |
| vuelve a estar libre | **sí** |

### Los tamaños

No cambia ninguno: el reflejo vive en un elemento absoluto que no ocupa lugar.
Medido con dos ítems: **73x29** a 390 de ancho, **55x29** a 320 y **184x93** en
escritorio, donde la franja pasa a ser columna. El radio se hereda bien en los
dos layouts —9px en móvil, 7 en escritorio— y la caja va con
`pointer-events:none`, así que no se come ningún toque.

### Verificado

A 390x844, 320x568 y 1280x840: mismo tamaño de ítem que antes, el reflejo
siempre dentro de su botón, sin desborde horizontal y la ficha abriendo entera.
Sin errores de consola en pestaña nueva.

## v192 · el penal definitorio dice dónde estás

De los tres ejemplos salió **la A**.

### El título decía lo que menos importaba

La instancia vivía en la **etiqueta de 10px** de arriba, compartiendo renglón
con PENAL DEFINITORIO, y el título grande lo ocupaba **UNA PELOTA**.

O sea que el cartel más definitivo del campeonato usaba su tipografía más
grande para decir **cuántos tiros hay** en vez de **qué se está jugando**.

Ahora el título es la instancia —CUARTOS, SEMIFINAL, lo que toque— y debajo, en
la tipografía de texto y apagado, PENAL DEFINITORIO.

### Qué se pierde, y por qué no importa

«UNA PELOTA» decía que hay **un solo tiro**. Eso ya lo dicen el arco vacío y las
dos chapas de abajo —ENTRA → SEMIFINAL, LA ATAJA → SE ACABÓ—. Era relato, no
información.

### Hay dos instancias en el cartel

Conviene tenerlo anotado porque se presta a confusión: el cartel nombra **la que
se juega** y **la que se gana**. El título ahora dice la primera —dónde estás— y
la chapa verde de abajo sigue diciendo la segunda —el premio—.

### Los tamaños

El cartel **baja de 359 a 355px** de alto a 390 de ancho: el encabezado gastaba
dos renglones para lo que ahora ocupa uno y su bajada.

| pantalla | cartel | título |
|---|---|---|
| 320 x 568 | 294 x 355 | 24px |
| 390 x 844 | 350 x 355 | 24px |
| 844 x 390 | 480 x 343 | 34px |

Probado con **CLASIFICATORIA**, que es el nombre de instancia más largo: entra
en una sola línea en las tres pantallas.

### El estado resuelto no se toca

Cuando el penal se dispara, `morfarPop` reemplaza todo el contenido y arma su
propia etiqueta. Verificado tirando el penal: sale «LA PONÉS IZQUIERDA · EL
ARQUERO VUELA A TU IZQUIERDA», el título del desenlace y el resultado, sin
rastro de la bajada nueva.

### Un crash latente que encontré y no toqué

`tirarPenal` arma la chapa verde con `RONDA(G.ronda + 1).name`. En **LA FINAL**
no hay ronda siguiente, así que eso sería un `TypeError`. Y como el cartel se
arma dentro de un `new Promise`, el error **no se vería**: se convierte en un
rechazo silencioso, el cartel no se monta y el juego queda esperando una promesa
que no resuelve nunca.

**Hoy es inalcanzable.** Unas líneas más arriba el código desvía la final y el
partido único a la tanda completa de cinco, y sólo las rondas de paso llegan a
`tirarPenal`. Verificado forzando `G.ronda` a la última: el rechazo existe, pero
ningún camino del juego pasa por ahí.

Queda anotado por si algún día se agrega una ronda después de la final o cambia
esa guarda. El arreglo es una línea.

### Verificado

Las tres instancias jugables en 320x568, 390x844 y 844x390: título en una línea,
bajada completa, cartel entero en pantalla y sin scroll interno. El estado
resuelto intacto. Sin errores de consola en pestaña nueva.

## v193 · los emoji del mini juego de penales

Dos pantallas, una elección en cada una: **la B en el sorteo** y **la A en el
penal del partido**.

### No era uno: eran cuatro

Buscándolo midiendo el DOM del juego andando —no leyendo el archivo— aparecieron
cuatro, y el más grande no estaba donde parecía:

- **El sorteo** —la pantalla que abre el mini juego, «el que gana patea
  primero»— tenía **tres**: el árbitro a **56px** y las dos lunas a 30px adentro
  de los botones CARA / SECA.
- **El penal del partido**, el que sale de una posibilidad de gol, tenía el
  blanco de tiro en el **título grande**.
- **El penal definitorio** (el de v192) y la tanda de cinco no tenían ninguno.

### El juego ya dibujaba la moneda

Éste es el punto: cuando la moneda cae, el cartel resuelto muestra `GESTOS.cara`
y `GESTOS.seca` —un disco con centro y un anillo—. Pero los botones para
**elegir** usaban dos lunas del teclado, que salen naranja y violeta.

O sea que elegías una luna y te salía una moneda. Ahora los tres lugares —los
dos botones, el disco de arriba y el desenlace— muestran **el mismo par de
dibujos**. No se inventó ninguno.

### El árbitro

Arriba iba un árbitro emoji a 56px. En su lugar va la moneda, **con la misma
regla**: mismo tamaño, mismo margen, y el mismo `.girando` cuando elegís. La
clase pasó de `.mon-arb` a `.mon-moneda`, porque el nombre viejo ya mentía.

La otra opción era sacarlo del todo —el cartel bajaba 65px—, pero el sorteo
perdía el momento. Es la pantalla que tiene que hacerte sentir que hay una
moneda en el aire.

### Los botones, que se habían quedado en v187

Mientras medía apareció que **los botones CARA / SECA nunca pasaron por el
rebranding de v188**: seguían con su degradado propio mientras todos los
secundarios del juego usan el fondo plano de `.cta.n-linea`. Ahora lo usan.

**El hover y el elegido están escritos a mano.** No es redundancia: el fondo
plano de `.sit.moneda .palo` es 0,3,0 y le gana por orden al `.palo:hover`
del principio de la hoja, así que sin esas dos líneas los botones se quedaban
sin respuesta al tocarlos y el elegido perdía su borde dorado.

### El penal del partido

Se borró el emoji y el título quedó en **PENAL**. Nada más. La alternativa era
sumarle una bajada al estilo de v192 diciendo quién patea, pero eso ya lo dice
el renglón de abajo con otras palabras: «¿A qué palo **la mandás**?» contra «¿A
qué palo **volás**?». No valía sumar 19px para repetirlo.

### Los tamaños

| pantalla | v192 | v193 |
|---|---|---|
| sorteo · 320 x 568 | 311 | **308** |
| sorteo · 390 x 844 | 297 | **294** |
| sorteo · 844 x 390 | 330 | **327** |
| sorteo · 1280 x 840 | 340 | **337** |
| penal · 390 x 844 | 323 | **323** |

El sorteo baja **3px** en todos lados y el penal no se mueve un píxel.

### Verificado

Medido en el juego corriendo, no en maquetas: **cero emoji** en las dos
pantallas y en el cartel resuelto del sorteo. El sorteo completo —elegir, el
giro, SALIÓ CARA con su dibujo— y el penal suelto, en 320x568, 390x844, 844x390
y 1280x840: todo entra en pantalla, sin scroll interno. El botón elegido
conserva el borde dorado y el fondo dorado al 14%.

Un detalle de medición que vale anotar: el panel del navegador **congela las
transiciones CSS**, así que leer `border-color` justo después del clic devuelve
el valor de partida y parece un bug de especificidad. Con `transition:none`
puesto a mano, el borde dorado aparece. No había tal bug.

## v194 · campeón: un botón, un camino derecho y un bullet

Tres cosas en la pantalla que remata el campeonato.

### El pie: queda COMPARTIR solo

Eran dos botones contorneados en fila —COMPARTIR y COPIAR—. Ahora en **CAMPEÓN**
queda uno solo, centrado, con **los mismos 155px** que tenía cuando eran dos.

El ancho no es un capricho: sin el segundo botón, el `flex:1` de `.cta.chica`
—y el `width:100%` de `.cta`— lo estiran a toda la caja, y ahí compartir pasa a
pesar lo mismo que JUGAR OTRO CAMPEONATO, que es el botón que importa. La clase
`.cta-fila.solo` lo centra y le devuelve su ancho.

**ELIMINADO sigue con los dos.** El pedido era para CAMPEÓN, y además ahí COPIAR
es la única salida al portapapeles: COMPARTIR usa el menú del sistema y, cuando
el navegador no lo tiene, abre WhatsApp Web. Si algún día se unifican las dos
pantallas, el cambio es la bandera `campeon` que `botonesFinal()` ya recibe.

### EL CAMINO: los nombres arrancaban en una escalera

**Cada fila era su propia grilla.** Con `grid-template-columns:1fr auto`, el `auto`
valía lo que medía *esa* fila: la columna de la derecha arrancaba en **216px** en
CLASIFICATORIA y en **252** en OCTAVOS. Los nombres quedaban pegados al borde
derecho y con el costado izquierdo hecho una escalera de cinco escalones.

Ahora la columna fija es la del **resultado** —que mide siempre lo mismo, «N-N»—
y la del nombre se queda con el resto. Las cinco rondas arrancan en **x = 56** en
todas las pantallas donde el camino se dibuja como lista.

El `minmax(34px, auto)` es por si algún día entra un resultado de dos cifras: esa
fila se ensancha sola en vez de pisarse. Hoy el texto mide 27px, así que sobran
siete.

**«Ganado en penales» cambió de columna** y ahora va debajo del rival, no suelto
al otro lado. Se lee pegado al partido que aclara.

### No cuesta un píxel

La caja de EL CAMINO mide **261px** antes y después: la aclaración de penales ya
ocupaba su propio renglón, sólo que del otro lado. Y sacar un botón de la fila no
cambia el alto, porque los dos compartían renglón.

| pantalla | v193 | v194 |
|---|---|---|
| 390 x 844 | 350 x 759 | 350 x 759 |
| 1280 x 840 | 520 x 748 | 520 x 748 |
| 320 x 568 | 304 x 530 | 304 x 530 |
| 844 x 390 | 520 x 362 | 520 x 362 |

Debajo de 700px de alto el camino no es una lista sino cinco chapas en fila, y
ahí la grilla no corre: el bloque de `max-height:700px` la reemplaza por un flex.
Verificado a 390x690 y a 844x390: las cinco chapas intactas, con el PEN abreviado.

### El texto que se comparte: un bullet por partido

Cada partido arrancaba con **dos espacios**. En WhatsApp la sangría se ve pero no
separa, así que los cinco renglones se leían como un bloque. Ahora arrancan con
**•** y cada partido es un ítem. El mensaje no se alarga ni un carácter.

Cambia en los dos lados: las copas ganadas y el ÚLTIMO INTENTO del que cayó.

### Algo que encontré y no toqué

Cuando compartís sin haber ganado ninguna copa, el mensaje sale con **dos
renglones en blanco seguidos**: el `L.push('')` que precede a la línea de copas se
empuja igual aunque esa línea no exista. Es una línea de código y no lo toqué
porque no era parte del pedido.

### Verificado

Las dos pantallas finales en 320x568, 390x690, 390x844, 844x390 y 1280x840.
CAMPEÓN con un botón de 155px centrado, ELIMINADO con los dos de 155 y 153. Los
nombres de las rondas alineados en la misma x en las dos. Los textos compartidos
—el de campeón y el de eliminado— leídos de `textoCompartir` corriendo, no
escritos a mano. Sin errores de consola.

## v195 · la carta trabada estaba borrada, no tapada

De las tres salió **la B**. OFFSIDE queda como estaba.

### Lo que había, medido

La ilustración de una carta trabada terminaba al **7,8% de opacidad** —el 26%
de la caja por el 30% de la imagen— con `grayscale(.7)` y **sin desenfoque**.

O sea que el pedido —«blureemos más»— no se podía cumplir tal cual: no había
blur que aumentar, y **desenfocar algo que ya no se ve no se nota**. Eso se
probó y está en las maquetas: con 2,5px encima del 7,8% la carta es la misma.

### Lo que hay ahora

La imagen **vuelve** —25,5% efectivo— pero sin color y fuera de foco. La carta
pasa de «borrada» a «tapada»: se ve que hay una jugada ahí abajo y que no se
puede mirar, que es exactamente lo que significa estar trabada.

| | opacidad de la foto | desenfoque |
|---|---|---|
| antes | 7,8% | — |
| ahora | **25,5%** | **4px** (1,6 en mobile) |

### Las cartas vuelven a distinguirse entre ellas

Efecto lateral que no buscaba y que quedó: sin foto, una **ROJA** trabada y una
**JUGADA CLARA** trabada eran el mismo rectángulo rayado. Con la imagen de
vuelta, aunque esté borrosa, cada una tiene su mancha.

### El texto no se toca

Una trabada tiene que poder leerse: hay que saber que es un PENAL para decidir
si vale gastar el VAR en destrabarla. Se desenfoca la foto, nunca el nombre ni
el cartel. El nombre sigue al 26% y el cartel al 50%.

### El desenfoque se mide en píxeles y la carta no

Esto apareció probando en el teléfono y casi arruina el cambio. **4px son el 2%
de una carta de escritorio, que mide 185, y el 5% de una de teléfono, que mide
80.** Sin ajustar, en mobile la imagen se volvía una mancha gris lisa y
volvíamos al rectángulo de antes, con el agravante de que ahora pesaba más.

Debajo de 440 el desenfoque baja a **1,6px**, que es el mismo 2%. El corte es el
que el juego ya usa para el canto de las cartas.

### Una regresión que me hice y arreglé

Con el **VAR apuntando**, las trabadas se marcan `.destrabable` y el cartel del
ítem promete que «se ven vivas otra vez». Esa clase le sube la caja al 90%: con
la foto al 7,8% eso daba 27% y no molestaba, pero con la foto al 25,5% pasaba a
**76% de gris borroso** —o sea peor que trabada, un manchón— justo en el momento
en que la carta tiene que verse bien.

Ahora con el VAR apuntando **la carta vuelve en foco y con color**: 67,5% y
`grayscale(.15)`, sin blur. Es la que estás por destrabar, así que se muestra
como va a quedar.

La regla va con `.lock.destrabable` y no con `.destrabable` sola para ganarle por
especificidad a las dos de arriba sin depender del orden de la hoja.

### Verificado

Cuatro trabadas distintas —DELANTERO con duelo, PENAL, ROJA y JUGADA CLARA— en
escritorio y a 390 de ancho. El desenfoque cambia solo en el corte de 440: 4px
arriba, 1,6 abajo. El estado con el VAR apuntando, en foco. El texto de las
cuatro, legible. Sin errores de consola.

## v196 · la chapa del mini juego se apoya sobre la foto

De las tres salió **la A**, más dos pedidos de tamaño para escritorio.

### El problema, medido

En las cuatro cartas de mano a mano el cartel de abajo gastaba **tres
renglones** —la chapa MINI JUEGO, el nombre del mini juego y el efecto— y la
ilustración, que es `flex:1`, se quedaba con lo que sobrara. Sobraba poco.

En un teléfono de 390 la foto de una carta de mini juego medía **40px de alto**
contra los **60 a 78** de una carta normal. El ARQUERO, que tiene dos líneas de
efecto, quedaba en 31.

### Lo que se hizo

La chapa sale del flujo y se apoya sobre el borde de abajo de la foto. Va
anclada al borde de arriba del cartel, así que **no hay ningún número mágico**:
se acomoda sola en cada pantalla.

| | foto antes | foto ahora |
|---|---|---|
| escritorio · carta 185 | 111px | **133px** |
| teléfono · carta 80 | 40px | **61px** |

En el teléfono la carta de mini juego pasa a tener **la misma foto que una**
**carta normal**, que es de lo que se trataba.

La del pop-up (`.p-out`) y la de la lista de posibilidad de gol (`.fg-art`) no se
tocan: cada una tiene su propia regla y ahí no falta lugar. Verificado montando
las dos.

### El escudo se fue arriba, y en todos los tamaños

Con la chapa apoyada abajo y al medio, el escudo del rival —que vivía abajo a la
derecha de la foto— pasó a pelear el mismo renglón.

El pedido era moverlo **en mobile**, donde en 80px directamente no entraban.
Pero medido en escritorio, con el escudo ya agrandado a 33px, **se pisaban 2px**.
Si se cruzan en 80 y en 185, no hay ancho donde convenga dejarlo abajo: la regla
va para todos los tamaños. **Si lo querés abajo en escritorio, se vuelve a
poner y se corre la chapa a la izquierda —una línea—.**

### Escritorio: el escudo y el número del duelo

Los dos eran de teléfono. El escudo tocaba su techo en **22px** y el número iba
en **20px fijos**, sin escalar con nada: en una carta de 185 eran dos detalles
que había que buscar.

| | antes | ahora |
|---|---|---|
| escudo | 22px | **33px** |
| número del duelo | 20px · caja de 28 | **26px · caja de 36** |

Sólo en escritorio, con la misma consulta que ya usa el resto de la mesa. En el
teléfono los dos ya ocupan lo que tienen que ocupar.

### El tope del escudo estaba escrito donde no servía

El `max-height:calc(100% - 4px)` vivía en el `svg`, que es hijo de un flex de alto
automático: ahí el porcentaje no resuelve contra nada y la regla era letra
muerta. Ahora el tope va en `.c-esc`, que está en absoluto y sí resuelve contra
`.c-ico`. Con el escudo 50% más grande esto dejó de ser teórico.

### Y se fue otro emoji

La chapa decía **🎮 MINI JUEGO** con un emoji del teclado, o sea que lo dibujaba
el sistema operativo y se veía distinto en cada máquina. Ahora lleva el mismo
dibujo de dos jugadores que el menú usa para el 1 vs 1, que además dice lo que
la carta propone. Se mide en `em`, así que sigue colgando del `font-size` que
cada breakpoint ya le daba al emoji: no hubo un solo tamaño que reajustar.

### Verificado

320x568, 390x844, 844x390 y 1280x840. La chapa entera adentro de la carta y sin
pisarse con el escudo en ninguna. En 320 los dos siguen apagados por los
escalones de alto de v186, como antes. El cartel del pop-up y el de la lista de
posibilidad de gol, intactos. Sin errores de consola.

## v197 · la foto es la ficha, en los dos carteles del sorteo

De las cuatro salió **la A**, con los botones apilados y el cartel del rival
igualado.

### El problema, medido

Cada ficha del sorteo era una cajita con **tres cosas apiladas** —foto, nombre
y porcentaje— y la foto se quedaba con el 40% de su propio alto. En un teléfono
de 390: ficha de **51x84**, foto de **41x34**.

El límite duro es el ancho: cinco columnas en 350px dan 51px por ficha, y eso no
se toca sin romper la fila de cinco. Así que lo que se buscó fue el alto.

### Lo que se hizo

La foto ocupa la ficha entera y el nombre y el porcentaje se apoyan encima,
sobre el degradado que la foto ya tenía. **La ficha mide exactamente lo mismo.**

| | foto antes | foto ahora |
|---|---|---|
| teléfono · 390x844 | 41 x 34 | **49 x 82** |
| escritorio · 1280x840 | 57 x 59 | **89 x 110** |

En una pantalla baja la ficha cede como cede todo lo demás: a 390x660 queda en
62 de alto en vez de 84, y la foto en **60 x 62**.

El alto lo fija ahora `min-height` en la ficha y no un `clamp` contra `vh` en la
imagen: la imagen se estira al 100% de lo que le den. Las dos consultas que le
daban su propia altura se fueron porque quedaban en letra muerta.

### Los botones, uno debajo del otro

Iban en fila y eran los únicos así en todo el juego. Ahora van apilados: el que
hace algo arriba, el que se va abajo. **El cartel sube 53px** en el teléfono —de
437 a 490— que es lo que cuesta poner un botón debajo del otro.

### El cartel del rival, igualado

AGUANTE AGOTADO y POSIBILIDAD DE GOL comparten `.sorteo` y se separan sólo en el
color, pero el botón se había quedado atrás: del lado tuyo USAR LA RACHA es
verde lleno desde v188 y del lado del rival seguía siendo **un contorno rojo**
sobre fondo oscuro, el último contorneado de los dos carteles.

Ahora el botón del rival entra en la misma caja `.sit-botones` —que es la que los
apila y les da su medida— y se rellena con su rojo. Mismo molde, mismo peso,
cada uno con su color. Ahí va uno solo: de ese cartel no se sale.

### Una trampa de orden que me comí

Al mover la chapa del MINI JUEGO al borde de arriba de la foto puse la regla
junto al resto del cambio, **antes** de la regla base que la ancla abajo. Misma
especificidad, así que ganaba la de abajo: la chapa quedaba con `top` **y**
`bottom` puestos y se estiraba a los 76px de la ficha. La casilla del PENAL se
veía como **un bloque dorado macizo**, sin foto.

El arreglo no fue agregar otra regla sino corregir la de siempre: la chapa se
ancla arriba en su propia declaración, y la consulta de escritorio también.

### Verificado

390x844, 390x660, 844x390 y 1280x840, los dos carteles. El cartel entra en
pantalla en las cuatro y no rueda por dentro salvo en apaisado, donde ya rodaba
antes del cambio —medido contra v196: la caja mide 460x340 en las dos—.

El sorteo corrido de punta a punta: el cursor pasa por las cinco, cuatro se
apagan y la que gana se levanta con su anillo. La chapa del MINI JUEGO en su
esquina, con la foto detrás.

## v198 · los números de ataque y defensa toman la curva de la chapita

De las tres salió **la A**: sólo el radio.

### El mismo borde, dos formas

Los tres números del juego —el del panel PLANTEL, el del renglón del valor del
cartel de la jugada y el de la carta— llevan **el mismo borde de 2px** en el
color del eje: rojo para ataque, azul para defensa.

Pero la chapita de la carta tenía **7px de radio** y los otros dos iban con
esquinas rectas. Mismo borde, dos formas.

Ahora los tres van redondeados: **5px, y 7 en escritorio**, que es exactamente
lo que usa `.cell .c-val` desde v196.

### Sólo el radio, no el fondo

La chapita de la carta lleva además un fondo teñido al 10%. Eso se queda en la
carta: en el panel los dos números están **uno arriba del otro** y dos rellenos
de color pesan ahí más de lo que pesa uno solo en una carta.

### Una regla, dos lugares

El renglón del valor del cartel de la jugada **reusa a propósito las clases del
panel** —`.stat` y `.stat-txt`— desde v185, con el comentario escrito al lado:
«si el panel cambia el cartel lo sigue solo». Así fue: se tocó una regla y se
arreglaron los dos.

### No se movió un píxel

| | caja del panel | radio |
|---|---|---|
| 390 x 844 | 31 x 21 | 0 → **5px** |
| 844 x 390 | 30 x 37 | 0 → **7px** |
| 1280 x 840 | 30 x 37 | 0 → **7px** |

El número del cartel de la jugada, igual: 26x29 antes y después, con 7px.

### Lo que no entra acá

En el **duelo 1v1** los stats de cada jugador (`.jp-st`) se muestran sin recuadro,
como texto suelto con el número en color. No es la misma pieza y no se tocó.

### Verificado

390x844, 844x390 y 1280x840. Los tres números redondeados y del mismo tamaño que
antes en las tres. Sin errores de consola.

## v199 · los stats del duelo también llevan el recuadro

Eran los últimos números de ataque y defensa sin caja: texto suelto en color al
lado de su palabra, mientras el panel del campeonato y la carta los muestran
metidos en un recuadro con borde. Ahora llevan el mismo: **borde de 2px en el**
**color del eje y 5px de radio**.

El alineado pasa de `baseline` a `center`: con la caja puesta, la palabra se colgaba
del renglón de base del número y quedaba alta.

### El renglón tenía tres piezas, no dos

Ahí estaba el problema. Además de los dos stats, en esa fila vive **la plata**.
Con el recuadro los stats pasaron de 53 a 68px y las tres dejaron de entrar: la
columna del rival tiene 164px de ancho útil y piden 169.

Y el resultado era peor que quedarse corto: la plata caía a un segundo renglón
**en un panel sí y en el otro no**, según cuántos dígitos tuviera. Dos paneles
que son la misma pieza, viéndose distintos.

**Apretar no alcanzaba.** Probado en el juego: con la etiqueta en 8px y el
espaciado en 0,4 las tres piezas todavía piden 166 de 164, y a esa altura el
texto ya no se lee.

Así que la plata baja **siempre**, a su propio renglón y alineada a la derecha.
Los dos paneles quedan idénticos. Cuesta **33px de alto** por panel.

### Y una consecuencia que no se veía venir

En mobile las dos columnas de la mesa son `minmax(0,1fr) auto`: la derecha pide
lo suyo y la izquierda se queda con el resto. En el campeonato eso es justo lo
que se quiere —la derecha es el PLANTEL— pero **en el duelo las dos llevan un
panel de jugador**, y al cambiar cuánto mide el contenido la repartición se fue
al diablo: medido, **155 contra 219**, y el panel angosto partía sus dos stats
en dos renglones.

El arreglo va acotado al duelo con `:has()`:

    .cancha:has(#jugL .jp){grid-template-columns:1fr 1fr}

Con eso los dos paneles miden **187** en un teléfono de 390 y el campeonato
sigue con su `auto` de siempre. Verificado que la consulta no lo toca: en
campeonato las columnas siguen dando 300 y 73.

### Los tamaños

| | panel antes | panel ahora |
|---|---|---|
| 1280x840 · tuyo | 210 x 195 | 210 x 228 |
| 1280x840 · rival | 190 x 181 | 190 x 214 |
| 390x844 | 186 y 188 | **187 y 187** |

### Lo que cede en 320

A 320 de ancho el panel queda en 152 y los dos stats **ya no entran en la misma**
**línea**: se apilan, uno arriba del otro. Antes entraban. Los dos paneles hacen
lo mismo, así que se lee como una decisión y no como un error, y es el tamaño
más apretado que el juego soporta. Forzarlos a una línea ahí pedía bajar la
etiqueta a 7,5px.

### Verificado

320x568, 390x844 y 1280x840, los dos paneles y los dos modos. Sin desborde
lateral en ninguna. El campeonato, intacto. Sin errores de consola.

## v200 · la cinta del refuerzo dice qué partido viene

De las tres salió **la B**.

### La instancia ya estaba, pero escondida

La cinta decía el nombre del club grande y, en gris abajo, «te espera en
CUARTOS». O sea que la ronda **ya se nombraba** —el dato estaba— pero en el
cuerpo más chico y el color más apagado del cartel, y en ningún lado decía que
eso era **el próximo partido**.

### Lo que hay ahora

Arriba va el rótulo **PRÓXIMO PARTIDO** y la ronda se pega al nombre del club en
una **chapa dorada**: la misma pieza que el MINI JUEGO usa en la mesa.

El club no pierde el renglón grande, y eso fue a propósito: el refuerzo **se
elige contra alguien**. Las otras dos propuestas lo bajaban a 10px o lo dejaban
compitiendo con la ronda, y ninguna de las dos ayudaba a decidir.

### No cuesta nada

| | tarjeta | cinta |
|---|---|---|
| 320 x 568 | 304 x 384 | 302 x 63 |
| 390 x 844 | 350 x 448 | 348 x 66 |
| 1280 x 840 | 520 x 575 | 518 x 66 |

Las mismas medidas que antes del cambio: el rótulo entra en el aire que la línea
gris ya ocupaba.

### Dos detalles del CSS que hubo que escribir

**El corte con puntos suspensivos se mudó del `b` al nombre.** El `b` pasó a ser
una fila con dos piezas, así que el que tiene que ceder es el club y no la
chapa. Probado con el nombre más largo de la tabla —CENTRAL CÓRDOBA— y entra sin
cortarse **hasta en una pantalla de 320**.

**Y el selector va con la clase repetida** —`.rf-prox .px-tx .px-nm`—: el
nombre del club es un `span` adentro de `.px-tx`, y la regla del renglón chico de
abajo le ganaba por especificidad y lo dejaba en 10,5px y gris. Lo mismo con el
rótulo.

### La ronda sin escudo sigue andando

Cuando la ronda no tiene equipo sorteado —el 1v1, los penales sueltos— la
cabecera se arma sin escudo en vez de romperse. Verificado llamándola con una
ronda sin `eq`: sale el rótulo, el club y la chapa, sin escudo y sin error.

### Verificado

320x568, 390x844 y 1280x840. La tarjeta entra en pantalla en las tres y no rueda
por dentro. Cuatro nombres de club, ninguno cortado. Sin errores de consola.

## v201 · el valor sobre la foto del pop-up, y el VS entre los dos números

Dos cosas que venían de la misma charla: primero el número, después el tamaño.

### El pop-up no decía el valor donde la carta lo dice

La carta de la mesa lleva su valor en una chapita arriba a la derecha. El
pop-up que se abre al tocarla no lo llevaba: el valor aparecía recién abajo, en
el renglón que lo compara con el tuyo. Sobre la foto había **un solo dato**, el
escudo del rival.

Ahora la chapita está también sobre la ilustración, con el mismo molde: borde de
2px en el color del eje —rojo si la carta se pelea con tu ataque, azul si se
pelea con tu defensa— y la misma esquina.

### El vidrio, porque atrás hay una foto

En la carta el fondo teñido al 10% alcanza, porque atrás hay una carta oscura.
Acá atrás hay una foto, y contra un cielo claro la chapita casi no se despega.
Así que lleva **el mismo vidrio esmerilado que el escudo**: fondo azul al 50%,
`blur(5px) saturate(1.3)` y la misma sombra.

Lo único que no copia del escudo es su filo blanco al 34%: la chapita conserva el
borde de color, que es lo que la ata a la carta que acabás de tocar.

### El tamaño: emparejada con el escudo

De las tres salió **la B**. El dato que definió el problema es que **el escudo no
tiene escalón de escritorio**: mide 40 x 44 en todos los anchos. La chapita sí lo
tenía, así que para emparejarlos había que sacárselo.

| | celular | escritorio | vs. escudo |
|---|---|---|---|
| Escudo | 40 x 44 | 40 x 44 | — |
| Antes | 27 x 28 | 36 x 36 | 16 y 8 más baja |
| Ahora | 40 x 44 | 40 x 44 | igual |

Son 34px de cuerpo más 3 de aire, que dan los 44 justos. El radio quedó en **8 y
no en los 10 del escudo**: 8 es la proporción que la chapita tiene en la carta —5
sobre 28, 7 sobre 36—, así que sigue leyendo como la chapita de la carta, sólo
que del tamaño del escudo.

**El ancho va por `min-width` y no fijo.** Con un dígito da los 40 justos, y si el
valor pasa de 9 la chapita crece en vez de recortarlo. No es hipotético: el valor
sale de 2–5 más la mitad de tu ataque, así que en una partida larga llega.
Probado con un 12: sale 50 x 44, misma altura.

### El VS

El renglón de abajo tenía los dos números uno al lado del otro, que se lee como
una lista de dos datos. Ahora va un **VS** en el medio, en la tipografía de
título y en dorado: es el color que el juego usa para lo que está en juego, y no
se pisa con el rojo ni el azul de los ejes.

No aprieta nada. El renglón reparte el aire que ya le sobraba: los dos recuadros
siguen midiendo 84 y 87, y el conjunto sigue centrado.

### No cuesta nada

| | pop-up | ilustración | chapita | escudo |
|---|---|---|---|---|
| 390 x 780 | 350 x 468 | 296 x 192 | 40 x 44 | 40 x 44 |
| 844 x 390 | 430 x 340 | 349 x 192 | 40 x 44 | 40 x 44 |
| 1280 x 860 | 563 x 553 | 497 x 208 | 40 x 44 | 40 x 44 |

Las mismas medidas de pop-up que antes del cambio: la chapita va en absoluto
sobre la foto y no empuja nada.

### Las cartas que no son de duelo no cambian

Las 25 cartas sin eje —jugada, penal, offside, lesión, los mini juegos— no tienen
renglón de valor, así que no llevan ni chapita ni VS. Verificado abriendo una: no
aparece ninguna de las dos.

### Verificado

390x780, 844x390 y 1280x860, en los dos ejes y con valores de un dígito y de dos.
La chapita entra siempre dentro de la ilustración. Sin errores de consola.

## v202 · la chapa de MINI JUEGO entra en un renglón y baja el tono

De las tres salió **la B**.

### Por qué se partía

La chapa pedía **72px** para entrar en una línea y la foto de la carta mide **68**
en un teléfono de 390. Le faltaban 4, así que se partía en MINI / JUEGO. Por eso
en escritorio no se veía nunca: ahí la foto mide 236.

Partida no le robaba alto a la foto —la chapa flota sobre la ilustración desde
v196, no está en el flujo— pero pasaba de **13 a 19px de alto**, o sea que tapaba
6px más de foto. Y sobre todo se leía como algo roto.

### `nowrap` sola no alcanzaba

Con `white-space:nowrap` la chapa dejaba de partirse pero se salía de la carta.
El encaje lo terminan dos escalones:

| | 360 x 800 | 390 x 844 | Escritorio |
|---|---|---|---|
| Foto de la carta | 61 | 68 | 236 |
| Antes | 52 · **2 líneas** | 52 · **2 líneas** | 114 |
| Ahora | 49 | 66 | 116 |

En mobile la letra baja de 7,2 a 6,8, el espaciado de 0,8 a 0,2 y el ícono de 9,5
a 8. Y en **360 o menos** —la medida de media Android— la foto baja a 61, así que
hay otro escalón donde la letra va a 6,2 y **el ícono se va**. Eso no es nuevo: es
lo mismo que el juego ya hace con las casillas chicas del pop-up de posibilidad de
gol, donde el dibujo de dos jugadores tampoco entra. El rótulo, que es lo que
avisa, se queda siempre.

### Y deja de ser un bloque dorado

Llena era **la única mancha de color maciza sobre una foto**, repetida en cada
carta de mano a mano: lo más ruidoso de la mesa. Ahora lleva el mismo vidrio
esmerilado que el escudo del rival y la chapita del valor del pop-up —fondo azul
al 50% y `blur(5px) saturate(1.3)`— con el dorado reducido a **un filo de 1px y al
texto**.

Sigue avisando que en esa carta hay que elegir algo, un tono más abajo. Es la
misma idea que los botones `n-linea`: contorno en vez de relleno.

### El pop-up no se toca

La chapa del cartel de la jugada (`.p-out .mj-lb`) sigue llena y dorada, porque
ahí no compite con quince cartas al lado. Verificado abriendo un mano a mano: sale
en `rgb(245,200,66)` con texto negro, sin filo y sin `nowrap`, igual que antes. Y
las casillas del pop-up de posibilidad de gol (`.fg-art .mj-lb`) tampoco, porque
el selector nuevo es `.cell .c-out .mj-lb`.

### Verificado

En el juego andando a 360x800, 390x844 y 1280x860. Una línea en los tres, y la
chapa siempre más angosta que la foto: 49 de 61, 66 de 70 y 116 de 165. Sin
errores de consola.

## v203 · el mini juego muestra el choque con el mismo renglón que la carta

De las tres salió **la A**: no una parecida, la misma.

### Eran dos piezas distintas para el mismo dato

El pop-up de mini juego tenía su propio renglón (`.p-emp`) y no se parecía en
nada al del pop-up de carta: números pelados sin recuadro, el del rival **en
blanco** en vez del color del eje, un `vs` minúsculo de 9px en gris, y un `⚔` /
`🛡` que dibujaba el sistema operativo.

Ahora arma el renglón con **la misma función** que el cartel de la jugada,
`filaValor`, así que los dos números van en su recuadro del color del eje y el VS
dorado va en el medio.

### Lo que de verdad unifica es el selector

Las reglas del renglón colgaban de `.play`, o sea del cartel de la jugada, así
que el mini juego **no podía heredarlas aunque quisiera**: tenía que copiarlas, y
copiadas se separaron. Ahora cuelgan de `.p-val` a secas. La clase es única en
todo el juego, así que cualquier pop-up que arme este renglón hereda el mismo.

**Un efecto que salió gratis:** el escalón de escritorio también estaba atado a
`.play`. Al soltarlo, el pop-up de mini juego pasa a tener en escritorio los
números de 34px y el VS de 28 que hasta ahora eran sólo del cartel de la jugada.

### El `:last-child` no es adorno

`.p-val .stat` empata en especificidad con `.stat:last-child` —la regla que le
devuelve el relleno de abajo a la última fila del panel— y está más arriba en la
hoja. Con el `.play` adelante el selector pesaba más y ganaba; sin él, pierde.

Probado aparte antes de escribirlo: con `.p-val .stat` solo, el segundo recuadro
del renglón sale **1px más alto que el primero** (19 contra 18 en la prueba). Por
eso la regla nombra el `:last-child` explícitamente. Verificado en el juego: los
dos recuadros del renglón quedan en `padding-bottom:0`, y los del panel siguen en
2px, que es lo suyo.

### Los dos números son siempre iguales

El mini juego se abre justo cuando empatan, así que los dos recuadros quedan del
mismo color. Es lo correcto: se miden en el mismo eje.

### No cuesta nada, al contrario

| | pop-up | renglón | número |
|---|---|---|---|
| Antes | 350 x 487 | 298 x 39 | 12 x 39 |
| Ahora | 350 x 477 | 298 x 35 | 31 x 35 |
| Ahora, escritorio | 538 x 686 | 462 x 40 | 36 x 40 |

El cartel sale **10px más bajo** que antes. Y el del cartel de la jugada no se
movió: sigue en 350 x 468 con el renglón en 296 x 35.

### Y se va CSS que quedó sin dueño

`.p-emp` y sus cuatro hijos estaban declarados **tres veces en la hoja base más
una en escritorio**, pisándose entre sí: el bloque de arriba estaba muerto entero,
el de PENAL DEFINITORIO le ganaba el cuerpo del número al de abajo, y el escalón
de escritorio no llegaba a aplicar nunca por especificidad. Ahora que ningún
marcado los usa, se fueron los cuatro. El archivo queda 401 bytes más chico.

### Verificado

Los cuatro mini juegos —MANO A MANO, 1 vs 1, LA MARCA, DEFENDER— en 390x844 y
1280x860. Cada uno con su eje: rojo el del arquero y el defensor, azul el del
medio y el delantero. El panel de stats y el cartel de la jugada, sin cambios.
Sin errores de consola.

### Queda anotado

El título del mini juego del DEFENSOR se llama **1 vs 1**, y va justo debajo del
renglón. Con el VS dorado arriba quedan dos «vs» dorados apilados, uno en
mayúscula y otro en minúscula. En los otros tres no pasa. Se arregla renombrando
esa carta a UNO CONTRA UNO, pero no se tocó acá.

## v204 · las cinco del sorteo, en tres y dos, y el cursor del color del cartel

Dos cosas del mismo cartel: el layout salió **la C** y el cursor **la B**. Vale
para los dos —el tuyo y el del rival—, que comparten `.sit.sorteo`.

### Las fotos no se veían chicas por tamaño: por forma

El dibujo mide **248 x 164** —apaisado— y la casilla era un rectángulo parado de
51 x 84. Con `object-fit:cover` la imagen se agranda hasta llenar el alto y **lo
que sobra de ancho se recorta**: se veía el **40%** del dibujo.

Eso cambia el problema. Estirar para abajo, que era lo primero que uno prueba,
**agranda la figura pero muestra menos foto**: la casilla se hace todavía más
angosta de forma. Medido, a 124 de alto queda el 27% y a 164 el 20%. La única
manera de ver más es **ensanchar la casilla**, y para eso hay que salir de la
fila de cinco.

| | 320 x 568 | 360 x 800 | 390 x 844 | Acostado | Escritorio |
|---|---|---|---|---|---|
| Antes | 45 x 64 · 46% | 45 x 84 · 35% | 51 x 84 · 40% | 67 x 112 · 39% | 91 x 112 · 53% |
| Ahora | igual | 78 x 88 · 58% | 88 x 88 · 66% | igual | 154 x 112 · 91% |

El porcentaje es cuánto del dibujo original se ve sin recortar.

Lo que cuesta es la lectura de «una de las cinco»: en dos filas ya no se leen
como cinco puertas iguales. Es el precio y va a ojos abiertos.

### Dos vueltas atrás donde no hay alto

En **pantallas bajas** —un teléfono chico de pie— no hay lugar para dos filas, y
**acostado** el cartel ya rodaba por dentro antes de este cambio. En los dos
casos vuelve a la fila de cinco con la medida de siempre, así que ahí queda
exactamente igual que antes. Verificado: 320x568 sale en una fila de 48 x 64 y
844x390 en una de 67 x 112, los mismos de v203.

El escalón grande también se acotó: era `min-width:1025px` **o** `821px` en
apaisado, que es la misma consulta que usa un teléfono acostado. Ahora ese brazo
pide además `min-height:561px`, así que una tablet acostada lo toma y un teléfono
acostado no.

### El cursor toma el color del cartel

Mientras el sorteo gira, el aro deja de ser blanco: **verde si la llegada es
tuya, rojo si es del rival**. El sorteo empieza a decir de quién es desde la
primera vuelta, en vez de decirlo recién en la casilla que gana.

Es lo único de la ficha que cambia entre un cartel y el otro, y a propósito: el
layout, los tiempos y el salto son una sola regla para los dos.

### Y hubo que mudarlo de lugar

La primera versión del cursor no funcionaba sobre dos de las cinco casillas. Las
dos marcas que existen del lado tuyo —`.fg-mini.mj`, el filo dorado del MINI
JUEGO, y `.fg-mini.seguro`, el verde claro de la que entra siempre— **empatan en
especificidad** con el cursor y están más abajo en la hoja, así que le ganaban: el
aro se quedaba del color de la marca.

Con el aro blanco pasaba lo mismo y no se notaba, porque el dorado del MINI JUEGO
no desentona con un cursor blanco. Con el aro de color sí se nota, y es justo la
casilla que más se mira. Se arregla poniendo el bloque del cursor **después** de
las marcas, no subiéndole la especificidad.

Verificado casilla por casilla, con las transiciones apagadas para leer el valor
de destino y no el del camino: las cinco toman `rgb(61,220,107)` del lado tuyo y
`rgb(255,59,82)` del lado del rival, **incluidas la del mini juego y la segura**.

### Verificado

Los dos carteles en 320x568, 360x800, 390x844, 844x390 y 1280x860. Ninguno rueda
por dentro salvo el acostado, que ya rodaba. El tuyo queda en 350 x 588 con 178
de aire de sobra y el del rival en 350 x 558 con 208. Sin errores de consola.

## v205 · el reflejo de los ítems, en los dos botones que arrancan el campeonato

De las tres salió **la B**. CAMPEONATO en la pantalla principal y EMPEZAR LA COPA
al elegir club son los dos botones rellenos que empiezan todo, y no se movía nada
en ellos. Ahora llevan la misma caja `.i-brillo` que los ítems, con el mismo
degradado.

### El reloj no se podía reusar tal cual

| | ancho | ciclo | barrido | velocidad |
|---|---|---|---|---|
| Ítem | 73 | 2,2s | 440ms | ~390 px/s |
| CAMPEONATO | 354 | 2,2s | 440ms | ~1.700 px/s |
| EMPEZAR LA COPA | 350 | 2,2s | 440ms | ~1.680 px/s |

Con el ciclo de los ítems el reflejo cruza **casi cinco veces más distancia en el
mismo tiempo**, y a esa velocidad deja de leerse como luz y pasa a ser un
parpadeo. Así que el ciclo sube a **3,6s**, el barrido se lleva el 26% en vez del
20% y la banda se ensancha, para que sea un reflejo y no una raya.

Es la misma pieza con otro reloj, no otra pieza: la trampa era reusar un número
sin mirar sobre qué cae.

### Dos trampas de especificidad, las dos medidas

**El reflejo se iba a toda la pantalla.** `.i-brillo` va en absoluto contra el
ancestro posicionado más cercano. `.mm-grande` ya era `position:relative`, pero
`.cta` no, así que el de EMPEZAR LA COPA se anclaba a la ventana: medido, **390 x
844 en vez de 350 x 48**. Se arregla con `.cta:has(.i-brillo){position:relative}`,
con `:has()` para que lo tome sólo el botón que lleva el reflejo y no los
cuarenta y pico de `.cta` del juego.

**El apagado por movimiento reducido no llegaba.** La regla que anima es
`.mm-grande .i-brillo::after` —(0,2,1)— y la que apaga es `.i-brillo::after`
—(0,1,1)—: una media query no suma especificidad, así que la que anima ganaba
igual y el reflejo seguía corriendo. Nombrar los dos botones adentro del bloque de
arriba tampoco alcanzaba, porque ahí las dos pesan (0,2,1) y entre iguales decide
el orden, y el bloque de arriba va antes.

Probado forzando la consulta —cambiando `prefers-reduced-motion:reduce` por una
que siempre da verdadera— seguía saliendo `btnBrillo 3.6s`. La solución es un
`@media` propio **después** de la regla que anima. Verificado con la misma prueba:
los tres reflejos —los ítems y los dos botones— quedan en `none 0s`, con el filo
quieto que ya tenían los ítems.

### Un efecto de yapa

`#startBtn` es el mismo botón para los tres modos, así que **JUGAR EL PARTIDO** y
**SEGUIR** también quedan con el reflejo. Es coherente: es el botón que empieza,
se llame como se llame.

### Verificado

En el juego andando a 390x844. El reflejo queda **adentro de cada botón**: 354 x
66 sobre el de 354 x 66, y 320 x 44 sobre el de 324 x 48 —ahí la caja mide la
parte de adentro del filo dorado de 2px, que queda limpio—. Los ítems siguen
exactamente como estaban: `itemBrillo 2.2s` y su degradado de siempre. Sin errores
de consola.

## v206 · el mercado: la plata arriba, la mochila aparte y menos colores

De los cinco layouts salió **la B**.

### Las tres cosas, medidas

**La plata era más chica que los precios.** El presupuesto era una de tres
columnas de la franja y medía **20px**, contra los 19 de cada precio —pero cuatro
precios contra un presupuesto—. Ahora ocupa el renglón entero a **46px** y
centrado, y el aguante y la racha se reparten el de abajo.

**Lo que tenés obligaba a leer los cuatro renglones.** La columna existía, pero
estaba pegada al precio y con la misma forma de chapa, así que competía con él.
Ahora sube a una tira propia arriba de la lista, con sólo los que llevás y su
número; cuando no tenés ninguno lo dice en una línea. Y como ya está dicho ahí,
los renglones se quedan sin la columna.

**Hablaban cinco colores a la vez:** dorado el rótulo y la chapa de tenés, verde
el presupuesto y los cuatro precios, rojo el que no alcanza, azul el DESTRABA del
VAR, amarillo la racha. Ahora el verde es **sólo la plata que tenés**, los precios
pasan a blanco y el rojo se guarda para el renglón que dice cuánto falta, que es
el dato.

### El entretiempo del 1v1 no se toca

Esa pantalla reusa `tiendaHTML()` y no tiene mochila, así que si la columna se
escondía en todos lados perdía el dato y no ganaba nada. Todo lo del layout va
scopeado a `.card-mercado`, una clase nueva que sólo lleva la tarjeta del
mercado. El precio en blanco sí es para las dos, porque es la misma lista.

Verificado sacándole la clase a la tarjeta en vivo: la plata vuelve a 20,28px y
la columna de «tenés» vuelve a `flex`, con el precio en blanco en los dos casos.

### Un guard para las pantallas anchas y bajas

Apilar la plata cuesta alto, y hay pantallas donde el alto es justo lo escaso. En
un **portátil de 1280 x 768** la tarjeta pasaba de 651 —que entraba— a **740, con
87px para rodar hasta el botón de jugar**: exactamente el problema que esta
pantalla ya había resuelto una vez.

Así que en `(min-width:821px) and (max-height:820px)` la franja vuelve a ser tres
columnas y la mochila pone el rótulo en la misma línea que las chapas. La plata
igual queda más grande que antes: **34px** contra los 22 de tope que tenía.

### Verificado

| | tarjeta | plata | hay que rodar |
|---|---|---|---|
| 320 x 568 | 530 | 46px | no |
| 360 x 740 | 679 | 46px | no |
| 390 x 844 | 695 | 46px | no |
| 1280 x 768 | 714 | 34px | no |
| 1280 x 860 | 827 | 46px | no |
| 844 x 390 | — | 34px | 228px |

El acostado ya rodaba antes de este cambio: eran 227px y ahora son 228, o sea que
queda como estaba. Probado también con la mochila vacía y con dos ítems. Sin
errores de consola.

### Lo que no se hizo

En la maqueta el rótulo MERCADO iba en gris. No se aplicó: `.card .tag` está
dorado a propósito y documentado —«es la que dice en qué parte del juego estás»—,
así que apagarlo sólo en esta pantalla rompía el sistema en vez de calmarlo. Si
se quiere, es una línea, pero habría que hacerlo en todas las tarjetas.

## v207 · el rótulo de las tarjetas pasa a gris, en las once

Quedó pendiente de v206 y se decidió mirándolo aparte: **todas en gris**.

### Qué es el rótulo

Cada tarjeta abre con dos líneas. Arriba, en 11px y muy espaciada, va el
**rótulo** —MERCADO, VESTUARIO, OPCIONES— que dice en qué parte del juego estás.
Abajo, grande, va el **título**, que dice qué hacés ahí. El rótulo lo pinta una
sola regla, `.card .tag`, y la usan **once tarjetas**.

### Por qué se apaga

El argumento del dorado era que el rótulo dice dónde estás. Sigue siendo cierto,
pero decirlo no es lo mismo que gritarlo: el dorado es el color que el juego usa
para **lo que está en juego** —la plata, la copa, el VS del duelo— y gastarlo en
un rótulo de 11px que sólo ubica le saca fuerza donde sí hace falta.

En gris queda en la misma familia que los otros rótulos chicos que tiene al lado
—PRESUPUESTO, LO QUE LLEVÁS, LLEGÁS CON—, que es lo que es.

### En la regla de siempre, no en una excepción

La maqueta del mercado lo pedía apagado sólo ahí. Puestas las seis cabeceras una
debajo de la otra se veía el costo: el mercado dejaba de pertenecer a la serie y
el rótulo pasaba a significar **dos cosas distintas según la pantalla**. Cuesta la
misma línea hacerlo bien, así que cambian las once juntas.

**Y coinciden con los pop-ups.** El rótulo de los carteles de jugada (`.sit-tag`)
ya era gris, porque ahí nombra la carta. Ahora los dos usan el mismo gris,
`--dim2`: verificado, los dos salen en `rgb(88,120,171)`.

### De paso, una declaración que mentía

`.card .tag` estaba declarada **dos veces** en la hoja base. De la primera sólo
llegaba el margen: el cuerpo, el espaciado y el color los volvía a decir la
segunda, que gana por orden. Se le sacó el `color:var(--gold)` para que no quede
diciendo dorado donde ya no lo es.

### Verificado

Cuatro tarjetas abiertas en el juego andando —MERCADO, OPCIONES, CRÉDITOS y EL
PARTIDO, que además lleva `card-reglas`—: las cuatro en `rgb(88,120,171)`, con el
título en blanco. Sin errores de consola.

## v208 · opciones: se van los últimos tres emoji de una pantalla entera

De las tres salió **la A**: la misma lista, con los íconos del juego y más aire.

### Lo que estaba mal, no mejorable

Los tres íconos eran emoji —🔊, 🖥 y ⚡— o sea que los dibujaba el sistema
operativo: la pantalla se veía distinta en cada máquina y no combinaba con el
resto del juego, que ya es todo SVG. Era de las últimas que quedaban así.

**Los tres reemplazos ya estaban en el sprite** y no hubo que dibujar nada:

| | era | ahora | de dónde sale |
|---|---|---|---|
| Volumen | 🔊 | `#i-gri` | el altavoz del GRITO DEL DT |
| Pantalla completa | 🖥 | `#i-var` | el monitor del VAR |
| Animaciones | ⚡ | `#i-rayo` | el rayo de la racha |

Van en `--dim`: son un dibujo que acompaña al nombre, no algo que haya que
mirar.

### Y el renglón respira

De 11 a 14 de alto, y el último se queda sin la línea de abajo, que no separaba
nada del botón. La chapa de PRÓXIMAMENTE se apaga un punto: está tres veces y no
es lo que hay que leer.

Se dejó escrita tres veces a propósito. La otra propuesta la subía a una sola
línea arriba, que dice lo mismo con menos ruido, pero **esta lista envejece
mejor**: cuando alguna de las tres empiece a funcionar, sólo cambia la chapa de
la derecha por un control y el resto sirve tal cual.

### Un guard para el teléfono acostado

Ahí la tarjeta entraba justo. Con los 14 de alto había que rodar **4px** para
llegar al botón —medido en 844x390—, así que en `(orientation:landscape) and
(max-height:560px)` los renglones se quedan con los 11 de siempre.

### Verificado

En el juego andando: 390x844 en 279 con los renglones de 47, 320x568 en 246,
1280x860 en 366 y 844x390 en 348, ninguno rodando por dentro. Los tres íconos
salen de `#i-gri`, `#i-var` y `#i-rayo`, y en la tarjeta **no queda un solo
emoji**. Sin errores de consola.

## v209 · las transiciones: un solo reloj y sin sobrepaso

Salió **la B más lo de la A**: son dos problemas distintos y no se pisan.

### Lo exagerado: el sobrepaso

Los carteles entraban desde el **72%** de su tamaño y pasaban por el **106**
antes de frenar: un salto del 34% con rebote. Y al cerrarse hacían lo contrario
de entrar —se agrandaban a 105 mientras se apagaban—, que se lee como un tirón.

Ahora arrancan en **96** y llegan a 100 sin pasarse, y la salida cierra hacia
adentro, a 99. Es la entrada al revés.

### Lo entrecortado: siete relojes

No era que algo fuera lento o rápido: era que **nada terminaba junto**.

| Pieza | Entraba | Ahora | Salía | Ahora |
|---|---|---|---|---|
| Pop-up de jugada | 420ms | 300 | 220ms | 180 |
| Pop-up de situación | 500ms | 300 | 220ms | 180 |
| Aviso | 450ms | 300 | 220ms | 180 |
| Cartel de gol | 420ms | 300 | 220ms | 180 |
| El velo | 260ms | 300 | 200ms | 300 |
| La mesa, atrás | 240ms | 300 | 240ms | 180 |
| Pantalla y tarjeta | 300ms | 300 | 300ms | 300 |
| Caja que se transforma | 300ms | 300 | — | — |

Dos números para todo el juego —**entrar 300, salir 180**— y dos curvas: una
que frena sin pasarse al entrar y otra que arranca suave y se va al salir.

### La mesa va y vuelve con relojes distintos, a propósito

La transición que manda es la del **estado al que se va**: yendo atrás manda
`.wrap.atras` y volviendo manda `.wrap`. Así la mesa se aleja con el reloj de
entrar y vuelve con el de salir, igual que el cartel que la tapa.

Y la vuelta tiene que terminar antes de que se saque el velo, 300ms después del
cierre, porque mientras la transición corre el `transform` sigue vivo y con él el
bloque contenedor de los `fixed`. Con 180 sobra. Verificado muestreando cada
45ms: a los 90 ya está `golsale 0.18s` en el cartel y `0.18s` en la mesa.

### Todo se editó en su lugar

Ni una regla nueva al final de la hoja. El bloque de `prefers-reduced-motion`
está **justo debajo** de `.wrap` y de `.pop-velo`, así que un override más abajo
le habría ganado —que es la trampa que apareció en v205—. Y como `.wrap.atras`
ahora trae su propia transición, el bloque de movimiento reducido tuvo que
apagarla también ahí: sola, `.wrap{transition:none}` ya no le llegaba.

### Lo que no se tocó

El levantado de la carta de la mesa —`.cell`, 200ms de `translate` y `rotate` con
la curva vieja— es otra cosa: no es una transición entre pantallas sino el gesto
de la carta que elegís, y ahí los 200ms con un toque de sobrepaso están bien.

### Los tamaños, intactos

Sólo cambiaron `transform`, `opacity` y tiempos. Medido en el juego andando a
390x844, contra los números anotados en las versiones donde se fijaron:

| | antes | ahora |
|---|---|---|
| Pop-up de carta | 350 x 468 (v201) | 350 x 468 |
| Mini juego | 350 x 477 (v203) | 350 x 477 |
| Sorteo | 350 x 588 (v204) | 350 x 588 |
| Opciones | 350 x 279 (v208) | 350 x 279 |

### Verificado

Pop-up abriendo y cerrando sobre la mesa, pantalla abriendo y cerrando, y las
cuatro medidas de arriba. Sin errores de consola.

## v210 · la mesa se va atrás también con las pantallas

De las tres salió **la A**, que además es la que no agrega una sola regla de CSS.

### El último paso era un corte

La tarjeta se desvanecía y **la mesa ya estaba ahí**, entera y quieta. No es que
llegara: es que se destapaba. Nada conectaba una pantalla con la otra.

Y el juego ya sabía hacerlo: cuando se abre un cartel, `.wrap` toma `.atras` y se
aleja un punto mientras lo que viene llega adelante, y vuelve sola al cerrarse.
Con las pantallas eso **no pasaba**. Son dos líneas, una en `openCard` y otra en
`closeCard`, y de paso carteles y pantallas pasan a comportarse igual.

### Hubo que enseñarle cuándo no volver

Desde que las pantallas también mandan la mesa atrás hay dos casos donde el
pedido de vuelta llega de más:

- un **cartel que se cierra sobre una pantalla** que sigue abierta,
- una **pantalla que se cierra para dejar paso a un cartel**.

Sin el guard la mesa hacía el viaje de ida y vuelta por nada y se veía un
tironcito debajo de lo que estaba adelante. El guard vive adentro de `mesaAtras`,
en un solo lugar: no vuelve si hay un cartel vivo o una pantalla abierta.

El cartel que **se está yendo** no cuenta, porque en ese momento `cerrarPop` ya le
puso `saliendo` y es justamente el que pide la vuelta.

Probado los cuatro casos a mano sobre el juego andando: con pantalla abierta se
queda atrás, con cartel vivo se queda atrás, con el cartel yéndose vuelve, y sin
nada adelante vuelve.

### Verificado

La corrida entera desde el menú: club `atras true`, cómo se juega `atras true`,
mercado `atras true`, y al llegar al tablero `atras false` con las 16 cartas
puestas y el overlay cerrado. Sin errores de consola.

Las medidas del alejado se leyeron **con las transiciones apagadas**, que es la
única forma de leer el valor de destino y no el del camino: `scale(.955)` y
`brightness(.72)` con la clase, nada sin ella.

### Queda pendiente

El tablero se rearma **mientras el velo todavía se está yendo** —`closeCard()` y
`startMatch()` corren uno detrás del otro, sin esperar— así que las cartas cambian
por detrás del fundido. Se ofreció junto con esto y no se aplicó: va aparte.

## v211 · el velo se hunde, y ahora es la única transición del juego

De las tres salió **la C**, y con ella el pedido de aplicarla también entre
pop-ups: unificar todas las transiciones del juego en un solo gesto.

### Por qué las otras dos rondas no servían

La primera tanda entraba de un costado y se descartó entera: *"no quiero que
aparezca de un costado, porque se ve cortado al cargar"*. Y tenía razón, pero el
motivo no era el costado. Era **qué estaba pasando mientras la pantalla viajaba**.

La pantalla que llegaba cruzaba un ancho entero en 260ms, y durante esos 260ms el
navegador todavía la estaba armando: imágenes, escudos, cronómetros. Lo que se
veía no era una pantalla entrando — era una pantalla **dibujándose mientras se
movía**. En la de cómo se juega, que mide 756 de alto, salta a la vista.

Moverla más despacio, o desde otro lado, no arregla nada: el trabajo sigue
cayendo arriba del movimiento.

### El gesto

Ahora **no viaja nada**. El fondo se hunde —tapa un poco más y desenfoca un poco
más—, el cambio pasa mientras no se lo está mirando, y el fondo vuelve. Son dos
medios tiempos de 150ms que suman los mismos 300 de entrar que fijó v209.

Por pesada que sea la pantalla que viene, **se arma a oscuras**.

| | antes | ahora |
|---|---|---|
| Pantalla a pantalla | clon que se desliza, 260ms | el velo se hunde, 150 + 150 |
| Cartel a cartel | la caja se estira y el viejo se disuelve | el velo se hunde, 150 + 150 |
| Los cinco desenlaces en el lugar | la caja se estira | **igual que antes** |

Se fueron `deslizarPantalla`, `dirPantalla`, `atras()` —nueve llamadas— y la regla
`.card-sale`. Entraron `cambiarAOscuras`, `.hundido`, `.apagada` y `.foto-vieja`.

### Lo que rompió el primer intento

El primer patch aplicó limpio, pasó todos los controles de estructura… y **en el
juego los botones del menú no hacían nada**. Se veían bien y no respondían.

La causa: para que el cambio no se viera, lo había puesto **adentro del
`setTimeout`**. Pero todos los que llaman a `openCard` y a `montarPop` enganchan
sus botones en el renglón siguiente:

    openCard(html, 'card-menu');
    $('oBack').onclick = () => showMenu();

Si el marcado nuevo todavía no está puesto, `$('oBack')` es `null` y el botón
queda sin dueño. No era un caso raro: rompía **todos** los llamadores.

La versión que quedó da vuelta el orden. **El cambio se aplica en el acto**, y lo
que se demora es una **foto** —un clon quieto de lo que había— colgada encima. Al
llegar el fondo a lo más oscuro, la foto se saca y abajo ya está lo nuevo, que
nunca se vio armarse.

### Y lo que rompió el segundo

Con la foto puesta, medido en el juego andando: la tarjeta nueva **no se apagaba**.

El apagado se ponía antes de aplicar el cambio, y tanto la pantalla como el cartel
eligen sus clases de cero —`card.className = 'card ' + extra`—, así que se lo
llevaban puesto. Va **después** de aplicar: entre una línea y la otra no hay
pintado, y lo nuevo nunca llega a verse encendido.

### Tres detalles que hubo que resolver

- **La foto cuelga del `body`, no del velo.** Adentro del velo sus clases
  contestarían a los `querySelector` de quien montó el cartel —`wrap.querySelector('.sit')`,
  `wrap.querySelector('#fgUsar')`— y **le robaría los botones al cartel de verdad**.
  Es el mismo pozo que ya tenía el clon que se deslizaba, que por eso iba sin
  `id`. Acá van los dos: sin `id` y fuera del velo.
- **El bloque contenedor de un `fixed` no siempre es la ventana.** Cualquier
  `filter` o `backdrop-filter` arriba lo cambia, y el overlay tiene
  `backdrop-filter` puesto. En vez de adivinar quién es, la foto se cuelga en 0,0
  y se mide dónde cayó: esa es la esquina de la que hay que partir, valga lo que
  valga. Medido con el overlay scrolleado 30px: la foto cae en 127,-10, clavada
  sobre la tarjeta que reemplaza.
- **Dos cambios encadenados en menos de 150ms.** El reloj del primero, al vencer,
  le sacaría el apagado a la que recién entra. El reloj se guarda en la caja y el
  siguiente lo cancela.

### `morfarPop` se queda

Lo usan los cinco carteles que **se resuelven en el lugar**: la moneda, los dos
penales, el mano a mano y la situación de gol. Ésos no son un cambio de cartel —
son el cartel que estás mirando mostrando lo que pasó. Apagarlos sería taparle al
jugador justo lo que fue a ver.

La distinción cae sola en el código: lo que pasa por `montarPop` es un cartel
nuevo y va a oscuras; lo que llama a `morfarPop` directo es un desenlace y se
queda a la vista.

### Sin movimiento

Con `prefers-reduced-motion` no hay hundido ni foto: se aplica y listo. Verificado
pisando `matchMedia`: cero fotos, cero `hundido`, y el botón enganchado igual.

### Verificado

Sobre el juego andando, no a ojo:

| | v210 | v211 |
|---|---|---|
| Menú 375x812 | 375 x 766 | 375 x 766 |
| Club 375x812 | 335 x 549 | 335 x 549 |
| Cómo se juega 375x812 | 335 x 736 | 335 x 736 |
| Menú 320x568 | 320 x 522 | 320 x 522 |
| Club 320x568 | 304 x 473 | 304 x 473 |
| Menú 1280x768 | 1280 x 722 | 1280 x 722 |
| Cómo se juega 1280x768 | 880 x 740 | 880 x 740 |
| Opciones 844x390 | 560 x 348 | 560 x 348 |
| Club 844x390 | 620 x 314 | 620 x 314 |

Sin scroll de más en ninguna, ni horizontal ni vertical. Las dos cadenas medidas
paso a paso: menú → opciones → club → cómo se juega → tablero, con los botones
enganchados en cada una; y carta → mini juego adentro del partido, con los dos
lados del arco respondiendo.

El desenlace en el lugar, medido en la moneda de la tanda de penales: la caja
crece de 336x282 a 350x294 con `pop-morfando` puesto y el fantasma apagándose,
**sin** `apagada`. Sigue siendo lo que era.

Los 458 contra 466 de scroll del tablero a 1280x768 no son una regresión: el
tablero se arma al azar y tres corridas seguidas de v211 dieron 458, 483 y 470.

### Queda pendiente

Lo de v210 sigue abierto: el tablero se rearma **mientras el velo todavía se está
yendo**, porque `closeCard()` y `startMatch()` corren uno detrás del otro sin
esperarse. Con el gesto unificado el arreglo es más fácil que antes, pero va
aparte.

## v212 · el banco de pruebas, y las dos costuras que encontró

Esto no salió de mirar el juego: salió de **instrumentarlo y medirlo**. Un
`MutationObserver` sobre `#overlay`, `#card`, `.wrap`, `.pop-velo` y `.pop-caja`
anotando con reloj de pared cada clase que entra y sale; envoltorios sobre
`openCard`, `closeCard`, `montarPop`, `cerrarPop`, `morfarPop`, `mesaAtras`,
`startMatch` y `renderBoard` midiendo lo que cada uno bloquea; y un
`PerformanceObserver` de `long-animation-frame` y `longtask` por si algo tardaba
de más. Después, una corrida automática que recorre menú → opciones → créditos →
club → cómo se juega → tablero, y adentro del partido unas cuarenta jugadas.

Nada de esto queda en el juego: se inyecta desde afuera sobre la página andando.

### Lo que el banco puede medir y lo que no

**Puede**: la coreografía completa con reloj de pared, y el trabajo sincrónico de
cada paso. Y sirve porque **el juego no usa `requestAnimationFrame` en ningún
lado** — todo es `setTimeout` y transiciones de CSS—, así que los tiempos que mide
son los tiempos de verdad.

**No puede**: contar cuadros. El panel del navegador baja el `rAF` a 1Hz cuando no
es la superficie que se está mirando, así que cualquier medición de fluidez
visual desde acá sería un invento del banco, no del juego. Lo que sí se puede
afirmar es lo que causa los cuadros perdidos: **el hilo principal no se bloquea**.
Cada cambio de pantalla cuesta entre 1,6 y 17ms de trabajo sincrónico, y en toda
la corrida no hubo **una sola** tarea larga de 50ms o más.

| paso | trabajo sincrónico |
|---|---|
| menú → opciones | 3,4 ms |
| opciones → menú | 3,1 ms |
| menú → créditos | 10,1 ms |
| menú → club | 14,1 ms |
| club → cómo se juega | 8,6 ms |
| cómo se juega → tablero | 4,6 ms (`startMatch` entero) |
| `render()` | 0,9 ms · `renderBoard()` 0,6 ms |

### Costura 1 · la pantalla se iba con dos relojes

v209 dejó una regla: **manda el reloj del estado al que se va**. La mesa la
cumple: se va atrás en 300ms con la curva de entrar y vuelve en 180 con la de
salir. Los carteles la cumplen: entran en 300 y se van en 180.

El velo de las pantallas **nunca la cumplió**. Salía con los mismos 300ms y la
misma curva de entrar, `cubic-bezier(.22,1,.36,1)`, que en la cola va lentísima.
Resultado medido: a los 180ms la mesa ya estaba entera, quieta y a brillo pleno,
y encima le quedaba todavía un tinte desvaneciéndose **120ms más**.

Dos cosas terminando en momentos distintos es exactamente lo que se lee como
entrecortado, y era el último lugar del juego donde pasaba.

Ahora `.overlay` y `.card` llevan una transición en cada estado, igual que
`.wrap` y `.wrap.atras`: **300ms con la curva de entrar puestos en `.overlay.open`,
180ms con la de salir en `.overlay`**. Verificado leyendo el estilo calculado en
los dos estados.

| | abierto | cerrado |
|---|---|---|
| `.overlay` opacity | .3s `(.22,1,.36,1)` | .18s `(.4,0,1,1)` |
| `.card` transform | .3s `(.22,1,.36,1)` | .18s `(.4,0,1,1)` |
| `.wrap` (ya era así) | .3s `(.22,1,.36,1)` | .18s `(.4,0,1,1)` |

### Costura 2 · el tiempo de gracia costaba más de lo que compraba

`POP_GRACIA` es lo que el velo espera antes de irse, por si atrás viene otro
cartel que quiera engancharse. Estaba en 90ms.

Medido: **cuando hay un cartel encadenado llega entre 1 y 5ms**. Todos los que
encadenan montan el suyo en el mismo tick, incluso los que pasan por un `await`,
porque el `montarPop` está adentro del ejecutor de la promesa —`penalUno` es el
caso más largo y monta en la primera línea—. Y cuando no viene ninguno, el
siguiente cartel tarda más de un segundo.

En catorce cadenas medidas **no cayó ninguna entre 5 y 90ms**. La distribución es
partida en dos y el medio está vacío.

O sea que los 90ms no compraban nada arriba de 5, y se los cobraban a cada
cierre: tocabas un cartel para sacarlo y durante 90ms no pasaba nada. Con 40
queda ocho veces el peor caso medido y el toque contesta al doble de rápido.

| | antes | ahora |
|---|---|---|
| tocar un cartel que se cierra | 93–99 ms hasta que se mueve algo | **50 ms** |
| tocar un cartel que encadena | 4 ms | 3–8 ms |

### Lo que se midió y estaba bien

- **Abrir y cerrar una pantalla sobre el tablero**: arranca en el mismo
  milisegundo del toque. Cero latencia.
- **Pantalla a pantalla**: el cambio se aplica a los 12ms del toque, la foto se
  saca a los 170 y la que entra termina cerca de los 320. Un solo movimiento.
- **Cartel a cartel**: arranca a los 4ms, termina a los ~306.
- **El sorteo del tablero**: el cursor frena como una ruleta —90, 134, 181, 233,
  286, 326, 435ms— y después la elegida se queda marcada 430ms mientras las otras
  se apagan. Parecía un hueco muerto en la traza y no lo es: es el remate.
- **El tablero se rearma 2ms antes de que el velo empiece a irse.** Estaba anotado
  como pendiente desde v210 y con la medición a la vista **se decide dejarlo**: el
  velo está al 94% de opacidad con 7px de desenfoque, así que no se ve nada del
  rearmado, y lo que sí se ve —el velo yéndose y la mesa volviendo, ahora los dos
  en 180ms— es un solo gesto de revelado.

### Verificado

Quince jugadas automáticas con cinco cierres de cartel: **cero parpadeos** del
velo (un velo que se va y otro que entra de cero en menos de 500ms). La secuencia
quedó alternando limpio, con 1,5 segundos como mínimo entre una salida y la
entrada siguiente.

Las seis medidas de pantalla, iguales a v211: menú 375x766 y 1280x722, club
335x549 y 620x587, cómo se juega 335x736 y 880x740. Sin scroll de más.

## v213 · el cartel del gol: el color se muda de la etiqueta al dato

De las cuatro salió **la C**, con el latido más seguido de lo que proponía la
maqueta.

### Lo que estaba mal, medido

El nombre del equipo que marcaba se ponía verde o rojo. Medido sobre el juego
andando: ese nombre mide **9,6px**. Y el dato que de verdad había cambiado —el
número, de **34px**— salía **blanco**, igual que el otro.

O sea que la señal de «esto acaba de pasar» estaba puesta en la etiqueta y no en
la noticia, y los dos números del marcador eran indistinguibles. Los dos pedidos
que llegaron —«el nombre en blanco» y «resaltar el número»— eran las dos mitades
del mismo problema.

Un detalle que ya había pasado antes: **la línea que pone el nombre en blanco ya
estaba escrita**, con dos abajo que la pisaban.

```
.gf.favor .gm-eq.marco b,.gf.contra .gm-eq.marco b{color:var(--white)}
.gf.favor .gm-eq.marco b{color:var(--green)}      ← se va
.gf.contra .gm-eq.marco b{color:var(--red)}       ← se va
```

Es el mismo enredo que tenía el rótulo de las cartas en v207: una declaración
correcta arriba y su contraria abajo, ganando por orden.

### Lo que cambió

| | antes | ahora |
|---|---|---|
| Nombre del que marcó | verde / rojo, 9,6px | **blanco**, 9,2px |
| El otro nombre | `--dim` | `--dim2`, un punto más apagado |
| Número que subió | blanco, sin marca | **color del gol + latido** |
| Tamaño del número | `clamp(34px, 9vw, 48px)` | `clamp(40px, 11vw, 52px)` |
| Separador | guion de 22px | filo de 1px, del alto de los dígitos |
| Escudo | 30px | 26px |
| Minuto | no existía | **línea nueva arriba del marcador** |

El guion se iba solo: a 22px al lado de números de 34 parecía un menos, y no
está restando nada. El elemento se queda —la caja lo necesita para separar las
dos columnas— pero ya no dice nada.

### El minuto

El cartel del gol era **el único pop-up del juego que no decía cuándo pasó** lo
que pasó. El de la jugada lo dice desde siempre, con esta misma tipografía y este
mismo trato, así que acá no se inventó nada: se usa el rótulo que ya existía.

El minuto sale de `minutoDelGol()`, que es `minutoActual()` pero a prueba de los
otros lados de donde sale este cartel: el 1v1 reparte los 90 entre 16 turnos como
hace el cronómetro, y **donde no hay partido detrás devuelve `null`** y la línea
no se dibuja. El gol se cuenta en el mismo minuto que la jugada que lo produjo,
así que lleva el mismo `+1`.

Verificado contra el cartel de la jugada: los dos dicen 10' en la primera. Y los
bordes: reloj en 1 → 90', 1v1 sin turnos → sin línea, 1v1 a los 5 turnos → 28',
sin ronda → sin línea, sin reloj → sin línea.

### El latido

La maqueta proponía **un solo golpe**. No alcanzaba: el cartel dura tres segundos
y el ojo llega tarde. Queda latiendo mientras el cartel está arriba, con 820ms de
ciclo —unos tres latidos y medio, y de paso el pulso de alguien corriendo—.

Lo que lo hace latido y no vibración es que **descansa**: el golpe ocupa los
primeros 570ms del ciclo y los 250 que sobran quedan quietos. Medido pisando el
reloj de la animación y leyendo la escala calculada:

| ms | 0 | 60 | 120 | **180** | 240 | 360 | 480 | 574 | 820 |
|---|---|---|---|---|---|---|---|---|---|
| escala | 1 | 1,156 | 1,178 | **1,18** | 1,032 | 0,99 | 0,999 | 1 | 1 |

No hace falta apagarlo: el cartel se va a los 3s o cuando lo tocan, así que
`infinite` nunca dura más que eso. Con `prefers-reduced-motion` queda el color
solo, que es lo que lleva el dato —la regla va después y con la misma
especificidad, comprobado sobre el CSSOM: índice 728 la animación, 732 el
apagado—.

### Verificado

Las dos direcciones, sobre el juego andando: con **¡GOL!** se marca el número de
la izquierda y se enciende tu nombre; con **GOL RIVAL**, el de la derecha y el
del rival. En los dos casos el otro nombre queda en `--dim2` y el otro número en
blanco sin animación.

| viewport | v212 | v213 | crece | le sobra abajo |
|---|---|---|---|---|
| 320 x 568 | 269 x 222 | 269 x 234 | +12 | — |
| 375 x 812 | 322 x 285 | 322 x 294 | +9 | — |
| 390 x 844 | 336 x 293 | 336 x 304 | +11 | 288 |
| 844 x 390 | 480 x 206 | 480 x 221 | +15 | 98 |
| 1280 x 768 | 516 x 360 | 516 x 376 | +16 | 214 |

**El ancho no se movió en ninguna** y el velo no estrena scroll en ninguna.

El caso que había que mirar era **320 de ancho con INDEPENDIENTE**, que es el
nombre más largo del juego y el que ya había obligado a apretar el relleno en
v206. El número creció 6px y el nombre bajó 0,4, y la cuenta dio a favor: la
columna pasó de 97,5 a 94,0 y el nombre de pedir 91 a pedir 89. Queda con **5px
de margen**, contra los 6,5 de antes. No se recorta.

### Lo que no se aplicó

De las cuatro propuestas, la **B** —la chapa llena de color— es la más legible sin
discusión, y sigue siendo la que habría que elegir si el cartel se mirara de lejos
o en una pantalla mala. Rompe la simetría del marcador: el dígito con chapa mide
31px y el otro 11.

La **D** —el número girando de 1 a 2— es la mejor idea de las cuatro y la peor
pieza: este cartel **está hecho para tocarlo** —`esperarOClick` deja adelantarlo—
y el que lo toca antes de que termine el giro se queda mirando el número viejo.
Queda anotada para cuando el giro pueda arrancar con el cartel entrando.

## v214 · tiempo de descuento: los escudos, y que se note que son dos opciones

De cuatro maneras de meterle los escudos salió **la tira**, y de tres maneras de
marcar las cartas salió **el latido**.

### Era el único marcador del juego sin escudos

La marquesina del tablero los tiene, la cinta de la jugada los tiene y el cartel
del gol los tiene desde siempre. Acá había dos números dorados flotando, y este
cartel te pregunta justamente algo que depende de cómo va el partido.

El dorado también se fue. Es el color de la racha: los cuatro rayos y la cinta
RACHA LLENA, que está pegada arriba. El marcador le competía a lo que de verdad
manda en este cartel. Los números pasan a blanco con el filo de un píxel, como
quedó el del gol en v213.

### Por qué al lado y no arriba

La disposición del cartel del gol —escudo arriba, nombre abajo— cuesta unos 40px
de alto, y **el alto es lo que este cartel no tiene**: medía 598px en un teléfono
de 812, y en 320 de ancho dejaba 25px arriba y 55 abajo; acostado, 17 y 43.

Puestos en una línea no cuestan un píxel. Y hubo con qué pagar el resto: abajo de
las dos cartas había **una oración de tres renglones en mayúsculas espaciadas**
—58px— que es la manera más cara de decir algo. Pasa a caja baja y a 35. El
renglón de arriba —«se acabaron los 90 · elegí qué hacer con ella»— se va del
todo yendo ganando o empatando, porque lo segundo lo dice ahora el rótulo.

| | v213 | v214 | |
|---|---|---|---|
| 320 x 568 | 284 x 487 | 284 x 464 | −23 |
| 375 x 812 | 322 x 598 | 322 x 544 | **−54** |
| 844 x 390 | 461 x 329 | 461 x 329 | 0 |
| 1280 x 768 | 516 x 643 | 516 x 543 | **−100** |

**Entraron los escudos y el cartel encima se achicó.** Eso no estaba garantizado.

### El nombre no entra en un teléfono, y no por poco

Acá la maqueta mintió: el marco de la comparación era más ancho que la tarjeta de
verdad —366 contra 322— y el club que salió sorteado tenía nombre corto. Sobre el
juego andando, con INDEPENDIENTE, que es el más largo:

| ancho | necesita | tiene |
|---|---|---|
| 320 | 90 | 61 |
| 375 | 90 | 69 |
| 414 | 90 | 89 |

Hasta I. RIVADAVIA, que necesita 70, se recortaba en los dos primeros. **No hay
ancho de teléfono donde entre**, así que en todos salía con puntos suspensivos,
que es peor que no estar.

Así que en el teléfono van **los escudos solos**, que es como la marquesina
resuelve lo mismo, y las chapas dejan de estirarse para que el grupo se junte en
el medio. El nombre vuelve en 700 de ancho, donde la tarjeta ya llegó a su tope y
la chapa reparte unos 150 para los 90 que hacen falta.

El corte **no va en la consulta ancha de más abajo** —a 820 en vertical la
tarjeta ya mide 413 y el nombre entra perfecto— ni en el ancho de teléfono más
uno, que sería apostar a un píxel.

**Y una corrección de método.** La primera medición la hice clonando el texto en
un medidor fuera de pantalla y comparando anchos, y esa cuenta dio recortes que
no existían en pantalla ancha —decía que faltaban 4px donde sobraban 45—. La
prueba que vale es `scrollWidth > clientWidth`, que es la que el navegador usa
para decidir si pone los puntos suspensivos. Todos los números de arriba salen de
ésa.

### Que son dos opciones

Las dos cartas tienen filo de color, título de color y una foto, y aun así se
leen como dos fichas de información: son idénticas a las de la situación de gol,
que **no se tocan**. Lo primero que les faltaba no era movimiento sino que
alguien dijera que hay que elegir una. El rótulo **ELEGÍ UNA** cuesta un renglón
y hace la mitad del trabajo. Yendo abajo no aparece: ahí hay una sola carta.

La otra mitad es el latido, y es **el gesto que el juego ya reservó para «tocá
esto»**: lo llevan IR AL VESTUARIO y USAR LA RACHA, que son las otras dos veces
que hay que tocar sí o sí. Dos golpes y descanso, 2,8s de ciclo.

Cada carta late **con su color** —verde JUGARLA, dorado GUARDARLA, los que ya
tienen en el filo y en el título— y van corridas medio ciclo, porque dos cartas
latiendo juntas se leen como un parpadeo de la pantalla y no como dos objetos.

**Sin escala, a diferencia del de los CTA.** Aquéllos son botones de una línea y
crecen un 3,5%; estas cartas miden 83px y llevan una foto adentro: escalarlas se
ve como un temblor. Queda el anillo solo, y va con `outline`, que **no ocupa
lugar**: el cartel mide exactamente lo mismo con latido y sin él.

Se apaga al pasar el dedo sólo donde hay mouse, que es la trampa que ya había
tenido el latido de los CTA: en un teléfono el `:hover` se queda pegado en lo
último que tocaste.

### De paso, dos limpiezas

- `equiposDelPartido()`. Los dos equipos del partido —nombres y escudos, con su
  rama para el 1v1— estaban escritos **dos veces**: una en `flashGol` y otra
  haría falta acá. Ahora es una función que usan los dos carteles que muestran el
  marcador.
- `.e-marc` y sus **seis reglas** en cuatro breakpoints se van con el marcador
  dorado: era el único lugar que las usaba.

### Verificado

Los tres estados sobre el juego andando: **ganando** y **empatando** dibujan las
dos cartas con el rótulo y las dos latiendo corridas 1,4s; **perdiendo** dibuja
una sola, sin rótulo y latiendo igual —es lo único que hay para tocar—. Los
botones enganchados en los tres.

Los escudos aparecen en los cinco anchos probados. Los nombres: ocultos en 320,
375 y 414; puestos y sin recortar en 820 vertical, 844 acostado y 1280. Sin
scroll de más en ninguno y el ancho de la tarjeta no se movió.

## v215 · el resaltado de la fila: se va el 3D y queda el filo

De cuatro mecanismos distintos salió **el más corto**: sacar el relieve y no
poner nada en su lugar.

### Qué hacía

Al pasar por una fila o una columna, cada carta hacía lo suyo por separado:
subía 7px, se acercaba 30 en el eje Z —lo que la agrandaba por perspectiva— y se
inclinaba 6 grados, más un canto de cinco capas con una sombra grande. En el
teléfono la versión chica era 4px, 18 de Z y 5 grados.

Eran **cuatro efectos sueltos** que el ojo tenía que juntar para leer una sola
cosa: esta fila está elegida. Medido a 375, la carta pasaba de 76x131 en la
posición 48,360 a 79x131 en 44,355.

### Qué queda

El resaltado ya tenía su idioma —el color de lo que te hace cada carta, que sale
de `predict()`— y lo único que sobraba era el relieve. Queda el filo del tono y
una línea del mismo color por adentro, que es lo que lo hace ver **encendido** en
vez de sólo pintado. Nada se mueve, nada crece, nada se apaga.

Se fueron `translate`, `rotate`, el `perspective` de `.cells` y los cantos
propios del resaltado. De paso el `perspective` se lleva una trampa: convierte al
elemento en el bloque contenedor de todo lo que tenga `position:fixed` adentro,
igual que un `transform` o un `filter`.

### El grosor va adentro, no en el borde

Un borde ocupa lugar. La carta es `border-box`, así que lo que gana el filo se lo
saca al contenido, y eso tiene dos costos distintos según la pantalla:

- **En el teléfono** el alto de la fila está fijado, así que el borde no corre
  nada… pero se come la ilustración. Medido en 320x568, que es la más apretada:
  con el borde en 3px la caja del dibujo pasa de 16 a 12 píxeles. **Un cuarto del
  dibujo.**
- **En escritorio** la mesa es `flex` y la carta se estira con lo que tiene
  adentro, así que los píxeles que el borde le roba al interior vuelven como
  alto: la carta resaltada pasaba de 229 a 230 y **empujaba un píxel para abajo a
  las filas de abajo**, cada vez que el dedo pasaba por una fila.

Ese segundo problema **ya existía antes de este cambio** —venía del
`border-width:3px` de escritorio, con un comentario que decía que no corría nada
justamente porque el borde crece hacia adentro— y se arregla acá.

La solución es la misma para los dos: **el grosor entero va por adentro, con
`box-shadow`, y el borde no se toca.** Se ve igual —1px de borde más 1 de sombra
son los 2 de siempre en el teléfono, y más 2 son los 3 de siempre en
escritorio— y no ocupa nada.

| | fila resaltada se mueve | columna resaltada se mueve |
|---|---|---|
| 320 x 568 | no | no |
| 375 x 812 | no | no |
| 844 x 390 | no | no |
| 1280 x 768 | no | no |

Medido con `offsetLeft/Top/Width/Height` sobre las 16 cartas: **la mesa entera da
exactamente los mismos números en reposo y resaltada**, en los cuatro anchos.

### El color, por variable

Los seis tonos eran seis bloques idénticos salvo el color. Ahora cada uno pone su
`--tono` en una línea y el filo, la línea interior y sus transparencias se
escriben **una sola vez**. El grosor de escritorio es un `--filo-hl:2px` en vez
de repetir seis reglas.

### Lo que se probó y se descartó

Antes de la D estaba la idea de **pasar el color del filo al fondo de la carta**,
para que las cuatro quedaran pintadas iguales y se leyeran como una banda. No se
lee: las cartas son casi toda foto, así que el lavado queda tapado por el arte y
sólo asoma en las dos franjas de texto. Se armó, se miró y se cambió.

De los otros tres mecanismos, el que más me seguía gustando es **el riel** —un
halo del tono que cruza el hueco de 5px y forma una placa continua—, que es el
único que hace que las cuatro cartas se lean como un renglón y no como cuatro
cosas. Queda anotado.

### Una corrección de método, otra vez

Las primeras lecturas decían que el color del tono **no se aplicaba**: la carta
resaltada seguía dando el azul de reposo. Era falso. El panel del navegador tiene
el reloj de las transiciones congelado, así que `getComputedStyle` devolvía para
siempre el valor de arranque de la transición de `border-color`. Con las
transiciones apagadas el color aparece correcto.

Es la misma trampa de v204 y la misma regla: **este resaltado se mide con las
transiciones apagadas**, porque lo que se quiere leer es el valor de destino y no
el del camino.

### Verificado

Las dos direcciones sobre el juego andando: con la fila marcada, las cuatro
cartas toman el color de su tono; con la columna, las cuatro de la columna, en
las cuatro grillas. Las cartas trabadas se quedan afuera de las dos, como antes.
Sin scroll de más y sin desborde de costado en ningún ancho.

## v216 · el cartel del gol se queda hasta que lo toques

De las tres maneras de avisarlo salió **la A**: el mismo aviso que ya lleva la
carta del tablero.

### El reloj se va

El cartel se iba solo a los **3000ms**, o antes si lo tocabas. El problema no era
que tres segundos fueran pocos: es que **el cartel se iba sin que el jugador
dijera cuándo**, y éste es el único momento del partido en el que uno quiere
quedarse mirando. Ahora espera.

Es el único cartel del juego sin reloj. Todos los demás siguen con su
`ESPERA_FIN` de 3500ms y se pueden adelantar con un toque.

### Cómo se espera sin reloj

`esperarOClick(wrap, ms)` pasa a aceptar que no le pasen `ms`: ahí no arma
temporizador y sólo escucha el toque.

**Y el `ms` se omite, no se pasa `Infinity`.** Un `setTimeout(fn, Infinity)`
convierte el número a entero de 32 bits, que da 0: el cartel se cerraría **en el
acto** en vez de no cerrarse nunca. Es la clase de detalle que parece un chiste
hasta que lo escribís.

La guarda de 200ms que `esperarOClick` ya tenía pasa a ser **lo único que lo
protege**: sin ella, el mismo toque con el que resolviste la jugada anterior
cerraría este cartel antes de que se llegue a ver. Verificado: un toque a los
60ms no lo cierra; uno a los 600 sí.

### El aviso

Desde que no se va solo, hay que decir que espera. El juego ya tenía dos maneras
y se usó una, no una nueva:

| | dónde vive hoy | trato |
|---|---|---|
| **La elegida** | la carta del tablero, «TOCÁ PARA JUGARLA» | 11px, 4 de espaciado, gris, parpadeando |
| La otra | el arco del penal, «tocá adentro del arco» | 10px, 2 de espaciado, más apagado, quieto |

Se eligió la de la carta porque es **exactamente la misma situación** —la tarjeta
entera es el botón y no hay nada que elegir— y porque el cambio de regla hay que
anunciarlo: hasta ahora el jugador no tenía que hacer nada acá.

En pantalla ancha crece a 12,5px con 4,5 de espaciado, que es lo que hace el
aviso de la jugada en esa misma consulta. Con `prefers-reduced-motion` se queda
quieto y un punto más apagado.

**Va al pie de la banda de abajo**, con el minuto y el marcador. En el primer
intento de la maqueta cayó adentro de la foto, flotando abajo del «¡GOL!»: la
inserción tomaba el primer `</div></div>` del marcado, que cierra el título y la
imagen, en vez del último, que cierra la banda.

### Verificado

Sobre el juego andando: a los **5,5 segundos el cartel sigue abierto** y la
promesa sin resolver; al tocarlo se cierra y resuelve. Un cartel cualquiera con
`ESPERA_FIN` sigue yéndose solo a los 3500 —medido, 3907 con el fundido—.

| viewport | v215 | v216 | crece | le sobra abajo |
|---|---|---|---|---|
| 320 x 568 | 269 x 234 | 269 x 257 | +23 | 173 |
| 375 x 812 | 322 x 294 | 322 x 317 | +23 | 265 |
| 390 x 844 | 336 x 304 | 336 x 327 | +23 | 276 |
| 844 x 390 | 480 x 221 | 480 x 249 | +28 | 84 |
| 1280 x 768 | 516 x 376 | 516 x 404 | +28 | 200 |

El ancho no se movió en ninguna, el velo no estrena scroll en ninguna y no hay
desborde de costado. El caso más apretado es el teléfono acostado y le siguen
sobrando 58px arriba y 84 abajo.

## v217 · el mercado se actualiza en el lugar, y cada renglón dice cuántos tenés

### Comprar ya no rehace la pantalla

Comprar o devolver llamaba a `showMarket()`, que vuelve a armar la tarjeta entera
y la pasa por `openCard`. **Desde v211 eso es un cambio de pantalla**: el fondo se
hunde, la tarjeta se reemplaza a oscuras y vuelve. Para el que compra se ve como
si la página se recargara, y encima pierde el lugar donde estaba mirando.

Ahora `mercadoRedibujar()` cambia sólo las tres partes que dependen de la plata y
del inventario —la franja, la mochila y la lista— y pone o saca la nota de la ✕
según haya compras. El título, el párrafo y el botón de jugar **no se tocan**.

El 1v1 ya tenía su propia versión de esto —`duelRedibujarTienda`— desde que su
tienda vive adentro del cartel del entretiempo y no en una pantalla.

`showMarket()` queda de red: si la tarjeta del mercado no está en pantalla,
`mercadoRedibujar` devuelve `false` y el que llama cae en el camino de antes.

Medido sobre el juego andando, comprando un ítem:

| | |
|---|---|
| Transiciones de pantalla disparadas | **0** —ni un `hundido`, ni una `foto-vieja`— |
| La tarjeta es el mismo nodo | sí |
| El `<h1>` es el mismo nodo | sí |
| Botones de compra reenganchados | los cuatro |
| `#nextBtn` sigue enganchado | sí |

Y la vuelta completa: comprar dos SUPLENTES y un GRITO DEL DT, después devolver
los tres de a uno, termina en €60M, sin chapas, sin nota y sin ✕ — todo sin que
la pantalla parpadee una sola vez.

### La chapa de cuántos tenés

Cada renglón de la lista muestra ahora **x1**, **x2** pegado al nombre. Va en
dorado, que es el color con el que el juego cuenta lo que tenés —los rayos de la
racha, el número de la mochila— y **no aparece cuando está en cero**: un «x0» es
ruido, la ausencia ya dice lo mismo.

No cuesta un píxel de alto: es una chapa en línea al lado del nombre, en el mismo
renglón donde ya vivía el «máx 1» de los ítems que no se acumulan.

### Lo que no se tocó, y conviene mirar

Con la chapa en el renglón, **la tira de arriba repite lo mismo**: «LO QUE
LLEVÁS · SUPLENTES 2 · GRITO DEL DT 1» dice exactamente lo que ahora dicen las
chapas. Es justo la repetición que v206 había resuelto al revés —ahí se sacó la
columna del renglón y se puso la tira—. Sacar la tira devolvería unos 56px de
alto. **No se hizo**: se pidió la chapa, no que se fuera la tira, y esa es una
decisión de diseño aparte.

### Verificado

Las medidas son **idénticas a v216** en los cuatro anchos probados, con el
mercado vacío y con dos compras hechas:

| viewport | vacío | con dos compras |
|---|---|---|
| 320 x 568 | 530 | 530 |
| 375 x 812 | 676 | 732 |
| 390 x 844 | 677 | 733 |
| 1280 x 768 | 698 | 738 |

El crecimiento al comprar es la nota de la ✕, que ya estaba antes. La chapa no
suma nada.

En un teléfono acostado —844x390— la tarjeta del mercado **scrollea por dentro**:
tiene `max-height` y `overflow:auto`, así que el botón de JUGAR se alcanza
bajando adentro de la tarjeta, no de la pantalla. Se comprobó porque la primera
lectura decía que el botón quedaba 212px abajo del corte y parecía inalcanzable:
lo que faltaba era scrollear la tarjeta. Es igual en v216.

## v218 · la amarilla acumulada deja de pisar la racha

De tres lugares salió **el ícono del aguante**: el otro extremo del mismo
renglón donde ya estaba.

### Por qué se montaba

En el teléfono la advertencia de amarilla es una tarjeta chica colgada del
aguante con `right:-17px`, apoyada en el hueco que hay entre el aguante y la
racha. **Ese hueco mide 8px y la tarjeta 14** —el emoji sale más ancho que su
tamaño de letra— así que le pisaba 8px al primer rayo. Medido a 375: la tarjeta
iba de 118 a 134 y la racha arranca en 126.

Achicarla no arreglaba nada: probada a 10px seguía pisando 4.

Y no se puede simplemente correrla adentro de la línea, porque **no sobra un
píxel**: el aguante mide 106, la racha 106 y la plata 43; con los dos huecos de
10 dan los **286 exactos** que mide la franja. Por eso la tarjeta estaba en
absoluto desde el principio.

### Adónde se fue

Al **otro extremo del mismo renglón**: la esquina del ícono del corazón, que
está al principio de la línea y no tiene a nadie al lado. Sigue en absoluto, así
que tampoco cuesta un píxel, y sigue pegada a lo que la amarilla amenaza —la
próxima es roja y la roja cuesta corazones—. El anillo dorado que ya rodea el
ícono se queda, así que la advertencia se sigue leyendo como una sola cosa.

Son dos números: `right:-17px;top:50%;transform:translateY(-50%)` pasa a
`left:14px;top:-1px`, y el tamaño de 12 a 11.

### Las otras dos que se vieron

- **En el escudo del club**, arriba en la marquesina. Es la que más se ve y la
  que más aire tiene alrededor, pero queda lejos de los corazones y dejaría
  huérfano el anillo dorado del aguante: habría que sacarlo.
- **En la esquina del reloj**, que es —medido— la única esquina de la pantalla
  con aire de sobra. Se ve perfecto, pero el reloj cuenta minutos: sería usar el
  lugar que está libre, no el que corresponde.

### Verificado

| | pisa la racha | el resto de la pantalla |
|---|---|---|
| antes | 8px | igual |
| ahora | **0** | igual |

Medido con la amarilla apagada y encendida, a 375 y a 320: la marquesina, la
franja de medidores, el aguante, la racha y la mesa dan **exactamente los mismos
números en los dos estados**. La tarjeta no cuesta layout.

En escritorio y en teléfono acostado no cambia nada: ahí la advertencia no es la
tarjeta suelta sino la caja entera del panel, que es lo que ya hacía.

Y la línea de ayuda de abajo lo sigue diciendo con palabras —«🟨 amarilla
acumulada»—, que es la otra mitad del aviso y no se tocó.

## v219 · el cartel de la posibilidad de gol se llena de letra

El recuadro mide lo mismo que antes. Lo que cambió es lo que hay adentro.

### El problema: 188px de aire

En el teléfono el cartel esconde la descripción y quedan tres cosas en una
línea. Medido a 375: adentro del recuadro entran **343px** y se usaban **155**
—pelota 16, título 74, la chapa del contador 51—. El resto, **188px, más de la
mitad del cartel, era hueco**.

El título salía en 9,4px, más chico que cualquier otro texto de la pantalla, en
el cartel más ancho que tiene el juego.

### Qué se hizo

**Dos pelotas, una en cada punta.** El título queda entre las dos y el cartel
se lee como una sola cosa con principio y fin. Las pelotas se van a los bordes
con `space-between` y el título toma lo que sobra con `flex:1`.

**El título pasa de 9,4 a 15px** y dice *LA POSIBILIDAD DE GOL* —con el
artículo—. El texto pasa de **74px de ancho a 154**.

**La racha se cuenta con rayos, no con un número.** Era el único lugar del juego
donde se escribía «2/4»; arriba, en la franja de medidores, la misma racha ya se
dibuja con rayos encendidos y apagados. Ahora acá se usa el mismo idioma:
encendidos los que llevás, apagados los que faltan.

**La chapa perdió el marco.** Era un rectángulo con borde y relleno que se
llevaba 51px; sin él, el hueco de la derecha mide 39 con los rayos y 27 con la
palabra USAR. Esos píxeles se los quedó el título.

Se fue también la luz propia de la chapa —`chapaluz`, un fondo que se corría por
adentro—: sin marco, la palabra USAR vive dentro del cartel y le alcanza con el
barrido verde que ya lo cruza entero.

### La altura, que era la condición

El pedido fue explícito: **sin tocar el tamaño del recuadro**. La chapa era la
pieza más alta del renglón, 23px, y sacarla dejaba el cartel en 35 de alto en
vez de 39.

Los que faltaban volvieron como relleno, pero **no alcanzaba con subirlo de 6 a
8**: los rayos miden 10 y la pelota 17, así que el renglón adentro queda en 21 y
el relleno tiene que poner 18. Con 8 el cartel quedaba en **37**. Es el tipo de
cosa que no se ve calculando y aparece midiendo.

También hubo que dejar la pelota en 17 en toda la franja del teléfono: a 19 el
renglón pasaba a 23 y el cartel a 41 en las pantallas de 441 a 820.

Y en escritorio, donde la descripción sí se ve, la chapa era **más alta que el
bloque de texto** —32px contra 29—, así que era ella la que daba la altura con
la racha llena. Sin marco el hueco mide 21 y el cartel se caía de 58 a 55. Se le
guardó la altura con un `min-height:32px`.

### Un escalón menos

El cartel tenía una bajada en 440px: el título se achicaba a 9,5. Ya no hace
falta. Medido a 320 —la pantalla más angosta— el texto ocupa **154 de los 191**
que mide el hueco del título con la racha cargando, y entra en un renglón con 37
de sobra. Una sola medida de 320 a 820.

### Verificado

| ancho | v218 (cargando / lista) | v219 | título |
|---|---|---|---|
| 320 | 39 / 39 | **39 / 39** | 74 → 154 |
| 360 | 39 / 39 | **39 / 39** | 74 → 154 |
| 375 | 39 / 39 | **39 / 39** | 74 → 154 |
| 390 | 39 / 39 | **39 / 39** | 74 → 154 |
| 441 | 39 / 39 | **39 / 39** | 74 → 154 |
| 600 | 39 / 39 | **39 / 39** | 73 → 154 |
| 820 | 39 / 39 | **39 / 39** | 73 → 154 |
| 844 × 390 | 75 / 69 | **75 / 69** | 108 → 125 |
| 1280 | 61 / 58 | **61 / 58** | 108 → 125 |

Las dos columnas se midieron con la v218 servida al lado de la v219, en la misma
pantalla y en los dos estados de la racha, con las transiciones apagadas. **No
hay un solo píxel de diferencia en la altura del cartel en ninguno de los nueve
anchos.**

El título no se parte en ninguno: un solo renglón en todos, y el cartel no
desborda —`scrollWidth` igual a `clientWidth`, que es la única prueba de recorte
que sirve—.

A 375 el resto de la pantalla también da igual: la marquesina, el cartel, el
`wrap` y el alto del documento dan los mismos cuatro números en las dos
versiones.

## v220 · pasar de ronda dice GANASTE y muestra el marcador

La pantalla se llamaba **PASASTE** y era la única de las tres de fin de partido
donde **tu escudo no aparecía en ninguna parte**.

### Lo que pasaba

El resultado existía, pero vivía chico adentro de una caja: el escudo del rival,
su nombre y un `1-1` colgando de un hilo abajo. Leído así, el partido que
acababas de ganar era una ficha del rival, no un marcador.

En ELIMINADO y en CAMPEÓN el resultado es otra cosa: una fila de **escudo ·
número · escudo** con los dos equipos nombrados, y DEFINIDO EN LOS PENALES abajo
cuando corresponde. Es la misma función, `marcadorFinal`, que las dos comparten.

### Qué se hizo

**El título pasa a GANASTE** y arriba del cuerpo va ese mismo `marcadorFinal`,
sin una línea nueva: los dos escudos a 42px, el número grande en el medio.

La caja del partido ganado se va —el marcador la reemplaza— y la del rival que
viene, que quedaba sola, **no se achica: crece**. Pasaba media fila y ahora se
queda con la fila entera, **acostada**: etiqueta, escudo, nombre y ronda en un
renglón de 61px. En columna habría desperdiciado la mitad del ancho y sumado
100px de alto para decir tres cosas.

La escalera de cinco rondas y la franja de corazón, racha y plata **se quedan
donde estaban**. Son lo que venís a mirar antes de entrar al vestuario.

### Lo que se descartó

- **Copiar ELIMINADO entero** —cinta, marcador, EL CAMINO y dos chapas—. Es la
  lectura más literal del pedido y por eso mismo la que más pierde: ELIMINADO es
  el **final** de la corrida y esta pantalla es el **medio**. Se llevaba puestas
  la escalera, la racha y la plata, y dejaba al próximo rival como texto en una
  chapa sin escudo. Medido con INDEPENDIENTE adelante, esa chapa pasa a dos
  renglones.
- **Meter el marcador adentro de la caja**, dejando las dos donde estaban. Era la
  más barata y la única que no crecía, pero los escudos entraban a 36px contra
  los 42 del marcador de verdad y los dos nombres compartían un renglón de 11px:
  con nombres largos se parte en dos líneas.

### Verificado

Medido con la v219 servida al lado de la v220, en el juego andando —no en una
maqueta—, llegando a la pantalla por el camino de siempre y con las transiciones
apagadas:

| pantalla | v219 | v220 con penales | v220 sin penales |
|---|---|---|---|
| 390 × 844 | 472 | **499** | 481 |
| 320 × 568 | 425 | **484** | — |
| 768 × 1024 | 485 | **513** | — |
| 1280 × 768 | 485 | **513** | — |
| 844 × 390 | 362 · rueda | **362 · rueda** | 362 · rueda |

Cuesta **27px** en un teléfono de 390, donde sobran 345, y **59** en uno de 320
—ahí la caja acostada se parte en dos renglones y suma alto—. En ninguna de las
cinco pantallas se recorta un texto, y **ninguna rueda que no rodara antes**: en
844 × 390 el tope de alto es 362 y ahí no entra ninguna de las dos versiones, que
es algo que ya pasaba.

Probado además con los nombres más largos de la tabla —INDEPENDIENTE contra
ESTUDIANTES, e INDEPENDIENTE como próximo rival—: a 390 la tarjeta queda en 515 y
a 320 en 500, sin recortes y sin rodar.

ELIMINADO y CAMPEÓN se midieron después del cambio y siguen igual: 561 y 605 a
390, con su marcador y sin recortes.

### Lo que se fue

Con la caja del partido se van dos reglas que solo ella usaba: `.pd-pen` —el «en
penales» chiquito, que ahora lo dice el marcador con todas las letras— y el hilo
dorado del pie, porque la caja acostada no tiene pie.

### Una cosa que queda como estaba

A 320, con nombres de 13 letras, el marcador los parte **a mitad de palabra**
—INDEPENDI / ENTE—. No es nuevo ni es de esta pantalla: es cómo se comporta
`marcadorFinal` desde siempre, igual en ELIMINADO y en CAMPEÓN. Traerlo acá
trajo también eso, que es justamente de lo que se trataba: que las tres digan el
resultado igual.

## v221 · el relato vive en el tablero y en ningún otro lado

El botón del relato —el de la esquina de abajo a la izquierda— se creaba **una
sola vez al cargar la página** y se colgaba del `body`. Como nunca se lo sacaba
de ahí, estaba en todas las pantallas del juego.

### Dónde aparecía y no tenía que aparecer

En el **menú principal**, en **elegir club**, en **opciones**, en **créditos**, en
el **mercado** y encima de los carteles de **fin de partido**. En el menú, además,
con el punto verde de «hay relato sin leer» prendido y el relato vacío: un botón
que no lleva a ningún lado, tapando una esquina de la pantalla de entrada.

### La regla

Todas esas pantallas son **el mismo `#overlay` abierto** encima de la mesa. El
tablero es la única donde no hay ninguno. Así que:

```css
#overlay.open ~ .log-fab, body:has(#overlay.open) .log-fab{display:none}
```

Va con las dos formas, igual que la regla que ya lo esconde cuando el panel está
abierto: el hermano para los navegadores sin `:has()` —el botón se cuelga
después del overlay, así que alcanza— y el `:has()` para los que lo tienen.

Y el relato del tablero **nunca queda vacío**: `startMatch` escribe la primera
línea antes de que se vea la mesa.

### El hueco que dejaba reservado

El pie de la página se corre a la derecha para que el botón no se le monte al
primer link: `padding-left:calc(var(--fab) + 12px)`. Sin botón, ese hueco quedaba
reservado para nada y **los créditos salían 20px corridos**. Medido a 390: el
centro del renglón caía en 215 y el de la pantalla está en 195.

Así que la reserva también se ata al botón: donde no está, el pie vuelve a 12.

### Verificado

Recorrido completo —menú, opciones, créditos, elegir club, tablero, mercado,
ganaste de ronda y de vuelta al tablero— a 320, 390, 768 × 1024, 844 × 390 y
1280 × 768:

| pantalla | botón | pie |
|---|---|---|
| menú | **no** | centrado |
| opciones | **no** | centrado |
| créditos | **no** | centrado |
| elegir club | **no** | centrado |
| **tablero** | **sí** | corrido 20, que es el hueco del botón |
| mercado | **no** | centrado |
| ganaste de ronda | **no** | centrado |

En el tablero a 320 —la pantalla más angosta— el botón termina **17px antes** del
primer link del pie, así que sigue sin montársele.

El panel sigue funcionando igual: se abre tocando el botón, se cierra tocando el
título, y mientras está abierto el botón se esconde, que es lo que ya hacía.

En escritorio y en teléfono acostado no cambia nada: ahí el relato no es un botón
flotante sino el panel fijo de la columna, y el botón ya estaba apagado.

## v222 · el mini juego abre con la misma cabecera que el cartel anterior

Tocás una carta, se abre el cartel de la jugada con la foto del jugador, tocás
otra vez y se abre el mini juego con **la misma foto recortada a una banda de
piernas**. Dos pantallas seguidas, la misma imagen, dos encuadres distintos.

### Por qué se veía distinta

Es literalmente el mismo archivo: mide **248 × 164**, apaisado. El cartel de la
jugada le da `max-height:190px` y a lo ancho de su pop-up eso alcanza para
mostrarlo entero. El del mini juego le daba **118px fijos**, así que
`object-fit:cover` se comía **el 45%** —arriba y abajo— y lo que quedaba era la
franja del medio.

Medido: la foto necesita **216px** de alto para entrar completa en los 326 de
ancho que tiene el pop-up a 390. Tenía 118.

### Qué se hizo

**La foto, entera.** El tope pasa a `min(216px, 27vh)`: 216 es lo que la imagen
necesita, y el `27vh` es el que la achica en las pantallas bajas, donde el cartel
no tiene de dónde sacar el alto. El degradado del pie baja de 58 a 42%, que es el
del cartel anterior.

**La misma cabecera.** Arriba va `cintaDelClub` —escudo, nombre del club y
minuto—, la misma función que usa el cartel de la jugada, y sobre la foto van sus
dos chapas: el escudo abajo a la derecha y el valor de la carta arriba, con el
mismo vidrio esmerilado y el mismo borde del color del eje. No se parecen: **son
la misma pieza**.

Va en `manoAMano`, que es por donde pasan **los cuatro mini juegos** —la marca,
el cruce, el mano a mano y defender—, así que los cuatro lo tienen sin repetir
una línea.

**Aire entre los valores y el nombre del juego.** Pegados se leían como un bloque
solo y son dos cosas distintas: cuánto vale la carta y a qué vas a jugar. El
nombre baja 12px en el teléfono y 9 en escritorio.

**El pie parpadea.** «TOCÁ UN LADO» lleva ahora la misma animación que el «TOCÁ
PARA JUGARLA» del cartel anterior —`blink 1.1s steps(2,start)`, la misma
declaración—: es la misma frase en las dos pantallas y ahora se comporta igual.
Con movimiento reducido se apaga, como el resto.

### Los tres enredos que aparecieron midiendo

**La cinta no llegaba al borde derecho.** El `*{max-width:100%}` global le pone
de techo el ancho del contenido, la caja queda sobredeterminada y el navegador
**descarta el margen derecho** en silencio: la cinta se corría a la izquierda y no
se estiraba. Es el mismo enredo que ya estaba anotado en `.play .p-cinta`. Se
arregla con `max-width:none` y, además, con el ancho explícito
—`width:calc(100% + 48px)`— para que si aparece la barra de scroll del cartel la
cinta la siga y quede simétrica igual.

**En escritorio no entraba.** El cartel ya estaba al límite de su `max-height` y
la cinta lo pasaba: aparecía la barra de scroll, que se come 15px de ancho y
volvía a torcer la cinta. Los huecos verticales ceden unos píxeles y **la cancha
del duelo se topa en 410px** —de 249 de alto pasa a 228, un 8% que no se nota—. El
cartel queda en 632 contra los 646 de antes: entra sin barra.

**La pregunta más larga manda.** Los cuatro mini juegos preguntan distinto, y
«¿PARA QUÉ LADO LO MARCÁS?» —la del delantero— se parte en dos renglones donde las
otras tres entran en uno. Con el tope de 27vh el cartel entraba en tres de los
cuatro y se pasaba 6px en ése. En los teléfonos parados de 640 para abajo la foto
cede un poco más. El escalón lleva `orientation:portrait` a propósito: sin eso,
acostado el 24vh daba 94px y la foto se recortaba un 66%.

### Verificado

Los cuatro mini juegos, en el juego andando, en siete pantallas:

| pantalla | alto del cartel | sobra | recorte de la foto |
|---|---|---|---|
| 320 × 568 | 487 | 31 | 23% (antes 34%) |
| 360 × 640 | 510 | 80 | 24% |
| 375 × 667 | 543 | 74 | 15% |
| 390 × 844 | 579 | 189 | **0%** (antes 45%) |
| 412 × 915 | 593 | 246 | 6% |
| 768 × 1024 | 660 | 288 | 17% |
| 1280 × 768 | 632 | 60 | 54% |

Los números son los del **peor** de los cuatro, que es siempre el del delantero.
En ninguna se corta el cartel por arriba, en ninguna se rueda, la cinta llega a
los dos bordes y el pie parpadea.

En **844 × 390** —el teléfono acostado— el cartel se rueda, como ya se rodaba
antes: 636px de contenido contra 620, en un hueco de 343. Ahí no entra ni con la
cinta ni sin ella.

El cartel de **situación de gol** comparte la clase de la foto y se midió también:
gana la foto entera —de 34% de recorte a 14% en 320— y no cambia nada más. A 390
mide 385 en un hueco de 768.

El parpadeo se verificó por la declaración y no por el color: el panel **congela
el reloj de las animaciones**, así que `getComputedStyle` devuelve siempre la
opacidad del primer cuadro. Lo que sí se puede comparar es que el pie del mini
juego y el «TOCÁ PARA JUGARLA» del cartel anterior corren **la misma animación con
los mismos parámetros**: `blink / 1.1s / steps(2, start) / infinite`, las dos en
estado `running`.

## v223 · el choque del mini juego se cuenta con escudos

El renglón que enfrenta los dos números decía de quién era cada uno **con
palabras** —VALOR / de la carta a la izquierda, ATAQUE / el tuyo a la derecha—,
en un juego que a los equipos los nombra con escudos en todas las demás
pantallas.

Y había un desbalance: el escudo del rival aparecía **dos veces en el mismo
cartel** —en la cinta de arriba y sobre la foto— mientras que **el tuyo no
aparecía ninguna**, aunque uno de los dos números es tuyo.

### Cómo queda

    escudo del club de la carta · número · VS · número · escudo tuyo

Los rótulos se van, el escudo de cada club ocupa su hueco y el que estaba sobre
la foto se saca: con el del renglón, el mismo escudo salía **tres veces** en un
cartel de 580px.

Va en `manoAMano`, así que lo tienen **los cuatro mini juegos** sin repetir una
línea.

**El VS deja el dorado y pasa a gris** —`var(--dim)`, el mismo tono que el juego
usa para lo secundario—. Con los escudos al lado, el dorado era lo más brillante
del renglón y se llevaba la mirada al separador en vez de a los dos que se
enfrentan. Va scopeado al mini juego: el cartel de la jugada, que todavía lleva
los rótulos, se queda con el suyo.

### Lo que se pierde

La palabra **ATAQUE** o **DEFENSA**, que decía qué eje se está midiendo. Sigue
dicho por el color del recuadro —rojo el ataque, azul la defensa—, que es el
mismo código que usan la chapita de la carta y el panel de stats. Si alguna vez
hace falta escribirlo, el lugar es debajo del VS, y ahí sí cuesta píxeles.

### Verificado

Los cuatro mini juegos, en el juego andando, con la v222 servida en la misma
pestaña para que las dos midan en la misma escala. Los números son los del peor
de los cuatro, que siempre es el del delantero:

| pantalla | v222 | v223 |
|---|---|---|
| 320 × 568 | 487 | **487** |
| 360 × 640 | 510 | **510** |
| 390 × 844 | 579 | **579** |
| 768 × 1024 | 660 | **660** |
| 1280 × 768 | 632 | **632** |

**Ni un píxel de diferencia en ninguna.** El renglón también mide lo mismo —34 en
el teléfono, 38 en escritorio—: los escudos entran exactamente en el hueco que
dejaron las dos columnas de texto.

Los escudos van a 34px en el teléfono y 40 en escritorio, que es el alto del
recuadro del número en cada uno. Las cuatro cartas de mini juego son **siempre
del rival**, así que los dos escudos nunca son el mismo.

El cartel de la jugada —el de un toque antes— se midió después del cambio y está
igual: sus dos rótulos, su VS dorado y su escudo sobre la foto.

### Una trampa de medición, anotada

Las primeras mediciones daban **+24px** y eran falsas. Estaban tomadas en dos
pestañas distintas del panel, y el panel **escala una pestaña y no la otra**
cuando el viewport emulado no entra: `innerWidth` dice 390 en las dos, pero
`devicePixelRatio` no, y todo el cartel sale un 4% más grande de un lado. La
pista fue que crecían **todas** las piezas a la vez —cinta, foto, cancha,
renglón, título—, que es lo que no puede pasar cuando se toca una sola.

Medidas las dos versiones en la misma pestaña, la diferencia es cero.

## v224 · los mini juegos se juegan en una cancha

Las dos escenas del juego —el duelo de a dos y el arco de tres palos— pasaban en
un azul transparente sobre el azul del cartel, con dos caminos punteados en
celeste. Ahora pasan en **césped con franjas de corte y cal blanca**.

El verde ya estaba en la paleta desde siempre —`--cesped` y `--cesped2`— y no lo
usaba ninguna pantalla.

### Por qué la cancha y no otra cosa

No es decoración: **lo que se toca es un área de la cancha**. En verde, con la
línea blanca alrededor, eso se entiende sin leer la pregunta; en azul sobre azul
había que deducir que esos dos rectángulos eran botones.

Y el arco comparte el césped, así que las dos escenas dejan de ser dos dibujos
distintos y pasan a ser **el mismo lugar**: la línea de gol es la misma cal que
la línea del medio del duelo.

Los caminos punteados se fueron con el azul. Con la cancha dibujada, la línea del
medio alcanza para decir que hay dos lados.

### Más grande, que era la otra mitad del pedido

- **El duelo** pasa de `viewBox 200x116` a `200x140`, y las dos zonas van ahora de
  borde a borde de la caja.
- **El arco** pasa de `200x120` a `200x136` y **crece hacia arriba**: el travesaño
  sube de 22 a 14.

El ancho no se toca en ninguna de las dos, así que lo único que cambia es el alto.

### Lo que no se movió ni un píxel

El arquero sigue parado en `(100,62)`, la pelota del penal en `(100,112)` y
`PENAL_Z` apunta a los mismos tres puntos. En el duelo, las figuras siguen en
`(100,44)` y `(100,102)`, la pelota en 58 y 112, y el anillo en 74.

Es a propósito: `animarPenal` calcula el vuelo y el disparo como **deltas contra
esas posiciones**, y el duelo mueve las figuras ±50 de lado y la pelota ±54 de
alto. Para que el duelo creciera sin tocar esos números, todo el contenido va
dentro de un `<g transform="translate(0,12)">`: se corre entero y **las distancias
relativas quedan iguales**. Ninguna constante de animación se duplicó en un
segundo lugar.

### Los tres penales, de un solo lugar

El arco sale de `arcoPenalHTML`, y de ahí lo toman los tres: la **tanda completa**
y el **penal suelto** de la posibilidad de gol pasan por `penalUno`, y el **penal
definitorio** por `tirarPenal`. Una sola función cambiada y los tres quedan en la
misma cancha.

### Verificado

Medido con la v223 servida en la misma pestaña, para que las dos midan en la
misma escala. Los números del duelo son los del peor de los cuatro mini juegos,
que siempre es el del delantero:

**El duelo**

| pantalla | v223 | v224 | cada lado que se toca |
|---|---|---|---|
| 320 × 568 | 487 (sobran 31) | **498** (sobran 20) | 105 × 119 → **105 × 144** |
| 390 × 844 | 579 (sobran 189) | **613** (sobran 155) | 129 × 146 → **129 × 177** |
| 1280 × 768 | 632 (sobran 60) | **639** (sobran 53) | 177 × 201 → **151 × 208** |

**El arco**

| pantalla | v223 | v224 | cada palo |
|---|---|---|---|
| 320 × 568 | 278 | **296** | 60 × 88 → **60 × 105** |
| 390 × 844 | 310 | **333** | 74 × 109 → **74 × 129** |
| 1280 × 768 | 457 | **492** | 115 × 168 → **115 × 199** |

El blanco para el dedo crece **un 21% en el duelo y un 18% en el arco** en un
teléfono de 390. Ninguna de las seis se rueda ni se corta por arriba.

En **escritorio** el duelo se topa en 350px de ancho —antes en 410—: con el
viewBox más alto, 410 dejaba el cartel 17px por encima de su tope y lo hacía
rodar. Ahí las zonas quedan un 15% más angostas y **un 3% más altas**, que es lo
que importa con mouse. El arco no se topa: su cartel tiene 200px de sobra.

En **320 × 568** la cancha se llevaba 36px más de los que había y el cartel se
pasaba por 4. La foto de la carta cede dos puntos de alto —de 24vh a 21— y vuelve
a entrar con 20 de sobra: en esa pantalla el que tiene que ganar es el lugar
donde se juega.

Probado además de punta a punta: el duelo resuelve —zonas apagadas, figuras que
se cruzan, pelota que cambia de dueño y el cartel de desenlace— y el penal
también, con la pelota terminando **a 17px del guante** en la atajada y la red
encendiéndose en el gol.

## v225 · el escudo vuelve a las cartas del teléfono

En un iPhone 13 mini y en un 17 Pro las cartas de la mesa salían **sin escudo**.
No era un bug nuevo: era una regla puesta a propósito —`(max-width:820px) and
(max-height:760px)` apagaba la chapita— y el corte estaba mal puesto.

### Por qué 760 se llevaba puestos esos teléfonos

En Safari, **la altura que ve el CSS no es la de la pantalla** sino la que queda
abajo de las barras del navegador. Un 13 mini de 812 de pantalla reporta 716, y
un 17 Pro queda alrededor de 745. Los dos caían debajo de 760 y se quedaban sin
escudo aunque en la carta hubiera lugar de sobra.

### Pero el corte no era lo único

Midiendo las **16 cartas** en vez de la primera apareció la razón de fondo. La
chapita tenía un tope atado al alto de la ilustración, y ese alto **no es el
mismo en todas**: la carta con el nombre en dos renglones —DELANTERO, PASE GOL—
se queda con mucho menos foto. Medido a 375 × 716, con la chapita forzada a la
vista:

| | la mejor carta | la peor carta |
|---|---|---|
| foto | 47px | **16px** |
| chapita | 21px | **8px** |

Con ese tope, bajar el corte habría puesto en algunas cartas una astilla de 8px.
Por eso el corte estaba tan arriba: tapaba un problema que no era el corte.

### Las dos cosas que se hicieron

**La chapita deja de medirse contra la foto.** Sin ese tope, las 16 la muestran
del mismo tamaño: 21px a 716 y 19 a 640. Se sale unos píxeles de la ilustración
en las cartas de nombre largo y no molesta a nadie —sigue adentro de la carta y
no pisa ni el nombre ni el resultado, medido carta por carta—.

**Y recién entonces baja el corte, de 760 a 640**, que es donde el escudo empieza
a cortarse de verdad. Entre 640 y 760 va una versión compacta: el mismo escudo
con menos relleno alrededor.

### Verificado

Las 16 cartas, en el juego andando:

| pantalla | antes | ahora | chapita |
|---|---|---|---|
| 320 × 568 | sin escudo | sin escudo | — |
| 375 × 640 | sin escudo | **16 de 16** | 19px |
| 375 × 716 · iPhone 13 mini | sin escudo | **16 de 16** | 21px |
| 402 × 745 · iPhone 17 Pro | sin escudo | **16 de 16** | 21px |
| 375 × 812 | 16 de 16 | 16 de 16 | 22–25px |
| 1280 × 768 | 16 de 16 | 16 de 16 | 42px |

En las seis, **todas las chapitas quedan adentro de la carta y ninguna pisa el
nombre**. Abajo de 640 el escudo se sigue apagando, como antes: ahí la carta
queda reducida a nombre y resultado y la foto mide 3px.

### Una trampa de medición, anotada

Las primeras mediciones daban números que no cerraban entre sí —la misma pantalla
daba foto 25 una vez y 10 la siguiente— porque estaban tomadas sobre
`querySelector('.cell')`, **la primera carta de la mesa**, y la mesa se sortea de
nuevo en cada carga. El alto de la foto depende de si el nombre entró en uno o en
dos renglones, así que el número cambiaba con la carta que había tocado.

Medido sobre las 16 a la vez, el rango aparece solo y con él la causa.

## v226 · el cartel del gol vuelve a cerrarse tocándolo

El cartel de GOL y GOL RIVAL dice **TOCÁ PARA SEGUIR** y no seguía: tocando la
tarjeta no pasaba nada, y había que tocar **afuera** del cartel para avanzar.

### Dónde estaba

No en el cartel del gol. En `montarPop`, que es lo que monta todos los pop-ups.

De un cartel al siguiente **la caja no se cambia: se reusa**. Es el mismo
elemento del DOM, al que se le cambia la clase y se le reemplazan los hijos. Eso
es a propósito —es lo que hace que el cambio sea a oscuras y no un salto—, pero
tiene una consecuencia: **cualquier manejador que le haya puesto el cartel
anterior viaja con ella**.

Y dos carteles le ponen uno: la ficha de **la posibilidad de gol** y la del
**ítem**, las dos con la misma línea:

```js
caja.onclick = (ev) => ev.stopPropagation();   // tocar la tarjeta no es tocar el velo
```

Después de abrir cualquiera de las dos, ese `stopPropagation` se quedaba pegado a
la caja compartida. El cartel del gol escucha el toque **en el velo**
—`esperarOClick`—, así que el toque moría en la caja y no llegaba nunca. Tocando
afuera sí, porque ahí el velo es el destino directo.

Eso es lo que lo hacía parecer un problema del cartel del gol y no de la caja.

`montarPop` ya limpiaba el `onclick` **del velo**, dos líneas más arriba, por
exactamente esta razón. Faltaba la otra mitad.

### El arreglo

```js
if(caja){ caja.onclick = null; caja.style.cursor = ''; }
```

Una línea, al lado de la que ya limpiaba el velo. No toca ninguno de los dos
carteles que sí quieren cortar la burbuja: ésos ponen su manejador **después** de
montar, así que se lo siguen quedando mientras están en pantalla.

### Verificado

Reproducido primero y arreglado después, en el emulador de teléfono:

| | antes | ahora |
|---|---|---|
| tocar la tarjeta de GOL | **no cerraba** | cierra |
| tocar la tarjeta de GOL RIVAL | **no cerraba** | cierra |
| tocar afuera | cerraba | cierra |
| el manejador heredado en la caja | **presente** | no queda |

Y los dos carteles que sí lo usan siguen igual: en la ficha de la posibilidad de
gol, tocar la tarjeta **no** la cierra y tocar el velo sí.

La última comprobación es con un toque de verdad del navegador —no un evento
sintético— sobre GOL RIVAL en un teléfono de 375 × 812.

## v227 · la ficha del ítem, mínima

En el teléfono la ficha de un ítem medía **370 × 273** sobre una pantalla de
390: iba de margen a margen y tapaba la mesa que estabas mirando justo para
decidir si usarlo. Y usaba cuatro colores —el filo dorado de arriba, la chapa
del paso, los dos botones dorados— para decir una sola cosa: cuánto sube un
medidor.

### Qué quedó

Cuatro renglones, en el orden en que uno los pregunta:

| | |
|---|---|
| **qué ítem es** | el ícono y el nombre |
| **qué hace** | `+2 ❤ AGUANTE` — el número grande, el medidor **con todas las letras** |
| **de cuánto a cuánto** | `3 ❤ → 4 ❤`, a la derecha del mismo renglón |
| **por qué** | una línea de descripción |

y abajo **USAR / VOLVER, uno abajo del otro**.

El medidor escrito es lo que antes había que saberse. La ficha decía `+1 ❤` y
vos tenías que acordarte de que ese corazón es el aguante y el rayo la racha.
Ese renglón corto —`I.efecto`— existe porque en la barra de ítems no entra la
palabra; en la ficha sí entra, y es justo donde hace falta. Sale de una tabla
nueva, `MEDIDOR`, al lado de `ITEMS`.

### Los botones, apilados

En 284px de ancho, dos botones al lado dan 127 cada uno: alcanza para la
palabra y no para el dedo. Apilados se llevan el ancho entero, con 38px de alto
mínimo cada uno.

### Se va la banda de foto

Era lo que más alto costaba —96px— y era la foto del ítem, que no contesta
ninguna de las cuatro preguntas de arriba. Con ella se fueron `.if-fila`,
`.if-art`, `.if-ico`, `.if-txt` y `.if-ef` del bloque de la ficha; las reglas
sueltas de `.if-fila` y `.if-art` se quedan porque el cartel de la posibilidad
de gol comparte la caja con su propio marcado.

### El ancho propio, y el margen

La ficha iba de margen a margen por una razón vieja: vive **adentro del botón
del ítem**, y heredaba sus 69px de ancho. Ponerla en `position:fixed` y
estirarla de 10 a 10 era el remedio de entonces.

Ahora tiene ancho propio —`min(284px, 100vw - 24px)`— y eso reabre el problema
que el estirón tapaba: centrada en su ítem, la del primero y la del cuarto se
salen de la pantalla. Así que el JS la mide **ya puesta** y la mete a la fuerza
entre los dos márgenes:

```js
const x = Math.max(MRG, Math.min(centro - ancho / 2, window.innerWidth - ancho - MRG));
f.style.setProperty('--fl', Math.round(x) + 'px');
f.style.setProperty('--fx', Math.round(centro - x) + 'px');   // el pico, contra la posición final
```

`--fx` pasa a ser el centro del ítem **medido desde la ficha** y no desde el
borde de la pantalla, así el pico sigue apuntando al ítem aunque la ficha se
haya corrido.

### Y lo mismo en escritorio y en el teléfono acostado

Ahí la ficha no va fija sino colgada del ítem, con `top:50%`, y la corrección de
arriba no la toca: `--fy` sólo lo lee el bloque de mobile.

Acostado a 844 × 390 los cuatro ítems son una columna, y medido **antes de
tocar nada** la ficha del segundo se iba 39px por debajo del borde, la del
tercero 165 y la del cuarto 256 —o sea, entera—. Eso **ya pasaba en v226**:
está comprobado sirviendo el `index.html` de v226 y midiéndolo igual, no
deducido. Se arregla midiéndola una vez puesta y corriéndola contra el borde
que la empuja, con `calc(50% + …)` para no perder el centrado cuando entra.

### Medido

Las dos versiones **en la misma pestaña** —cambiar de pestaña invalida la
comparación, ver v223— en un teléfono de 390 × 844, con los cuatro ítems
usables de verdad (aguante por debajo del máximo, racha en cero y una carta
trabada), porque si no, tres de los cuatro muestran el cartel de «no se puede»
y se mide otra cosa:

| ítem | v226 | v227 | superficie |
|---|---|---|---|
| SUPLENTES | 370 × 272 | 284 × 262 | **−26%** |
| GRITO DT | 370 × 273 | 284 × 266 | **−25%** |
| SEGUNDO AIRE | 370 × 272 | 284 × 279 | **−21%** |
| VAR | 370 × 272 | 284 × 269 | **−24%** |

**El alto no es lo que baja.** En SEGUNDO AIRE sube, porque los botones pasaron
a estar uno abajo del otro. Lo que baja es el ancho, 370 a 284, y con él la
superficie. Vale decirlo porque la primera versión de este comentario decía
«284 × 258, un 28% menos» —escrito de memoria antes de medir la ficha ya
armada— y ninguno de los dos números era cierto.

Y en ocho pantallas, abriendo los cuatro ítems en cada una y mirando margen,
apilado, scroll interno y desborde. El margen es el **más chico de los cuatro**
en cada pantalla, contra el borde que esté más cerca:

| | ancho | margen al costado | margen abajo | se sale | scroll |
|---|---|---|---|---|---|
| 320 × 568 | 284 | 12 | 144 | no | no |
| 360 × 640 | 284 | 12 | 216 | no | no |
| 375 × 667 | 284 | 12 | 243 | no | no |
| 390 × 844 | 284 | 12 | 405 | no | no |
| 412 × 915 | 284 | 12 | 491 | no | no |
| 768 × 1024 | 284 | 12 | 658 | no | no |
| 1280 × 768 | 284 | 214 | 128 | no | no |
| 844 × 390 acostado | 284 | 249 | **12** | no | no |

En las cinco primeras el tope de 12 es el que trabaja: la ficha del primer ítem
y la del cuarto llegan al margen y ahí se frenan. En las dos últimas la ficha
cuelga del ítem en medio de la pantalla y de los costados le sobra todo; el que
trabaja es el de abajo, y el 12 de `844 × 390` es exactamente la corrección
nueva apoyándose contra el borde.

### Dos cosas que aparecieron recién con la ficha armada

Las dos estaban en la maqueta que se eligió, y ninguna se ve leyendo el código:
hay que abrir los cuatro ítems y leer lo que dicen.

**La frase partida del SEGUNDO AIRE.** `desc` ya termina en punto y el agregado
se pegaba detrás en minúscula y con otro punto al final:

> El equipo saca fuerzas de donde no hay. ~~y recuperás un máximo.~~

Ahora el agregado es una oración entera —mayúscula y punto incluidos— y se pega
sin tocarle nada: «El equipo saca fuerzas de donde no hay. También recuperás un
máximo.»

**El renglón doble de la VAR.** `DESTRABA UNA CARTA` mide 128px y el paso
`TRABADA → JUGABLE` otros 128: no entran en los 256 que quedan, así que el
renglón se partía en dos y la ficha crecía 15px. Y encima decían lo mismo dos
veces. La palabra sola alcanza, porque el paso ya cuenta de qué a qué: la ficha
pasó de **294 a 269**.

### Una nota sobre el verde

La ficha bajó de cuatro colores a uno, pero el botón USAR sigue verde lleno.
No es un descuido ni una quinta tinta: es el mismo verde con el que se confirma
en todo el juego, y es lo que el jugador viene a tocar. El comentario del
código dice «el único color que **decora** es el número» por eso mismo —la
primera versión decía «el color queda en un solo lugar», que mirando la
pantalla es falso—.

## v228 · el resaltado del HUD: el salto corto, y la plata con el número

Cuando volvés al tablero después de una jugada, `pulseCambios()` compara una
foto de antes con el estado nuevo y le pone una clase al recurso que se movió.
El resaltado hacía **dos cosas fuertes a la vez**:

```css
18% { box-shadow: 0 0 22px 5px var(--hl); transform: scale(1.13) }
```

Una sombra de color **a opacidad entera y con 5px de expansión** —un rectángulo
encendido alrededor de la celda, que no tiene la forma de nada de lo que hay
adentro— y un salto al **113%**, que en la tira del teléfono es el ancho de
media barra de aguante.

### Dos tratos, según lo que el medidor pueda decir

| | qué le pasa |
|---|---|
| aguante, racha, marcador, reloj | **saltan y vuelven**: la mitad de tiempo y la mitad de salto que antes |
| la plata | **sube el número que cambió** |

La división no es estética. En cuatro de los cinco el **cuánto** ya está a la
vista: las barras de aguante y de racha se cuentan, el marcador y el minuto se
leen. En la plata no: de €40M a €50M hay que acordarse del anterior. Es el único
de los cinco donde poner el número agrega algo en vez de repetir lo que ya está.

```css
.pulse-up,.pulse-down{animation:pulsesalto .46s cubic-bezier(.2,1.7,.4,1)}
@keyframes pulsesalto{
  0%{transform:scale(1);filter:none}
  32%{transform:scale(1.07);filter:drop-shadow(0 0 6px var(--hl))}
  100%{transform:scale(1);filter:none}
}
```

`drop-shadow` y no `box-shadow`: la luz **sigue el contorno** de lo que hay —el
corazón, el rayo, el número— en vez de dibujar el rectángulo de la celda. El
rebote del final es lo que lo hace un salto y no un inflado.

La plata, en cambio, no salta: la celda se tiñe apenas —lo justo para saber cuál
de las tres se movió— y el trabajo de decir cuánto lo hace el número. Dos
movimientos encima del mismo dato es lo que tenía de más el resaltado viejo.

El número va en el verde del dinero cuando entra y en **rojo cuando sale**, que
es el caso del mercado. El `--hl2` es el mismo color al 15% escrito a mano:
`color-mix` haría lo mismo con una línea, pero no lo usa ningún otro lugar del
juego y son dos casos.

### Dónde cae el número, que no es el mismo lugar en los dos layouts

El primer intento fue el obvio —arriba de la celda, centrado, en cuerpo 15— y
**medido no servía en ninguno de los dos**:

| | qué pasaba |
|---|---|
| apilado (escritorio, teléfono acostado) | se metía **12px adentro de la fila de RACHA**, que es justo el otro medidor que se suele mover en la misma jugada |
| la tira del teléfono | tapaba **7 de los 17px de alto** del `€40M`, o sea el número que uno está tratando de leer |

El hueco está en lugares distintos, así que el número va distinto en cada uno.

**Apilado.** La fila mide 164 de ancho y el `€40M` ocupa 53 alineado a la
izquierda: sobran **111 a la derecha**, en la misma banda del valor. Ahí no pisa
nada. Medido a 1280 × 800: la fila va de 309 a 362, la de RACHA de 246 a 300 y
el valor de 332 a 355.

**La tira.** El presupuesto es una chapa de 51 × 23 con el número adentro y nada
de sobra a los costados: medido a 390, quedan 7px hasta el plantel y 7 hasta la
fila de ítems. El único hueco es **arriba**, los 15px que van de la marquesina
—que termina en 66— a la chapa, que arranca en 81. Entra en cuerpo 12.

### Medido

El número, en su punto más alto con opacidad entera, en los cuatro tamaños:

| | el número | su celda | ¿tapa el valor? | ¿pisa otro medidor? |
|---|---|---|---|---|
| 320 × 568 | 190–221 × 60–79 | 181–229 × 81–104 | no | no |
| 390 × 844 | 259–290 × 60–79 | 249–299 × 81–104 | no | no |
| 844 × 390 | 758–796 × 307–330 | 613–802 × 297–350 | no | no |
| 1280 × 800 | 1194–1232 × 319–342 | 1074–1238 × 309–362 | no | no |

En los dos teléfonos el número se mete 6px en la marquesina. No tapa nada:
comprobado con `elementFromPoint` sobre esa banda, lo único que hay ahí es el
**relleno de abajo** de la marquesina —4px— y su contenido de ese lado termina
en 50, catorce píxeles más arriba.

El punto más alto no se puede muestrear en vuelo: el panel del navegador
**congela el reloj de animación** y `getComputedStyle` devuelve el fotograma
cero para siempre. Se mide aplicando el pico como transformación estática, que
es lo mismo que dice el `@keyframes`.

### Y ahora sí se apaga con movimiento reducido

El resaltado viejo no estaba en ninguno de los diez bloques de
`prefers-reduced-motion` del juego: el salto al 113% le saltaba igual a quien
había pedido que las cosas no se muevan. Éste sí, y quieto sigue diciendo lo
mismo, porque la clase se pone y se saca al segundo: aparece, se queda, se va.

```css
@media (prefers-reduced-motion:reduce){
  .pulse-up,.pulse-down{animation:none;box-shadow:0 0 0 1px var(--hl);border-radius:4px}
  .pulse-coin{animation:none;background-color:var(--hl2)}
  .pulse-delta{animation:none;opacity:1}
}
```

### Lo que no se tocó

**El reloj se sigue poniendo rojo todas las jugadas.** No sale de
`pulseCambios` sino de `finDeJugada`, que le pega `pulse-down` —el rojo de «te
perjudicó»— cada vez que corren los 10 minutos. Es el resaltado más frecuente
del juego y avisa de algo que pasa siempre. Queda anotado; cambiarlo es otra
decisión.

Y el verde de la plata sigue siendo **el mismo verde del gol** a propósito:
antes era un dorado que se confundía con el amarillo de la racha, y las dos
cosas aparecen juntas en la misma línea.

## v229 · las columnas laten por debajo del cartel de gol

Las dos salidas de la racha se encienden casi juntas y competían por la misma
mirada. La que ganaba era la equivocada.

### Cuánto pesaba cada una

| | halo | anillo | ¿se mueve? | ¿cuántos? |
|---|---|---|---|---|
| el cartel de gol | 18px al **28%** | 1px | lo cruza un barrido de 1,8s | uno |
| las columnas | 30px al **75%** | de 1 a **2,5px** | **latían, 1,5s sin parar** | **cuatro** |

Casi el triple de opacidad y casi el doble de radio, repetido en cuatro chapas,
y encima moviéndose. El propio CSS del juego ya tenía escrito por qué eso gana:
**el ojo detecta el movimiento antes que el brillo**. Sólo que estaba escrito
como argumento para que las columnas *se vieran*, y terminó haciendo que le
ganaran al cartel —que es el que decide el partido, y la columna la salida
barata—.

### Lo que cambia

```css
@keyframes titilarsuave{
  0%,100%{box-shadow:0 0 0 1px rgba(245,200,66,.30)}
  50%    {box-shadow:0 0 0 1px rgba(245,200,66,.55), 0 0 10px rgba(245,200,66,.22)}
}
```

Tres cosas, y ninguna toca el cartel:

1. **El pico baja a 10px al 22%**, por debajo del halo *quieto* del cartel.
2. **El anillo deja de engordar.** Se queda en 1px y sólo cambia de opacidad, de
   .30 a .55. Antes pasaba de 1 a 2,5px, que es un cambio de grosor y se lee
   como movimiento aunque el color no cambie.
3. **El ciclo pasa de 1,5 a 1,9s**, así late más lento que el barrido del
   cartel, que va en 1,8. Dos ritmos parecidos compitiendo se leen como un solo
   temblor; separados, el más rápido manda.

Lo que **no** cambia: el borde y el texto siguen dorados y el fondo sigue siendo
`--panel`. La columna se sigue leyendo como encendida, que es lo que hace falta
en el tramo donde es la única salida disponible.

### Ese tramo, que es la mitad del asunto

Las dos no se encienden en el mismo momento: las columnas cuestan
`COSTO_COLUMNA`, **3 rayos**, y el cartel necesita la racha **llena, 4**. Con la
racha en 3 la fila de columnas es la única salida encendida y no tiene con quién
competir; ahí el resaltado tiene que seguir alcanzando. Comprobado en los dos
estados por separado y no sólo en el que molestaba.

### `titilarBorde` se va

Lo usaba una sola regla —la de las columnas— así que con el cambio quedó sin
nadie y se borró. Con él se actualiza el vocabulario de animaciones que está
documentado arriba de todo en el CSS, porque **le cambió la premisa**: decía que
la racha llena y las columnas son «cinco cosas que aparecen juntas y no pueden
competir entre ellas», tratadas con el mismo pulso. Ahora dice lo contrario para
este par, y por qué: se encienden juntas y **no pueden pesar igual**.

### El reemplazo quieto, también más bajo

Con movimiento reducido las columnas se quedaban en `0 0 0 2px currentColor` —el
anillo grueso en el color entero—, que es el fotograma del pico viejo. Quieto
volvía a gritar más que el cartel, así que ahora se queda en el reposo del
latido nuevo:

```css
.col-picks.lista .col-pick{box-shadow:0 0 0 1px rgba(245,200,66,.55)}
```

### Verificado

Leyendo las declaraciones y no muestreando la animación en vuelo: el panel del
navegador **congela el reloj**, así que el pico se compara contra el
`@keyframes`, y para mirarlo se aplica como sombra estática.

| | antes | ahora |
|---|---|---|
| animación de la columna | `titilarBorde` 1,5s | `titilarsuave` 1,9s |
| pico de la columna | 30px al 75% | **10px al 22%** |
| anillo | 1 → 2,5px | 1px fijo |
| halo del cartel | 18px al 28% | **sin tocar** |
| barrido del cartel | 1,8s | **sin tocar** |
| `titilarBorde` en el archivo | 3 menciones | ninguna |

## v230 · el pico de las columnas, de 22 a 30%

Un solo número, corregido mirándolo andar en el teléfono.

El 22% de v229 se eligió para que el pico de la columna quedara por debajo del
28% del cartel **también en opacidad**, no sólo en radio. Visto en movimiento
quedaba apagado de más: la columna dejaba de leerse como disponible, que es
justo lo que el resaltado tiene que decir.

```css
50% {box-shadow:0 0 0 1px rgba(245,200,66,.55), 0 0 10px rgba(245,200,66,.30)}
```

### Por qué 30 sigue estando bien

Ahora el pico es **más opaco en el filo** que el halo del cartel —30 contra 28—
y eso podría sonar a que volvimos al problema. No es lo mismo:

| | radio | opacidad | expansión |
|---|---|---|---|
| el cartel | **18px** | 28% | 1px |
| las columnas, antes de v229 | 30px | **75%** | hasta 2,5px |
| las columnas, ahora | 10px | 30% | ninguna |

Con **poco más de la mitad del radio y sin expansión**, la columna reparte
bastante menos luz aunque arranque con un punto más de opacidad en el borde. Lo
que define cuál te lleva el ojo es cuánta luz hay, no cuán fuerte empieza.

Y lo demás de v229 sigue igual, que es de donde sale la mayor parte de la
diferencia: el anillo no engorda —la columna ya no cambia de grosor— y el ciclo
de 1,9s está separado del barrido de 1,8 del cartel.

Sin tocar: el reposo del latido, el reemplazo de movimiento reducido, y el
cartel entero.

## v231 · el escudo y el número del plantel, en escritorio

Los dos venían del teléfono sin crecer nunca. En una pantalla de 1440 el escudo
del marcador medía **26 × 31** al lado de un «0 - 0» de 44px, y el número del
plantel **30 × 36** dentro de un panel de 215 de ancho: los dos se leían como si
todavía estuvieran peleando por los 390px de un teléfono.

### Los dos al mismo alto

```css
@media (min-width:1025px) and (min-height:600px){
  .mq-esc .escudo{width:37.5px;height:45px}
  #panelPlantel .stat .n{font-size:44px;min-width:38px}
}
```

| | antes | ahora |
|---|---|---|
| el escudo del marcador | 26 × 31 | **38 × 45** |
| el número del plantel | 30 × 36 | **38 × 45** |

La misma caja, exacta. No están nunca uno al lado del otro —el escudo vive en la
marquesina y el número en el panel de la derecha— pero son las dos cifras duras
del HUD de escritorio, y que midan lo mismo es lo que las hace leerse como una
familia en vez de dos tamaños sueltos.

El escudo va **37.5 y no un número redondo**: el `viewBox` es `0 0 100 120`, así
que 45 de alto son exactamente 37.5 de ancho. Con 38 la silueta se achata.
Redondeando, mide 38 en pantalla, que es de dónde sale el `min-width:38px` del
número: se eligió **para igualar al escudo**, no al revés.

### La condición es propia, y por qué

El bloque de escritorio que ya existía es
`(min-width:1025px), (min-width:821px) and (orientation:landscape)`, y por la
segunda rama **se come también al teléfono acostado**: 844 × 390 entra ahí. Con
45px de escudo, eso es media marquesina en un teléfono.

Así que esto va en su propio bloque, `(min-width:1025px) and (min-height:600px)`,
al final de la hoja. Entra un portátil de 1280 × 720 y no entra ningún teléfono,
ni parado ni acostado.

### La explicación del stat pasa a tres renglones, y no cuesta nada

Con el número más ancho, «vs. defensores y arqueros» ya no entra en un renglón y
ATAQUE queda en tres mientras DEFENSA sigue en dos. Probado a 34, 36, 38 y 42 de
ancho de chip, y con el `gap` y el relleno recortados: **se parte en todos**. El
umbral está entre 116 y 121px de texto, y el chip original dejaba 121.

No importa: **las dos cajas del plantel miden 68 en todos los casos**, porque el
alto lo manda el número de 45 y no el texto. El renglón de más cae en espacio que
ya estaba vacío.

### Medido

| | escudo | número | ¿misma caja? |
|---|---|---|---|
| 1280 × 800 | 38 × 45 | 38 × 45 | sí |
| 1440 × 900 | 38 × 45 | 38 × 45 | sí |
| 1920 × 1080 | 38 × 45 | 38 × 45 | sí |
| 390 × 844 | 17 × 17 | 31 × 20 | **sin tocar** |
| 844 × 390 acostado | 26 × 31 | 30 × 36 | **sin tocar** |

En los tres de escritorio: el escudo entra entero en la marquesina, las dos
cajas del plantel miden igual, ningún nombre de club se corta y la página no
scrollea de costado. Y los dos tamaños de teléfono devuelven exactamente los
valores de antes del cambio, que es la comprobación de que el bloque nuevo no
los alcanza.

## v232 · el dibujo del desenlace lleva el balón de los mini juegos

Los dieciséis dibujos que cierran una jugada tenían la pelota como **un disco
macizo del mismo color que todo lo demás**: `fill:currentColor`. Siendo lo único
que se mueve de verdad en la animación, se fundía con el arquero, el palo o la
defensa que la frenan.

Ahora usa **el balón que ya dibujan la cancha del mini juego y el arco del
penal**: blanco, con el pentágono negro y las costuras.

```js
pelotaSVG(31.5, 16, 5.4, 'pe pe-balon')
```

`pelotaSVG` ya existía y recibe la clase, así que no hubo que dibujar nada
nuevo. Y el balón entra con la clase **`pe`**, que es a la que están atadas
todas las animaciones de la pelota: se mueve exactamente igual que el disco que
reemplaza, sin tocar un solo `@keyframes`.

### Trece, no dieciséis

Tres dibujos quedan afuera y por dos motivos distintos:

| | |
|---|---|
| `copa`, `seca` | no tienen pelota |
| `cara` | **sí tiene un `<circle class="pe">`, y no es una pelota**: es la cara del disco de la moneda, r 8,5 y centrada |

La primera versión de esto la cambiaba también y el sorteo salía con una pelota
de fútbol adentro de la moneda. El reemplazo se hace por coordenadas y saltea
esa exacta.

### Y con algo que mirar adentro, el tamaño paga

De **58 a 76px** en toda la franja del teléfono. Con el disco macizo, crecer no
servía de mucho —era una mancha más grande—; el balón tiene detalle adentro.

### Los tres tamaños que había, y cuál mandaba

El dibujo tenía **tres** declaraciones de `font-size` compitiendo:

| dónde | valor | ¿mandaba? |
|---|---|---|
| `.gf.fallo .fi` (arriba de la hoja) | 42px | no — la pisa la de abajo |
| `.gf.fallo .fi` (más abajo) | **58px** | **sí**, en 441px y para arriba |
| `@media (max-width:440px)` | 50px | sí, sólo abajo de 440 |
| `@media` de escritorio | 80px | sí, en escritorio |

Las dos del medio son la misma regla escrita dos veces con la misma
especificidad: gana la que viene después. Así que el tamaño real en un teléfono
de 390 era **58**, no los 42 de la primera declaración —que es la que uno
encuentra buscando—.

Y el 50 de abajo de 440 iba **al revés**: la pantalla más chica mostraba el
dibujo más grande que la de 390. Se fue. Ahora es un solo número, 76, para toda
la franja del teléfono, y escritorio se queda en 80 como estaba.

### Medido

| | dibujo | el cartel | ¿entra? |
|---|---|---|---|
| 320 × 568 | 76px | 269 × 215 | sí |
| 390 × 844 | 76px | 336 × 215 | sí |
| 844 × 390 acostado | 80px | 413 × 256 | sí |
| 1440 × 900 | 80px | 470 × 266 | sí |

En los cuatro: el cartel entra entero en pantalla, la frase no se corta y no
rueda por dentro. El cartel sube de 198 a 215 de alto en el teléfono, que es lo
que costaron los 18px de dibujo.

Comprobado además que los trece salen con balón y con costuras, que la moneda
conserva su disco, y que **ninguno de los dieciséis se quedó sin animación** —el
reemplazo podría haber roto el enganche de los `@keyframes` a `.pe`, y no lo
hizo—.

## v233 · el penal: amague, disparo y golpe

El tiro tenía **dos tiempos y en el orden equivocado**: salía el arquero
—130ms— y después volaba la pelota —520ms—. Está comentado en el código que el
orden es a propósito, para que se vea el duelo, pero tiene una consecuencia que
no estaba anotada: **cuando la pelota arranca, ya sabés si entra**. Los últimos
520ms son confirmación, no suspenso.

Ahora son tres tiempos:

| | qué pasa | cuánto |
|---|---|---|
| **el amague** | la pelota retrocede un toque, el arquero quieto | 180ms |
| **el disparo** | salen los dos a la vez; la pelota gira 520° | 350ms |
| **el golpe** | tiembla el arco y revienta el destello donde pegó | 430ms |

El arquero tarda `.3s` y la pelota `.34s`, así que **la decisión y el tiro se
resuelven juntos**. El total queda en 960ms contra los 990 de antes: no es más
largo, está repartido distinto.

### El tiro, más rápido y al revés

```css
.pp-pel{transition:transform .34s cubic-bezier(.35,.05,.4,1)}
.pp-pel.atras{transition:transform .17s ease-out}
```

De `.46s` a `.34s`, y con la curva dada vuelta: antes arrancaba rápido y
frenaba al llegar —lo que hace que se lea como un desplazamiento—, ahora
arranca lenta y termina de golpe. El amague lleva su propia transición porque
el retroceso tiene que ser más corto que el tiro.

El giro de 520° es lo que lo termina de hacer un tiro: sin él la pelota se
traslada, no vuela.

### El golpe

Hasta acá la pelota llegaba y **no pasaba nada con el resto del dibujo**: el
arco quedaba tan quieto como antes del tiro. Cuatro sacudones de menos de 3px
alcanzan para que se sienta.

Va en el `<svg>` entero y no en el arco solo, así se mueven también la red, el
césped y el arquero: es un temblor de la cámara, no una pieza suelta.

Y el destello se escala con `transform` y no animando el `r` del círculo, igual
que `pp-atajo`: el radio como propiedad animable de CSS no está en todos los
navegadores, y la escala sí.

### El arquero deja de hamacarse

`arqVaiven` lo movía de lado a lado mientras elegías. Con el amague del
pateador hay **dos cosas moviéndose para decir lo mismo**, y la que importa es
la de la pelota, que es la que anticipa el disparo. El arquero esperando quieto
es, además, lo que pasa de verdad en un penal.

Lo usaba una sola regla, así que el keyframe se fue con él.

### Los tres penales, de una

El juego tiene tres lugares donde se patea y **los tres pasan por
`animarPenal`**:

| | por dónde llega |
|---|---|
| el penal definitorio | `tirarPenal` |
| la tanda de la final | `penalShootout` → `serieDePenales` → `penalUno` |
| el modo penales suelto | `showPenalesSolos` → `serieDePenales` → `penalUno` |

Así que el cambio es una sola función y un solo bloque de CSS, no tres.

### Verificado, tirando de verdad

Muestreando el tiro mientras corre, en el juego andando:

| a los | la pelota | el arquero | el arco |
|---|---|---|---|
| 60ms | `translate(0,9) scale(.94)` — atrás | quieto | — |
| 120ms | atrás todavía | quieto | — |
| 200ms | `translate(-52,-52) rotate(520deg)` | movido | — |
| 620ms | en el palo | movido | **tiembla** |

Y después del tiro el temblor se saca, así que un segundo penal arranca limpio.
Comprobado en el definitorio y en el de la tanda: los dos montan el círculo del
destello, los dos lo encienden y los dos resuelven en `sit penal resuelta`.

### Movimiento reducido

```css
@media (prefers-reduced-motion:reduce){
  .parco.tiembla{animation:none}
  .pp-flash.on{animation:none;opacity:.7}
}
```

No tiembla nada y el destello se queda quieto un instante en vez de expandirse:
el impacto se sigue marcando.

## v234 · la tanda: el marcador manda

La pizarra eran **dos filas** —nombre, cinco huecos, y un número de 17px al
final de cada una—. Ese número es el dato que define la tanda y era lo más chico
del cartel: para saber cómo iba había que leer dos renglones separados y
restarlos de cabeza, justo en el momento de más tensión del juego.

Ahora es **un solo bloque**: escudo y nombre de cada lado, sus puntos debajo, y
el `3 · 2` grande en el medio —que es como el juego cuenta un marcador en todas
las demás pantallas—.

### Los puntos siguen siendo puntos

Verde el que entró, rojo el que erró, vacío el que falta, dorado latiendo el que
se va a patear. **Y la rayita oscura sobre el rojo se queda**: es la única
diferencia que no depende del color, y sin ella un daltonismo rojo-verde deja la
tanda ilegible.

Lo que sí cambió es cómo se centra esa rayita. El punto viejo era un contenedor
flex y la rayita se centraba sola; el nuevo no lo es, así que va posicionada:

```css
.pz-punto{position:relative}
.pz-punto.fallo::after{
  position:absolute;left:50%;top:50%;
  transform:translate(-50%,-50%) rotate(-45deg);
}
```

### Qué se juega en este tiro

Un renglón que antes no estaba y que había que sacar contando los puntos de las
dos filas:

| | cuándo |
|---|---|
| **si la mete, define** | metiéndola, al que patea no lo alcanzan ni metiendo el rival todos los que le quedan |
| **si la erra, se acabó** | errándola, no llega ni a lo que el rival **ya tiene** |
| último de la serie | le queda uno |
| penal N de 5 | el resto |
| muerte súbita | pasados los cinco |

Las dos primeras van en rojo. Y las dos cuentas son **sobre el máximo
alcanzable**, no sobre la diferencia: la diferencia sola no alcanza porque
depende de cuántos tiros le quedan a cada uno, que en una tanda casi nunca es lo
mismo.

### Se cae el ancho fijo de la columna del nombre

Había un `width:11ch` en el nombre con un comentario de veinte líneas que
explicaba por qué: cada fila era su propia grilla, así que con BOCA arriba y
RIVER abajo las dos hileras de círculos arrancaban en x distintos y quedaban
corridas una respecto de la otra.

**Con los puntos colgando de su propio equipo el problema no existe**: las dos
hileras ya no tienen que alinearse entre sí. El `11ch` se fue, y con él la
restricción de que ningún nombre de club pudiera pasar de once caracteres sin
recortarse.

El `▸` del turno también se fue —tenía su propio lugar reservado para no mover
el nombre al aparecer—. Ahora el que patea se marca **en el color del nombre**.

### Lo que no cambió

La muerte súbita sigue igual: las casillas son las de **esa** serie y arrancan
de cero, mientras el marcador del medio sigue contando la tanda entera. Es el
mismo `cols` / `base` de antes.

Y los dos llamadores siguen siendo los mismos: el penal de la tanda, con turno,
y el resumen final, que pasa `-1` y ahí no se dibuja ni el punto que late ni el
renglón de qué se juega.

### Medido

Los seis estados, armando la pizarra a mano:

| | marcador | renglón |
|---|---|---|
| media tanda | 2 · 2 | penal 4 de 5 |
| 4-1 con dos por patear | 4 · 1 | **si la mete, define** |
| 1-4 con dos por patear | 1 · 4 | **si la erra, se acabó** |
| 4-4 con uno cada uno | 4 · 4 | último de la serie |
| muerte súbita | 6 · 5 | muerte súbita |
| resumen final | 5 · 4 | *(sin renglón)* |

En muerte súbita se dibujan **4 puntos** —las dos rondas jugadas— y el marcador
sigue en 6 · 5, que es la tanda entera. En el resumen no hay punto latiendo ni
equipo marcado.

Y el cartel entero, en cuatro pantallas:

| | el cartel | la pizarra | ¿entra? |
|---|---|---|---|
| 320 × 568 | 283 × 382 | 242 × 56 | sí |
| 390 × 844 | 336 × 419 | 298 × 56 | sí |
| 1440 × 900 | 581 × 659 | 529 × 82 | sí |
| 844 × 390 acostado | 461 × 329 | 389 × 82 | rueda por dentro |

Ningún nombre de club se corta y la pizarra no se desborda en ninguna.

**El scroll del acostado es de antes.** Comprobado sirviendo el `index.html` de
v233 y midiéndolo igual: mismo cartel de 461 × 329 y también rueda. Con el
cambio la pizarra pasa de **104 a 82** de alto ahí, así que rueda 22px menos que
antes.

## v235 · los mini juegos: quién ataca se ve, y el mano a mano pasa al arco

### El que tiene la pelota se mueve más

Las dos figuras se hamacaban igual —±5px en 1,9s, una en contrafase de la
otra—, así que mirando la escena no se sabía quién iba a resolver: había que
buscar dónde estaba la pelota.

| | ciclo | recorrido |
|---|---|---|
| el que tiene la pelota | **1,25s** | ±7px **y se inclina 2,5°** |
| el que espera | 2,4s | ±2,5px |

La escena cuenta quién ataca antes de que leas el texto.

**Cuál de los dos es el activo no está escrito en el CSS sino en
`escenaDuelo`**, que es la única que sabe de quién es la pelota: con la tuya sos
vos —arquero, defensor— y con la de él es el rival —medio, delantero—. Es el
mismo `mia` que ya decidía dónde dibujar la pelota, así que no hay un segundo
lugar donde acordarse de la regla.

Comprobado en los tres que usan figuras —el del arquero pasó al arco y ya no
tiene—: en **1 vs 1** el activo es el de abajo, vos, porque la pelota es tuya;
en **LA MARCA** y en **DEFENDER** es el de arriba, el rival, que es quien la
lleva. `dlVaiven` y `dlVaiven2` se fueron con el cambio.

### El mano a mano pasa al arco

El mini juego del arquero pregunta **«¿al palo izquierdo o al derecho?»** y se
dibujaba como dos muñecos en una cancha: el texto hablaba de un arco que no
estaba en ningún lado.

Ahora usa **el mismo arco de los penales** —red, césped, palos, el arquero con
los colores del rival— con **dos zonas de 78 en vez de tres de 52**, que cubren
el arco entero. La elección sigue siendo izquierda o derecha y **la
probabilidad no se toca**: sigue siendo 50/50.

```js
function arcoManoAMano(esc){ /* el arco del penal, con dos palos */ }
```

#### Los `data-z` son 0 y 2, no 0 y 1

Son los índices de `PENAL_Z`, así que el arquero vuela **a los dos palos** y no
al del medio. Eso deja que la resolución use `animarPenal` tal cual, sin
traducir coordenadas: la pelota va al palo que elegiste, el arquero al suyo, y
si coinciden te la ataja —que es exactamente la regla del mano a mano con la
pelota tuya—.

Tuvo un costo: `animarPenal` marcaba la zona elegida **por posición**.

```js
svg.querySelectorAll('.pp-zona').forEach(z => {
  z.classList.add('off');
  if(+z.dataset.z === mio) z.classList.add('sel');   // antes: (z, i) => i === mio
});
```

Con tres zonas da igual —los índices coinciden con el orden—; con dos, el palo
derecho es `data-z="2"` y está en la **posición 1**, así que por orden se
marcaba el equivocado. Comprobado eligiendo la derecha: queda seleccionada la
de `data-z="2"`.

### El arquero se hamaca, y sólo acá

```css
.sit.mam .pp-arq.idle{animation:mamArq 1.9s ease-in-out infinite}
```

En el penal el arquero se quedó quieto en v233, porque el amague del pateador
ya anticipa el tiro. Acá no hay amague —tocás un palo y sale— así que el
movimiento del arquero es toda la vida que tiene la escena mientras decidís.
Va **scopeado a `.sit.mam`**: el penal sigue con su arquero quieto, verificado
aparte.

La pelota además respira. Usa `translate` y no `transform`, que es lo que mueve
el disparo: son dos propiedades distintas y no se pisan.

### Medido

| | el cartel | ¿entra? | ¿rueda? |
|---|---|---|---|
| 320 × 568 | 283 × 478 | sí | no |
| 390 × 844 | 336 × 606 | sí | no |
| 1440 × 900 | 581 × 760 | sí | no |

Con el arco el cartel mide **606 contra los 613** de la cancha: siete píxeles
menos, no más.

Y los cuatro mini juegos resuelven: ¡GOLAZO! y ATAJADÓN en el del arquero,
¡LO PASÁS! en el defensor, TE PASÓ en el medio y SE VA SOLO en el delantero,
los cuatro con su dibujo de desenlace.

El penal quedó intacto: tres zonas con `data-z` 0, 1 y 2, y su arquero sin
animación de espera.

## v236 · el reflejo de los botones, más seguido

El reflejo que cruza los botones pasaba cada 2,2s en los ítems y cada 3,6s en
los dos botones grandes. Ahora pasa cada **1,5s** y cada **2,4s**.

| | ciclo | pasadas por minuto |
|---|---|---|
| los ítems | 2,2s → **1,5s** | 27 → **40** |
| CAMPEONATO y EMPEZAR LA COPA | 3,6s → **2,4s** | 17 → **25** |

### Lo que se recorta es el descanso, no el barrido

El ciclo son dos cosas: el barrido y la pausa hasta el siguiente. Bajar el
ciclo a secas aceleraría el barrido en la misma proporción, y eso es
exactamente lo que el código ya tenía escrito que no hay que hacer: **a unos
1.700 px/s el reflejo deja de leerse como luz y pasa a ser un parpadeo**.

Así que el porcentaje del barrido sube junto con el ciclo, para que el tiempo
absoluto casi no cambie:

| | barrido | descanso | la luz |
|---|---|---|---|
| ítems, antes | 440ms (20%) | 1.760ms | 398 px/s |
| ítems, ahora | **375ms (25%)** | **1.125ms** | **454 px/s** |
| botones, antes | 936ms (26%) | 2.664ms | ~900 px/s |
| botones, ahora | **792ms (33%)** | **1.608ms** | **970 px/s** |

El descanso baja un 36% y un 40%; la luz sube un 14% y un 8%. Sigue **muy por
debajo** del techo de 1.700.

### Los retardos de la cadena bajan con el ciclo

Los cuatro ítems salen escalonados para que no parezca un parpadeo de la
pantalla. Los retardos pasan de `.28 / .56 / .84` a `.19 / .38 / .57`, un tercio
menos, igual que el ciclo: escalonar 280ms sobre un ciclo de 1,5s dejaría al
cuarto ítem saliendo cuando el primero ya volvió, y la cadena se leería al
revés.

### Verificado en los tres lugares donde vive

| | ancho | animación | la luz |
|---|---|---|---|
| CAMPEONATO (`.mm-grande`) | 354 | `btnBrillo` 2,4s | — |
| EMPEZAR LA COPA (`.cta`) | 320 | `btnBrillo` 2,4s | 970 px/s |
| cada ítem | 71 | `itemBrillo` 1,5s | 454 px/s |

Los ítems salen escalonados `0 / .19 / .38`, y el reflejo de EMPEZAR LA COPA
sigue midiendo **320 × 44** —el botón— y no la ventana entera: el ancla que
arregló eso en su momento no se tocó.

Los dos apagados por movimiento reducido siguen en pie, cada uno en su bloque.

## v237 · todo penal se patea

El juego tenía **seis** penales y sólo tres se jugaban. Los otros tres se
resolvían con una moneda, así que la misma jugada terminaba de dos maneras
distintas según de dónde saliera.

| dónde | quién patea | antes | ahora |
|---|---|---|---|
| penal definitorio | vos | mini juego | igual |
| tanda de penales | los dos | mini juego | igual |
| situación de gol → PENAL | vos | mini juego | igual |
| **carta PENAL** | vos | `chance(.50)` | **mini juego** |
| **carta PENAL RIVAL** | el rival | `chance(.50)` | **mini juego** |
| **fundida → PENAL** | el rival | `chance(.50)` | **mini juego** |

Los tres que faltaban ahora usan el mismo pop-up: elegís palo y el arquero
vuela. A favor lo pateás vos; en contra **lo atajás vos**, que es el lado que
antes no existía en ningún lado del juego salvo en la tanda.

### Un solo lugar donde se abre

```js
function penalSuelto(yoPateo, rot){ /* penalUno con ronda 0 */ }
```

Devuelve **si entró la pelota**, no si te fue bien: pateando vos las dos cosas
coinciden, atajando son opuestas. Quien llama decide qué hacer con eso, y así
el mismo pop-up sirve para los dos lados sin una rama adentro.

### El rótulo lo manda quien lo abre

El penal suelto escribía **«POSIBILIDAD DE GOL»** siempre, porque cuando se
escribió salía de un solo lado. Ahora sale de tres, y en dos de ellos esa línea
era falsa: una carta de penal no tiene nada que ver con la racha llena.

| de dónde viene | qué dice |
|---|---|
| carta PENAL | PENAL · LO PATEÁS VOS |
| carta PENAL RIVAL | PENAL RIVAL · ATAJÁS VOS |
| la racha llena | POSIBILIDAD DE GOL · PENAL |
| la fundida | SE TERMINÓ EL AGUANTE · ATAJÁS VOS |

Y el cartel de la situación dejó de prometer un porcentaje cuando lo que sale
es un penal: de los dos lados dice **IR AL PENAL**, y abajo «LO PATEÁS VOS» o
«LO ATAJÁS VOS». Antes esa línea sólo estaba del lado de a favor.

### El 50% pasa a 67%, y el cartel deja de mentir

Con tres palos y el arquero eligiendo al azar, el penal entra **2 de cada 3**.
Las dos cartas decían 50% y ahora dicen **67%**.

Eso destapó una diferencia que ya estaba. Cuando la situación de gol pasó a
mini juego, su `p` se quedó en `.50` — y esa `p` es la que alimenta el
porcentaje del cartel de la racha llena. Con el penal jugándose al 67%:

| | prometía | pagaba |
|---|---|---|
| antes | **51%** | 54% |
| ahora | **54%** | 54% |

El comentario del código decía que la tirada era «2 de 3». No lo era: era 50%.
Con `p:2/3` en las dos listas —la de a favor y la del rival— el número del
cartel y el que sale son el mismo, comprobado sumando la tabla.

### El dibujo no se repite

Las cartas de penal llamaban a `flashFallo` al errar, que es la tarjeta con el
dibujo animado. El mini juego ya cierra con su propia tarjeta —¡GOL! o ATAJADO,
con el arco o el guante—, así que esa llamada se fue: eran dos carteles
seguidos diciendo lo mismo. El cartel con foto del gol sí se queda, como en
cualquier otro tanto.

### Verificado de punta a punta

Jugando cada uno en el juego andando y mirando qué se movió:

| | rótulo | resultado | efecto |
|---|---|---|---|
| carta PENAL | PENAL · LO PATEÁS VOS | entró | **gU +1, racha +1** |
| carta PENAL RIVAL | PENAL RIVAL · ATAJÁS VOS | gol del rival | **gC +1** |
| situación a favor | POSIBILIDAD DE GOL | entró | **gU +1** |
| fundida | SE TERMINÓ EL AGUANTE · ATAJÁS VOS | gol del rival | **gC +1, racha −1** |

Y los carteles de las otras cuatro situaciones siguen con su porcentaje y su
botón EJECUTAR: córner 35%, jugada clara ENTRA SOLA.

### Lo que queda por decidir

**El peso de las cartas de penal en la mesa no se tocó.** Un PENAL a favor pasó
de valer 0,50 goles a valer 0,67, y un PENAL RIVAL de costar 0,50 a costar
0,67. Las dos cartas se volvieron más caras en lo que hacen sin que cambie cada
cuánto aparecen. Es un número aparte y quedó anotado a propósito, no olvidado.

## v238 · el resaltado del tablero salta tres veces

Al cerrar un pop-up y volver a las cartas, los medidores que cambiaron se
resaltan: salta el marcador, el aguante, la racha y el reloj, y a la plata se le
enciende el fondo con el número que subió o bajó flotando al lado.

El problema no era el efecto, era **cuándo pasaba**. Arrancaba en el mismo
instante en que el tablero volvía a aparecer, y duraba 460ms. En esos 460ms el
ojo todavía está donde estaba el pop-up, no en la fila de medidores de arriba:
cuando llegabas, ya había terminado. El resaltado se mostraba y no se veía.

### Se repite, no se alarga

Estirar una sola pasada lo hubiese convertido en otra cosa —una celda inflada
que baja despacio—. Repetirla la deja igual y le da tres oportunidades: si
llegaste tarde a la primera, agarrás la segunda o la tercera.

| | antes | ahora |
|---|---|---|
| ciclo | .46s | **.58s** |
| pasadas | 1 | **3** |
| total | 460ms | **1,74s** |

Lo que se estira del ciclo es **el descanso**, no el salto. El pico del
`@keyframes` está en el 32%, que a .58s cae a los **186ms**, y de ahí al final
la celda ya está quieta en su tamaño normal. Tres saltos cortos separados por
un respiro, no tres saltos lentos.

El keyframe no se tocó: sigue siendo `scale(1.07)` con su sombra. Lo único que
cambió es cuántas veces corre.

### La plata va dos, no tres

El tinte del fondo hace **dos pasadas de .8s — 1,6s**, que a ojo es lo mismo que
los 1,74 del salto. Tres no: el número que flota al lado —que es lo que de
verdad se lee ahí— hace una sola pasada y termina en `forwards`, y tres tintes
debajo de un número que aparece una vez se leían como dos cosas distintas
pasando al mismo tiempo.

El número flotante no se tocó: sigue siendo 1s y ya está invisible mucho antes
de que se limpie la clase.

### El número que no está en el CSS

Las clases las saca un `setTimeout`, y ése era el que de verdad mandaba. En
1000ms la tercera pasada no existía: la clase se iba **en la mitad de la
segunda** y el salto se cortaba al aire. Subió a **2100** —1,74s más margen—.

Y hay **dos** de esos timeouts, no uno. El reloj no pasa por `pulseCambios`: lo
marca `finDeJugada`, que tenía su propia espera de 1000ms. Es además el
resaltado **más frecuente del juego**, porque suena en todas las jugadas. Salió
en la verificación, no de leer el código: el reloj era el único medidor que
reportaba `animationName: none` cuando los otros cuatro ya corrían de a tres.

### Medido en el juego andando

Disparando `pulseCambios` con los cinco medidores movidos, y `finDeJugada`
aparte para el reloj:

| medidor | animación |
|---|---|
| m-score | `pulsesalto 0.58s x3` |
| m-aguante | `pulsesalto 0.58s x3` |
| m-racha | `pulsesalto 0.58s x3` |
| m-reloj | `pulsesalto 0.58s x3` |
| m-dinero | `pulsetinte 0.8s x2` |

Y la clase, sobre el reloj, en cuatro momentos: **presente a los 60ms, presente
a los 1160** —donde con el timeout viejo ya no hubiese estado—, **presente a los
1560**, dentro de la tercera pasada, y **ausente a los 2460**. La animación
llega hasta el final y después se limpia.

### Movimiento reducido

Quien pidió que las cosas no se muevan sigue viendo un recuadro quieto en lugar
del salto, y el fondo tinte en lugar del parpadeo. Ahí el cambio se nota más que
en el salto: sin animación no hay tres pasadas que contar, hay un recuadro que
**dura el doble**, 2,1s en vez de 1. Que es exactamente lo que se buscaba.

## v239 · la chapa de máximo del SEGUNDO AIRE

El ítem hace **dos cosas** y la ficha mostraba una. Los +2 de aguante estaban en
el número grande; el corazón de **máximo** que devuelve —que es lo que hace que
este ítem valga 30 y SUPLENTES valga 10— aparecía dos veces y no se veía en
ninguna:

- como `<em>de 4 máx</em>` en cuerpo 9,6 **adentro** del número del paso, que
  además empujaba el renglón del efecto a partirse en dos;
- como la última frase del texto de color, en el mismo cuerpo 11,5 gris que la
  frase de ambiente que la precede.

### Y la frase no siempre era cierta

```js
const recupera = G.aguanteMax < AGUANTE_BASE;   // o sea, < 4
if(recupera) G.aguanteMax++;
G.aguante = clamp(G.aguante + 2, 0, G.aguanteMax);
```

Esa primera línea es la que la ficha no miraba. **«También recuperás un máximo»
se imprimía siempre**, con el techo bajo y con el techo entero. Con el techo en
4 no hay nada que recuperar y la ficha prometía algo que `usarItem` no iba a
hacer.

### Una chapa, y sólo cuando corresponde

```js
function extraItem(k){
  if(k !== 'refuerzo' || G.aguanteMax >= AGUANTE_BASE) return '';
  ...
}
```

Va **entre** el efecto y el texto de color: es parte de lo que el ítem hace, no
parte del color. Y va en chapa y no en número para que no le compita al **+2**:
es más chica que el nombre del ítem y el único borde redondo de la ficha, así
que se lee como una etiqueta —algo que **además** viene con esto— y no como un
segundo efecto. El rojo es el del aguante, que es el medidor del que habla.

Al lado, el paso propio del techo: `3 → 4`, con los números que hay, igual que
el paso del aguante.

### Qué se fue

| | antes | ahora |
|---|---|---|
| `de N máx` dentro del paso | sí | **no** |
| «También recuperás un máximo» | siempre | **nunca** — la dice la chapa |
| `MEDIDOR.refuerzo.mas` | el dato | **borrado**, no lo usaba nadie más |
| `.if-paso em` | la regla CSS | **borrada**, era su único `<em>` |

El texto de color vuelve a ser sólo color: «El equipo saca fuerzas de donde no
hay».

**La barra de ítems y la tienda no se tocaron.** Ahí `I.efecto` sigue diciendo
«y recuperás un ❤ de máximo» siempre, y ahí está bien: describen el ítem, no la
partida que estás jugando. La ficha es la única de las tres que muestra el paso
con los números de ahora, así que es la única que tenía que mirar la condición.

### Medido en el juego andando

Cinco estados del ítem, abriendo la ficha en el juego y leyendo lo que quedó:

| `aguanteMax` | chapa | paso | ficha |
|---|---|---|---|
| 1 | +1 ❤ DE MÁXIMO · `1 → 2` | 0 ❤ → 2 ❤ | 284 × 305 |
| 2 | +1 ❤ DE MÁXIMO · `2 → 3` | 0 ❤ → 2 ❤ | 284 × 305 |
| 3 | +1 ❤ DE MÁXIMO · `3 → 4` | 1 ❤ → 3 ❤ | 284 × 305 |
| 4 | **no hay** | 2 ❤ → 4 ❤ | 284 × **262** |
| 4, aguante lleno | no hay | — | 284 × 232 |

El paso vuelve a **un solo renglón** en los cinco. Y `maxNuevo` se quedó donde
estaba: el ítem sube el techo **antes** de repartir los dos corazones, así que
con el techo en 2 el paso es «0 → 2» y no «0 → 1».

Con el techo bajo la ficha queda en **305 contra los 310 de antes**: lo que gana
al desarmar el paso partido lo gasta en la fila nueva, o sea que el máximo pasó
a verse **sin costar alto**. Con el techo entero baja de 279 a **262**, que es
exactamente lo que medía la frase que no era cierta —y la deja igual de corta
que la de SUPLENTES, que mide 262—.

### Los anchos

La chapa mide **113 × 25** y la fila entera usa **150 de los 228** que tiene,
igual a 320 que a 390 —la ficha vale 284 en los dos—, así que no se parte en
ningún ancho. En escritorio la ficha entera queda en 284 × 255.

### Y el ítem sigue haciendo lo que dice

Usado con el techo en 3: `aguanteMax` 3 → **4**, `aguante` 1 → **3**, el ítem
gastado. Reabierta la ficha con el techo ya entero, la chapa **no está**.

## v240 · la carta con la foto entera

La ilustración deja de ser un recuadro en el medio de la carta y pasa a **ser la
carta**: ocupa los 83 × 146 enteros y el texto se apoya encima, con un velo que
se cierra arriba y abajo y se abre en el medio. Medido en un iPhone 17 Pro, la
foto pasa de **68–86px de alto a 146**.

### Y no se movió nada de lugar

El nombre sigue arriba con el número del duelo a su derecha, el escudo colgado
de la esquina de la ilustración y el resultado abajo. Esa era la condición, y
casi no se cumple.

El primer intento sacaba `.c-ico` del flujo para estirarlo a la carta. Ahí el
escudo —que vive adentro y se cuelga de su esquina— se iba al borde de arriba,
donde ya están el nombre y el número: medido, **8 choques de 8 cartas**.

Lo que funciona es al revés:

```css
.cell::before{ background-image:var(--art); ... }   /* la foto la pinta la carta */
.cell .c-art{ visibility:hidden }                   /* la <img> se queda en su lugar */
```

`visibility` y no `display`: la imagen original **sigue ocupando su caja**, así
`.c-ico` conserva la suya y el escudo no se entera de nada. El único
desplazamiento es de **5px** —su esquina pasa de 53,42 a 58,38—, que es el
relleno que le ponía la chapita al irse.

### El escudo, con su vidrio

Se va la chapita: el fondo azul al 50%, el borde blanco y el relleno. Lo que
queda es el desenfoque, **recortado contra la silueta del escudo** con una
máscara redonda. No hay chapa ni borde, pero el fondo que le toca se vuelve
borroso y más oscuro y el escudo se despega igual — que es lo único que la
chapita hacía.

### El nombre, con sombra

Sobre la chapa lisa de antes no la necesitaba. Sobre la foto sí, o se pierde en
las ilustraciones claras. Va **chica y pegada** —`0 1px 2px` más un halo de 6
apenas visible—, no el resplandor grande del resultado: a cuerpo 11 un halo
ancho le come el filo a las letras.

### Dónde mirar cada ilustración

La carta es angosta y alta, así que de una foto apaisada entra una franja.
Recortada al medio, la mitad de las cartas mostraba césped y el asunto quedaba
afuera: el banderín del córner, la bandera del offside, la tarjeta del árbitro.

Salieron las 33 imágenes del juego a archivos y se miraron una por una,
recortadas al alto de la carta en cinco posiciones. La tabla vive en `ENCUADRE`
y son **treinta encuadres**: sólo tres se quedaron en el 50 del medio —el
tiro libre del rival, la camiseta de FAMA y la de SPONSOR—. Los otros
veintisiete se movieron; los que más:

| ilustración | de | a | qué entra ahora |
|---|---|---|---|
| `pasegolC` | 50 | **82** | el que llega a recibir, que es la amenaza |
| `publicidad` | 50 | **72** | los carteles con marca, no el césped vacío |
| `offside` | 50 | **58** | la bandera levantada del asistente |
| `cooling` | 50 | **62** | el técnico y el cartel de COOLING BREAK |
| `corner` · `cornerC` | 50 | **15** | el banderín y la pelota |
| `penal` | 50 | **22** | el árbitro señalando el punto y el caído |

**AUTOGOL RIVAL y AUTOGOL PROPIO son la misma foto** —`autogol` es alias de
`encontra` en `ART`—. Con el encuadre se vuelven dos cartas distintas: una
muestra el festejo (78%) y la otra las manos en la cabeza (30%).

### Las tres que el velo tapaba

La roja, la amarilla y el offside tienen su asunto **arriba de todo**, justo
donde el velo arranca en .92 para que se lea el nombre. Corregir el encuadre no
alcanzaba: entraban en cuadro y salían apagadas.

Probados seis tratamientos en la carta de verdad —el zoom las perdía del todo—,
lo único que las destapa es **bajar ese arranque a .58**. Esas tres llevan la
clase `arriba` y su propio `--velo`. El nombre se sigue leyendo porque ahora
tiene su sombra.

Y el offside necesitó tres pasadas. En la hoja de recortes sueltos el 58%
alcanzaba; puesto en la carta pareció que la bandera quedaba partida y se probó
el 66. Comparadas las ocho posiciones **una al lado de la otra en el tablero**,
el 66 la corta más, no menos: a 58 la bandera es la más grande y la más entera,
con el brazo levantado debajo. Volvió a 58.

### El penal no es un porcentaje

Desde la v237 todo penal se patea, así que el **67%** del frente era la chance de
una moneda que ya no se tira: lo que pasa depende de a dónde le pegues. Las dos
cartas y los dos pop-ups pasan a decir **MINI JUEGO**, con la misma chapa que
usan los duelos, y el renglón de abajo —lo que te deja— no cambia.

| | antes | ahora |
|---|---|---|
| carta PENAL | 67% GOL | **MINI JUEGO · PATEÁS** |
| carta PENAL RIVAL | 67% RIVAL | **MINI JUEGO · ATAJÁS** |
| POSIBILIDAD DE GOL | 67% GOL | **MINI JUEGO** |
| SE TERMINÓ EL AGUANTE | 67% GOL | **MINI JUEGO** |

En el pop-up del rival la chapa **no estaba**: `minisGol` la ponía sólo del lado
de a favor, de cuando el penal del rival se sorteaba solo. Ahora va de los dos
lados, porque de los dos lados se juega.

El subtítulo es de una palabra **por medida**: a 320 la carta tiene 62 × 129 y
«LO PATEÁS VOS» se parte en dos renglones y se sale 4px de la caja. «PATEÁS»
entra con 5px de sobra.

### Lo que se movió de lugar en el CSS

Dos piezas tuvieron que mudarse porque su casa cambió de dueño:

- **el candado de la trabada** vivía en `.cell::after`, que ahora es el velo;
  pasa al `::before` de la ilustración, que sigue estando en el medio;
- **el brillo diagonal del resaltado** vivía en `.c-ico::after`, que ahora es una
  caja chica; pasa a ser una segunda capa del mismo velo.

La trabada conserva su trato: 26% de foto, sin color y fuera de foco, con el
desenfoque escalado por ancho de carta. Y no se enciende al tomar la fila, como
siempre.

### Medido

Con un tablero armado a mano con las dieciséis cartas más exigentes —las tres
del velo flojo, los dos penales, una trabada, un duelo, la del nombre más
largo—, en cuatro anchos:

| pantalla | carta | desbordes |
|---|---|---|
| 320 × 800 | 62 × 129 | **ninguno** |
| 402 × 874 | 83 × 146 | **ninguno** |
| 1280 × 860 | 189 × 224 | **ninguno** |
| 874 × 402 (apaisado) | 68 × 189 | **ninguno** |

Comprobado elemento por elemento —nombre, número, resultado, escudo y chapa—
contra el borde de la carta, no a ojo. Las dieciséis con su foto y su encuadre,
el escudo de 18 / 19 / 21 / 33px según pantalla, y el juego jugándose de punta a
punta sin un error en consola.

### Lo que se deja como está

**El nombre partido de las cuatro de duelo.** DELANTERO, DEFENSOR, ARQUERO y
MEDIO llevan el número del duelo arriba a la derecha, y ese número le come el
ancho al nombre: le quedan **47px** de los 72 que usa cualquier otra carta. Con
`overflow-wrap:break-word` una palabra que no entra sola se parte donde sea, así
que sale `DELANTER / O` a 390 y tres partidas a 320 —las cartas sin número no se
parten nunca—.

Es de antes de v240: la caja del nombre no cambió. Se probaron tres arreglos, los
tres sobre `.cell:not(.sin-val)`, y los tres funcionan —cero nombres partidos,
6 de 6 cartas en su medida, nada fuera de la caja—:

| | partidos a 320 | foto libre 320 / 390 / 402 |
|---|---|---|
| como está | **3** | 48 / 72 / 80 |
| el número arriba, el nombre abajo | 0 | 36 / 49 / 56 |
| el nombre arriba, el número abajo | 0 | **60 / 73 / 80** |
| el número flotado | 0 | **60 / 73 / 80** |

Dos de los tres dejan **más** foto que hoy, no menos: el renglón de más ya se
estaba pagando con el nombre partido, sólo que mal. Aun así queda sin aplicar
**a propósito**: es una decisión tomada, no un olvido.

## v241 · el arquero del penal, moviéndose apenas

Mientras elegís el palo, el arquero esperaba **inmóvil** y lo único que se movía
en la escena eran los tres palos titilando. Ahora se hamaca:

```css
.pp-arq.idle{animation:arqPeso 2.6s ease-in-out infinite}
@keyframes arqPeso{
  0%,100%{transform:translateX(-4px) rotate(-1.2deg)}
  50%    {transform:translateX(4px) rotate(1.2deg)}
}
```

### Esto ya se había sacado, y por buenos motivos

El arquero se hamacaba con `arqVaiven` y el vaivén se quitó con este argumento,
que estaba escrito en el CSS: con el **amague del pateador** —el retroceso de la
pelota justo antes del tiro— hay dos cosas moviéndose para decir lo mismo, y la
que importa es la de la pelota, que es la que anticipa el disparo.

Ese argumento sigue en pie, y es justamente el que define **cuánto** se mueve el
que vuelve:

| | mano a mano | penal, antes | penal, ahora |
|---|---|---|---|
| recorrido | ±8px | — | **±4px** |
| giro | ±3° | — | **±1,2°** |
| ciclo | 1,9s | — | **2,6s** |

La mitad de recorrido y un 37% más lento. A esa velocidad no compite con el
amague, que dura 180ms, y alcanza para que la escena no parezca un dibujo.

### Por qué el de costado y no otro

Se probaron tres en la carta de verdad: el paso de costado, un agacharse y
estirarse —cargando el salto, sin moverse para los lados— y los dos guantes
subiendo y bajando en contrafase con el cuerpo quieto.

Los dos últimos tienen una ventaja real: **no dicen nada sobre a qué palo va a
volar**, que es la única objeción seria contra el movimiento lateral. Ganó el de
costado igual, por parecerse más a un arquero, y el riesgo queda acotado por la
velocidad: a 2,6s por ciclo, en el instante del amague el arquero está donde
estaba hace medio segundo.

### Se apaga solo

Vive en `.idle`, que es la clase que `animarPenal` saca **antes** del vuelo:

```js
arq.classList.remove('idle');   // y recién después el amague y el disparo
```

Comprobado en un penal de verdad: antes del tiro el arquero tiene
`pp-arq idle` con `arqPeso 2.6s`; apenas se elige el palo queda en `pp-arq`,
con `animation:none` y la matriz del vuelo puesta. Nada le pisa la atajada.

### Y vale para los tres

El definitorio, la tanda de la final y el modo suelto comparten `arcoPenalHTML`
y `animarPenal`, así que la regla se escribe una vez y la heredan los tres.

El **mano a mano** del arquero conserva el suyo —`mamArq`, ±8px y ±3°— y no se
tocó: ahí el movimiento del arquero es toda la vida que tiene la escena, porque
no hay amague que lo acompañe. Quedan dos vaivenes para el mismo dibujo, a
propósito y por distinto motivo.

Movimiento reducido apaga los dos: las dos reglas que ya existían
—`.pp-zona, .pp-arq.idle` y `.sit.mam .pp-arq.idle`— ponen `animation:none`, y
la nueva cae adentro de la primera sin tocar nada.

## v242 · el reflejo de los ítems, también en las columnas

Una columna encendida y un ítem usable dicen lo mismo —**esto se puede gastar**—
y lo decían de dos maneras distintas: el ítem con el reflejo que lo cruza, la
columna latiendo. Ahora las dos llevan el reflejo, con el mismo enganche:

```js
(usable ? '<span class="i-brillo"></span>' : '')
```

Sólo en las que se pueden gastar. Si lo llevaran todas dejaría de significar
«ésta sí», que es exactamente para lo que está.

### El reloj de los ítems sirve tal cual

Los botones grandes del menú necesitaron su propio ciclo porque miden 350px y
con el de los ítems la luz se iba a 1.700 px/s, que es donde deja de leerse como
luz. Acá no hace falta: **un botón de columna mide casi lo mismo que un ítem**.

| | ancho | luz |
|---|---|---|
| ítem, a 402 | 76px | 486 px/s |
| columna, a 402 | **84px** | **538 px/s** |
| ítem, a 320 | 55px | 354 px/s |
| columna, a 320 | **63px** | **403 px/s** |

Un 10% de diferencia, que es la que hay entre los dos anchos, y las cuatro
medidas lejísimos del techo. Así que la columna usa `itemBrillo 1.5s` sin tocar
nada, y los retardos son los mismos —.19, .38 y .57— porque también son cuatro
botones en fila: saliendo juntos parecerían un parpadeo de la pantalla.

### Dos cosas que ya estaban y hacían falta

`.col-pick` tenía `overflow:hidden` desde que se arregló el texto largo que
rompía la mesa, así que el reflejo ya venía recortado. Lo que le faltaba era ser
el marco: era `position:static`, y `.i-brillo` va en absoluto, así que sin
`position:relative` el reflejo se ancla a la ventana y cruza la pantalla entera
en lugar del botón.

### Y se apaga donde ya se apagaba

Al pasar por encima o al armar la columna, el latido se cortaba con el argumento
de que «ya la estás mirando». El reflejo se corta con ella, por lo mismo: es lo
que te trae hasta acá, no algo para mirar una vez que llegaste. Comprobado:
con `.activo` puesta, `animation:none` y `opacity:0`.

Movimiento reducido ya lo cubría sin escribir nada: la regla general
`.i-brillo::after{animation:none;opacity:0}` alcanza a la columna igual que al
ítem, y le deja el mismo filo quieto.

### Lo que queda para decidir

**La columna encendida ahora tiene dos movimientos**: el reflejo nuevo y el
latido `titilarsuave` de 1,9s que ya tenía. Son dos períodos distintos —1,5 y
1,9— así que entran y salen de fase cada 7,1s.

El ítem, que es el modelo que se copió, **tiene sólo el reflejo**. Si se quiere
que digan lo mismo del todo, lo que sobra es el latido. Queda sin tocar porque
no se pidió, pero es la pregunta que abre este cambio.

## v243 · los dos penales, en verde y en rojo

La carta de **PENAL** pasa de celeste a **verde** y la de **PENAL RIVAL** se
queda en rojo, que ya lo era. Y las dos cambian la chapa del mini juego: los dos
muñecos de `#i-dos` dejan lugar a **la pelota**.

### Por qué el penal deja la familia del celeste

El celeste no es un color suelto: lo llevan PASE GOL, CÓRNER, TIRO LIBRE y sus
versiones del rival, y quiere decir «acá hay un porcentaje de gol en juego».
Pasar el penal a verde **rompe esa familia a propósito**: los otros son una
tirada que se resuelve sola, y el penal es un mini juego que jugás vos. Es la
misma razón por la que en v240 dejó de decir 67%.

Y el tono no es sólo el texto: pinta también el filo cuando tomás la fila, la
barra del pie de la carta y el pop-up que se abre al jugarla. Los tres cambian
juntos.

| | antes | ahora |
|---|---|---|
| PENAL | `tone:'gol'` · celeste | **`tone:'good'` · verde** |
| PENAL RIVAL | `tone:'bad'` · rojo | igual |

`isSafe` mira `tone !== 'bad'`, así que el penal a favor sigue contando como
carta segura: el cambio es de color, no de reglas.

### La pelota, porque las letras no entran

Decir «de gol» con letras no era posible. Medido en la chapa de la carta:

| | pide | hay |
|---|---|---|
| `MINI JUEGO DE GOL` a 402 | 78px | **71px** |
| `MINI JUEGO DE GOL` a 320 | 58px | **50px** |

Se corta en los dos anchos. Y el renglón de abajo tampoco alcanza: a 320 tiene
52px, y «GOL · PATEÁS» se parte en dos renglones y se sale 4px de la carta. Ahí
abajo entra **una palabra sola**.

Así que lo dice el dibujo. La chapa nueva —`CHAPA_MJ_GOL`— es la misma de
siempre con `#i-pelota` en lugar de `#i-dos`, y no gasta una letra: sigue
midiendo 64px a 402 y 47 a 320, igual que la de los duelos.

### Y la chapa toma el color de la carta

El dorado fijo sirve para los duelos, que son amarillos de riesgo. En el penal
contradecía lo que la carta dice, y el cartel terminaba con dos colores peleando
en tres centímetros. Ahora la chapa lleva la clase `gol` y hereda el tono:

```css
.cell.tono-good .c-out .mj-lb.gol{ ... verde ... }
.cell.tono-bad  .c-out .mj-lb.gol{ ... rojo ... }
```

Se queda el vidrio esmerilado; sólo cambian el filo y la tinta.

### Dónde sí y dónde no

La pelota va en las dos cartas **y en los dos pop-ups** —POSIBILIDAD DE GOL y SE
TERMINÓ EL AGUANTE—, porque es el mismo penal y si el dibujo es lo que dice «de
gol», tiene que decirlo en los dos lados. Ahí la chapa se queda dorada: no hay
tono de carta del que colgarse, y así mantiene la pinta de las otras cuatro
filas de la lista.

Los **duelos no se tocan**: DEFENSOR, ARQUERO, MEDIO y DELANTERO siguen con los
dos muñecos y la chapa dorada, que es lo que corresponde a «acá se juega contra
alguien».

### Medido

Con un tablero armado con los dos penales repetidos y la familia del celeste al
lado, a 402 y a 320:

| carta | tono | texto | chapa | ícono |
|---|---|---|---|---|
| PENAL | `tono-good` | verde | verde | `#i-pelota` |
| PENAL RIVAL | `tono-bad` | rojo | rojo | `#i-pelota` |
| PASE GOL · CÓRNER | `tono-gol` | celeste | — | — |
| JUGADA CLARA | `tono-good` | verde | — | — |
| DEFENSOR | `tono-risk` | dorado | dorada | `#i-dos` |

Nada cortado y nada fuera de la carta en ninguno de los dos anchos, con la chapa
en 47/47 a 320 y 64/64 a 402.

## v244 · atajar el penal del rival paga 2

Atajarlo daba **+1 ⚡**, lo mismo que despejar un córner en contra. Pero no es lo
mismo: es la única de las cuatro cartas del rival donde **el que patea tiene la
ventaja**.

| carta del rival | te hace el gol | te salvás | ⚡ al salvarte | ⚡ por jugada |
|---|---|---|---|---|
| CÓRNER RIVAL | 30% | 70% | +1 | **+0,40** |
| LIBRE RIVAL | 35% | 65% | +1 | **+0,30** |
| PASE GOL RIVAL | 40% | 60% | +1 | **+0,20** |
| PENAL RIVAL | **67%** | **33%** | +1 | **−0,33** |

Las otras tres **te regalan racha en promedio** y el penal era el único que te la
sacaba. Con +2 queda en **cero**: deja de restar y sigue siendo la más dura de
las cuatro, que es lo que corresponde a la que te hace el gol dos de cada tres
veces.

### Por qué 2 y no 3

Con 3 la carta pasaría a **+0,33 ⚡ por jugada**: más que el pase gol y el libre
del rival, y prácticamente lo mismo que el córner, que te hace el gol **menos de
la mitad de las veces** que el penal. Un penal en contra sería tan bueno para tu
racha como un córner en contra, y eso ya no se sostiene.

```
premio al atajar    ⚡ por jugada
   +1                  −0,33      el de antes
   +2                   0,00      el punto exacto de equilibrio
   +3                  +0,33      mejor que tres cartas menos peligrosas
```

El 2 no es un número al ojo: es donde `(1/3)·premio − (2/3)·1` da cero.

### Y paga igual venga de donde venga

El penal del rival sale de dos lados —la carta y la fundida— y los dos pagan 2.
Es el mismo mini juego y la misma atajada de 1 en 3, así que cobrarlo distinto
según el origen sería una asimetría sin motivo. Las otras situaciones en contra
siguen pagando 1, porque fallan mucho más seguido.

El penal **a favor** no se tocó: convertirlo sigue dando +1 ⚡ y el gol, que es
donde está el premio de verdad.

### Medido

Con la racha en 0: atajar suma **2**, las otras tres del rival suman **1**. Desde
3 el tope sigue recortando —queda en 4 de 4— y ahí se dispara el aviso de racha
llena, como con cualquier otra carta. La carta lo dice: **−1 ⚡ o +2 ⚡**.

## v245 · la columna cuesta 2 y se abre a mitad de camino

`COSTO_COLUMNA` pasa de **3 a 2**. La puerta baja sola: `colReady` se compara
contra esa misma constante, así que el botón que se habilitaba con 3 rayos ahora
se habilita con 2.

### El problema, medido

La columna casi no se usaba, y el precio era la razón: **costaba 3 de los 4
rayos que pide la situación de gol**, o sea que gastarla era renunciar a la
llegada.

Antes del ingreso hay que mirar la entrada. Por cada carta que sale, la racha se
mueve **+0,26 en promedio**: el 57,6% de las cartas no la toca, el 26,5% da +1,
el 4,7% da +2, el 10,1% la baja y el 1,1% la llena de golpe. A ese ritmo hacen
falta **casi 4 jugadas para ganar un rayo y unas 16 para llenar la barra** — más
de un partido y medio. El jugador no guardaba por avaricia: guardaba porque el
ingreso es lento.

En un campeonato entero —45 jugadas, con la racha arrastrándose de un partido al
siguiente— y guardándola siempre, la racha vive así:

| 0 ⚡ | 1 ⚡ | 2 ⚡ | 3 ⚡ | 4 ⚡ |
|---|---|---|---|---|
| 31,6% | 23,6% | 20,6% | 15,9% | **8,3%** |

Con la puerta en 3 el botón se habilitaba el **24,2%** de las jugadas. Con la
puerta en 2, el **44,7%**.

### Por qué las dos cosas y no una

Simulados 8.000 campeonatos con el mazo del juego y los efectos de racha leídos
de cada rama del código, con un jugador que gasta en columna cada vez que puede:

| regla | columnas | situaciones | botón habilitado |
|---|---|---|---|
| puerta 3, cuesta 3 | 3,9 | 1,4 | 11,8% |
| sólo el precio a 2 | 4,8 | 1,6 | 14,3% |
| sólo la puerta a 2 | 4,0 | 1,4 | 35,3% |
| **puerta 2, cuesta 2** | **7,7** | 0,9 | 19,1% |

Cada mitad sola no mueve nada: bajar el precio deja la columna encerrada detrás
de una puerta que se abre poco, y bajar la puerta abre un botón que no podés
pagar. Juntas dan **el doble de columnas**.

Y lo que de verdad cambia es el **tipo de cambio** — cuántas columnas compra
cada situación de gol que resignás:

```
hoy     3,9 ÷ (3,7 − 1,4) = 1,7 columnas
nuevo   7,7 ÷ (3,7 − 0,9) = 2,8 columnas
```

Un 60% mejor. Por 1,7 columnas nadie entregaba la llegada.

### El comentario ya decía 2

Arriba de la constante estaba escrito, palabra por palabra, el diseño de este
cambio: «la COLUMNA cuesta 2 y está disponible a mitad de camino… Guardar hasta
4 o gastar de a 2 es la decisión». Revisado el historial, **la constante nació en
3 en la v113 y nunca cambió**: el comentario no había quedado viejo, describía un
diseño que nunca se aplicó. Ahora coinciden.

### La línea de ayuda estrena un tercer estado

Tenía dos —racha llena o nada— y con la columna abriéndose a mitad de camino
quedaba un tramo, racha 2 o 3, donde se encendían cuatro botones dorados sin que
nada explicara qué hacían ni cuánto costaban. Ahora dice: «Podés gastar 2 en una
COLUMNA, o guardarla para la situación de gol».

### Medido en el juego

| racha | botones | costo | ayuda |
|---|---|---|---|
| 0 y 1 | apagados | −2 | «Elegí una FILA» |
| **2 y 3** | **encendidos** | −2 | «Podés gastar 2 en una COLUMNA…» |
| 4 | encendidos | −2 | «Racha llena…» |

Gastar una columna con 2 deja la racha en **0**, y `cobrarRacha` con 3 no hace
nada: la situación de gol sigue pidiendo la barra entera.

### Lo que queda para mirar

Gastando siempre, **la situación de gol cae de 3,7 a 0,9 por campeonato**. No es
un error del cambio: es la decisión funcionando, y el jugador real va a mezclar.
Pero la llegada es la jugada más vistosa del juego y 0,9 por campeonato es poco,
así que conviene volver a este número después de unas partidas.

Y si la columna sigue sin usarse, el número a mirar ya no es el precio: es el
**+0,26 de racha por carta**, que es lo que hace que la barra tarde 16 jugadas.

## v246 · ELIMINADO se queda con COMPARTIR solo

El pie de **ELIMINADO** pierde el botón **COPIAR**. Queda COMPARTIR solo y
centrado, exactamente como ya estaba CAMPEÓN.

### Por qué se va

El argumento que tenía escrito en el código era que en ELIMINADO «COPIAR es la
única salida al portapapeles». No lo era: COMPARTIR abre el menú nativo del
sistema —que en el celular ya ofrece copiar entre sus opciones— y donde no hay
menú abre WhatsApp Web con el texto puesto. COPIAR repetía eso con un botón más.

Y lo que costaba no era el espacio sino la atención. Las dos pantallas son el
remate de la corrida y tienen un solo botón que importa —el verde de arriba,
JUGAR OTRO CAMPEONATO o EMPEZAR DE NUEVO—. Con dos botones abajo, el pie pesaba
lo mismo que la acción principal. Con uno, no compite:

| | ancho |
|---|---|
| el verde de arriba | 328px |
| COMPARTIR | **155px** |

Es el mismo razonamiento por el que CAMPEÓN se había quedado con uno solo, y no
había razón para que la pantalla gemela se leyera distinto: misma banda, mismo
marcador, mismo cuerpo, mismo pie.

### Lo que se fue con él

`botonesFinal(campeon)` ya no decide nada, así que **pierde el parámetro** y
las dos pantallas la llaman igual. Quien sí necesita saber de dónde viene es
`engancharCompartir`, que lo lee de `G.phase` para armar el texto.

Con un solo `data-share` el `modo` es siempre `'wsp'`, así que las dos
líneas del portapapeles —`navigator.clipboard.writeText` y el «COPIADO ✓»—
**no se alcanzaban nunca**. Se fueron, junto con el símbolo `#i-copiar` del
sprite y las tres reglas de `.cta.chica.alt`, que era el contorno dorado del
botón que ya no existe.

La salida a mano se queda: si el sistema niega el menú —o lo devuelve
cancelado— sigue apareciendo el `textarea` con el texto seleccionado.

### El centrado deja de ser un modificador

Centrar era `.cta-fila.solo`, el caso especial de CAMPEÓN. Ahora no hay otro
caso, así que vive en `.cta-fila` y se fueron con él dos cosas que existían
sólo para la fila de dos: el `gap:8px` —no hay qué separar— y el `flex:1`
de `.cta.chica`, que partía la fila en mitades.

```css
.cta-fila{display:flex;justify-content:center;margin-top:16px}
.cta-fila .cta{width:auto;min-width:155px}
```

El `width:auto` sigue haciendo falta: sin él, el `width:100%` de `.cta`
estira el botón a toda la caja aunque la fila lo centre.

Ojo con el orden al tocar esto: `.cta-fila .cta` y `.cta.chica` tienen la
**misma especificidad**. Mientras `.cta.chica` conservaba `flex:1` había que
cuidar cuál iba después; sacándoselo, el problema desaparece.

### Medido

Las dos pantallas, en el mismo tab, forzando `matchLost` y `matchWon`:

| ancho | botones | COMPARTIR | izq / der | verde |
|---|---|---|---|---|
| 320 | 1 y 1 | 155 × 44 | 54 / 54 | 262 |
| 402 | 1 y 1 | 155 × 44 | 87 / 86 | 328 |
| 430 | 1 y 1 | 155 × 44 | 101 / 101 | 356 |

ELIMINADO y CAMPEÓN dan **el mismo número en los tres anchos**. El botón mide
155 en los tres —el `min-width` manda— con 106px de contenido adentro, así que
no se corta ni siquiera a 320, y no aparece scroll horizontal en ninguno. El
píxel de diferencia a 402 es el redondeo de una caja impar.

## v247 · el texto que se comparte dice el club y los rivales

El mensaje que sale del botón COMPARTIR nombra ahora **de qué club sos** y
**contra quién jugaste cada partido**.

### Lo que no había que hacer

El club y el rival **ya estaban guardados**: `matchWon` y `matchLost` empujan
`{ ronda, rival, gU, gC, pens, gano }` al historial desde siempre, y el nombre
del club vive en `G.club`. El texto simplemente no los escribía. No hizo falta
guardar un dato nuevo ni migrar nada —el juego no persiste partidas, así que
tampoco hay guardados viejos a los que les falte el rival—.

### Antes y ahora

```
⚽ DUELO FUTBOLERO              🏆 *¡CAMPEÓN!* · DUELO FUTBOLERO
                                👕 *RACING*
🏆 2 copas ganadas              🥇 2 copas ganadas

COPA 1:                         *COPA 1*
• CLASIFICATORIA  2-1           ✅ CLASIFICATORIA · 2-1 a *RIESTRA*
• OCTAVOS  1-0                  ✅ OCTAVOS · 1-0 a *BANFIELD*
• SEMIFINAL  1-1 (ganado…)      ✅ SEMIFINAL · 1-1 a *TALLERES* (en penales)
• LA FINAL  2-0                 🏆 LA FINAL · 2-0 a *BOCA*
```

Cuatro decisiones, cada una con su motivo:

1. **El club va solo, sin preámbulo.** La primera versión decía «Dirijo a
   *RACING*». El verbo no agrega nada que la camiseta no diga ya, y es la línea
   que más se mira.
2. **El rival en negrita.** Es el dato nuevo del mensaje; en redonda se perdía
   dentro de un renglón que ya tiene ronda, resultado y a veces un paréntesis.
3. **Se fueron los bullets.** El `•` sólo decía «esto es una lista». El tilde,
   la cruz y la copa de la final ocupan el mismo lugar y además dicen **cómo
   salió** el partido. La sangría no era opción: WhatsApp la muestra pero no
   separa.
4. **El resultado se lee como en la cancha:** «2-1 a Riestra» cuando ganaste,
   «1-3 con Vélez» cuando perdiste.

Los penales van al final entre paréntesis y **no reemplazan al tilde**: si lo
hicieran, un 0-0 ganado en penales y uno perdido se leerían igual.

### El formato del chat es el que hay

WhatsApp da `*negrita*`, `_cursiva_`, `~tachado~` y el bloque
monoespaciado, y nada más: no hay títulos, ni tablas, ni colores. La negrita se
gasta donde rinde —el club, cada rival y los títulos `*COPA 1*` y
`*ÚLTIMO INTENTO*`—, que es lo que hace que la lista se lea como lista.

Se descartaron dos formatos, los dos medidos:

- **El cruce**, con los dos equipos en cada renglón —`RACING 3-2 TIGRE`—.
  Es la lectura más futbolera, pero repite el club diez veces y **parte 3 de 14
  renglones** en un teléfono; cuando un renglón se corta, la lista deja de
  leerse como lista.
- **La tabla alineada** dentro del bloque monoespaciado, que es lo único del
  chat que respeta los espacios. Alinea bien —el renglón más largo mide 209px
  de los 286 que hay— pero obliga a abreviar las rondas a `8VOS`/`4TOS` y
  **adentro no entra ni un emoji**: no ocupan un caracter y corren toda la
  columna, así que el tilde tiene que quedar afuera del bloque.

### Medido

En una burbuja de 308px, que es el ancho de un teléfono común:

| mensaje | antes | ahora | renglones que se cortan |
|---|---|---|---|
| CAMPEÓN con dos copas | 338 | **485** | 1 de 15 |
| ELIMINADO con una copa | 279 | **393** | 0 de 13 |

Nombrar a diez rivales cuesta letras y ese es el precio. El único renglón que
se parte en dos es el de un nombre largo con penales encima —«CLASIFICATORIA ·
0-0 a *SARMIENTO* (en penales)»— y se parte **después del resultado**, así que
la línea sigue leyéndose.

Probado además con el sorteo real: `armarCopa()` reparte los rivales de la
tabla de equipos y el texto sale bien con los nombres largos de verdad
—`GIMNASIA MZA`, `INDEPENDIENTE`—, con las negritas pares en los dos
estados.

### Lo que falta mirar en un teléfono

Dos cosas que dependen de cómo dibuje WhatsApp y no se pueden medir acá: que la
negrita se vea como negrita en las dos plataformas, y **dónde aparece la
tarjeta de vista previa del link**, que probablemente va arriba de todo el
mensaje y no donde está escrito el link.

## v248 · el cartel de la jugada es la carta, en grande

El pop-up que salta al tocar una fila deja la receta vieja y toma la de la
carta de la mesa: **la foto a sangre**, con su encuadre y su velo, el escudo y
el nombre encima, y los números apoyados abajo.

### El desfasaje

La carta dejó la tira de foto en la v240 —foto a sangre, velo, nombre sobre la
imagen— y el cartel se quedó con la receta anterior: la ilustración recortada
en **una tira apaisada de 190px** con margen y esquinas redondeadas, y el
nombre debajo, sobre el panel. Tocabas una carta y el cartel que se abría
estaba hecho de otra cosa.

### Cuatro probadas, una elegida

Se armaron cuatro sobre el cartel real —el `.play` que devuelve
`mostrarJugada`, capturado del juego andando— y se midieron las seis familias
de carta por cinco anchos:

| | qué hacía | alto |
|---|---|---|
| **P1** la carta grande | foto de fondo, cinta arriba y banda oscura abajo | 317–520 |
| **P2** la cabecera a sangre | la tira crece y llega a los bordes, el panel se queda | 326–525 |
| **P3** la carta entera | dos tercios de imagen limpia, todo el texto abajo | **317–557** |
| **P4** la foto y nada más | sin bandas ni paneles, el texto flotando | 317–520 |

Ganó **P3**: es la única que copia el *orden* de la carta y no sólo su foto.

Y una diferencia que sólo apareció midiendo: **acostado, el cartel de hoy
rueda** —las seis cartas, medido— y P2 rueda igual, porque las dos atan la foto
a una altura fija. P1, P3 y P4 no: al soltar esa tira, el cartel se acomoda al
alto que hay.

### El escudo, al lado del nombre

El cartel tiene **dos escudos**: el chico de la cinta y el grande de la foto. El
código tenía escrito por qué —«el de la cinta acompaña al nombre del club y dice
de quién es la jugada; el de la foto es el que se ve de lejos y ata el cartel a
la carta que acabás de tocar»— pero eso se escribió **cuando la foto era una
tira aparte**. Con la foto a sangre los dos quedaban sobre la misma imagen, a
60px uno del otro.

Probados tres lugares abajo a la izquierda —arriba del nombre, al lado del
nombre, y clavado en la esquina—, quedó **al lado del nombre, los dos centrados
como un bloque**: lo que se lee es «este club, esta carta». Se descartó dejarlo
en la esquina de abajo: el escudo se montaba encima del bloque del resultado
—que ocupa todo el ancho y tiene fondo propio— en las seis cartas y en los cinco
anchos, y para arreglarlo había que correr el pie entero 58px.

El nombre lleva `min-width:0`, que es lo que le permite achicarse dentro del
flex; sin eso un nombre largo empuja al escudo fuera de la caja en vez de
partirse.

### Dos trampas del flex

1. **La cinta va en absoluto** sobre la foto. Si siguiera ocupando lugar
   empujaría la imagen hacia abajo y el cartel dejaría de ser una carta.
2. **Acostado, el sobrante se iba para arriba.** Con el texto pegado abajo
   —`justify-content:flex-end`— lo que no entra desborda **hacia arriba**, y se
   metía debajo de la cinta; el relleno no lo frena, porque el desbordado
   ignora el relleno. En ARQUERO —renglón de valor más resultado largo— el
   nombre entraba 6px por abajo de la cinta. Se arregla apoyando el contenido
   **arriba** en pantallas bajas: el sobrante se va hacia abajo, que es donde el
   cartel tiene su barra para rodar.

### Medido en el juego

Las **29 cartas** por cinco anchos, 145 casos, mirando alto, si rueda, si se
sale del velo y si se cruzan la cinta, el escudo, la chapa del valor y el
nombre:

| pantalla | alto | cruces | ruedan |
|---|---|---|---|
| 320 × 690 | 437 | 0 | 0 |
| 402 × 874 | 554 | 0 | 0 |
| 430 × 932 | 557 | 0 | 0 |
| 844 × 390 acostado | 317–326 | 0 | **1** (ARQUERO, 9px) |
| 1280 × 800 | 507 (541 de ancho) | 0 | 0 |

Acostado quedó **una sola carta rodando 9px**, donde antes rodaban las seis
medidas. Los topes de tamaño no se tocaron: sigue el `max-width:400px` de
celular y el `clamp(430px, 44vw, 720px)` de 1025 para arriba.

### La rama del emoji sigue viva

Todo cuelga de `.con-foto`, que se pone **sólo si la carta tiene
ilustración**. Hoy las 29 la tienen, así que la rama del emoji —`.p-ico`, para
una carta que todavía no tenga arte— no la usa nadie; la clase es lo que la deja
funcionando sin una foto de fondo que sostener.

## v249 · en pantallas bajas el pie de la carta deja de recortarse

En un **iPhone SE 2/3** —375 × 667— las dieciséis cartas del tablero perdían el
renglón del efecto: DEFENSOR mostraba «LA PERDÉS» sin su «−1 ❤», PASE GOL
mostraba «40% GOL» sin su «+1 ⚡». En el piso de 320 × 568 pasaba lo mismo.

### Por qué

La carta es una columna de flex con tres partes —título, hueco de la
ilustración y pie— y el hueco del medio **no se encogía**. Un item de flex en
columna no baja de lo que mide su contenido; eso es el `min-height:auto` que
trae de fábrica. Así que el hueco se plantaba en los 44px de la ilustración
aunque la carta midiera 95, y los píxeles que faltaban salían del último
renglón, que es el pie, comido por el `overflow:hidden` de la carta.

Medido en el SE 2/3, con la carta en 95px:

```
título   24
hueco    44   ← no se encogía
pie      34
huecos    8
        ────
        110   contra 86 de caja
```

### El arreglo

```css
.cell .c-ico{flex:1; min-height:0; …}
```

**Soltarlo no cuesta nada, porque la ilustración ya no vive ahí.** Desde la
v240 la pinta el fondo de la carta a sangre, y este hueco sólo guarda el
escudo, que va en absoluto y con `overflow:visible` —así que se sigue viendo
entero aunque el hueco se achique—. Donde hay lugar de sobra, de 390 para
arriba, el `flex:1` lo estira igual que siempre y no cambia absolutamente
nada.

Abajo de 639px de alto no alcanzaba ni con el hueco en cero —título 24 + pie 34
+ huecos 8 = 66 contra 62 de caja—, así que en ese tramo, que ya tenía su
bloque, se recortan además los milímetros que sobran: el título deja de
reservar 24px de alto, la carta baja un punto de relleno y el efecto junta su
interlínea. **El cuerpo de las letras no se toca**: lo que se saca es aire.

### Medido

Las 16 cartas del tablero, antes y después, con la animación de entrada ya
terminada —los rects mienten mientras corre—:

| pantalla | carta | recortadas antes | después |
|---|---|---|---|
| 320 × 568 · SE 1 | 62 × 71 | **16 de 16** | 0 |
| 360 × 640 · Android viejo | 72 × 88 | 16 de 16 | 0 |
| 375 × 667 · SE 2/3 | 76 × 95 | **16 de 16** | 0 |
| 360 × 800 · Galaxy | 72 × 128 | 1 de 16 | 0 |
| 390 × 844 · iPhone 12–16 | 80 × 139 | 0 | 0 |
| 402 × 874 · iPhone 17 Pro | 83 × 146 | 0 | 0 |
| 430 × 932 · Pro Max | 90 × 161 | 0 | 0 |
| 844 × 390 · acostado | 114 × 203 | 0 | 0 |
| 1280 × 800 | 185 × 226 | 0 | 0 |

**La carta mide exactamente lo mismo que antes en las nueve.** El escudo no se
sale de la carta en ninguna, y no aparece scroll horizontal en ninguna.

### Lo que sigue igual

El **corte del nombre a mitad de palabra** —DEFENSO/R, DELANTE/RO— se sigue
viendo, y se sigue dejando así a propósito: está documentado en la v240 con las
tres soluciones medidas.

## v250 · la foto del cartel deja de recortarse

La ilustración del cartel de la jugada se veía pixelada. No era el filtro ni el
navegador: era que **le estábamos tirando más de la mitad de los píxeles**.

### La cuenta

Las 29 ilustraciones miden **248 × 164** —apaisadas, 8 KB cada una, 230 KB en
total— y desde la v248 el cartel las muestra en una caja **parada** de 370 × 554.
Tapándola con `cover`, la imagen se escala 3,38× hasta 838 × 554, de los cuales
se ven 370: **se recorta el 56% del ancho**. Lo que se veía a pantalla completa
era un pedazo de **110 × 164** estirado.

| dónde | caja | 1x | 2x | 3x |
|---|---|---|---|---|
| carta del tablero | 83 × 146 | 0,89× | 1,78× | 2,67× |
| cartel viejo, la tira de 190px | 370 × 190 | 1,49× | 2,98× | 4,48× |
| **cartel de la v248** | 370 × 554 | 3,38× | 6,76× | **10,13×** |

En un iPhone de 3x el cartel pide 1110 × 1662 píxeles reales. Por eso saltó
ahora y no antes: v248 no rompió nada, pasó de agrandar 4,5× a agrandar 10×.

### Lo que se probó y lo que quedó

Se compararon tres arreglos sin arte nuevo, sobre el cartel real:

- **desenfoque parejo** y **desenfoque con grano**: no agregan detalle, cambian
  «pixelada» por «fuera de foco». Honestos como parche, pero no arreglan nada.
- **la foto entera**: dejar de recortarla. Esta es la que quedó.

Y después, tres formas de acomodarla: apoyada arriba, **centrada y fundida**, y
centrada con filo. Quedó la del medio.

### Cómo funciona

Dos capas de la **misma** imagen dentro de `.p-art`:

```
.p-fondo            cover, con su encuadre, blur(16px) y scale(1.14)
img:not(.p-fondo)   entera, ancho completo, centrada y fundida arriba y abajo
```

La de adelante va a `width:100%` con el alto que le toca, así que se agranda
**1,5× en vez de 3,4×** — la misma cuenta que tenía la tira del cartel viejo—.
Como es apaisada no llega a tapar el alto, y lo que falta lo tapa la de atrás,
desenfocada hasta que deja de leerse como imagen y pasa a ser color. La nítida
se funde en ella por los dos bordes con una máscara, así que **no hay filo en
ninguna parte**.

Las dos capas comparten el `src`, así que el navegador decodifica una sola
imagen: la segunda sale de su caché.

**El `ENCUADRE` de cada carta ya no encuadra la foto**, sólo la capa borrosa.
La nítida va entera y no hay nada que recortar.

### Una trampa que costó encontrar

Probando una variante que agrandaba la foto un 28%, el `width:128%` **no hacía
nada**: la regla global de `max-width:100%` le ponía de techo el ancho del
contenedor. Hay que decirle `max-width:none`. Es el mismo enredo que en la v176
dejó torcida la cabecera del vestuario y en la v170 la cinta del club.

### Medido

Las **29 cartas**, en el juego andando:

| pantalla | alto del cartel | franja nítida | cruces | ruedan |
|---|---|---|---|---|
| 360 × 800 | 507 | — | 0 | 0 |
| 402 × 874 | 554 | 225–226 | 0 | 0 |
| 844 × 390 acostado | 317–326 | — | 0 | 1 (ARQUERO, 9px) |

En las 29 hay dos capas, con el mismo `src`, la nítida a ancho completo y
centrada a menos de 3px del centro del cartel. Los topes de tamaño no se
tocaron.

### Esto es un parche

Con 248 × 164 no hay forma de llenar un teléfono de 3x sin agrandar. Lo que
sigue es **arte nuevo, parado**: con una fuente de 720 × 1010 el cartel
agrandaría 1,66× y la carta del tablero pasaría a **achicar**. Cuando llegue,
esto vuelve a ser un `cover` cambiando estas dos reglas por la de antes.
