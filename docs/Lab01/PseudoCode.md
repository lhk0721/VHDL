# pseudo code

```vhdl
1. req <- 0;
    while (TRUE) do
2. wait until (ready = 1); -- data ready
3. data <- data_to_be_sent;
4. req <- not req; -- invert req value
5. wait until (ack = req);
end while;
```