target = "xilinx"
action = "synthesis"

syn_device = "xc3s250e"
syn_grade = "-4"
syn_package = "cp132"
syn_top = "tetris_top"
syn_project = "tetris.xise"
syn_tool = "ise"
top_module = "tetris_top"
incl_makefiles = [
"a.mk",
]

files = "tetris_top.ucf"

modules = {
  "local" : "../hdl"
}
