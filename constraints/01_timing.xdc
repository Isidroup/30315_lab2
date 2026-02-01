# --------------------------------------------------------------------------------
# Archivo: 01_timing.xdc
# Descripción: Restricciones temporales (Virtual Clock y I/O Delays)
# --------------------------------------------------------------------------------

# 1. Crear el Reloj Virtual
# Definimos un reloj de 40 MHz (25ns).
# NO se asocia a ningún puerto físico (no usamos [get_ports...]).
create_clock -name v_clk -period 25.0

# --------------------------------------------------------------------------
# 2. Restricciones de Entrada (Input Delay)
# --------------------------------------------------------------------------
# El diseño es combinacional. Indicamos que los datos (A, B, SEL) llegan
# 2ns después del flanco del reloj virtual.
set_input_delay -clock v_clk -max 2.0 [get_ports {A[*] B[*] SEL[*]}]
set_input_delay -clock v_clk -min 0.5 [get_ports {A[*] B[*] SEL[*]}]

# --------------------------------------------------------------------------
# 3. Restricciones de Salida (Output Delay)
# --------------------------------------------------------------------------
# Indicamos que las salidas (SS, AN) deben estar estables 1.5ns antes
# del siguiente flanco para cumplir con el setup del dispositivo externo.
set_output_delay -clock v_clk -max 1.5 [get_ports {SS[*] AN[*]}]
set_output_delay -clock v_clk -min 0.0 [get_ports {SS[*] AN[*]}]

# --------------------------------------------------------------------------
# NOTA SOBRE LAS CONDICIONES DE CONTORNO:
# Los valores asignados (2.0 ns de entrada, 1.5 ns de salida y 20 ns de periodo)
# se utilizan aquí como ejemplo ilustrativo. En una implementación real, estos
# parámetros dependen estrictamente de las condiciones de contorno físicas del
# sistema completo, tales como:
#   1. Las especificaciones de tiempo (Datasheets) de los chips externos.
#   2. La longitud y capacitancia de las pistas de la PCB (retardos de vuelo).
#   3. La frecuencia de operación requerida por el bus del sistema.
# --------------------------------------------------------------------------
