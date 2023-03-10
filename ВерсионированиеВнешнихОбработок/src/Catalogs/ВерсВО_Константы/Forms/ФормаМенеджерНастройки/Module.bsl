
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДоступностьДалее();
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКЛокальномуРепозиториюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога; 
    ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим);     
    ДиалогОткрытия.Каталог = ""; 
    ДиалогОткрытия.МножественныйВыбор = Ложь; 
    ДиалогОткрытия.Заголовок = "Выберите каталог хранения локального гит репозитория."; 
    
    Если ДиалогОткрытия.Выбрать() И ЗначениеЗаполнено(ДиалогОткрытия.Каталог) Тогда 	
    	ПутьКЛокальномуРепозиторию = ДиалогОткрытия.Каталог;
    	АдресGitСервераПингНаСервере();
    	ПроверитьНаличиеГитНаСервере();
    	АвторизацияGitПроверкаНаСервере();
    	ДоступностьДалее();
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура Пароль1СПриИзменении(Элемент)
	
	ПроверкаАвторизацииПользователя1С();
	ДоступностьДалее();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьРеквизитыФормы();
	АдресGitСервераПингНаСервере();
	ПроверитьНаличиеГитНаСервере(); 
	ПроверкаАвторизацииПользователя1С();
	АвторизацияGitПроверкаНаСервере();
	
	Элементы.Далее.Доступность = СлужебныйГитЕсть И СлужебныйПингГитСервераУспешен;
	Элементы.Назад.Доступность = Ложь;
	Элементы.ДекорацияСтрокаПодключенияБД.Заголовок = "Сстрока подключения текущей БД: " + СтрокаСоединенияИнформационнойБазы();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ВерсВО_ОбщегоНазначения.ПолучитьДанныеНастроекВерсионирования());

КонецПроцедуры   

&НаСервере
Процедура ПроверкаАвторизацииПользователя1С()

	Если ЗначениеЗаполнено(Пользователь1С) И ЗначениеЗаполнено(Пароль1С) Тогда
		ПользовательИБ = Пользователи.СвойстваПользователяИБ(Пользователь1С.ИдентификаторПользователяИБ);
		СлужебныйАвторизация1СКорректна = Пользователи.СохраняемоеЗначениеСтрокиПароля(Пароль1С) = ПользовательИБ.СохраняемоеЗначениеПароля;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Пользователи.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Пользователи КАК Пользователи";
		
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		Если Не (ЗначениеЗаполнено(Пользователь1С) Или ЗначениеЗаполнено(Пароль1С)) И РезультатЗапроса.Количество() = 1 Тогда
			СлужебныйАвторизация1СКорректна = Истина;
		Иначе
			СлужебныйАвторизация1СКорректна = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если СлужебныйАвторизация1СКорректна Тогда
		Элементы.ДекорацияСтатусПроверкиПароля1С.Заголовок = "Данные авторизации 1С корректны.";
		Элементы.ДекорацияСтатусПроверкиПароля1С.ЦветТекста =  WebЦвета.Зеленый;
	Иначе
		Элементы.ДекорацияСтатусПроверкиПароля1С.Заголовок = "Данные авторизации 1С указаны неверно!";
		Элементы.ДекорацияСтатусПроверкиПароля1С.ЦветТекста =  WebЦвета.Красный; 
	КонецЕсли;

КонецПроцедуры

// Проверка Гит
&НаСервере
Процедура ПроверитьНаличиеГитНаСервере()
	
	СлужебныйГитЕсть = ВерсВО_ОбщегоНазначения.ПроверитьНаличиеГит();
	Если СлужебныйГитЕсть Тогда
		Элементы.ДекорацияСтатусНаличиеГит.Заголовок = "Гит установлен.";
		Элементы.ДекорацияСтатусНаличиеГит.ЦветТекста =  WebЦвета.Зеленый;
		Элементы.ПроверитьНаличиеГит.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияСтатусНаличиеГит.Заголовок = "Гит не обнаружен! Установите гит.";
		Элементы.ДекорацияСтатусНаличиеГит.ЦветТекста =  WebЦвета.Красный; 
		Элементы.ПроверитьНаличиеГит.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеГит(Команда)
	ПроверитьНаличиеГитНаСервере();
КонецПроцедуры


// Проверка пинг гит сервер
&НаСервере
Процедура АдресGitСервераПингНаСервере()
	
	Если ЗначениеЗаполнено(ТипGitСервера) И ЗначениеЗаполнено(АдресРепозиторияGit) Тогда
		СлужебныйПингГитСервераУспешен = ВерсВО_ОбщегоНазначения.ВыполнитьПинг(АдресРепозиторияGit);
		Если СлужебныйПингГитСервераУспешен Тогда
			Элементы.ДекорацияСтатусПингГитСервер.Заголовок = "Пинг сервера выполнен.";
			Элементы.ДекорацияСтатусПингГитСервер.ЦветТекста =  WebЦвета.Зеленый;
			Элементы.ПроверитьНаличиеГит.Видимость = Ложь;
		Иначе
			Элементы.ДекорацияСтатусПингГитСервер.Заголовок = "Пинг сервера не выполнен. Проверьте правильность введенного адреса.";
			Элементы.ДекорацияСтатусПингГитСервер.ЦветТекста =  WebЦвета.Красный; 
			Элементы.ПроверитьНаличиеГит.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресGitСервераПриИзменении(Элемент)
	АдресGitСервераПингНаСервере();
	ДоступностьДалее();
	ДоступностьГотово();
