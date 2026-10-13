function integer clog2;
  input integer value;
  integer i;
  begin
    value = value - 1;
    for (i = 0; value > 0; i = i + 1)
      value = value >> 1;
    clog2 = i;
  end
endfunction
