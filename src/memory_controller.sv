/*

if (load)
    p_ram = read
    p_addr = {E, F}
elif (loadv)
    v_ram = read
    v_addr = {E, F}
elif (store)
    p_ram = write
    p_addr = {E, F}
    p_datain = {G, H}
elif (storev)
    v_ram = write
    v_addr = {E, F}
    v_datain = {G, H}
elif (peek)
    p_ram = read
    p_addr = paddr + 1
else
    p_ram = read
    v_ram = read
    
*/