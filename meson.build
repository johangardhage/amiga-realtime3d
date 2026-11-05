project('amiga-realtime3d', meson_version: '>=0.56.0')

vasm = find_program('vasmm68k_mot')

vasm_args = [
  '-quiet',
  '-Fhunkexe',
  '-nosym',
  '-I', '@SOURCE_ROOT@/src/lib',
  '-I', '@SOURCE_ROOT@/include',
]

foreach n : ['01', '02', '03', '04', '05', '06', '07', '08', '09']
  name = 'Program_' + n
  custom_target(name,
    input: 'src' / name + '.s',
    output: name,
    depfile: name + '.d',
    command: [vasm, vasm_args, '-depend=make', '-depfile', '@DEPFILE@', '@INPUT@', '-o', '@OUTPUT@'],
    build_by_default: true,
  )
endforeach
