# ==================================================================
# Script Tcl para Vivado - labs 30315 Part: xc7a35tcpg236-1 (Basys3)
# ==================================================================

# 0. Configuración básica
set script_dir [file dirname [info script]]

# 1. Crear proyecto y cambia a la carpeta del proyecto
create_project lab "$script_dir/../vivado" -part xc7a35tcpg236-1 -force
set project_dir [get_property DIRECTORY [current_project]]
cd $project_dir

# 2. Configuración del proyecto para trabajar con VHDL
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]

# 3. Añadir fuentes de diseño, situadas en la carpeta rtl
add_files [file normalize "$project_dir/../rtl"]

# 4. Añadir archivos de testbench, situados en la carpeta sim
add_files -fileset sim_1 [file normalize "$project_dir/../sim"]

# 5. Añadir archivos de restricciones, situados en la carpeta constraints
add_files -fileset constrs_1 [file normalize "$project_dir/../constraints"]

# 5.1 EL fichero de localizaciones no se usa en síntesis
set_property used_in_synthesis false [get_files  "$script_dir/../constraints/02_basys3_io.xdc"]
