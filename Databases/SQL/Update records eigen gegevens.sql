update tablenaam set column1 = column2 where column1 like '%tekst%'
update tablenaam set column1 = REPLACE(column1,' tekst1','') where column1 like '%tekst2%'
