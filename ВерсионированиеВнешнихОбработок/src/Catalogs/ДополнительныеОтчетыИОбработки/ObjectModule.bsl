
&После("ПриЗаписи")
Процедура ВерсВО_ПриЗаписи(Отказ)
	Если Не ОбменДанными.Загрузка Тогда
		ВерсВО_ОбщегоНазначения.ДобавитьОбработкуКВыгрузке(Ссылка, Ответственный);	
	КонецЕсли;
КонецПроцедуры