КонецПроцедуры


// Тип и проверка авторизации гит сервер
&НаСервере
Процедура ТипАвторизацииGitПриИзмененииНаСервере()
	
	Элементы.SshGit.Видимость = Ложь;
	Элементы.ТокенGit.Видимость = Ложь;
	Элементы.ПарольGit.Видимость = Ложь;
	
	Если ТипАвторизацииGit = Перечисления.ВерсВО_ТипАвторизацииGit.SSH Тогда
		Элементы.SshGit.Видимость = Истина;
	ИначеЕсли ТипАвторизацииGit = Перечисления.ВерсВО_ТипАвторизацииGit.Токен Тогда
		Элементы.ТокенGit.Видимость = Истина;
	ИначеЕсли ТипАвторизацииGit = Перечисления.ВерсВО_ТипАвторизацииGit.ЛогинПароль Тогда
		Элементы.ПарольGit.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипАвторизацииGitПриИзменении(Элемент)
	
	ТипАвторизацииGitПриИзмененииНаСервере();
	АвторизацияGitПроверкаНаСервере();
	ДоступностьДалее();
	ДоступностьГотово();
	
КонецПроцедуры

&НаСервере
Процедура АвторизацияGitПроверкаНаСервере() 
	
	Если ЗначениеЗаполнено(ТипАвторизацииGit) И ЗначениеЗаполнено(EmailGit) И ЗначениеЗаполнено(ЛогинGit) Тогда
		СтруктураАвторизации = Новый Структура;
		ДанныеЗаполнены = Истина;
		Если ТипАвторизацииGit = Перечисления.ВерсВО_ТипАвторизацииGit.Токен Тогда
			Если Не ЗначениеЗаполнено(ТокенGit) Тогда
				ДанныеЗаполнены = Ложь;	
			КонецЕсли;
			СтруктураАвторизации.Вставить("Токен", ТокенGit);	
		ИначеЕсли ТипАвторизацииGit = Перечисления.ВерсВО_ТипАвторизацииGit.ЛогинПароль Тогда
			Если Не ЗначениеЗаполнено(ЛогинGit) Или Не ЗначениеЗаполнено(ПарольGit) Тогда
				ДанныеЗаполнены = Ложь;	
			КонецЕсли;
			СтруктураАвторизации.Вставить("Логин", ЛогинGit);
			СтруктураАвторизации.Вставить("Пароль", ПарольGit);	
		КонецЕсли;
		Если ДанныеЗаполнены Тогда 
			СлужебныйДанныеХранилища = СведенияОРепозиторииПоДаннымФормы();
			СлужебныйАвторизацияГитКорректна = СлужебныйДанныеХранилища.АвторизацияУспешна;
		КонецЕсли;
	КонецЕсли;
	
	Если СлужебныйАвторизацияГитКорректна Тогда
		Элементы.ДекорацияСтатусПроверкиАвторизации.Заголовок = "Авторизация выполнена.";
		Элементы.ДекорацияСтатусПроверкиАвторизации.ЦветТекста =  WebЦвета.Зеленый;
	Иначе 
		Элементы.ДекорацияСтатусПроверкиАвторизации.Заголовок = "Авторизация не выполнена! Проверьте правильность введенных данных!";
		Элементы.ДекорацияСтатусПроверкиАвторизации.ЦветТекста =  WebЦвета.Красный; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияGitПриИзменении(Элемент)
	АвторизацияGitПроверкаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьДалее()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаВыборГитСервера" Тогда
		Элементы.Далее.Доступность = СлужебныйГитЕсть И СлужебныйПингГитСервераУспешен И ЗначениеЗаполнено(ПутьКЛокальномуРепозиторию);
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаНастройкаАвторизации" Тогда
		Элементы.Далее.Доступность = СлужебныйАвторизация1СКорректна И СлужебныйАвторизацияГитКорректна;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьГотово()
	
	Элементы.Готово.Доступность = СлужебныйГитЕсть И СлужебныйПингГитСервераУспешен И СлужебныйАвторизация1СКорректна И СлужебныйАвторизацияГитКорректна
	И ЗначениеЗаполнено(ИдентификаторХранилища) И ЗначениеЗаполнено(СтрокаПодключенияМастерБД);
	ВключитьВерсионирование = Элементы.Готово.Доступность;
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьЗаполнениеДополнительныхНастроек()
	
	Элементы.ИдентификаторХранилища.СписокВыбора.Очистить();
	Если СлужебныйДанныеХранилища.Пустой Тогда
		СинхронизироватьСтруктуруСправочника = Истина;
	Иначе
		Для Каждого Хранилище Из СлужебныйДанныеХранилища.СписокХранилищ Цикл
			Элементы.ИдентификаторХранилища.СписокВыбора.Добавить(Хранилище.name);	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьНовыйИдентификаторХранилища()
	
	Возврат ВерсВО_ОбщегоНазначения.ПолучитьНовыйИдентификаторХранилища();
	
