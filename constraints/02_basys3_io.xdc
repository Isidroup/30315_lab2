# --------------------------------------------------------------------------------
# Archivo: 02_basys3_io.xdc
# Descripción: Asignación de pines y configuración de voltaje para Basys3
# --------------------------------------------------------------------------------

## Switches (Entradas A y B)
set_property PACKAGE_PIN V17 [get_ports {A[0]}]; # sw0
##    >>TODO: Completar la asignación de pines para los demás switches A[1]..A[5], B[0]..B[5]

## Buttons (Selectores display)
set_property PACKAGE_PIN T17  [get_ports {SEL[0]}]; # btnR
##    >>TODO: Completar la asignación de pines para los demás botones SEL[1]..SEL[2]

##7 Segment Display Outputs (Salidas SS, AN)
set_property PACKAGE_PIN W7    [get_ports {SS[6]}];
##    >>TODO: Completar la asignación de pines para las demás salidas SS[0]..SS[5] y AN[0]..AN[3]




# --------------------------------------------------------------------------
# Configuración Eléctrica y de Dispositivo
# --------------------------------------------------------------------------

# Estándar I/O: Aplicamos LVCMOS33 a todos los puertos
# Configuración para Entradas (Switches y Botones)
set_property IOSTANDARD LVCMOS33 [get_ports {A[*] B[*] SEL[*]}]
# Configuración para Salidas (LEDs)
set_property IOSTANDARD LVCMOS33 [get_ports {SS[*] AN[*]}]

# Configuración de compresión de Bitstream y Voltaje de Bancos
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# --------------------------------------------------------------------------
# NOTA SOBRE LA ASIGNACIÓN DE PINES:
# La asignación de pines y la configuración eléctrica aquí definidas
# están específicamente adaptadas para la placa Basys3. Al utilizar
# una FPGA diferente o una placa distinta, es necesario consultar la
# documentación del fabricante para asegurar una asignación correcta
# de pines y una configuración adecuada de los estándares eléctricos.
