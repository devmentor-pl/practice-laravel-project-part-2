> :white_check_mark: *Jeśli będziesz mieć problem z rozwiązaniem tego zadania, poproś o pomoc na odpowiednim kanale na Slacku, tj. `s7e06-laravel-project-part-2` (dotyczy [mentee](https://devmentor.pl/mentoring/)) lub na ogólnodostępnej i bezpłatnej [społeczności na Discordzie](https://devmentor.pl/discord). Pamiętaj, aby treść Twojego wpisu spełniała [odpowiednie kryteria](https://devmentor.pl/jak-prosic-o-pomoc/).*

&nbsp;

# `#03` Laravel: Projekt cz. 2 (33-43)

Przenieś logikę tworzenia oraz edycji wydatku do osobnych klas akcji np. `CreateExpense` oraz `UpdateExpense`.

Wszystkie operacje na bazie danych wykonuj w [transakcji](https://laravel.com/docs/12.x/database#database-transactions). Akcja nie powinna korzystać z obiektu `Request` - przekaż jej jedynie zwalidowane dane. Kontroler ma jedynie wywołać akcję i przekierować użytkownika.

Przy edycji wydatku zsynchronizuj jego pozycje (dodane, zmienione, usunięte).

&nbsp;
> :no_entry: *Jeśli nie posiadasz materiałów do tego zadania tj. **Wideo**, znajdziesz je na stronie [laracasts.com](https://laracasts.com/referral/bogolubow)*

> :arrow_left: [*poprzednie zadanie*](./../02) | [*następne zadanie*](./../04) :arrow_right:
