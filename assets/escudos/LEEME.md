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

## Los escudos reales (v294)

El juego muestra los escudos reales de los treinta clubes, que están en
`reales/`. Los SVG de esta carpeta son los dibujados de antes. Siguen sirviendo
de referencia, y el juego los vuelve a usar con `?escudos=dibujados`.

| archivo | qué es |
|---|---|
| `reales/<club>-192.webp` | 160×192, para todo lo que se ve de 17 a 70px (~8 KB) |
| `reales/<club>-600.webp` | 500×600, para el escudo grande de la elección de club (120px, ~26 KB) |

Salen de los PNG originales de 1500px, con el margen transparente recortado y
el escudo centrado en una caja 5:6. Es la misma proporción que el dibujo
(100×120), y por eso la imagen ocupa exactamente el mismo lugar en todas las
pantallas. Para cambiar un escudo hay que regenerar los dos tamaños con ese
mismo recorte.
