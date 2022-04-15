# vhdl-cpu
A relatively simple CPU implemented in VHDL

## Microsequencer
### ctrlSignal Bit Fields
| Bit | Signal | Bit | Signal |
| --- | --- | --- | --- |
| 0 | ARINC | 11 | DRHBUS |
| 1 | PCINC | 12 | DRLBUS |
| 2 | ARLOAD | 13 | TRBUS |
| 3 | PCLOAD | 14 | RBUS |
| 4 | DRLOAD | 15 | ACBUS |
| 5 | TRLOAD | 16 | MEMBUS |
| 6 | IRLOAD | 17 | BUSMEM |
| 7 | RLOAD | 18 | READ |
| 8 | ACLOAD | 19 | WRITE |
| 9 | ZLOAD | 20-26 | ALUS[1:7] |
| 10 | PCBUS | |
