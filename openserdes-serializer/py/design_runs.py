
from subprocess import call
import shutil

periods = [8, 6, 4, 2, 1, 0.5]

for p in periods:
  obj_dir = f'{p}ns-build'
  p_actual = p # Single data rate
  call(['make', 'clean-build', f'OBJ_DIR={obj_dir}'])
  call(['make', 'par',         f'OBJ_DIR={obj_dir}',  f'SER_CLK_PERIOD={p_actual}'])
  shutil.move('hammer.log', f'{p}ns_hammer.log')