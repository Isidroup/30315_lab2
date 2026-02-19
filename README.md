# Lab 2 - Multiplicador con Display BCD

Proyecto VHDL para implementar un multiplicador de números enteros con signo en una placa Basys3, mostrando el resultado en un display de 7 segmentos mediante conversión BCD.

## 📋 Descripción General

Este proyecto implementa un **multiplicador de 6 bits con signo** que visualiza el resultado en displays de 7 segmentos utilizando codificación BCD.

### Características Principales

- **Multiplicación con signo**: Entradas de 6 bits (valores de -32 a +31)
- **Resultado**: 12 bits con manejo de signo
- **Conversión BCD**: Algoritmo Double-Dabble para conversión binario a decimal
- **Display 7 segmentos**: 4 dígitos multiplexados
- **Interfaz de selección**: Control por botones para visualizar cada dígito
- **Plataforma**: FPGA Xilinx Basys3 (Artix-7)

---

## 📁 Estructura del Proyecto

```
30315_lab2/
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
│   └── lab.tcl            # Script TCL para crear el proyecto en Vivado
└── vivado/                # Proyecto Vivado (generado al ejecutar el script)
```

---

## 🔧 Especificaciones Técnicas

### Módulo Principal (`lab2.vhd`)

El módulo principal implementa un **multiplicador de 6 bits con signo** con las siguientes características:

1. **Entrada A y B**: Dos números de 6 bits cada uno (valores de -32 a +31)
2. **Multiplicación**: Realiza el producto `A × B` generando un resultado de 12 bits
3. **Conversión BCD**: Convierte el valor absoluto del producto a BCD usando 4 dígitos
4. **Manejo de Signo**: Indica el signo del producto en el dígito más significativo
5. **Display de 7 Segmentos**: Multiplexación para mostrar cada dígito
6. **Interfaz de Selección**: Control mediante 5 botones (SEL[4:0])

### Interfaz de Puertos

| Puerto     | Ancho  | Tipo    | Descripción                              |
|------------|--------|---------|------------------------------------------|
| `A[5:0]`   | 6 bits | Entrada | Multiplicando (switches 0-5)             |
| `B[5:0]`   | 6 bits | Entrada | Multiplicador (switches 8-13)            |
| `SEL[4:0]` | 5 bits | Entrada | Selector de dígito y función (botones)   |
| `SS[6:0]`  | 7 bits | Salida  | Segmentos del display (a-g)              |
| `AN[3:0]`  | 4 bits | Salida  | Control de ánodos (selección de display) |

### Rango de Operación

| Parámetro        | Valor                             |
|------------------|-----------------------------------|
| **Entrada A**    | -32 a +31 (6 bits con signo)      |
| **Entrada B**    | -32 a +31 (6 bits con signo)      |
| **Producto máx** | -32 × -32 = 1024                  |
| **Producto mín** | -32 × 31 = -992                   |
| **Rango BCD**    | 0000 a 1024 (4 dígitos decimales) |

### Información del Dispositivo

- **FPGA**: Xilinx Artix-7 (xc7a35tcpg236-1)
- **Placa**: Digilent Basys3
- **Lenguaje**: VHDL
- **Display**: 7 segmentos de cátodo común

---

## 📊 Funcionalidad

### Mapa de Selección (SEL)

| SEL    | Función                     |
|--------|-----------------------------|
| `0001` | Muestra dígito de unidades  |
| `0010` | Muestra dígito de decenas   |
| `0100` | Muestra dígito de centenas  |
| `1000` | Muestra signo (en millares) |

### Algoritmo de Conversión BCD

El módulo [doubledabble12b.vhd](rtl/doubledabble12b.vhd) implementa el **algoritmo Double-Dabble** para conversión binario a BCD:

