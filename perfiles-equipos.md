# Perfiles de los equipos (propuesta B · en análisis, todavía no aplicada)

Datos guardados el 25 de septiembre de 2026 para la propuesta **B** de los stats:
sacar el «espejo» —que las cartas de duelo suban 1 cada 2 puntos de tus stats— y
darle a cada rival un **perfil fijo** que cambia el mazo de duelos:

- **OFENSIVO**: más medios y delanteros → conviene subir **DEFENSA**.
- **DEFENSIVO**: más defensores y arqueros → conviene subir **ATAQUE**.
- **PAREJO**: el mazo de siempre.

Nada de esto está en el juego todavía (v268). Pendiente: simular campañas
completas, decidir cuánto endurecer semifinal y final, prototipo jugable y el
diseño de cómo se muestra el perfil en la pantalla del refuerzo.

## Cómo se calculó

Goles a favor y en contra por partido de cada equipo, sumando la **temporada
2025** (tabla general, 32 partidos) y el **Torneo Apertura 2026** (16
partidos). Los dos ascendidos —Estudiantes de Río Cuarto y Gimnasia de
Mendoza— sólo tienen los 16 del Apertura 2026.

- media de la liga: **1,015** goles por equipo por partido
- **ataque** = goles a favor por partido − media (+ = convierte más que la media)
- **defensa** = media − goles en contra por partido (+ = recibe menos que la media)
- **perfil**: si ataque − defensa > 0,12 → OFENSIVO; si < −0,12 → DEFENSIVO; si no, PAREJO

Resultado: 10 ofensivos, 10 defensivos, 10 parejos. Revisado y aprobado tal
cual. Tres salen del lado «menos malo» de equipos flojos en las dos cosas
(Newell's, Estudiantes de Río Cuarto, Gimnasia de Mendoza); se decidió
dejarlos como dio el cálculo.

### 16AVOS

| Equipo | PJ | GF/PJ | GC/PJ | Ataque | Defensa | Perfil |
|---|---|---|---|---|---|---|
| I. RIVADAVIA | 48 | 1.31 | 1.02 | +0.30 | -0.01 | **OFENSIVO** |
| GIMNASIA MZA | 16 | 0.88 | 1.38 | -0.14 | -0.36 | **OFENSIVO** |
| ALDOSIVI | 48 | 0.77 | 1.35 | -0.24 | -0.34 | **PAREJO** |
| SARMIENTO | 48 | 0.77 | 1.17 | -0.24 | -0.15 | **PAREJO** |
| EST. RÍO IV | 16 | 0.31 | 1.50 | -0.70 | -0.48 | **DEFENSIVO** |
| RIESTRA | 48 | 0.77 | 0.65 | -0.24 | +0.37 | **DEFENSIVO** |

### OCTAVOS

| Equipo | PJ | GF/PJ | GC/PJ | Ataque | Defensa | Perfil |
|---|---|---|---|---|---|---|
| DEFENSA | 48 | 1.04 | 1.29 | +0.03 | -0.28 | **OFENSIVO** |
| TUCUMÁN | 48 | 1.02 | 1.31 | +0.01 | -0.30 | **OFENSIVO** |
| BANFIELD | 48 | 0.96 | 1.23 | -0.06 | -0.21 | **OFENSIVO** |
| BARRACAS | 48 | 1.13 | 1.04 | +0.11 | -0.03 | **OFENSIVO** |
| C. CÓRDOBA | 48 | 1.02 | 1.13 | +0.01 | -0.11 | **PAREJO** |
| PLATENSE | 48 | 0.73 | 1.06 | -0.29 | -0.05 | **DEFENSIVO** |

### CUARTOS

| Equipo | PJ | GF/PJ | GC/PJ | Ataque | Defensa | Perfil |
|---|---|---|---|---|---|---|
| UNIÓN | 48 | 1.15 | 1.04 | +0.13 | -0.03 | **OFENSIVO** |
| INSTITUTO | 48 | 0.88 | 1.13 | -0.14 | -0.11 | **PAREJO** |
| GIMNASIA LP | 48 | 0.88 | 1.10 | -0.14 | -0.09 | **PAREJO** |
| ARGENTINOS | 48 | 1.23 | 0.73 | +0.21 | +0.29 | **PAREJO** |
| BELGRANO | 48 | 0.90 | 0.98 | -0.12 | +0.04 | **DEFENSIVO** |
| TIGRE | 48 | 1.04 | 0.83 | +0.03 | +0.18 | **DEFENSIVO** |

### SEMIFINAL

| Equipo | PJ | GF/PJ | GC/PJ | Ataque | Defensa | Perfil |
|---|---|---|---|---|---|---|
| NEWELL'S | 48 | 0.83 | 1.35 | -0.18 | -0.34 | **OFENSIVO** |
| ESTUDIANTES | 48 | 1.13 | 0.92 | +0.11 | +0.10 | **PAREJO** |
| CENTRAL | 48 | 1.25 | 0.67 | +0.23 | +0.35 | **PAREJO** |
| LANÚS | 48 | 1.06 | 0.81 | +0.05 | +0.20 | **DEFENSIVO** |
| HURACÁN | 48 | 0.96 | 0.83 | -0.06 | +0.18 | **DEFENSIVO** |
| TALLERES | 48 | 0.77 | 0.83 | -0.24 | +0.18 | **DEFENSIVO** |

### LA FINAL

| Equipo | PJ | GF/PJ | GC/PJ | Ataque | Defensa | Perfil |
|---|---|---|---|---|---|---|
| BOCA | 48 | 1.54 | 0.67 | +0.53 | +0.35 | **OFENSIVO** |
| INDEPENDIENTE | 48 | 1.27 | 0.94 | +0.26 | +0.08 | **OFENSIVO** |
| RACING | 48 | 1.23 | 0.92 | +0.21 | +0.10 | **PAREJO** |
| RIVER | 48 | 1.31 | 0.75 | +0.30 | +0.27 | **PAREJO** |
| VÉLEZ | 48 | 0.92 | 0.96 | -0.10 | +0.06 | **DEFENSIVO** |
| SAN LORENZO | 48 | 0.85 | 0.73 | -0.16 | +0.29 | **DEFENSIVO** |

## Fuentes

- [Campeonato de Primera División 2025 (Argentina) – Wikipedia](https://es.wikipedia.org/wiki/Campeonato_de_Primera_Divisi%C3%B3n_2025_(Argentina))
- [Anexo:Torneo Apertura 2026 (Argentina) – Wikipedia](https://es.wikipedia.org/wiki/Anexo:Torneo_Apertura_2026_(Argentina))
