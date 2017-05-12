# README for Python implementation of variants of Dynamic Mode Decomposition

## folders
1. **dmdtools** folder contains implementation of variants of Dynamic Mode Decomposition  
2. **scripts** folder contains demos of various DMD algrithm  
3. **tests** folder contains tests for DMD class and kernel DMD class.

## implementations contained in **dmdtools** folder
1. **batch.py** implements Standard batch processed DMD (including total-least-squares) and Kernel DMD with polynomial kernel.  
2. **streaming.py** implements Streaming DMD.  
3. **online.py** implements online DMD (including weighted online DMD).  
4. **window.py** implements window DMD.  

## demostrations contained in **scripts** folder
1. **total_dmd_example.py** demostrates the use of DMD and total-least-squares DMD.  
2. **streaming_dmd_example.py** demostrates the use of Streaming DMD.  
3. **online_demo.py** demostrates the use of online DMD  
4. **window_demo.py** demostrates the use of window DMD  