- Entrada: Número binario de 12 bits
- Salida: 4 dígitos BCD (16 bits = 4 × 4 bits)
- Método: Shift-and-add-3 iterativo
- Referencia: [Binary to BCD Conversion](https://johnloomis.org/ece314/notes/devices/binary_to_BCD/bin_to_bcd.html)

---

## 🚀 Uso

### Crear el Proyecto en Vivado

#### Opción 1: Usar el script TCL desde Vivado GUI

1. Abrir **Vivado**
2. Seleccionar **Tools → Run Tcl Script**
3. Navegar a `scripts/lab.tcl` y ejecutarlo
4. El proyecto se creará automáticamente en `vivado/`

#### Opción 2: Ejecutar el script desde línea de comandos

```bash
# Desde el directorio del proyecto
vivado -mode batch -source scripts/lab.tcl
```

#### Opción 3: Ejecutar manualmente en la consola TCL de Vivado

1. Abrir Vivado
2. En la **TCL Console**, ejecutar:
   ```tcl
   source scripts/lab.tcl
   ```

### Simulación

#### Con Vivado

1. Abrir el proyecto: `vivado vivado/lab.xpr`
2. En Flow Navigator → Simulation → **Run Behavioral Simulation**
3. Observar las formas de onda generadas por el testbench

### Síntesis e Implementación

1. **Run Synthesis** - Sintetiza el diseño
2. **Run Implementation** - Implementa en el dispositivo target
3. **Generate Bitstream** - Genera el archivo `.bit`

### Programación de la Basys3

1. Conectar la placa Basys3 por USB
2. Abrir **Hardware Manager** en Vivado
3. Programar el dispositivo con el bitstream generado

### Operación en Hardware

1. Configurar el **multiplicando A** en switches SW[5:0] (valores de -32 a +31)
2. Configurar el **multiplicador B** en switches SW[13:8] (valores de -32 a +31)
3. Presionar botones **SEL[4:0]** para seleccionar el dígito a mostrar:
   - **btnR**: Unidades
   - **btnC**: Decenas
   - **btnL**: Centenas
   - **btnU**: Millares (signo)
4. Observar el resultado en el **display de 7 segmentos**

---

## 🔌 Mapeo de Hardware (Basys3)

### Entradas

| Señal    | Hardware      | Pines         | Descripción                |
|----------|---------------|---------------|----------------------------|
| `A[5:0]` | Switches 0-5  | SW5-SW0       | Multiplicando (operando A) |
| `B[5:0]` | Switches 13-8 | SW13-SW8      | Multiplicador (operando B) |
| `SEL[0]` | btnR          | Button Right  | Selector unidades          |
| `SEL[1]` | btnC          | Button Center | Selector decenas           |
| `SEL[2]` | btnL          | Button Left   | Selector centenas          |
| `SEL[3]` | btnU          | Button Up     | Selector millares (signo)  |
| `SEL[4]` | btnD          | Button Down   | (Reservado)                |

### Salidas

| Señal     | Hardware       | Descripción                          |
|-----------|----------------|--------------------------------------|
| `SS[6:0]` | Segmentos a-g  | Segmentos del display (cátodo común) |
| `AN[3:0]` | Ánodos AN3-AN0 | Control de displays (activo bajo)    |

**Ubicación de constraints**: [02_basys3_io.xdc](constraints/02_basys3_io.xdc)

---

## 📚 Documentación

### Archivos Principales

| Archivo                                                      | Descripción                        |
|--------------------------------------------------------------|------------------------------------|
| [rtl/lab2.vhd](rtl/lab2.vhd)                                 | Módulo principal del multiplicador |
| [rtl/doubledabble12b.vhd](rtl/doubledabble12b.vhd)           | Conversor BCD (Double-Dabble)      |
| [sim/lab2_tb.vhd](sim/lab2_tb.vhd)                           | Testbench para verificación        |
| [scripts/lab.tcl](scripts/lab.tcl)                           | Script de creación del proyecto    |
| [constraints/02_basys3_io.xdc](constraints/02_basys3_io.xdc) | Mapeo de pines I/O                 |
| [constraints/01_timing.xdc](constraints/01_timing.xdc)       | Restricciones de timing            |

### Detalles del Script TCL

El script `lab.tcl` realiza las siguientes operaciones:

1. **Crea el proyecto** en `vivado/` con dispositivo `xc7a35tcpg236-1` (Basys3)
2. **Configura el lenguaje** a VHDL para síntesis y simulación
3. **Añade archivos de diseño** desde `rtl/`
4. **Añade testbench** desde `sim/` como fileset de simulación
5. **Añade restricciones** desde `constraints/`
6. **Configura el proyecto** para síntesis e implementación

---

## 📋 Requisitos

### Hardware
- FPGA Xilinx Basys3
- Cable USB para programación

### Software
- Vivado Design Suite (2019.x o superior)
- ModelSim (opcional, para simulación)
- VHDL-93/2008 compatible

---

## 📝 Notas Importantes

⚠️ **Números con signo**: Los operandos A y B se interpretan como números con signo en complemento a 2 (rango -32 a +31).

⚠️ **Display de 7 segmentos**: El display utilizado es de **cátodo común**, donde los segmentos se activan con nivel alto ('1').

⚠️ **Multiplexación**: Aunque el diseño incluye 4 displays, la selección se realiza mediante botones (no hay multiplexación temporal automática).

⚠️ **Algoritmo BCD**: El conversor Double-Dabble es puramente combinacional y procesa los 12 bits del resultado.

---

## 👨‍🏫 Información del Curso

**Asignatura**: 30315 - Electrónica Digital (EDIG)
**Laboratorio**: Lab 2 - Multiplicador con Display BCD
**Plataforma**: Basys3 (Artix-7 XC7A35T)

---

*Última actualización: Febrero 2026*
