# Notas de referencia — Sol Cesto

Apuntes tomados de las capturas que me pasó el usuario. Sirven como referencia
de diseño para el juego propio, no como especificación final.

## Estructura de pantalla

Tres columnas:

| Zona | Contenido |
|---|---|
| Izquierda | Ventana de descripción + inventario + libro de modificadores |
| Centro | Grilla de la mazmorra (4×4) |
| Derecha | Personaje con sus stats + puerta + sapo |

## Grilla central — la mazmorra

- Grilla de **4×4 casillas**. Cada casilla contiene un elemento: un monstruo,
  un cofre, u otras cosas.
- El contenido es **visible antes de entrar**: monstruo con su daño (⚔ 3),
  cofre con recompensa incierta (? oro), slime con daño mágico (🔵 1).

### Resolución del combate: comparación de stats

El personaje tiene dos stats:

- **Ataque (rojo) ⚔** — en la captura, 2
- **Magia (azul) 🔵** — en la captura, 1

Cada monstruo o elemento tiene su propio valor de ataque o de magia. Cuando la
casilla te toca al azar, **se compara tu stat contra el de la casilla**:

- Si tu stat **alcanza o supera** al del elemento → lo **matás**, no perdés vida.
- Si el elemento **te supera** → **te quita vida**.

**El color del número indica con qué stat se compara**: los valores rojos contra
tu Ataque, los azules contra tu Magia.

#### Verificación contra la captura del tablero

Personaje: ⚔ 2 · 🔵 1. Fila activa:

| Casilla | Valor | Stat comparado | Resultado mostrado |
|---|---|---|---|
| Monstruo | ⚔ 3 | ⚔ 2 → pierde | `❤-1` |
| Slime verde | 🔵 1 | 🔵 1 → empata | `❤ok` |
| Frutilla | — | — | `❤+1` |
| Monstruo | ⚔ 3 | ⚔ 2 → pierde | `❤-1` |

Encaja exacto. La lectura del sistema queda confirmada.

#### Por qué esto importa para el diseño

Subir un stat no significa "hacer más daño": significa volverse **inmune a toda
una clase de casillas**. Pasar de ⚔2 a ⚔3 hace que todos los monstruos de valor
3 dejen de lastimarte de golpe.

El tablero no cambia — cambia lo que el tablero te puede hacer. Por eso mirar la
grilla y contar cuántas casillas te lastiman *hoy* es la decisión estratégica
central, y por eso conviene tener dos stats: te obliga a elegir en qué te
especializás, y ninguna mejora te vuelve inmune a todo.

### Los tres efectos posibles

Sea cual sea el elemento, lo que hace se reduce a tres resultados:

| Efecto | Ejemplo |
|---|---|
| **Quita vida** | Monstruos (⚔ 3), slimes (🔵 1) |
| **Da vida** | La frutilla / casillas de curación (`❤+1`) |
| **Da monedas** | Cofres (`? oro`) |

Y existe el resultado neutro (`❤ok`): la casilla no te hace nada.

Esto mantiene el juego simple de leer: por más variedad de elementos que haya,
el jugador siempre está evaluando la misma pregunta — cuánta vida arriesgo
contra cuánta vida u oro puedo ganar.

### LA MECÁNICA CENTRAL

**No elegís una casilla: elegís una FILA entera.** Después el juego sortea al
azar cuál de las casillas de esa fila te toca.

Por eso la fila activa muestra `25%` en cada una de sus 4 casillas: esa es la
probabilidad de que te toque. Arriba de cada casilla se ve el resultado que
traería (`❤-1`, `❤ok`, `❤+1`, `❤-1`).

La decisión real no es *"¿a qué casilla entro?"* sino
**"¿qué distribución de resultados compro?"**. Mirás las 4 casillas de cada
fila, evaluás el reparto, y elegís según la vida que te queda.

**La suerte está expuesta como información, no escondida como sorpresa.** Ves
las probabilidades exactas y tenés que decidir igual.

### Consecuencia de diseño: manipular la probabilidad

Si una fila tiene 4 casillas, cada una es 25%. Si sacás una del tablero, las
tres restantes pasan a 33%.

Por eso la flecha (*"destruye un monstruo a elección"*) no es un ítem de daño:
es un ítem de **manipulación de probabilidades**. Sacás la peor casilla de una
fila y mejorás las chances de todo lo bueno que queda ahí.

Cualquier ítem futuro debería pensarse con esta lógica: no "cuánto daño hace"
sino "cómo altera el reparto".

## Panel derecho — personaje y progreso

De arriba hacia abajo:

1. **Corazón (5/5)** — la vida del personaje.
2. **Sol (0/4)** — se va cargando durante la corrida. **Cuando lo completás,
   podés elegir una COLUMNA en vez de una fila.** Cambia el eje de selección:
   la columna ofrece otras 4 casillas con otra distribución. Es el recurso de
   escape para cuando ninguna fila te sirve.
3. **Personaje** con sus stats: ataque **⚔ 2** y defensa/magia **🔵 1**.
4. **Puerta (0/5)** — la salida del piso. Hay que **completar 5 intentos**
   para poder avanzar al siguiente nivel. Es el reloj de la corrida: define
   cuántas decisiones te quedan antes de salir.
5. **Sapo (0)** — el monedero. **Junta las monedas** que sacás de los cofres, y
   con esas monedas después **comprás ítems**.

La tensión del diseño está acá: la puerta te da un número fijo de intentos, así
que cada intento gastado en farmear oro es un intento que no gastás en avanzar
seguro. Vida, intentos y oro son tres recursos que compiten entre sí.

## Carta de entidad (ejemplo: The Knight)

Cada entidad es una carta con:
- Vida (5)
- Ataque (2) y valor defensivo/mágico (1)
- Valor de recompensa (4, flor dorada)
- **Regla de comportamiento**: "se mueve al azar en línea vertical"
- Slots de equipamiento (casco, arma, guantes, botas)
- Texto de sabor sin peso mecánico

## Inventario e ítems

Panel izquierdo con slots de ítems. Al señalar uno, la **ventana superior
muestra su descripción**.

| Ítem | Efecto |
|---|---|
| Frasco rojo | Cura 1 punto de vida |
| Flecha / dardo | Destruye un monstruo a elección |

## Libro de modificadores (abajo a la izquierda)

Modificadores porcentuales acumulados durante la corrida:
⚔ +0% · 🔑 +0% · ❤ +0% · 📦 +0% · 🎩 x1 · ⛰ +0%

## Pendiente de confirmar

- Cómo se carga el Sol (¿matando monstruos? ¿con las flores doradas que dan de
  recompensa las cartas de entidad?)
- Qué cuenta como "intento" para la puerta: ¿cada fila que elegís?
- Qué pasa con la casilla después de resolverse: ¿se vacía? ¿se repone?
- Los demás tipos de casilla del tablero y qué hace cada uno
- Dónde se compran los ítems con las monedas del sapo
- Qué querés replicar y qué querés cambiar en tu versión
