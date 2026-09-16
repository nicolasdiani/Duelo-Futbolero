# Los escudos

Los treinta clubes de la Primera 2026, dibujados con el sistema del juego.

## Por qué no hay versiones por tamaño

Son SVG: **el mismo archivo sirve para todos los tamaños**. No tienen `width`
ni `height`, solo `viewBox="0 0 100 120"`, así que se dibujan del tamaño que
les dé quien los usa. Una copia a 26px y otra a 150px serían el mismo archivo
pesando el doble.

Los tres tamaños en que el juego los muestra son **26** (marquesina), **34**
(marcador) y **58** (chapa de remate), pero eso se pide al usarlos:

```html
<img src="assets/escudos/boca.svg" width="26" height="31" alt="Boca">
```

La proporción es 100 &times; 120, o sea **ancho = alto &times; 0.83**.

## Qué hay acá

| archivo | qué es |
|---|---|
| `<club>.svg` | uno por club, 30 en total, escalables |
| `sprite.svg` | los treinta en un archivo, para usar con `<use>` |
| `equipos.json` | los datos: siluetas, patrones, colores y los 30 clubes |

Con el sprite, un escudo se pone así:

```html
<svg width="34" height="41"><use href="assets/escudos/sprite.svg#esc-racing"/></svg>
```

## Si hacen falta PNG

Estos no sirven para algo que no entienda SVG —una imagen de redes, un
favicon—. Para eso hay que rasterizarlos, y ahí sí conviene una copia por
tamaño. No están hechos: se piden cuando aparezca el caso.

## Lo que de verdad es el asset

Los SVG son una **salida**, no la fuente. El escudo es una función de cinco
campos —silueta, dibujo, color de fondo, color de detalle y nombre— y eso vive
en `equipos.json`. Si cambia un color de un club, se cambia ahí y se vuelven a
generar los treinta; no se edita un SVG a mano.
