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
