# Lab 2 - Multiplicador con display BCD (EDig 30315)

Proyecto VHDL para implementar un multiplicador de números enteros con signo en una placa Basys3, mostrando el resultado en un display de 7 segmentos mediante conversión BCD.

## Estructura de Directorios

```
30315_lab2_solutions/
├── README.md              # Este archivo
├── constraints/           # Restricciones de pines y timing
│   ├── 01_timing.xdc      # Restricciones de timing del reloj
│   └── 02_basys3_io.xdc   # Asignación de pines I/O de la placa Basys3
├── doc/                   # Documentación adicional
├── rtl/                   # Diseño lógico (RTL)
│   ├── lab2.vhd           # Módulo principal del multiplicador
│   └── doubledabble12b.vhd# Conversor binario a BCD (algoritmo Double-Dabble)
├── sim/                   # Testbench para simulación
│   └── lab2_tb.vhd        # Testbench del multiplicador
├── scripts/               # Scripts de automatización
│   └── lab.tcl            # Script Tcl para crear el proyecto en Vivado
└── vivado/                # Proyecto Vivado (generado al ejecutar el script)
```

## Funcionalidad Implementada

### Módulo Principal (`lab2.vhd`)

El módulo principal implementa un **multiplicador de 6 bits con signo** que:

1. **Entrada A y B**: Dos números de 6 bits cada uno (valores de -32 a +31)
2. **Multiplicación**: Realiza el producto `A × B` generando un resultado de 12 bits
3. **Conversión BCD**: Convierte el valor absoluto del producto a BCD (Binary Coded Decimal) usando 4 dígitos
4. **Manejo de Signo**: Indica el signo del producto (positivo o negativo) en el dígito más significativo
5. **Display de 7 Segmentos**: Muestra cada dígito del resultado en un display de 7 segmentos
6. **Interfaz de Selección**: Permite seleccionar qué dígito mostrar mediante 5 botones (SEL[4:0])

### Interfaz de Puertos

| Puerto     | Ancho  | Dirección | Descripción                              |
|------------|--------|-----------|------------------------------------------|
| `A[5:0]`   | 6 bits | Entrada   | Multiplicando (switches 0-5)             |
| `B[5:0]`   | 6 bits | Entrada   | Multiplicador (switches 8-13)            |
| `SEL[4:0]` | 5 bits | Entrada   | Selector de dígito y función (botones)   |
| `SS[6:0]`  | 7 bits | Salida    | Segmentos del display (a-g)              |
| `AN[3:0]`  | 4 bits | Salida    | Control de ánodos (selección de display) |

### Mapa de Selección (SEL)

| SEL    | Función                     |
|--------|-----------------------------|
| `0001` | Muestra dígito de unidades  |
| `0010` | Muestra dígito de decenas   |
| `0100` | Muestra dígito de centenas  |
| `1000` | Muestra signo (en millares) |

### Módulo Double-Dabble (`doubledabble12b.vhd`)

Implementa la conversión de números binarios (12 bits) a BCD mediante el **algoritmo Double-Dabble**, que:

- Genera una salida BCD de 16 bits (4 dígitos de 4 bits cada uno)
- Referencia: https://johnloomis.org/ece314/notes/devices/binary_to_BCD/bin_to_bcd.html

## Configuración de Hardware (Basys3)

### Entradas
- **Switches A (sw0-sw5)**: Primer operando (6 bits)
- **Switches B (sw8-sw13)**: Segundo operando (6 bits)
- **Botones (btnR, btnC, btnL, btnU, btnD)**: Selectores (SEL[0:4])

### Salidas
- **Display de 7 Segmentos (AN0-AN3)**: Muestra el resultado del producto

## Cómo Crear el Proyecto Vivado

### Requisitos Previos
- Vivado Design Suite instalado (versión compatible con Basys3)
- Placa Basys3 conectada (para programación)

### Procedimiento para crear el proyecto Vivado:

#### Opción 1: Usar el script TCL desde Vivado GUI

1. Abre **Vivado**
2. Selecciona **Tools → Run Tcl Script** (o usa el menú desplegable en la consola TCL)
3. Navega a `scripts/lab.tcl` y selecciona el archivo
4. El script creará automáticamente el proyecto en `vivado/` con todas las fuentes y restricciones

#### Opción 2: Ejecutar el script desde línea de comandos

```bash
# En Windows (desde el directorio del proyecto)
vivado -mode batch -source scripts/lab.tcl

# En Linux/Mac
vivado -mode batch -source scripts/lab.tcl
```

#### Opción 3: Ejecutar manualmente en la consola TCL de Vivado

1. Abre Vivado
2. En la **TCL Console** (parte inferior de la ventana), ejecuta:
   ```tcl
   source scripts/lab.tcl
   ```

### Después de Crear el Proyecto

Una vez creado, el proyecto abrirá en Vivado con:

- ✅ Fuentes de diseño VHDL cargadas (`rtl/`)
- ✅ Testbench listo para simulación (`sim/`)
- ✅ Restricciones de pines aplicadas (`constraints/`)
- ✅ Configuración de síntesis y implementación lista

Desde Vivado podrás:
- 🧪 **Simular** el comportamiento (Flow → Run Simulation)
- 🔨 **Sintetizar** el diseño (Flow → Run Synthesis)
- 📋 **Implementar** en hardware (Flow → Run Implementation)
- 📥 **Generar bitstream** para programar la Basys3 (Flow → Generate Bitstream)

## Detalles del Script TCL

El script `lab.tcl` realiza las siguientes operaciones:

1. **Crea el proyecto** en `vivado/` con dispositivo `xc7a35tcpg236-1` (Basys3)
2. **Configura el lenguaje** a VHDL para síntesis y simulación
3. **Añade archivos de diseño** desde `rtl/`
4. **Añade testbench** desde `sim/` como fileset de simulación
5. **Añade restricciones** desde `constraints/`
6. **Excluye archivos de síntesis** si es necesario (solo simulación)

## Notas de Implementación

- El diseño está optimizado para la FPGA **Artix-7** de la Basys3
- Los switches de entrada están mapeados a los pines especificados en `02_basys3_io.xdc`
- El display de 7 segmentos es un display de cátodo común
- El resultado del multiplicador soporta(máximo: -32 × -32 = 1024, -32 × 31 = -992, 31 × 31 = 961)

## Archivos Principales

| Archivo                                                      | Descripción                        |
|--------------------------------------------------------------|------------------------------------|
| [rtl/lab2.vhd](rtl/lab2.vhd)                                 | Módulo principal del multiplicador |
| [rtl/doubledabble12b.vhd](rtl/doubledabble12b.vhd)           | Conversor BCD                      |
| [sim/lab2_tb.vhd](sim/lab2_tb.vhd)                           | Testbench para verificación        |
| [scripts/lab.tcl](scripts/lab.tcl)                           | Script de creación del proyecto    |
| [constraints/02_basys3_io.xdc](constraints/02_basys3_io.xdc) | Mapeo de pines I/O                 |
| [constraints/01_timing.xdc](constraints/01_timing.xdc)       | Restricciones de timing            |


---

**Versión**: 1.0
**Último actualizado**: 28/01/2026
**Plataforma**: Basys3 (Artix-7 XC7A35T)
