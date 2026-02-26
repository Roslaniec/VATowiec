# dbf.pl

W VATowcu definicje XML można edytować w wewnętrznym edytorze,
jednak nie jest to rozwiązanie optymalne,
szczególnie w przypadku pracy nad większymi zmianami.

Aby uprościć pracę na plikach *.dbf* powstał skrypt `dbf.pl`,
który pozwala na:
- wykonywanie operacji SQL na bazie danych (np. SELECT, DELETE, itp),
- eksport danych do formatu CSV,
- import danych z formatu CSV.

Przykłady użycia:
```
./dbf.pl query 'select * from XML_STR where ADRES like "TEST\\%"'
./dbf.pl query 'delete from XML_STR where ADRES like "TEST\\%"'
./dbf.pl export 'select * from XML_STR where ADRES like "JPK_V7M_2\\%"' > jpk_v7m_2.csv
./dbf.pl import XML_STR ../VATowiec/jpk_v7m_3.STR.csv
```

# LibreOffice

Do pracy na plikach CSV używam LibreOffice.
LibreOffice (co może nie jest takie oczywiste) 
pozwala również na pracę bezpośrednio na plikach `.dbf`.
W szczególności chętnie używam tej możliwości do szybkiego podejrzenia zawartości pliku `.dbf`:
```
libreoffice --view --infilter="dBASE:25" XML_RAP.dbf
```
Parametr `--infilter` jest konieczny, ponieważ VATowiec używa strony kodowej **CP852**.

Do edycji plików *CSV* (wyeksportowanych przy pomocy `dbf.pl`) używam LibreOffice z takim parametrem:
```
libreoffice --infilter="CSV:44,34,25,1,1/2/2/2/3/2/4/2/5/2/6/2/7/2/8/2/9/2/10/2/11/2/12/2/13/2/14/2/15/2/16/2/17/2/18/2" jpk_v7k_3.csv
```
Ten skomplikowany parametr `--infilter` wymusza użycie strony kodowej **CP852** oraz zapewnia, 
że wszystkie kolumny są traktowane jako *TEXT*, dzięki czemu nie mamy problemu z różnymi 
automatycznymi konwersjami, które LibreOffice bardzo lubi robić
(przykładowo konwertuje pole do daty lub traktuje jako liczbę).
