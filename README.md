# ⚽ DUELO FUTBOLERO

Juego de **estrategia y suerte** en el navegador. Cinco partidos de eliminación
directa hasta ganar la copa.

No hay build, ni servidor, ni dependencias: es un solo archivo HTML.

---

## Cómo jugarlo

Abrí [`index.html`](index.html) en cualquier navegador. Doble click y listo.

## La mecánica en tres líneas

1. El partido es una **grilla de 4×4 jugadas**.
2. **No elegís la carta: elegís la FILA.** El azar sortea cuál de sus cartas
   te toca.
3. Pero **ves todas las probabilidades antes de decidir**. La suerte está en
   cuál te toca, nunca en qué hace.

Cada carta muestra en un cartelito qué te haría — `PASA`, `GOL`, `-1 ❤`,
`50% GOL`, `+€16-28M` — y las de porcentaje muestran también qué pasa si **no**
entra, porque ninguna se desperdicia: las tuyas te dan racha, las del rival te
cuestan aguante. Así la decisión real no es *"¿a qué carta entro?"*
sino *"¿qué reparto de resultados me conviene comprar con el aguante que me
queda?"*.

Cuando gastás una carta, esa fila queda con menos cartas y **las que
sobreviven suben de probabilidad**: de 4 al 25% se pasa a 3 al 33%.

## Los recursos

| | Qué es |
|---|---|
| **AGUANTE** ❤ | El físico del equipo. Si llega a cero el rival se gana una situación de gol y se rellena. Son 4, siempre |
| **MARCADOR** | Goles tuyos y del rival |
| **TIEMPO DE JUEGO** ⏱ | Los 90 minutos. Cada jugada gasta 10, así que son 9 por partido |
| **RACHA** ☀ | Se carga ganando duelos. Llena, elegís: una **situación de gol** o atacar por **columna** |
| **PRESUPUESTO** € | En millones. Sale **solo** de las cartas de taquilla: ganar un partido no paga |

## Los stats

- **ATAQUE** 🔴 pelea contra defensores y arqueros — cuando atacás vos.
- **DEFENSA** 🔵 contra los delanteros rivales — cuando ataca el rival.

Si tu stat alcanza o supera el de la carta, ganás el duelo. Subir un stat no
es "pegar más fuerte": es volverte **inmune a toda una clase de cartas**.

Entre partido y partido elegís **un refuerzo**: +1 ATAQUE o +1 DEFENSA. No se
compran con plata — la plata es solo para ítems.

Ojo: los rivales se acomodan a tu plantel. Por cada 2 puntos que sumás, las
cartas de ese color suben 1. Reforzar te deja mejor parado, pero no te regala
el partido.

---

## Archivos

| Archivo | Qué es |
|---|---|
| [`index.html`](index.html) | El juego completo — HTML, CSS y JS en un solo archivo |
| [`DISEÑO.md`](DISEÑO.md) | El diseño: todas las reglas, el catálogo de cartas y los números de balance |
| [`notas-sol-cesto.md`](notas-sol-cesto.md) | Apuntes del juego que sirvió de referencia para el sistema |

## Balance

Sobre 4.000 campeonatos simulados con un jugador que elige siempre la fila de
mejor valor esperado, la copa se gana el **21%** de las veces. Los marcadores
salen realistas: `1-0`, `3-0`, `2-1`.

Todo lo tuneable —probabilidades, valores de los rivales, pesos de cada carta
y precios del mercado— está en tablas arriba del `<script>`, separado de la
lógica.

---

## Para subir cambios

Doble click en `subir.bat`.

---

## Licencia

**Copyright © 2026 Nicolás Diani. Todos los derechos reservados.**

Podés jugarlo y leer el código para aprender. No podés redistribuirlo,
alojarlo en otro dominio, venderlo ni publicar obras derivadas sin permiso
por escrito. Ver [`LICENSE`](LICENSE) para los términos completos.
