{ inputs, ... }: {
  stripTrailingZeros = float:
  let
    s = toString float;
    # This regex captures the integer part and the decimal part up to the last nonzero digit
    match = builtins.match "([0-9]+\\.[0-9]*[1-9])0*$" s;
    result = if match != null then builtins.elemAt match 0 else
             # If it's all zeros after the dot, capture just the integer part
             (let intMatch = builtins.match "([0-9]+)\\.0*$" s;
              in if intMatch != null then builtins.elemAt intMatch 0 else s);
  in result;
}

