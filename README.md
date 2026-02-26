# VATowiec

[VATowiec](http://vatowiec.pl) to darmowy program do księgowości, 
a jego działanie opiera się na plikach XBase (.dbf).

Program umożliwia eksport danych do różnych formatów, w szczególności XML — 
niezbędnego przy wysyłaniu plików JPK.

W tym repozytorum udostępniam moje zmiany lub poprawki w definicjach XML.

[!IMPORTANT]
Definicje te tworzę głównie dla siebie i nie daję żadnej gwarancji, 
że wygenerowane forumalarze będą prawidłowe dla innych form księgowania.

W szczególności mam tu na myśli dane które znajdują się w formularzach.

[!CAUTION]
Sam fakt, że wygenerowany formularz XML ma prawidłową składnię i przechodzi walidację nie oznacza, 
że jest on prawidłowy z punktu widzenia przepisów skarbowych!

VATowiec daje bardzo dużą dowolność w zakresie sposobu księgowania zdarzeń gospodarczych
i z pewnością nie jestem w stanie ogarnąć wszystkich.

Przed wysłaniem wygenerowanego pliku XML zawsze sprawdź jego zawartość pod kątem poprawności
merytorycznej!


## Instalacja

W zakładce [releases](https://github.com/Roslaniec/VATowiec/releases) 
anajdziesz repozytoria z kolejnymi wydaniami. 
Znajdź najnowszy, przykładowo JPK3.zip
W tym pliku będa trzy pliki: XML_RAP.dbf, XML_RW.dbf, XML_STR.dbf.
To są bazy danych które należy podmienić w VATowcu.

1. Zamknij program VATowiec

2. Umieść wypakowane pliki XML_*.dbf w katalogu **C:\BR\PROGRAMY\HELP** (nadpisując istniejące pliki)

3. Uruchom VATowca i wykonaj:
   System > Definicje XML
   Prawy przycisk myszy... Import
   Wybierz formularz: JPK_V7M_3 i/lub JPK_V7K_3... [ > ]... [ OK ]

4. Gotowe.

Jeżeli w przyszłości zrobisz dogrywkę, to definicje które zostały już zaimportowane nie znikną
z bieżącej bazy, tylko nie będziesz miał już możliwości importu tych moich definicji.
Aby je powtórnie zaimportować po dogrywce, musisz powtórnie wykonać operacje powyżej.
