# ⚽ FÚTBOL CESTO

Juego de **estrategia y suerte** en el navegador. Cinco partidos de eliminación
directa hasta ganar la copa.

No hay build, ni servidor, ni dependencias: es un solo archivo HTML.

---

## Cómo jugarlo

Abrí [`index.html`](index.html) en cualquier navegador. Doble click y listo.

## La mecánica en tres líneas

1. El partido es una **grilla de 4×4 jugadas**.
2. **No elegís la casilla: elegís la FILA.** El azar sortea cuál de sus casillas
   te toca.
3. Pero **ves todas las probabilidades antes de decidir**. La suerte está en
   cuál te toca, nunca en qué hace.

Cada casilla muestra en un cartelito qué te haría — `PASA`, `GOL`, `-1 ❤`,
`50% GOL`, `+ 🪙` — así que la decisión real no es *"¿a qué casilla entro?"*
sino *"¿qué reparto de resultados me conviene comprar con el aguante que me
queda?"*.

Cuando gastás una casilla, esa fila queda con menos casillas y **las que
sobreviven suben de probabilidad**: de 4 al 25% se pasa a 3 al 33%.

## Los recursos

| | Qué es |
|---|---|
| **AGUANTE** ❤ | El físico del equipo. Si llega a cero te hacen un gol y el equipo se funde |
| **MARCADOR** | Goles tuyos y del rival |
| **RELOJ** ⏱ | Jugadas que te quedan. El partido termina siempre por acá |
| **RACHA** ☀ | Se carga ganando duelos. Llena, podés atacar por **columna** |
| **DINERO** 🪙 | Para el mercado de pases entre partidos |

## Los stats

- **ATAQUE** 🔴 pelea contra defensores y arqueros — cuando atacás vos.
- **DEFENSA** 🔵 contra los delanteros rivales — cuando ataca el rival.

Si tu stat alcanza o supera el de la casilla, ganás el duelo. Subir un stat no
es "pegar más fuerte": es volverte **inmune a toda una clase de casillas**.

Ojo: los rivales se acomodan a tu plantel. Por cada 2 puntos que fichás, las
casillas de ese color suben 1. Fichar te deja mejor parado, pero no te regala
el partido.

---

## Archivos

| Archivo | Qué es |
|---|---|
| [`index.html`](index.html) | El juego completo — HTML, CSS y JS en un solo archivo |
| [`DISEÑO.md`](DISEÑO.md) | El diseño: todas las reglas, el catálogo de casillas y los números de balance |
| [`notas-sol-cesto.md`](notas-sol-cesto.md) | Apuntes del juego que sirvió de referencia para el sistema |

## Balance

Sobre 4.000 campeonatos simulados con un jugador que elige siempre la fila de
mejor valor esperado, la copa se gana el **21%** de las veces. Los marcadores
salen realistas: `1-0`, `3-0`, `2-1`.

Todo lo tuneable —probabilidades, valores de los rivales, pesos de cada casilla
y precios del mercado— está en tablas arriba del `<script>`, separado de la
lógica.

---

## Para subir cambios

Doble click en `subir.bat`.