КонецФункции

&НаКлиенте
Процедура ПервичнаяВыгрузкаСправочникаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		
		ПараметрыЗапуска = Новый Структура;
		ПараметрыЗапуска.Вставить("ПутьКЛокальномуРепозиторию", СлужебныйДанныеХранилища.ПутьКВременномуКаталогу);
		
		СтруктураФоновогоЗадания = ВерсВО_ОбщегоНазначения.ПервичнаяВыгрузкаСправочникаОбработокВФоне(ПараметрыЗапуска, УникальныйИдентификатор);
		ИДЗадания 	= СтруктураФоновогоЗадания.ИдентификаторЗадания;
		
		ПараметрыОжидания  = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.Интервал  = 2;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(СтруктураФоновогоЗадания, Новый ОписаниеОповещения("ПервичнаяВыгрузкаСправочникаОбработокВФонеЗавершение", ЭтотОбъект), ПараметрыОжидания);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПервичнаяВыгрузкаСправочникаОбработокВФонеЗавершение(Результат, Параметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторХранилищаПриИзменении(Элемент)
	
	Элементы.СтрокаПодключенияМастерБД.Доступность = Истина;
	Для Каждого Хранилище Из СлужебныйДанныеХранилища.СписокХранилищ Цикл
		Если Хранилище.name = ИдентификаторХранилища Тогда
			СтрокаПодключенияМастерБД = Хранилище.masterDataBase;
			Элементы.СтрокаПодключенияМастерБД.Доступность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ДоступностьГотово();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПодключенияМастерБДПриИзменении(Элемент)
	
	ДоступностьГотово();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовоеХранилище(Команда)
	
	СтрокаПодключенияМастерБД = СтрокаСоединенияИнформационнойБазы();
	ИдентификаторХранилища = ПолучитьНовыйИдентификаторХранилища();
	Элементы.ИдентификаторХранилища.СписокВыбора.Добавить(ИдентификаторХранилища);
	СлужебныйНовоеХранилище = Истина;
	
	ДоступностьГотово();

КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Элементы.Назад.Доступность = Истина;
	Элементы.Далее.Доступность = Истина;
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаВыборГитСервера" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаНастройкаАвторизации;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаНастройкаАвторизации" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаДополнительныеНастройки;
		ВыполнитьЗаполнениеДополнительныхНастроек();
		Элементы.Далее.Доступность = Ложь;
	КонецЕсли;
	
	ДоступностьДалее();
	ДоступностьГотово();
	
КонецПроцедуры 

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.Далее.Доступность = Истина;
	Элементы.Назад.Доступность = Истина;
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаДополнительныеНастройки" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаНастройкаАвторизации;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСтраницаНастройкаАвторизации" Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаВыборГитСервера;
		Элементы.Назад.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ГотовоНаСервере()
	
	СтруктураНастроек = ВерсВО_ОбщегоНазначения.ПолучитьСтруктуруКонстант();
	Для Каждого Настройка Из СтруктураНастроек Цикл
		СсылкаНаНастройку = Справочники.ВерсВО_Константы.НайтиПоНаименованию(Настройка.Ключ); 
		Если ЗначениеЗаполнено(СсылкаНаНастройку) Тогда
			НастройкаОбъект = СсылкаНаНастройку.ПолучитьОбъект();
		Иначе
			НастройкаОбъект = Справочники.ВерсВО_Константы.СоздатьЭлемент();
		КонецЕсли;
		
		НастройкаОбъект.Наименование = Настройка.Ключ;
		НастройкаОбъект.Значение = ЭтаФорма[Настройка.Ключ];
		
		НастройкаОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ГотовоНаСервере();
	Если СлужебныйНовоеХранилище Тогда
		ОписаниеОповещенияВыгрузитьПервично = Новый ОписаниеОповещения("ПервичнаяВыгрузкаСправочникаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияВыгрузитьПервично, "Вы создаете новое хранилище. Выполнить выгрузку справочника обработок?", РежимДиалогаВопрос.ДаНет);
	КонецЕсли;

КонецПроцедуры

Функция СведенияОРепозиторииПоДаннымФормы() Экспорт

	СтруктураДанныеНастроек = Новый Структура;
	СтруктураДанныеНастроек.Вставить("ТипGitСервера", ТипGitСервера);
	СтруктураДанныеНастроек.Вставить("ТипGitСервера", ТипАвторизацииGit);
	
	СтруктураАвторизации = Новый Структура;
	СтруктураАвторизации.Вставить("Токен", ТокенGit);
	СтруктураАвторизации.Вставить("Логин", ЛогинGit);
	СтруктураАвторизации.Вставить("Пароль", ПарольGit);

	Возврат ВерсВО_ОбщегоНазначения.ПолучитьСведенияОРепозитории(
		СтруктураДанныеНастроек, 
		АдресРепозиторияGit, 
		ПутьКЛокальномуРепозиторию, 
		СтруктураАвторизации);
	
КонецФункции

